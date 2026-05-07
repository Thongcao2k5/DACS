using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MotoShop.Models.ViewModels
{
    public class ProductCreateViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập tên sản phẩm")]
        public string ProductName { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int? CategoryId { get; set; }
        public int? BrandId { get; set; }
        public bool IsFeatured { get; set; }
        public bool IsActive { get; set; } = true;

        [Display(Name = "Hình ảnh sản phẩm")]
        public List<IFormFile> Images { get; set; } = new List<IFormFile>();

        // Danh sách biến thể
        public List<VariantViewModel> Variants { get; set; } = new List<VariantViewModel>();
    }

    public class VariantViewModel
    {
        public int ProductVariantId { get; set; } // Thêm trường này
        public string VariantName { get; set; } = string.Empty;
        public string SKU { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }
    }
}
