using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using Microsoft.AspNetCore.Identity;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace MotoShop.Controllers
{
    public class PaymentController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly IOrderService _orderService;
        private readonly UserManager<IdentityUser> _userManager;

        public PaymentController(IConfiguration configuration, IOrderService orderService, UserManager<IdentityUser> userManager)
        {
            _configuration = configuration;
            _orderService = orderService;
            _userManager = userManager;
        }

        // Bước 1: Tạo URL và Redirect sang VNPay
        public async Task<IActionResult> CreatePayment(int orderId)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var order = await _orderService.GetOrderDetailsAsync(orderId, userId);
            if (order == null) return NotFound();

            // 2. Lấy cấu hình trực tiếp để tránh lỗi GetSection
            string vnp_Returnurl = Url.Action("PaymentCallback", "Payment", null, Request.Scheme) ?? "";
            string vnp_Url = _configuration["Payment:VnPay:BaseUrl"] ?? "";
            string vnp_TmnCode = _configuration["Payment:VnPay:TmnCode"] ?? "";
            string vnp_HashSecret = _configuration["Payment:VnPay:HashSecret"] ?? "";

            if (string.IsNullOrEmpty(vnp_Url) || string.IsNullOrEmpty(vnp_TmnCode) || string.IsNullOrEmpty(vnp_HashSecret))
            {
                return BadRequest($"Lỗi hệ thống: Chưa cấu hình thông số thanh toán. Vui lòng kiểm tra lại file appsettings.json (TMN: {vnp_TmnCode != ""}, URL: {vnp_Url != ""})");
            }

            VnPayLibrary vnpay = new VnPayLibrary();
            vnpay.AddRequestData("vnp_Version", "2.1.0");
            vnpay.AddRequestData("vnp_Command", "pay");
            vnpay.AddRequestData("vnp_TmnCode", vnp_TmnCode);
            vnpay.AddRequestData("vnp_Amount", ((long)(order.TotalAmount * 100)).ToString()); 
            vnpay.AddRequestData("vnp_CreateDate", DateTime.Now.ToString("yyyyMMddHHmmss"));
            vnpay.AddRequestData("vnp_CurrCode", "VND");
            vnpay.AddRequestData("vnp_IpAddr", HttpContext.Connection.RemoteIpAddress?.ToString() ?? "127.0.0.1");
            vnpay.AddRequestData("vnp_Locale", "vn");
            vnpay.AddRequestData("vnp_OrderInfo", "Thanh toan don hang: " + order.OrderId);
            vnpay.AddRequestData("vnp_OrderType", "other");
            vnpay.AddRequestData("vnp_ReturnUrl", vnp_Returnurl);
            vnpay.AddRequestData("vnp_TxnRef", order.OrderId.ToString());

            string paymentUrl = vnpay.CreateRequestUrl(vnp_Url, vnp_HashSecret);
            return Redirect(paymentUrl);
        }

        // Bước 2: Nhận kết quả từ VNPay và hiển thị theo Layout của dự án
        public async Task<IActionResult> PaymentCallback()
        {
            if (Request.Query.Count > 0)
            {
                var vnpaySection = _configuration.GetSection("Payment:VnPay");
                string vnp_HashSecret = vnpaySection["HashSecret"] ?? "";
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
                    int orderId = Convert.ToInt32(txnRef);
                    ViewBag.OrderId = orderId; // Lưu orderId vào ViewBag

                    if (vnp_ResponseCode == "00")
                    {
                        await _orderService.UpdatePaymentStatusAsync(orderId, "Paid");
                        
                        ViewBag.Message = "Thanh toán thành công đơn hàng #" + txnRef;
                        ViewBag.Status = "success";
                    }
                    else
                    {
                        ViewBag.Message = "Giao dịch không thành công hoặc đã bị hủy. Mã lỗi: " + vnp_ResponseCode;
                        ViewBag.Status = "error";
                    }
                }
                else
                {
                    ViewBag.Message = "Chữ ký không hợp lệ. Vui lòng liên hệ hỗ trợ.";
                    ViewBag.Status = "error";
                }
            }
            return View(); // Trả về View có Layout chung
        }
    }
}
