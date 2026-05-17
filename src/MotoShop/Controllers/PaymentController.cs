using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class PaymentController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly IOrderService _orderService;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly MotoShop.Data.Data.MotoShopDbContext _context;
        private readonly MotoShop.Business.Interfaces.IEmailService _emailService;
        private readonly ILogger<PaymentController> _logger;
        private readonly MotoShop.Business.Interfaces.IAuditLogService _auditLogService;

        public PaymentController(IConfiguration configuration, IOrderService orderService, UserManager<IdentityUser> userManager, MotoShop.Data.Data.MotoShopDbContext context, MotoShop.Business.Interfaces.IEmailService emailService, ILogger<PaymentController> logger, MotoShop.Business.Interfaces.IAuditLogService auditLogService)
        {
            _configuration = configuration;
            _orderService = orderService;
            _userManager = userManager;
            _context = context;
            _emailService = emailService;
            _logger = logger;
            _auditLogService = auditLogService;
        }

        // Bước 1: Tạo URL và Redirect sang VNPay cho Đơn hàng
        public async Task<IActionResult> CreatePayment(int orderId)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var order = await _orderService.GetOrderDetailsAsync(orderId, userId);
            if (order == null) return NotFound();

            return GenerateVnPayUrl(order.OrderId.ToString(), order.TotalAmount, "Thanh toan don hang: " + order.OrderId);
        }

        // Bước 1b: Tạo URL và Redirect sang VNPay cho Cọc dịch vụ
        public async Task<IActionResult> CreateServiceDeposit(int bookingId)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return NotFound();

            // Sử dụng prefix SB_ để phân biệt với Order
            return GenerateVnPayUrl("SB_" + booking.BookingId, booking.DepositAmount, "Thanh toan coc dich vu: " + booking.BookingId);
        }

        private IActionResult GenerateVnPayUrl(string txnRef, decimal amount, string orderInfo)
        {
            string vnp_Returnurl = Url.Action("PaymentCallback", "Payment", null, Request.Scheme) ?? "";
            string vnp_Url = _configuration["Payment:VnPay:BaseUrl"] ?? "";
            string vnp_TmnCode = _configuration["Payment:VnPay:TmnCode"] ?? "";
            string vnp_HashSecret = _configuration["Payment:VnPay:HashSecret"] ?? "";

            if (string.IsNullOrEmpty(vnp_Url) || string.IsNullOrEmpty(vnp_TmnCode) || string.IsNullOrEmpty(vnp_HashSecret))
            {
                return BadRequest("Lỗi hệ thống: Chưa cấu hình thông số thanh toán VnPay.");
            }

            VnPayLibrary vnpay = new VnPayLibrary();
            vnpay.AddRequestData("vnp_Version", "2.1.0");
            vnpay.AddRequestData("vnp_Command", "pay");
            vnpay.AddRequestData("vnp_TmnCode", vnp_TmnCode);
            vnpay.AddRequestData("vnp_Amount", ((long)(amount * 100)).ToString()); 
            vnpay.AddRequestData("vnp_CreateDate", DateTime.Now.ToString("yyyyMMddHHmmss"));
            vnpay.AddRequestData("vnp_CurrCode", "VND");
            vnpay.AddRequestData("vnp_IpAddr", HttpContext.Connection.RemoteIpAddress?.ToString() ?? "127.0.0.1");
            vnpay.AddRequestData("vnp_Locale", "vn");
            vnpay.AddRequestData("vnp_OrderInfo", orderInfo);
            vnpay.AddRequestData("vnp_OrderType", "other");
            vnpay.AddRequestData("vnp_ReturnUrl", vnp_Returnurl);
            vnpay.AddRequestData("vnp_TxnRef", txnRef);

            string paymentUrl = vnpay.CreateRequestUrl(vnp_Url, vnp_HashSecret);
            return Redirect(paymentUrl);
        }

        // Bước 2: Nhận kết quả từ VNPay
        public async Task<IActionResult> PaymentCallback()
        {
            if (Request.Query.Count == 0)
                return View();

            string vnp_HashSecret = _configuration["Payment:VnPay:HashSecret"] ?? "";
            VnPayLibrary vnpay = new VnPayLibrary();

            foreach (var s in Request.Query)
            {
                if (!string.IsNullOrEmpty(s.Key) && s.Key.StartsWith("vnp_"))
                    vnpay.AddResponseData(s.Key, s.Value.ToString());
            }

            string txnRef = vnpay.GetResponseData("vnp_TxnRef");
            string vnp_ResponseCode = vnpay.GetResponseData("vnp_ResponseCode");
            string vnp_SecureHash = Request.Query["vnp_SecureHash"].ToString();
            string vnpayTxnNo = vnpay.GetResponseData("vnp_TransactionNo");

            // FIX 3: Verify chữ ký trước khi xử lý bất kỳ thứ gì
            if (!vnpay.ValidateSignature(vnp_SecureHash, vnp_HashSecret))
            {
                _logger.LogWarning("VNPay invalid signature. TxnRef={TxnRef}", txnRef);
                ViewBag.Status = "error";
                ViewBag.Message = "Chữ ký không hợp lệ.";
                return View();
            }

            if (vnp_ResponseCode != "00")
            {
                _logger.LogInformation("VNPay payment failed. TxnRef={TxnRef}, Code={Code}", txnRef, vnp_ResponseCode);
                await _auditLogService.LogActionAsync(
                    _userManager.GetUserId(User), "PAYMENT_FAIL", "Order", txnRef,
                    null, $"VNPay thất bại: mã lỗi {vnp_ResponseCode}",
                    HttpContext.Connection.RemoteIpAddress?.ToString());
                ViewBag.Status = "error";
                ViewBag.Message = "Giao dịch không thành công. Mã lỗi: " + vnp_ResponseCode;
                return View();
            }

            // FIX 1: Validate số tiền
            if (!long.TryParse(vnpay.GetResponseData("vnp_Amount"), out long receivedAmount))
            {
                _logger.LogWarning("VNPay invalid amount format. TxnRef={TxnRef}", txnRef);
                ViewBag.Status = "error";
                ViewBag.Message = "Dữ liệu thanh toán không hợp lệ.";
                return View();
            }

            if (txnRef.StartsWith("SB_"))
            {
                // Xử lý cọc dịch vụ
                if (!int.TryParse(txnRef.Replace("SB_", ""), out int bookingId))
                {
                    ViewBag.Status = "error";
                    ViewBag.Message = "Mã đặt lịch không hợp lệ.";
                    return View();
                }

                var booking = await _context.ServiceBookings.FindAsync(bookingId);
                if (booking == null)
                {
                    ViewBag.Status = "error";
                    ViewBag.Message = "Không tìm thấy đặt lịch.";
                    return View();
                }

                long expectedAmount = (long)(booking.DepositAmount * 100);
                if (expectedAmount != receivedAmount)
                {
                    _logger.LogWarning("VNPay amount mismatch for booking {BookingId}. Expected={Expected}, Received={Received}", bookingId, expectedAmount, receivedAmount);
                    ViewBag.Status = "error";
                    ViewBag.Message = "Số tiền thanh toán không khớp.";
                    return View();
                }

                // Atomic idempotency — tránh race condition khi VNPay gọi callback 2 lần
                var bookingRows = await _context.ServiceBookings
                    .Where(b => b.BookingId == bookingId && b.DepositStatus != "Paid")
                    .ExecuteUpdateAsync(b => b
                        .SetProperty(x => x.Status, "Confirmed")
                        .SetProperty(x => x.DepositStatus, "Paid")
                        .SetProperty(x => x.ConfirmedAt, DateTime.Now));

                if (bookingRows > 0)
                {
                    _logger.LogInformation("VNPay booking deposit paid. BookingId={BookingId}, TxnNo={TxnNo}", bookingId, vnpayTxnNo);
                    await _auditLogService.LogActionAsync(
                        _userManager.GetUserId(User), "PAYMENT_SUCCESS", "Booking", bookingId.ToString(),
                        null, $"VNPay cọc dịch vụ thành công: {booking.DepositAmount:N0}₫, TxnNo={vnpayTxnNo}",
                        HttpContext.Connection.RemoteIpAddress?.ToString());

                    try
                    {
                        var bookingForEmail = await _context.ServiceBookings
                            .Include(b => b.Service)
                            .FirstOrDefaultAsync(b => b.BookingId == bookingId);
                        if (bookingForEmail?.CustomerEmail != null)
                            await _emailService.SendDepositConfirmedAsync(bookingForEmail, vnpayTxnNo);
                    }
                    catch { /* email failure không ảnh hưởng kết quả */ }
                }
                else
                {
                    _logger.LogInformation("VNPay duplicate callback for booking {BookingId}", bookingId);
                }

                ViewBag.Status = "success";
                ViewBag.BookingId = bookingId;
                ViewBag.Message = "Thanh toán cọc dịch vụ thành công!";
            }
            else
            {
                // Xử lý đơn hàng
                if (!int.TryParse(txnRef, out int orderId))
                {
                    ViewBag.Status = "error";
                    ViewBag.Message = "Mã đơn hàng không hợp lệ.";
                    return View();
                }

                var order = await _context.Orders.FindAsync(orderId);
                if (order == null)
                {
                    ViewBag.Status = "error";
                    ViewBag.Message = "Không tìm thấy đơn hàng.";
                    return View();
                }

                // C4: Kiểm tra ownership — nếu user đang đăng nhập phải là chủ đơn
                var currentUserId = _userManager.GetUserId(User);
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var ownerCustomerId = await _context.Customers
                        .Where(c => c.UserId == currentUserId)
                        .Select(c => (int?)c.CustomerId)
                        .FirstOrDefaultAsync();
                    if (ownerCustomerId == null || order.CustomerId != ownerCustomerId)
                    {
                        _logger.LogWarning("VNPay callback ownership mismatch. OrderId={OrderId}, OwnerId={OwnerId}, RequestUser={UserId}", orderId, order.CustomerId, currentUserId);
                        ViewBag.Status = "error";
                        ViewBag.Message = "Bạn không có quyền truy cập đơn hàng này.";
                        return View();
                    }
                }

                long expectedAmount = (long)(order.TotalAmount * 100);
                if (expectedAmount != receivedAmount)
                {
                    _logger.LogWarning("VNPay amount mismatch for order {OrderId}. Expected={Expected}, Received={Received}", orderId, expectedAmount, receivedAmount);
                    ViewBag.Status = "error";
                    ViewBag.Message = "Số tiền thanh toán không khớp.";
                    return View();
                }

                // C1: Atomic idempotency — UpdatePaymentStatusAsync dùng WHERE PaymentStatus != 'Paid'
                if (order.PaymentStatus != MotoShop.Data.Constants.PaymentStatusConst.Paid)
                {
                    await _orderService.UpdatePaymentStatusAsync(orderId, MotoShop.Data.Constants.PaymentStatusConst.Paid);
                    _logger.LogInformation("VNPay order paid. OrderId={OrderId}, TxnNo={TxnNo}", orderId, vnpayTxnNo);
                    await _auditLogService.LogActionAsync(
                        _userManager.GetUserId(User), "PAYMENT_SUCCESS", "Order", orderId.ToString(),
                        null, $"VNPay thanh toán thành công: {order.TotalAmount:N0}₫, TxnNo={vnpayTxnNo}",
                        HttpContext.Connection.RemoteIpAddress?.ToString());
                }
                else
                {
                    _logger.LogInformation("VNPay duplicate callback for order {OrderId}", orderId);
                }

                ViewBag.Status = "success";
                ViewBag.OrderId = orderId;
                ViewBag.Message = "Thanh toán thành công đơn hàng #" + txnRef;
            }

            return View();
        }
    }
}
