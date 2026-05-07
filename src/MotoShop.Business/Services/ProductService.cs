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
            bool? onSale = null,
            IEnumerable<int>? productIds = null)
        {
            var query = _productRepository.Find(p => p.IsActive && !p.IsDeleted)
                .AsNoTracking()
                .AsQueryable();

            // Lọc theo danh sách ID cụ thể (nếu có)
            if (productIds != null && productIds.Any())
            {
                // Nếu onSale không được set là true, ta lọc cứng theo list IDs này
                // Nếu onSale = true, ta sẽ kết hợp ở phần lọc onSale bên dưới
                if (onSale != true)
                {
                    query = query.Where(p => productIds.Contains(p.ProductId));
                }
            }

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

            // Lọc đang giảm giá
            if (onSale == true)
            {
                if (productIds != null && productIds.Any())
                {
                    // Lấy sản phẩm có giảm giá TRONG variant HOẶC nằm trong list IDs khuyến mãi
                    query = query.Where(p => productIds.Contains(p.ProductId) || p.Variants.Any(v => v.OriginalPrice != null && v.OriginalPrice > v.Price));
                }
                else
                {
                    query = query.Where(p => p.Variants.Any(v => v.OriginalPrice != null && v.OriginalPrice > v.Price));
                }
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
            return await _uow.Repository<ProductVariant>().Find(v => true).AsNoTracking().MaxAsync(v => (decimal?)v.Price) ?? 10000000;
        }

        public async Task<IEnumerable<CategoryDto>> GetAllCategoriesAsync()
        {
            var categories = await _uow.Repository<Category>().Find(c => true).AsNoTracking().ToListAsync();
            return _mapper.Map<IEnumerable<CategoryDto>>(categories);
        }

        public async Task<IEnumerable<BrandDto>> GetAllBrandsAsync()
        {
            var brands = await _uow.Repository<Brand>().Find(b => true).AsNoTracking().ToListAsync();
            return _mapper.Map<IEnumerable<BrandDto>>(brands);
        }

        public async Task<IEnumerable<ProductDto>> GetFeaturedProductsAsync(int count)
        {
            return await _productRepository.Find(p => p.IsFeatured && p.IsActive && !p.IsDeleted)
                .AsNoTracking()
                .OrderByDescending(p => p.CreatedDate)
                .Take(count)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();
        }

        public async Task<IEnumerable<ProductDto>> GetPromotionProductsAsync(int count)
        {
            return await _productRepository.Find(p => p.IsActive && p.IsFeatured)
                .AsNoTracking()
                .OrderByDescending(p => p.CreatedDate)
                .Take(count)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();
        }

        public async Task<IEnumerable<ProductDto>> GetRandomProductsAsync(int count)
        {
            return await _productRepository.Find(p => p.IsActive)
                .AsNoTracking()
                .OrderBy(p => p.ProductId) 
                .Take(count)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();
        }

        public async Task<ProductDto?> GetProductBySlugAsync(string slug)
        {
            var productQuery = _productRepository.Find(p => p.Slug == slug && p.IsActive)
                .AsNoTracking()
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider);

            return await productQuery.FirstOrDefaultAsync();
        }

        public async Task<List<ProductDto>> GetRelatedProductsAsync(
            int productId,
            int categoryId,
            int brandId,
            int take = 8)
        {
            // TẦNG 1: Cùng cả Category lẫn Brand
            var tier1 = await _uow.Repository<Product>()
                .Find(p =>
                    p.IsActive &&
                    p.ProductId != productId &&
                    p.CategoryId == categoryId &&
                    p.BrandId == brandId)
                .AsNoTracking()
                .OrderByDescending(p => p.IsFeatured)
                .ThenByDescending(p => p.CreatedDate)
                .Take(take)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();

            if (tier1.Count >= take)
                return tier1.Take(take).ToList();

            // TẦNG 2: Cùng Category
            var existingIds = tier1.Select(p => p.ProductId).ToHashSet();
            existingIds.Add(productId);

            var tier2 = await _uow.Repository<Product>()
                .Find(p =>
                    p.IsActive &&
                    !existingIds.Contains(p.ProductId) &&
                    p.CategoryId == categoryId)
                .AsNoTracking()
                .OrderByDescending(p => p.IsFeatured)
                .ThenByDescending(p => p.CreatedDate)
                .Take(take - tier1.Count)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();

            var result = tier1.Concat(tier2).ToList();

            if (result.Count >= take)
                return result.Take(take).ToList();

            // TẦNG 3: Cùng Brand
            existingIds = result.Select(p => p.ProductId).ToHashSet();
            existingIds.Add(productId);

            var tier3 = await _uow.Repository<Product>()
                .Find(p =>
                    p.IsActive &&
                    !existingIds.Contains(p.ProductId) &&
                    p.BrandId == brandId)
                .AsNoTracking()
                .OrderByDescending(p => p.IsFeatured)
                .ThenByDescending(p => p.CreatedDate)
                .Take(take - result.Count)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();

            return result.Concat(tier3).Take(take).ToList();
        }

        public async Task<IEnumerable<CouponDto>> GetVouchersForProductAsync(int productId)
        {
            var product = await _uow.Repository<Product>().Find(p => p.ProductId == productId).AsNoTracking().FirstOrDefaultAsync();
            if (product == null) return Enumerable.Empty<CouponDto>();

            var allActiveCoupons = await _uow.Repository<Coupon>().Find(c => c.IsActive 
                && c.ExpiryDate >= DateTime.Now 
                && (c.UsageLimit == 0 || c.UsedCount < c.UsageLimit))
                .AsNoTracking()
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
                oi.Order != null && oi.Order.Customer != null && oi.Order.Customer.UserId == userId && 
                oi.ProductVariant != null && oi.ProductVariant.ProductId == productId &&
                (oi.Order.Status == "Completed" || oi.Order.Status == "DaHoanThanh"))
                .AsNoTracking()
                .AnyAsync();
        }

        public async Task<Dictionary<int, int>> GetProductCountByCategoryAsync()
        {
            return await _productRepository.Find(p => p.IsActive && !p.IsDeleted)
                .GroupBy(p => p.CategoryId)
                .Select(g => new { CategoryId = g.Key ?? 0, Count = g.Count() })
                .ToDictionaryAsync(x => x.CategoryId, x => x.Count);
        }

        public async Task<Dictionary<int, int>> GetProductCountByBrandAsync()
        {
            return await _productRepository.Find(p => p.IsActive && !p.IsDeleted)
                .GroupBy(p => p.BrandId)
                .Select(g => new { BrandId = g.Key ?? 0, Count = g.Count() })
                .ToDictionaryAsync(x => x.BrandId, x => x.Count);
        }

        public async Task<FlashSaleViewModel?> GetActiveFlashSaleAsync()
        {
            var now = DateTime.Now;

            var flashSale = await _uow.Repository<FlashSale>().Find(fs =>
                fs.IsActive &&
                fs.StartDate <= now &&
                fs.EndDate >= now)
                .AsNoTracking()
                .Include(fs => fs.FlashSaleProducts)
                    .ThenInclude(fsp => fsp.Product)
                        .ThenInclude(p => p!.Variants)
                .Include(fs => fs.FlashSaleProducts)
                    .ThenInclude(fsp => fsp.Product)
                        .ThenInclude(p => p!.Images)
                .OrderByDescending(fs => fs.StartDate)
                .FirstOrDefaultAsync();

            if (flashSale == null) return null;

            return new FlashSaleViewModel
            {
                FlashSaleId = flashSale.FlashSaleId,
                Title = flashSale.Title,
                EndDate = flashSale.EndDate,
                Products = flashSale.FlashSaleProducts
                    .Where(fsp => fsp.Quantity > fsp.SoldQuantity && fsp.Product != null)
                    .Select(fsp => new HomeFlashSaleProductDto
                    {
                        ProductId = fsp.ProductId,
                        ProductName = fsp.Product!.ProductName,
                        Slug = fsp.Product.Slug,
                        ImageUrl = fsp.Product.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault() 
                                   ?? fsp.Product.Images.Select(i => i.ImageUrl).FirstOrDefault(),
                        FlashSalePrice = fsp.FlashSalePrice,
                        OriginalPrice = fsp.Product.Variants.Any() ? fsp.Product.Variants.Min(v => v.Price) : 0,
                        DiscountPercent = (int)Math.Round((1 - fsp.FlashSalePrice / (fsp.Product.Variants.Any() ? fsp.Product.Variants.Min(v => v.Price) : 1)) * 100),
                        Quantity = fsp.Quantity,
                        SoldQuantity = fsp.SoldQuantity,
                        SoldPercent = fsp.Quantity > 0 ? (int)Math.Round((decimal)fsp.SoldQuantity / fsp.Quantity * 100) : 0
                    })
                    .ToList()
            };
        }

        public async Task<PagedList<ProductDto>> GetPagedDiscountProductsAsync(int pageNumber, int pageSize, string sort = "newest")
        {
            var now = DateTime.Now;

            // 1. Lấy danh sách Promotion đang kích hoạt
            var activePromotionProducts = await _uow.Repository<PromotionProduct>()
                .Find(pp => pp.Promotion != null && pp.Promotion.IsActive && pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now)
                .Include(pp => pp.Promotion)
                .Select(pp => new { pp.ProductId, pp.Promotion })
                .ToListAsync();

            var promoProductIds = activePromotionProducts.Select(p => p.ProductId).Distinct().ToList();

            // 2. Lấy sản phẩm (Lọc: Có trong Promotion Campaign HOẶC có giá giảm Variant HOẶC là Flash Sale)
            // Lưu ý: onSale=true trong GetPagedProductsAsync sẽ lấy những sp có Variant.OriginalPrice > Price
            var pagedResult = await GetPagedProductsAsync(
                null, null, null, sort, pageNumber, pageSize, null, null, true, true, promoProductIds
            );

            // 3. Xử lý logic nhãn và giá "phân biệt rõ" (Shopee Style)
            var items = pagedResult.ToList();
            foreach (var item in items)
            {
                // Mặc định PromotionType từ Variant Sale nếu có
                if (item.MinOriginalPrice > item.MinPrice)
                {
                    item.PromotionType = "RegularSale";
                }

                // Nếu có trong chiến dịch Promotion (Ưu tiên cao hơn Regular Sale)
                var promoMatch = activePromotionProducts.FirstOrDefault(p => p.ProductId == item.ProductId);
                if (promoMatch != null && promoMatch.Promotion != null)
                {
                    var p = promoMatch.Promotion;
                    decimal basePrice = item.MinOriginalPrice ?? item.MinPrice;
                    decimal discountedPrice = basePrice;

                    if (p.DiscountType == "Percentage")
                        discountedPrice = basePrice * (1 - p.DiscountPercentage / 100);
                    else
                        discountedPrice = Math.Max(0, basePrice - p.DiscountAmount);

                    // Chỉ áp dụng nếu giá Promotion thực sự rẻ hơn
                    if (discountedPrice < item.MinPrice || item.MinOriginalPrice == null)
                    {
                        item.MinPrice = discountedPrice;
                        item.MinOriginalPrice = basePrice;
                        item.PromotionType = "Promotion"; // Nhãn Ưu đãi
                    }
                }

                // Nếu đang trong Flash Sale (Ưu tiên hiển thị cao nhất)
                if (item.IsFlashSale)
                {
                    // Flash Sale Price đã được MappingProfile lấy sẵn vào item.FlashSalePrice
                    if (item.FlashSalePrice.HasValue && item.FlashSalePrice.Value > 0)
                    {
                        item.MinPrice = item.FlashSalePrice.Value;
                        item.PromotionType = "FlashSale"; // Nhãn Flash Sale
                    }
                }

                // Cuối cùng tính toán lại % giảm giá hiển thị và đồng bộ giá cũ
                if (item.MinOriginalPrice > item.MinPrice && item.MinOriginalPrice > 0)
                {
                    item.DiscountPercent = (int)Math.Round((1 - item.MinPrice / item.MinOriginalPrice.Value) * 100);
                    item.OldPrice = item.MinOriginalPrice;
                }
            }

            return pagedResult;
        }

        public async Task<List<BrandWithProductsDto>> GetBrandWithProductsAsync(int brandsCount = 4, int productsPerBrand = 6)
        {
            var topBrands = await _uow.Repository<Brand>().Find(b => b.Products.Any(p => p.IsActive && !p.IsDeleted))
                .AsNoTracking()
                .OrderByDescending(b => b.Products.Count(p => p.IsActive && !p.IsDeleted))
                .Take(brandsCount)
                .ToListAsync();

            var result = new List<BrandWithProductsDto>();
            foreach (var brand in topBrands)
            {
                var products = await _productRepository.Find(p => p.IsActive && !p.IsDeleted && p.BrandId == brand.BrandId)
                    .AsNoTracking()
                    .OrderByDescending(p => p.IsFeatured)
                    .Take(productsPerBrand)
                    .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                    .ToListAsync();

                result.Add(new BrandWithProductsDto
                {
                    BrandId = brand.BrandId,
                    BrandName = brand.BrandName,
                    LogoUrl = brand.LogoUrl,
                    Products = products,
                    TotalCount = await _productRepository.Find(p => p.IsActive && !p.IsDeleted && p.BrandId == brand.BrandId).AsNoTracking().CountAsync()
                });
            }
            return result;
        }

        public async Task<List<CategoryWithProductsDto>> GetCategoryWithProductsAsync(int categoriesCount = 4, int productsPerCategory = 4)
        {
            var topCats = await _uow.Repository<Category>().Find(c => c.ParentId == null && c.Products.Any(p => p.IsActive && !p.IsDeleted))
                .AsNoTracking()
                .OrderByDescending(c => c.Products.Count(p => p.IsActive && !p.IsDeleted))
                .Take(categoriesCount)
                .ToListAsync();

            var result = new List<CategoryWithProductsDto>();
            foreach (var cat in topCats)
            {
                var products = await _productRepository.Find(p => p.IsActive && !p.IsDeleted && (p.CategoryId == cat.CategoryId || p.Category!.ParentId == cat.CategoryId))
                    .AsNoTracking()
                    .OrderByDescending(p => p.IsFeatured)
                    .Take(productsPerCategory)
                    .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                    .ToListAsync();

                result.Add(new CategoryWithProductsDto
                {
                    CategoryId = cat.CategoryId,
                    CategoryName = cat.CategoryName,
                    Slug = cat.Slug,
                    Products = products,
                    TotalCount = await _productRepository.Find(p => p.IsActive && !p.IsDeleted && (p.CategoryId == cat.CategoryId || p.Category!.ParentId == cat.CategoryId)).AsNoTracking().CountAsync()
                });
            }
            return result;
        }
    }
}
