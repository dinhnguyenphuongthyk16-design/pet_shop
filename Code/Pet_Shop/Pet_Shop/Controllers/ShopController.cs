using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Pet_Shop.Services;
using Pet_Shop.Models.Entities;
using System.Security.Claims;

namespace Pet_Shop.Controllers
{
    public class ShopController : Controller
    {
        private readonly ProductService _productService;
        private readonly CategoryService _categoryService;
        private readonly ILogger<ShopController> _logger;
        private readonly LocalRecommendationService _localRecommendationService;

        public ShopController(
            ProductService productService,
            CategoryService categoryService,
            ILogger<ShopController> logger,
            LocalRecommendationService localRecommendationService)
        {
            _productService = productService;
            _categoryService = categoryService;
            _logger = logger;
            _localRecommendationService = localRecommendationService;
        }

        [HttpGet]
        public async Task<IActionResult> Products(
            int? categoryId,
            int? brandId,
            decimal? minPrice,
            decimal? maxPrice,
            string? sortBy,
            int page = 1)
        {
            try
            {
                ViewData["Title"] = "Cửa hàng sản phẩm";

                // Get filter options
                var categories = await _categoryService.GetAllCategoriesAsync();
                var brands = await _productService.GetAllBrandsAsync();

                ViewBag.Categories = categories;
                ViewBag.Brands = brands;
                ViewBag.SelectedCategoryId = categoryId;
                ViewBag.SelectedBrandId = brandId;
                ViewBag.MinPrice = minPrice;
                ViewBag.MaxPrice = maxPrice;
                ViewBag.SortBy = sortBy;
                ViewBag.CurrentPage = page;

                // Get products
                IEnumerable<Product> products = await _productService.GetAllProductsAsync();

                // Apply filters
                if (categoryId.HasValue)
                {
                    products = products.Where(p => p.CategoryID == categoryId.Value);
                }

                if (brandId.HasValue)
                {
                    products = products.Where(p => p.BrandID == brandId.Value);
                }

                if (minPrice.HasValue)
                {
                    products = products.Where(p => p.Price >= minPrice.Value);
                }

                if (maxPrice.HasValue)
                {
                    products = products.Where(p => p.Price <= maxPrice.Value);
                }

                // Apply sorting
                products = sortBy switch
                {
                    "name_asc" => products.OrderBy(p => p.ProductName),
                    "name_desc" => products.OrderByDescending(p => p.ProductName),
                    "price_asc" => products.OrderBy(p => p.Price),
                    "price_desc" => products.OrderByDescending(p => p.Price),
                    "newest" => products.OrderByDescending(p => p.CreatedDate),
                    _ => products.OrderBy(p => p.ProductName)
                };

                // Pagination
                const int pageSize = 12;
                var totalItems = products.Count();
                var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

                products = products.Skip((page - 1) * pageSize).Take(pageSize);

                ViewBag.TotalItems = totalItems;
                ViewBag.TotalPages = totalPages;
                ViewBag.Products = products;

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading products");
                ViewBag.Error = "Có lỗi xảy ra khi tải danh sách sản phẩm";
                return View();
            }
        }

        [HttpGet]
        public async Task<IActionResult> Category(int id, int page = 1)
        {
            try
            {
                var category = await _categoryService.GetCategoryByIdAsync(id);
                if (category == null)
                {
                    return NotFound();
                }

                ViewData["Title"] = $"Danh mục: {category.CategoryName}";

                // Get products for this category
                var products = await _productService.GetProductsByCategoryAsync(id);

                // Pagination
                const int pageSize = 12;
                var totalItems = products.Count();
                var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

                products = products.Skip((page - 1) * pageSize).Take(pageSize);

                ViewBag.Category = category;
                ViewBag.Products = products;
                ViewBag.TotalItems = totalItems;
                ViewBag.TotalPages = totalPages;
                ViewBag.CurrentPage = page;

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading category {CategoryId}", id);
                return NotFound();
            }
        }

        [HttpGet]
        public async Task<IActionResult> Product(int id)
        {
            try
            {
                var product = await _productService.GetProductByIdAsync(id);
                if (product == null)
                {
                    return NotFound();
                }

                ViewData["Title"] = product.ProductName;

                // Related products (same category)
                var relatedProducts = await _productService.GetRelatedProductsAsync(
                    id,
                    product.CategoryID,
                    4
                );

                ViewBag.Product = product;
                ViewBag.RelatedProducts = relatedProducts;

                // ==========================
                // Detect userId from Claims
                // ==========================
                int? userId = null;
                if (User.Identity != null && User.Identity.IsAuthenticated)
                {
                    var idClaim = User.FindFirst("UserId") ??
                                  User.FindFirst(ClaimTypes.NameIdentifier);

                    if (idClaim != null && int.TryParse(idClaim.Value, out var uid))
                    {
                        userId = uid;
                    }
                }

                // ==========================
                // AI Recs – mode = "user"
                // ==========================
                if (userId.HasValue)
                {
                    try
                    {
                        var userRecs = await _localRecommendationService
                            .GetUserRecommendationsAsync(userId.Value, 5);

                        ViewBag.UserRecommendations = userRecs;
                    }
                    catch (Exception recEx)
                    {
                        _logger.LogWarning(recEx,
                            "Error getting user-based recommendations for user {UserId}", userId);
                    }
                }

                // ==========================
                // AI Recs – mode = "click"
                // (based on this product as if it were in the cart)
                // ==========================
                try
                {
                    var clickRecs = await _localRecommendationService
                        .GetCartBasedRecommendationsAsync(
                            customerId: userId ?? 0,
                            cartProductIds: new[] { product.ProductID },
                            maxItems: 5);

                    ViewBag.ClickRecommendations = clickRecs;
                }
                catch (Exception recEx)
                {
                    _logger.LogWarning(recEx,
                        "Error getting click-based recommendations for productCode {Code}",
                        product.ProductCode);
                }

                // ==========================
                // AI Recs – mode = "text"
                // ==========================
                try
                {
                    var query = product.ProductName ?? string.Empty;
                    if (product.Category != null &&
                        !string.IsNullOrEmpty(product.Category.CategoryName))
                    {
                        query += " " + product.Category.CategoryName;
                    }

                    var textRecs = await _localRecommendationService
                        .GetTextRecommendationsAsync(query, 5);

                    ViewBag.TextRecommendations = textRecs;
                }
                catch (Exception recEx)
                {
                    _logger.LogWarning(recEx,
                        "Error getting text-based recommendations for product {ProductId}", id);
                }

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading product {ProductId}", id);
                return NotFound();
            }
        }
    }
}
