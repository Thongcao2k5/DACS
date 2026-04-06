using Microsoft.AspNetCore.Identity;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Data.Data
{
    public static class DbSeeder
    {
        public static async Task SeedAsync(MotoShopDbContext context, UserManager<IdentityUser> userManager = null, RoleManager<IdentityRole> roleManager = null)
        {
            // 0. Seed Roles and Admin User (New)
            if (roleManager != null && userManager != null)
            {
                string[] roles = { "Admin", "Staff", "Customer" };
                foreach (var role in roles)
                {
                    if (!await roleManager.RoleExistsAsync(role))
                    {
                        await roleManager.CreateAsync(new IdentityRole(role));
                    }
                }

                var adminUser = await userManager.FindByEmailAsync("admin@motoshop.com");
                if (adminUser == null)
                {
                    var admin = new IdentityUser
                    {
                        UserName = "admin@motoshop.com",
                        Email = "admin@motoshop.com",
                        EmailConfirmed = true
                    };
                    var result = await userManager.CreateAsync(admin, "Admin123!");
                    if (result.Succeeded)
                    {
                        await userManager.AddToRoleAsync(admin, "Admin");
                    }
                }
            }

            // 1. Seed Categories
            if (!context.Categories.Any())
            {
                var categories = new List<Category>
                {
                    new Category { CategoryName = "Phụ tùng máy", Slug = "phu-tung-may" },
                    new Category { CategoryName = "Dàn chân", Slug = "dan-chan" },
                    new Category { CategoryName = "Nhớt máy", Slug = "nhot-may" },
                    new Category { CategoryName = "Đồ chơi xe", Slug = "do-choi-xe" },
                    new Category { CategoryName = "Vỏ lốp xe", Slug = "vo-lop-xe" }
                };
                context.Categories.AddRange(categories);
                await context.SaveChangesAsync();
            }

            // 2. Seed Brands
            if (!context.Brands.Any())
            {
                var brands = new List<Brand>
                {
                    new Brand { BrandName = "Honda", LogoUrl = "honda.svg" },
                    new Brand { BrandName = "Yamaha", LogoUrl = "yamaha.svg" },
                    new Brand { BrandName = "Motul", LogoUrl = "motul.svg" },
                    new Brand { BrandName = "Ohlins", LogoUrl = "ohlins.svg" },
                    new Brand { BrandName = "Michelin", LogoUrl = "michelin.svg" }
                };
                context.Brands.AddRange(brands);
                await context.SaveChangesAsync();
            }

            // 3. Seed Units
            if (!context.Units.Any())
            {
                var units = new List<Unit>
                {
                    new Unit { UnitName = "Lon", Symbol = "L" },
                    new Unit { UnitName = "Cái", Symbol = "C" },
                    new Unit { UnitName = "Bộ", Symbol = "B" }
                };
                context.Units.AddRange(units);
                await context.SaveChangesAsync();
            }

            // 4. Seed Products
            if (!context.Products.Any())
            {
                var catMachine = context.Categories.First(c => c.Slug == "phu-tung-may");
                var catOil = context.Categories.First(c => c.Slug == "nhot-may");
                var catFoot = context.Categories.First(c => c.Slug == "dan-chan");
                
                var brandHonda = context.Brands.First(b => b.BrandName == "Honda");
                var brandMotul = context.Brands.First(b => b.BrandName == "Motul");
                var brandOhlins = context.Brands.First(b => b.BrandName == "Ohlins");

                var unitL = context.Units.First(u => u.Symbol == "L");
                var unitC = context.Units.First(u => u.Symbol == "C");
                var unitB = context.Units.First(u => u.Symbol == "B");

                var products = new List<Product>
                {
                    new Product 
                    { 
                        ProductName = "Bộ Nồi Trước Honda SH Chính Hãng", 
                        Slug = "bo-noi-truoc-honda-sh", 
                        Description = "Bộ nồi trước chính hãng cho Honda SH, giúp xe vận hành êm ái.",
                        CategoryId = catMachine.CategoryId,
                        BrandId = brandHonda.BrandId,
                        IsFeatured = true,
                        IsActive = true,
                        CreatedDate = DateTime.Now,
                        Variants = new List<ProductVariant> { new ProductVariant { VariantName = "Bộ nồi SH", Price = 1250000, CostPrice = 1000000, SKU = "SH-NOI-01", BaseUnitId = unitB.UnitId } },
                        Images = new List<ProductImage> { new ProductImage { ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800", IsPrimary = true, DisplayOrder = 1 } }
                    },
                    new Product 
                    { 
                        ProductName = "Nhớt Motul 300V Factory Line 10W40 1L", 
                        Slug = "motul-300v-10w40", 
                        Description = "Nhớt cao cấp nhất của Motul dành cho xe PKL và xe côn tay.",
                        CategoryId = catOil.CategoryId,
                        BrandId = brandMotul.BrandId,
                        IsFeatured = true,
                        IsActive = true,
                        CreatedDate = DateTime.Now,
                        Variants = new List<ProductVariant> { new ProductVariant { VariantName = "Chai 1L", Price = 450000, CostPrice = 380000, SKU = "MOTUL-300V-1L", BaseUnitId = unitL.UnitId } },
                        Images = new List<ProductImage> { new ProductImage { ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsPrimary = true, DisplayOrder = 1 } }
                    },
                    new Product 
                    { 
                        ProductName = "Phuộc Ohlins Chính Hãng Cho Vario", 
                        Slug = "phuoc-ohlins-vario", 
                        Description = "Phuộc Ohlins đẳng cấp thế giới, cải thiện độ nhún và thẩm mỹ.",
                        CategoryId = catFoot.CategoryId,
                        BrandId = brandOhlins.BrandId,
                        IsFeatured = true,
                        IsActive = true,
                        CreatedDate = DateTime.Now,
                        Variants = new List<ProductVariant> { new ProductVariant { VariantName = "Phuộc Vario", Price = 8900000, CostPrice = 7500000, SKU = "OHLINS-VARIO", BaseUnitId = unitC.UnitId } },
                        Images = new List<ProductImage> { new ProductImage { ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800", IsPrimary = true, DisplayOrder = 1 } }
                    }
                };

                context.Products.AddRange(products);
                await context.SaveChangesAsync();
            }
        }
    }
}
