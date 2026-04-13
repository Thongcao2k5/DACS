using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IProductService
    {
        Task<PagedList<ProductDto>> GetPagedProductsAsync(int pageNumber, int pageSize);
        Task<PagedList<ProductDto>> GetPagedProductsAsync(
            string searchTerm,
            int? categoryId,
            int? brandId,
            string sort,
            int page,
            int pageSize
        );
        Task<IEnumerable<CategoryDto>> GetAllCategoriesAsync();
        Task<IEnumerable<BrandDto>> GetAllBrandsAsync();
        Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count);
        Task<IEnumerable<ProductDto>> GetRandomProductsAsync(int count);
        Task<ProductDto> GetProductBySlugAsync(string slug);
    }
}
