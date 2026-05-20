using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IProductService
    {
        Task<PagedList<ProductDto>> GetPagedProductsAsync(int pageNumber, int pageSize);
        Task<PagedList<ProductDto>> GetPagedProductsAsync(
            string? searchTerm,
            int? categoryId,
            int? brandId,
            string? sort,
            int pageNumber,
            int pageSize,
            decimal? minPrice = null,
            decimal? maxPrice = null,
            bool? inStock = null,
            bool? onSale = null,
            string? usageSlug = null,
            IEnumerable<int>? productIds = null
        );
        Task<IEnumerable<CategoryDto>> GetAllCategoriesAsync();
        Task<IEnumerable<BrandDto>> GetAllBrandsAsync();
        Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count);
        Task<IEnumerable<ProductDto>> GetRandomProductsAsync(int count);
        Task<IEnumerable<ProductDto>> GetPromotionProductsAsync(int count);
        Task<ProductDto?> GetProductBySlugAsync(string slug);
        Task<List<ProductDto>> GetRelatedProductsAsync(int productId, int categoryId, int brandId, int take = 8);
        Task<IEnumerable<CouponDto>> GetVouchersForProductAsync(int productId);
        Task<bool> CanUserReviewProductAsync(string userId, int productId);
        Task<decimal> GetMaxProductPriceAsync();
        
        // Homepage & Sidebar Display Enhancements
        Task<Dictionary<int, int>> GetProductCountByCategoryAsync();
        Task<Dictionary<int, int>> GetProductCountByBrandAsync();
        Task<FlashSaleViewModel?> GetActiveFlashSaleAsync();
        Task<PagedList<ProductDto>> GetPagedDiscountProductsAsync(int pageNumber, int pageSize, string sort = "newest");
        Task<List<BrandWithProductsDto>> GetBrandWithProductsAsync(int brandsCount = 4, int productsPerBrand = 6);
        Task<List<CategoryWithProductsDto>> GetCategoryWithProductsAsync(int categoriesCount = 4, int productsPerCategory = 4);
    }
}
