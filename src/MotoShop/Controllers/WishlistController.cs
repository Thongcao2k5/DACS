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
using System.Text.Json;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class WishlistController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICartService _cartService;
        private const string WISHLIST_COOKIE = "MotoShop_Wishlist_Items";

        public WishlistController(
            MotoShopDbContext context,
            UserManager<IdentityUser> userManager,
            ICartService cartService)
        {
            _context = context;
            _userManager = userManager;
            _cartService = cartService;
        }

        private List<int> GetGuestWishlistItems()
        {
            var cookie = Request.Cookies[WISHLIST_COOKIE];
            if (string.IsNullOrEmpty(cookie)) return new List<int>();
            try { return JsonSerializer.Deserialize<List<int>>(cookie) ?? new List<int>(); }
            catch { return new List<int>(); }
        }

        private void SaveGuestWishlistItems(List<int> items)
        {
            var options = new Microsoft.AspNetCore.Http.CookieOptions { Expires = DateTimeOffset.Now.AddDays(30), Path = "/", HttpOnly = true };
            Response.Cookies.Append(WISHLIST_COOKIE, JsonSerializer.Serialize(items), options);
        }

        [HttpGet]
        public IActionResult Index()
        {
            return RedirectToAction("Wishlist", "Account");
        }

        [HttpGet]
        public async Task<IActionResult> GetCount()
        {
            var userId = _userManager.GetUserId(User);
            if (userId != null)
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer != null)
                {
                    var count = await _context.WishlistsNew.CountAsync(wi => wi.UserId == customer.CustomerId);
                    return Json(new { count });
                }
            }
            return Json(new { count = GetGuestWishlistItems().Count });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Toggle([FromBody] WishlistRequest req)
        {
            if (req == null) return Json(new { success = false });
            int productId = req.ProductId;

            var userId = _userManager.GetUserId(User);
            if (userId != null)
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer != null)
                {
                    var item = await _context.WishlistsNew.FirstOrDefaultAsync(wi => wi.UserId == customer.CustomerId && wi.ProductId == productId);
                    bool added = false;
                    if (item == null)
                    {
                        _context.WishlistsNew.Add(new WishlistNew { UserId = customer.CustomerId, ProductId = productId, CreatedAt = DateTime.Now });
                        added = true;
                    }
                    else
                    {
                        _context.WishlistsNew.Remove(item);
                        added = false;
                    }
                    await _context.SaveChangesAsync();
                    return Json(new { success = true, added = added, message = added ? "Đã thêm vào yêu thích" : "Đã xóa khỏi yêu thích" });
                }
            }

            // GUEST TOGGLE
            var guestItems = GetGuestWishlistItems();
            bool guestAdded = false;
            if (guestItems.Contains(productId))
            {
                guestItems.Remove(productId);
                guestAdded = false;
            }
            else
            {
                guestItems.Add(productId);
                guestAdded = true;
            }
            SaveGuestWishlistItems(guestItems);
            return Json(new { success = true, added = guestAdded, message = guestAdded ? "Đã thêm vào yêu thích" : "Đã xóa khỏi yêu thích" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Add([FromBody] int productId)
        {
            var userId = _userManager.GetUserId(User);
            if (userId != null)
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer != null)
                {
                    var exists = await _context.WishlistsNew.AnyAsync(wi => wi.UserId == customer.CustomerId && wi.ProductId == productId);
                    if (!exists) {
                        _context.WishlistsNew.Add(new WishlistNew { UserId = customer.CustomerId, ProductId = productId, CreatedAt = DateTime.Now });
                        await _context.SaveChangesAsync();
                    }
                    return Json(new { success = true, message = "Đã thêm vào yêu thích" });
                }
            }

            // GUEST ADD
            var items = GetGuestWishlistItems();
            if (!items.Contains(productId)) {
                items.Add(productId);
                SaveGuestWishlistItems(items);
            }
            return Json(new { success = true, message = "Đã thêm vào yêu thích" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Remove([FromBody] WishlistRequest req)
        {
            if (req == null) return Json(new { success = false });
            
            var userId = _userManager.GetUserId(User);
            if (userId != null)
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer != null)
                {
                    var item = await _context.WishlistsNew.FirstOrDefaultAsync(wi => wi.UserId == customer.CustomerId && wi.ProductId == req.ProductId);
                    if (item != null) { _context.WishlistsNew.Remove(item); await _context.SaveChangesAsync(); }
                    return Json(new { success = true });
                }
            }

            // GUEST REMOVE
            var items = GetGuestWishlistItems();
            items.Remove(req.ProductId);
            SaveGuestWishlistItems(items);
            return Json(new { success = true });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Clear()
        {
            var userId = _userManager.GetUserId(User);
            if (userId != null)
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer != null)
                {
                    var items = _context.WishlistsNew.Where(wi => wi.UserId == customer.CustomerId);
                    _context.WishlistsNew.RemoveRange(items);
                    await _context.SaveChangesAsync();
                }
            }
            SaveGuestWishlistItems(new List<int>());
            return Json(new { success = true });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddToCart([FromBody] WishlistRequest req)
        {
            if (req == null) return Json(new { success = false });

            var variant = await _context.ProductVariants.FirstOrDefaultAsync(v => v.ProductId == req.ProductId && v.StockQuantity > 0);
            if (variant == null) return Json(new { success = false, message = "Hết hàng" });
            
            var userId = _userManager.GetUserId(User) ?? Request.Cookies["MotoShop_GuestId"] ?? Guid.NewGuid().ToString();
            var success = await _cartService.AddToCartAsync(userId, variant.ProductVariantId, req.Quantity);
            return Json(new { success = success, cartCount = await _cartService.GetCartCountAsync(userId) });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddAllToCart()
        {
            var userId = _userManager.GetUserId(User) ?? Request.Cookies["MotoShop_GuestId"] ?? Guid.NewGuid().ToString();
            var items = new List<int>();

            var identityId = _userManager.GetUserId(User);
            if (identityId != null) {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == identityId);
                if (customer != null) {
                    items = await _context.WishlistsNew.Where(wi => wi.UserId == customer.CustomerId).Select(wi => wi.ProductId).ToListAsync();
                }
            } else {
                items = GetGuestWishlistItems();
            }

            int added = 0;
            foreach (var pId in items) {
                var variant = await _context.ProductVariants.FirstOrDefaultAsync(v => v.ProductId == pId && v.StockQuantity > 0);
                if (variant != null) {
                    await _cartService.AddToCartAsync(userId, variant.ProductVariantId, 1);
                    added++;
                }
            }
            return Json(new { success = true, added = added, cartCount = await _cartService.GetCartCountAsync(userId) });
        }

        public class WishlistRequest { public int ProductId { get; set; } public int Quantity { get; set; } = 1; }
    }
}
