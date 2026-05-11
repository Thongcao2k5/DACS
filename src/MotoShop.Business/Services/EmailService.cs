using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Models;

namespace MotoShop.Business.Services
{
    public class EmailService : IEmailService
    {
        private readonly IConfiguration _config;
        private readonly ILogger<EmailService> _logger;
        private readonly string _siteUrl;

        public EmailService(IConfiguration config, ILogger<EmailService> logger)
        {
            _config = config;
            _logger = logger;
            _siteUrl = config["AppSettings:SiteUrl"] ?? "https://localhost:7106";
        }

        public async Task SendEmailAsync(string toEmail, string subject, string message)
        {
            var smtpHost = _config["SmtpSettings:Host"];
            var smtpPort = int.Parse(_config["SmtpSettings:Port"] ?? "587");
            var smtpUser = _config["SmtpSettings:User"];
            var smtpPass = _config["SmtpSettings:Pass"];

            try
            {
                using var client = new SmtpClient(smtpHost, smtpPort)
                {
                    EnableSsl = true,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(smtpUser, smtpPass)
                };

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(smtpUser!, "MotoShop"),
                    Subject = subject,
                    Body = message,
                    IsBodyHtml = true,
                    BodyEncoding = Encoding.UTF8
                };
                mailMessage.To.Add(toEmail);

                await client.SendMailAsync(mailMessage);
                _logger.LogInformation("Email sent → {To} | {Subject}", toEmail, subject);
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "Email FAILED → {To} | {Subject}", toEmail, subject);
            }
        }

        // ─── ORDER CONFIRMATION ────────────────────────────────────────────────

        public async Task SendOrderConfirmationAsync(Order order)
        {
            var email = order.Customer?.Email;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = order.Customer?.FullName ?? "Quý khách";
                var orderCode = order.OrderCode ?? $"#{order.OrderId}";
                var orderDate = order.OrderDate.ToString("HH:mm dd/MM/yyyy");
                var paymentMethod = order.PaymentMethod == "VNPay" ? "VNPay (Thẻ ATM/Visa/QR)" : "Chuyển khoản ngân hàng";

                // Build items rows
                var itemsRows = new StringBuilder();
                decimal subTotal = 0;
                foreach (var item in order.OrderItems)
                {
                    var name = item.ProductVariant?.Product?.ProductName ?? item.ProductVariant?.VariantName ?? "Sản phẩm";
                    var variant = item.ProductVariant?.VariantName ?? "";
                    var displayName = name == variant ? name : $"{name} ({variant})";
                    var lineTotal = item.Price * item.Quantity;
                    subTotal += lineTotal;
                    itemsRows.Append($@"
                        <tr>
                            <td style='padding:10px 12px;border-bottom:1px solid #f0f0f0;font-size:14px;'>{displayName}</td>
                            <td style='padding:10px 12px;border-bottom:1px solid #f0f0f0;text-align:center;font-size:14px;'>{item.Quantity}</td>
                            <td style='padding:10px 12px;border-bottom:1px solid #f0f0f0;text-align:right;font-size:14px;'>{item.Price:N0}₫</td>
                            <td style='padding:10px 12px;border-bottom:1px solid #f0f0f0;text-align:right;font-size:14px;font-weight:600;'>{lineTotal:N0}₫</td>
                        </tr>");
                }

                var shippingCost = order.ShippingMethod?.Cost ?? 0m;
                var shippingName = order.ShippingMethod?.Name ?? "Giao hàng tiêu chuẩn";
                var discount = order.DiscountAmount;
                var total = order.TotalAmount;

                var discountRow = discount > 0
                    ? $"<tr><td style='padding:6px 0;color:#e53e3e;'>Giảm giá</td><td style='padding:6px 0;color:#e53e3e;text-align:right;'>-{discount:N0}₫</td></tr>"
                    : "";

                var html = WrapEmail($@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Cảm ơn bạn đã đặt hàng!</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, đơn hàng của bạn đã được xác nhận và đang được xử lý.</p>

                    <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <table style='width:100%;border-collapse:collapse;'>
                            <tr>
                                <td style='padding:4px 0;color:#718096;font-size:13px;'>Mã đơn hàng</td>
                                <td style='padding:4px 0;text-align:right;font-weight:700;color:#e53e3e;font-size:15px;'>{orderCode}</td>
                            </tr>
                            <tr>
                                <td style='padding:4px 0;color:#718096;font-size:13px;'>Ngày đặt</td>
                                <td style='padding:4px 0;text-align:right;font-size:13px;'>{orderDate}</td>
                            </tr>
                            <tr>
                                <td style='padding:4px 0;color:#718096;font-size:13px;'>Thanh toán</td>
                                <td style='padding:4px 0;text-align:right;font-size:13px;'>{paymentMethod}</td>
                            </tr>
                        </table>
                    </div>

                    <h3 style='color:#2d3748;font-size:15px;margin:0 0 12px;border-bottom:2px solid #e53e3e;padding-bottom:8px;'>Chi tiết đơn hàng</h3>
                    <table style='width:100%;border-collapse:collapse;margin-bottom:16px;'>
                        <thead>
                            <tr style='background:#f7f7f7;'>
                                <th style='padding:10px 12px;text-align:left;font-size:13px;color:#4a5568;font-weight:600;'>Sản phẩm</th>
                                <th style='padding:10px 12px;text-align:center;font-size:13px;color:#4a5568;font-weight:600;'>SL</th>
                                <th style='padding:10px 12px;text-align:right;font-size:13px;color:#4a5568;font-weight:600;'>Đơn giá</th>
                                <th style='padding:10px 12px;text-align:right;font-size:13px;color:#4a5568;font-weight:600;'>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>{itemsRows}</tbody>
                    </table>

                    <table style='width:220px;margin-left:auto;border-collapse:collapse;margin-bottom:24px;'>
                        <tr>
                            <td style='padding:5px 0;color:#718096;font-size:13px;'>Tạm tính</td>
                            <td style='padding:5px 0;text-align:right;font-size:13px;'>{subTotal:N0}₫</td>
                        </tr>
                        <tr>
                            <td style='padding:5px 0;color:#718096;font-size:13px;'>{shippingName}</td>
                            <td style='padding:5px 0;text-align:right;font-size:13px;'>{(shippingCost == 0 ? "Miễn phí" : shippingCost.ToString("N0") + "₫")}</td>
                        </tr>
                        {discountRow}
                        <tr style='border-top:2px solid #e53e3e;'>
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
                    </div>");

                await SendEmailAsync(email, $"[MotoShop] Xác nhận đơn hàng {orderCode}", html);
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendOrderConfirmationAsync failed for order {OrderId}", order.OrderId);
            }
        }

        // ─── ORDER SHIPPING ────────────────────────────────────────────────────

        public async Task SendOrderShippingAsync(Order order)
        {
            var email = order.Customer?.Email;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = order.Customer?.FullName ?? "Quý khách";
                var orderCode = order.OrderCode ?? $"#{order.OrderId}";
                var estimatedDays = order.ShippingMethod?.EstimatedDays ?? "1-3 ngày làm việc";

                var html = WrapEmail($@"
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

                    <div style='background:#f0fff4;border:1px solid #c6f6d5;border-radius:8px;padding:14px 18px;margin-bottom:24px;'>
                        <p style='margin:0;font-size:13px;color:#276749;'>
                            💡 <strong>Lưu ý:</strong> Vui lòng để điện thoại ở chế độ nhận cuộc gọi. Shipper sẽ liên hệ trước khi giao hàng.
                            Nếu không gặp, đơn hàng có thể bị hoàn về.
                        </p>
                    </div>

                    <div style='text-align:center;margin:24px 0;'>
                        <a href='{_siteUrl}/Order/Detail/{order.OrderId}' style='background:#e53e3e;color:#fff;padding:13px 32px;text-decoration:none;border-radius:25px;font-weight:700;font-size:14px;display:inline-block;'>
                            THEO DÕI ĐƠN HÀNG
                        </a>
                    </div>");

                await SendEmailAsync(email, $"[MotoShop] Đơn hàng {orderCode} đang được giao", html);
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendOrderShippingAsync failed for order {OrderId}", order.OrderId);
            }
        }

        // ─── ORDER COMPLETED ───────────────────────────────────────────────────

        public async Task SendOrderCompletedAsync(Order order)
        {
            var email = order.Customer?.Email;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = order.Customer?.FullName ?? "Quý khách";
                var orderCode = order.OrderCode ?? $"#{order.OrderId}";

                // Get first product for review link
                var firstVariantId = order.OrderItems.FirstOrDefault()?.ProductVariantId;
                var firstProductId = order.OrderItems.FirstOrDefault()?.ProductVariant?.Product?.ProductId;
                var reviewLink = firstProductId.HasValue
                    ? $"{_siteUrl}/Product/Details/{firstProductId}"
                    : $"{_siteUrl}/Product";

                var html = WrapEmail($@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Giao hàng thành công! Cảm ơn bạn 🎉</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, đơn hàng <strong>{orderCode}</strong> đã được giao thành công. Cảm ơn bạn đã tin tưởng và mua sắm tại MotoShop!</p>

                    <div style='background:#f0fff4;border:1px solid #c6f6d5;border-radius:8px;padding:14px 18px;margin-bottom:24px;text-align:center;'>
                        <p style='margin:0 0 6px;font-size:22px;'>✅</p>
                        <p style='margin:0;font-size:14px;color:#276749;font-weight:600;'>Đơn hàng {orderCode} đã hoàn tất</p>
                        <p style='margin:4px 0 0;font-size:12px;color:#48bb78;'>Giao hàng thành công</p>
                    </div>

                    <p style='color:#4a5568;font-size:14px;line-height:1.7;margin-bottom:20px;'>
                        Trải nghiệm mua sắm của bạn rất quan trọng với chúng tôi. Hãy dành 1 phút để đánh giá sản phẩm — điều này giúp những khách hàng khác có lựa chọn tốt hơn!
                    </p>

                    <div style='text-align:center;margin:20px 0;'>
                        <a href='{reviewLink}' style='background:#e53e3e;color:#fff;padding:12px 28px;text-decoration:none;border-radius:25px;font-weight:700;font-size:13px;display:inline-block;margin:4px;'>
                            ⭐ ĐÁNH GIÁ SẢN PHẨM
                        </a>
                        &nbsp;
                        <a href='{_siteUrl}/Product' style='background:#fff;color:#e53e3e;padding:12px 28px;text-decoration:none;border-radius:25px;font-weight:700;font-size:13px;display:inline-block;border:2px solid #e53e3e;margin:4px;'>
                            MUA THÊM NGAY
                        </a>
                    </div>");

                await SendEmailAsync(email, $"[MotoShop] Đơn hàng {orderCode} đã giao thành công", html);
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendOrderCompletedAsync failed for order {OrderId}", order.OrderId);
            }
        }

        // ─── BOOKING CONFIRMATION ──────────────────────────────────────────────

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
                var depositAmount = booking.DepositAmount;
                var expireAt = booking.ExpireAt?.ToString("HH:mm dd/MM/yyyy") ?? "";

                var html = WrapEmail($@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Đặt lịch thành công! 🔧</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, lịch hẹn dịch vụ của bạn đã được ghi nhận. Vui lòng thanh toán cọc để xác nhận lịch.</p>

                    <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <table style='width:100%;border-collapse:collapse;'>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Mã lịch hẹn</td>
                                <td style='padding:6px 0;text-align:right;font-weight:700;color:#e53e3e;font-size:15px;'>{bookingCode}</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Dịch vụ</td>
                                <td style='padding:6px 0;text-align:right;font-size:14px;font-weight:600;'>{serviceName}</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Thời gian hẹn</td>
                                <td style='padding:6px 0;text-align:right;font-size:14px;font-weight:600;color:#2d3748;'>{serviceDate}</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Địa điểm</td>
                                <td style='padding:6px 0;text-align:right;font-size:13px;'>123 Đường ABC, Q.1, TP.HCM</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Tiền cọc cần thanh toán</td>
                                <td style='padding:6px 0;text-align:right;font-weight:700;color:#e53e3e;font-size:14px;'>{depositAmount:N0}₫</td>
                            </tr>
                            {(string.IsNullOrEmpty(expireAt) ? "" : $"<tr><td style='padding:6px 0;color:#718096;font-size:13px;'>Hạn thanh toán cọc</td><td style='padding:6px 0;text-align:right;font-size:13px;color:#c05621;font-weight:600;'>{expireAt}</td></tr>")}
                        </table>
                    </div>

                    <div style='background:#fffbeb;border:1px solid #fbd38d;border-radius:8px;padding:14px 18px;margin-bottom:24px;'>
                        <p style='margin:0 0 6px;font-size:13px;font-weight:700;color:#744210;'>📋 Lưu ý khi đến làm dịch vụ:</p>
                        <ul style='margin:0;padding-left:20px;color:#744210;font-size:13px;line-height:1.8;'>
                            <li>Vui lòng đến đúng giờ hẹn, mang theo xe đủ nhiên liệu</li>
                            <li>Mang theo mã lịch hẹn <strong>{bookingCode}</strong> khi đến</li>
                            <li>Cần đổi lịch: gọi <strong>1900 1234</strong> trước ít nhất 2 tiếng</li>
                        </ul>
                    </div>

                    <div style='text-align:center;margin:24px 0;'>
                        <a href='{_siteUrl}/Booking/Detail/{booking.BookingId}' style='background:#e53e3e;color:#fff;padding:13px 32px;text-decoration:none;border-radius:25px;font-weight:700;font-size:14px;display:inline-block;'>
                            XEM CHI TIẾT LỊCH HẸN
                        </a>
                    </div>");

                await SendEmailAsync(email, $"[MotoShop] Xác nhận đặt lịch {bookingCode}", html);
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendBookingConfirmationAsync failed for booking {BookingId}", booking.BookingId);
            }
        }

        // ─── DEPOSIT CONFIRMED ─────────────────────────────────────────────────

        public async Task SendDepositConfirmedAsync(ServiceBooking booking, string vnpayTxnRef)
        {
            var email = booking.CustomerEmail;
            if (string.IsNullOrWhiteSpace(email)) return;

            try
            {
                var customerName = booking.CustomerFullName ?? "Quý khách";
                var bookingCode = booking.BookingCode ?? $"BK{booking.BookingId:000000}";
                var serviceName = booking.Service?.ServiceName ?? "Dịch vụ xe máy";
                var serviceDate = booking.ServiceDate?.ToString("HH:mm, dddd dd/MM/yyyy") ?? "Đang xác nhận";
                var depositAmount = booking.DepositAmount;
                var confirmedAt = (booking.ConfirmedAt ?? System.DateTime.Now).ToString("HH:mm dd/MM/yyyy");

                var html = WrapEmail($@"
                    <h2 style='color:#2d3748;margin:0 0 8px;'>Đã xác nhận thanh toán cọc! ✅</h2>
                    <p style='color:#718096;margin:0 0 20px;'>Xin chào <strong>{customerName}</strong>, chúng tôi đã nhận được khoản đặt cọc cho lịch hẹn dịch vụ của bạn.</p>

                    <div style='background:#f0fff4;border:1px solid #c6f6d5;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <table style='width:100%;border-collapse:collapse;'>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Mã lịch hẹn</td>
                                <td style='padding:6px 0;text-align:right;font-weight:700;color:#e53e3e;font-size:15px;'>{bookingCode}</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Số tiền cọc đã nhận</td>
                                <td style='padding:6px 0;text-align:right;font-weight:700;color:#276749;font-size:15px;'>{depositAmount:N0}₫</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Mã giao dịch VNPay</td>
                                <td style='padding:6px 0;text-align:right;font-size:13px;font-weight:600;'>{vnpayTxnRef}</td>
                            </tr>
                            <tr>
                                <td style='padding:6px 0;color:#718096;font-size:13px;'>Thời gian xác nhận</td>
                                <td style='padding:6px 0;text-align:right;font-size:13px;'>{confirmedAt}</td>
                            </tr>
                        </table>
                    </div>

                    <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:16px 20px;margin-bottom:24px;'>
                        <p style='margin:0 0 8px;font-size:13px;color:#718096;'>📅 Nhắc lịch hẹn của bạn</p>
                        <p style='margin:0;font-size:15px;font-weight:700;color:#2d3748;'>{serviceName}</p>
                        <p style='margin:4px 0 0;font-size:14px;color:#e53e3e;font-weight:600;'>{serviceDate}</p>
                        <p style='margin:4px 0 0;font-size:13px;color:#718096;'>📍 123 Đường ABC, Q.1, TP.HCM</p>
                    </div>

                    <div style='text-align:center;margin:24px 0;'>
                        <a href='{_siteUrl}/Booking/Detail/{booking.BookingId}' style='background:#e53e3e;color:#fff;padding:13px 32px;text-decoration:none;border-radius:25px;font-weight:700;font-size:14px;display:inline-block;'>
                            XEM CHI TIẾT LỊCH HẸN
                        </a>
                    </div>");

                await SendEmailAsync(email, $"[MotoShop] Xác nhận nhận cọc - Lịch hẹn {bookingCode}", html);
            }
            catch (System.Exception ex)
            {
                _logger.LogError(ex, "SendDepositConfirmedAsync failed for booking {BookingId}", booking.BookingId);
            }
        }

        // ─── PROMOTION ─────────────────────────────────────────────────────────

        public async Task SendPromotionEmailAsync(string toEmail, string promotionName, string description, string startDate, string endDate)
        {
            var html = WrapEmail($@"
                <h2 style='color:#2d3748;margin:0 0 8px;'>🌟 {promotionName}</h2>
                <p style='color:#718096;line-height:1.6;margin:0 0 20px;'>{description}</p>
                <div style='background:#fff5f5;border:1px solid #fed7d7;border-radius:8px;padding:14px 18px;margin-bottom:24px;'>
                    <p style='margin:5px 0;font-size:13px;'><strong>📅 Bắt đầu:</strong> {startDate}</p>
                    <p style='margin:5px 0;font-size:13px;'><strong>📅 Kết thúc:</strong> {endDate}</p>
                </div>
                <div style='text-align:center;'>
                    <a href='{_siteUrl}/Product' style='background:#e53e3e;color:#fff;padding:13px 32px;text-decoration:none;border-radius:25px;font-weight:700;font-size:14px;display:inline-block;'>
                        XEM ƯU ĐÃI NGAY
                    </a>
                </div>");

            await SendEmailAsync(toEmail, $"[MotoShop] Khuyến mãi: {promotionName}", html);
        }

        // ─── SHARED WRAPPER ────────────────────────────────────────────────────

        private static string WrapEmail(string bodyContent) => $@"
            <!DOCTYPE html>
            <html>
            <body style='margin:0;padding:20px;background:#f4f4f4;font-family:Arial,sans-serif;'>
                <div style='max-width:600px;margin:0 auto;background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.08);'>
                    <div style='background:#e53e3e;padding:28px 30px;text-align:center;'>
                        <h1 style='color:#fff;margin:0;font-size:26px;letter-spacing:2px;font-weight:900;'>MOTO SHOP</h1>
                        <p style='color:#ffd5d5;margin:6px 0 0;font-size:13px;'>Hệ thống phụ tùng xe máy chính hãng</p>
                    </div>
                    <div style='padding:32px 30px;'>
                        {bodyContent}
                    </div>
                    <div style='background:#f7f7f7;padding:18px 30px;text-align:center;border-top:1px solid #eee;'>
                        <p style='margin:4px 0;color:#718096;font-size:12px;'>📞 Hotline: <strong>1900 1234</strong> &nbsp;|&nbsp; 📍 123 Đường ABC, Q.1, TP.HCM</p>
                        <p style='margin:4px 0;color:#a0aec0;font-size:11px;'>© 2026 MotoShop — Tất cả quyền được bảo lưu.</p>
                    </div>
                </div>
            </body>
            </html>";
    }
}
