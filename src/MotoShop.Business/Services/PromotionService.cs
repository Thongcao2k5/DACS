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
                .Include(p => p.PromotionCategories)
                .Include(p => p.PromotionProductVariants)
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

        public async Task<decimal> CalculateDiscountAsync(int productId, decimal originalPrice, int? productVariantId = null)
        {
            var promotion = await GetBestPromotionForProductAsync(productId, productVariantId, new[]
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
            var promotions = await GetActiveOrderPromotionsAsync();
            foreach (var promotion in promotions)
            {
                var eligibleTotal = await GetEligibleTotalAsync(promotion, orderTotal, items);
                if (eligibleTotal <= 0)
                {
                    continue;
                }

                var discountedEligibleTotal = ApplyDiscount(eligibleTotal, promotion);
                return Math.Max(0, orderTotal - (eligibleTotal - discountedEligibleTotal));
            }

            return Math.Max(0, orderTotal);
        }

        public async Task<decimal> ApplyVoucherAsync(string code, decimal orderTotal, List<CartItem>? items = null)
        {
            var validation = await ValidateVoucherAsync(code, orderTotal, items);
            if (!validation.IsValid)
                return Math.Max(0, orderTotal);

            // Atomic increment — chỉ tăng nếu chưa vượt giới hạn, tránh race condition
            var normalizedCode = code.Trim().ToUpperInvariant();
            var now = DateTime.Now;
            var rows = await _context.Set<Promotion>()
                .Where(p => p.CouponCode == normalizedCode
                         && p.IsActive
                         && p.StartDate <= now
                         && p.EndDate >= now
                         && (!p.UsageLimit.HasValue || p.UsedCount < p.UsageLimit.Value))
                .ExecuteUpdateAsync(p => p
                    .SetProperty(x => x.UsedCount, x => x.UsedCount + 1)
                    .SetProperty(x => x.UpdatedAt, DateTime.Now));

            if (rows == 0)
                return Math.Max(0, orderTotal); // Race condition: voucher vừa hết lượt

            return Math.Max(0, orderTotal - validation.DiscountAmount);
        }

        public async Task<(bool IsValid, decimal DiscountAmount, string Message)> ValidateVoucherAsync(string code, decimal orderTotal, List<CartItem>? items = null)
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

            var eligibleTotal = await GetEligibleTotalAsync(promotion, orderTotal, items);
            if (eligibleTotal <= 0)
            {
                return (false, 0, "Voucher khong ap dung cho san pham trong don hang.");
            }

            var discountedEligibleTotal = ApplyDiscount(eligibleTotal, promotion);
            var discountAmount = Math.Max(0, eligibleTotal - discountedEligibleTotal);

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
                ApplyType = ParseApplyType(dto.ApplyType),
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

                    if (promotion.ApplyType == PromotionApplyType.Product && dto.ProductIds != null)
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
                    else if (promotion.ApplyType == PromotionApplyType.Category && dto.CategoryIds != null)
                    {
                        var links = dto.CategoryIds.Distinct().Select(categoryId => new PromotionCategory
                        {
                            PromotionId = promotion.Id,
                            CategoryId = categoryId
                        }).ToList();

                        if (links.Any())
                        {
                            await _unitOfWork.Repository<PromotionCategory>().AddRangeAsync(links);
                            await _unitOfWork.CompleteAsync();
                        }
                    }
                    else if (promotion.ApplyType == PromotionApplyType.ProductVariantSKU && dto.ProductVariantIds != null)
                    {
                        var links = dto.ProductVariantIds.Distinct().Select(productVariantId => new PromotionProductVariant
                        {
                            PromotionId = promotion.Id,
                            ProductVariantId = productVariantId
                        }).ToList();

                        if (links.Any())
                        {
                            await _unitOfWork.Repository<PromotionProductVariant>().AddRangeAsync(links);
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
                        .Include(p => p.PromotionCategories)
                        .Include(p => p.PromotionProductVariants)
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
                    promotion.ApplyType = ParseApplyType(dto.ApplyType);
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

                    _context.PromotionProducts.RemoveRange(promotion.PromotionProducts);
                    _context.PromotionCategories.RemoveRange(promotion.PromotionCategories);
                    _context.PromotionProductVariants.RemoveRange(promotion.PromotionProductVariants);
                    await _context.SaveChangesAsync();

                    if (promotion.ApplyType == PromotionApplyType.Product && dto.ProductIds != null)
                    {
                        var links = dto.ProductIds.Distinct().Select(productId => new PromotionProduct
                        {
                            PromotionId = promotion.Id,
                            ProductId = productId
                        }).ToList();

                        if (links.Any()) await _context.PromotionProducts.AddRangeAsync(links);
                    }
                    else if (promotion.ApplyType == PromotionApplyType.Category && dto.CategoryIds != null)
                    {
                        var links = dto.CategoryIds.Distinct().Select(categoryId => new PromotionCategory
                        {
                            PromotionId = promotion.Id,
                            CategoryId = categoryId
                        }).ToList();

                        if (links.Any()) await _context.PromotionCategories.AddRangeAsync(links);
                    }
                    else if (promotion.ApplyType == PromotionApplyType.ProductVariantSKU && dto.ProductVariantIds != null)
                    {
                        var links = dto.ProductVariantIds.Distinct().Select(productVariantId => new PromotionProductVariant
                        {
                            PromotionId = promotion.Id,
                            ProductVariantId = productVariantId
                        }).ToList();

                        if (links.Any()) await _context.PromotionProductVariants.AddRangeAsync(links);
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
                        .Include(p => p.PromotionCategories)
                        .Include(p => p.PromotionProductVariants)
                        .FirstOrDefaultAsync(p => p.Id == id);

                    if (promotion == null)
                    {
                        return false;
                    }

                    if (promotion.PromotionProducts.Any())
                    {
                        _context.PromotionProducts.RemoveRange(promotion.PromotionProducts);
                    }
                    if (promotion.PromotionCategories.Any())
                    {
                        _context.PromotionCategories.RemoveRange(promotion.PromotionCategories);
                    }
                    if (promotion.PromotionProductVariants.Any())
                    {
                        _context.PromotionProductVariants.RemoveRange(promotion.PromotionProductVariants);
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
                .Include(p => p.PromotionCategories)
                .Include(p => p.PromotionProductVariants)
                .FirstOrDefaultAsync(p => p.Id == id);
        }

        private async Task<Promotion?> GetBestPromotionForProductAsync(int productId, int? productVariantId, IEnumerable<PromotionType> types)
        {
            var now = DateTime.Now;
            var product = await _context.Products
                .AsNoTracking()
                .Include(p => p.Variants)
                .Include(p => p.Category)
                .FirstOrDefaultAsync(p => p.ProductId == productId);

            if (product == null) return null;

            var activePromotions = await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                .Include(p => p.PromotionCategories)
                .Include(p => p.PromotionProductVariants)
                .Where(p => p.IsActive && p.StartDate <= now && p.EndDate >= now && types.Contains(p.PromotionType))
                .ToListAsync();

            return activePromotions
                .Where(p => IsPromotionApplicableToProduct(p, product, productVariantId))
                .OrderByDescending(p => GetTypePriority(p.PromotionType))
                .ThenByDescending(p => p.Priority)
                .ThenByDescending(p => p.DiscountValue)
                .FirstOrDefault();
        }

        private async Task<List<Promotion>> GetActiveOrderPromotionsAsync()
        {
            var now = DateTime.Now;
            var promotions = await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                .Include(p => p.PromotionCategories)
                .Include(p => p.PromotionProductVariants)
                .Where(p => p.IsActive
                    && p.StartDate <= now
                    && p.EndDate >= now
                    && (p.PromotionType == PromotionType.OrderDiscount || p.PromotionType == PromotionType.Campaign))
                .ToListAsync();

            return promotions
                .OrderByDescending(p => GetTypePriority(p.PromotionType))
                .ThenByDescending(p => p.Priority)
                .ThenByDescending(p => p.DiscountValue)
                .ToList();
        }

        private async Task<decimal> GetEligibleTotalAsync(Promotion promotion, decimal orderTotal, List<CartItem>? items)
        {
            if (promotion.ApplyType == PromotionApplyType.All)
            {
                return orderTotal;
            }

            if (items == null || !items.Any())
            {
                return 0;
            }

            var variantIds = items.Select(i => i.ProductVariantId).Distinct().ToList();
            var variants = await _context.ProductVariants
                .AsNoTracking()
                .Include(v => v.Product)
                    .ThenInclude(p => p!.Category)
                .Where(v => variantIds.Contains(v.ProductVariantId))
                .ToDictionaryAsync(v => v.ProductVariantId);

            return items.Where(item =>
                variants.TryGetValue(item.ProductVariantId, out var variant) &&
                variant.Product != null &&
                IsPromotionApplicableToProduct(promotion, variant.Product, variant.ProductVariantId))
                .Sum(item => item.Price * item.Quantity);
        }

        private static bool IsPromotionApplicableToProduct(Promotion promotion, Product product, int? productVariantId)
        {
            return promotion.ApplyType switch
            {
                PromotionApplyType.All => true,
                PromotionApplyType.Category => product.CategoryId.HasValue && promotion.PromotionCategories.Any(pc =>
                    pc.CategoryId == product.CategoryId.Value ||
                    (product.Category != null && product.Category.ParentId.HasValue && pc.CategoryId == product.Category.ParentId.Value)),
                PromotionApplyType.Product => promotion.PromotionProducts.Any(pp => pp.ProductId == product.ProductId),
                PromotionApplyType.ProductVariantSKU => productVariantId.HasValue
                    ? promotion.PromotionProductVariants.Any(pv => pv.ProductVariantId == productVariantId.Value)
                    : product.Variants.Any(v => promotion.PromotionProductVariants.Any(pv => pv.ProductVariantId == v.ProductVariantId)),
                _ => false
            };
        }

        private PromotionDto MapPromotion(Promotion promotion)
        {
            var dto = _mapper.Map<PromotionDto>(promotion);
            dto.ProductIds = promotion.PromotionProducts?.Select(pp => pp.ProductId).Distinct().ToList();
            dto.CategoryIds = promotion.PromotionCategories?.Select(pc => pc.CategoryId).Distinct().ToList();
            dto.ProductVariantIds = promotion.PromotionProductVariants?.Select(pv => pv.ProductVariantId).Distinct().ToList();
            dto.ApplyType = promotion.ApplyType.ToString();
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

        private static PromotionApplyType ParseApplyType(string? value)
        {
            return Enum.TryParse<PromotionApplyType>(value, true, out var parsed)
                ? parsed
                : PromotionApplyType.Product;
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
