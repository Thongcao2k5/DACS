using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MotoShop.Data.Models
{
    public class Category
    {
        [Key]
        public int CategoryId { get; set; }
        [Required, StringLength(200)]
        public string CategoryName { get; set; } = string.Empty;
        [StringLength(255)]
        public string? Slug { get; set; }
        public int? ParentId { get; set; }
        public string? Description { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        public string? Icon { get; set; }
        public bool IsActive { get; set; } = true;

        [ForeignKey("ParentId")]
        public virtual Category? ParentCategory { get; set; }
        public virtual ICollection<Category> SubCategories { get; set; } = new List<Category>();
        public virtual ICollection<Product> Products { get; set; } = new List<Product>();
    }

    public class Brand
    {
        [Key]
        public int BrandId { get; set; }
        [Required, StringLength(255)]
        public string BrandName { get; set; } = string.Empty;
        [StringLength(500)]
        public string? LogoUrl { get; set; }
        public string? Description { get; set; }

        public virtual ICollection<Product> Products { get; set; } = new List<Product>();
    }

    public class MotorbikeModel
    {
        [Key]
        public int ModelId { get; set; }
        [Required, StringLength(200)]
        public string ModelName { get; set; } = string.Empty;
        [StringLength(200)]
        public string? Manufacturer { get; set; }
        public int? ParentId { get; set; }

        [ForeignKey("ParentId")]
        public virtual MotorbikeModel? ParentModel { get; set; }
        public virtual ICollection<MotorbikeModel> SubModels { get; set; } = new List<MotorbikeModel>();
        public virtual ICollection<ProductVariant> ProductVariants { get; set; } = new List<ProductVariant>();
    }

    public class Product
    {
        [Key]
        public int ProductId { get; set; }
        public int? CategoryId { get; set; }
        public int? BrandId { get; set; }
        [Required, StringLength(300)]
        public string ProductName { get; set; } = string.Empty;
        [StringLength(255)]
        public string? Slug { get; set; }
        public string? Description { get; set; }
        public bool IsFeatured { get; set; } = false;
        public bool IsActive { get; set; } = true;
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        public bool IsDeleted { get; set; } = false;
        public int SoldCount { get; set; } = 0;

        [ForeignKey("CategoryId")]
        public virtual Category? Category { get; set; }
        [ForeignKey("BrandId")]
        public virtual Brand? Brand { get; set; }
        public virtual ICollection<ProductVariant> Variants { get; set; } = new List<ProductVariant>();
        public virtual ICollection<ProductImage> Images { get; set; } = new List<ProductImage>();
        public virtual ICollection<ProductReview> Reviews { get; set; } = new List<ProductReview>();
        public virtual ICollection<FlashSaleProduct> OldFlashSaleProducts { get; set; } = new List<FlashSaleProduct>();
        public virtual ICollection<PromotionProduct> PromotionProducts { get; set; } = new List<PromotionProduct>();
        public virtual ICollection<ProductSpecification> Specifications { get; set; } = new List<ProductSpecification>();
    }

    public class Unit
    {
        [Key]
        public int UnitId { get; set; }
        [Required, StringLength(50)]
        public string UnitName { get; set; } = string.Empty;
        [StringLength(20)]
        public string? Symbol { get; set; }
    }

    public class ProductVariant
    {
        [Key]
        public int ProductVariantId { get; set; }
        public int? ProductId { get; set; }
        public int? BaseUnitId { get; set; }
        public int? ModelId { get; set; }
        [StringLength(100)]
        public string? SKU { get; set; }
        [Required, StringLength(255)]
        public string VariantName { get; set; } = string.Empty;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? OriginalPrice { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal CostPrice { get; set; }
        public int StockQuantity { get; set; } = 0;
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        public int MinStockLevel { get; set; } = 5;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
        [ForeignKey("BaseUnitId")]
        public virtual Unit? BaseUnit { get; set; }
        [ForeignKey("ModelId")]
        public virtual MotorbikeModel? MotorbikeModel { get; set; }
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();
        public virtual ICollection<InventoryTransaction> InventoryTransactions { get; set; } = new List<InventoryTransaction>();
        public virtual ICollection<VariantImage> VariantImages { get; set; } = new List<VariantImage>();
        public virtual ICollection<ProductVariantAttributeValue> VariantAttributeValues { get; set; } = new List<ProductVariantAttributeValue>();
    }

    public class ProductImage
    {
        [Key]
        public int ImageId { get; set; }
        public int? ProductId { get; set; }
        [Required, StringLength(500)]
        public string ImageUrl { get; set; } = string.Empty;
        public bool IsPrimary { get; set; } = false;
        public int DisplayOrder { get; set; } = 0;
        [StringLength(10)]
        public string MediaType { get; set; } = "image";
        [StringLength(500)]
        public string? VideoUrl { get; set; }

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    public class VariantImage
    {
        [Key]
        public int VariantImageId { get; set; }
        public int ProductVariantId { get; set; }
        [Required, StringLength(500)]
        public string ImageUrl { get; set; } = string.Empty;
        public bool IsPrimary { get; set; } = false;
        public int DisplayOrder { get; set; } = 0;

        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
    }

    public class ProductSpecification
    {
        [Key]
        public int SpecId { get; set; }
        public int ProductId { get; set; }
        [Required, StringLength(100)]
        public string SpecName { get; set; } = string.Empty;
        [Required, StringLength(500)]
        public string SpecValue { get; set; } = string.Empty;
        public int DisplayOrder { get; set; } = 0;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    public class Customer
    {
        [Key]
        public int CustomerId { get; set; }
        [StringLength(450)]
        public string? UserId { get; set; }
        [Required, StringLength(200)]
        public string FullName { get; set; } = string.Empty;
        [StringLength(255)]
        public string? Email { get; set; }
        [StringLength(50)]
        public string? Phone { get; set; }
        [StringLength(500)]
        public string? Address { get; set; }
        public string? AvatarUrl { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        public bool IsLocked { get; set; } = false;

        public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
        public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();
        public virtual ICollection<AddressNew> Addresses { get; set; } = new List<AddressNew>();
    }

    public class Order
    {
        [Key]
        public int OrderId { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public string? OrderCode { get; private set; }
        public int? CustomerId { get; set; }
        public int? StoreId { get; set; }
        public int? CreatedByStaffId { get; set; }
        public int? CouponId { get; set; }
        public int? ShippingMethodId { get; set; }
        public DateTime OrderDate { get; set; } = DateTime.Now;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal TotalAmount { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountAmount { get; set; } = 0;
        [StringLength(50)]
        public string? Status { get; set; }
        [StringLength(500)]
        public string? ShippingAddress { get; set; }
        [StringLength(100)]
        public string? PaymentStatus { get; set; }
        [StringLength(100)]
        public string? PaymentMethod { get; set; }
        public string? Note { get; set; }

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        [ForeignKey("StoreId")]
        public virtual Store? Store { get; set; }
        [ForeignKey("CreatedByStaffId")]
        public virtual Staff? CreatedByStaff { get; set; }
        [ForeignKey("CouponId")]
        public virtual Coupon? Coupon { get; set; }
        [ForeignKey("ShippingMethodId")]
        public virtual ShippingMethod? ShippingMethod { get; set; }
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<OrderStatusHistory> StatusHistories { get; set; } = new List<OrderStatusHistory>();
        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
    }

    public class OrderItem
    {
        [Key]
        public int OrderItemId { get; set; }
        public int? OrderId { get; set; }
        public int? ProductVariantId { get; set; }
        public int Quantity { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }

        [ForeignKey("OrderId")]
        public virtual Order? Order { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
    }

    public class ServiceCategory
    {
        [Key]
        public int CategoryId { get; set; }
        [Required, StringLength(100)]
        public string CategoryName { get; set; } = string.Empty;
        public string? Slug { get; set; }
        public string? Icon { get; set; }
        public bool IsActive { get; set; } = true;
        public int DisplayOrder { get; set; } = 0;

        public virtual ICollection<Service> Services { get; set; } = new List<Service>();
    }

    public class Service
    {
        [Key]
        public int ServiceId { get; set; }
        [Required, StringLength(200)]
        public string ServiceName { get; set; } = string.Empty;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? OriginalPrice { get; set; }
        public int? Duration { get; set; } = 30;
        public string? Slug { get; set; }
        public string? ShortDescription { get; set; }
        public string? Description { get; set; }
        public int? WarrantyDays { get; set; }
        public int? TotalBookings { get; set; } = 0;
        public bool IsPopular { get; set; } = false;
        public string? Tags { get; set; }
        [Column(TypeName = "decimal(3, 1)")]
        public decimal AverageRating { get; set; } = 0;
        public int TotalReviews { get; set; } = 0;
        public int? CategoryId { get; set; }
        [ForeignKey("CategoryId")]
        public virtual ServiceCategory? ServiceCategory { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        public bool? IsActive { get; set; } = true;

        public virtual ICollection<ServiceBooking> Bookings { get; set; } = new List<ServiceBooking>();
        public virtual ICollection<ServiceComboItem> ComboItems { get; set; } = new List<ServiceComboItem>();
        public virtual ICollection<ServiceReview> Reviews { get; set; } = new List<ServiceReview>();
        public virtual ICollection<ServiceImage> Images { get; set; } = new List<ServiceImage>();
    }

    public class ServiceImage
    {
        [Key]
        public int ImageId { get; set; }
        public int ServiceId { get; set; }
        [Required, StringLength(500)]
        public string ImageUrl { get; set; } = string.Empty;
        public int DisplayOrder { get; set; } = 0;

        [ForeignKey("ServiceId")]
        public virtual Service? Service { get; set; }
    }

    public class ServiceReview
    {
        [Key]
        public int ReviewId { get; set; }
        public int ServiceId { get; set; }
        public int? CustomerId { get; set; }
        public int Rating { get; set; }
        public string? Comment { get; set; }
        public bool IsApproved { get; set; } = false;
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("ServiceId")]
        public virtual Service? Service { get; set; }
        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
    }

    public class ServiceCombo
    {
        [Key]
        public int ComboId { get; set; }
        [Required, StringLength(200)]
        public string ComboName { get; set; } = string.Empty;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal TotalPrice { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountPrice { get; set; } 
        public string? Description { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        public bool IsActive { get; set; } = true;

        public virtual ICollection<ServiceComboItem> ComboItems { get; set; } = new List<ServiceComboItem>();
        public virtual ICollection<ServiceBooking> Bookings { get; set; } = new List<ServiceBooking>();
    }

    public class ServiceComboItem
    {
        [Key]
        public int Id { get; set; }
        public int ComboId { get; set; }
        public int ServiceId { get; set; }

        [ForeignKey("ComboId")]
        public virtual ServiceCombo? Combo { get; set; }
        [ForeignKey("ServiceId")]
        public virtual Service? Service { get; set; }
    }

    public class ServiceBooking
    {
        [Key]
        public int BookingId { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public string? BookingCode { get; private set; }
        public int? CustomerId { get; set; }
        public int? ServiceId { get; set; }
        public int? ComboId { get; set; }
        public int? CreatedByStaffId { get; set; }
        public int? AssignedStaffId { get; set; }
        public DateTime BookingDate { get; set; } = DateTime.Now;
        public DateTime? ServiceDate { get; set; }
        [StringLength(50)]
        public string? Status { get; set; } 
        [StringLength(200)]
        public string? CustomerFullName { get; set; }
        [StringLength(50)]
        public string? CustomerPhone { get; set; }
        [StringLength(255)]
        public string? CustomerEmail { get; set; }
        [StringLength(200)]
        public string? VehicleBrand { get; set; }
        [StringLength(200)]
        public string? VehicleModel { get; set; }
        public int? VehicleYear { get; set; }
        [StringLength(50)]
        public string? LicensePlate { get; set; }
        public string? Notes { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DepositAmount { get; set; } = 0;
        [StringLength(50)]
        public string? DepositStatus { get; set; } 
        [StringLength(500)]
        public string? TransferProof { get; set; } 
        public DateTime? ConfirmedAt { get; set; }
        public DateTime? ExpireAt { get; set; }
        public string? CancelReason { get; set; }

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        [ForeignKey("ServiceId")]
        public virtual Service? Service { get; set; }
        [ForeignKey("ComboId")]
        public virtual ServiceCombo? Combo { get; set; }
        [ForeignKey("CreatedByStaffId")]
        public virtual Staff? CreatedByStaff { get; set; }
        [ForeignKey("AssignedStaffId")]
        public virtual Staff? AssignedStaff { get; set; }
    }

    public class ProductReview
    {
        [Key]
        public int ReviewId { get; set; }
        public int? ProductId { get; set; }
        public int? ProductVariantId { get; set; }
        public int? CustomerId { get; set; }
        public int Rating { get; set; }
        public string? Comment { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        [StringLength(20)]
        public string Status { get; set; } = "Pending"; 

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        public virtual ICollection<ProductReviewImage> Images { get; set; } = new List<ProductReviewImage>();
    }

    public class ProductReviewImage
    {
        [Key]
        public int Id { get; set; }
        public int ReviewId { get; set; }
        [Required, StringLength(500)]
        public string ImageUrl { get; set; } = string.Empty;

        [ForeignKey("ReviewId")]
        public virtual ProductReview? Review { get; set; }
    }

    public class OldPromotion
    {
        [Key]
        public int PromotionId { get; set; }
        [Required, StringLength(255)]
        public string PromotionName { get; set; } = string.Empty;
        public string? Description { get; set; }
        [Required, StringLength(20)]
        public string DiscountType { get; set; } = string.Empty;
        [Column(TypeName = "decimal(5, 2)")]
        public decimal DiscountPercentage { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountAmount { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? MinOrderValue { get; set; } 
        public int? MinQuantity { get; set; } 
        public DateTime StartDate { get; set; } = DateTime.Now;
        public DateTime EndDate { get; set; } = DateTime.Now.AddDays(7);
        public bool IsActive { get; set; } = true;

        public virtual ICollection<OldPromotionProduct> PromotionProducts { get; set; } = new List<OldPromotionProduct>();
    }

    public class OldPromotionProduct
    {
        [Key]
        public int Id { get; set; }
        public int PromotionId { get; set; }
        public int ProductId { get; set; }

        [ForeignKey("PromotionId")]
        public virtual OldPromotion? Promotion { get; set; }
        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    // ── NEW UNIFIED PROMOTION SYSTEM (Stage 1) ──────────────────

    public class FlashSale
    {
        [Key]
        public int FlashSaleId { get; set; }
        [Required, StringLength(255)]
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool IsActive { get; set; } = true;

        public virtual ICollection<FlashSaleProduct> FlashSaleProducts { get; set; } = new List<FlashSaleProduct>();
    }

    public class FlashSaleProduct
    {
        [Key]
        public int Id { get; set; }
        public int FlashSaleId { get; set; }
        public int ProductId { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal FlashSalePrice { get; set; }
        public int Quantity { get; set; }
        public int SoldQuantity { get; set; } = 0;

        [ForeignKey("FlashSaleId")]
        public virtual FlashSale? FlashSale { get; set; }
        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    public class Store
    {
        [Key]
        public int StoreId { get; set; }
        [Required, StringLength(200)]
        public string StoreName { get; set; } = string.Empty;
        [StringLength(500)]
        public string? Address { get; set; }
        [StringLength(50)]
        public string? Phone { get; set; }

        public virtual ICollection<Staff> Staffs { get; set; } = new List<Staff>();
        public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
    }

    public class Staff
    {
        [Key]
        public int StaffId { get; set; }
        public string? UserId { get; set; }
        public int? StoreId { get; set; }
        [Required, StringLength(50)]
        public string StaffCode { get; set; } = string.Empty;
        [StringLength(100)]
        public string? Position { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("StoreId")]
        public virtual Store? Store { get; set; }
    }

    public class Banner
    {
        [Key]
        public int BannerId { get; set; }
        [StringLength(255)]
        public string? Title { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        [StringLength(500)]
        public string? LinkUrl { get; set; }
        [StringLength(100)]
        public string? Position { get; set; }
        public int DisplayOrder { get; set; } = 0;
        public bool IsActive { get; set; } = true;
    }

    public class Slider
    {
        [Key]
        public int SliderId { get; set; }
        [StringLength(255)]
        public string? Title { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        [StringLength(500)]
        public string? LinkUrl { get; set; }
        public int Position { get; set; } = 0;
        public bool IsActive { get; set; } = true;
    }

    public class Cart
    {
        [Key]
        public int CartId { get; set; }
        public int? CustomerId { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        public string UserId { get; set; } = string.Empty;

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();
    }

    public class CartItem
    {
        [Key]
        public int CartItemId { get; set; }
        public int CartId { get; set; }
        public int ProductVariantId { get; set; }
        public int Quantity { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }

        [ForeignKey("CartId")]
        public virtual Cart? Cart { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
    }

    public class Payment
    {
        [Key]
        public int PaymentId { get; set; }
        public int? OrderId { get; set; }
        [StringLength(100)]
        public string? PaymentMethod { get; set; }
        [StringLength(100)]
        public string? PaymentStatus { get; set; }
        public DateTime? PaidDate { get; set; }

        [ForeignKey("OrderId")]
        public virtual Order? Order { get; set; }
    }

    public class OrderStatusHistory
    {
        [Key]
        public int HistoryId { get; set; }
        public int? OrderId { get; set; }
        [StringLength(100)]
        public string? Status { get; set; }
        public DateTime ChangedDate { get; set; } = DateTime.Now;

        [ForeignKey("OrderId")]
        public virtual Order? Order { get; set; }
    }

    public class InventoryTransaction
    {
        [Key]
        public int TransactionId { get; set; }
        public int? ProductVariantId { get; set; }
        public int Quantity { get; set; }
        [Required, StringLength(50)]
        public string TransactionType { get; set; } = string.Empty;
        public DateTime TransactionDate { get; set; } = DateTime.Now;
        public string? Note { get; set; }

        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
    }

    public class StoreSetting
    {
        [Key]
        public int SettingID { get; set; }
        [Required, StringLength(255)]
        public string StoreName { get; set; } = string.Empty;
        [StringLength(500)]
        public string? LogoUrl { get; set; }
        [StringLength(50)]
        public string? Phone { get; set; }
        [StringLength(100)]
        public string? Email { get; set; }
        public string? Address { get; set; }
        [StringLength(255)]
        public string? Facebook { get; set; }
        [StringLength(255)]
        public string? Zalo { get; set; }
    }

    public class BlogCategory
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(200)]
        public string Name { get; set; } = string.Empty;
        [StringLength(255)]
        public string? Slug { get; set; }

        public virtual ICollection<Blog> Blogs { get; set; } = new List<Blog>();
    }

    public class Blog
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(300)]
        public string Title { get; set; } = string.Empty;
        [Required, StringLength(300)]
        public string Slug { get; set; } = string.Empty;
        [Required]
        public string Content { get; set; } = string.Empty;
        [StringLength(500)]
        public string? Thumbnail { get; set; }
        public int CategoryId { get; set; }
        public int Status { get; set; } = 0; 
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        public DateTime? UpdatedDate { get; set; }
        public string? MetaTitle { get; set; }
        public string? MetaDescription { get; set; }
        public bool IsPublished { get; set; } = false;

        [ForeignKey("CategoryId")]
        public virtual BlogCategory? Category { get; set; }
    }

    public class Notification
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string UserId { get; set; } = string.Empty;
        [Required, StringLength(255)]
        public string Title { get; set; } = string.Empty;
        [Required]
        public string Message { get; set; } = string.Empty;
        public bool IsRead { get; set; } = false;
        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }

    public class Coupon
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(50)]
        public string Code { get; set; } = string.Empty;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountValue { get; set; }
        [Required, StringLength(20)]
        public string DiscountType { get; set; } = string.Empty;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? MinOrderValue { get; set; }
        public int UsageLimit { get; set; } = 0;
        public int UsedCount { get; set; } = 0;
        public DateTime ExpiryDate { get; set; } = DateTime.Now.AddMonths(1);
        public bool IsActive { get; set; } = true;
        public bool? IsAllProducts { get; set; } = true;
        public string? AppliedCategoryIds { get; set; }
        public string? AppliedProductIds { get; set; }
    }

    public class ShippingMethod
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(100)]
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Cost { get; set; }
        [StringLength(100)]
        public string? EstimatedDays { get; set; }
        public bool IsActive { get; set; } = true;
    }

    [Table("WishlistsNew")]
    public class WishlistNew
    {
        [Key]
        public int Id { get; set; }
        public int UserId { get; set; }
        public int ProductId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    [Table("AddressesNew")]
    public class AddressNew
    {
        [Key]
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public string? FullName { get; set; }
        public string? Phone { get; set; }
        public string? Province { get; set; }
        public string? District { get; set; }
        public string? Ward { get; set; }
        public string? Street { get; set; }
        public bool IsDefault { get; set; } = false;
        [NotMapped]
        public string Address => $"{Street}, {Ward}, {District}, {Province}";
    }

    public class ChatConversation
    {
        [Key]
        public int Id { get; set; }
        public string? UserId { get; set; }
        public string? GuestSessionId { get; set; }
        [StringLength(200)]
        public string? CustomerName { get; set; }
        [StringLength(255)]
        public string? CustomerEmail { get; set; }
        public string? LastMessage { get; set; }
        public DateTime? LastMessageAt { get; set; }
        public int UnreadByAdminCount { get; set; } = 0;
        public int UnreadByCustomerCount { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
        public bool IsClosed { get; set; } = false;

        public virtual ICollection<ChatMessage> Messages { get; set; } = new List<ChatMessage>();
    }

    public class ChatMessage
    {
        [Key]
        public int Id { get; set; }
        public int ConversationId { get; set; }
        [Required, StringLength(20)]
        public string SenderType { get; set; } = "Customer"; // Customer or Admin
        public string? SenderId { get; set; }
        [StringLength(200)]
        public string? SenderName { get; set; }
        [Required]
        public string Message { get; set; } = string.Empty;
        public bool IsRead { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [ForeignKey("ConversationId")]
        public virtual ChatConversation? Conversation { get; set; }
    }

    public class AuditLog
    {
        [Key]
        public int Id { get; set; }
        public string? UserId { get; set; }
        [Required, StringLength(255)]
        public string Action { get; set; } = string.Empty;
        [Required, StringLength(255)]
        public string EntityName { get; set; } = string.Empty;
        [StringLength(100)]
        public string? EntityId { get; set; }
        public string? OldValues { get; set; }
        public string? NewValues { get; set; }
        [StringLength(50)]
        public string? IpAddress { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }

    public class ProductAttribute
    {
        [Key]
        public int AttributeId { get; set; }
        [Required, StringLength(200)]
        public string AttributeName { get; set; } = string.Empty;
        public virtual ICollection<AttributeValue> AttributeValues { get; set; } = new List<AttributeValue>();
    }

    public class AttributeValue
    {
        [Key]
        public int ValueId { get; set; }
        public int AttributeId { get; set; }
        [Required, StringLength(200)]
        public string Value { get; set; } = string.Empty;
        [ForeignKey("AttributeId")]
        public virtual ProductAttribute ProductAttribute { get; set; } = null!;
        public virtual ICollection<ProductVariantAttributeValue> VariantAttributeValues { get; set; } = new List<ProductVariantAttributeValue>();
    }

    [Table("ProductVariantAttributeValue")]
    public class ProductVariantAttributeValue
    {
        [Key]
        public int Id { get; set; }
        public int ProductVariantId { get; set; }
        public int ValueId { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant ProductVariant { get; set; } = null!;
        [ForeignKey("ValueId")]
        public virtual AttributeValue AttributeValue { get; set; } = null!;
    }
}
