using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class ProductService : IProductService
    {
        private readonly IProductRepository _productRepository;
        private readonly IMapper _mapper;

        public ProductService(IProductRepository productRepository, IMapper mapper)
        {
            _productRepository = productRepository;
            _mapper = mapper;
        }

        public async Task<PagedList<ProductDto>> GetPagedProductsAsync(int pageNumber, int pageSize)
        {
            var source = _productRepository.Find(p => p.IsActive)
                .OrderByDescending(p => p.CreatedDate)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants);

            // Manual mapping for PagedList if ProjectTo is complex, but here we can try ProjectTo
            var query = source.ProjectTo<ProductDto>(_mapper.ConfigurationProvider);
            return await PagedList<ProductDto>.CreateAsync(query, pageNumber, pageSize);
        }

        public async Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count)
        {
            var products = await _productRepository.GetFeaturedProductsAsync(count);
            return _mapper.Map<IEnumerable<ProductDto>>(products);
        }

        public async Task<ProductDto> GetProductBySlugAsync(string slug)
        {
            var product = await _productRepository.Find(p => p.Slug == slug && p.IsActive)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .FirstOrDefaultAsync();

            return _mapper.Map<ProductDto>(product);
        }
    }
}
