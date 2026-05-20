using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using MotoShop.Data.Enums;

namespace MotoShop.Data.Models
{
    [Table("Promotions")]
    public class Promotion
    {
        [Key]
        public int Id { get; set; }

        [Required, StringLength(255)]
        public string Name { get; set; } = string.Empty;

        [StringLength(255)]
        public string? Slug { get; set; }

        public string? Description { get; set; }

        [Required]
        public PromotionType PromotionType { get; set; } = PromotionType.ProductDiscount;

        [Required]
        public DiscountType DiscountType { get; set; } = DiscountType.Percent;

        [Required]
        public PromotionApplyType ApplyType { get; set; } = PromotionApplyType.Product;

        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountValue { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal? MaxDiscountAmount { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal? MinOrderAmount { get; set; }

        [StringLength(100)]
        public string? CouponCode { get; set; }

        public DateTime StartDate { get; set; } = DateTime.Now;
        public DateTime EndDate { get; set; } = DateTime.Now.AddDays(7);

        public int? UsageLimit { get; set; }
        public int UsedCount { get; set; } = 0;

        public bool IsActive { get; set; } = true;
        public bool IsFeatured { get; set; } = false;
        public int Priority { get; set; } = 0;

        [StringLength(500)]
        public string? BannerImage { get; set; }

        [StringLength(50)]
        public string? BackgroundColor { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime? UpdatedAt { get; set; }

        public virtual ICollection<PromotionProduct> PromotionProducts { get; set; } = new List<PromotionProduct>();
        public virtual ICollection<PromotionCategory> PromotionCategories { get; set; } = new List<PromotionCategory>();
        public virtual ICollection<PromotionProductVariant> PromotionProductVariants { get; set; } = new List<PromotionProductVariant>();
    }

    [Table("PromotionCategories")]
    public class PromotionCategory
    {
        [Key]
        public int Id { get; set; }
        public int PromotionId { get; set; }
        public int CategoryId { get; set; }

        [ForeignKey(nameof(PromotionId))]
        public virtual Promotion? Promotion { get; set; }
        [ForeignKey(nameof(CategoryId))]
        public virtual Category? Category { get; set; }
    }

    [Table("PromotionProductVariants")]
    public class PromotionProductVariant
    {
        [Key]
        public int Id { get; set; }
        public int PromotionId { get; set; }
        public int ProductVariantId { get; set; }

        [ForeignKey(nameof(PromotionId))]
        public virtual Promotion? Promotion { get; set; }
        [ForeignKey(nameof(ProductVariantId))]
        public virtual ProductVariant? ProductVariant { get; set; }
    }
}
