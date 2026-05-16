using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Enums;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class PromotionService : IPromotionService
    {
        private readonly IPromotionRepository _promotionRepository;
        private readonly IUnitOfWork _unitOfWork;
        private readonly MotoShopDbContext _context;
        private readonly IMapper _mapper;

        public PromotionService(
            IPromotionRepository promotionRepository,
            IUnitOfWork unitOfWork,
            MotoShopDbContext context,
            IMapper mapper)
        {
            _promotionRepository = promotionRepository;
            _unitOfWork = unitOfWork;
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<PromotionDto>> GetActivePromotionsAsync()
        {
            var promotions = await _promotionRepository.GetActivePromotions();
            return promotions.Select(MapPromotion).ToList();
        }

        public async Task<List<PromotionDto>> GetAllAsync()
        {
            var promotions = await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                .OrderByDescending(p => p.StartDate)
                .ToListAsync();

            return promotions.Select(MapPromotion).ToList();
        }

        public async Task<List<PromotionDto>> GetFlashSalesAsync()
        {
            var promotions = await _promotionRepository.GetFlashSales();
            return promotions.Select(MapPromotion).ToList();
        }

        public async Task<List<PromotionDto>> GetFeaturedAsync()
        {
            var now = DateTime.Now;
            var promotions = await _promotionRepository.GetActivePromotions();
            return promotions
                .Where(p => p.IsFeatured && p.StartDate <= now && p.EndDate >= now)
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.StartDate)
                .Select(MapPromotion)
                .ToList();
        }

        public async Task<List<ProductDto>> GetFlashSaleProductsAsync(int count = 12)
        {
            var now = DateTime.Now;
            var flashSales = await _promotionRepository.GetFlashSales();
            var activeFlashSales = flashSales
                .Where(p => p.IsActive && p.StartDate <= now && p.EndDate >= now)
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.StartDate)
                .ToList();

            if (!activeFlashSales.Any())
            {
                return new List<ProductDto>();
            }

            var productPromotions = activeFlashSales
                .SelectMany(p => p.PromotionProducts.Select(pp => new { pp.ProductId, Promotion = p }))
                .GroupBy(x => x.ProductId)
                .Select(g => g.OrderByDescending(x => x.Promotion.Priority).First())
                .ToDictionary(x => x.ProductId, x => x.Promotion);

            var productIds = productPromotions
                .OrderByDescending(kvp => kvp.Value.Priority)
                .ThenByDescending(kvp => kvp.Value.DiscountValue)
                .Select(kvp => kvp.Key)
                .Take(count)
                .ToList();
            if (!productIds.Any())
            {
                return new List<ProductDto>();
            }

            var products = await _unitOfWork.Repository<Product>()
                .Find(p => productIds.Contains(p.ProductId) && p.IsActive && !p.IsDeleted)
                .AsNoTracking()
                .Include(p => p.Variants)
                .Include(p => p.Images)
                .Include(p => p.Brand)
                .Include(p => p.Category)
                .ToListAsync();

            var result = new List<ProductDto>();
            foreach (var product in products)
            {
                var promo = productPromotions.GetValueOrDefault(product.ProductId);
                if (promo == null)
                {
                    continue;
                }

                var basePrice = GetBasePrice(product);
                if (basePrice <= 0) continue;
                var discountedPrice = ApplyDiscount(basePrice, promo);
                var primaryImage = product.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault()
                    ?? product.Images.Select(i => i.ImageUrl).FirstOrDefault()
                    ?? string.Empty;

                result.Add(new ProductDto
                {
                    ProductId = product.ProductId,
                    ProductName = product.ProductName,
                    Slug = product.Slug ?? string.Empty,
                    Description = product.Description ?? string.Empty,
                    CategoryName = product.Category?.CategoryName ?? string.Empty,
                    CategoryId = product.CategoryId,
                    BrandName = product.Brand?.BrandName ?? string.Empty,
                    BrandLogoUrl = product.Brand?.LogoUrl ?? string.Empty,
                    BrandId = product.BrandId,
                    IsFeatured = product.IsFeatured,
                    MinPrice = discountedPrice,
                    MinOriginalPrice = basePrice,
                    OldPrice = basePrice,
                    DiscountPercent = basePrice > discountedPrice && basePrice > 0
                        ? (int)Math.Round((1 - discountedPrice / basePrice) * 100)
                        : 0,
                    PromotionType = "FlashSale",
                    SoldCount = product.SoldCount,
                    StockCount = product.Variants.Sum(v => v.StockQuantity),
                    PrimaryImageUrl = primaryImage,
                    DefaultVariantId = product.Variants.OrderBy(v => v.Price).Select(v => v.ProductVariantId).FirstOrDefault(),
                    IsInStock = product.Variants.Any(v => v.StockQuantity > 0),
                    IsFlashSale = true,
                    FlashSalePrice = discountedPrice,
                    FlashSalePercent = basePrice > discountedPrice && basePrice > 0
                        ? (int)Math.Round((1 - discountedPrice / basePrice) * 100)
                        : 0,
                    FlashSaleQuantity = null,
                    FlashSaleSoldQuantity = null,
                    FlashSaleEndDate = promo.EndDate,
                    CreatedDate = product.CreatedDate
                });
            }

            return result
                .OrderByDescending(p => p.DiscountPercent)
                .ThenByDescending(p => p.SoldCount)
                .Take(count)
                .ToList();
        }

        public async Task<decimal> CalculateDiscountAsync(int productId, decimal originalPrice)
        {
            var promotion = await GetBestPromotionForProductAsync(productId, new[]
            {
                PromotionType.FlashSale,
                PromotionType.ProductDiscount
            });

            if (promotion == null)
            {
                return Math.Max(0, originalPrice);
            }

            return ApplyDiscount(originalPrice, promotion);
        }

        public async Task<decimal> CalculateOrderDiscountAsync(decimal orderTotal, List<CartItem> items)
        {
            var promotion = await GetBestOrderPromotionAsync();
            if (promotion == null)
            {
                return Math.Max(0, orderTotal);
            }

            return ApplyDiscount(orderTotal, promotion);
        }

        public async Task<decimal> ApplyVoucherAsync(string code, decimal orderTotal)
        {
            var validation = await ValidateVoucherAsync(code, orderTotal);
            if (!validation.IsValid)
            {
                return Math.Max(0, orderTotal);
            }

            var promotion = await _promotionRepository.GetByCode(code);
            if (promotion == null)
            {
                return Math.Max(0, orderTotal - validation.DiscountAmount);
            }

            promotion.UsedCount += 1;
            promotion.UpdatedAt = DateTime.Now;
            _promotionRepository.Update(promotion);
            await _unitOfWork.CompleteAsync();

            return Math.Max(0, orderTotal - validation.DiscountAmount);
        }

        public async Task<(bool IsValid, decimal DiscountAmount, string Message)> ValidateVoucherAsync(string code, decimal orderTotal)
        {
            if (string.IsNullOrWhiteSpace(code))
            {
                return (false, 0, "Mã voucher không hợp lệ.");
            }

            var promotion = await _promotionRepository.GetByCode(code);
            if (promotion == null || promotion.PromotionType != PromotionType.Voucher)
            {
                return (false, 0, "Voucher không tồn tại.");
            }

            if (!promotion.IsActive)
            {
                return (false, 0, "Voucher hiện không hoạt động.");
            }

            var now = DateTime.Now;
            if (promotion.StartDate > now || promotion.EndDate < now)
            {
                return (false, 0, "Voucher đã hết hạn hoặc chưa đến thời gian áp dụng.");
            }

            if (promotion.UsageLimit.HasValue && promotion.UsedCount >= promotion.UsageLimit.Value)
            {
                return (false, 0, "Voucher đã hết lượt sử dụng.");
            }

            if (promotion.MinOrderAmount.HasValue && orderTotal < promotion.MinOrderAmount.Value)
            {
                return (false, 0, "Đơn hàng chưa đạt giá trị tối thiểu.");
            }

            var discountAmount = ApplyDiscount(orderTotal, promotion);
            discountAmount = Math.Max(0, orderTotal - discountAmount);

            return (true, discountAmount, "Voucher hợp lệ.");
        }

        public async Task<PromotionDto> CreateAsync(PromotionDto dto)
        {
            var promotion = new Promotion
            {
                Name = dto.Name?.Trim() ?? string.Empty,
                Slug = string.IsNullOrWhiteSpace(dto.Slug) ? GenerateSlug(dto.Name) : dto.Slug!.Trim(),
                Description = dto.Description,
                PromotionType = ParsePromotionType(dto.PromotionType),
                DiscountType = ParseDiscountType(dto.DiscountType),
                DiscountValue = dto.DiscountValue,
                MaxDiscountAmount = dto.MaxDiscountAmount,
                MinOrderAmount = dto.MinOrderAmount,
                CouponCode = string.IsNullOrWhiteSpace(dto.CouponCode) ? null : dto.CouponCode.Trim().ToUpperInvariant(),
                StartDate = ParseStartDate(dto.StartDate),
                EndDate = ParseEndDate(dto.EndDate),
                UsageLimit = dto.UsageLimit,
                UsedCount = dto.UsedCount,
                IsActive = dto.IsActive,
                IsFeatured = dto.IsFeatured,
                Priority = dto.Priority,
                BannerImage = dto.BannerImage,
                BackgroundColor = dto.BackgroundColor,
                CreatedAt = dto.CreatedAt ?? DateTime.Now,
                UpdatedAt = dto.UpdatedAt ?? DateTime.Now
            };

            var strategy = _context.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    await _promotionRepository.AddAsync(promotion);
                    await _unitOfWork.CompleteAsync();

                    if (dto.ProductIds != null)
                    {
                        var links = dto.ProductIds.Distinct().Select(productId => new PromotionProduct
                        {
                            PromotionId = promotion.Id,
                            ProductId = productId
                        }).ToList();

                        if (links.Any())
                        {
                            await _unitOfWork.Repository<PromotionProduct>().AddRangeAsync(links);
                            await _unitOfWork.CompleteAsync();
                        }
                    }

                    await transaction.CommitAsync();
                    var savedPromotion = await LoadPromotionAsync(promotion.Id);
                    return MapPromotion(savedPromotion ?? promotion);
                }
                catch
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            });
        }

        public async Task<bool> UpdateAsync(int id, PromotionDto dto)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    var promotion = await _context.Promotions
                        .Include(p => p.PromotionProducts)
                        .FirstOrDefaultAsync(p => p.Id == id);

                    if (promotion == null)
                    {
                        return false;
                    }

                    promotion.Name = dto.Name?.Trim() ?? promotion.Name;
                    promotion.Slug = string.IsNullOrWhiteSpace(dto.Slug) ? GenerateSlug(dto.Name) : dto.Slug!.Trim();
                    promotion.Description = dto.Description;
                    promotion.PromotionType = ParsePromotionType(dto.PromotionType);
                    promotion.DiscountType = ParseDiscountType(dto.DiscountType);
                    promotion.DiscountValue = dto.DiscountValue;
                    promotion.MaxDiscountAmount = dto.MaxDiscountAmount;
                    promotion.MinOrderAmount = dto.MinOrderAmount;
                    promotion.CouponCode = string.IsNullOrWhiteSpace(dto.CouponCode) ? null : dto.CouponCode.Trim().ToUpperInvariant();
                    promotion.StartDate = ParseStartDate(dto.StartDate);
                    promotion.EndDate = ParseEndDate(dto.EndDate);
                    promotion.UsageLimit = dto.UsageLimit;
                    promotion.UsedCount = dto.UsedCount;
                    promotion.IsActive = dto.IsActive;
                    promotion.IsFeatured = dto.IsFeatured;
                    promotion.Priority = dto.Priority;
                    promotion.BannerImage = dto.BannerImage;
                    promotion.BackgroundColor = dto.BackgroundColor;
                    promotion.UpdatedAt = DateTime.Now;

                    if (dto.ProductIds != null)
                    {
                        _context.PromotionProducts.RemoveRange(promotion.PromotionProducts);
                        await _context.SaveChangesAsync();

                        var links = dto.ProductIds.Distinct().Select(productId => new PromotionProduct
                        {
                            PromotionId = promotion.Id,
                            ProductId = productId
                        }).ToList();

                        if (links.Any())
                        {
                            await _context.PromotionProducts.AddRangeAsync(links);
                        }
                    }

                    await _context.SaveChangesAsync();
                    await transaction.CommitAsync();
                    return true;
                }
                catch
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            });
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    var promotion = await _context.Promotions
                        .Include(p => p.PromotionProducts)
                        .FirstOrDefaultAsync(p => p.Id == id);

                    if (promotion == null)
                    {
                        return false;
                    }

                    if (promotion.PromotionProducts.Any())
                    {
                        _context.PromotionProducts.RemoveRange(promotion.PromotionProducts);
                    }

                    _context.Promotions.Remove(promotion);
                    await _context.SaveChangesAsync();
                    await transaction.CommitAsync();
                    return true;
                }
                catch
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            });
        }

        public async Task<bool> ToggleActiveAsync(int id)
        {
            var promotion = await _context.Promotions.FirstOrDefaultAsync(p => p.Id == id);
            if (promotion == null)
            {
                return false;
            }

            promotion.IsActive = !promotion.IsActive;
            promotion.UpdatedAt = DateTime.Now;
            _context.Promotions.Update(promotion);
            await _context.SaveChangesAsync();
            return true;
        }

        private async Task<Promotion?> LoadPromotionAsync(int id)
        {
            return await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                .FirstOrDefaultAsync(p => p.Id == id);
        }

        private async Task<Promotion?> GetBestPromotionForProductAsync(int productId, IEnumerable<PromotionType> types)
        {
            var activePromotions = await _promotionRepository.GetActivePromotions();

            return activePromotions
                .Where(p => types.Contains(p.PromotionType) && p.PromotionProducts.Any(pp => pp.ProductId == productId))
                .OrderByDescending(p => GetTypePriority(p.PromotionType))
                .ThenByDescending(p => p.Priority)
                .ThenByDescending(p => p.DiscountValue)
                .FirstOrDefault();
        }

        private async Task<Promotion?> GetBestOrderPromotionAsync()
        {
            var activePromotions = await _promotionRepository.GetActivePromotions();

            return activePromotions
                .Where(p => p.PromotionType == PromotionType.OrderDiscount || p.PromotionType == PromotionType.Campaign)
                .OrderByDescending(p => GetTypePriority(p.PromotionType))
                .ThenByDescending(p => p.Priority)
                .ThenByDescending(p => p.DiscountValue)
                .FirstOrDefault();
        }

        private PromotionDto MapPromotion(Promotion promotion)
        {
            var dto = _mapper.Map<PromotionDto>(promotion);
            dto.ProductIds = promotion.PromotionProducts?.Select(pp => pp.ProductId).Distinct().ToList();
            dto.UsedCount = promotion.UsedCount;
            dto.UsageLimit = promotion.UsageLimit;
            dto.Priority = promotion.Priority;
            dto.BannerImage = promotion.BannerImage;
            dto.BackgroundColor = promotion.BackgroundColor;
            dto.CreatedAt = promotion.CreatedAt;
            dto.UpdatedAt = promotion.UpdatedAt;
            return dto;
        }

        private static PromotionType ParsePromotionType(string? value)
        {
            return Enum.TryParse<PromotionType>(value, true, out var parsed)
                ? parsed
                : PromotionType.ProductDiscount;
        }

        private static DiscountType ParseDiscountType(string? value)
        {
            return Enum.TryParse<DiscountType>(value, true, out var parsed)
                ? parsed
                : DiscountType.Percent;
        }

        private static DateTime ParseStartDate(string? value)
        {
            return ParseDate(value, DateTime.Now, startOfDay: true);
        }

        private static DateTime ParseEndDate(string? value)
        {
            return ParseDate(value, DateTime.Now.AddDays(7), startOfDay: false);
        }

        private static DateTime ParseDate(string? value, DateTime fallback, bool startOfDay)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return fallback;
            }

            var formats = new[]
            {
                "yyyy-MM-dd",
                "yyyy-MM-ddTHH:mm:ss",
                "yyyy-MM-dd HH:mm:ss",
                "dd/MM/yyyy",
                "dd/MM/yyyy HH:mm:ss",
                "MM/dd/yyyy",
                "MM/dd/yyyy HH:mm:ss"
            };

            if (DateTime.TryParseExact(value.Trim(), formats, CultureInfo.InvariantCulture, DateTimeStyles.AssumeLocal, out var parsed))
            {
                if (value.Contains("T") || value.Contains(":"))
                {
                    return parsed;
                }

                return startOfDay ? parsed.Date : parsed.Date.AddDays(1).AddTicks(-1);
            }

            if (DateTime.TryParse(value, CultureInfo.CurrentCulture, DateTimeStyles.AssumeLocal, out parsed))
            {
                if (value.Contains("T") || value.Contains(":"))
                {
                    return parsed;
                }

                return startOfDay ? parsed.Date : parsed.Date.AddDays(1).AddTicks(-1);
            }

            return fallback;
        }

        private static decimal GetBasePrice(Product product)
        {
            return product.Variants.Any()
                ? product.Variants.Min(v => v.Price)
                : 0;
        }

        private static decimal ApplyDiscount(decimal basePrice, Promotion promotion)
        {
            decimal result = basePrice;

            if (promotion.DiscountType == DiscountType.Percent)
            {
                result = basePrice * (1 - promotion.DiscountValue / 100m);
            }
            else
            {
                result = basePrice - promotion.DiscountValue;
            }

            if (promotion.MaxDiscountAmount.HasValue)
            {
                var discountAmount = basePrice - result;
                if (discountAmount > promotion.MaxDiscountAmount.Value)
                {
                    result = basePrice - promotion.MaxDiscountAmount.Value;
                }
            }

            return Math.Clamp(result, 0, basePrice);
        }

        private static int GetTypePriority(PromotionType type)
        {
            return type switch
            {
                PromotionType.FlashSale => 400,
                PromotionType.ProductDiscount => 300,
                PromotionType.OrderDiscount => 200,
                PromotionType.Voucher => 100,
                PromotionType.Campaign => 50,
                _ => 0
            };
        }

        private static string GenerateSlug(string? name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return $"promotion-{Guid.NewGuid():N}";
            }

            var slug = name.Trim().ToLowerInvariant();
            slug = Regex.Replace(slug, @"[^a-z0-9\s-]", string.Empty);
            slug = Regex.Replace(slug, @"\s+", "-");
            slug = Regex.Replace(slug, @"-+", "-");
            return slug.Trim('-');
        }
    }
}
