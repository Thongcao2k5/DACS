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
            int page,
            int pageSize,
            decimal? minPrice = null,
            decimal? maxPrice = null,
            bool? inStock = null,
            bool? onSale = null
        );
        Task<IEnumerable<CategoryDto>> GetAllCategoriesAsync();
        Task<IEnumerable<BrandDto>> GetAllBrandsAsync();
        Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count);
        Task<IEnumerable<ProductDto>> GetRandomProductsAsync(int count);
        Task<IEnumerable<ProductDto>> GetPromotionProductsAsync(int count);
        Task<ProductDto> GetProductBySlugAsync(string slug);
        Task<IEnumerable<ProductDto>> GetRelatedProductsAsync(int productId, int? categoryId, int? brandId, int count);
        Task<IEnumerable<CouponDto>> GetVouchersForProductAsync(int productId);
        Task<bool> CanUserReviewProductAsync(string userId, int productId);
        Task<decimal> GetMaxProductPriceAsync();
    }
}
