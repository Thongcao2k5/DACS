using System;
using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class FlashSaleViewModel
    {
        public int FlashSaleId { get; set; }
        public string Title { get; set; } = string.Empty;
        public DateTime EndDate { get; set; }
        public List<HomeFlashSaleProductDto> Products { get; set; } = new();
    }

    public class HomeFlashSaleProductDto
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string? Slug { get; set; }
        public string? ImageUrl { get; set; }
        public decimal FlashSalePrice { get; set; }
        public decimal OriginalPrice { get; set; }
        public int DiscountPercent { get; set; }
        public int Quantity { get; set; }
        public int SoldQuantity { get; set; }
        public int SoldPercent { get; set; }
    }

    public class BrandWithProductsDto
    {
        public int BrandId { get; set; }
        public string BrandName { get; set; } = string.Empty;
        public string? LogoUrl { get; set; }
        public int TotalCount { get; set; }
        public List<ProductDto> Products { get; set; } = new();
    }

    public class CategoryWithProductsDto
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; } = string.Empty;
        public string? Slug { get; set; }
        public int TotalCount { get; set; }
        public List<ProductDto> Products { get; set; } = new();
    }
}
