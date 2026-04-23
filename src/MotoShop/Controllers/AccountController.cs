using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Models.ViewModels;
using System.Threading.Tasks;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Identity.UI.Services;
using System;
using MotoShop.Business.Interfaces;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using Microsoft.AspNetCore.Http;
using System.IO;
using System.Collections.Generic;
using System.Text.Json;

namespace MotoShop.Controllers
{
    public class AccountController : Controller
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IMemoryCache _cache;
        private readonly IEmailSender _emailSender;
        private readonly ICartService _cartService;
        private readonly MotoShopDbContext _context;

        public AccountController(
            SignInManager<IdentityUser> signInManager, 
            UserManager<IdentityUser> userManager,
            IMemoryCache cache,
            IEmailSender emailSender,
            ICartService cartService,
            MotoShopDbContext context)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _cache = cache;
            _emailSender = emailSender;
            _cartService = cartService;
            _context = context;
        }

        [HttpGet]
        public IActionResult Login(string? returnUrl = null)
        {
            if (_signInManager.IsSignedIn(User)) return RedirectToAction("Index", "Home");
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model, string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByEmailAsync(model.Email);
                if (user != null)
                {
                    var result = await _signInManager.PasswordSignInAsync(user.UserName!, model.Password, model.RememberMe, lockoutOnFailure: false);
                    if (result.Succeeded)
                    {
                        var currentCustomer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == user.Id);
                        if (currentCustomer == null)
                        {
                            currentCustomer = new Customer { 
                                UserId = user.Id, 
                                FullName = user.UserName ?? "Khách hàng",
                                Email = user.Email,
                                CreatedDate = DateTime.Now
                            };
                            _context.Customers.Add(currentCustomer);
                            await _context.SaveChangesAsync();
                        }

                        // 1. Sync Cart
                        string? guestCartId = Request.Cookies["MotoShop_GuestId"];
                        if (!string.IsNullOrEmpty(guestCartId))
                        {
                            await _cartService.SyncCartAsync(guestCartId, user.Id);
                            Response.Cookies.Delete("MotoShop_GuestId");
                        }

                        // 2. Sync Wishlist from Cookie
                        var wishlistCookie = Request.Cookies["MotoShop_Wishlist_Items"];
                        if (!string.IsNullOrEmpty(wishlistCookie))
                        {
                            try {
                                var guestProductIds = JsonSerializer.Deserialize<List<int>>(wishlistCookie);
                                if (guestProductIds != null && guestProductIds.Any()) {
                                    var wishlist = await _context.Wishlists.FirstOrDefaultAsync(w => w.CustomerId == currentCustomer.CustomerId);
                                    if (wishlist == null) {
                                        wishlist = new Wishlist { CustomerId = currentCustomer.CustomerId, CreatedDate = DateTime.Now };
                                        _context.Wishlists.Add(wishlist);
                                        await _context.SaveChangesAsync();
                                    }

                                    foreach (var pId in guestProductIds) {
                                        var exists = await _context.WishlistItems.AnyAsync(wi => wi.WishlistId == wishlist.WishlistId && wi.ProductId == pId);
                                        if (!exists) {
                                            _context.WishlistItems.Add(new WishlistItem { WishlistId = wishlist.WishlistId, ProductId = pId, CreatedDate = DateTime.Now });
                                        }
                                    }
                                    await _context.SaveChangesAsync();
                                }
                            } catch { }
                            Response.Cookies.Delete("MotoShop_Wishlist_Items");
                        }

                        if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl)) return Redirect(returnUrl);
                        return RedirectToAction("Index", "Home");
                    }
                }
                ModelState.AddModelError(string.Empty, "Email hoặc mật khẩu không chính xác.");
            }
            return View(model);
        }

        [HttpGet]
        public IActionResult Register()
        {
            if (_signInManager.IsSignedIn(User)) return RedirectToAction("Index", "Home");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = new IdentityUser { UserName = model.Email, Email = model.Email, PhoneNumber = model.PhoneNumber };
                var result = await _userManager.CreateAsync(user, model.Password);
                if (result.Succeeded)
                {
                    await _userManager.AddToRoleAsync(user, "Customer");
                    var customer = new Customer { UserId = user.Id, FullName = model.FullName, Email = model.Email, Phone = model.PhoneNumber, CreatedDate = DateTime.Now };
                    _context.Customers.Add(customer);
                    await _context.SaveChangesAsync();
                    await _signInManager.SignInAsync(user, isPersistent: false);
                    return Json(new { success = true, redirectUrl = "/" });
                }
            }
            return Json(new { success = false, message = "Lỗi đăng ký" });
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> Profile()
        {
            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.Include(c => c.Orders).FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return NotFound();

            var model = new ProfileViewModel
            {
                FullName = customer.FullName,
                Email = customer.Email ?? "",
                PhoneNumber = customer.Phone ?? "",
                AvatarUrl = customer.AvatarUrl,
                Address = customer.Address,
                PendingOrders = customer.Orders.Count(o => o.Status == "DangXuLy" || o.Status == "Pending"),
                ShippingOrders = customer.Orders.Count(o => o.Status == "DangGiao" || o.Status == "Shipping"),
                CompletedOrders = customer.Orders.Count(o => o.Status == "DaHoanThanh" || o.Status == "Completed")
            };
            return View(model);
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateProfile(ProfileViewModel model)
        {
            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer != null) {
                customer.FullName = model.FullName;
                customer.Phone = model.PhoneNumber;
                customer.Address = model.Address;
                await _context.SaveChangesAsync();
                return Json(new { success = true });
            }
            return Json(new { success = false });
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid) return Json(new { success = false });
            var user = await _userManager.GetUserAsync(User);
            var result = await _userManager.ChangePasswordAsync(user!, model.CurrentPassword, model.NewPassword);
            return Json(new { success = result.Succeeded });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout(string? returnUrl = null)
        {
            await _signInManager.SignOutAsync();
            return RedirectToAction("Index", "Home");
        }
    }
}
