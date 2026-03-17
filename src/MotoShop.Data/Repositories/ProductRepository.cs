using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Data.Repositories
{
    public class ProductRepository : GenericRepository<Product>, IProductRepository
    {
        public ProductRepository(MotoShopDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Product>> GetFeaturedProductsAsync(int count)
        {
            return await _dbSet
                .Where(p => p.IsFeatured && p.IsActive)
                .OrderByDescending(p => p.CreatedDate)
                .Take(count)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .ToListAsync();
        }

        public async Task<IEnumerable<Product>> GetProductsByCategoryAsync(int categoryId)
        {
            return await _dbSet
                .Where(p => p.CategoryId == categoryId && p.IsActive)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .ToListAsync();
        }

        public async Task<ProductImage> FindImageByIdAsync(int imageId)
        {
            return await _context.Set<ProductImage>().FindAsync(imageId);
        }

        public void UpdateImage(ProductImage image)
        {
            _context.Set<ProductImage>().Update(image);
        }
    }
}
