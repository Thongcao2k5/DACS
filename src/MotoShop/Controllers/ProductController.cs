using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Business.DTOs;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Models;
using MotoShop.Data.Interfaces;
using System;
using Microsoft.Extensions.Caching.Memory;

namespace MotoShop.Controllers
{
    public class ProductController : Controller
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;
        private readonly IFlashSaleService _flashSaleService;
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IMemoryCache _cache;

        private static readonly MemoryCacheEntryOptions _shortCache = new MemoryCacheEntryOptions()
            .SetAbsoluteExpiration(TimeSpan.FromMinutes(5));
        private static readonly MemoryCacheEntryOptions _longCache = new MemoryCacheEntryOptions()
            .SetAbsoluteExpiration(TimeSpan.FromHours(1));

        public ProductController(
            IProductService productService,
            ICategoryService categoryService,
            IFlashSaleService flashSaleService,
            IUnitOfWork unitOfWork,
            UserManager<IdentityUser> userManager,
            IMemoryCache cache)
        {
            _productService = productService;
            _categoryService = categoryService;
            _flashSaleService = flashSaleService;
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
            // Chạy tuần tự để tránh lỗi "A second operation was started on this context..."
            
            // 1. Lấy dữ liệu phân trang
            var pagedProducts = await _productService.GetPagedProductsAsync(
                searchTerm, categoryId, brandId, sort, page, pageSize, minPrice, maxPrice, inStock, onSale
            );

            // 2. Lấy danh mục và thương hiệu (cache 1 giờ)
            var categories = await _cache.GetOrCreateAsync("all_categories", e =>
            {
                e.SetAbsoluteExpiration(TimeSpan.FromHours(1));
                return _categoryService.GetAllAsync();
            }) ?? await _categoryService.GetAllAsync();

            var brands = await _cache.GetOrCreateAsync("all_brands", e =>
            {
                e.SetAbsoluteExpiration(TimeSpan.FromHours(1));
                return _productService.GetAllBrandsAsync();
            }) ?? await _productService.GetAllBrandsAsync();

            // 3. Lấy số lượng sản phẩm (cache 5 phút)
            ViewBag.CategoryProductCount = await _cache.GetOrCreateAsync("product_count_by_category", e =>
            {
                e.SetAbsoluteExpiration(TimeSpan.FromMinutes(5));
                return _productService.GetProductCountByCategoryAsync();
            });
            ViewBag.BrandProductCount = await _cache.GetOrCreateAsync("product_count_by_brand", e =>
            {
                e.SetAbsoluteExpiration(TimeSpan.FromMinutes(5));
                return _productService.GetProductCountByBrandAsync();
            });

            // 4. Chuẩn bị SelectList và ListItems cho Sidebar
            ViewBag.CategoryListItems = categories.ToList();
            ViewBag.BrandListItems = brands.ToList();

            var categoryItems = categories.Select(c => new {
                CategoryId = c.CategoryId,
                CategoryNameWithCount = $"{c.CategoryName} ({((Dictionary<int, int>)ViewBag.CategoryProductCount).GetValueOrDefault(c.CategoryId, 0)})"
            });
            ViewBag.CategoryList = new SelectList(categoryItems, "CategoryId", "CategoryNameWithCount", categoryId);
            
            var brandItems = brands.Select(b => new {
                BrandId = b.BrandId,
                BrandNameWithCount = $"{b.BrandName} ({((Dictionary<int, int>)ViewBag.BrandProductCount).GetValueOrDefault(b.BrandId, 0)})"
            });
            ViewBag.BrandList = new SelectList(brandItems, "BrandId", "BrandNameWithCount", brandId);
            
            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = (sort == "newest" || string.IsNullOrEmpty(sort)) },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = (sort == "price_asc") },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = (sort == "price_desc") },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = (sort == "az") },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = (sort == "za") }
            };

            // 5. Tính toán số lượng hiển thị (FIX 5)
            int from = pagedProducts.TotalCount > 0 ? (page - 1) * pageSize + 1 : 0;
            int to = Math.Min(page * pageSize, pagedProducts.TotalCount);
            ViewBag.From = from;
            ViewBag.To = to;
            ViewBag.TotalProducts = pagedProducts.TotalCount;

            // 6. Tiêu đề động (FIX 1)
            var currentCat = categories.FirstOrDefault(c => c.CategoryId == categoryId);
            var currentBrand = brands.FirstOrDefault(b => b.BrandId == brandId);
            ViewBag.CategoryName = currentCat?.CategoryName;
            ViewBag.BrandName = currentBrand?.BrandName;

            // 7. Giá lớn nhất cho Slider (cache 1 giờ)
            ViewBag.MaxPriceLimit = await _cache.GetOrCreateAsync("max_product_price", e =>
            {
                e.SetAbsoluteExpiration(TimeSpan.FromHours(1));
                return _productService.GetMaxProductPriceAsync();
            });
            ViewBag.SelectedMinPrice = minPrice ?? 0;
            ViewBag.SelectedMaxPrice = maxPrice ?? ViewBag.MaxPriceLimit;

            // 8. Gợi ý từ khóa nếu không có kết quả (TÍNH NĂNG 7)
            if (pagedProducts.TotalCount == 0 && !string.IsNullOrEmpty(searchTerm))
            {
                // Logic đơn giản: lấy các từ khóa phổ biến
                ViewBag.Suggestions = new List<string> { "Nhớt Motul", "Vỏ xe", "Nhông sên dĩa" }; 
            }

            // Giữ lại các tham số lọc
            ViewBag.SearchTerm = searchTerm;
            ViewBag.CurrentCategoryId = categoryId;
            ViewBag.CurrentBrandId = brandId;
            ViewBag.Sort = sort;
            ViewBag.InStock = inStock;
            ViewBag.OnSale = onSale;

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return PartialView("_ProductGridPartial", pagedProducts);
            }

            return View(pagedProducts);
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

        public async Task<IActionResult> Compare(string ids)
        {
            if (string.IsNullOrEmpty(ids)) return RedirectToAction("Index");

            var idList = ids.Split(',')
                .Select(s => int.TryParse(s.Trim(), out var n) ? n : 0)
                .Where(n => n > 0)
                .Distinct()
                .Take(4)
                .ToList();

            var rawProducts = await _unitOfWork.Repository<Product>()
                .Find(x => idList.Contains(x.ProductId) && x.IsActive)
                .Include(x => x.Variants)
                .Include(x => x.Images)
                .Include(x => x.Brand)
                .Include(x => x.Category)
                .Include(x => x.Specifications)
                .AsNoTracking()
                .ToListAsync();

            var specsMap = new Dictionary<int, Dictionary<string, string>>();
            var products = rawProducts.Select(p =>
            {
                specsMap[p.ProductId] = p.Specifications
                    .OrderBy(s => s.DisplayOrder)
                    .ToDictionary(s => s.SpecName, s => s.SpecValue);

                return new ProductDto
                {
                    ProductId        = p.ProductId,
                    ProductName      = p.ProductName,
                    Slug             = p.Slug ?? string.Empty,
                    BrandName        = p.Brand?.BrandName ?? string.Empty,
                    BrandLogoUrl     = p.Brand?.LogoUrl ?? string.Empty,
                    CategoryName     = p.Category?.CategoryName ?? string.Empty,
                    CategoryId       = p.CategoryId,
                    PrimaryImageUrl  = p.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault()
                                       ?? p.Images.Select(i => i.ImageUrl).FirstOrDefault() ?? string.Empty,
                    MinPrice         = p.Variants.Any() ? p.Variants.Min(v => v.Price) : 0,
                    MinOriginalPrice = p.Variants.OrderBy(v => v.Price).Select(v => v.OriginalPrice).FirstOrDefault(),
                    IsInStock        = p.Variants.Any(v => v.StockQuantity > 0),
                    StockCount       = p.Variants.Sum(v => v.StockQuantity),
                    SoldCount        = p.SoldCount,
                    IsFeatured       = p.IsFeatured
                };
            }).OrderBy(p => idList.IndexOf(p.ProductId)).ToList();

            ViewBag.SpecNames = specsMap.Values
                .SelectMany(d => d.Keys)
                .Distinct()
                .OrderBy(n => n)
                .ToList();
            ViewBag.SpecsMap = specsMap;

            return View(products);
        }

        public IActionResult Category(int id)
        {
            return RedirectToAction("Index", new { categoryId = id });
        }

        public async Task<IActionResult> Details(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();

            // FIX: Lấy tất cả thuộc tính của các biến thể
            var allAttributes = product.Variants
                .SelectMany(v => v.VariantAttributeValues)
                .ToList();

            if (allAttributes.Any())
            {
                // Nếu có thuộc tính cấu trúc (Màu sắc, Dung tích...), group theo AttributeName
                ViewBag.AttributeGroups = allAttributes
                    .GroupBy(av => av.AttributeName ?? "Thuộc tính")
                    .ToDictionary(
                        g => g.Key,
                        g => g.Select(av => av.Value).Distinct().ToList()
                    );
            }
            else if (product.Variants.Count > 1)
            {
                // Nếu không có thuộc tính cấu trúc nhưng có nhiều biến thể, group theo "Phiên bản" dùng VariantName
                ViewBag.AttributeGroups = new Dictionary<string, List<string>>
                {
                    { "Phiên bản", product.Variants.Select(v => v.VariantName).Distinct().ToList() }
                };
            }
            else
            {
                ViewBag.AttributeGroups = new Dictionary<string, List<string>>();
            }

            ViewBag.DefaultVariant = product.Variants
                .OrderByDescending(v => v.StockQuantity > 0)
                .FirstOrDefault() ?? product.Variants.FirstOrDefault();

            ViewBag.MaxStock = product.Variants.Max(v => (int?)v.StockQuantity) ?? 0;

            var userId = _userManager.GetUserId(User);
            
            bool isWishlisted = false;
            if (!string.IsNullOrEmpty(userId))
            {
                var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
                if (customer != null)
                {
                    isWishlisted = await _unitOfWork.Repository<WishlistNew>().Find(w => w.UserId == customer.CustomerId && w.ProductId == product.ProductId).AnyAsync();
                }
            }
            ViewBag.IsWishlisted = isWishlisted;

            bool canReview = !string.IsNullOrEmpty(userId) && await _productService.CanUserReviewProductAsync(userId, product.ProductId);
            bool hasReviewed = false;
            if (!string.IsNullOrEmpty(userId))
            {
                var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
                if (customer != null)
                {
                    hasReviewed = await _unitOfWork.Repository<ProductReview>().Find(r => r.CustomerId == customer.CustomerId && r.ProductId == product.ProductId).AnyAsync();
                }
            }
            ViewBag.CanReview = canReview;
            ViewBag.HasReviewed = hasReviewed;
            ViewBag.IsLoggedIn = !string.IsNullOrEmpty(userId);

            var relatedProducts = await _productService.GetRelatedProductsAsync(
                product.ProductId,
                product.CategoryId ?? 0,
                product.BrandId ?? 0,
                8);

            var vouchers = await _productService.GetVouchersForProductAsync(product.ProductId);

            ViewBag.RelatedProducts = relatedProducts;
            ViewBag.Vouchers = vouchers;

            // Fix #3: Tính FlashSalePercent (MappingProfile không tính được do phép chia phức tạp)
            if (product.IsFlashSale && product.FlashSalePrice.HasValue && product.MinPrice > 0)
                product.FlashSalePercent = (int)Math.Round((1 - product.FlashSalePrice.Value / product.MinPrice) * 100);

            // Fix #2: Áp dụng giá Promotion nếu sản phẩm đang trong chương trình ưu đãi
            if (!product.IsFlashSale)
            {
                var now = DateTime.Now;
                var promoProduct = await _unitOfWork.Repository<PromotionProduct>()
                    .Find(pp => pp.ProductId == product.ProductId &&
                                pp.Promotion != null &&
                                pp.Promotion.IsActive &&
                                pp.Promotion.StartDate <= now &&
                                pp.Promotion.EndDate >= now)
                    .Include(pp => pp.Promotion)
                    .FirstOrDefaultAsync();

                if (promoProduct?.Promotion != null)
                {
                    var promo = promoProduct.Promotion;
                    var defaultVar = product.Variants
                        .OrderByDescending(v => v.StockQuantity > 0)
                        .FirstOrDefault() ?? product.Variants.FirstOrDefault();

                    if (defaultVar != null)
                    {
                        decimal basePrice = defaultVar.OriginalPrice ?? defaultVar.Price;
                        decimal discountedPrice = promo.DiscountType == "Percentage"
                            ? basePrice * (1 - promo.DiscountPercentage / 100m)
                            : Math.Max(0, basePrice - promo.DiscountAmount);

                        if (discountedPrice < defaultVar.Price)
                        {
                            ViewBag.PromotionPrice = discountedPrice;
                            ViewBag.PromotionOriginalPrice = basePrice;
                            ViewBag.PromotionPercent = (int)Math.Round((1 - discountedPrice / basePrice) * 100);
                            ViewBag.PromotionName = promo.PromotionName;
                        }
                    }
                }
            }

            return View(product);
        }

        public IActionResult Promotion()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetPromotionProductsJson(int count = 12)
        {
            var activeSales = await _flashSaleService.GetActiveFlashSalesAsync();
            if (activeSales == null || !activeSales.Any())
            {
                return Json(new List<ProductDto>());
            }
            
            var products = activeSales.SelectMany(s => s.Products).Take(count).ToList();
            return Json(products);
        }
    }
}
