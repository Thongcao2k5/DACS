using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace MotoShop.Business.Services
{
    public class EmailSender : IEmailSender
    {
        private readonly string _host;
        private readonly int    _port;
        private readonly string _user;
        private readonly string _pass;
        private readonly ILogger<EmailSender> _logger;

        public EmailSender(IConfiguration configuration, ILogger<EmailSender> logger)
        {
            _logger = logger;
            _host = configuration["SmtpSettings:Host"] ?? "smtp.gmail.com";
            _port = int.TryParse(configuration["SmtpSettings:Port"], out int p) ? p : 587;
            _user = configuration["SmtpSettings:User"] ?? string.Empty;
            _pass = configuration["SmtpSettings:Pass"] ?? string.Empty;

            if (string.IsNullOrWhiteSpace(_user) || string.IsNullOrWhiteSpace(_pass))
                _logger.LogWarning("SMTP credentials are empty! Check SmtpSettings in appsettings.json");
            else
                _logger.LogInformation("EmailSender configured: {Host}:{Port} as {User}", _host, _port, _user);
        }

        public async Task SendEmailAsync(string toEmail, string subject, string htmlMessage)
        {
            _logger.LogInformation("Sending email → {To} | Subject: {Subject}", toEmail, subject);

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("MOTO SHOP", _user));
            message.To.Add(new MailboxAddress(string.Empty, toEmail));
            message.Subject = subject;
            message.Body    = new TextPart("html") { Text = htmlMessage };

            using var client = new SmtpClient();
            try
            {
                // SecureSocketOptions.Auto: tự chọn StartTls (587) hoặc SslOnConnect (465)
                await client.ConnectAsync(_host, _port, SecureSocketOptions.Auto);
                _logger.LogInformation("SMTP connected to {Host}:{Port}", _host, _port);

                await client.AuthenticateAsync(_user, _pass);
                _logger.LogInformation("SMTP authenticated as {User}", _user);

                await client.SendAsync(message);
                await client.DisconnectAsync(quit: true);

                _logger.LogInformation("Email sent successfully to {To}", toEmail);
            }
            catch (MailKit.Security.AuthenticationException ex)
            {
                _logger.LogError("SMTP AUTH FAILED for {User} on {Host}:{Port} — {Msg}", _user, _host, _port, ex.Message);
                _logger.LogError("→ Kiểm tra: (1) Gmail bật 2FA chưa? (2) App Password đúng chưa? (3) Xóa space trong App Password?");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "SMTP error sending to {To} via {Host}:{Port} — {Msg}", toEmail, _host, _port, ex.Message);
                throw;
            }
        }
    }
}
