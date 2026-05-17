using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using MotoShop.Business.DTOs;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace MotoShop.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountApiController : ControllerBase
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IEmailSender _emailSender;
        private readonly IMemoryCache _cache;
        private readonly MotoShopDbContext _context;
        private readonly ILogger<AccountApiController> _logger;

        public AccountApiController(
            UserManager<IdentityUser> userManager,
            IEmailSender emailSender,
            IMemoryCache cache,
            MotoShopDbContext context,
            ILogger<AccountApiController> logger)
        {
            _userManager = userManager;
            _emailSender = emailSender;
            _cache = cache;
            _context = context;
            _logger = logger;
        }

        private class RegistrationCache
        {
            public required RegisterInitialDto Model { get; set; }
            public required string Code { get; set; }
        }

        [HttpPost("register-step1")]
        public async Task<IActionResult> RegisterStep1([FromBody] RegisterInitialDto model)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var userExists = await _userManager.FindByEmailAsync(model.Email);
            if (userExists != null)
                return BadRequest(new { message = "Email này đã được sử dụng." });

            // Tạo mã OTP ngẫu nhiên 6 chữ số
            string otpCode = RandomNumberGenerator.GetInt32(100000, 1000000).ToString();

            // Lưu thông tin đăng ký và mã OTP vào Cache (hết hạn sau 10 phút)
            var cacheKey = $"Reg_{model.Email}";
            _cache.Set(cacheKey, new RegistrationCache { Model = model, Code = otpCode }, TimeSpan.FromMinutes(10));

            // Gửi Email
            string subject = "Mã xác nhận đăng ký tài khoản MotoShop";
            string message = $@"
                <div style='font-family: Arial, sans-serif; border: 1px solid #ddd; padding: 20px; max-width: 600px;'>
                    <div style='text-align: center; margin-bottom: 20px;'>
                        <h1 style='color: #d9534f; margin: 0;'>MOTO SHOP</h1>
                        <p style='color: #777; margin: 5px 0 0;'>Chuyên phụ tùng & dịch vụ xe máy</p>
                    </div>
                    <div style='background-color: #fff; border-radius: 8px;'>
                        <h2 style='color: #333;'>Xác nhận đăng ký tài khoản</h2>
                        <p>Chào bạn <b>{model.FullName}</b>,</p>
                        <p>Cảm ơn bạn đã quan tâm và đăng ký tài khoản tại MotoShop. Để hoàn tất quá trình đăng ký, vui lòng sử dụng mã xác nhận dưới đây:</p>
                        <div style='background: #f8f9fa; border: 2px dashed #d9534f; padding: 20px; text-align: center; margin: 25px 0;'>
                            <span style='font-size: 32px; font-weight: bold; letter-spacing: 10px; color: #d9534f;'>{otpCode}</span>
                        </div>
                        <p>Mã này có hiệu lực trong vòng <b>10 phút</b>. Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>
                        <br/>
                        <p>Trân trọng,<br/>Đội ngũ MotoShop</p>
                    </div>
                    <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'/>
                    <p style='font-size: 11px; color: #aaa; text-align: center;'>Email này được gửi tự động từ hệ thống MotoShop. Vui lòng không trả lời trực tiếp vào email này.</p>
                </div>";

            try
            {
                await _emailSender.SendEmailAsync(model.Email, subject, message);
                return Ok(new { success = true, message = "Mã xác nhận đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư (và cả hòm thư rác)." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "RegisterStep1: Failed to send OTP to {Email}. Cause: {Error}", model.Email, ex.Message);
                return StatusCode(500, new { message = "Không thể gửi email. Vui lòng kiểm tra lại địa chỉ email hoặc thử lại sau.", error = ex.Message });
            }
        }

        [HttpPost("verify-otp")]
        public async Task<IActionResult> VerifyOtp([FromBody] VerifyRegisterDto model)
        {
            var cacheKey = $"Reg_{model.Email}";
            if (!_cache.TryGetValue(cacheKey, out RegistrationCache? cachedData) || cachedData == null)
            {
                return BadRequest(new { message = "Phiên làm việc đã hết hạn hoặc không tồn tại. Vui lòng thực hiện lại bước đăng ký." });
            }

            if (cachedData.Code != model.Code)
            {
                return BadRequest(new { message = "Mã xác nhận không chính xác. Vui lòng kiểm tra lại." });
            }

            // Dữ liệu đúng, tiến hành tạo User
            RegisterInitialDto regModel = cachedData.Model;

            // Dùng CreateExecutionStrategy vì DbContext được cấu hình EnableRetryOnFailure
            // (SqlServerRetryingExecutionStrategy không cho phép BeginTransaction trực tiếp)
            string? resultMessage = null;
            bool succeeded = false;

            var strategy = _context.Database.CreateExecutionStrategy();
            try
            {
                await strategy.ExecuteAsync(
                    state: 0,
                    operation: async (dbContext, state, ct) =>
                    {
                        using var transaction = await _context.Database.BeginTransactionAsync(ct);
                        try
                        {
                            var user = new IdentityUser { UserName = regModel.Email, Email = regModel.Email };
                            var result = await _userManager.CreateAsync(user, regModel.Password);

                            if (!result.Succeeded)
                            {
                                resultMessage = string.Join(" ", result.Errors.Select(e => e.Description));
                                _logger.LogWarning("VerifyOtp: CreateUser failed for {Email}: {Errors}", regModel.Email, resultMessage);
                                await transaction.RollbackAsync();
                                return false;
                            }

                            await _userManager.AddToRoleAsync(user, "Customer");

                            _context.Customers.Add(new Customer
                            {
                                UserId      = user.Id,
                                FullName    = regModel.FullName,
                                Email       = regModel.Email,
                                CreatedDate = DateTime.Now
                            });
                            await _context.SaveChangesAsync(ct);
                            await transaction.CommitAsync(ct);

                            succeeded = true;
                            return true;
                        }
                        catch
                        {
                            await transaction.RollbackAsync();
                            throw;
                        }
                    },
                    verifySucceeded: null);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "VerifyOtp: Unexpected error for {Email}: {Error}", regModel.Email, ex.Message);
                return StatusCode(500, new { message = "Có lỗi xảy ra trong quá trình xử lý.", error = ex.Message });
            }

            if (!succeeded)
                return BadRequest(new { message = resultMessage ?? "Đăng ký không thành công." });

            _cache.Remove(cacheKey);
            return Ok(new { success = true, message = "Đăng ký tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ." });
        }

        [HttpPost("forgot-password-step1")]
        public async Task<IActionResult> ForgotPasswordStep1([FromBody] ForgotInitialDto model)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
                return BadRequest(new { message = "Email không tồn tại trong hệ thống." });

            string otpCode = RandomNumberGenerator.GetInt32(100000, 1000000).ToString();
            var cacheKey = $"Forgot_{model.Email}";
            _cache.Set(cacheKey, otpCode, TimeSpan.FromMinutes(10));

            string subject = "Mã xác nhận khôi phục mật khẩu MotoShop";
            string message = $@"
                <div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #eee;'>
                    <h2 style='color: #d9534f;'>Yêu cầu khôi phục mật khẩu</h2>
                    <p>Chào bạn,</p>
                    <p>Bạn đã yêu cầu khôi phục mật khẩu cho tài khoản MotoShop. Mã xác nhận của bạn là:</p>
                    <div style='background: #f4f4f4; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; color: #d9534f;'>
                        {otpCode}
                    </div>
                    <p>Mã này có hiệu lực trong 10 phút. Nếu bạn không thực hiện yêu cầu này, hãy bỏ qua email này.</p>
                </div>";

            try
            {
                await _emailSender.SendEmailAsync(model.Email, subject, message);
                return Ok(new { success = true, message = "Mã xác nhận đã được gửi đến email." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ForgotPasswordStep1: Failed to send OTP to {Email}. Cause: {Error}", model.Email, ex.Message);
                return StatusCode(500, new { message = "Không thể gửi email. Vui lòng thử lại sau.", error = ex.Message });
            }
        }

        [HttpPost("verify-forgot-otp")]
        public async Task<IActionResult> VerifyForgotOtp([FromBody] VerifyRegisterDto model)
        {
            await Task.CompletedTask;
            var cacheKey = $"Forgot_{model.Email}";
            if (!_cache.TryGetValue(cacheKey, out string? savedCode) || savedCode != model.Code)
                return BadRequest(new { message = "Mã xác nhận không chính xác hoặc đã hết hạn." });

            return Ok(new { success = true });
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDto model)
        {
            var cacheKey = $"Forgot_{model.Email}";
            if (!_cache.TryGetValue(cacheKey, out string? savedCode) || savedCode != model.Code)
                return BadRequest(new { message = "Phiên làm việc đã hết hạn. Vui lòng thực hiện lại từ đầu." });

            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null) return BadRequest(new { message = "Người dùng không tồn tại." });

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var result = await _userManager.ResetPasswordAsync(user, token, model.NewPassword);

            if (result.Succeeded)
            {
                _cache.Remove(cacheKey);
                return Ok(new { success = true, message = "Mật khẩu đã được cập nhật thành công!" });
            }

            return BadRequest(new { message = "Cập nhật mật khẩu thất bại.", errors = result.Errors });
        }
    }
}
