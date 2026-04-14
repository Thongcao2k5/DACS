using System;
using System.ComponentModel.DataAnnotations;
using MotoShop.Business.DTOs;

namespace MotoShop.Models.ViewModels
{
    public class ServiceBookingViewModel
    {
        public int? ServiceId { get; set; }
        
        // This is used for displaying the selected service info in the view
        public ServiceDto? SelectedService { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        public string CustomerName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^(0[3|5|7|8|9])+([0-9]{8})$", ErrorMessage = "Số điện thoại không hợp lệ")]
        public string CustomerPhone { get; set; }

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string? Email { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn hãng xe")]
        public string VehicleBrand { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập dòng xe")]
        public string VehicleModel { get; set; }

        public string? LicensePlate { get; set; }

        public string? Notes { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn ngày hẹn")]
        [DataType(DataType.Date)]
        public DateTime ServiceDate { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn khung giờ")]
        public string ServiceTime { get; set; }
    }
}
