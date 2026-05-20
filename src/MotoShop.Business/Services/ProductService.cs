using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Enums;
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
            string? usageSlug = null,
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
                var search = MotoShop.Business.Helpers.VietnameseStringHelper.NormalizeKeyword(searchTerm);
                query = query.Where(p => 
                    EF.Functions.Collate(p.ProductName, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || p.ProductName.ToLower().Contains(search) || 
                    (p.Description != null && (EF.Functions.Collate(p.Description, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || p.Description.ToLower().Contains(search))) ||
                    (p.Brand != null && (EF.Functions.Collate(p.Brand.BrandName, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || p.Brand.BrandName.ToLower().Contains(search))) ||
                    (p.Category != null && (EF.Functions.Collate(p.Category.CategoryName, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || p.Category.CategoryName.ToLower().Contains(search))) ||
                    p.ProductProductUsages.Any(u => u.ProductUsage != null && (EF.Functions.Collate(u.ProductUsage.Name, "SQL_Latin1_General_CP1_CI_AI").Contains(search) || u.ProductUsage.Name.ToLower().Contains(search))) ||
                    p.Variants.Any(v => v.SKU != null && v.SKU.ToLower().Contains(search)));
            }

            // Lọc theo danh mục
            if (categoryId.HasValue && categoryId.Value > 0)
            {
                query = query.Where(p => p.CategoryId == categoryId.Value);
            }

            if (!string.IsNullOrWhiteSpace(usageSlug))
            {
                query = query.Where(p => p.ProductProductUsages.Any(u => u.ProductUsage != null && u.ProductUsage.Slug == usageSlug && u.ProductUsage.IsActive));
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

            // Manual Select thay vì ProjectTo — cho phép tính Flash Sale price trực tiếp trong SQL,
            // tránh subquery lồng phức tạp mà EF Core có thể không dịch được qua AutoMapper.
            var now = DateTime.Now;
            var dtoQuery = query.Select(p => new ProductDto
            {
                ProductId = p.ProductId,
                ProductName = p.ProductName,
                Slug = p.Slug ?? string.Empty,
                CategoryName = p.Category != null ? p.Category.CategoryName : string.Empty,
                CategoryId = p.CategoryId,
                BrandName = p.Brand != null ? p.Brand.BrandName : string.Empty,
                BrandLogoUrl = p.Brand != null ? (p.Brand.LogoUrl ?? string.Empty) : string.Empty,
                BrandId = p.BrandId,
                IsFeatured = p.IsFeatured,
                SoldCount = p.SoldCount,
                CreatedDate = p.CreatedDate,
                StockCount = p.Variants.Sum(v => v.StockQuantity),
                IsInStock = p.Variants.Any(v => v.StockQuantity > 0),
                DefaultVariantId = p.Variants.OrderBy(v => v.Price).Select(v => v.ProductVariantId).FirstOrDefault(),
                PrimaryImageUrl = p.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault()
                    ?? p.Images.Select(i => i.ImageUrl).FirstOrDefault() ?? string.Empty,
                MinOriginalPrice = p.Variants.OrderBy(v => v.Price).Select(v => (decimal?)(v.OriginalPrice ?? v.Price)).FirstOrDefault(),
                OldPrice = p.Variants.OrderBy(v => v.Price).Select(v => (decimal?)(v.OriginalPrice ?? v.Price)).FirstOrDefault(),
                IsFlashSale = p.PromotionProducts.Any(pp =>
                    pp.Promotion != null && pp.Promotion.IsActive &&
                    pp.Promotion.PromotionType == PromotionType.FlashSale &&
                    pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                    (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value)),
                FlashSaleEndDate = p.PromotionProducts
                    .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                 pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                 pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                                 (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                    .OrderByDescending(pp => pp.Promotion!.Priority)
                    .Select(pp => (DateTime?)pp.Promotion!.EndDate)
                    .FirstOrDefault(),
                FlashSaleQuantity = p.PromotionProducts
                    .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                 pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                 pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                                 (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                    .OrderByDescending(pp => pp.Promotion!.Priority)
                    .Select(pp => (int?)pp.Quantity)
                    .FirstOrDefault(),
                FlashSaleSoldQuantity = p.PromotionProducts
                    .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                 pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                 pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                                 (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                    .OrderByDescending(pp => pp.Promotion!.Priority)
                    .Select(pp => (int?)pp.SoldQuantity)
                    .FirstOrDefault(),
                FlashSalePrice = p.PromotionProducts
                    .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                 pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                 pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                                 (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                    .OrderByDescending(pp => pp.Promotion!.Priority)
                    .Select(pp => (decimal?)(
                        pp.Promotion!.DiscountType == DiscountType.Percent
                            ? p.Variants.Min(v => v.Price) * (1 - pp.Promotion.DiscountValue / 100m)
                            : p.Variants.Min(v => v.Price) > pp.Promotion.DiscountValue
                                ? p.Variants.Min(v => v.Price) - pp.Promotion.DiscountValue
                                : 0m))
                    .FirstOrDefault(),
                FlashSalePercent = (int)p.PromotionProducts
                    .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                 pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                 pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                                 (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                    .OrderByDescending(pp => pp.Promotion!.Priority)
                    .Select(pp => pp.Promotion!.DiscountType == DiscountType.Percent
                        ? pp.Promotion.DiscountValue : 0m)
                    .FirstOrDefault(),
                // MinPrice = Flash Sale price nếu đang có Flash Sale, ngược lại là giá gốc thấp nhất
                MinPrice = p.PromotionProducts.Any(pp =>
                    pp.Promotion != null && pp.Promotion.IsActive &&
                    pp.Promotion.PromotionType == PromotionType.FlashSale &&
                    pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                    (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                    ? (decimal)(p.PromotionProducts
                        .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                     pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                     pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now &&
                                     (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                        .OrderByDescending(pp => pp.Promotion!.Priority)
                        .Select(pp =>
                            pp.Promotion!.DiscountType == DiscountType.Percent
                                ? p.Variants.Min(v => v.Price) * (1 - pp.Promotion.DiscountValue / 100m)
                                : p.Variants.Min(v => v.Price) > pp.Promotion.DiscountValue
                                    ? p.Variants.Min(v => v.Price) - pp.Promotion.DiscountValue
                                    : 0m)
                        .FirstOrDefault())
                    : p.Variants.Select(v => v.Price).OrderBy(x => x).FirstOrDefault(),
            });
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
            // Use explicit Select instead of ProjectTo to avoid the expensive
            // correlated subqueries generated for IsFlashSale/FlashSalePrice/FlashSaleEndDate.
            var pool = await _productRepository.Find(p => p.IsActive && !p.IsDeleted)
                .AsNoTracking()
                .OrderByDescending(p => p.IsFeatured)
                .ThenByDescending(p => p.SoldCount)
                .Take(count * 4)
                .Select(p => new ProductDto
                {
                    ProductId = p.ProductId,
                    ProductName = p.ProductName,
                    Slug = p.Slug,
                    CategoryName = p.Category != null ? p.Category.CategoryName : string.Empty,
                    CategoryId = p.CategoryId,
                    BrandName = p.Brand != null ? p.Brand.BrandName : string.Empty,
                    BrandLogoUrl = p.Brand != null ? p.Brand.LogoUrl : string.Empty,
                    BrandId = p.BrandId,
                    IsFeatured = p.IsFeatured,
                    SoldCount = p.SoldCount,
                    CreatedDate = p.CreatedDate,
                    MinPrice = p.Variants.Select(v => v.Price).OrderBy(x => x).FirstOrDefault(),
                    MinOriginalPrice = p.Variants.OrderBy(v => v.Price).Select(v => (decimal?)(v.OriginalPrice ?? v.Price)).FirstOrDefault(),
                    OldPrice = p.Variants.OrderBy(v => v.Price).Select(v => (decimal?)(v.OriginalPrice ?? v.Price)).FirstOrDefault(),
                    DefaultVariantId = p.Variants.OrderBy(v => v.Price).Select(v => v.ProductVariantId).FirstOrDefault(),
                    PrimaryImageUrl = p.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault()
                        ?? p.Images.Select(i => i.ImageUrl).FirstOrDefault() ?? string.Empty,
                    StockCount = p.Variants.Sum(v => v.StockQuantity),
                    IsInStock = p.Variants.Any(v => v.StockQuantity > 0),
                })
                .ToListAsync();

            return pool.OrderBy(_ => Guid.NewGuid()).Take(count).ToList();
        }

        private static decimal ApplyDiscount(decimal originalPrice, MotoShop.Data.Enums.DiscountType discountType, decimal discountValue)
            => discountType == MotoShop.Data.Enums.DiscountType.Percent
                ? originalPrice * (1 - discountValue / 100m)
                : Math.Max(0, originalPrice - discountValue);

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
            var now = DateTime.Now;
            var vouchers = await _uow.Repository<Promotion>()
                .Find(p => p.PromotionType == PromotionType.Voucher
                    && p.IsActive
                    && p.StartDate <= now
                    && p.EndDate >= now
                    && (!p.UsageLimit.HasValue || p.UsedCount < p.UsageLimit.Value))
                .AsNoTracking()
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.DiscountValue)
                .Take(3)
                .ToListAsync();

            return vouchers.Select(v => new CouponDto
            {
                Id = v.Id,
                Code = v.CouponCode ?? string.Empty,
                DiscountValue = v.DiscountValue,
                DiscountType = v.DiscountType == DiscountType.Percent ? "Percentage" : "Fixed",
                MinOrderValue = v.MinOrderAmount,
                UsageLimit = v.UsageLimit ?? 0,
                UsedCount = v.UsedCount,
                ExpiryDate = v.EndDate,
                IsActive = v.IsActive
            });
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

            var baseQuery = _uow.Repository<Promotion>().Find(p =>
                p.PromotionType == PromotionType.FlashSale &&
                p.IsActive)
                .AsNoTracking()
                .AsSplitQuery()
                .Include(p => p.PromotionProducts)
                    .ThenInclude(pp => pp.Product)
                        .ThenInclude(p => p!.Variants)
                .Include(p => p.PromotionProducts)
                    .ThenInclude(pp => pp.Product)
                        .ThenInclude(p => p!.Images);

            // Ưu tiên flash sale đang trong thời gian hiệu lực
            var flashSale = await baseQuery
                .Where(p => p.StartDate <= now && p.EndDate >= now)
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.StartDate)
                .FirstOrDefaultAsync();

            // Fallback: lấy flash sale active gần nhất nếu không có cái nào đang chạy
            if (flashSale == null)
            {
                flashSale = await baseQuery
                    .OrderByDescending(p => p.StartDate)
                    .FirstOrDefaultAsync();
            }

            if (flashSale == null) return null;

            return new FlashSaleViewModel
            {
                FlashSaleId = flashSale.Id,
                Title = flashSale.Name,
                EndDate = flashSale.EndDate,
                Products = flashSale.PromotionProducts
                    .Where(pp => pp.Product != null)
                    .Select(pp =>
                    {
                        var originalPrice = pp.Product!.Variants.Any() ? pp.Product.Variants.Min(v => v.Price) : 0;
                        var salePrice = ApplyDiscount(originalPrice, flashSale.DiscountType, flashSale.DiscountValue);

                        return new HomeFlashSaleProductDto
                        {
                            ProductId = pp.ProductId,
                            ProductName = pp.Product.ProductName,
                            Slug = pp.Product.Slug,
                            ImageUrl = pp.Product.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault()
                                       ?? pp.Product.Images.Select(i => i.ImageUrl).FirstOrDefault(),
                            FlashSalePrice = salePrice,
                            OriginalPrice = originalPrice,
                            DiscountPercent = originalPrice > 0 ? (int)Math.Round((1 - salePrice / originalPrice) * 100) : 0,
                            Quantity = 0,
                            SoldQuantity = 0,
                            SoldPercent = 0
                        };
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
                null, null, null, sort, pageNumber, pageSize, null, null, true, true, null, promoProductIds
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

                    discountedPrice = ApplyDiscount(basePrice, p.DiscountType, p.DiscountValue);

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
                .Select(b => new { b.BrandId, b.BrandName, b.LogoUrl })
                .ToListAsync();

            var brandIds = topBrands.Select(b => b.BrandId).ToList();

            // Lấy tất cả sản phẩm của các brand trong 1 query, rồi group trong memory
            var allProducts = await _productRepository
                .Find(p => p.IsActive && !p.IsDeleted && brandIds.Contains(p.BrandId ?? 0))
                .AsNoTracking()
                .OrderByDescending(p => p.IsFeatured)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();

            var productsByBrand = allProducts
                .GroupBy(p => p.BrandId)
                .ToDictionary(g => g.Key ?? 0, g => g.ToList());

            return topBrands.Select(brand => new BrandWithProductsDto
            {
                BrandId   = brand.BrandId,
                BrandName = brand.BrandName,
                LogoUrl   = brand.LogoUrl,
                Products  = productsByBrand.TryGetValue(brand.BrandId, out var list)
                                ? list.Take(productsPerBrand).ToList()
                                : new List<ProductDto>(),
                TotalCount = productsByBrand.TryGetValue(brand.BrandId, out var all) ? all.Count : 0
            }).ToList();
        }

        public async Task<List<CategoryWithProductsDto>> GetCategoryWithProductsAsync(int categoriesCount = 4, int productsPerCategory = 4)
        {
            var topCats = await _uow.Repository<Category>().Find(c => c.ParentId == null && c.Products.Any(p => p.IsActive && !p.IsDeleted))
                .AsNoTracking()
                .OrderByDescending(c => c.Products.Count(p => p.IsActive && !p.IsDeleted))
                .Take(categoriesCount)
                .Select(c => new { c.CategoryId, c.CategoryName, c.Slug })
                .ToListAsync();

            var catIds = topCats.Select(c => c.CategoryId).ToList();

            // Map sub-category → parent (1 query)
            var subCatMap = await _uow.Repository<Category>()
                .Find(c => c.ParentId != null && catIds.Contains(c.ParentId.Value))
                .AsNoTracking()
                .Select(c => new { c.CategoryId, ParentId = c.ParentId!.Value })
                .ToDictionaryAsync(c => c.CategoryId, c => c.ParentId);

            var allCatIds = catIds.Concat(subCatMap.Keys).ToList();

            // Lấy tất cả sản phẩm trong 1 query
            var allProducts = await _productRepository
                .Find(p => p.IsActive && !p.IsDeleted && allCatIds.Contains(p.CategoryId ?? 0))
                .AsNoTracking()
                .OrderByDescending(p => p.IsFeatured)
                .ProjectTo<ProductDto>(_mapper.ConfigurationProvider)
                .ToListAsync();

            // Group theo parent category trong memory
            var productsByCat = new Dictionary<int, List<ProductDto>>();
            foreach (var p in allProducts)
            {
                var cid = p.CategoryId ?? 0;
                var parentId = subCatMap.TryGetValue(cid, out var pid) ? pid : cid;
                if (!productsByCat.ContainsKey(parentId)) productsByCat[parentId] = new();
                productsByCat[parentId].Add(p);
            }

            return topCats.Select(cat => new CategoryWithProductsDto
            {
                CategoryId   = cat.CategoryId,
                CategoryName = cat.CategoryName,
                Slug         = cat.Slug,
                Products     = productsByCat.TryGetValue(cat.CategoryId, out var list)
                                   ? list.Take(productsPerCategory).ToList()
                                   : new List<ProductDto>(),
                TotalCount   = productsByCat.TryGetValue(cat.CategoryId, out var all) ? all.Count : 0
            }).ToList();
        }
    }
}
