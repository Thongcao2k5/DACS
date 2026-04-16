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
        public decimal MinPrice { get; set; }
        public string PrimaryImageUrl { get; set; }
        public int DefaultVariantId { get; set; }
        public List<ProductVariantDto> Variants { get; set; } = new List<ProductVariantDto>();
        public List<ProductImageDto> Images { get; set; } = new List<ProductImageDto>();
    }

    public class ProductVariantDto
    {
        public int ProductVariantId { get; set; }
        public string VariantName { get; set; }
        public decimal Price { get; set; }
        public string SKU { get; set; }
        public int StockQuantity { get; set; }
        public string ImageUrl { get; set; }
    }

    public class ProductImageDto
    {
        public int ImageId { get; set; }
        public string ImageUrl { get; set; }
        public bool IsPrimary { get; set; }
        public int DisplayOrder { get; set; }
    }
}
