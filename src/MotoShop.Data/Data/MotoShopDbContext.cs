using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Enums;
using MotoShop.Data.Models;

namespace MotoShop.Data.Data
{
    public class MotoShopDbContext : IdentityDbContext
    {
        public MotoShopDbContext(DbContextOptions<MotoShopDbContext> options)
            : base(options)
        {
        }

        public DbSet<Category> Categories { get; set; }
        public DbSet<Brand> Brands { get; set; }
        public DbSet<MotorbikeModel> MotorbikeModels { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Unit> Units { get; set; }
        public DbSet<ProductVariant> ProductVariants { get; set; }
        public DbSet<ProductImage> ProductImages { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<Service> Services { get; set; }
        public DbSet<ServiceCombo> ServiceCombos { get; set; }
        public DbSet<ServiceComboItem> ServiceComboItems { get; set; }
        public DbSet<ServiceBooking> ServiceBookings { get; set; }
        public DbSet<ProductReview> ProductReviews { get; set; }
        public DbSet<OldPromotion> OldPromotions { get; set; }
        public DbSet<OldPromotionProduct> OldPromotionProducts { get; set; }
        public DbSet<Promotion> Promotions { get; set; }
        public DbSet<PromotionProduct> PromotionProducts { get; set; }
        public DbSet<FlashSale> FlashSales { get; set; }
        public DbSet<FlashSaleProduct> FlashSaleProducts { get; set; }
        public DbSet<ChatConversation> ChatConversations { get; set; }
        public DbSet<Store> Stores { get; set; }
        public DbSet<Staff> Staffs { get; set; }
        public DbSet<Banner> Banners { get; set; }
        public DbSet<Slider> Sliders { get; set; }
        public DbSet<Cart> Carts { get; set; }
        public DbSet<CartItem> CartItems { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<OrderStatusHistory> OrderStatusHistory { get; set; }
        public DbSet<InventoryTransaction> InventoryTransactions { get; set; }
        public DbSet<WishlistNew> WishlistsNew { get; set; }
        public DbSet<AddressNew> AddressesNew { get; set; }
        public DbSet<StoreSetting> StoreSettings { get; set; }
        public DbSet<BlogCategory> BlogCategories { get; set; }
        public DbSet<Blog> Blogs { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Coupon> Coupons { get; set; }
        public DbSet<ShippingMethod> ShippingMethods { get; set; }
        public DbSet<ServiceReview> ServiceReviews { get; set; }
        public DbSet<ServiceCategory> ServiceCategories { get; set; }
        public DbSet<ServiceImage> ServiceImages { get; set; }
        public DbSet<ChatMessage> ChatMessages { get; set; }
        public DbSet<VariantImage> VariantImages { get; set; }
        public DbSet<ProductAttribute> ProductAttributes { get; set; }
        public DbSet<AttributeValue> AttributeValues { get; set; }
        public DbSet<ProductVariantAttributeValue> ProductVariantAttributeValues { get; set; }
        public DbSet<ProductSpecification> ProductSpecifications { get; set; }
        public DbSet<AuditLog> AuditLogs { get; set; }
        public DbSet<ProductReviewImage> ProductReviewImages { get; set; }
        public DbSet<WeightGroup> WeightGroups { get; set; }
        public DbSet<ProductUsage> ProductUsages { get; set; }
        public DbSet<ProductProductUsage> ProductProductUsages { get; set; }
        public DbSet<PromotionCategory> PromotionCategories { get; set; }
        public DbSet<PromotionProductVariant> PromotionProductVariants { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Promotion>()
                .Property(p => p.PromotionType)
                .HasConversion<string>()
                .HasMaxLength(50);

            builder.Entity<Promotion>()
                .Property(p => p.DiscountType)
                .HasConversion<string>()
                .HasMaxLength(20);

            builder.Entity<Promotion>()
                .Property(p => p.ApplyType)
                .HasConversion<string>()
                .HasMaxLength(30);

            builder.Entity<ProductProductUsage>()
                .HasKey(x => new { x.ProductId, x.ProductUsageId });

            builder.Entity<ProductProductUsage>()
                .HasOne(x => x.Product)
                .WithMany(p => p.ProductProductUsages)
                .HasForeignKey(x => x.ProductId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.Entity<ProductProductUsage>()
                .HasOne(x => x.ProductUsage)
                .WithMany(u => u.ProductProductUsages)
                .HasForeignKey(x => x.ProductUsageId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.Entity<ProductUsage>().HasData(
                new ProductUsage { Id = 1, Name = "Tang toc", Slug = "tang-toc", IsActive = true },
                new ProductUsage { Id = 2, Name = "Tiet kiem nhien lieu", Slug = "tiet-kiem-nhien-lieu", IsActive = true },
                new ProductUsage { Id = 3, Name = "Bao ve dong co", Slug = "bao-ve-dong-co", IsActive = true },
                new ProductUsage { Id = 4, Name = "Giam rung", Slug = "giam-rung", IsActive = true },
                new ProductUsage { Id = 5, Name = "Tang hieu suat phanh", Slug = "tang-hieu-suat-phanh", IsActive = true },
                new ProductUsage { Id = 6, Name = "Phu hop xe tay ga", Slug = "phu-hop-xe-tay-ga", IsActive = true },
                new ProductUsage { Id = 7, Name = "Phu hop xe so", Slug = "phu-hop-xe-so", IsActive = true },
                new ProductUsage { Id = 8, Name = "Trang tri xe", Slug = "trang-tri-xe", IsActive = true }
            );

            builder.Entity<Promotion>()
                .HasIndex(p => p.CouponCode);

            builder.Entity<PromotionProduct>()
                .HasIndex(pp => pp.PromotionId);

            builder.Entity<PromotionProduct>()
                .HasIndex(pp => pp.ProductId);

            // Configure OrderCode as computed column
            builder.Entity<Order>()
                .Property(o => o.OrderCode)
                .HasComputedColumnSql("'DH'+right('000000'+CONVERT([nvarchar],[OrderId]),(6))", stored: true);

            builder.Entity<ServiceBooking>()
                .Property(b => b.BookingCode)
                .HasComputedColumnSql("'DV'+right('000000'+CONVERT([nvarchar],[BookingId]),(6))", stored: true);

            // Bổ sung ràng buộc Restrict để bảo vệ dữ liệu (Shopee Standard)
            builder.Entity<Product>()
                .HasOne(p => p.Category)
                .WithMany(c => c.Products)
                .HasForeignKey(p => p.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.Entity<Product>()
                .HasOne(p => p.Brand)
                .WithMany(b => b.Products)
                .HasForeignKey(p => p.BrandId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
