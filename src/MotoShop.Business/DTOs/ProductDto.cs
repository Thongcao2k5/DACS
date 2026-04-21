using System;
using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class ProductDto
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Slug { get; set; }
        public string Description { get; set; }
        public string CategoryName { get; set; }
        public string BrandName { get; set; }
        public bool IsFeatured { get; set; }
        public decimal MinPrice { get; set; }
        public decimal? MinOriginalPrice { get; set; }
        public string PrimaryImageUrl { get; set; }
        public int DefaultVariantId { get; set; }
        public List<ProductVariantDto> Variants { get; set; } = new List<ProductVariantDto>();
        public List<ProductImageDto> Images { get; set; } = new List<ProductImageDto>();
        public List<ProductReviewDto> Reviews { get; set; } = new List<ProductReviewDto>();
    }

    public class ProductReviewDto
    {
        public int ReviewId { get; set; }
        public string CustomerName { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsApproved { get; set; }
    }

    public class ProductVariantDto
    {
        public int ProductVariantId { get; set; }
        public string VariantName { get; set; }
        public decimal Price { get; set; }
        public decimal? OriginalPrice { get; set; }
        public string SKU { get; set; }
        public int StockQuantity { get; set; }
        public string ImageUrl { get; set; }
        public List<VariantAttributeDto> AttributeValues { get; set; } = new List<VariantAttributeDto>();
    }

    public class VariantAttributeDto
    {
        public string AttributeName { get; set; }
        public string Value { get; set; }
    }

    public class ProductImageDto
    {
        public int ImageId { get; set; }
        public string ImageUrl { get; set; }
        public bool IsPrimary { get; set; }
        public int DisplayOrder { get; set; }
    }
}
