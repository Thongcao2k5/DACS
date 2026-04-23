using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using MotoShop.Data.Interfaces;

namespace MotoShop.Controllers
{
    public class PaymentController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly IOrderService _orderService;

        public PaymentController(IConfiguration configuration, IOrderService orderService)
        {
            _configuration = configuration;
            _orderService = orderService;
        }

        [HttpGet]
        public async Task<IActionResult> CreatePaymentUrl(int orderId)
        {
            var order = await _orderService.GetOrderDetailsAsync(orderId, ""); // userId tạm thời để trống hoặc lấy từ Claims
            if (order == null) return NotFound();

            string vnp_Returnurl = _configuration["VnPay:ReturnUrl"];
            string vnp_Url = _configuration["VnPay:BaseUrl"];
            string vnp_TmnCode = _configuration["VnPay:TmnCode"];
            string vnp_HashSecret = _configuration["VnPay:HashSecret"];

            VnPayLibrary vnpay = new VnPayLibrary();

            vnpay.AddRequestData("vnp_Version", _configuration["VnPay:Version"]);
            vnpay.AddRequestData("vnp_Command", _configuration["VnPay:Command"]);
            vnpay.AddRequestData("vnp_TmnCode", vnp_TmnCode);
            vnpay.AddRequestData("vnp_Amount", ((long)(order.TotalAmount * 100)).ToString()); 

            vnpay.AddRequestData("vnp_CreateDate", DateTime.Now.ToString("yyyyMMddHHmmss"));
            vnpay.AddRequestData("vnp_CurrCode", _configuration["VnPay:CurrCode"]);
            vnpay.AddRequestData("vnp_IpAddr", HttpContext.Connection.RemoteIpAddress?.ToString() ?? "127.0.0.1");
            vnpay.AddRequestData("vnp_Locale", _configuration["VnPay:Locale"]);

            vnpay.AddRequestData("vnp_OrderInfo", "Thanh toan don hang:" + order.OrderCode);
            vnpay.AddRequestData("vnp_OrderType", "other");
            vnpay.AddRequestData("vnp_ReturnUrl", vnp_Returnurl);
            vnpay.AddRequestData("vnp_TxnRef", order.OrderId.ToString()); 

            string paymentUrl = vnpay.CreateRequestUrl(vnp_Url, vnp_HashSecret);

            return Redirect(paymentUrl);
        }

        [HttpGet]
        [Route("api/payment/vnpay-return")]
        public async Task<IActionResult> PaymentCallback()
        {
            var vnpayData = Request.Query;
            VnPayLibrary vnpay = new VnPayLibrary();

            foreach (string s in vnpayData.Keys)
            {
                if (!string.IsNullOrEmpty(s) && s.StartsWith("vnp_"))
                {
                    vnpay.AddResponseData(s, vnpayData[s]);
                }
            }

            string orderIdStr = vnpay.GetResponseData("vnp_TxnRef");
            string vnp_ResponseCode = vnpay.GetResponseData("vnp_ResponseCode");
            string vnp_TransactionStatus = vnpay.GetResponseData("vnp_TransactionStatus");
            string vnp_SecureHash = vnpayData["vnp_SecureHash"];
            string vnp_HashSecret = _configuration["VnPay:HashSecret"];

            bool checkSignature = vnpay.ValidateSignature(vnp_SecureHash, vnp_HashSecret);

            if (checkSignature)
            {
                if (vnp_ResponseCode == "00" && vnp_TransactionStatus == "00")
                {
                    // Thanh toán thành công
                    await _orderService.UpdatePaymentStatusAsync(int.Parse(orderIdStr), "Paid");
                    return RedirectToAction("Success", "Cart", new { id = orderIdStr });
                }
                else
                {
                    // Thanh toán lỗi
                    return RedirectToAction("Index", "Cart", new { error = "Thanh toán không thành công. Mã lỗi: " + vnp_ResponseCode });
                }
            }
            else
            {
                return RedirectToAction("Index", "Cart", new { error = "Chữ ký không hợp lệ" });
            }
        }
    }
}
