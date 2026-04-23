using System;

namespace MotoShop.Business.DTOs
{
    public class CouponDto
    {
        public int Id { get; set; }
        public string Code { get; set; } = string.Empty;
        public decimal DiscountValue { get; set; }
        public string DiscountType { get; set; } = string.Empty;
        public decimal? MinOrderValue { get; set; }
        public int UsageLimit { get; set; }
        public int UsedCount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActive { get; set; }
    }
}
