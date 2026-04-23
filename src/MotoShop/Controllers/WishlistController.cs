using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class WishlistController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICartService _cartService;
        private const string GUEST_COOKIE = "MotoShop_GuestId";

        public WishlistController(
            MotoShopDbContext context,
            UserManager<IdentityUser> userManager,
            ICartService cartService)
        {
            _context = context;
            _userManager = userManager;
            _cartService = cartService;
        }

        private string GetWishlistUserId()
        {
            var userId = _userManager.GetUserId(User);
            if (userId != null) return userId;

            if (Request.Cookies.ContainsKey(GUEST_COOKIE))
            {
                return Request.Cookies[GUEST_COOKIE]!;
            }

            string guestId = Guid.NewGuid().ToString();
            Response.Cookies.Append(GUEST_COOKIE, guestId, new Microsoft.AspNetCore.Http.CookieOptions
            {
                Expires = DateTimeOffset.Now.AddYears(1),
                Path = "/",
                HttpOnly = true,
                IsEssential = true
            });
            return guestId;
        }

        private async Task<int> GetInternalUserIdAsync()
        {
            var userIdStr = GetWishlistUserId();
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userIdStr);
            if (customer != null) return customer.CustomerId;

            // Dùng mã băm ổn định từ chuỗi GuestId để lưu vào INT
            // Đảm bảo mã băm luôn dương và không đổi giữa các lần chạy
            return Math.Abs(userIdStr.GetHashCode());
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            int userId = await GetInternalUserIdAsync();
            
            var wishlist = await _context.WishlistsNew
                .Where(w => w.UserId == userId)
                .Include(w => w.Product)
                    .ThenInclude(p => p.Brand)
                .Include(w => w.Product)
                    .ThenInclude(p => p.Variants)
                .Include(w => w.Product)
                    .ThenInclude(p => p.Images)
                .OrderByDescending(w => w.CreatedAt)
                .ToListAsync();

            return View(wishlist);
        }

        [HttpGet]
        public async Task<IActionResult> GetCount()
        {
            int userId = await GetInternalUserIdAsync();
            var count = await _context.WishlistsNew.CountAsync(w => w.UserId == userId);
            return Json(new { count });
        }

        [HttpPost]
        public async Task<IActionResult> Add([FromBody] int productId)
        {
            int userId = await GetInternalUserIdAsync();

            var exists = await _context.WishlistsNew.AnyAsync(w => w.UserId == userId && w.ProductId == productId);
            if (!exists)
            {
                var item = new WishlistNew
                {
                    UserId = userId,
                    ProductId = productId,
                    CreatedAt = DateTime.Now
                };
                _context.WishlistsNew.Add(item);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Đã thêm vào yêu thích" });
            }

            return Json(new { success = true, message = "Sản phẩm đã có trong yêu thích" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Remove([FromBody] WishlistRequest req)
        {
            if (req == null) return Json(new { success = false });

            int userId = await GetInternalUserIdAsync();
            var item = await _context.WishlistsNew.FirstOrDefaultAsync(w => w.UserId == userId && w.ProductId == req.ProductId);
            
            if (item != null)
            {
                _context.WishlistsNew.Remove(item);
                await _context.SaveChangesAsync();
                return Json(new { success = true });
            }

            return Json(new { success = false, message = "Không tìm thấy sản phẩm" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Clear()
        {
            int userId = await GetInternalUserIdAsync();
            var items = _context.WishlistsNew.Where(w => w.UserId == userId);
            _context.WishlistsNew.RemoveRange(items);
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddToCart([FromBody] WishlistRequest req)
        {
            if (req == null) return Json(new { success = false });

            var variant = await _context.ProductVariants
                .Where(v => v.ProductId == req.ProductId && v.StockQuantity > 0)
                .FirstOrDefaultAsync();

            if (variant == null)
                return Json(new { success = false, message = "Sản phẩm hiện đang hết hàng" });

            var cartUserId = GetWishlistUserId();
            var success = await _cartService.AddToCartAsync(cartUserId, variant.ProductVariantId, req.Quantity);
            
            if (success)
            {
                var count = await _cartService.GetCartCountAsync(cartUserId);
                return Json(new { success = true, cartCount = count });
            }

            return Json(new { success = false, message = "Lỗi khi thêm vào giỏ hàng" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddAllToCart()
        {
            int userId = await GetInternalUserIdAsync();
            var cartUserId = GetWishlistUserId();
            
            var items = await _context.WishlistsNew
                .Where(w => w.UserId == userId)
                .Include(w => w.Product)
                    .ThenInclude(p => p.Variants)
                .ToListAsync();

            int added = 0;
            var skipped = new List<string>();

            foreach (var item in items)
            {
                var variant = item.Product.Variants.FirstOrDefault(v => v.StockQuantity > 0);
                if (variant != null)
                {
                    await _cartService.AddToCartAsync(cartUserId, variant.ProductVariantId, 1);
                    added++;
                }
                else
                {
                    skipped.Add(item.Product.ProductName);
                }
            }

            var finalCount = await _cartService.GetCartCountAsync(cartUserId);
            return Json(new { success = true, added = added, skipped = skipped, cartCount = finalCount });
        }

        public class WishlistRequest
        {
            public int ProductId { get; set; }
            public int Quantity { get; set; } = 1;
        }
    }
}
