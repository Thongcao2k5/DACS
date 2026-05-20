using MotoShop.Business.DTOs;
using MotoShop.Data.Models;
using MotoShop.Business.Helpers;
using System.Collections.Generic;

namespace MotoShop.Models.ViewModels
{
    public class ProductListViewModel
    {
        public PagedList<ProductDto> PagedProducts { get; set; } = default!;

        // Navigation / Filter data
        public List<CategoryDto> Categories { get; set; } = new();
        public List<BrandDto> Brands { get; set; } = new();

        public Dictionary<int, int> CategoryProductCount { get; set; } = new();
        public Dictionary<int, int> BrandProductCount { get; set; } = new();

        // Current state
        public string? CurrentKeyword { get; set; }
        public int? CurrentCategoryId { get; set; }
        public int? CurrentBrandId { get; set; }

        public string? CurrentSort { get; set; }
        public bool IsDiscountActive { get; set; }
        public bool IsInStockActive { get; set; }

        public decimal SelectedMinPrice { get; set; }
        public decimal SelectedMaxPrice { get; set; }
        public decimal MaxPriceLimit { get; set; }

        // Display helpers
        public string? PageTitle { get; set; }
        public string? PageSubtitle { get; set; }
    }
}
