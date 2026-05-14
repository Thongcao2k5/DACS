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
                    ? await _promotionService.CalculateDiscountAsync(variant.ProductId.Value, variant.Price)
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
            }

            var shippingMethods = await _context.ShippingMethods.Where(s => s.IsActive == true).ToListAsync();

            ViewBag.CartItems = finalItems;
            ViewBag.TotalAmount = finalItems.Sum(i => i.Total);
            ViewBag.ShippingMethods = shippingMethods;
            ViewBag.SavedAddresses = savedAddresses;

            var model = new CheckoutDto();
            var defaultAddr = savedAddresses.FirstOrDefault(a => a.IsDefault) ?? savedAddresses.FirstOrDefault();
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
        public async Task<IActionResult> CheckCoupon(string code, string orderValue)
        {
            if (string.IsNullOrEmpty(code)) return Json(new { success = false, message = "Vui lòng nhập mã." });

            if (!decimal.TryParse(orderValue, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal val))
            {
                return Json(new { success = false, message = "Giá trị đơn hàng không hợp lệ." });
            }

            var result = await _promotionService.ValidateVoucherAsync(code, val);
            return Json(new
            {
                success = result.IsValid,
                message = result.Message,
                discountAmount = result.DiscountAmount
            });
        }

        public async Task<IActionResult> Success(int id)
        {
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant!)
                        .ThenInclude(pv => pv.Product!)
                .Include(o => o.ShippingMethod)
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null) return NotFound();
            return View(order);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddQuick([FromBody] AddQuickRequest request)
        {
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
