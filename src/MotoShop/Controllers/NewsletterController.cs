using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class NewsletterController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly MotoShop.Business.Interfaces.IEmailService _emailService;

        public NewsletterController(MotoShopDbContext context, MotoShop.Business.Interfaces.IEmailService emailService)
        {
            _context = context;
            _emailService = emailService;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Subscribe(string email)
        {
            if (string.IsNullOrEmpty(email) || !email.Contains("@"))
            {
                return Json(new { success = false, message = "Vui lòng nhập địa chỉ email hợp lệ!" });
            }

            try
            {
                var existed = await _context.Database.SqlQueryRaw<int>(
                    "SELECT 1 as Value FROM NewsletterSubscriptions WHERE Email = {0}", email
                ).ToListAsync();

                if (existed.Count > 0)
                {
                    return Json(new { success = false, message = "Email này đã được đăng ký nhận tin từ trước." });
                }

                string sql = "INSERT INTO NewsletterSubscriptions (Email, SubscribedAt, IsActive) VALUES ({0}, {1}, 1)";
                await _context.Database.ExecuteSqlRawAsync(sql, email, DateTime.Now);

                // GỬI EMAIL XÁC NHẬN NGAY LẬP TỨC
                await _emailService.SendEmailAsync(email, "[MOTOSHOP] ĐĂNG KÝ NHẬN TIN THÀNH CÔNG", 
                    "<h3>Chào bạn,</h3><p>Cảm ơn bạn đã đăng ký nhận tin khuyến mãi tại <b>MotoShop</b>. Chúng tôi sẽ gửi đến bạn những ưu đãi mới nhất và sớm nhất!</p>");

                return Json(new { success = true, message = "Đã cập nhật email thành công! Bạn sẽ nhận được các thông báo khuyến mãi mới nhất." });
            }
            catch (Exception)
            {
                return Json(new { success = false, message = "Có lỗi xảy ra. Vui lòng thử lại sau." });
            }
        }
    }
}
