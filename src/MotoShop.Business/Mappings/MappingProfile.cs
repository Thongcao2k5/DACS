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
                .ForMember(dest => dest.MinOriginalPrice, opt => opt.MapFrom(src => src.Variants.Any() ? src.Variants.OrderBy(v => v.Price).FirstOrDefault().OriginalPrice : null))
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
                .ForMember(dest => dest.AttributeValues, opt => opt.MapFrom(src => src.VariantAttributeValues.Select(vav => new VariantAttributeDto {
                    AttributeName = vav.AttributeValue.ProductAttribute.AttributeName,
                    Value = vav.AttributeValue.Value
                })));

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
        }
    }
}
