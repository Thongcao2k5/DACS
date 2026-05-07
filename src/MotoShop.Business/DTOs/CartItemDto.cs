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
        public string ProductName { get; set; } = string.Empty;
        public string? VariantName { get; set; }
        public string ImageUrl { get; set; } = string.Empty;
        public decimal Price { get; set; } // Đây là giá bán thực tế (đã giảm nếu có promotion)
        public decimal OriginalPrice { get; set; } // Giá gốc ban đầu
        public decimal PromotionDiscount => OriginalPrice - Price; // Số tiền giảm cho mỗi sản phẩm
        public int Quantity { get; set; }
        public decimal Total => Price * Quantity;
        public decimal TotalOriginal => OriginalPrice * Quantity;
        public decimal TotalDiscount => PromotionDiscount * Quantity;
        public int StockQuantity { get; set; } // Để check tồn kho real-time
    }
}
