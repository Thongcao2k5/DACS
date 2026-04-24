using AutoMapper;
using MotoShop.Business.DTOs;
using MotoShop.Data.Models;
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
                .ForMember(dest => dest.MinPrice, opt => opt.MapFrom(src => src.Variants.Any() ? src.Variants.Min(v => v.Price) : 0))
                .ForMember(dest => dest.OldPrice, opt => opt.MapFrom(src => src.Variants.Any() ? (src.Variants.OrderBy(v => v.Price).FirstOrDefault().OriginalPrice ?? src.Variants.Min(v => v.Price) * 1.25m) : 0))
                .ForMember(dest => dest.DiscountPercent, opt => opt.MapFrom(src => src.Variants.Any() ? 
                    (int)Math.Round((double)((src.Variants.OrderBy(v => v.Price).FirstOrDefault().OriginalPrice ?? src.Variants.Min(v => v.Price) * 1.25m) - src.Variants.Min(v => v.Price)) * 100 / (double)(src.Variants.OrderBy(v => v.Price).FirstOrDefault().OriginalPrice ?? src.Variants.Min(v => v.Price) * 1.25m)) : 0))
                .ForMember(dest => dest.DefaultVariantId, opt => opt.MapFrom(src => src.Variants.Any() ? src.Variants.FirstOrDefault().ProductVariantId : 0))
                .ForMember(dest => dest.PrimaryImageUrl, opt => opt.MapFrom(src => src.Images.FirstOrDefault(i => i.IsPrimary) != null ? src.Images.FirstOrDefault(i => i.IsPrimary).ImageUrl : (src.Images.Any() ? src.Images.First().ImageUrl : string.Empty)))
                .ForMember(dest => dest.Variants, opt => opt.MapFrom(src => src.Variants))
                .ForMember(dest => dest.Images, opt => opt.MapFrom(src => src.Images))
                .ForMember(dest => dest.Reviews, opt => opt.MapFrom(src => src.Reviews));

            // ProductReview Mapping
            CreateMap<ProductReview, ProductReviewDto>()
                .ForMember(dest => dest.CustomerName, opt => opt.MapFrom(src => src.Customer != null ? src.Customer.FullName : "Khách hàng"))
                .ForMember(dest => dest.IsApproved, opt => opt.MapFrom(src => src.Status == "Approved"));

            // ProductVariant Mapping
            CreateMap<ProductVariant, ProductVariantDto>()
                .ForMember(dest => dest.VariantAttributeValues, opt => opt.MapFrom(src => src.VariantAttributeValues.Select(vav => new VariantAttributeDto {
                    AttributeName = vav.AttributeValue.ProductAttribute != null ? vav.AttributeValue.ProductAttribute.AttributeName : "Thuộc tính",
                    Value = vav.AttributeValue != null ? vav.AttributeValue.Value : string.Empty
                }).ToList()));

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

            // Coupon Mapping
            CreateMap<Coupon, CouponDto>();

            // Promotion Mapping
            CreateMap<Promotion, PromotionDto>()
                .ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.StartDate.ToString("dd/MM/yyyy")))
                .ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.EndDate.ToString("dd/MM/yyyy")))
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.PromotionProducts != null ? src.PromotionProducts.Count : 0))
                .ForMember(dest => dest.StatusText, opt => opt.MapFrom(src => src.EndDate < DateTime.Now ? "Đã kết thúc" : (src.StartDate > DateTime.Now ? "Sắp diễn ra" : "Đang diễn ra")))
                .ForMember(dest => dest.StatusClass, opt => opt.MapFrom(src => src.EndDate < DateTime.Now ? "bg-danger" : (src.StartDate > DateTime.Now ? "bg-warning" : "bg-success")));

            // Order Mapping
            CreateMap<Order, OrderDto>()
                .ForMember(dest => dest.Amount, opt => opt.MapFrom(src => (int)src.TotalAmount));
        }
    }
}
