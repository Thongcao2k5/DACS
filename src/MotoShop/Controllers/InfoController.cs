using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.Extensions.Configuration;
using System.Net;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class InfoController : Controller
    {
        private readonly IEmailSender _emailSender;
        private readonly IConfiguration _config;

        public InfoController(IEmailSender emailSender, IConfiguration config)
        {
            _emailSender = emailSender;
            _config = config;
        }

        public IActionResult AboutUs()
        {
            return View();
        }

        public IActionResult Contact()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Contact(string fullName, string email, string phone, string subject, string message)
        {
            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(message))
            {
                return Json(new { success = false, message = "Vui lòng điền đầy đủ các thông tin bắt buộc." });
            }

            try
            {
                string adminEmail = _config["Email:AdminReceiver"] ?? _config["Email:SenderEmail"] ?? "admin@motoshop.vn";

                // HTML-encode toàn bộ input người dùng trước khi đưa vào email body
                string safeFullName = WebUtility.HtmlEncode(fullName);
                string safeEmail    = WebUtility.HtmlEncode(email);
                string safePhone    = WebUtility.HtmlEncode(phone ?? "");
                string safeSubject  = WebUtility.HtmlEncode(subject ?? "");
                string safeMessage  = WebUtility.HtmlEncode(message).Replace("\n", "<br/>");

                string emailBody = $@"
                    <h3>Tin nhắn liên hệ mới từ MotoShop</h3>
                    <p><b>Họ tên:</b> {safeFullName}</p>
                    <p><b>Email:</b> {safeEmail}</p>
                    <p><b>Số điện thoại:</b> {safePhone}</p>
                    <p><b>Tiêu đề:</b> {safeSubject}</p>
                    <p><b>Nội dung:</b><br/>{safeMessage}</p>
                ";

                await _emailSender.SendEmailAsync(adminEmail, $"[CONTACT] {safeSubject}", emailBody);

                return Json(new { success = true, message = "Tin nhắn của bạn đã được gửi thành công. Chúng tôi sẽ phản hồi sớm nhất!" });
            }
            catch
            {
                return Json(new { success = false, message = "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau." });
            }
        }

        public IActionResult Branches()
        {
            return View();
        }

        public IActionResult PrivacyPolicy()
        {
            return View();
        }

        public IActionResult ReturnPolicy()
        {
            return View();
        }

        public IActionResult ShippingPolicy()
        {
            return View();
        }

        public IActionResult TermsOfService()
        {
            return View();
        }

        public IActionResult WarrantyPolicy()
        {
            return View();
        }

        public IActionResult Page404()
        {
            return View();
        }
    }
}
