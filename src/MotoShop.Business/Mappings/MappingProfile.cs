using AutoMapper;
using MotoShop.Business.DTOs;
using MotoShop.Data.Constants;
using MotoShop.Data.Enums;
using MotoShop.Data.Models;
using System;
using System.Linq;

namespace MotoShop.Business.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // Product Mapping
            CreateMap<Product, ProductDto>()
                .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category != null ? src.Category.CategoryName : string.Empty))
                .ForMember(dest => dest.BrandName, opt => opt.MapFrom(src => src.Brand != null ? src.Brand.BrandName : string.Empty))
                .ForMember(dest => dest.BrandLogoUrl, opt => opt.MapFrom(src => src.Brand != null ? src.Brand.LogoUrl : string.Empty))
                .ForMember(dest => dest.MinPrice, opt => opt.MapFrom(src => src.Variants.Select(v => v.Price).OrderBy(p => p).FirstOrDefault()))
                .ForMember(dest => dest.MinOriginalPrice, opt => opt.MapFrom(src => src.Variants.OrderBy(v => v.Price).Select(v => (decimal?)(v.OriginalPrice ?? v.Price)).FirstOrDefault()))
                .ForMember(dest => dest.OldPrice, opt => opt.MapFrom(src => src.Variants.OrderBy(v => v.Price).Select(v => (decimal?)(v.OriginalPrice ?? v.Price)).FirstOrDefault()))
                .ForMember(dest => dest.DiscountPercent, opt => opt.MapFrom(src => 0)) // Calculated in DTO property
                .ForMember(dest => dest.DefaultVariantId, opt => opt.MapFrom(src => src.Variants.OrderBy(v => v.Price).Select(v => v.ProductVariantId).FirstOrDefault()))
                .ForMember(dest => dest.PrimaryImageUrl, opt => opt.MapFrom(src => src.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault() ?? src.Images.Select(i => i.ImageUrl).FirstOrDefault() ?? string.Empty))
                .ForMember(dest => dest.IsFlashSale, opt => opt.MapFrom(src =>
                    src.PromotionProducts.Any(pp =>
                        pp.Promotion != null && pp.Promotion.IsActive &&
                        pp.Promotion.PromotionType == PromotionType.FlashSale &&
                        pp.Promotion.StartDate <= DateTime.Now && pp.Promotion.EndDate >= DateTime.Now &&
                        (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))))
                .ForMember(dest => dest.FlashSaleEndDate, opt => opt.MapFrom(src =>
                    src.PromotionProducts
                        .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                     pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                     pp.Promotion.StartDate <= DateTime.Now && pp.Promotion.EndDate >= DateTime.Now &&
                                     (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                        .OrderByDescending(pp => pp.Promotion!.Priority)
                        .Select(pp => (DateTime?)pp.Promotion!.EndDate)
                        .FirstOrDefault()))
                .ForMember(dest => dest.FlashSaleQuantity, opt => opt.MapFrom(src =>
                    src.PromotionProducts
                        .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                     pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                     pp.Promotion.StartDate <= DateTime.Now && pp.Promotion.EndDate >= DateTime.Now &&
                                     (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                        .OrderByDescending(pp => pp.Promotion!.Priority)
                        .Select(pp => (int?)pp.Quantity)
                        .FirstOrDefault()))
                .ForMember(dest => dest.FlashSaleSoldQuantity, opt => opt.MapFrom(src =>
                    src.PromotionProducts
                        .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                     pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                     pp.Promotion.StartDate <= DateTime.Now && pp.Promotion.EndDate >= DateTime.Now &&
                                     (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                        .OrderByDescending(pp => pp.Promotion!.Priority)
                        .Select(pp => (int?)pp.SoldQuantity)
                        .FirstOrDefault()))
                .ForMember(dest => dest.FlashSalePrice, opt => opt.MapFrom(src =>
                    src.PromotionProducts
                        .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                     pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                     pp.Promotion.StartDate <= DateTime.Now && pp.Promotion.EndDate >= DateTime.Now &&
                                     (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                        .OrderByDescending(pp => pp.Promotion!.Priority)
                        .Select(pp => (decimal?)(
                            !src.Variants.Any() ? 0m :
                            pp.Promotion!.DiscountType == DiscountType.Percent
                                ? src.Variants.Min(v => v.Price) * (1 - pp.Promotion.DiscountValue / 100m)
                                : src.Variants.Min(v => v.Price) > pp.Promotion.DiscountValue
                                    ? src.Variants.Min(v => v.Price) - pp.Promotion.DiscountValue
                                    : 0m))
                        .FirstOrDefault()))
                .ForMember(dest => dest.FlashSalePercent, opt => opt.MapFrom(src =>
                    (int)src.PromotionProducts
                        .Where(pp => pp.Promotion != null && pp.Promotion.IsActive &&
                                     pp.Promotion.PromotionType == PromotionType.FlashSale &&
                                     pp.Promotion.StartDate <= DateTime.Now && pp.Promotion.EndDate >= DateTime.Now &&
                                     (!pp.Quantity.HasValue || pp.SoldQuantity < pp.Quantity.Value))
                        .OrderByDescending(pp => pp.Promotion!.Priority)
                        .Select(pp => pp.Promotion!.DiscountType == DiscountType.Percent
                            ? pp.Promotion.DiscountValue
                            : 0m)
                        .FirstOrDefault()))
                .ForMember(dest => dest.StockCount, opt => opt.MapFrom(src => src.Variants.Sum(v => v.StockQuantity)))
                .ForMember(dest => dest.IsInStock,  opt => opt.MapFrom(src => src.Variants.Any(v => v.StockQuantity > 0)));

            // ProductReview Mapping
            CreateMap<ProductReview, ProductReviewDto>()
                .ForMember(dest => dest.CustomerName, opt => opt.MapFrom(src => src.Customer != null ? src.Customer.FullName : "Khách hàng"))
                .ForMember(dest => dest.AvatarUrl, opt => opt.MapFrom(src => src.Customer != null ? src.Customer.AvatarUrl : string.Empty))
                .ForMember(dest => dest.ReviewImages, opt => opt.MapFrom(src => src.Images.Select(i => i.ImageUrl).ToList()))
                .ForMember(dest => dest.IsApproved, opt => opt.MapFrom(src => src.Status == ReviewStatusConst.Approved));

            // ProductVariant Mapping
            CreateMap<ProductVariant, ProductVariantDto>()
                .ForMember(dest => dest.VariantAttributeValues,
                    opt => opt.MapFrom(src => src.VariantAttributeValues));

            CreateMap<ProductVariantAttributeValue, VariantAttributeDto>()
                .ForMember(dest => dest.AttributeName,
                    opt => opt.MapFrom(src => src.AttributeValue.ProductAttribute.AttributeName))
                .ForMember(dest => dest.Value,
                    opt => opt.MapFrom(src => src.AttributeValue.Value));

            // ProductImage Mapping
            CreateMap<ProductImage, ProductImageDto>();

            // Category Mapping
            CreateMap<Category, CategoryDto>()
                .ForMember(dest => dest.ParentCategoryName, opt => opt.MapFrom(src => src.ParentCategory != null ? src.ParentCategory.CategoryName : string.Empty))
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.Products != null ? src.Products.Count : 0));

            // Brand Mapping
            CreateMap<Brand, BrandDto>()
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.Products != null ? src.Products.Count : 0));

            // MotorbikeModel Mapping
            CreateMap<MotorbikeModel, MotorbikeModelDto>()
                .ForMember(dest => dest.ParentModelName, opt => opt.MapFrom(src => src.ParentModel != null ? src.ParentModel.ModelName : string.Empty));

            // Promotion Mapping
            CreateMap<Promotion, PromotionDto>()
                .ForMember(dest => dest.PromotionType, opt => opt.MapFrom(src => src.PromotionType.ToString()))
                .ForMember(dest => dest.DiscountType, opt => opt.MapFrom(src => src.DiscountType.ToString()))
                .ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.StartDate.ToString("dd/MM/yyyy")))
                .ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.EndDate.ToString("dd/MM/yyyy")))
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.PromotionProducts != null ? src.PromotionProducts.Count : 0))
                .ForMember(dest => dest.StatusText, opt => opt.MapFrom(src => src.EndDate < DateTime.Now ? "Đã kết thúc" : (src.StartDate > DateTime.Now ? "Sắp diễn ra" : "Đang diễn ra")))
                .ForMember(dest => dest.StatusClass, opt => opt.MapFrom(src => src.EndDate < DateTime.Now ? "bg-danger" : (src.StartDate > DateTime.Now ? "bg-warning" : "bg-success")));

            // FlashSale Mapping
            CreateMap<FlashSale, FlashSaleDto>()
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.FlashSaleProducts != null ? src.FlashSaleProducts.Count : 0))
                .ForMember(dest => dest.StatusText, opt => opt.MapFrom(src => !src.IsActive ? "Tạm dừng" : (src.EndDate < DateTime.Now ? "Đã kết thúc" : (src.StartDate > DateTime.Now ? "Sắp diễn ra" : "Đang diễn ra"))))
                .ForMember(dest => dest.StatusClass, opt => opt.MapFrom(src => !src.IsActive ? "bg-secondary" : (src.EndDate < DateTime.Now ? "bg-danger" : (src.StartDate > DateTime.Now ? "bg-warning" : "bg-success"))));

            CreateMap<FlashSaleProduct, FlashSaleProductDto>()
                .ForMember(dest => dest.ProductName, opt => opt.MapFrom(src => src.Product != null ? src.Product.ProductName : string.Empty))
                .ForMember(dest => dest.ImageUrl, opt => opt.MapFrom(src => src.Product != null && src.Product.Images != null && src.Product.Images.Any(i => i.IsPrimary) ? src.Product.Images.First(i => i.IsPrimary).ImageUrl : (src.Product != null && src.Product.Images != null && src.Product.Images.Any() ? src.Product.Images.First().ImageUrl : string.Empty)))
                .ForMember(dest => dest.OriginalPrice, opt => opt.MapFrom(src =>
                    src.Product != null && src.Product.Variants != null && src.Product.Variants.Any()
                        ? src.Product.Variants.Min(v => v.OriginalPrice ?? v.Price)
                        : 0m));

            // Order Mapping
            CreateMap<Order, OrderDto>()
                .ForMember(dest => dest.Amount, opt => opt.MapFrom(src => (int)src.TotalAmount));
        }
    }
}
