namespace MotoShop.Business.DTOs
{
    public class PromotionDto
    {
        public int PromotionId { get; set; }
        public string PromotionName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string DiscountType { get; set; } = string.Empty;
        public decimal DiscountPercentage { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal? MinOrderValue { get; set; }
        public int? MinQuantity { get; set; }
        public string StartDate { get; set; } = string.Empty; // Định dạng chuỗi để JS dễ đọc
        public string EndDate { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public int ProductCount { get; set; }
        public string StatusText { get; set; } = string.Empty;
        public string StatusClass { get; set; } = string.Empty;
    }
}
