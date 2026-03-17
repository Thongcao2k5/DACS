using MotoShop.Business.DTOs;
using System.Collections.Generic;

namespace MotoShop.Models.ViewModels
{
    public class HomeViewModel
    {
        public IEnumerable<ProductDto> FeaturedProducts { get; set; }
        public IEnumerable<ProductDto> BestSellingProducts { get; set; }
        public IEnumerable<ProductDto> NewProducts { get; set; }
    }
}
