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
        public virtual Category Category { get; set; }
        [ForeignKey("BrandId")]
        public virtual Brand Brand { get; set; }
        public virtual ICollection<ProductVariant> Variants { get; set; } = new List<ProductVariant>();
        public virtual ICollection<ProductImage> Images { get; set; } = new List<ProductImage>();
    }

    public class Unit
    {
        [Key]
        public int UnitId { get; set; }
        [Required, StringLength(50)]
        public string UnitName { get; set; }
        [StringLength(20)]
        public string Symbol { get; set; }
    }

    public class ProductVariant
    {
        [Key]
        public int ProductVariantId { get; set; }
        public int? ProductId { get; set; }
        public int? BaseUnitId { get; set; }
        [StringLength(100)]
        public string? SKU { get; set; }
        [Required, StringLength(255)]
        public string VariantName { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal CostPrice { get; set; }
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;

        [ForeignKey("ProductId")]
        public virtual Product? Product { get; set; }
        [ForeignKey("BaseUnitId")]
        public virtual Unit? BaseUnit { get; set; }
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
        public virtual Product Product { get; set; }
    }

    public class Customer
    {
        [Key]
        public int CustomerId { get; set; }
        public string UserId { get; set; } // AspNetUsers Id
        [Required, StringLength(200)]
        public string FullName { get; set; }
        [StringLength(50)]
        public string? Phone { get; set; }
        [StringLength(500)]
        public string? Address { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }

    public class Order
    {
        [Key]
        public int OrderId { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public string OrderCode { get; private set; }
        public int? CustomerId { get; set; }
        public int? StoreId { get; set; }
        public int? CreatedByStaffId { get; set; }
        public DateTime OrderDate { get; set; } = DateTime.Now;
        [Column(TypeName = "decimal(18, 2)")]
        public decimal TotalAmount { get; set; }
        [StringLength(50)]
        public string Status { get; set; }

        [ForeignKey("CustomerId")]
        public virtual Customer Customer { get; set; }
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
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
        public virtual Order Order { get; set; }
        [ForeignKey("ProductVariantId")]
        public virtual ProductVariant ProductVariant { get; set; }
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
        public virtual Customer Customer { get; set; }
        [ForeignKey("ServiceId")]
        public virtual Service Service { get; set; }
    }
}
