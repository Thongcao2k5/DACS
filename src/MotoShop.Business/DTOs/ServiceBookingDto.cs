using System;

namespace MotoShop.Business.DTOs
{
    public class ServiceBookingDto
    {
        public int BookingId { get; set; }
        public int? CustomerId { get; set; }
        public int? ServiceId { get; set; }
        public int? CreatedByStaffId { get; set; }
        public int? AssignedStaffId { get; set; }
        public DateTime BookingDate { get; set; }
        public DateTime? ServiceDate { get; set; }
        public string Status { get; set; }
        public string Notes { get; set; }

        public string CustomerName { get; set; } // Extra for display if needed
        public string CustomerPhone { get; set; }
        public string VehicleBrand { get; set; }
        public string VehicleModel { get; set; }
        public string LicensePlate { get; set; }
    }
}
