using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Linq;

namespace MotoShop.Controllers
{
    public class CartController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICartService _cartService;
        private readonly IOrderService _orderService;

        public CartController(
            IUnitOfWork unitOfWork,
            UserManager<IdentityUser> userManager,
            ICartService cartService,
            IOrderService orderService)
        {
            _unitOfWork = unitOfWork;
            _userManager = userManager;
            _cartService = cartService;
            _orderService = orderService;
        }

        private string GetCartUserId()
        {
            if (_userManager.GetUserId(User) != null) return _userManager.GetUserId(User);

            if (Request.Cookies.ContainsKey("GuestId"))
            {
                return Request.Cookies["GuestId"];
            }

            string guestId = System.Guid.NewGuid().ToString();
            Response.Cookies.Append("GuestId", guestId, new Microsoft.AspNetCore.Http.CookieOptions
            {
                Expires = System.DateTimeOffset.Now.AddDays(30),
                HttpOnly = true,
                IsEssential = true
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
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> AddToCart(int variantId, int quantity = 1)
        {
            var userId = GetCartUserId();
            
            try
            {
                var success = await _cartService.AddToCartAsync(userId, variantId, quantity);
                if (success)
                {
                    return Json(new { success = true, message = "Sản phẩm đã được thêm vào giỏ hàng!" });
                }
                return Json(new { success = false, message = "Không thể thêm sản phẩm. Có thể do hết hàng hoặc lỗi hệ thống." });
            }
            catch (System.Exception ex)
            {
                return Json(new { success = false, message = "Có lỗi xảy ra: " + ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> Checkout()
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) 
                return RedirectToAction("Login", "Account", new { returnUrl = Url.Action("Checkout", "Cart") });

            // Sync guest cart to user cart on checkout if needed
            if (Request.Cookies.ContainsKey("GuestId"))
            {
                var guestId = Request.Cookies["GuestId"];
                await _cartService.SyncCartAsync(guestId, userId);
                Response.Cookies.Delete("GuestId");
            }

            var cartItems = await _cartService.GetCartAsync(userId);
            if (!cartItems.Any()) return RedirectToAction("Index");

            var shippingMethods = await _unitOfWork.Repository<ShippingMethod>().Find(s => s.IsActive).ToListAsync();

            ViewBag.CartItems = cartItems;
            ViewBag.TotalAmount = cartItems.Sum(i => i.Total);
            ViewBag.ShippingMethods = shippingMethods;

            return View(new CheckoutDto());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Checkout(CheckoutDto model)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(new { success = false, message = "Vui lòng đăng nhập." });

            // Note is optional, so we remove manual validation if it was there
            if (string.IsNullOrEmpty(model.FullName) || string.IsNullOrEmpty(model.Phone) || string.IsNullOrEmpty(model.Province))
            {
                return Json(new { success = false, message = "Vui lòng điền đầy đủ thông tin giao hàng." });
            }

            var result = await _orderService.CreateOrderAsync(userId, model);
            
            if (result.Success)
            {
                return Json(new { success = true, message = result.Message, orderId = result.OrderId });
            }

            return Json(new { success = false, message = result.Message });
        }

        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> UpdateQuantity(int variantId, int quantity)
        {
            var userId = GetCartUserId();
            var success = await _cartService.UpdateQuantityAsync(userId, variantId, quantity);
            return Json(new { success = success });
        }

        [HttpPost]
        [IgnoreAntiforgeryToken]
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

            // Chuyển đổi orderValue từ string sang decimal dùng InvariantCulture để tránh lỗi dấu phẩy/dấu chấm
            if (!decimal.TryParse(orderValue, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal val))
            {
                return Json(new { success = false, message = "Giá trị đơn hàng không hợp lệ." });
            }

            var coupon = await _unitOfWork.Repository<Coupon>()
                .Find(c => c.Code.ToLower() == code.ToLower() && c.IsActive && (c.ExpiryDate == null || c.ExpiryDate >= System.DateTime.Now))
                .FirstOrDefaultAsync();
            
            if (coupon == null) return Json(new { success = false, message = "Mã giảm giá không hợp lệ hoặc đã hết hạn." });

            if (coupon.UsageLimit > 0 && coupon.UsedCount >= coupon.UsageLimit)
                return Json(new { success = false, message = "Mã giảm giá đã hết số lượt sử dụng." });

            if (coupon.MinOrderValue.HasValue && val < coupon.MinOrderValue.Value)
                return Json(new { success = false, message = $"Đơn hàng tối thiểu {coupon.MinOrderValue.Value:N0}đ để sử dụng mã này." });

            decimal discountAmount = 0;
            if (coupon.DiscountType == "Percentage")
            {
                discountAmount = val * (coupon.DiscountValue / 100);
            }
            else
            {
                discountAmount = coupon.DiscountValue;
            }

            return Json(new { success = true, message = "Áp dụng thành công", discountAmount = discountAmount });
        }

        public async Task<IActionResult> Success(int id)
        {
            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant)
                        .ThenInclude(pv => pv.Product)
                .Include(o => o.ShippingMethod)
                .Include(o => o.Coupon)
                .FirstOrDefaultAsync();

            if (order == null) return NotFound();

            return View(order);
        }
    }
}
