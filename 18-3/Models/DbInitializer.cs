using Microsoft.AspNetCore.Identity;
using _18_3.Models;
using Microsoft.EntityFrameworkCore;

namespace _18_3.Models
{
    public static class DbInitializer
    {
        public static async Task Seed(ApplicationDbContext context, UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager)
        {
            context.Database.Migrate();

            // 1. Tạo Roles
            if (!await roleManager.RoleExistsAsync(SD.Role_Admin))
            {
                await roleManager.CreateAsync(new IdentityRole(SD.Role_Admin));
                await roleManager.CreateAsync(new IdentityRole(SD.Role_Customer));
            }

            // 2. Tạo Admin User mẫu
            var adminUser = await userManager.FindByEmailAsync("admin@shop.com");
            if (adminUser == null)
            {
                var admin = new ApplicationUser
                {
                    UserName = "admin@shop.com",
                    Email = "admin@shop.com",
                    FullName = "Hệ thống Quản trị", // Đây là trường bắt buộc
                    EmailConfirmed = true,
                    SecurityStamp = Guid.NewGuid().ToString() // Rất quan trọng cho Identity
                };

                var result = await userManager.CreateAsync(admin, "Admin123!");
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(admin, SD.Role_Admin);
                }
            }

            // 3. Tạo Danh mục mẫu
            if (!context.Categories.Any())
            {
                var categories = new List<Category>
                {
                    new Category { Name = "Lốp xe" },
                    new Category { Name = "Dầu nhớt" },
                    new Category { Name = "Phanh & Thắng" },
                    new Category { Name = "Phụ kiện trang trí" }
                };
                context.Categories.AddRange(categories);
                context.SaveChanges();

                // 4. Tạo Sản phẩm mẫu
                if (!context.Products.Any())
                {
                    var catLop = categories.First(c => c.Name == "Lốp xe").Id;
                    var catNhot = categories.First(c => c.Name == "Dầu nhớt").Id;

                    context.Products.AddRange(new List<Product>
                    {
                        new Product { 
                            Name = "Lốp Michelin City Grip 2", 
                            Price = 1200, 
                            Description = "Lốp cao cấp dành cho xe tay ga, bám đường cực tốt.", 
                            CategoryId = catLop,
                            ImageUrl = "https://michelin.vn/images/city-grip-2.jpg"
                        },
                        new Product { 
                            Name = "Dầu nhớt Motul 300V", 
                            Price = 450, 
                            Description = "Dầu nhớt tổng hợp 100% dành cho xe phân khối lớn.", 
                            CategoryId = catNhot,
                            ImageUrl = "https://motul.com/images/300v.jpg"
                        },
                        new Product { 
                            Name = "Lốp Dunlop ScootSmart", 
                            Price = 950, 
                            Description = "Lốp xe bền bỉ, êm ái cho hành trình dài.", 
                            CategoryId = catLop,
                            ImageUrl = "https://dunlop.vn/images/scootsmart.jpg"
                        }
                    });
                    context.SaveChanges();
                }
            }
        }
    }
}
