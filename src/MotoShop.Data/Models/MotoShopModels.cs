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
        public string CategoryName { get; set; }
        [StringLength(255)]
        public string? Slug { get; set; }
        public int? ParentId { get; set; }
        public string? Description { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }

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
        public string BrandName { get; set; }
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
        public string ModelName { get; set; }
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
        public string ProductName { get; set; }
        [StringLength(255)]
        public string? Slug { get; set; }
        public string? Description { get; set; }
        public bool IsFeatured { get; set; } = false;
        public bool IsActive { get; set; } = true;
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("CategoryId")]
        public virtual Category? Category { get; set; }
        [ForeignKey("BrandId")]
        public virtual Brand? Brand { get; set; }
        public virtual ICollection<ProductVariant> Variants { get; set; } = new List<ProductVariant>();
        public virtual ICollection<ProductImage> Images { get; set; } = new List<ProductImage>();
        public virtual ICollection<ProductReview> Reviews { get; set; } = new List<ProductReview>();
    }

    public class Unit
    {
        [Key]
        public int UnitId { get; set; }
        [Required, StringLength(50)]
        public string UnitName { get; set; }
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
        public string VariantName { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal CostPrice { get; set; }
        public int StockQuantity { get; set; } = 0;
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
        [ForeignKey("BaseUnitId")]
        public virtual Unit? BaseUnit { get; set; }
        [ForeignKey("ModelId")]
        public virtual MotorbikeModel? MotorbikeModel { get; set; }
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();
        public virtual ICollection<InventoryTransaction> InventoryTransactions { get; set; } = new List<InventoryTransaction>();
    }

    public class ProductImage
    {
        [Key]
        public int ImageId { get; set; }
        public int? ProductId { get; set; }
        [Required, StringLength(500)]
        public string ImageUrl { get; set; }
        public bool IsPrimary { get; set; } = false;
        public int DisplayOrder { get; set; } = 0;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    public class Customer
    {
        [Key]
        public int CustomerId { get; set; }
        public string? UserId { get; set; }
        [Required, StringLength(200)]
        public string FullName { get; set; }
        [StringLength(255)]
        public string? Email { get; set; }
        [StringLength(50)]
        public string? Phone { get; set; }
        [StringLength(500)]
        public string? Address { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
        public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();
        public virtual ICollection<Wishlist> Wishlists { get; set; } = new List<Wishlist>();
        public virtual ICollection<CustomerAddress> CustomerAddresses { get; set; } = new List<CustomerAddress>();
    }

    public class CustomerAddress
    {
        [Key]
        public int Id { get; set; }
        public int CustomerId { get; set; }
        [Required, StringLength(200)]
        public string FullName { get; set; }
        [StringLength(50)]
        public string Phone { get; set; }
        [Required, StringLength(500)]
        public string Address { get; set; }
        public bool IsDefault { get; set; } = false;

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
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
        [StringLength(50)]
        public string? Status { get; set; }
        [StringLength(500)]
        public string? ShippingAddress { get; set; }
        [StringLength(100)]
        public string? PaymentStatus { get; set; }
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

    public class Service
    {
        [Key]
        public int ServiceId { get; set; }
        [Required, StringLength(200)]
        public string ServiceName { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }
        public string? Description { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }

        public virtual ICollection<ServiceBooking> Bookings { get; set; } = new List<ServiceBooking>();
    }

    public class ServiceBooking
    {
        [Key]
        public int BookingId { get; set; }
        public int? CustomerId { get; set; }
        public int? ServiceId { get; set; }
        public int? CreatedByStaffId { get; set; }
        public int? AssignedStaffId { get; set; }
        public DateTime BookingDate { get; set; } = DateTime.Now;
        public DateTime? ServiceDate { get; set; }
        [StringLength(50)]
        public string? Status { get; set; }
        public string? Notes { get; set; }

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        [ForeignKey("ServiceId")]
        public virtual Service? Service { get; set; }
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
        public string? Comment { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
        public bool IsApproved { get; set; } = false;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
    }

    public class Promotion
    {
        [Key]
        public int PromotionId { get; set; }
        [Required, StringLength(255)]
        public string PromotionName { get; set; }
        public string? Description { get; set; }
        [Column(TypeName = "decimal(5, 2)")]
        public decimal DiscountPercentage { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountAmount { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool IsActive { get; set; } = true;
    }

    public class Store
    {
        [Key]
        public int StoreId { get; set; }
        [Required, StringLength(200)]
        public string StoreName { get; set; }
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
        public string StaffCode { get; set; }
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
        public int Position { get; set; }
        public bool IsActive { get; set; } = true;
    }

    public class Cart
    {
        [Key]
        public int CartId { get; set; }
        public int? CustomerId { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();
        public string UserId { get; set; }
    }

    public class CartItem
    {
        [Key]
        public int CartItemId { get; set; }
        public int CartId { get; set; }
        public int ProductVariantId { get; set; }
        public int Quantity { get; set; }

        [ForeignKey("CartId")]
        public virtual Cart? Cart { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
        public decimal Price { get; set; }
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
        public string TransactionType { get; set; } // "IN", "OUT"
        public DateTime TransactionDate { get; set; } = DateTime.Now;
        public string? Note { get; set; }

        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant? ProductVariant { get; set; }
    }

    public class Wishlist
    {
        [Key]
        public int WishlistId { get; set; }
        public int? CustomerId { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("CustomerId")]
        public virtual Customer? Customer { get; set; }
        public virtual ICollection<WishlistItem> WishlistItems { get; set; } = new List<WishlistItem>();
    }

    public class WishlistItem
    {
        [Key]
        public int WishlistItemId { get; set; }
        public int? WishlistId { get; set; }
        public int? ProductId { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("WishlistId")]
        public virtual Wishlist? Wishlist { get; set; }
        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
    }

    public class ProductAttribute
    {
        [Key]
        public int AttributeId { get; set; }
        [Required, StringLength(200)]
        public string AttributeName { get; set; }

        public virtual ICollection<AttributeValue> AttributeValues { get; set; } = new List<AttributeValue>();
    }

    public class AttributeValue
    {
        [Key]
        public int ValueId { get; set; }
        public int? AttributeId { get; set; }
        [StringLength(200)]
        public string? Value { get; set; }

        [ForeignKey("AttributeId")]
        public virtual ProductAttribute? ProductAttribute { get; set; }
    }

    public class StoreSetting
    {
        [Key]
        public int SettingID { get; set; }
        [Required, StringLength(255)]
        public string StoreName { get; set; }
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
        public string Name { get; set; }
        [StringLength(255)]
        public string Slug { get; set; }

        public virtual ICollection<Blog> Blogs { get; set; } = new List<Blog>();
    }

    public class Blog
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(300)]
        public string Title { get; set; }
        [StringLength(300)]
        public string Slug { get; set; }
        public string Content { get; set; }
        [StringLength(500)]
        public string? Thumbnail { get; set; }
        public int? CategoryId { get; set; }
        public string? AuthorId { get; set; }
        public bool IsPublished { get; set; } = false;
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("CategoryId")]
        public virtual BlogCategory? Category { get; set; }
    }

    public class Notification
    {
        [Key]
        public int Id { get; set; }
        public string UserId { get; set; }
        [Required, StringLength(255)]
        public string Title { get; set; }
        public string Message { get; set; }
        public bool IsRead { get; set; } = false;
        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }

    public class Coupon
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(50)]
        public string Code { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal DiscountValue { get; set; }
        [StringLength(20)]
        public string DiscountType { get; set; } // "Percentage", "Amount"
        public DateTime ExpiryDate { get; set; }
        public bool IsActive { get; set; } = true;
    }

    public class ShippingMethod
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(100)]
        public string Name { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Cost { get; set; }
        [StringLength(100)]
        public string? EstimatedDays { get; set; }
    }
}
