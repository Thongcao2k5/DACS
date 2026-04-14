using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class ProductService : IProductService
    {
        private readonly IProductRepository _productRepository;
        private readonly IUnitOfWork _uow;
        private readonly IMapper _mapper;

        public ProductService(IProductRepository productRepository, IUnitOfWork uow, IMapper mapper)
        {
            _productRepository = productRepository;
            _uow = uow;
            _mapper = mapper;
        }

        public async Task<PagedList<ProductDto>> GetPagedProductsAsync(int pageNumber, int pageSize)
        {
            return await GetPagedProductsAsync(
                searchTerm: null,
                categoryIds: null,
                brandIds: null,
                minPrice: null,
                maxPrice: null,
                sort: "newest",
                page: pageNumber,
                pageSize: pageSize);
        }

        public async Task<PagedList<ProductDto>> GetPagedProductsAsync(
            string? searchTerm,
            int[]? categoryIds,
            int[]? brandIds,
            decimal? minPrice,
            decimal? maxPrice,
            string? sort,
            int page,
            int pageSize)
        {
            var query = _productRepository.Find(p => p.IsActive)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .AsQueryable();

            // Lọc theo từ khóa
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                var search = searchTerm.Trim().ToLower();
                query = query.Where(p => p.ProductName.ToLower().Contains(search) || 
                                       (p.Description != null && p.Description.ToLower().Contains(search)));
            }

            // Lọc theo danh sách danh mục
            if (categoryIds != null && categoryIds.Length > 0)
            {
                query = query.Where(p => p.CategoryId.HasValue && categoryIds.Contains(p.CategoryId.Value));
            }

            // Lọc theo danh sách thương hiệu
            if (brandIds != null && brandIds.Length > 0)
            {
                query = query.Where(p => p.BrandId.HasValue && brandIds.Contains(p.BrandId.Value));
            }

            // Lọc theo khoảng giá (Dựa trên giá của biến thể)
            if (minPrice.HasValue)
            {
                query = query.Where(p => p.Variants.Any(v => v.Price >= minPrice.Value));
            }
            if (maxPrice.HasValue)
            {
                query = query.Where(p => p.Variants.Any(v => v.Price <= maxPrice.Value));
            }

            // Sắp xếp
            query = sort?.ToLower() switch
            {
                "az" => query.OrderBy(p => p.ProductName),
                "za" => query.OrderByDescending(p => p.ProductName),
                "price_asc" => query.OrderBy(p => p.Variants.Any() ? p.Variants.Min(v => v.Price) : 0),
                "price_desc" => query.OrderByDescending(p => p.Variants.Any() ? p.Variants.Max(v => v.Price) : 0),
                "newest" => query.OrderByDescending(p => p.CreatedDate),
                _ => query.OrderByDescending(p => p.CreatedDate)
            };

            // Project sang DTO để tối ưu hiệu suất (chỉ lấy các trường cần thiết)
            var dtoQuery = query.ProjectTo<ProductDto>(_mapper.ConfigurationProvider);
            return await PagedList<ProductDto>.CreateAsync(dtoQuery, page, pageSize);
        }

        public async Task<IEnumerable<CategoryDto>> GetAllCategoriesAsync()
        {
            var categories = await _uow.Repository<Category>().GetAllAsync();
            return _mapper.Map<IEnumerable<CategoryDto>>(categories);
        }

        public async Task<IEnumerable<BrandDto>> GetAllBrandsAsync()
        {
            var brands = await _uow.Repository<Brand>().GetAllAsync();
            return _mapper.Map<IEnumerable<BrandDto>>(brands);
        }

        public async Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count)
        {
            var products = await _productRepository.GetFeaturedProductsAsync(count);
            return _mapper.Map<IEnumerable<ProductDto>>(products);
        }

        public async Task<IEnumerable<ProductDto>> GetRandomProductsAsync(int count)
        {
            var products = await _productRepository.Find(p => p.IsActive)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .OrderBy(p => Guid.NewGuid()) // Sắp xếp ngẫu nhiên
                .Take(count)
                .ToListAsync();

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
