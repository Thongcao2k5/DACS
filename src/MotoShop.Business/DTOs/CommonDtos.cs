namespace MotoShop.Business.DTOs
{
    public class CategoryDto
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string? Slug { get; set; }
        public int? ParentId { get; set; }
        public string? ParentCategoryName { get; set; }
        public string? Description { get; set; }
        public string? ImageUrl { get; set; }
        public int ProductCount { get; set; }
    }

    public class BrandDto
    {
        public int BrandId { get; set; }
        public string BrandName { get; set; }
        public string? LogoUrl { get; set; }
        public string? Description { get; set; }
        public int ProductCount { get; set; }
    }

    public class MotorbikeModelDto
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public string? Manufacturer { get; set; }
        public int? ParentId { get; set; }
        public string? ParentModelName { get; set; }
    }
}
