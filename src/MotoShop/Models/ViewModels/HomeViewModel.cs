using MotoShop.Business.DTOs;
using System.Collections.Generic;

namespace MotoShop.Models.ViewModels
{
    public class HomeViewModel
    {
        public IEnumerable<ProductDto> FeaturedProducts { get; set; } = new List<ProductDto>();
        public IEnumerable<ProductDto> BestSellingProducts { get; set; } = new List<ProductDto>();
        public IEnumerable<ProductDto> NewProducts { get; set; } = new List<ProductDto>();
        public IEnumerable<CategoryDto> TopCategories { get; set; } = new List<CategoryDto>();
    }
}
