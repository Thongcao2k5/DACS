using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Data.Interfaces
{
    public interface IProductRepository : IGenericRepository<Product>
    {
        Task<IEnumerable<Product>> GetFeaturedProductsAsync(int count);
        Task<IEnumerable<Product>> GetProductsByCategoryAsync(int categoryId);
        Task<ProductImage> FindImageByIdAsync(int imageId);
        void UpdateImage(ProductImage image);
    }
}
