using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity.UI.Services;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class InfoController : Controller
    {
        private readonly IEmailSender _emailSender;

        public InfoController(IEmailSender emailSender)
        {
            _emailSender = emailSender;
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
                // Gửi email cho Admin (Email nhận lấy từ appsettings hoặc để mặc định)
                string adminEmail = "duongtruong251125@gmail.com"; 
                string emailBody = $@"
                    <h3>Tin nhắn liên hệ mới từ MotoShop</h3>
                    <p><b>Họ tên:</b> {fullName}</p>
                    <p><b>Email:</b> {email}</p>
                    <p><b>Số điện thoại:</b> {phone}</p>
                    <p><b>Tiêu đề:</b> {subject}</p>
                    <p><b>Nội dung:</b><br/>{message}</p>
                ";

                await _emailSender.SendEmailAsync(adminEmail, $"[CONTACT] {subject}", emailBody);

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
