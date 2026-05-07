using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using Microsoft.AspNetCore.Identity;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace MotoShop.Controllers
{
    public class PaymentController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly IOrderService _orderService;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly MotoShop.Data.Data.MotoShopDbContext _context;

        public PaymentController(IConfiguration configuration, IOrderService orderService, UserManager<IdentityUser> userManager, MotoShop.Data.Data.MotoShopDbContext context)
        {
            _configuration = configuration;
            _orderService = orderService;
            _userManager = userManager;
            _context = context;
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
            if (Request.Query.Count > 0)
            {
                string vnp_HashSecret = _configuration["Payment:VnPay:HashSecret"] ?? "";
                var vnpayData = Request.Query;
                VnPayLibrary vnpay = new VnPayLibrary();

                foreach (var s in vnpayData)
                {
                    if (!string.IsNullOrEmpty(s.Key) && s.Key.StartsWith("vnp_"))
                    {
                        vnpay.AddResponseData(s.Key, s.Value.ToString());
                    }
                }

                string txnRef = vnpay.GetResponseData("vnp_TxnRef");
                string vnp_ResponseCode = vnpay.GetResponseData("vnp_ResponseCode");
                string vnp_SecureHash = Request.Query["vnp_SecureHash"].ToString();

                bool checkSignature = vnpay.ValidateSignature(vnp_SecureHash, vnp_HashSecret);

                if (checkSignature)
                {
                    ViewBag.Status = "success";
                    if (vnp_ResponseCode == "00")
                    {
                        if (txnRef.StartsWith("SB_"))
                        {
                            // Xử lý cọc dịch vụ
                            int bookingId = int.Parse(txnRef.Replace("SB_", ""));
                            var booking = await _context.ServiceBookings.FindAsync(bookingId);
                            if (booking != null)
                            {
                                booking.Status = "Confirmed";
                                booking.DepositStatus = "Paid";
                                booking.ConfirmedAt = DateTime.Now;
                                await _context.SaveChangesAsync();

                                ViewBag.BookingId = bookingId;
                                ViewBag.Message = "Thanh toán cọc dịch vụ thành công!";
                            }
                        }
                        else
                        {
                            // Xử lý đơn hàng
                            int orderId = int.Parse(txnRef);
                            await _orderService.UpdatePaymentStatusAsync(orderId, "Paid");
                            ViewBag.OrderId = orderId;
                            ViewBag.Message = "Thanh toán thành công đơn hàng #" + txnRef;
                        }
                    }
                    else
                    {
                        ViewBag.Message = "Giao dịch không thành công. Mã lỗi: " + vnp_ResponseCode;
                        ViewBag.Status = "error";
                    }
                }
                else
                {
                    ViewBag.Message = "Chữ ký không hợp lệ.";
                    ViewBag.Status = "error";
                }
            }
            return View();
        }
    }
}
