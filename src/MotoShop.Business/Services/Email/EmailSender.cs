using Microsoft.AspNetCore.Identity.UI.Services;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace MotoShop.Business.Services
{
    public class EmailSender : IEmailSender
    {
        private readonly IConfiguration _configuration;

        public EmailSender(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            // Lấy thông tin cấu hình từ appsettings.json
            var mail = _configuration.GetSection("SmtpSettings")["User"];
            var pw = _configuration.GetSection("SmtpSettings")["Pass"];
            var host = _configuration.GetSection("SmtpSettings")["Host"];
            var port = int.Parse(_configuration.GetSection("SmtpSettings")["Port"]);

            var client = new SmtpClient(host, port)
            {
                EnableSsl = true,
                Credentials = new NetworkCredential(mail, pw)
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress(mail, "MOTO SHOP"),
                Subject = subject,
                Body = htmlMessage,
                IsBodyHtml = true
            };
            mailMessage.To.Add(email);

            return client.SendMailAsync(mailMessage);
        }
    }
}