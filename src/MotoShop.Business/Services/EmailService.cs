using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using MotoShop.Business.Interfaces;

namespace MotoShop.Business.Services
{
    public class EmailService : IEmailService
    {
        private readonly IConfiguration _config;

        public EmailService(IConfiguration config)
        {
            _config = config;
        }

        public async Task SendEmailAsync(string toEmail, string subject, string message)
        {
            var smtpHost = _config["SmtpSettings:Host"];
            var smtpPort = int.Parse(_config["SmtpSettings:Port"] ?? "587");
            var smtpUser = _config["SmtpSettings:User"];
            var smtpPass = _config["SmtpSettings:Pass"];

            try
            {
                using (var client = new SmtpClient(smtpHost, smtpPort))
                {
                    client.EnableSsl = true;
                    client.UseDefaultCredentials = false; // Đảm bảo không dùng creds hệ thống
                    client.Credentials = new NetworkCredential(smtpUser, smtpPass);

                    var mailMessage = new MailMessage
                    {
                        From = new MailAddress(smtpUser!, "MotoShop Support"),
                        Subject = subject,
                        Body = message,
                        IsBodyHtml = true
                    };
                    mailMessage.To.Add(toEmail);

                    await client.SendMailAsync(mailMessage);
                    System.Console.WriteLine($"[EMAIL SUCCESS] Đã gửi mail tới: {toEmail}");
                }
            }
            catch (System.Exception ex)
            {
                System.Console.WriteLine($"[EMAIL ERROR] Lỗi gửi mail tới {toEmail}: {ex.Message}");
                if (ex.InnerException != null) 
                    System.Console.WriteLine($"[EMAIL ERROR DETAIL] {ex.InnerException.Message}");
            }
        }

        public async Task SendPromotionEmailAsync(string toEmail, string promotionName, string description, string startDate, string endDate)
        {
            string htmlContent = $@"
                <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #eee; border-radius: 10px; overflow: hidden;'>
                    <div style='background: #E24B4A; color: white; padding: 20px; text-align: center;'>
                        <h1 style='margin: 0;'>MOTO SHOP</h1>
                        <p style='margin: 5px 0 0 0;'>Khuyến mãi cực hot dành riêng cho bạn!</p>
                    </div>
                    <div style='padding: 30px;'>
                        <h2 style='color: #333;'>🌟 {promotionName}</h2>
                        <p style='color: #666; line-height: 1.6;'>{description}</p>
                        <div style='background: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0;'>
                            <p style='margin: 5px 0;'><strong>📅 Bắt đầu:</strong> {startDate}</p>
                            <p style='margin: 5px 0;'><strong>📅 Kết thúc:</strong> {endDate}</p>
                        </div>
                        <div style='text-align: center; margin-top: 30px;'>
                            <a href='https://localhost:7106/Product/Promotion' style='background: #E24B4A; color: white; padding: 12px 25px; text-decoration: none; border-radius: 25px; font-weight: bold;'>XEM CHI TIẾT NGAY</a>
                        </div>
                    </div>
                    <div style='background: #f4f4f4; color: #999; padding: 15px; text-align: center; font-size: 12px;'>
                        <p>Bạn nhận được email này vì đã đăng ký nhận tin từ MotoShop.</p>
                        <p>© 2026 MotoShop - Hệ thống phụ tùng xe máy chính hãng.</p>
                    </div>
                </div>";

            await SendEmailAsync(toEmail, $"[MOTOSHOP] THÔNG BÁO KHUYẾN MÃI: {promotionName}", htmlContent);
        }
    }
}
