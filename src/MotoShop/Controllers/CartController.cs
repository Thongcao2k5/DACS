using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using MotoShop.Data.Enums;
using MotoShop.Data.Data;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Linq;
using System.Collections.Generic;
using System;
using Microsoft.AspNetCore.Http;

namespace MotoShop.Controllers
{
    public class CartController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICartService _cartService;
        private readonly IOrderService _orderService;
        private readonly MotoShopDbContext _context;
        private readonly IPromotionService _promotionService;

        public CartController(
            IUnitOfWork unitOfWork,
            UserManager<IdentityUser> userManager,
            ICartService cartService,
            IOrderService orderService,
            MotoShopDbContext context,
            IPromotionService promotionService)
        {
            _unitOfWork = unitOfWork;
            _userManager = userManager;
            _cartService = cartService;
            _orderService = orderService;
            _context = context;
            _promotionService = promotionService;
        }

        private string GetCartUserId()
        {
            var userId = _userManager.GetUserId(User);
            if (userId != null) return userId;

            const string guestCookieName = "MotoShop_GuestId";

            if (Request.Cookies.ContainsKey(guestCookieName))
            {
                return Request.Cookies[guestCookieName]!;
            }

            string guestId = Guid.NewGuid().ToString();
            Response.Cookies.Append(guestCookieName, guestId, new Microsoft.AspNetCore.Http.CookieOptions
            {
                Path = "/",
                HttpOnly = true,
                IsEssential = true,
                Secure = true,
                SameSite = SameSiteMode.Lax
            });
            return guestId;
        }

        public async Task<IActionResult> Index()
        {
            var userId = GetCartUserId();
            var cartItems = await _cartService.GetCartAsync(userId);
            return View(cartItems);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddToCart([FromForm] int variantId, [FromForm] int quantity = 1)
        {
            if (quantity < 1)
                return Json(new { success = false, message = "Số lượng không hợp lệ." });

            var userId = GetCartUserId();
            try
            {
                var success = await _cartService.AddToCartAsync(userId, variantId, quantity);
                if (success) return Json(new { success = true, message = "Sản phẩm đã được thêm vào giỏ hàng!" });
                return Json(new { success = false, message = "Không thể thêm sản phẩm." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi: " + ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> Checkout(int? variantId, int quantity = 1)
        {
            if (quantity < 1) quantity = 1;

            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) 
                return RedirectToAction("Login", "Account", new { returnUrl = Request.Path + Request.QueryString });

            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return RedirectToAction("Profile", "Account");

            var savedAddresses = await _context.AddressesNew
                .Where(a => a.CustomerId == customer.CustomerId)
                .OrderByDescending(a => a.IsDefault)
                .ToListAsync();

            List<CartItemDto> finalItems;
            if (variantId.HasValue)
            {
                var variant = await _context.ProductVariants
                    .Include(v => v.Product)
                    .FirstOrDefaultAsync(v => v.ProductVariantId == variantId.Value);

                if (variant == null) return RedirectToAction("Index");

                // SỬ DỤNG PromotionHelper ĐÃ REFACTOR ĐỂ TÍNH GIÁ ĐÚNG
                decimal displayPrice = variant.ProductId.HasValue
                    ? await _promotionService.CalculateDiscountAsync(variant.ProductId.Value, variant.Price, variant.ProductVariantId)
                    : variant.Price;
                decimal originalPrice = variant.Price;

                finalItems = new List<CartItemDto> {
                    new CartItemDto {
                        ProductVariantId = variant.ProductVariantId,
                        ProductName = variant.Product?.ProductName ?? "Sản phẩm",
                        VariantName = variant.VariantName,
                        Price = displayPrice,
                        OriginalPrice = originalPrice,
                        Quantity = quantity,
                        ImageUrl = variant.ImageUrl ?? ""
                    }
                };
                ViewBag.IsDirectCheckout = true;
                ViewBag.DirectVariantId = variantId.Value;
                ViewBag.DirectQuantity = quantity;
                var effectiveWeight = (variant.Weight == 500 && variant.WeightGroupId.HasValue)
                    ? variant.WeightGroupId.Value switch { 1 => 300, 2 => 1000, 3 => 3000, 4 => 6000, _ => 500 }
                    : variant.Weight;
                ViewBag.DefaultWeight = Math.Max(100, effectiveWeight * quantity);
            }
            else
            {
                if (Request.Cookies.ContainsKey("MotoShop_GuestId"))
                {
                    var guestId = Request.Cookies["MotoShop_GuestId"];
                    await _cartService.SyncCartAsync(guestId!, userId);
                    Response.Cookies.Delete("MotoShop_GuestId");
                }
                finalItems = (await _cartService.GetCartAsync(userId)).ToList();
                if (!finalItems.Any()) return RedirectToAction("Index");
                ViewBag.IsDirectCheckout = false;
                var variantIds = finalItems.Select(i => i.ProductVariantId).ToList();
                var variantData = await _context.ProductVariants
                    .Where(v => variantIds.Contains(v.ProductVariantId))
                    .Select(v => new { v.ProductVariantId, v.Weight, v.WeightGroupId })
                    .ToListAsync();
                var weightMap = variantData.ToDictionary(
                    v => v.ProductVariantId,
                    v => (v.Weight == 500 && v.WeightGroupId.HasValue)
                        ? v.WeightGroupId.Value switch { 1 => 300, 2 => 1000, 3 => 3000, 4 => 6000, _ => 500 }
                        : v.Weight
                );
                ViewBag.DefaultWeight = Math.Max(100, finalItems.Sum(i => i.Quantity * (weightMap.TryGetValue(i.ProductVariantId, out var w) ? w : 500)));
            }

            var shippingMethods = await _context.ShippingMethods.Where(s => s.IsActive == true).ToListAsync();

            ViewBag.CartItems = finalItems;
            ViewBag.TotalAmount = finalItems.Sum(i => i.Total);
            ViewBag.CartItemCount = finalItems.Sum(i => i.Quantity);
            ViewBag.ShippingMethods = shippingMethods;
            ViewBag.SavedAddresses = savedAddresses;

            var model = new CheckoutDto();
            var defaultAddr = savedAddresses.FirstOrDefault(a => a.IsDefault) ?? savedAddresses.FirstOrDefault();
            ViewBag.DefaultDistrictId = defaultAddr?.DistrictId;
            ViewBag.DefaultWardCode = defaultAddr?.WardCode;
            if (defaultAddr != null) {
                model.FullName = defaultAddr.FullName ?? "";
                model.Phone = defaultAddr.Phone ?? "";
                model.Province = defaultAddr.Province ?? "";
                model.District = defaultAddr.District ?? "";
                model.Ward = defaultAddr.Ward ?? "";
                model.Address = defaultAddr.Street ?? "";
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Checkout(CheckoutDto model)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(new { success = false, message = "Vui lòng đăng nhập." });

            if (model.DirectVariantId.HasValue && model.DirectQuantity < 1)
                return Json(new { success = false, message = "Số lượng sản phẩm không hợp lệ." });

            if (!model.AddressId.HasValue)
            {
                if (string.IsNullOrEmpty(model.FullName) || string.IsNullOrEmpty(model.Phone) || string.IsNullOrEmpty(model.Province) || string.IsNullOrEmpty(model.Address))
                {
                    return Json(new { success = false, message = "Vui lòng điền đầy đủ thông tin giao hàng." });
                }
            }

            var result = await _orderService.CreateOrderAsync(userId, model);
            
            if (result.Success) return Json(new { success = true, message = result.Message, orderId = result.OrderId });
            return Json(new { success = false, message = result.Message });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateQuantity(int variantId, int quantity)
        {
            var userId = GetCartUserId();
            var success = await _cartService.UpdateQuantityAsync(userId, variantId, quantity);
            return Json(new { success = success });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RemoveFromCart(int variantId)
        {
            var userId = GetCartUserId();
            var success = await _cartService.RemoveFromCartAsync(userId, variantId);
            return Json(new { success = success });
        }

        [HttpGet]
        public async Task<IActionResult> GetCartCount()
        {
            var userId = GetCartUserId();
            var count = await _cartService.GetCartCountAsync(userId);
            return Json(count);
        }

        [HttpGet]
        public async Task<IActionResult> CheckCoupon(string code, string orderValue, int? directVariantId, int directQuantity = 1)
        {
            if (string.IsNullOrEmpty(code)) return Json(new { success = false, message = "Vui lòng nhập mã." });

            if (!decimal.TryParse(orderValue, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal val))
            {
                return Json(new { success = false, message = "Giá trị đơn hàng không hợp lệ." });
            }

            var promotionItems = await GetPromotionItemsForCouponAsync(directVariantId, directQuantity);
            var result = await _promotionService.ValidateVoucherAsync(code, val, promotionItems);
            return Json(new
            {
                success = result.IsValid,
                message = result.Message,
                discountAmount = result.DiscountAmount
            });
        }

        private async Task<List<CartItem>> GetPromotionItemsForCouponAsync(int? directVariantId, int directQuantity)
        {
            if (directVariantId.HasValue)
            {
                var variant = await _context.ProductVariants
                    .AsNoTracking()
                    .FirstOrDefaultAsync(v => v.ProductVariantId == directVariantId.Value);

                if (variant == null)
                {
                    return new List<CartItem>();
                }

                var price = variant.ProductId.HasValue
                    ? await _promotionService.CalculateDiscountAsync(variant.ProductId.Value, variant.Price, variant.ProductVariantId)
                    : variant.Price;

                return new List<CartItem>
                {
                    new CartItem
                    {
                        ProductVariantId = variant.ProductVariantId,
                        Quantity = Math.Max(1, directQuantity),
                        Price = price
                    }
                };
            }

            var userId = GetCartUserId();
            var cart = await _context.Carts
                .AsNoTracking()
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            return cart?.CartItems
                .Select(i => new CartItem
                {
                    ProductVariantId = i.ProductVariantId,
                    Quantity = i.Quantity,
                    Price = i.Price
                })
                .ToList() ?? new List<CartItem>();
        }

        [Microsoft.AspNetCore.Authorization.Authorize]
        public async Task<IActionResult> Success(int id)
        {
            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.AsNoTracking()
                .FirstOrDefaultAsync(c => c.UserId == userId);

            var order = await _context.Orders
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant!)
                        .ThenInclude(pv => pv.Product!)
                .Include(o => o.ShippingMethod)
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null) return NotFound();
            if (customer == null || order.CustomerId != customer.CustomerId) return Forbid();
            return View(order);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddQuick([FromBody] AddQuickRequest request)
        {
            if (request == null || request.Quantity < 1)
                return Json(new { success = false, message = "Số lượng không hợp lệ." });

            var variant = await _context.ProductVariants
                .Where(v => v.ProductId == request.ProductId && v.StockQuantity > 0)
                .OrderByDescending(v => v.StockQuantity)
                .FirstOrDefaultAsync();

            if (variant == null)
                return Json(new { success = false, message = "Sản phẩm đã hết hàng" });

            var userId = GetCartUserId();
            var success = await _cartService.AddToCartAsync(userId, variant.ProductVariantId, request.Quantity);

            if (!success)
                return Json(new { success = false, message = "Không thể thêm sản phẩm." });

            var cartCount = await _cartService.GetCartCountAsync(userId);
            return Json(new { success = true, cartCount, message = "Đã thêm vào giỏ hàng!" });
        }

        public class AddQuickRequest
        {
            public int ProductId { get; set; }
            public int Quantity { get; set; } = 1;
        }
    }
}
