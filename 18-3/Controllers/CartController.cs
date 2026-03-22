using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using _18_3.Models;
using _18_3.Repositories;
using _18_3.Extensions;

namespace _18_3.Controllers
{
    public class CartController : Controller
    {
        private readonly IProductRepository _productRepository;

        public CartController(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        // Xem giỏ hàng: Có thể cho phép xem hoặc bắt đăng nhập tùy bạn, 
        // ở đây tôi để bắt đăng nhập để đồng bộ.
        [Authorize]
        public IActionResult Index()
        {
            var cart = HttpContext.Session.GetObjectFromJson<ShoppingCart>("Cart") ?? new ShoppingCart();
            return View(cart);
        }

        // Bắt buộc đăng nhập khi thêm sản phẩm vào giỏ
        [Authorize]
        public async Task<IActionResult> AddToCart(int productId, int quantity = 1)
        {
            var product = await _productRepository.GetByIdAsync(productId);
            if (product != null)
            {
                var cart = HttpContext.Session.GetObjectFromJson<ShoppingCart>("Cart") ?? new ShoppingCart();
                cart.AddItem(new CartItem
                {
                    ProductId = product.Id,
                    Name = product.Name,
                    Price = product.Price,
                    Quantity = quantity,
                    ImageUrl = product.ImageUrl
                });
                HttpContext.Session.SetObjectAsJson("Cart", cart);
            }
            return RedirectToAction("Index");
        }

        [Authorize]
        public IActionResult RemoveFromCart(int productId)
        {
            var cart = HttpContext.Session.GetObjectFromJson<ShoppingCart>("Cart") ?? new ShoppingCart();
            cart.RemoveItem(productId);
            HttpContext.Session.SetObjectAsJson("Cart", cart);
            return RedirectToAction("Index");
        }

        // Bắt buộc đăng nhập khi vào trang thanh toán
        [Authorize]
        public IActionResult Checkout()
        {
            return View(new Order());
        }

        [Authorize]
        [HttpPost]
        public IActionResult Checkout(Order order)
        {
            var cart = HttpContext.Session.GetObjectFromJson<ShoppingCart>("Cart");
            if (cart == null || !cart.Items.Any())
            {
                return RedirectToAction("Index");
            }

            if (ModelState.IsValid)
            {
                // Logic lưu đơn hàng...
                HttpContext.Session.Remove("Cart");
                return View("OrderCompleted", order.Id);
            }
            return View(order);
        }
    }
}
