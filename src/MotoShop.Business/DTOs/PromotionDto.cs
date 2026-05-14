using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class PromotionDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Slug { get; set; }
        public string? Description { get; set; }
        public string PromotionType { get; set; } = "ProductDiscount";
        public string DiscountType { get; set; } = "Percent";
        public decimal DiscountValue { get; set; }
        public decimal? MaxDiscountAmount { get; set; }
        public decimal? MinOrderAmount { get; set; }
        public string? CouponCode { get; set; }
        public string StartDate { get; set; } = string.Empty;
        public string EndDate { get; set; } = string.Empty;
        public int? UsageLimit { get; set; }
        public int UsedCount { get; set; }
        public bool IsActive { get; set; }
        public bool IsFeatured { get; set; }
        public int Priority { get; set; }
        public string? BannerImage { get; set; }
        public string? BackgroundColor { get; set; }
        public System.DateTime? CreatedAt { get; set; }
        public System.DateTime? UpdatedAt { get; set; }
        public int ProductCount { get; set; }
        public string StatusText { get; set; } = string.Empty;
        public string StatusClass { get; set; } = string.Empty;
        public List<int>? ProductIds { get; set; }
    }
}
