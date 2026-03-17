using System;

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
    }
}
