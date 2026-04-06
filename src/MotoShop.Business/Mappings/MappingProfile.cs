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
                .ForMember(dest => dest.PrimaryImageUrl, opt => opt.MapFrom(src => src.Images.FirstOrDefault(i => i.IsPrimary) != null ? src.Images.FirstOrDefault(i => i.IsPrimary).ImageUrl : (src.Images.Any() ? src.Images.First().ImageUrl : string.Empty)));

            // Category Mapping
            CreateMap<Category, CategoryDto>()
                .ForMember(dest => dest.ParentCategoryName, opt => opt.MapFrom(src => src.ParentCategory != null ? src.ParentCategory.CategoryName : string.Empty))
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.Products.Count));

            // Brand Mapping
            CreateMap<Brand, BrandDto>()
                .ForMember(dest => dest.ProductCount, opt => opt.MapFrom(src => src.Products.Count));

            // MotorbikeModel Mapping
            CreateMap<MotorbikeModel, MotorbikeModelDto>()
                .ForMember(dest => dest.ParentModelName, opt => opt.MapFrom(src => src.ParentModel != null ? src.ParentModel.ModelName : string.Empty));
        }
    }
}
