using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

using Pet_Shop.Data;             // DbContext
using Pet_Shop.Models.Entities;  // Product, Order, etc.

namespace Pet_Shop.Services
{
    /// <summary>
    /// Calls the external Python Pet Shop Recommendation API
    /// (item-kNN + TF-IDF + Hybrid) and applies species-aware filtering
    /// with ratio matching based on the user's recent clicks or cart.
    /// </summary>
    public class LocalRecommendationService
    {
        private readonly HttpClient _http;
        private readonly ILogger<LocalRecommendationService> _logger;
        private readonly PetShopDbContext _db;

        private readonly string _baseUrl;

        public LocalRecommendationService(
            HttpClient http,
            IConfiguration config,
            PetShopDbContext db,
            ILogger<LocalRecommendationService> logger)
        {
            _http = http;
            _db = db;
            _logger = logger;
            _baseUrl = config["RecommendationApi:BaseUrl"] ?? "http://localhost:8081";
        }

        // =========================================================
        // 0) HEALTH
        // =========================================================
        public async Task<bool> IsApiAvailableAsync()
        {
            try
            {
                using var response = await _http.GetAsync($"{_baseUrl}/health");
                if (!response.IsSuccessStatusCode) return false;

                var health = await response.Content.ReadFromJsonAsync<HealthResponseDto>();
                return health != null && ((health.status?.Equals("healthy", StringComparison.OrdinalIgnoreCase) ?? false) || health.models_loaded);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "[REC] Health check failed.");
                return false;
            }
        }

        // =========================================================
        // 1) CLICK-BASED LIVE (GetAIRecsLive should call this)
        //    Ratio = Cat/Dog ratio from clicked codes (or cart fallback)
        // =========================================================
        public async Task<List<Product>> GetLiveRecommendationsFromClickedCodesAsync(
            int userId,
            IEnumerable<string>? clickedCodes,
            int maxItems = 8)
        {
            var clicks = (clickedCodes ?? Enumerable.Empty<string>())
                .Where(s => !string.IsNullOrWhiteSpace(s))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            _logger.LogInformation("[REC/LIVE] Incoming ClickedCodes: {Count} → {Codes}", clicks.Count, string.Join(", ", clicks));

            // Map clicked codes → products to infer species ratio
            var clickedProducts = new List<Product>();
            if (clicks.Any())
            {
                clickedProducts = await _db.Products
                    .Include(p => p.ProductImages)
                    .Where(p => p.ProductCode != null && clicks.Contains(p.ProductCode))
                    .ToListAsync();
            }

            if (!clickedProducts.Any())
            {
                _logger.LogInformation("[REC/LIVE] No valid clicked products. Fallback to history-based.");
                return await GetUserRecommendationsAsync(userId, maxItems);
            }

            // Species ratio from clicks
            var (catCount, dogCount, unkCount) = CountSpecies(clickedProducts);
            var totalAnimals = catCount + dogCount;

            _logger.LogInformation("[REC/LIVE] CLICK SPECIES COUNT → Cat={Cat}, Dog={Dog}, Unknown={Unknown}", catCount, dogCount, unkCount);

            bool enforceRatio = totalAnimals > 0;

            // Call Python (mode=click)
            var reqBody = new RecommendationRequestDto
            {
                mode = "click",
                user_id = userId > 0 ? userId.ToString() : "guest",
                clicked_item_keys = clicks,
                click_weights = null,
                // ask a lot to allow ratio selection while preserving Python order
                k = Math.Max(48, maxItems * 6)
            };

            RecommendationApiResponseDto? apiResp;
            try
            {
                using var response = await _http.PostAsJsonAsync($"{_baseUrl}/recommend", reqBody);
                response.EnsureSuccessStatusCode();
                apiResp = await response.Content.ReadFromJsonAsync<RecommendationApiResponseDto>();
                if (apiResp == null || !apiResp.success)
                {
                    _logger.LogWarning("[REC/LIVE] Python /recommend returned null/failed.");
                    return new List<Product>();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "[REC/LIVE] Error calling Python /recommend (mode=click).");
                return new List<Product>();
            }

            var keysInOrder = apiResp.recommendations
                .Select(r => r.item_key)
                .Where(k => !string.IsNullOrWhiteSpace(k))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            _logger.LogInformation("[REC/LIVE] Python returned {N} keys (distinct).", keysInOrder.Count);

            if (!keysInOrder.Any()) return new List<Product>();

            var products = await _db.Products
                .Include(p => p.ProductImages)
                .Where(p => p.ProductCode != null && keysInOrder.Contains(p.ProductCode))
                .ToListAsync();

            var orderIndex = keysInOrder
                .Select((k, i) => new { k, i })
                .ToDictionary(x => x.k, x => x.i, StringComparer.OrdinalIgnoreCase);

            // Keep Python order, remove any item already clicked (optional)
            var candidates = products
                .Where(p => p.ProductCode != null && !clicks.Contains(p.ProductCode))
                .OrderBy(p => orderIndex.TryGetValue(p.ProductCode!, out var i) ? i : int.MaxValue)
                .ToList();

            if (!enforceRatio)
            {
                _logger.LogInformation("[REC/LIVE] No Cat/Dog signal in clicks → returning top {K} in Python order.", maxItems);
                return candidates.Take(maxItems).ToList();
            }

            // Enforce ratio (Cat/Dog) according to clicks
            double catRatio = (double)catCount / (double)totalAnimals;
            double dogRatio = (double)dogCount / (double)totalAnimals;

            int targetCat = (int)Math.Round(catRatio * maxItems);
            int targetDog = (int)Math.Round(dogRatio * maxItems);

            // Adjust rounding to hit exactly maxItems
            int adjust = (targetCat + targetDog) - maxItems;
            if (adjust != 0)
            {
                if (adjust > 0)
                {
                    if (targetCat >= targetDog) targetCat -= adjust;
                    else targetDog -= adjust;
                }
                else // adjust < 0
                {
                    if (catRatio >= dogRatio) targetCat += -adjust;
                    else targetDog += -adjust;
                }
            }

            _logger.LogInformation("[REC/LIVE] Ratio targets for maxItems={Max} → Cat={TCat}, Dog={TDog} (CatRatio={CR:P1}, DogRatio={DR:P1})",
                maxItems, targetCat, targetDog, catRatio, dogRatio);

            // Partition candidates by species (still Python order)
            var catCands = new List<Product>();
            var dogCands = new List<Product>();
            var unkCands = new List<Product>();

            foreach (var p in candidates)
            {
                var s = DetectSpecies(p);
                switch (s)
                {
                    case Species.Cat: catCands.Add(p); break;
                    case Species.Dog: dogCands.Add(p); break;
                    default: unkCands.Add(p); break;
                }
            }

            _logger.LogInformation("[REC/LIVE] Candidate split → Cat={CatCnt}, Dog={DogCnt}, Unknown={UnkCnt}",
                catCands.Count, dogCands.Count, unkCands.Count);

            var selected = new List<Product>();
            selected.AddRange(catCands.Take(targetCat));
            selected.AddRange(dogCands.Take(targetDog));

            // If shortage in either bucket, fill respecting ratio preference first
            int remaining = maxItems - selected.Count;
            if (remaining > 0)
            {
                int shortCat = Math.Max(0, targetCat - selected.Count(p => DetectSpecies(p) == Species.Cat));
                int shortDog = Math.Max(0, targetDog - selected.Count(p => DetectSpecies(p) == Species.Dog));

                if (shortCat > 0)
                {
                    var extraCats = catCands.Skip(selected.Count(p => DetectSpecies(p) == Species.Cat)).Take(shortCat);
                    foreach (var e in extraCats)
                    {
                        if (selected.Count >= maxItems) break;
                        if (!selected.Contains(e)) selected.Add(e);
                    }
                }
                if (shortDog > 0)
                {
                    var extraDogs = dogCands.Skip(selected.Count(p => DetectSpecies(p) == Species.Dog)).Take(shortDog);
                    foreach (var e in extraDogs)
                    {
                        if (selected.Count >= maxItems) break;
                        if (!selected.Contains(e)) selected.Add(e);
                    }
                }

                remaining = maxItems - selected.Count;
                if (remaining > 0)
                {
                    foreach (var e in catCands)
                    {
                        if (selected.Count >= maxItems) break;
                        if (!selected.Contains(e)) selected.Add(e);
                    }
                    foreach (var e in dogCands)
                    {
                        if (selected.Count >= maxItems) break;
                        if (!selected.Contains(e)) selected.Add(e);
                    }
                    foreach (var e in unkCands)
                    {
                        if (selected.Count >= maxItems) break;
                        if (!selected.Contains(e)) selected.Add(e);
                    }
                }
            }

            _logger.LogInformation("[REC/LIVE] Selected {Count} items. Final mix → Cat={CatSel}, Dog={DogSel}, Unknown={UnkSel}",
                selected.Count,
                selected.Count(p => DetectSpecies(p) == Species.Cat),
                selected.Count(p => DetectSpecies(p) == Species.Dog),
                selected.Count(p => DetectSpecies(p) == Species.Unknown));

            foreach (var p in selected)
            {
                _logger.LogInformation("[REC/LIVE] PICKED: {Id} {Code} {Name} → {Species}",
                    p.ProductID, p.ProductCode, p.ProductName, DetectSpecies(p));
            }

            return selected.Take(maxItems).ToList();
        }

        // =========================================================
        // 2) User-based
        // =========================================================
        public async Task<List<Product>> GetUserRecommendationsAsync(
            int customerId,
            int maxItems = 8)
        {
            var result = new List<Product>();
            if (customerId <= 0) return result;

            // Demo history (scope to actual user if needed)
            var historyKeysRaw = await _db.Orders
                .SelectMany(o => o.OrderItems)
                .Select(oi => oi.Product.ProductCode)
                .ToListAsync();

            var historyKeys = historyKeysRaw
                .Where(k => !string.IsNullOrWhiteSpace(k))
                .Select(k => k!)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            if (!historyKeys.Any()) return result;

            var reqBody = new RecommendationRequestDto
            {
                mode = "user",
                user_id = customerId.ToString(),
                history_item_keys = historyKeys,
                k = Math.Max(8, maxItems * 2)
            };

            RecommendationApiResponseDto? apiResp;
            try
            {
                using var response = await _http.PostAsJsonAsync($"{_baseUrl}/recommend", reqBody);
                response.EnsureSuccessStatusCode();
                apiResp = await response.Content.ReadFromJsonAsync<RecommendationApiResponseDto>();
                if (apiResp == null || !apiResp.success) return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "[REC/USER] error calling Python /recommend (mode=user).");
                return result;
            }

            var keysInOrder = apiResp.recommendations
                .Select(r => r.item_key)
                .Where(k => !string.IsNullOrWhiteSpace(k))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            var products = await _db.Products
                .Include(p => p.ProductImages)
                .Where(p => p.ProductCode != null && keysInOrder.Contains(p.ProductCode))
                .ToListAsync();

            var byKey = products.ToDictionary(p => p.ProductCode!, p => p, StringComparer.OrdinalIgnoreCase);

            foreach (var key in keysInOrder)
            {
                if (byKey.TryGetValue(key, out var prod))
                {
                    result.Add(prod);
                    if (result.Count >= maxItems) break;
                }
            }
            return result;
        }

        // =========================================================
        // 3) Text-based (single definition)
        // =========================================================
        public async Task<List<Product>> GetTextRecommendationsAsync(string query, int maxItems = 8)
        {
            var result = new List<Product>();
            if (string.IsNullOrWhiteSpace(query)) return result;

            var reqBody = new RecommendationRequestDto
            {
                mode = "text",
                text_query = query,
                k = Math.Max(8, maxItems * 2)
            };

            RecommendationApiResponseDto? apiResp;
            try
            {
                using var response = await _http.PostAsJsonAsync($"{_baseUrl}/recommend", reqBody);
                response.EnsureSuccessStatusCode();

                apiResp = await response.Content.ReadFromJsonAsync<RecommendationApiResponseDto>();
                if (apiResp == null || !apiResp.success)
                {
                    _logger.LogWarning("Python recommender returned no/failed response for text query '{Query}'", query);
                    return result;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calling Python /recommend (mode=text) for query {Query}", query);
                return result;
            }

            var keysInOrder = apiResp.recommendations
                .Select(r => r.item_key)
                .Where(k => !string.IsNullOrWhiteSpace(k))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            if (!keysInOrder.Any()) return result;

            var products = await _db.Products
                .Include(p => p.ProductImages)
                .Where(p => p.ProductCode != null && keysInOrder.Contains(p.ProductCode))
                .ToListAsync();

            // Keep Python order, take maxItems
            var byKey = products.ToDictionary(p => p.ProductCode!, p => p, StringComparer.OrdinalIgnoreCase);
            foreach (var key in keysInOrder)
            {
                if (byKey.TryGetValue(key, out var prod))
                {
                    result.Add(prod);
                    if (result.Count >= maxItems) break;
                }
            }
            return result;
        }

        // ==========================
        // 8) CONTENT-BASED (wrapper)
        // ==========================
        public async Task<List<Product>> GetContentBasedRecommendationsAsync(params object[] args)
        {
            string query = (args != null && args.Length > 0 && args[0] != null)
                ? args[0].ToString() ?? string.Empty
                : string.Empty;

            if (string.IsNullOrWhiteSpace(query))
                return new List<Product>();

            return await GetTextRecommendationsAsync(query, 8);
        }

        // ==========================
        // 5) Wrapper for HomeController
        // ==========================
        public async Task<List<Product>> GetRecommendedProductsAsync(int userId, int maxItems = 8)
        {
            if (userId > 0)
                return await GetUserRecommendationsAsync(userId, maxItems);

            // Guest user → no history-based recs from Python
            return new List<Product>();
        }

        // ==========================
        // 6) Overloads (compat)
        // ==========================
        public Task<List<Product>> GetRecommendedProductsAsync(
            int userId, int maxItems, IEnumerable<int>? cartProductIds)
            => GetRecommendedProductsInternalAsync(userId, maxItems, cartProductIds);

        public Task<List<Product>> GetRecommendedProductsAsync(
            int userId, IEnumerable<int>? cartProductIds, int maxItems)
            => GetRecommendedProductsInternalAsync(userId, maxItems, cartProductIds);

        private async Task<List<Product>> GetRecommendedProductsInternalAsync(
            int userId, int maxItems, IEnumerable<int>? cartProductIds)
        {
            if (cartProductIds != null && cartProductIds.Any())
                return await GetCartBasedRecommendationsAsync(userId, cartProductIds, maxItems);

            return await GetUserRecommendationsAsync(userId, maxItems);
        }

        // ==========================
        // 7) Backwards-compatible names
        // ==========================
        public Task<List<Product>> GetClickBasedRecommendationsAsync(
            int customerId, IEnumerable<int> cartProductIds, int maxItems = 8)
            => GetCartBasedRecommendationsAsync(customerId, cartProductIds, maxItems);

        public Task<List<Product>> GetTextBasedRecommendationsAsync(string query, int maxItems = 8)
            => GetTextRecommendationsAsync(query, maxItems);

        // =====================================================================
        // ------------------------ Species helpers -----------------------------
        // =====================================================================

        private enum Species { Unknown = 0, Cat = 1, Dog = 2 }

        /// <summary>
        /// Remove Vietnamese diacritics to make matching robust:
        /// "mèo/chó" → "meo/cho"
        /// </summary>
        private static string StripDiacritics(string? s)
        {
            if (string.IsNullOrWhiteSpace(s)) return string.Empty;
            var norm = s.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder(norm.Length);
            foreach (var ch in norm)
            {
                var uc = CharUnicodeInfo.GetUnicodeCategory(ch);
                if (uc != UnicodeCategory.NonSpacingMark)
                    sb.Append(char.ToLowerInvariant(ch));
            }
            return sb.ToString().Normalize(NormalizationForm.FormC);
        }

        /// <summary>
        /// Detect species keywords in raw text (Vietnamese + English).
        /// Reads name/code/description (explicitly includes description).
        /// </summary>
        private static Species DetectSpeciesFromText(string? text)
        {
            if (string.IsNullOrWhiteSpace(text)) return Species.Unknown;

            var t0 = text.ToLowerInvariant();
            var t = StripDiacritics(text);

            string[] catWords =
            {
                "mèo","meo","cat","kitten","feline","whiskas","felix","pate mèo","pate meo",
                "catnip","litter","cat-food","cat food","rc-kitten","royal canin kitten",
                "acana cat","orijen cat","dem0-cat","demo-cat","cat-acc","cat-toy","cat-litter"
            };

            string[] dogWords =
            {
                "chó","cho","dog","puppy","canine","xích chó","day dat","dây dắt","leash","collar",
                "dog-food","dog food","pedigree","royal canin dog","orijen dog","dem0-dog","demo-dog","dog-acc"
            };

            bool hasCat = catWords.Any(w => t0.Contains(w) || t.Contains(w));
            bool hasDog = dogWords.Any(w => t0.Contains(w) || t.Contains(w));

            if (hasCat && !hasDog) return Species.Cat;
            if (hasDog && !hasCat) return Species.Dog;
            return Species.Unknown;
        }

        /// <summary>
        /// Detect species from a Product by concatenating fields.
        /// Priority: PetType → ProductCode prefix → keywords.
        /// </summary>
        private static Species DetectSpecies(Product p)
        {
            var petType = p.PetType?.Trim();
            if (!string.IsNullOrEmpty(petType))
            {
                var pet = petType.ToLowerInvariant();
                if (pet.Contains("cat")) return Species.Cat;
                if (pet.Contains("mèo") || StripDiacritics(pet).Contains("meo")) return Species.Cat;
                if (pet.Contains("dog") || pet.Contains("chó") || StripDiacritics(pet).Contains("cho")) return Species.Dog;
            }

            var code = p.ProductCode ?? string.Empty;
            var codeL = code.ToLowerInvariant();
            if (codeL.StartsWith("demo-cat-") || codeL.StartsWith("cat-")) return Species.Cat;
            if (codeL.StartsWith("demo-dog-") || codeL.StartsWith("dog-")) return Species.Dog;

            var blob = $"{p.ProductName} {p.ShortDescription} {p.Description} {p.ProductCode}";
            return DetectSpeciesFromText(blob);
        }

        private static (int cat, int dog, int unk) CountSpecies(IEnumerable<Product> prods)
        {
            int cats = 0, dogs = 0, unk = 0;
            foreach (var p in prods)
            {
                var s = DetectSpecies(p);
                if (s == Species.Cat) cats++;
                else if (s == Species.Dog) dogs++;
                else unk++;
            }
            return (cats, dogs, unk);
        }

        /// <summary>
        /// Majority vote across products (cart intent).
        /// </summary>
        private static Species DominantSpecies(IEnumerable<Product> prods)
        {
            int cats = 0, dogs = 0;
            foreach (var p in prods)
            {
                var s = DetectSpecies(p);
                if (s == Species.Cat) cats++;
                else if (s == Species.Dog) dogs++;
            }
            if (cats == 0 && dogs == 0) return Species.Unknown;
            return (cats >= dogs) ? Species.Cat : Species.Dog;
        }

        // =====================================================================
        // --------------------------- DTOs ------------------------------------
        // =====================================================================

        private sealed class HealthResponseDto
        {
            public string? status { get; set; }
            public bool models_loaded { get; set; }
            public int n_items { get; set; }
            public bool item_only_loaded { get; set; }
        }

        private sealed class RecommendationRequestDto
        {
            public string mode { get; set; } = "user"; // "user" | "click" | "text"
            public string? user_id { get; set; }
            public List<string>? history_item_keys { get; set; }
            public List<string>? clicked_item_keys { get; set; }
            public List<float>? click_weights { get; set; }
            public string? text_query { get; set; }
            public int k { get; set; } = 8;
        }

        private sealed class RecommendationApiResponseDto
        {
            public bool success { get; set; }
            public List<RecItem> recommendations { get; set; } = new();
            public sealed class RecItem
            {
                public string item_key { get; set; } = "";
                public double score { get; set; }
            }
        }

        // ==========================
        // 2) CART-BASED (strict species filter + fill; returns 8)
        // ==========================
        public async Task<List<Product>> GetCartBasedRecommendationsAsync(
            int customerId,
            IEnumerable<int> cartProductIds,
            int maxItems = 8)
        {
            var result = new List<Product>();
            var cartIds = cartProductIds?.Distinct().ToList() ?? new List<int>();
            if (!cartIds.Any())
                return await GetUserRecommendationsAsync(customerId, maxItems);

            // Load cart products to infer intent + map to item keys
            var cartProducts = await _db.Products
                .Include(p => p.ProductImages)
                .Where(p => cartIds.Contains(p.ProductID))
                .ToListAsync();

            var cartKeys = cartProducts
                .Select(p => p.ProductCode)
                .Where(k => !string.IsNullOrWhiteSpace(k))
                .Select(k => k!)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            if (!cartKeys.Any())
                return await GetUserRecommendationsAsync(customerId, maxItems);

            var intent = DominantSpecies(cartProducts);

            var reqBody = new RecommendationRequestDto
            {
                mode = "click",
                user_id = customerId.ToString(),
                clicked_item_keys = cartKeys,
                click_weights = null,
                k = Math.Max(28, maxItems * 6)
            };

            RecommendationApiResponseDto? apiResp;
            try
            {
                using var response = await _http.PostAsJsonAsync($"{_baseUrl}/recommend", reqBody);
                response.EnsureSuccessStatusCode();
                apiResp = await response.Content.ReadFromJsonAsync<RecommendationApiResponseDto>();
                if (apiResp == null || !apiResp.success) return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calling Python /recommend (mode=click) for customer {CustomerId}", customerId);
                return result;
            }

            var keysInOrder = apiResp.recommendations
                .Select(r => r.item_key)
                .Where(k => !string.IsNullOrWhiteSpace(k))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            if (!keysInOrder.Any()) return result;

            var products = await _db.Products
                .Include(p => p.ProductImages)
                .Where(p => p.ProductCode != null && keysInOrder.Contains(p.ProductCode))
                .ToListAsync();

            var orderIndex = keysInOrder
                .Select((k, i) => new { k, i })
                .ToDictionary(x => x.k, x => x.i, StringComparer.OrdinalIgnoreCase);

            var candidates = products
                .Where(p => !cartIds.Contains(p.ProductID)) // skip already in cart
                .OrderBy(p => orderIndex.TryGetValue(p.ProductCode!, out var i) ? i : int.MaxValue)
                .ToList();

            if (intent == Species.Unknown)
                return candidates.Take(maxItems).ToList();

            // Phase 1: same-species
            var sameSpecies = new List<Product>();
            foreach (var p in candidates)
            {
                if (DetectSpecies(p) == intent)
                {
                    sameSpecies.Add(p);
                    if (sameSpecies.Count >= maxItems) break;
                }
            }
            if (sameSpecies.Count >= maxItems)
                return sameSpecies.Take(maxItems).ToList();

            // Phase 2: fill with others in Python order
            var filled = new List<Product>(sameSpecies);
            foreach (var p in candidates)
            {
                if (filled.Contains(p)) continue;
                if (DetectSpecies(p) != intent)
                {
                    filled.Add(p);
                    if (filled.Count >= maxItems) break;
                }
            }

            return filled.Take(maxItems).ToList();
        }
    }
}
