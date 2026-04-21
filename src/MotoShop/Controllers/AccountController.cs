using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Models.ViewModels;
using System.Threading.Tasks;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Identity.UI.Services;
using System;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using System.Linq;

namespace MotoShop.Controllers
{
    public class AccountController : Controller
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IMemoryCache _cache;
        private readonly IEmailSender _emailSender;
        private readonly IUnitOfWork _unitOfWork;
        private readonly ICartService _cartService;

        public AccountController(
            SignInManager<IdentityUser> signInManager, 
            UserManager<IdentityUser> userManager,
            IMemoryCache cache,
            IEmailSender emailSender,
            IUnitOfWork unitOfWork)
            IEmailSender emailSender,
            ICartService cartService)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _cache = cache;
            _emailSender = emailSender;
            _unitOfWork = unitOfWork;
            _cartService = cartService;
        }

        [HttpGet]
        public IActionResult Login(string returnUrl = null)
        {
            if (_signInManager.IsSignedIn(User)) return RedirectToAction("Index", "Home");
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model, string returnUrl = null)
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
                        // Hợp nhất giỏ hàng ngay sau khi đăng nhập thành công
                        if (Request.Cookies.ContainsKey("GuestId"))
                        {
                            var guestId = Request.Cookies["GuestId"];
                            await _cartService.SyncCartAsync(guestId, user.Id);
                            Response.Cookies.Delete("GuestId");
                        }

                        if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                        {
                            return Redirect(returnUrl);
                        }

                        if (await _userManager.IsInRoleAsync(user, "Admin"))
                        {
                            return RedirectToAction("Index", "Home", new { area = "Admin" });
                        }
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

            // 1. Kiểm tra OTP từ Cache
            if (!_cache.TryGetValue($"OTP_{model.Email}", out string cachedOtp))
            {
                return Json(new { success = false, message = "Mã xác nhận đã hết hạn. Vui lòng gửi lại mã." });
            }

            if (cachedOtp != model.VerificationCode)
            {
                return Json(new { success = false, message = "Mã xác nhận không chính xác." });
            }

            // 2. Tạo User
            var user = new IdentityUser { 
                UserName = model.Email, 
                Email = model.Email, 
                PhoneNumber = model.PhoneNumber 
            };

            var result = await _userManager.CreateAsync(user, model.Password);

            if (result.Succeeded)
            {
                // Xóa OTP sau khi sử dụng thành công
                _cache.Remove($"OTP_{model.Email}");

                await _userManager.AddToRoleAsync(user, "Customer");
                
                // Đồng thời tạo bản ghi Customer trong MotoShop DB
                var customer = new Customer
                {
                    UserId = user.Id,
                    FullName = model.FullName,
                    Email = model.Email,
                    Phone = model.PhoneNumber,
                    CreatedDate = DateTime.Now
                };
                await _unitOfWork.Repository<Customer>().AddAsync(customer);
                await _unitOfWork.CompleteAsync();

                await _signInManager.SignInAsync(user, isPersistent: false);
                return Json(new { success = true, message = "Chào mừng bạn gia nhập MotoShop!", redirectUrl = Url.Action("Index", "Home") });
            }

            var identityErrors = string.Join("<br/>", result.Errors.Select(e => e.Description));
            return Json(new { success = false, message = identityErrors });
        }

        [HttpPost]
        public async Task<IActionResult> SendOtp([FromBody] OtpRequest model)
        {
            if (string.IsNullOrEmpty(model.Email))
            {
                return Json(new { success = false, message = "Vui lòng cung cấp Email." });
            }

            // Kiểm tra Email đã tồn tại chưa
            var existingUser = await _userManager.FindByEmailAsync(model.Email);
            if (existingUser != null)
            {
                return Json(new { success = false, message = "Email này đã được sử dụng bởi một tài khoản khác." });
            }

            // Tạo mã OTP 6 số ngẫu nhiên
            var otp = new Random().Next(100000, 999999).ToString();

            // Lưu vào Cache trong 5 phút
            _cache.Set($"OTP_{model.Email}", otp, TimeSpan.FromMinutes(5));

            try
            {
                // Gửi Mail qua IEmailSender
                await _emailSender.SendEmailAsync(model.Email, "Mã xác nhận đăng ký tài khoản MotoShop", 
                    $"Chào bạn,<br/><br/>Mã xác nhận (OTP) của bạn là: <b>{otp}</b><br/>Mã này có hiệu lực trong 5 phút.<br/><br/>Trân trọng,<br/>Đội ngũ MotoShop.");

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                // Có thể log lỗi ở đây
                return Json(new { success = false, message = "Không thể gửi email. Vui lòng kiểm tra lại cấu hình SMTP." });
            }
        }

        public class OtpRequest
        {
            public string Email { get; set; } = string.Empty;
        }

        [HttpGet]
        public IActionResult ForgotPassword()
        {
            return View();
        }

        [HttpGet]
        public IActionResult ResetPassword()
        {
            return View();
        }

        [HttpGet]
        [Microsoft.AspNetCore.Authorization.Authorize]
        public async Task<IActionResult> Profile()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return RedirectToAction("Login");

            var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == user.Id).FirstOrDefaultAsync();
            
            // Nếu chưa có bản ghi Customer (cho các user cũ), hãy tạo mới
            if (customer == null)
            {
                customer = new Customer
                {
                    UserId = user.Id,
                    FullName = user.UserName ?? "Khách hàng",
                    Email = user.Email,
                    Phone = user.PhoneNumber,
                    CreatedDate = DateTime.Now
                };
                await _unitOfWork.Repository<Customer>().AddAsync(customer);
                await _unitOfWork.CompleteAsync();
            }

            var orders = await _unitOfWork.Repository<Order>().Find(o => o.CustomerId == customer.CustomerId).ToListAsync();

            var model = new ProfileViewModel
            {
                Email = user.Email ?? "",
                PhoneNumber = customer.Phone ?? user.PhoneNumber ?? "",
                FullName = customer.FullName ?? user.UserName ?? "",
                Address = customer.Address,
                AvatarUrl = null,
                PendingOrders = orders.Count(o => o.Status == "Pending"),
                ShippingOrders = orders.Count(o => o.Status == "Shipping"),
                CompletedOrders = orders.Count(o => o.Status == "Completed")
            };

            return View(model);
        }

        [HttpPost]
        [Microsoft.AspNetCore.Authorization.Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateProfile(ProfileViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return Json(new { success = false, message = "Dữ liệu không hợp lệ." });
            }

            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Json(new { success = false, message = "Phiên đăng nhập hết hạn." });

            var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == user.Id).FirstOrDefaultAsync();
            if (customer == null)
            {
                customer = new Customer { UserId = user.Id };
                await _unitOfWork.Repository<Customer>().AddAsync(customer);
            }

            customer.FullName = model.FullName;
            customer.Phone = model.PhoneNumber;
            customer.Address = model.Address;

            user.PhoneNumber = model.PhoneNumber;

            _unitOfWork.Repository<Customer>().Update(customer);
            await _userManager.UpdateAsync(user);
            
            var result = await _unitOfWork.CompleteAsync();

            return Json(new { success = true, message = "Cập nhật hồ sơ thành công!" });
        }

        [HttpGet]
        [Microsoft.AspNetCore.Authorization.Authorize]
        public async Task<IActionResult> Orders(string? status)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return RedirectToAction("Login");

            var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == user.Id).FirstOrDefaultAsync();
            if (customer == null) return View(new List<Order>());

            var query = _unitOfWork.Repository<Order>().Find(o => o.CustomerId == customer.CustomerId);
            
            if (!string.IsNullOrEmpty(status) && status != "All")
            {
                query = query.Where(o => o.Status == status);
            }

            var orders = await query
                .Include(o => o.OrderItems)
                    .ThenInclude(i => i.ProductVariant)
                        .ThenInclude(v => v.Product)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            ViewBag.CurrentStatus = status ?? "All";
            return View(orders);
        }

        [HttpGet]
        [Microsoft.AspNetCore.Authorization.Authorize]
        public IActionResult AddressBook()
        {
            return View();
        }

        [HttpGet]
        [Microsoft.AspNetCore.Authorization.Authorize]
        public IActionResult ChangePassword()
        {
            return View();
        }

        [HttpPost]
        [Microsoft.AspNetCore.Authorization.Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword(ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var errors = string.Join("<br/>", ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage));
                return Json(new { success = false, message = errors });
            }

            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Json(new { success = false, message = "Phiên đăng nhập hết hạn." });

            var result = await _userManager.ChangePasswordAsync(user, model.CurrentPassword, model.NewPassword);

            if (result.Succeeded)
            {
                await _signInManager.RefreshSignInAsync(user);
                return Json(new { success = true, message = "Đổi mật khẩu thành công!" });
            }

            var identityErrors = string.Join("<br/>", result.Errors.Select(e => e.Description));
            return Json(new { success = false, message = identityErrors });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout(string returnUrl = null)
        {
            await _signInManager.SignOutAsync();
            if (!string.IsNullOrEmpty(returnUrl))
                return Redirect(returnUrl);

            return RedirectToAction("Index", "Home");
        }
    }
}
