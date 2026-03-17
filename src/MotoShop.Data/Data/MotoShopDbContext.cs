using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
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
        public DbSet<Product> Products { get; set; }
        public DbSet<Unit> Units { get; set; }
        public DbSet<ProductVariant> ProductVariants { get; set; }
        public DbSet<ProductImage> ProductImages { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<Service> Services { get; set; }
        public DbSet<ServiceBooking> ServiceBookings { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Cấu hình quan hệ Category cấp cha - con
            modelBuilder.Entity<Category>()
                .HasMany(c => c.SubCategories)
                .WithOne(c => c.ParentCategory)
                .HasForeignKey(c => c.ParentId)
                .OnDelete(DeleteBehavior.Restrict);

            // Các cấu hình bổ sung khác nếu cần
            modelBuilder.Entity<Order>()
                .Property(o => o.OrderCode)
                .HasComputedColumnSql("('DH'+right('000000'+CONVERT([nvarchar],[OrderId]),(6)))");
        }
    }
}
