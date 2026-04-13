using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using MotoShop.Data.Interfaces;
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

        public async Task<IActionResult> Index()
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return RedirectToAction("Login", "Account");

            var cartItems = await _cartService.GetCartAsync(userId);
            return View(cartItems);
        }

        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> AddToCart(int variantId, int quantity = 1)
        {
            var userId = _userManager.GetUserId(User);
            
            if (string.IsNullOrEmpty(userId))
            {
                return Json(new { success = false, message = "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng." });
            }

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
            if (string.IsNullOrEmpty(userId)) return RedirectToAction("Login", "Account");

            var cartItems = await _cartService.GetCartAsync(userId);
            if (!cartItems.Any()) return RedirectToAction("Index");

            ViewBag.CartItems = cartItems;
            ViewBag.TotalAmount = cartItems.Sum(i => i.Total);

            return View(new CheckoutDto());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Checkout(CheckoutDto model)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(new { success = false, message = "Vui lòng đăng nhập." });

            if (!ModelState.IsValid)
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
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(new { success = false });

            var success = await _cartService.UpdateQuantityAsync(userId, variantId, quantity);
            return Json(new { success = success });
        }

        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> RemoveFromCart(int variantId)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(new { success = false });

            var success = await _cartService.RemoveFromCartAsync(userId, variantId);
            return Json(new { success = success });
        }

        [HttpGet]
        public async Task<IActionResult> GetCartCount()
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(0);

            var count = await _cartService.GetCartCountAsync(userId);
            return Json(count);
        }

        public IActionResult Success(int id)
        {
            ViewBag.OrderId = id;
            return View();
        }
    }
}
