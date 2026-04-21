using System;
using System.ComponentModel.DataAnnotations;

namespace MotoShop.Business.DTOs
{
    public class BookingViewModel
    {
        // Thông tin liên hệ
        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^(0[3|5|7|8|9])+([0-9]{8})$", ErrorMessage = "Số điện thoại không hợp lệ")]
        public string Phone { get; set; }

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string? Email { get; set; }

        // Thông tin xe
        [Required(ErrorMessage = "Vui lòng chọn hãng xe")]
        public string VehicleBrand { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn dòng xe")]
        public string VehicleModel { get; set; }

        public int? VehicleYear { get; set; }
        public string? LicensePlate { get; set; }

        // Dịch vụ + lịch hẹn
        [Required(ErrorMessage = "Vui lòng chọn dịch vụ")]
        public int ServiceId { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn ngày hẹn")]
        public DateTime ServiceDate { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn khung giờ")]
        public string TimeSlot { get; set; }

        public string? Note { get; set; }
    }

    public class BookingSuccessViewModel
    {
        public int BookingId { get; set; }
        public string BookingCode { get; set; }
        public string ServiceName { get; set; }
        public decimal ServicePrice { get; set; }
        public decimal DepositAmount { get; set; }  // 30%
        public decimal RemainingAmount { get; set; } // 70%
        public DateTime ServiceDate { get; set; }
        public string TimeSlot { get; set; }
        public string Status { get; set; }
        public DateTime ExpireAt { get; set; } // Hết hạn cọc
        
        // Thông tin chuyển khoản
        public string BankName { get; set; }
        public string AccountNumber { get; set; }
        public string AccountHolder { get; set; }
        public string TransferContent { get; set; }
    }
}
