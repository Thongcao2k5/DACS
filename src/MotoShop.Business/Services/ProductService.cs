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
            return await GetPagedProductsAsync(null, null, null, "newest", pageNumber, pageSize);
        }

        public async Task<PagedList<ProductDto>> GetPagedProductsAsync(
            string? searchTerm,
            int? categoryId,
            int? brandId,
            string? sort,
            int page,
            int pageSize,
            decimal? minPrice = null,
            decimal? maxPrice = null,
            bool? inStock = null,
            bool? onSale = null)
        {
            var query = _productRepository.Find(p => p.IsActive && !p.IsDeleted)
                .AsNoTracking()
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
                                       (p.Description != null && p.Description.ToLower().Contains(search)) ||
                                       (p.Brand != null && p.Brand.BrandName.ToLower().Contains(search)) ||
                                       (p.Category != null && p.Category.CategoryName.ToLower().Contains(search)) ||
                                       p.Variants.Any(v => v.SKU != null && v.SKU.ToLower().Contains(search)));
            }

            // Lọc theo danh mục
            if (categoryId.HasValue && categoryId.Value > 0)
            {
                query = query.Where(p => p.CategoryId == categoryId.Value);
            }

            // Lọc theo thương hiệu
            if (brandId.HasValue && brandId.Value > 0)
            {
                query = query.Where(p => p.BrandId == brandId.Value);
            }

            // Lọc theo giá
            if (minPrice.HasValue)
            {
                query = query.Where(p => p.Variants.Any(v => v.Price >= minPrice.Value));
            }
            if (maxPrice.HasValue)
            {
                query = query.Where(p => p.Variants.Any(v => v.Price <= maxPrice.Value));
            }

            // Lọc còn hàng
            if (inStock == true)
            {
                query = query.Where(p => p.Variants.Any(v => v.StockQuantity > 0));
            }

            // Lọc đang giảm giá (Giá hiện tại < Giá gốc)
            if (onSale == true)
            {
                query = query.Where(p => p.Variants.Any(v => v.OriginalPrice != null && v.OriginalPrice > v.Price));
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

            var dtoQuery = query.ProjectTo<ProductDto>(_mapper.ConfigurationProvider);
            return await PagedList<ProductDto>.CreateAsync(dtoQuery, page, pageSize);
        }

        public async Task<decimal> GetMaxProductPriceAsync()
        {
            return await _uow.Repository<ProductVariant>().Find(v => true).MaxAsync(v => (decimal?)v.Price) ?? 10000000;
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

        public async Task<IEnumerable<ProductDto>> GetPromotionProductsAsync(int count)
        {
            return await _productRepository.Find(p => p.IsActive && p.IsFeatured)
                .OrderByDescending(p => p.CreatedDate)
                .Take(count)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();
        }

        public async Task<IEnumerable<ProductDto>> GetRandomProductsAsync(int count)
        {
            var products = await _productRepository.Find(p => p.IsActive)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .OrderBy(p => Guid.NewGuid())
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
                    .ThenInclude(v => v.VariantAttributeValues)
                        .ThenInclude(vav => vav.AttributeValue)
                            .ThenInclude(av => av.ProductAttribute)
                .Include(p => p.Reviews)
                    .ThenInclude(r => r.Customer)
                .FirstOrDefaultAsync();

            return _mapper.Map<ProductDto>(product);
        }

        public async Task<IEnumerable<ProductDto>> GetRelatedProductsAsync(int productId, int? categoryId, int? brandId, int count)
        {
            var query = _productRepository.Find(p => p.ProductId != productId && p.IsActive)
                .Include(p => p.Images)
                .Include(p => p.Variants);

            var related = await query
                .Where(p => p.CategoryId == categoryId || p.BrandId == brandId)
                .OrderByDescending(p => (p.CategoryId == categoryId ? 2 : 0) + (p.BrandId == brandId ? 1 : 0))
                .Take(count)
                .ToListAsync();

            return _mapper.Map<IEnumerable<ProductDto>>(related);
        }

        public async Task<IEnumerable<CouponDto>> GetVouchersForProductAsync(int productId)
        {
            var product = await _uow.Repository<Product>().GetByIdAsync(productId);
            if (product == null) return Enumerable.Empty<CouponDto>();

            var allActiveCoupons = await _uow.Repository<Coupon>().Find(c => c.IsActive 
                && c.ExpiryDate >= DateTime.Now 
                && (c.UsageLimit == 0 || c.UsedCount < c.UsageLimit))
                .ToListAsync();

            var filteredCoupons = allActiveCoupons.Where(c => 
                c.IsAllProducts == true || 
                (!string.IsNullOrEmpty(c.AppliedProductIds) && c.AppliedProductIds.Split(',').Contains(productId.ToString())) ||
                (product.CategoryId.HasValue && !string.IsNullOrEmpty(c.AppliedCategoryIds) && c.AppliedCategoryIds.Split(',').Contains(product.CategoryId.Value.ToString()))
            )
            .OrderByDescending(c => c.DiscountValue)
            .Take(3)
            .ToList();

            return _mapper.Map<IEnumerable<CouponDto>>(filteredCoupons);
        }

        public async Task<bool> CanUserReviewProductAsync(string userId, int productId)
        {
            if (string.IsNullOrEmpty(userId)) return false;

            return await _uow.Repository<OrderItem>().Find(oi => 
                oi.Order.Customer.UserId == userId && 
                oi.ProductVariant.ProductId == productId &&
                (oi.Order.Status == "Completed" || oi.Order.Status == "DaHoanThanh"))
                .AnyAsync();
        }
    }
}
