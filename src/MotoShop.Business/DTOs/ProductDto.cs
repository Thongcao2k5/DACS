using System;
using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class ProductDto
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string Slug { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int? CategoryId { get; set; }
        public string CategoryName { get; set; } = string.Empty;
        public int? BrandId { get; set; }
        public string BrandName { get; set; } = string.Empty;
        public string BrandLogoUrl { get; set; } = string.Empty;
        public bool IsFeatured { get; set; }
        public decimal MinPrice { get; set; }
        public decimal? MinOriginalPrice { get; set; }
        public decimal? OldPrice { get; set; }
        public int DiscountPercent { get; set; }
        public string? PromotionType { get; set; } // "Percentage", "Amount", "FlashSale"
        public int SoldCount { get; set; }
        public int StockCount { get; set; }
        public string PrimaryImageUrl { get; set; } = string.Empty;
        public int DefaultVariantId { get; set; }
        public bool IsInStock { get; set; }
        
        public bool IsFlashSale { get; set; }
        public decimal? FlashSalePrice { get; set; }
        public int FlashSalePercent { get; set; }
        public int? FlashSaleQuantity { get; set; }
        public int? FlashSaleSoldQuantity { get; set; }
        public DateTime? FlashSaleEndDate { get; set; }
        public DateTime CreatedDate { get; set; }

        public int CalculatedDiscountPercent
        {
            get
            {
                if (MinOriginalPrice.HasValue && MinOriginalPrice > MinPrice && MinOriginalPrice > 0)
                    return (int)Math.Round((1 - MinPrice / MinOriginalPrice.Value) * 100);
                return 0;
            }
        }

        public List<ProductVariantDto> Variants { get; set; } = new List<ProductVariantDto>();
        public List<ProductImageDto> Images { get; set; } = new List<ProductImageDto>();
        public List<ProductReviewDto> Reviews { get; set; } = new List<ProductReviewDto>();
        public List<string> UsageNames { get; set; } = new List<string>();
    }

    public class ProductReviewDto
    {
        public int ReviewId { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string? AvatarUrl { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public bool IsApproved { get; set; }
        public List<string> ReviewImages { get; set; } = new List<string>();
    }

    public class ProductVariantDto
    {
        public int ProductVariantId { get; set; }
        public string VariantName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public decimal? OriginalPrice { get; set; }
        public string SKU { get; set; } = string.Empty;
        public int StockQuantity { get; set; }
        public string ImageUrl { get; set; } = string.Empty;
        public List<VariantAttributeDto> VariantAttributeValues { get; set; } = new List<VariantAttributeDto>();
    }

    public class VariantAttributeDto
    {
        public string AttributeName { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
    }

    public class ProductImageDto
    {
        public int ImageId { get; set; }
        public string ImageUrl { get; set; } = string.Empty;
        public bool IsPrimary { get; set; }
        public int DisplayOrder { get; set; }
    }
}
