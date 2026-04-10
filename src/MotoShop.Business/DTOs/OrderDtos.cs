using System;
using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class CheckoutDto
    {
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string Note { get; set; } = string.Empty;
        public string PaymentMethod { get; set; } = "COD"; // Mặc định Thanh toán khi nhận hàng
        public int? ShippingMethodId { get; set; }
        public int? CouponId { get; set; }
    }

    public class OrderDto
    {
        public int OrderId { get; set; }
        public string OrderCode { get; set; } = string.Empty;
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; } = string.Empty;
        public string PaymentStatus { get; set; } = string.Empty;
        public string ShippingAddress { get; set; } = string.Empty;
    }
}
