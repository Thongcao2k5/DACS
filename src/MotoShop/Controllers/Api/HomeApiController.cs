using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Enums;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using System.Linq;
using System;

namespace MotoShop.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeApiController : ControllerBase
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;
        private readonly ICartService _cartService;
        private readonly IPromotionService _promotionService;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly MotoShopDbContext _context;

        public HomeApiController(
            IProductService productService, 
            ICategoryService categoryService,
            ICartService cartService,
            IPromotionService promotionService,
            UserManager<IdentityUser> userManager,
            MotoShopDbContext context)
        {
            _productService = productService;
            _categoryService = categoryService;
            _cartService = cartService;
            _promotionService = promotionService;
            _userManager = userManager;
            _context = context;
        }

        [HttpGet("featured")]
        public async Task<IActionResult> GetFeaturedProducts()
        {
            var products = await _productService.GetFeaturedProductsAsync(8);
            return Ok(products);
        }

        [HttpGet("flash-sale")]
        public async Task<IActionResult> GetFlashSale()
        {
            try
            {
                var now = DateTime.Now;

                // Lấy flash sale IsActive, ưu tiên đang chạy trước
                var running = await _context.Promotions
                    .AsNoTracking()
                    .Where(p => p.PromotionType == PromotionType.FlashSale
                             && p.IsActive
                             && p.StartDate <= now
                             && p.EndDate >= now)
                    .OrderByDescending(p => p.Priority)
                    .Select(p => p.Id)
                    .FirstOrDefaultAsync();

                var flashSaleId = running != 0 ? running : await _context.Promotions
                    .AsNoTracking()
                    .Where(p => p.PromotionType == PromotionType.FlashSale && p.IsActive)
                    .OrderByDescending(p => p.Priority)
                    .ThenByDescending(p => p.StartDate)
                    .Select(p => p.Id)
                    .FirstOrDefaultAsync();

                if (flashSaleId == 0) return Ok(null);

                var flashSale = await _context.Promotions
                    .AsNoTracking()
                    .Where(p => p.Id == flashSaleId)
                    .Select(p => new
                    {
                        p.Id,
                        p.Name,
                        p.EndDate,
                        p.DiscountType,
                        p.DiscountValue,
                        Items = p.PromotionProducts
                            .Where(pp => pp.Product != null
                                      && pp.Product.IsActive
                                      && !pp.Product.IsDeleted)
                            .Select(pp => new
                            {
                                pp.ProductId,
                                pp.Product!.ProductName,
                                pp.Product.Slug,
                                ImageUrl = pp.Product.Images
                                    .Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault()
                                    ?? pp.Product.Images.Select(i => i.ImageUrl).FirstOrDefault(),
                                SellingPrice = pp.Product.Variants
                                    .Where(v => v.Price > 0)
                                    .OrderBy(v => v.Price)
                                    .Select(v => v.Price)
                                    .FirstOrDefault(),
                                OriginalPrice = pp.Product.Variants
                                    .Where(v => v.Price > 0)
                                    .OrderBy(v => v.Price)
                                    .Select(v => (decimal?)v.OriginalPrice)
                                    .FirstOrDefault()
                            })
                            .ToList()
                    })
                    .FirstOrDefaultAsync();

                if (flashSale == null) return Ok(null);

                var isPercent = flashSale.DiscountType == DiscountType.Percent;
                var products = flashSale.Items.Select(item =>
                {
                    var basePrice = item.OriginalPrice ?? item.SellingPrice;
                    var sale = isPercent
                        ? basePrice * (1 - flashSale.DiscountValue / 100m)
                        : Math.Max(0, basePrice - flashSale.DiscountValue);
                    var pct = basePrice > 0 ? (int)Math.Round((1 - sale / basePrice) * 100) : 0;
                    return new
                    {
                        productId = item.ProductId,
                        productName = item.ProductName,
                        slug = item.Slug,
                        imageUrl = item.ImageUrl,
                        flashSalePrice = sale,
                        originalPrice = basePrice,
                        discountPercent = pct,
                        quantity = 0,
                        soldQuantity = 0,
                        soldPercent = 0
                    };
                }).ToList();

                return Ok(new
                {
                    flashSaleId = flashSale.Id,
                    title = flashSale.Name,
                    endDate = flashSale.EndDate,
                    products
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        // Endpoint debug — xem raw data flash sale trong DB
        [HttpGet("flash-sale/debug")]
        public async Task<IActionResult> DebugFlashSale()
        {
            var now = DateTime.Now;
            var all = await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                .Where(p => p.PromotionType == PromotionType.FlashSale)
                .Select(p => new
                {
                    p.Id,
                    p.Name,
                    p.IsActive,
                    StartDate = p.StartDate.ToString("dd/MM/yyyy HH:mm"),
                    EndDate = p.EndDate.ToString("dd/MM/yyyy HH:mm"),
                    IsRunning = p.StartDate <= now && p.EndDate >= now,
                    p.DiscountValue,
                    DiscountType = p.DiscountType.ToString(),
                    ProductCount = p.PromotionProducts.Count
                })
                .ToListAsync();

            return Ok(new { serverTime = now.ToString("dd/MM/yyyy HH:mm:ss"), flashSales = all });
        }

        [HttpGet("products/discount")]
        public async Task<IActionResult> GetDiscountProducts(int pageNumber = 1, int pageSize = 12, string sort = "newest")
        {
            pageNumber = Math.Max(1, pageNumber);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var pagedResult = await _productService.GetPagedDiscountProductsAsync(pageNumber, pageSize, sort);

            return Ok(new {
                items = pagedResult,
                pageNumber = pagedResult.CurrentPage,
                pageCount = pagedResult.TotalPages,
                totalCount = pagedResult.TotalCount
            });
        }

        [HttpGet("promotions")]
        public async Task<IActionResult> GetPromotionProducts()
        {
            var activeSales = await _promotionService.GetFlashSalesAsync();
            return Ok(activeSales);
        }

        [HttpGet("categories")]
        public async Task<IActionResult> GetCategories()
        {
            var categories = await _categoryService.GetAllAsync();
            var topCategories = categories
                .OrderByDescending(c => c.ProductCount)
                .Take(5)
                .ToList();
                
            return Ok(topCategories);
        }

        [HttpGet("cart-count")]
        public async Task<IActionResult> GetCartCount()
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Ok(new { count = 0 });

            var cart = await _cartService.GetCartAsync(userId);
            return Ok(new { count = cart.Sum(i => i.Quantity) });
        }
    }
}
