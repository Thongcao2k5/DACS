using System;
using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class FlashSaleDto
    {
        public int FlashSaleId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool IsActive { get; set; }
        public int ProductCount { get; set; }
        public string StatusText { get; set; } = string.Empty;
        public string StatusClass { get; set; } = string.Empty;

        // Extended properties for Frontend
        public List<ProductDto> Products { get; set; } = new List<ProductDto>();
        public bool IsUpcoming => DateTime.Now < StartDate;
        public bool IsExpired => DateTime.Now > EndDate;
        public bool IsRunning => DateTime.Now >= StartDate && DateTime.Now <= EndDate && IsActive;
    }

    public class FlashSaleProductDto
    {
        public int Id { get; set; }
        public int FlashSaleId { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string? ImageUrl { get; set; }
        public decimal OriginalPrice { get; set; }
        public decimal FlashSalePrice { get; set; }
        public int Quantity { get; set; }
        public int SoldQuantity { get; set; }
    }
}
