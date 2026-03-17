using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MotoShop.Models.ViewModels
{
    public class ProductCreateViewModel
    {
        [Required(ErrorMessage = "Tên sản phẩm không được để trống")]
        public string ProductName { get; set; }
        public string Description { get; set; }
        public int? CategoryId { get; set; }
        public int? BrandId { get; set; }
        public bool IsFeatured { get; set; }
        public bool IsActive { get; set; } = true;

        [Display(Name = "Hình ảnh sản phẩm")]
        public List<IFormFile> Images { get; set; }
    }
}
