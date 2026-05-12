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
using Microsoft.AspNetCore.Hosting;
using System.Security.Claims;

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
        private readonly IWebHostEnvironment _webHostEnvironment;

        public AccountController(
            SignInManager<IdentityUser> signInManager, 
            UserManager<IdentityUser> userManager,
            IMemoryCache cache,
            IEmailSender emailSender,
            ICartService cartService,
            MotoShopDbContext context,
            IWebHostEnvironment webHostEnvironment)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _cache = cache;
            _emailSender = emailSender;
            _cartService = cartService;
            _context = context;
            _webHostEnvironment = webHostEnvironment;
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
                    var result = await _signInManager.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, lockoutOnFailure: true);
                    if (result.Succeeded)
                    {
                        var currentCustomer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == user.Id);
                        if (currentCustomer == null)
                        {
                            currentCustomer = new Customer { UserId = user.Id, FullName = user.UserName ?? "Khách hàng", Email = user.Email, CreatedDate = DateTime.Now };
                            _context.Customers.Add(currentCustomer);
                            await _context.SaveChangesAsync();
                        }

                        // --- 1. ĐỒNG BỘ GIỎ HÀNG ---
                        string? guestCartId = Request.Cookies["MotoShop_GuestId"];
                        if (!string.IsNullOrEmpty(guestCartId))
                        {
                            await _cartService.SyncCartAsync(guestCartId, user.Id);
                            Response.Cookies.Delete("MotoShop_GuestId");
                        }

                        // --- 2. ĐỒNG BỘ YÊU THÍCH ---
                        var wishlistCookie = Request.Cookies["MotoShop_Wishlist_Items"];
                        if (!string.IsNullOrEmpty(wishlistCookie))
                        {
                            try {
                                var guestProductIds = JsonSerializer.Deserialize<List<int>>(wishlistCookie);
                                if (guestProductIds != null && guestProductIds.Any()) {
                                    foreach (var pId in guestProductIds) {
                                        var exists = await _context.WishlistsNew.AnyAsync(w => w.UserId == currentCustomer.CustomerId && w.ProductId == pId);
                                        if (!exists) {
                                            _context.WishlistsNew.Add(new WishlistNew { UserId = currentCustomer.CustomerId, ProductId = pId, CreatedAt = DateTime.Now });
                                        }
                                    }
                                    await _context.SaveChangesAsync();
                                }
                            } catch { }
                            Response.Cookies.Delete("MotoShop_Wishlist_Items");
                        }

                        string redirectUrl = (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl)) ? returnUrl : Url.Action("Index", "Home") ?? "/";
                        
                        // Kiểm tra nếu là Admin thì đưa vào trang quản trị
                        if (await _userManager.IsInRoleAsync(user, "Admin"))
                        {
                            redirectUrl = Url.Action("Index", "Home", new { area = "Admin" }) ?? "/Admin";
                        }

                        return Json(new { 
                            success = true, 
                            message = "Chào mừng bạn quay trở lại MotoShop!", 
                            redirectUrl = redirectUrl 
                        });
                    }
                }
                return Json(new { success = false, message = "Email hoặc mật khẩu không chính xác." });
            }
            return Json(new { success = false, message = "Vui lòng nhập đầy đủ thông tin." });
        }

        [HttpGet]
        public IActionResult Register()
        {
            if (_signInManager.IsSignedIn(User)) return RedirectToAction("Index", "Home");
            return View();
        }

        [HttpGet]
        public IActionResult ForgotPassword()
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
        public IActionResult Index() => RedirectToAction("Profile");

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> Profile()
        {
            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers
                .Include(c => c.Orders)
                .Include(c => c.CustomerAddresses)
                .FirstOrDefaultAsync(c => c.UserId == userId);
            
            if (customer == null) return NotFound();

            // Thống kê đơn hàng chi tiết hơn
            ViewBag.TotalOrders = customer.Orders.Count;
            ViewBag.Pending = customer.Orders.Count(o => o.Status == "DangXuLy" || o.Status == "Pending" || o.Status == "Processing");
            ViewBag.Shipping = customer.Orders.Count(o => o.Status == "DangGiao" || o.Status == "Shipping");
            ViewBag.Completed = customer.Orders.Count(o => o.Status == "DaHoanThanh" || o.Status == "Completed");
            ViewBag.TotalSpent = customer.Orders.Where(o => o.Status == "DaHoanThanh" || o.Status == "Completed").Sum(o => o.TotalAmount);

            return View(customer);
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateProfile(string fullName, string phone, string email, string address)
        {
            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer != null) {
                customer.FullName = fullName;
                customer.Phone = phone;
                customer.Email = email;
                customer.Address = address;
                await _context.SaveChangesAsync();
                return Json(new { success = true });
            }
            return Json(new { success = false });
        }

        [HttpGet]
        [Authorize]
        public IActionResult AddressBook() => RedirectToAction("Index", "Address");

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> Wishlist()
        {
            var userId = _userManager.GetUserId(User);
            if (userId == null) return RedirectToAction("Login");

            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return NotFound();

            var wishlistItems = await _context.WishlistsNew
                .Where(w => w.UserId == customer.CustomerId)
                .Include(w => w.Product).ThenInclude(p => p!.Brand)
                .Include(w => w.Product).ThenInclude(p => p!.Variants)
                .Include(w => w.Product).ThenInclude(p => p!.Images)
                .OrderByDescending(w => w.CreatedAt)
                .ToListAsync();

            ViewBag.Customer = customer;
            return View(wishlistItems);
        }

        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> ToggleWishlist([FromBody] WishlistRequest request)
        {
            bool added = false;

            // NẾU ĐÃ ĐĂNG NHẬP -> Lưu vào Database
            if (_signInManager.IsSignedIn(User))
            {
                var userId = _userManager.GetUserId(User);
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer == null) return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng" });

                var wishItem = await _context.WishlistsNew
                    .FirstOrDefaultAsync(w => w.UserId == customer.CustomerId && w.ProductId == request.ProductId);

                if (wishItem != null)
                {
                    _context.WishlistsNew.Remove(wishItem);
                }
                else
                {
                    _context.WishlistsNew.Add(new WishlistNew
                    {
                        UserId = customer.CustomerId,
                        ProductId = request.ProductId,
                        CreatedAt = DateTime.Now
                    });
                    added = true;
                }
                await _context.SaveChangesAsync();
            }
            else
            {
                // NẾU CHƯA ĐĂNG NHẬP -> Lưu vào Session Cookie (Tự xóa khi đóng trình duyệt)
                var wishlistCookie = Request.Cookies["MotoShop_Wishlist_Items"];
                List<int> productIds = new List<int>();
                if (!string.IsNullOrEmpty(wishlistCookie))
                {
                    try { productIds = JsonSerializer.Deserialize<List<int>>(wishlistCookie) ?? new List<int>(); } catch { }
                }

                if (productIds.Contains(request.ProductId))
                {
                    productIds.Remove(request.ProductId);
                }
                else
                {
                    productIds.Add(request.ProductId);
                    added = true;
                }

                // KHÔNG đặt Expires -> Cookie này sẽ biến mất khi đóng trình duyệt
                var cookieOptions = new CookieOptions { 
                    HttpOnly = true, 
                    SameSite = SameSiteMode.Lax,
                    Secure = true 
                };
                Response.Cookies.Append("MotoShop_Wishlist_Items", JsonSerializer.Serialize(productIds), cookieOptions);
            }

            return Json(new { success = true, added = added });
        }

        public class WishlistRequest
        {
            public int ProductId { get; set; }
        }

        [HttpGet]
        [Authorize]
        public IActionResult ChangePassword() => View();

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid) return Json(new { success = false, message = "Dữ liệu không hợp lệ" });
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Json(new { success = false });
            
            var result = await _userManager.ChangePasswordAsync(user, model.CurrentPassword, model.NewPassword);
            if (result.Succeeded) {
                await _signInManager.RefreshSignInAsync(user);
                return Json(new { success = true, message = "Đổi mật khẩu thành công" });
            }
            return Json(new { success = false, message = result.Errors.FirstOrDefault()?.Description });
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UploadAvatar(IFormFile file)
        {
            if (file == null || file.Length == 0) return Json(new { success = false, message = "Không có tệp được chọn" });

            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return Json(new { success = false });

            try
            {
                var uploads = Path.Combine(_webHostEnvironment.WebRootPath, "uploads", "avatars");
                if (!Directory.Exists(uploads)) Directory.CreateDirectory(uploads);

                var fileName = $"avatar_{customer.CustomerId}_{DateTime.Now.Ticks}{Path.GetExtension(file.FileName)}";
                var filePath = Path.Combine(uploads, fileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                }

                customer.AvatarUrl = $"/uploads/avatars/{fileName}";
                await _context.SaveChangesAsync();

                return Json(new { success = true, avatarUrl = customer.AvatarUrl });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ExternalLogin(string provider, string? returnUrl = null)
        {
            var redirectUrl = Url.Action("ExternalLoginCallback", "Account", new { returnUrl });
            var properties = _signInManager.ConfigureExternalAuthenticationProperties(provider, redirectUrl);
            return Challenge(properties, provider);
        }

        [HttpGet]
        public async Task<IActionResult> ExternalLoginCallback(string? returnUrl = null, string? remoteError = null)
        {
            if (remoteError != null)
            {
                TempData["Error"] = $"Lỗi từ {remoteError}.";
                return RedirectToAction("Login");
            }

            var info = await _signInManager.GetExternalLoginInfoAsync();
            if (info == null) return RedirectToAction("Login");

            var result = await _signInManager.ExternalLoginSignInAsync(info.LoginProvider, info.ProviderKey, isPersistent: false, bypassTwoFactor: true);
            if (result.Succeeded)
            {
                var existingUser = await _userManager.FindByLoginAsync(info.LoginProvider, info.ProviderKey);
                if (existingUser != null) await EnsureCustomerAsync(existingUser, info);
                return RedirectToLocal(returnUrl);
            }

            var email = info.Principal.FindFirstValue(ClaimTypes.Email);
            if (string.IsNullOrEmpty(email))
            {
                var nameIdentifier = info.Principal.FindFirstValue(ClaimTypes.NameIdentifier);
                email = $"fb_{nameIdentifier}@facebook.local";
            }

            var userByEmail = await _userManager.FindByEmailAsync(email);
            if (userByEmail != null)
            {
                await _userManager.AddLoginAsync(userByEmail, info);
                await _signInManager.SignInAsync(userByEmail, isPersistent: false);
                await EnsureCustomerAsync(userByEmail, info);
                return RedirectToLocal(returnUrl);
            }

            var newUser = new IdentityUser { UserName = email, Email = email, EmailConfirmed = true };
            var createResult = await _userManager.CreateAsync(newUser);
            if (createResult.Succeeded)
            {
                await _userManager.AddLoginAsync(newUser, info);
                await _userManager.AddToRoleAsync(newUser, "Customer");
                await EnsureCustomerAsync(newUser, info);
                await _signInManager.SignInAsync(newUser, isPersistent: false);
                return RedirectToLocal(returnUrl);
            }

            TempData["Error"] = "Không thể tạo tài khoản: " + string.Join(", ", createResult.Errors.Select(e => e.Description));
            return RedirectToAction("Login");
        }

        private async Task EnsureCustomerAsync(IdentityUser user, ExternalLoginInfo info)
        {
            var exists = await _context.Customers.AnyAsync(c => c.UserId == user.Id);
            if (!exists)
            {
                var name = info.Principal.FindFirstValue(ClaimTypes.Name) ?? user.Email ?? "Khách hàng";
                _context.Customers.Add(new Customer { UserId = user.Id, FullName = name, Email = user.Email, CreatedDate = DateTime.Now });
                await _context.SaveChangesAsync();
            }
        }

        private IActionResult RedirectToLocal(string? returnUrl)
        {
            if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                return Redirect(returnUrl);
            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout(string? returnUrl = null)
        {
            // --- 3. DỌN DẸP KHI ĐĂNG XUẤT (Clear Guest Data để giỏ hàng trống) ---
            Response.Cookies.Delete("MotoShop_GuestId");
            Response.Cookies.Delete("MotoShop_Wishlist_Items");
            
            await _signInManager.SignOutAsync();
            return RedirectToAction("Index", "Home");
        }
    }
}
