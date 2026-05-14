using MailKit.Net.Smtp;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MimeKit;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Models;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class EmailService : IEmailService
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<EmailService> _logger;
        private readonly string _siteUrl;
        private string? _layoutHtml;

        public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
        {
            _configuration = configuration;
            _logger = logger;
            _siteUrl = _configuration["AppSettings:SiteUrl"] ?? "https://localhost:7106";
        }

        private async Task<string> WrapEmailAsync(string bodyContent)
        {
            if (_layoutHtml == null)
            {
                var path = Path.Combine(Directory.GetCurrentDirectory(), "..", "MotoShop.Business", "Templates", "EmailLayout.html");
                if (File.Exists(path))
                {
                    _layoutHtml = await File.ReadAllTextAsync(path);
                }
                else
                {
                    // Fallback if file not found
                    return bodyContent;
                }
            }
            return _layoutHtml.Replace("{{BodyContent}}", bodyContent);
        }

        public async Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            try
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress(_configuration["EmailSettings:SenderName"], _configuration["EmailSettings:SenderEmail"]));
                message.To.Add(new MailboxAddress("", email));
                message.Subject = subject;

                var bodyBuilder = new BodyBuilder { HtmlBody = htmlMessage };
                message.Body = bodyBuilder.ToMessageBody();

                using (var client = new SmtpClient())
                {
                    await client.ConnectAsync(
                        _configuration["EmailSettings:SmtpServer"],
                        int.Parse(_configuration["EmailSettings:SmtpPort"] ?? "587"),
                        MailKit.Security.SecureSocketOptions.StartTls);

                    await client.AuthenticateAsync(
                        _configuration["EmailSettings:SenderEmail"],
                        _configuration["EmailSettings:SmtpPassword"]);

                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "Failed to send email to {Email}", email);
                throw;
            }
        }

        public async Task SendOrderConfirmationAsync(Order order)
        {
            var email = order.Customer?.Email;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = order.Customer?.FullName ?? "Quý khách";
                var orderCode = order.OrderCode ?? $"#{order.OrderId}";
                var total = order.TotalAmount;

                var itemsHtml = string.Join("", order.OrderItems.Select(i => $@"
                    <tr>
                        <td style='padding:12px 0;border-bottom:1px solid #edf2f7;'>
                            <div style='font-weight:600;color:#2d3748;font-size:14px;'>{i.ProductVariant?.Product?.ProductName}</div>
                            <div style='font-size:12px;color:#718096;margin-top:2px;'>Loại: {i.ProductVariant?.VariantName} | SL: {i.Quantity}</div>
                        </td>
                        <td style='padding:12px 0;text-align:right;border-bottom:1px solid #edf2f7;font-weight:600;color:#2d3748;font-size:14px;'>
                            {i.Price:N0}₫
                        </td>
                    </tr>"));

                var body = $@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Cảm ơn bạn đã đặt hàng! 🛍️</h2>
                    <p style='color:#718096;margin:0 0 24px;'>Xin chào <strong>{customerName}</strong>, chúng tôi đã nhận được đơn hàng <strong>{orderCode}</strong> của bạn và đang chuẩn bị hàng.</p>
                    
                    <table style='width:100%;border-collapse:collapse;margin-bottom:24px;'>
                        <thead>
                            <tr>
                                <th style='text-align:left;padding-bottom:10px;border-bottom:2px solid #edf2f7;color:#4a5568;font-size:12px;text-uppercase;letter-spacing:1px;'>Sản phẩm</th>
                                <th style='text-align:right;padding-bottom:10px;border-bottom:2px solid #edf2f7;color:#4a5568;font-size:12px;text-uppercase;letter-spacing:1px;'>Giá</th>
                            </tr>
                        </thead>
                        <tbody>
                            {itemsHtml}
                        </tbody>
                        <tr>
                            <td style='padding:10px 0 5px;font-weight:700;font-size:15px;'>Tổng cộng</td>
                            <td style='padding:10px 0 5px;text-align:right;font-weight:700;font-size:16px;color:#e53e3e;'>{total:N0}₫</td>
                        </tr>
                    </table>

                    <div style='background:#f7fafc;border-left:4px solid #e53e3e;padding:12px 16px;border-radius:4px;margin-bottom:24px;'>
                        <p style='margin:0;font-size:13px;color:#718096;'>📦 Địa chỉ giao hàng</p>
                        <p style='margin:4px 0 0;font-size:14px;color:#2d3748;font-weight:600;'>{order.ShippingAddress}</p>
                    </div>

                    <div style='text-align:center;margin:24px 0;'>
                        <a href='{_siteUrl}/Order/Detail/{order.OrderId}' style='background:#e53e3e;color:#fff;padding:13px 32px;text-decoration:none;border-radius:25px;font-weight:700;font-size:14px;display:inline-block;letter-spacing:0.5px;'>
                            XEM CHI TIẾT ĐƠN HÀNG
                        </a>
                    </div>";

                await SendEmailAsync(email, $"[MotoShop] Xác nhận đơn hàng {orderCode}", await WrapEmailAsync(body));
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendOrderConfirmationAsync failed for order {OrderId}", order.OrderId);
            }
        }

        public async Task SendOrderShippingAsync(Order order)
        {
            var email = order.Customer?.Email;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = order.Customer?.FullName ?? "Quý khách";
                var orderCode = order.OrderCode ?? $"#{order.OrderId}";
                var estimatedDays = order.ShippingMethod?.EstimatedDays ?? "1-3 ngày làm việc";

                var body = $@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Đơn hàng đang trên đường đến bạn! 🚚</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, đơn hàng của bạn đã được bàn giao cho đơn vị vận chuyển.</p>

                    <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <table style='width:100%;border-collapse:collapse;'>
                            <tr>
                                <td style='padding:4px 0;color:#718096;font-size:13px;'>Mã đơn hàng</td>
                                <td style='padding:4px 0;text-align:right;font-weight:700;color:#e53e3e;font-size:15px;'>{orderCode}</td>
                            </tr>
                            <tr>
                                <td style='padding:4px 0;color:#718096;font-size:13px;'>Thời gian giao dự kiến</td>
                                <td style='padding:4px 0;text-align:right;font-size:13px;font-weight:600;'>{estimatedDays}</td>
                            </tr>
                            <tr>
                                <td style='padding:4px 0;color:#718096;font-size:13px;'>Địa chỉ nhận hàng</td>
                                <td style='padding:4px 0;text-align:right;font-size:13px;'>{order.ShippingAddress}</td>
                            </tr>
                        </table>
                    </div>

                    <div style='text-align:center;margin:24px 0;'>
                        <a href='{_siteUrl}/Order/Detail/{order.OrderId}' style='background:#e53e3e;color:#fff;padding:13px 32px;text-decoration:none;border-radius:25px;font-weight:700;font-size:14px;display:inline-block;'>
                            THEO DÕI ĐƠN HÀNG
                        </a>
                    </div>";

                await SendEmailAsync(email, $"[MotoShop] Đơn hàng {orderCode} đang được giao", await WrapEmailAsync(body));
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendOrderShippingAsync failed for order {OrderId}", order.OrderId);
            }
        }

        public async Task SendOrderCompletedAsync(Order order)
        {
            var email = order.Customer?.Email;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = order.Customer?.FullName ?? "Quý khách";
                var orderCode = order.OrderCode ?? $"#{order.OrderId}";

                var firstProductId = order.OrderItems.FirstOrDefault()?.ProductVariant?.Product?.ProductId;
                var reviewLink = firstProductId.HasValue ? $"{_siteUrl}/Product/Details/{firstProductId}" : $"{_siteUrl}/Product";

                var body = $@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Giao hàng thành công! Cảm ơn bạn 🎉</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, đơn hàng <strong>{orderCode}</strong> đã được giao thành công. Cảm ơn bạn đã tin tưởng và mua sắm tại MotoShop!</p>

                    <div style='text-align:center;margin:20px 0;'>
                        <a href='{reviewLink}' style='background:#e53e3e;color:#fff;padding:12px 28px;text-decoration:none;border-radius:25px;font-weight:700;font-size:13px;display:inline-block;margin:4px;'>
                            ⭐ ĐÁNH GIÁ SẢN PHẨM
                        </a>
                    </div>";

                await SendEmailAsync(email, $"[MotoShop] Đơn hàng {orderCode} đã giao thành công", await WrapEmailAsync(body));
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendOrderCompletedAsync failed for order {OrderId}", order.OrderId);
            }
        }

        public async Task SendBookingConfirmationAsync(ServiceBooking booking)
        {
            var email = booking.CustomerEmail;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = booking.CustomerFullName ?? "Quý khách";
                var bookingCode = booking.BookingCode ?? $"BK{booking.BookingId:000000}";
                var serviceName = booking.Service?.ServiceName ?? "Dịch vụ xe máy";
                var serviceDate = booking.ServiceDate?.ToString("HH:mm, dddd dd/MM/yyyy") ?? "Đang xác nhận";

                var body = $@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Đặt lịch thành công! 🔧</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, lịch hẹn dịch vụ của bạn đã được ghi nhận.</p>

                    <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <table style='width:100%;border-collapse:collapse;'>
                            <tr><td style='padding:6px 0;color:#718096;font-size:13px;'>Mã lịch hẹn</td><td style='padding:6px 0;text-align:right;font-weight:700;color:#e53e3e;font-size:15px;'>{bookingCode}</td></tr>
                            <tr><td style='padding:6px 0;color:#718096;font-size:13px;'>Dịch vụ</td><td style='padding:6px 0;text-align:right;font-size:14px;font-weight:600;'>{serviceName}</td></tr>
                            <tr><td style='padding:6px 0;color:#718096;font-size:13px;'>Thời gian hẹn</td><td style='padding:6px 0;text-align:right;font-size:14px;font-weight:600;color:#2d3748;'>{serviceDate}</td></tr>
                        </table>
                    </div>";

                await SendEmailAsync(email, $"[MotoShop] Xác nhận đặt lịch {bookingCode}", await WrapEmailAsync(body));
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendBookingConfirmationAsync failed for booking {BookingId}", booking.BookingId);
            }
        }

        public async Task SendDepositConfirmedAsync(ServiceBooking booking, string vnpayTxnRef)
        {
            var email = booking.CustomerEmail;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = booking.CustomerFullName ?? "Quý khách";
                var bookingCode = booking.BookingCode ?? $"BK{booking.BookingId:000000}";
                var depositAmount = booking.DepositAmount;

                var body = $@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Đã xác nhận thanh toán cọc! ✅</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, chúng tôi đã nhận được khoản đặt cọc cho lịch hẹn của bạn.</p>

                    <div style='background:#f0fff4;border:1px solid #c6f6d5;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <p style='margin:0;font-size:15px;font-weight:700;color:#276749;'>Số tiền cọc: {depositAmount:N0}₫</p>
                        <p style='margin:4px 0;font-size:13px;'>Mã VNPay: {vnpayTxnRef}</p>
                    </div>";

                await SendEmailAsync(email, $"[MotoShop] Xác nhận nhận cọc - Lịch hẹn {bookingCode}", await WrapEmailAsync(body));
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendDepositConfirmedAsync failed for booking {BookingId}", booking.BookingId);
            }
        }

        public async Task SendPromotionEmailAsync(string toEmail, string promotionName, string description, string startDate, string endDate)
        {
            var body = $@"
                <h2 style='color:#2d3748;margin:0 0 8px;'>🌟 {promotionName}</h2>
                <p style='color:#718096;line-height:1.6;margin:0 0 20px;'>{description}</p>
                <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:14px 18px;margin-bottom:24px;'>
                    <p style='margin:5px 0;font-size:13px;'><strong>📅 Bắt đầu:</strong> {startDate}</p>
                    <p style='margin:5px 0;font-size:13px;'><strong>📅 Kết thúc:</strong> {endDate}</p>
                </div>";

            await SendEmailAsync(toEmail, $"[MotoShop] Khuyến mãi: {promotionName}", await WrapEmailAsync(body));
        }
    }
}
