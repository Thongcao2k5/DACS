using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using MotoShop.Data.Data;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Linq;
using System.Collections.Generic;
using System;

namespace MotoShop.Controllers
{
    public class CartController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICartService _cartService;
        private readonly IOrderService _orderService;
        private readonly MotoShopDbContext _context;

        public CartController(
            IUnitOfWork unitOfWork,
            UserManager<IdentityUser> userManager,
            ICartService cartService,
            IOrderService orderService,
            MotoShopDbContext context)
        {
            _unitOfWork = unitOfWork;
            _userManager = userManager;
            _cartService = cartService;
            _orderService = orderService;
            _context = context;
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
                // KHÔNG đặt Expires -> Sẽ bị xóa khi đóng trình duyệt
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
                // MUA NGAY: Chỉ lấy sản phẩm được chọn
                var variant = await _context.ProductVariants
                    .Include(v => v.Product)
                    .FirstOrDefaultAsync(v => v.ProductVariantId == variantId.Value);

                if (variant == null) return RedirectToAction("Index");

                // TÍNH TOÁN GIÁ KHUYẾN MÃI THỰC TẾ
                var now = DateTime.Now;
                decimal displayPrice = variant.Price;
                decimal originalPrice = variant.OriginalPrice ?? variant.Price;

                // 1. Check Flash Sale
                var flashSale = await _context.FlashSaleProducts.AsNoTracking()
                    .Include(fsp => fsp.FlashSale)
                    .FirstOrDefaultAsync(fsp => fsp.ProductId == variant.ProductId && fsp.FlashSale != null && fsp.FlashSale.IsActive && fsp.FlashSale.StartDate <= now && fsp.FlashSale.EndDate >= now && fsp.Quantity > fsp.SoldQuantity);

                if (flashSale != null)
                {
                    displayPrice = flashSale.FlashSalePrice;
                    originalPrice = variant.Price;
                }
                else
                {
                    // 2. Check Promotion
                    var promotion = await _context.PromotionProducts.AsNoTracking()
                        .Include(pp => pp.Promotion)
                        .Where(pp => pp.ProductId == variant.ProductId && pp.Promotion != null && pp.Promotion.IsActive && pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now)
                        .Select(pp => pp.Promotion)
                        .FirstOrDefaultAsync();

                    if (promotion != null)
                    {
                        originalPrice = variant.Price;
                        if (promotion.DiscountType == "Percentage")
                            displayPrice = variant.Price * (1 - (promotion.DiscountPercentage / 100));
                        else
                            displayPrice = Math.Max(0, variant.Price - promotion.DiscountAmount);
                    }
                }

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
                // THANH TOÁN GIỎ HÀNG: Lấy toàn bộ như cũ
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

            var shippingMethods = await _unitOfWork.Repository<ShippingMethod>().Find(s => s.IsActive == true).ToListAsync();

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

            // Nếu không có AddressId (tức là đang nhập mới) thì mới bắt buộc FullName, Phone, Province
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

            var coupon = await _unitOfWork.Repository<Coupon>()
                .Find(c => c.Code.ToLower() == code.ToLower() && c.IsActive && (c.ExpiryDate >= DateTime.Now))
                .FirstOrDefaultAsync();
            
            if (coupon == null) return Json(new { success = false, message = "Mã giảm giá không hợp lệ." });

            if (coupon.UsageLimit > 0 && coupon.UsedCount >= coupon.UsageLimit)
                return Json(new { success = false, message = "Mã giảm giá đã hết lượt sử dụng." });

            decimal discountAmount = coupon.DiscountType == "Percentage" ? val * (coupon.DiscountValue / 100) : coupon.DiscountValue;
            return Json(new { success = true, message = "Áp dụng thành công", discountAmount = discountAmount });
        }

        public async Task<IActionResult> Success(int id)
        {
            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant!)
                        .ThenInclude(pv => pv.Product!)
                .Include(o => o.ShippingMethod)
                .Include(o => o.Coupon)
                .FirstOrDefaultAsync();

            if (order == null) return NotFound();
            return View(order);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddQuick([FromBody] AddQuickRequest request)
        {
            // Lấy variant đầu tiên còn hàng
            var variant = await _context.ProductVariants
                .Where(v => v.ProductId == request.ProductId && v.StockQuantity > 0)
                .OrderByDescending(v => v.StockQuantity)
                .FirstOrDefaultAsync();

            if (variant == null)
                return Json(new { success = false, message = "Sản phẩm đã hết hàng" });

            // Gọi CartService thêm vào giỏ
            var userId = GetCartUserId();
            var success = await _cartService.AddToCartAsync(userId, variant.ProductVariantId, request.Quantity);

            if (!success)
                return Json(new { success = false, message = "Không thể thêm sản phẩm." });

            // Lấy tổng số lượng giỏ hàng
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
