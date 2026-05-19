using System.ComponentModel.DataAnnotations;

namespace MotoShop.Models.ViewModels
{
    public class AddressViewModel
    {
        public int Id { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Province { get; set; } = string.Empty;
        public string District { get; set; } = string.Empty;
        public string Ward { get; set; } = string.Empty;
        public string Street { get; set; } = string.Empty;
        public bool IsDefault { get; set; }
        public string FullAddress => $"{Street}, {Ward}, {District}, {Province}";
    }

    public class AddressFormViewModel
    {
        public int? Id { get; set; } // Dùng cho trường hợp Edit

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        public string FullName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^(0[3|5|7|8|9])+([0-9]{8})$", ErrorMessage = "Số điện thoại không đúng định dạng")]
        public string Phone { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng chọn Tỉnh/Thành phố")]
        public string Province { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng chọn Quận/Huyện")]
        public string District { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng chọn Phường/Xã")]
        public string Ward { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng nhập tên đường, số nhà")]
        public string Street { get; set; } = string.Empty;

        public bool IsDefault { get; set; }

        public int? DistrictId { get; set; }
        public string? WardCode { get; set; }
    }
}
