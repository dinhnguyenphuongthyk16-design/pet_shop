using System.Diagnostics;
using System.Linq;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;

using Pet_Shop.Data;              // ✅ add this for PetShopDbContext
using Pet_Shop.Models;
using Pet_Shop.Services;
using Pet_Shop.Models.Entities;

namespace Pet_Shop.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly CategoryService _categoryService;
        private readonly BannerService _bannerService;
        private readonly ProductService _productService;
        private readonly PromotionService _promotionService;
        private readonly ChatbotService _chatbotService;
        private readonly LocalRecommendationService? _localRecommendationService;
        private readonly IConfiguration _configuration;

        // ✅ NEW: inject EF DbContext for DB fallback
        private readonly PetShopDbContext _db;

        public HomeController(
            ILogger<HomeController> logger,
            CategoryService categoryService,
            BannerService bannerService,
            ProductService productService,
            PromotionService promotionService,
            ChatbotService chatbotService,
            LocalRecommendationService? localRecommendationService,
            IConfiguration configuration,
            PetShopDbContext db) // ✅ add this
        {
            _logger = logger;
            _categoryService = categoryService;
            _bannerService = bannerService;
            _productService = productService;
            _promotionService = promotionService;
            _chatbotService = chatbotService;
            _localRecommendationService = localRecommendationService;
            _configuration = configuration;
            _db = db; // ✅ store it
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var categories        = await _categoryService.GetAllCategoriesAsync();
                var banners           = await _bannerService.GetActiveBannersAsync();
                var activePromotions  = await _promotionService.GetActivePromotionsAsync();
                var featuredProducts  = await GetHomepageFeaturedProductsAsync();

                List<Product>? aiRecommendedProducts = null;
                var userId = GetCurrentUserId();
                if (userId > 0)
                {
                    aiRecommendedProducts = await _chatbotService.GetRecommendedProductsForUserAsync(userId, 8);
                    _logger.LogInformation($"AI Chatbot loaded {aiRecommendedProducts?.Count ?? 0} recommendations for user {userId}");
                }

                ViewBag.Categories         = categories;
                ViewBag.Banners            = banners;
                ViewBag.FeaturedProducts   = featuredProducts;
                ViewBag.ActivePromotions   = activePromotions;
                ViewBag.AIRecommendedProducts = aiRecommendedProducts;
                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading data for home page");
                ViewBag.Categories         = new List<Category>();
                ViewBag.Banners            = new List<Banner>();
                ViewBag.FeaturedProducts   = new List<Product>();
                ViewBag.ActivePromotions   = new List<Promotion>();
                ViewBag.AIRecommendedProducts = null;
                return View();
            }
        }

        private async Task<List<Product>> GetHomepageFeaturedProductsAsync()
        {
            var featuredProducts = new List<Product>();
            try
            {
                var useLocalML = _configuration.GetValue<bool>("LocalMLSettings:Enabled", false);

                if (useLocalML && _localRecommendationService != null)
                {
                    var localMLAvailable = await _localRecommendationService.IsApiAvailableAsync();
                    if (localMLAvailable)
                    {
                        var userId = GetCurrentUserId();
                        if (userId > 0)
                        {
                            featuredProducts = await _localRecommendationService.GetRecommendedProductsAsync(userId, 8);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Error getting featured products from Local ML service");
            }

            if (!featuredProducts.Any())
            {
                featuredProducts = (await _productService.GetFeaturedProductsAsync()).ToList();
            }
            return featuredProducts;
        }

        private int GetCurrentUserId()
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim != null && int.TryParse(userIdClaim.Value, out int userId))
                    return userId;
            }
            return 0;
        }

        public IActionResult Privacy() => View();
        public IActionResult Contact() => View();

        [HttpGet]
        public async Task<IActionResult> GetActivePromotions()
        {
            try
            {
                var promotions = await _promotionService.GetActivePromotionsAsync();
                return Json(new { success = true, data = promotions });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting active promotions");
                return Json(new { success = false, message = "Có lỗi xảy ra khi tải mã khuyến mãi" });
            }
        }

        // ======================================================
        // Live AI Recs (STRICT CART/CLICK species lock + DB fallback)
        // Body: { ClickedCodes: ["RC-ADULT-001", ...], K: 8 }
        // ======================================================
        [HttpPost]
        public async Task<IActionResult> GetAIRecsLive([FromBody] LiveRecRequest req)
        {
            try
            {
                if (req == null)
                    return Json(new { success = false, data = Array.Empty<object>(), message = "Yêu cầu không hợp lệ" });

                int k = req.K <= 0 ? 8 : req.K;

                var clickedCodes = (req.ClickedCodes ?? new List<string>())
                    .Where(s => !string.IsNullOrWhiteSpace(s))
                    .Select(s => s.Trim())
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .ToList();

                _logger.LogInformation("[HOME/AI] GetAIRecsLive: K={K}, ClickedCodes=[{Codes}]",
                    k, string.Join(", ", clickedCodes));

                // ---- Strict species lock from codes (prefix-based) ----
                bool anyCatCode = clickedCodes.Any(c =>
                    c.StartsWith("CAT-", StringComparison.OrdinalIgnoreCase) ||
                    c.StartsWith("DEMO-CAT-", StringComparison.OrdinalIgnoreCase) ||
                    c.Contains("KITTEN", StringComparison.OrdinalIgnoreCase));
                bool anyDogCode = clickedCodes.Any(c =>
                    c.StartsWith("DOG-", StringComparison.OrdinalIgnoreCase) ||
                    c.StartsWith("DEMO-DOG-", StringComparison.OrdinalIgnoreCase) ||
                    c.Contains("PUPPY", StringComparison.OrdinalIgnoreCase));

                string? locked = null; // "cat" | "dog" | null
                if (anyCatCode && !anyDogCode) locked = "cat";
                else if (anyDogCode && !anyCatCode) locked = "dog";

                _logger.LogInformation("[HOME/AI] Locked species intent: {Locked}", locked ?? "(none)");

                // Helpers
                bool IsCat(Product p)
                {
                    var code = p.ProductCode ?? "";
                    var pet  = (p.PetType ?? "").ToLowerInvariant();
                    return code.StartsWith("CAT-", StringComparison.OrdinalIgnoreCase)
                           || code.StartsWith("DEMO-CAT-", StringComparison.OrdinalIgnoreCase)
                           || pet.Contains("cat");
                }
                bool IsDog(Product p)
                {
                    var code = p.ProductCode ?? "";
                    var pet  = (p.PetType ?? "").ToLowerInvariant();
                    return code.StartsWith("DOG-", StringComparison.OrdinalIgnoreCase)
                           || code.StartsWith("DEMO-DOG-", StringComparison.OrdinalIgnoreCase)
                           || pet.Contains("dog");
                }
                bool IsNeutral(Product p)
                {
                    var pet = (p.PetType ?? "").ToLowerInvariant();
                    return string.IsNullOrWhiteSpace(pet) || pet.Contains("all");
                }

                var exclude = new HashSet<string>(clickedCodes, StringComparer.OrdinalIgnoreCase);

                var useLocalML  = _configuration.GetValue<bool>("LocalMLSettings:Enabled", false);
                var userId      = GetCurrentUserId();
                var canUseLocal = useLocalML
                                  && _localRecommendationService != null
                                  && await _localRecommendationService.IsApiAvailableAsync();

                _logger.LogInformation("[HOME/AI] canUseLocal={CanUseLocal}, userId={UserId}", canUseLocal, userId);

                // ---------- 1) Try CART-BASED ML (if clicks present & ML available) ----------
                var mlProducts = new List<Product>();
                if (canUseLocal && clickedCodes.Count > 0)
                {
                    var clickedProducts = await _productService.GetProductsByCodesAsync(clickedCodes);
                    var clickedIds = clickedProducts.Select(p => p.ProductID).Distinct().ToList();
                    _logger.LogInformation("[HOME/AI] CART-based: clickedIds=[{Ids}]",
                        string.Join(", ", clickedIds));

                    var ml = await _localRecommendationService
                        .GetCartBasedRecommendationsAsync(userId, clickedIds, k * 3);

                    mlProducts = ml
                        .Where(p => string.IsNullOrEmpty(p.ProductCode) || !exclude.Contains(p.ProductCode!))
                        .GroupBy(p => p.ProductID)
                        .Select(g => g.First())
                        .ToList();

                    _logger.LogInformation("[HOME/AI] ML results after exclude+dedupe: {Count}", mlProducts.Count);
                }

                // ---------- 2) Species-locked selection (prefer ML; fallback to DB) ----------
                if (locked != null)
                {
                    var final = new List<Product>(k);

                    if (mlProducts.Count > 0)
                    {
                        var same    = locked == "cat" ? mlProducts.Where(IsCat) : mlProducts.Where(IsDog);
                        var neutral = mlProducts.Where(IsNeutral);

                        foreach (var p in same)
                        {
                            if (final.Count >= k) break;
                            final.Add(p);
                        }
                        foreach (var p in neutral)
                        {
                            if (final.Count >= k) break;
                            final.Add(p);
                        }

                        _logger.LogInformation("[HOME/AI] ML filtered fill: same+neutral={Count}", final.Count);
                    }

                    // DB top-up if needed
                    if (final.Count < k)
                    {
                        int need = k - final.Count;
                        _logger.LogInformation("[HOME/AI] DB top-up by species. Need={Need}", need);

                        // same-species pool (prefix or PetType contains 'cat'/'dog')
                        IQueryable<Product> samePoolQuery = _db.Products
                            .Include(p => p.ProductImages)
                            .Where(p => p.IsActive);

                        samePoolQuery = locked == "cat"
                            ? samePoolQuery.Where(p =>
                                  (p.ProductCode != null && (p.ProductCode.StartsWith("CAT-") || p.ProductCode.StartsWith("DEMO-CAT-")))
                                  || (p.PetType != null && p.PetType.ToLower().Contains("cat")))
                            : samePoolQuery.Where(p =>
                                  (p.ProductCode != null && (p.ProductCode.StartsWith("DOG-") || p.ProductCode.StartsWith("DEMO-DOG-")))
                                  || (p.PetType != null && p.PetType.ToLower().Contains("dog")));

                        var samePool = await samePoolQuery
                            .OrderByDescending(p => p.IsFeatured)
                            .ThenByDescending(p => p.ProductID)
                            .ToListAsync();

                        var finalIds = new HashSet<int>(final.Select(x => x.ProductID));
                        var sameFill = samePool.Where(p =>
                                (string.IsNullOrEmpty(p.ProductCode) || !exclude.Contains(p.ProductCode!)) &&
                                !finalIds.Contains(p.ProductID))
                            .Take(need)
                            .ToList();

                        final.AddRange(sameFill);
                    }

                    if (final.Count < k)
                    {
                        int need = k - final.Count;
                        var neutralPool = await _db.Products
                            .Include(p => p.ProductImages)
                            .Where(p => p.IsActive)
                            .Where(p => string.IsNullOrEmpty(p.PetType) || p.PetType!.ToLower().Contains("all"))
                            .OrderByDescending(p => p.IsFeatured)
                            .ThenByDescending(p => p.ProductID)
                            .ToListAsync();

                        var finalIds = new HashSet<int>(final.Select(x => x.ProductID));
                        var neutralFill = neutralPool.Where(p =>
                                (string.IsNullOrEmpty(p.ProductCode) || !exclude.Contains(p.ProductCode!)) &&
                                !finalIds.Contains(p.ProductID))
                            .Take(need)
                            .ToList();

                        final.AddRange(neutralFill);
                    }

                    _logger.LogInformation("[HOME/AI] Final locked='{Locked}' count={Count}", locked, final.Count);
                    var dataLocked = final.Take(k).Select(MapProductToVm).ToList();
                    return Json(new { success = true, data = dataLocked });
                }

                // ---------- 3) No lock → gentle fallback path ----------
                List<Product> products;
                if (mlProducts.Count == 0)
                {
                    products = await FallbackFromClickedOrFeaturedAsync(clickedCodes, k);
                    _logger.LogInformation("[HOME/AI] No lock fallback count={Count}", products.Count);
                }
                else
                {
                    products = mlProducts.Take(k).ToList();
                }

                var data = products.Select(MapProductToVm).ToList();
                return Json(new { success = true, data });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "GetAIRecsLive failed");
                return Json(new { success = false, data = Array.Empty<object>(), message = "Không thể cập nhật gợi ý AI" });
            }
        }

        private async Task<List<Product>> FallbackFromClickedOrFeaturedAsync(List<string> clickedCodes, int k)
        {
            var exclude = new HashSet<string>(clickedCodes ?? Enumerable.Empty<string>(), StringComparer.OrdinalIgnoreCase);

            var featured = (await _productService.GetFeaturedProductsAsync())
                .Where(p => string.IsNullOrEmpty(p.ProductCode) || !exclude.Contains(p.ProductCode!))
                .Take(k)
                .ToList();

            if (featured.Count >= k) return featured;

            var need = k - featured.Count;
            var newer = (await _productService.GetNewProductsAsync())
                .Where(p => string.IsNullOrEmpty(p.ProductCode) || !exclude.Contains(p.ProductCode!))
                .Take(need)
                .ToList();

            featured.AddRange(newer);
            return featured;
        }

        // =============== helpers for /GetAIRecsLive ===============

        public class LiveRecRequest
        {
            public List<string>? ClickedCodes { get; set; }
            public int K { get; set; } = 8;
            public int? UserId { get; set; }
        }

        public class LiveRecProductVm
        {
            public int ProductID { get; set; }
            public string? ProductCode { get; set; }
            public string ProductName { get; set; } = "";
            public string? ShortDescription { get; set; }
            public decimal Price { get; set; }
            public decimal? SalePrice { get; set; }
            public string? ImageURL { get; set; }
            public bool HasDiscount => SalePrice.HasValue && SalePrice.Value > 0 && SalePrice.Value < Price;
        }

        private LiveRecProductVm MapProductToVm(Product p)
        {
            var img = p.ProductImages?
                .OrderByDescending(pi => pi.IsPrimary)
                .ThenBy(pi => pi.CreatedDate)
                .FirstOrDefault();

            return new LiveRecProductVm
            {
                ProductID = p.ProductID,
                ProductCode = p.ProductCode,
                ProductName = p.ProductName,
                ShortDescription = p.ShortDescription,
                Price = p.Price,
                SalePrice = p.SalePrice,
                ImageURL = img?.ImageURL
            };
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
