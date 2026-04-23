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
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;
using System.IO;

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
                        // ĐẢM BẢO LUÔN CÓ CUSTOMER RECORD (Sửa lỗi Address UserId = 0)
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

                        // 1. Lấy GuestId từ Cookie (Dùng đúng tên MotoShop_GuestId)
                        string? guestId = Request.Cookies["MotoShop_GuestId"];

                        if (!string.IsNullOrEmpty(guestId))
                        {
                            // 2. Đồng bộ Giỏ hàng
                            await _cartService.SyncCartAsync(guestId, user.Id);
                            
                            // 3. Đồng bộ Yêu thích (Wishlist) - Sử dụng mã băm INT để tìm Guest Wishlist
                            int guestInternalId = Math.Abs(guestId.GetHashCode());
                            var guestWishlist = await _context.WishlistsNew.Where(w => w.UserId == guestInternalId).ToListAsync();
                            
                            if (guestWishlist.Any())
                            {
                                if (currentCustomer != null)
                                {
                                    foreach (var item in guestWishlist)
                                    {
                                        var exists = await _context.WishlistsNew.AnyAsync(w => w.UserId == currentCustomer.CustomerId && w.ProductId == item.ProductId);
                                        if (!exists)
                                        {
                                            _context.WishlistsNew.Add(new WishlistNew { 
                                                UserId = currentCustomer.CustomerId, 
                                                ProductId = item.ProductId, 
                                                CreatedAt = DateTime.Now 
                                            });
                                        }
                                        _context.WishlistsNew.Remove(item);
                                    }
                                    await _context.SaveChangesAsync();
                                }
                            }

                            // 4. Dọn dẹp
                            Response.Cookies.Delete("MotoShop_GuestId");
                        }

                        if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                            return Redirect(returnUrl);

                        if (await _userManager.IsInRoleAsync(user, "Admin"))
                            return RedirectToAction("Index", "Home", new { area = "Admin" });
                        
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
            if (!ModelState.IsValid)
            {
                var errors = string.Join("<br/>", ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage));
                return Json(new { success = false, message = errors });
            }

            if (!_cache.TryGetValue($"OTP_{model.Email}", out string? cachedOtp))
                return Json(new { success = false, message = "Mã xác nhận đã hết hạn." });

            if (cachedOtp != model.VerificationCode)
                return Json(new { success = false, message = "Mã xác nhận không chính xác." });

            var user = new IdentityUser { UserName = model.Email, Email = model.Email, PhoneNumber = model.PhoneNumber };
            var result = await _userManager.CreateAsync(user, model.Password);

            if (result.Succeeded)
            {
                _cache.Remove($"OTP_{model.Email}");
                await _userManager.AddToRoleAsync(user, "Customer");
                await _signInManager.SignInAsync(user, isPersistent: false);
                return Json(new { success = true, message = "Đăng ký thành công!", redirectUrl = Url.Action("Index", "Home") });
            }

            return Json(new { success = false, message = result.Errors.FirstOrDefault()?.Description });
        }

        [HttpPost]
        public async Task<IActionResult> SendOtp([FromBody] OtpRequest model)
        {
            if (string.IsNullOrEmpty(model.Email)) return Json(new { success = false, message = "Vui lòng nhập Email." });

            var otp = new Random().Next(100000, 999999).ToString();
            _cache.Set($"OTP_{model.Email}", otp, TimeSpan.FromMinutes(5));

            try {
                await _emailSender.SendEmailAsync(model.Email, "Mã xác nhận MotoShop", $"Mã của bạn là: {otp}");
                return Json(new { success = true });
            } catch {
                return Json(new { success = false, message = "Không thể gửi email." });
            }
        }

        public class OtpRequest { public string Email { get; set; } = string.Empty; }

        // --- PROFILE ACTIONS ---

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> Profile()
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return RedirectToAction("Login");

            var customer = await _context.Customers
                .Include(c => c.Orders)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (customer == null) 
            {
                // Nếu User Identity tồn tại nhưng chưa có trong bảng Customers, tạo mới Profile rỗng
                var user = await _userManager.FindByIdAsync(userId);
                customer = new Customer { 
                    UserId = userId, 
                    FullName = user?.UserName ?? "Khách hàng",
                    Email = user?.Email,
                    CreatedDate = DateTime.Now
                };
                _context.Customers.Add(customer);
                await _context.SaveChangesAsync();
            }

            // Thống kê đơn hàng thật từ DB (PHẦN 1 - Query thống kê)
            ViewBag.Pending = customer.Orders.Count(o => o.Status == "DangXuLy" || o.Status == "Pending");
            ViewBag.Shipping = customer.Orders.Count(o => o.Status == "DangGiao" || o.Status == "Shipping");
            ViewBag.Completed = customer.Orders.Count(o => o.Status == "DaHoanThanh" || o.Status == "Completed");

            return View(customer);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateProfile(string fullName, string phone, string email, string address)
        {
            if (!System.Text.RegularExpressions.Regex.IsMatch(phone, @"^(0[3|5|7|8|9])+([0-9]{8})$"))
            {
                return Json(new { success = false, message = "Số điện thoại không đúng định dạng VN." });
            }

            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            
            if (customer != null) {
                customer.FullName = fullName;
                customer.Phone = phone;
                customer.Email = email;
                customer.Address = address; // Bổ sung cập nhật địa chỉ
                await _context.SaveChangesAsync();
                return Json(new { success = true });
            }
            return Json(new { success = false, message = "Không tìm thấy thông tin tài khoản." });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UploadAvatar(IFormFile file)
        {
            if (file == null || file.Length == 0) return Json(new { success = false });

            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return Json(new { success = false });

            var fileName = $"{customer.CustomerId}_avatar.jpg";
            var uploadDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads", "avatars");
            if (!Directory.Exists(uploadDir)) Directory.CreateDirectory(uploadDir);
            
            var filePath = Path.Combine(uploadDir, fileName);

            using (var image = await Image.LoadAsync(file.OpenReadStream())) {
                image.Mutate(x => x.Resize(new ResizeOptions { Size = new Size(200, 200), Mode = ResizeMode.Crop }));
                await image.SaveAsJpegAsync(filePath);
            }

            customer.AvatarUrl = $"/uploads/avatars/{fileName}";
            await _context.SaveChangesAsync();
            
            return Json(new { success = true, avatarUrl = customer.AvatarUrl });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage;
                return Json(new { success = false, message = error ?? "Dữ liệu không hợp lệ" });
            }

            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Json(new { success = false, message = "Không tìm thấy thông tin người dùng." });

            // 1. Kiểm tra mật khẩu hiện tại (dùng IdentityPasswordHasher nội bộ)
            var checkOld = await _userManager.CheckPasswordAsync(user, model.CurrentPassword);
            if (!checkOld)
            {
                return Json(new { success = false, message = "Mật khẩu hiện tại không đúng." });
            }

            // 2. Kiểm tra mật khẩu mới không được trùng mật khẩu cũ
            if (model.NewPassword == model.CurrentPassword)
            {
                return Json(new { success = false, message = "Mật khẩu mới không được trùng mật khẩu cũ." });
            }

            // 3. Thực hiện đổi mật khẩu
            var result = await _userManager.ChangePasswordAsync(user, model.CurrentPassword, model.NewPassword);
            if (result.Succeeded) 
            {
                await _signInManager.RefreshSignInAsync(user);
                return Json(new { success = true, message = "Đổi mật khẩu thành công" });
            }

            return Json(new { success = false, message = result.Errors.FirstOrDefault()?.Description ?? "Lỗi khi đổi mật khẩu" });
        }

        [HttpGet]
        public IActionResult AddressBook() => _signInManager.IsSignedIn(User) ? View() : RedirectToAction("Login");

        [HttpGet]
        public IActionResult ChangePassword() => _signInManager.IsSignedIn(User) ? View() : RedirectToAction("Login");

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout(string? returnUrl = null)
        {
            await _signInManager.SignOutAsync();
            return !string.IsNullOrEmpty(returnUrl) ? Redirect(returnUrl) : RedirectToAction("Index", "Home");
        }
    }
}
