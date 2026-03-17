using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IProductService
    {
        Task<PagedList<ProductDto>> GetPagedProductsAsync(int pageNumber, int pageSize);
        Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count);
        Task<ProductDto> GetProductBySlugAsync(string slug);
    }
}
