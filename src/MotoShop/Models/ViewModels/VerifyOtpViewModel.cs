namespace MotoShop.Models.ViewModels
{
    public class VerifyOtpViewModel
    {
        public string Email { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public RegisterViewModel RegisterData { get; set; } // Chứa thông tin đăng ký để lưu sau khi verify
    }
}
