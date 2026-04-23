using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Data.Data
{
    public static class DbSeeder
    {
        public static async Task SeedAsync(MotoShopDbContext context, UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager)
        {
            try
            {
                // 1. SEED ROLES
                if (!roleManager.Roles.Any())
                {
                    await roleManager.CreateAsync(new IdentityRole("Admin"));
                    await roleManager.CreateAsync(new IdentityRole("Staff"));
                    await roleManager.CreateAsync(new IdentityRole("Customer"));
                }

                // 2. SEED ADMIN USER
                if (!userManager.Users.Any(u => u.UserName == "admin@motoshop.vn"))
                {
                    var admin = new IdentityUser
                    {
                        UserName = "admin@motoshop.vn",
                        Email = "admin@motoshop.vn",
                        EmailConfirmed = true
                    };
                    await userManager.CreateAsync(admin, "Admin@123");
                    await userManager.AddToRoleAsync(admin, "Admin");
                }

                // KHÔNG XÓA DỮ LIỆU CŨ NỮA (ĐÃ LOẠI BỎ REMOVERANGE)

                // 3. SEED CATEGORIES (Chỉ thêm nếu trống)
                if (!context.Categories.Any())
                {
                    var categories = new List<Category>
                    {
                        new Category { CategoryName = "DẦU NHỚT", Slug = "dau-nhot" },
                        new Category { CategoryName = "BẢO DƯỠNG", Slug = "bao-duong" },
                        new Category { CategoryName = "HỆ THỐNG PHANH", Slug = "he-thong-phanh" },
                        new Category { CategoryName = "LỐP XE", Slug = "lop-xe" },
                        new Category { CategoryName = "GIẢM XÓC", Slug = "giam-xoc" },
                        new Category { CategoryName = "ĐỒ CHƠI XE", Slug = "do-choi-xe" },
                        new Category { CategoryName = "PHỤ TÙNG MÁY", Slug = "phu-tung-may" },
                        new Category { CategoryName = "HỆ THỐNG ĐIỆN", Slug = "he-thong-dien" },
                        new Category { CategoryName = "TRUYỀN ĐỘNG", Slug = "truyen-dong" }
                    };
                    context.Categories.AddRange(categories);
                    await context.SaveChangesAsync();
                }

                // 4. SEED BRANDS (Chỉ thêm nếu trống)
                if (!context.Brands.Any())
                {
                    var brands = new List<Brand>
                    {
                        new Brand { BrandName = "Motul" },
                        new Brand { BrandName = "Liqui Moly" },
                        new Brand { BrandName = "Brembo" },
                        new Brand { BrandName = "Michelin" },
                        new Brand { BrandName = "Ohlins" },
                        new Brand { BrandName = "YSS" },
                        new Brand { BrandName = "Honda" },
                        new Brand { BrandName = "Yamaha" }
                    };
                    context.Brands.AddRange(brands);
                    await context.SaveChangesAsync();
                }

                // 5. SEED SHIPPING METHODS
                if (!context.ShippingMethods.Any())
                {
                    context.ShippingMethods.AddRange(new List<ShippingMethod>
                    {
                        new ShippingMethod { Name = "Giao hàng nhanh", Cost = 30000, EstimatedDays = "2-3 ngày", IsActive = true },
                        new ShippingMethod { Name = "Hỏa tốc 2H", Cost = 50000, EstimatedDays = "2 giờ", IsActive = true },
                        new ShippingMethod { Name = "Tiêu chuẩn", Cost = 15000, EstimatedDays = "4-5 ngày", IsActive = true }
                    });
                    await context.SaveChangesAsync();
                }

                // 6. SEED DỮ LIỆU MẪU SẢN PHẨM (Chỉ nạp nếu bảng Product trống)
                if (!context.Products.Any())
                {
                    var catDauNhot = await context.Categories.FirstAsync(c => c.CategoryName == "DẦU NHỚT");
                    var brandMotul = await context.Brands.FirstAsync(b => b.BrandName == "Motul");

                    var p1 = new Product
                    {
                        ProductName = "Dầu nhớt Motul 7100 10W40",
                        CategoryId = catDauNhot.CategoryId,
                        BrandId = brandMotul.BrandId,
                        Description = "Nhớt tổng hợp toàn phần giúp bảo vệ động cơ tối ưu.",
                        Slug = "dau-nhot-motul-7100",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now
                    };
                    context.Products.Add(p1);
                    await context.SaveChangesAsync();

                    context.ProductVariants.Add(new ProductVariant
                    {
                        ProductId = p1.ProductId,
                        VariantName = "Chai 1L",
                        Price = 320000,
                        SKU = "MOTUL-7100-1L",
                        StockQuantity = 100,
                        ImageUrl = "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png",
                        CreatedDate = DateTime.Now
                    });
                    await context.SaveChangesAsync();
                }

                // 7. SEED DỊCH VỤ
                if (!context.Services.Any())
                {
                    context.Services.AddRange(new List<Service>
                    {
                        new Service { ServiceName = "Thay nhớt máy", Price = 20000, Description = "Tiền công thay nhớt.", IsActive = true },
                        new Service { ServiceName = "Vệ sinh nồi xe ga", Price = 150000, Description = "Làm sạch bộ nồi giúp xe chạy bốc hơn.", IsActive = true }
                    });
                    await context.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                // In lỗi ra Console để theo dõi
                Console.WriteLine($"[ERR] Seeding Error: {ex.Message}");
            }
        }
    }
}
