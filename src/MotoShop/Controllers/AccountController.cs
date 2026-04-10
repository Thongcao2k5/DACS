using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Models.ViewModels;
using System.Threading.Tasks;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Identity.UI.Services;
using System;

namespace MotoShop.Controllers
{
    public class AccountController : Controller
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IMemoryCache _cache;
        private readonly IEmailSender _emailSender;

        public AccountController(
            SignInManager<IdentityUser> signInManager, 
            UserManager<IdentityUser> userManager,
            IMemoryCache cache,
            IEmailSender emailSender)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _cache = cache;
            _emailSender = emailSender;
        }

        [HttpGet]
        public IActionResult Login()
        {
            if (_signInManager.IsSignedIn(User)) return RedirectToAction("Index", "Home");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByEmailAsync(model.Email);
                if (user != null)
                {
                    var result = await _signInManager.PasswordSignInAsync(user.UserName!, model.Password, model.RememberMe, lockoutOnFailure: false);
                    if (result.Succeeded)
                    {
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
        public IActionResult Profile()
        {
            if (!_signInManager.IsSignedIn(User)) return RedirectToAction("Login");
            return View();
        }

        [HttpGet]
        public IActionResult AddressBook()
        {
            if (!_signInManager.IsSignedIn(User)) return RedirectToAction("Login");
            return View();
        }

        [HttpGet]
        public IActionResult ChangePassword()
        {
            if (!_signInManager.IsSignedIn(User)) return RedirectToAction("Login");
            return View();
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

    