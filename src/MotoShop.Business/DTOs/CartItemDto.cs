using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MotoShop.Business.DTOs
{
    public class CartItemDto
    {
        public int ProductVariantId { get; set; }
        public string ProductName { get; set; }
        public string? VariantName { get; set; }
        public string ImageUrl { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public decimal Total => Price * Quantity;
        public int StockQuantity { get; set; } // Để check tồn kho real-time
    }
}
