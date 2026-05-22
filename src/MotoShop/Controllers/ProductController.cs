using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Business.DTOs;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Constants;
using MotoShop.Data.Models;
using MotoShop.Data.Enums;
using MotoShop.Data.Interfaces;
using System;
using Microsoft.Extensions.Caching.Memory;

namespace MotoShop.Controllers
{
    public class ProductController : Controller
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;
        private readonly IPromotionService _promotionService;
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IMemoryCache _cache;

        public ProductController(
            IProductService productService,
            ICategoryService categoryService,
            IPromotionService promotionService,
            IUnitOfWork unitOfWork,
            UserManager<IdentityUser> userManager,
            IMemoryCache cache)
        {
            _productService = productService;
            _categoryService = categoryService;
            _promotionService = promotionService;
            _unitOfWork = unitOfWork;
            _userManager = userManager;
            _cache = cache;
        }

        public async Task<IActionResult> Index(
            string? searchTerm,
            int? categoryId,
            int? brandId,
            decimal? minPrice,
            decimal? maxPrice,
            bool? inStock,
            bool? onSale,
            string? sort,
            int page = 1,
            int pageSize = 12)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var pagedProducts = await _productService.GetPagedProductsAsync(
                searchTerm, categoryId, brandId, sort, page, pageSize, minPrice, maxPrice, inStock, onSale
            );

            var categories = await _cache.GetOrCreateAsync("all_categories", e => {
                e.SetAbsoluteExpiration(TimeSpan.FromHours(1));
                return _categoryService.GetAllAsync();
            }) ?? new List<CategoryDto>();

            var brands = await _cache.GetOrCreateAsync("all_brands", e => {
                e.SetAbsoluteExpiration(TimeSpan.FromHours(1));
                return _productService.GetAllBrandsAsync();
            }) ?? new List<BrandDto>();

            var maxPriceLimit = await _cache.GetOrCreateAsync("max_product_price", e => {
                e.SetAbsoluteExpiration(TimeSpan.FromHours(1));
                return _productService.GetMaxProductPriceAsync();
            });

            var categoryProductCount = await _cache.GetOrCreateAsync("product_count_by_category", e => {
                e.SetAbsoluteExpiration(TimeSpan.FromMinutes(5));
                return _productService.GetProductCountByCategoryAsync();
            }) ?? new Dictionary<int, int>();

            var brandProductCount = await _cache.GetOrCreateAsync("product_count_by_brand", e => {
                e.SetAbsoluteExpiration(TimeSpan.FromMinutes(5));
                return _productService.GetProductCountByBrandAsync();
            }) ?? new Dictionary<int, int>();

            var vm = new MotoShop.Models.ViewModels.ProductListViewModel
            {
                PagedProducts = pagedProducts,
                Categories = categories.ToList(),
                Brands = brands.ToList(),
                CategoryProductCount = categoryProductCount,
                BrandProductCount = brandProductCount,

                CurrentKeyword = searchTerm,
                CurrentCategoryId = categoryId,
                CurrentBrandId = brandId,

                CurrentSort = sort,
                IsDiscountActive = onSale ?? false,
                IsInStockActive = inStock ?? false,

                SelectedMinPrice = minPrice ?? 0,
                SelectedMaxPrice = maxPrice ?? maxPriceLimit,
                MaxPriceLimit = maxPriceLimit
            };

            // Setup display titles
            if (!string.IsNullOrEmpty(searchTerm))
            {
                vm.PageTitle = "Kết quả tìm kiếm";
                vm.PageSubtitle = $"Tìm thấy {pagedProducts.TotalCount} sản phẩm cho từ khóa \"{searchTerm}\"";
            }
            else if (categoryId.HasValue)
            {
                var cat = categories.FirstOrDefault(c => c.CategoryId == categoryId.Value);
                vm.PageTitle = cat?.CategoryName ?? "Danh mục";
                vm.PageSubtitle = $"{pagedProducts.TotalCount} sản phẩm trong danh mục";
            }
            else if (brandId.HasValue)
            {
                var brand = brands.FirstOrDefault(b => b.BrandId == brandId.Value);
                vm.PageTitle = $"Thương hiệu {brand?.BrandName}";
                vm.PageSubtitle = $"{pagedProducts.TotalCount} sản phẩm của {brand?.BrandName}";
            }
            else
            {
                vm.PageTitle = "Tất cả sản phẩm";
                vm.PageSubtitle = $"Tổng số {pagedProducts.TotalCount} sản phẩm";
            }

            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = (sort == "newest" || string.IsNullOrEmpty(sort)) },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = (sort == "price_asc") },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = (sort == "price_desc") },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = (sort == "az") },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = (sort == "za") }
            };

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest") return PartialView("_ProductGridPartial", pagedProducts);
            return View(vm);
        }

        [HttpGet("products/usage/{slug}")]
        public async Task<IActionResult> Usage(string slug, string? sort, int page = 1, int pageSize = 12)
        {
            var usage = await _unitOfWork.Repository<ProductUsage>()
                .Find(u => u.IsActive && u.Slug == slug)
                .AsNoTracking()
                .FirstOrDefaultAsync();

            if (usage == null) return NotFound();

            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);
            var products = await _productService.GetPagedProductsAsync(null, null, null, sort, page, pageSize, null, null, null, null, slug);
            var categories = (await _categoryService.GetAllAsync()).ToList();
            var brands = (await _productService.GetAllBrandsAsync()).ToList();
            var maxPriceLimit = await _productService.GetMaxProductPriceAsync();

            var vm = new MotoShop.Models.ViewModels.ProductListViewModel
            {
                PagedProducts = products,
                Categories = categories,
                Brands = brands,
                CategoryProductCount = await _productService.GetProductCountByCategoryAsync(),
                BrandProductCount = await _productService.GetProductCountByBrandAsync(),
                CurrentKeyword = null,
                CurrentCategoryId = null,
                CurrentBrandId = null,
                CurrentSort = sort,
                IsDiscountActive = false,
                IsInStockActive = false,
                SelectedMinPrice = 0,
                SelectedMaxPrice = maxPriceLimit,
                MaxPriceLimit = maxPriceLimit,
                PageTitle = $"Cong dung: {usage.Name}",
                PageSubtitle = $"{products.TotalCount} san pham phu hop voi cong dung {usage.Name}"
            };
            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = (sort == "newest" || string.IsNullOrEmpty(sort)) },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = (sort == "price_asc") },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = (sort == "price_desc") },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = (sort == "az") },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = (sort == "za") }
            };
            return View("Index", vm);
        }

        [HttpGet]
        public async Task<IActionResult> SearchSuggestions(string term)
        {
            if (string.IsNullOrWhiteSpace(term) || term.Length < 2)
                return Json(new { products = new List<object>(), categories = new List<object>(), brands = new List<object>() });

            var search = MotoShop.Business.Helpers.VietnameseStringHelper.NormalizeKeyword(term);

            var products = await _unitOfWork.Repository<Product>().Find(p => p.IsActive && 
                (EF.Functions.Collate(p.ProductName, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || p.ProductName.ToLower().Contains(search)))
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .Take(5)
                .Select(p => new {
                    p.ProductId,
                    p.ProductName,
                    p.Slug,
                    ImageUrl = p.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault() ?? p.Images.Select(i => i.ImageUrl).FirstOrDefault(),
                    MinPrice = p.Variants.Any() ? p.Variants.Min(v => v.Price) : 0
                })
                .ToListAsync();

            var matchedCats = await _unitOfWork.Repository<Category>().Find(c =>
                EF.Functions.Collate(c.CategoryName, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || c.CategoryName.ToLower().Contains(search))
                .Take(3)
                .Select(c => new { c.CategoryId, c.CategoryName })
                .ToListAsync();

            var catIds = matchedCats.Select(c => c.CategoryId).ToList();
            var catCounts = await _unitOfWork.Repository<Product>().Find(p => catIds.Contains(p.CategoryId ?? 0) && p.IsActive)
                .GroupBy(p => p.CategoryId)
                .Select(g => new { Id = g.Key ?? 0, Count = g.Count() })
                .ToDictionaryAsync(x => x.Id, x => x.Count);

            var categories = matchedCats.Select(c => new {
                c.CategoryId, c.CategoryName,
                Count = catCounts.GetValueOrDefault(c.CategoryId, 0)
            }).ToList();

            var matchedBrands = await _unitOfWork.Repository<Brand>().Find(b =>
                EF.Functions.Collate(b.BrandName, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || b.BrandName.ToLower().Contains(search))
                .Take(3)
                .Select(b => new { b.BrandId, b.BrandName })
                .ToListAsync();

            var brandIds = matchedBrands.Select(b => b.BrandId).ToList();
            var brandCounts = await _unitOfWork.Repository<Product>().Find(p => brandIds.Contains(p.BrandId ?? 0) && p.IsActive)
                .GroupBy(p => p.BrandId)
                .Select(g => new { Id = g.Key ?? 0, Count = g.Count() })
                .ToDictionaryAsync(x => x.Id, x => x.Count);

            var brands = matchedBrands.Select(b => new {
                b.BrandId, b.BrandName,
                Count = brandCounts.GetValueOrDefault(b.BrandId, 0)
            }).ToList();

            return Json(new { products, categories, brands });
        }

        [HttpGet]
        public async Task<IActionResult> QuickView(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();
            return PartialView("_QuickViewPartial", product);
        }

        public async Task<IActionResult> Promotion()
        {
            var products = await _promotionService.GetFlashSaleProductsAsync(15);
            return View(products);
        }

        [HttpGet]
        public async Task<IActionResult> Compare(string ids)
        {
            if (string.IsNullOrEmpty(ids)) return RedirectToAction("Index");
            var idList = ids.Split(',').Select(s => int.TryParse(s.Trim(), out var n) ? n : 0).Where(n => n > 0).Distinct().Take(3).ToList();
            if (idList.Count < 2) return RedirectToAction("Index");

            var rawProducts = await _unitOfWork.Repository<Product>().Find(x => idList.Contains(x.ProductId) && x.IsActive)
                .Include(x => x.Variants).Include(x => x.Images).Include(x => x.Brand).Include(x => x.Category).Include(x => x.Specifications).Include(x => x.Reviews)
                .AsNoTracking().ToListAsync();

            if (rawProducts.Count < 2) return RedirectToAction("Index");
            if (rawProducts.Select(p => p.CategoryId).Distinct().Count() > 1) {
                TempData["CompareError"] = "Chỉ có thể so sánh sản phẩm cùng danh mục.";
                return RedirectToAction("Index");
            }

            var specsMap = new Dictionary<int, Dictionary<string, string>>();
            var ratingMap = new Dictionary<int, double>();

            var products = rawProducts.Select(p => {
                specsMap[p.ProductId] = p.Specifications.OrderBy(s => s.DisplayOrder).ToDictionary(s => s.SpecName, s => s.SpecValue);
                var approvedReviews = p.Reviews.Where(r => r.Status == ReviewStatusConst.Approved).ToList();
                ratingMap[p.ProductId] = approvedReviews.Any() ? Math.Round(approvedReviews.Average(r => r.Rating), 1) : 0;
                return new ProductDto {
                    ProductId = p.ProductId, ProductName = p.ProductName, Slug = p.Slug ?? string.Empty,
                    BrandName = p.Brand?.BrandName ?? string.Empty, BrandLogoUrl = p.Brand?.LogoUrl ?? string.Empty,
                    CategoryName = p.Category?.CategoryName ?? string.Empty, CategoryId = p.CategoryId,
                    PrimaryImageUrl = p.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault() ?? p.Images.Select(i => i.ImageUrl).FirstOrDefault() ?? string.Empty,
                    MinPrice = p.Variants.Any() ? p.Variants.Min(v => v.Price) : 0,
                    MinOriginalPrice = p.Variants.OrderBy(v => v.Price).Select(v => v.OriginalPrice).FirstOrDefault(),
                    IsInStock = p.Variants.Any(v => v.StockQuantity > 0),
                    StockCount = p.Variants.Sum(v => v.StockQuantity), SoldCount = p.SoldCount, IsFeatured = p.IsFeatured
                };
            }).OrderBy(p => idList.IndexOf(p.ProductId)).ToList();

            ViewBag.SpecNames = products.SelectMany(p => specsMap[p.ProductId].Keys).Distinct().ToList();
            ViewBag.SpecsMap = specsMap;
            ViewBag.RatingMap = ratingMap;
            ViewBag.CategoryName = rawProducts.First().Category?.CategoryName;

            return View(products);
        }

        public async Task<IActionResult> Details(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();

            ViewBag.DefaultVariant = product.Variants.OrderByDescending(v => v.StockQuantity > 0).FirstOrDefault() ?? product.Variants.FirstOrDefault();
            ViewBag.MaxStock = product.Variants.Max(v => (int?)v.StockQuantity) ?? 0;

            var attrGroups = product.Variants
                .SelectMany(v => v.VariantAttributeValues)
                .GroupBy(a => a.AttributeName)
                .ToDictionary(g => g.Key, g => g.Select(a => a.Value).Distinct().ToList());

            if (!attrGroups.Any() && product.Variants.Any())
            {
                var variantNames = product.Variants
                    .Select(v => string.IsNullOrWhiteSpace(v.VariantName) ? "Mặc định" : v.VariantName)
                    .Distinct()
                    .ToList();
                attrGroups.Add("Phiên bản", variantNames);
            }

            ViewBag.AttributeGroups = attrGroups.Any() ? attrGroups : null;

            var userId = _userManager.GetUserId(User);
            bool isWishlisted = false;
            bool hasReviewed = false;
            bool canReview = false;
            bool isLoggedIn = !string.IsNullOrEmpty(userId);

            if (isLoggedIn) {
                var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
                if (customer != null) {
                    isWishlisted = await _unitOfWork.Repository<WishlistNew>().Find(w => w.UserId == customer.CustomerId && w.ProductId == product.ProductId).AnyAsync();
                    hasReviewed = await _unitOfWork.Repository<ProductReview>().Find(r => r.CustomerId == customer.CustomerId && r.ProductId == product.ProductId).AnyAsync();
                }
                canReview = await _productService.CanUserReviewProductAsync(userId!, product.ProductId);
            }

            ViewBag.IsWishlisted = isWishlisted;
            ViewBag.HasReviewed = hasReviewed;
            ViewBag.CanReview = canReview;
            ViewBag.IsLoggedIn = isLoggedIn;

            ViewBag.RelatedProducts = await _productService.GetRelatedProductsAsync(product.ProductId, product.CategoryId ?? 0, product.BrandId ?? 0, 8);

            var now = DateTime.Now;
            var promoProduct = await _unitOfWork.Repository<PromotionProduct>()
                .Find(pp => pp.ProductId == product.ProductId
                    && pp.Promotion != null
                    && pp.Promotion.IsActive
                    && pp.Promotion.StartDate <= now
                    && pp.Promotion.EndDate >= now
                    && (pp.Promotion.PromotionType == PromotionType.FlashSale || pp.Promotion.PromotionType == PromotionType.ProductDiscount))
                .Include(pp => pp.Promotion)
                .OrderByDescending(pp => pp.Promotion!.PromotionType == PromotionType.FlashSale ? 2 : 1)
                .ThenByDescending(pp => pp.Promotion!.Priority)
                .FirstOrDefaultAsync();

            if (promoProduct?.Promotion != null) {
                var promo = promoProduct.Promotion;
                var defaultVar = product.Variants.OrderByDescending(v => v.StockQuantity > 0).FirstOrDefault() ?? product.Variants.FirstOrDefault();
                if (defaultVar != null) {
                    decimal basePrice = defaultVar.OriginalPrice ?? defaultVar.Price;
                    // [M3-FIX] Dùng PromotionService thay vì tính tay — nhất quán với CartService/OrderService
                    decimal discountedPrice = await _promotionService.CalculateDiscountAsync(product.ProductId, basePrice, defaultVar.ProductVariantId);
                    if (discountedPrice < basePrice) {
                        ViewBag.PromotionPrice = discountedPrice;
                        ViewBag.PromotionOriginalPrice = basePrice;
                        ViewBag.PromotionPercent = basePrice > 0 ? (int)Math.Round((1 - discountedPrice / basePrice) * 100) : 0;
                        ViewBag.PromotionName = promo.Name;
                        ViewBag.PromotionType = promo.PromotionType.ToString();
                        ViewBag.PromotionEndDate = promo.EndDate;
                    }
                }
            }

            return View(product);
        }

        [HttpGet]
        public async Task<IActionResult> GetPromotionProductsJson(int count = 12)
        {
            var activeSales = await _promotionService.GetFlashSaleProductsAsync(count);
            if (activeSales == null || !activeSales.Any()) return Json(new List<ProductDto>());
            return Json(activeSales.Take(count).ToList());
        }
    }
}
