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

            // 5. Seed Customers
            if (!context.Customers.Any())
            {
                var customers = new List<Customer>
                {
                    new Customer { FullName = "Nguyễn Văn A", Email = "vana@gmail.com", Phone = "0901234567", Address = "123 Đường Lê Lợi, Quận 1, TP.HCM" },
                    new Customer { FullName = "Trần Thị B", Email = "thib@gmail.com", Phone = "0912345678", Address = "456 Đường CMT8, Quận 3, TP.HCM" },
                    new Customer { FullName = "Lê Văn C", Email = "vanc@gmail.com", Phone = "0987654321", Address = "789 Đường Võ Văn Kiệt, Quận 5, TP.HCM" }
                };
                context.Customers.AddRange(customers);
                await context.SaveChangesAsync();
            }

            // 6. Seed Orders
            if (!context.Orders.Any())
            {
                var customers = context.Customers.ToList();
                var variants = context.ProductVariants.ToList();

                if (customers.Any() && variants.Any())
                {
                    var orders = new List<Order>
                    {
                        new Order 
                        { 
                            CustomerId = customers[0].CustomerId, 
                            OrderDate = DateTime.Now.AddDays(-5), 
                            Status = "Pending", 
                            TotalAmount = 1250000, 
                            PaymentStatus = "Unpaid", 
                            ShippingAddress = customers[0].Address,
                            OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[0].ProductVariantId, Quantity = 1, Price = 1250000 } }
                        },
                        new Order 
                        { 
                            CustomerId = customers[1].CustomerId, 
                            OrderDate = DateTime.Now.AddDays(-3), 
                            Status = "Confirmed", 
                            TotalAmount = 900000, 
                            PaymentStatus = "Paid", 
                            ShippingAddress = customers[1].Address,
                            OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[1].ProductVariantId, Quantity = 2, Price = 450000 } }
                        },
                        new Order 
                        { 
                            CustomerId = customers[2].CustomerId, 
                            OrderDate = DateTime.Now.AddDays(-1), 
                            Status = "Shipping", 
                            TotalAmount = 8900000, 
                            PaymentStatus = "Paid", 
                            ShippingAddress = customers[2].Address,
                            OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[2].ProductVariantId, Quantity = 1, Price = 8900000 } }
                        },
                        new Order 
                        { 
                            CustomerId = customers[0].CustomerId, 
                            OrderDate = DateTime.Now.AddDays(-10), 
                            Status = "Completed", 
                            TotalAmount = 450000, 
                            PaymentStatus = "Paid", 
                            ShippingAddress = customers[0].Address,
                            OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[1].ProductVariantId, Quantity = 1, Price = 450000 } }
                        },
                        new Order 
                        { 
                            CustomerId = customers[1].CustomerId, 
                            OrderDate = DateTime.Now.AddDays(-2), 
                            Status = "Cancelled", 
                            TotalAmount = 1250000, 
                            PaymentStatus = "Unpaid", 
                            ShippingAddress = customers[1].Address,
                            OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[0].ProductVariantId, Quantity = 1, Price = 1250000 } }
                        }
                    };
                    context.Orders.AddRange(orders);
                    await context.SaveChangesAsync();
                }
            }

            // 7. Seed Promotions
            if (!context.Promotions.Any())
            {
                var promotions = new List<Promotion>
                {
                    new Promotion 
                    { 
                        PromotionName = "Siêu hội Nhớt máy - Giảm 10%", 
                        Description = "Chương trình ưu đãi dành riêng cho các dòng nhớt cao cấp.",
                        DiscountType = "Percentage",
                        DiscountPercentage = 10,
                        StartDate = DateTime.Now.AddDays(-2),
                        EndDate = DateTime.Now.AddDays(10),
                        IsActive = true
                    },
                    new Promotion 
                    { 
                        PromotionName = "Ưu đãi Phuộc Ohlins - Giảm 500k", 
                        Description = "Giảm giá trực tiếp khi mua phuộc Ohlins chính hãng.",
                        DiscountType = "FixedAmount",
                        DiscountAmount = 500000,
                        StartDate = DateTime.Now.AddDays(-5),
                        EndDate = DateTime.Now.AddDays(5),
                        IsActive = true
                    },
                    new Promotion 
                    { 
                        PromotionName = "Sắp ra mắt: Đại tiệc phụ tùng Honda", 
                        Description = "Chương trình khuyến mãi lớn nhất năm sắp bắt đầu.",
                        DiscountType = "Percentage",
                        DiscountPercentage = 15,
                        StartDate = DateTime.Now.AddDays(5),
                        EndDate = DateTime.Now.AddDays(15),
                        IsActive = true
                    },
                    new Promotion 
                    { 
                        PromotionName = "Xả kho cuối mùa (Đã kết thúc)", 
                        Description = "Thanh lý các mặt hàng tồn kho giá cực sốc.",
                        DiscountType = "FixedAmount",
                        DiscountAmount = 100000,
                        StartDate = DateTime.Now.AddDays(-20),
                        EndDate = DateTime.Now.AddDays(-1),
                        IsActive = true
                    }
                };
                context.Promotions.AddRange(promotions);
                await context.SaveChangesAsync();

                // Assign products to promotions
                var allProducts = context.Products.ToList();
                if (allProducts.Any())
                {
                    var promoProds = new List<PromotionProduct>
                    {
                        new PromotionProduct { PromotionId = promotions[0].PromotionId, ProductId = allProducts[1].ProductId }, // Nhớt
                        new PromotionProduct { PromotionId = promotions[1].PromotionId, ProductId = allProducts[2].ProductId }, // Phuộc Ohlins
                        new PromotionProduct { PromotionId = promotions[2].PromotionId, ProductId = allProducts[0].ProductId }  // Nồi Honda
                    };
                    context.PromotionProducts.AddRange(promoProds);
                    await context.SaveChangesAsync();
                }
            }

            // 8. Seed Coupons
            if (!context.Coupons.Any())
            {
                var coupons = new List<Coupon>
                {
                    new Coupon { Code = "WELCOME2026", DiscountType = "Percentage", DiscountValue = 10, UsageLimit = 100, UsedCount = 5, ExpiryDate = DateTime.Now.AddMonths(1), MinOrderValue = 200000, IsActive = true },
                    new Coupon { Code = "MOTO50K", DiscountType = "FixedAmount", DiscountValue = 50000, UsageLimit = 50, UsedCount = 2, ExpiryDate = DateTime.Now.AddDays(15), MinOrderValue = 500000, IsActive = true },
                    new Coupon { Code = "EXPIRED2025", DiscountType = "Percentage", DiscountValue = 20, UsageLimit = 10, UsedCount = 10, ExpiryDate = DateTime.Now.AddDays(-1), MinOrderValue = 1000000, IsActive = true }
                };
                context.Coupons.AddRange(coupons);
                await context.SaveChangesAsync();
            }

            // 9. Seed Sliders & Banners
            if (!context.Sliders.Any())
            {
                context.Sliders.AddRange(new List<Slider>
                {
                    new Slider { Title = "Phụ Tùng Xe Máy Chính Hãng", ImageUrl = "/assets/img/backgrounds/hero-slider-1.jpg", LinkUrl = "/products", Position = 1, IsActive = true },
                    new Slider { Title = "Dịch Vụ Bảo Dưỡng Chuyên Nghiệp", ImageUrl = "/assets/img/backgrounds/hero-slider-2.jpg", LinkUrl = "/service", Position = 2, IsActive = true },
                    new Slider { Title = "Ưu Đãi Lốp Xe & Nhớt Máy", ImageUrl = "/assets/img/backgrounds/hero-slider-3.jpg", LinkUrl = "/promotion", Position = 3, IsActive = true },
                    new Slider { Title = "Hỗ Trợ Trả Góp Lãi Suất 0%", ImageUrl = "/assets/img/backgrounds/hero-slider-4.jpg", LinkUrl = "/contact", Position = 4, IsActive = true }
                });
            }

            if (!context.Banners.Any())
            {
                context.Banners.AddRange(new List<Banner>
                {
                    new Banner { Title = "Khuyến Mãi Lốp Michelin", ImageUrl = "/assets/img/elements/banner-1.jpg", LinkUrl = "/promotion", Position = "HomeMiddle", IsActive = true },
                    new Banner { Title = "Ưu Đãi Thay Nhớt", ImageUrl = "/assets/img/elements/banner-2.jpg", LinkUrl = "/service", Position = "HomeBottom", IsActive = true }
                });
            }

            // 10. Seed Blog Categories & Blogs
            if (!context.BlogCategories.Any())
            {
                var blogCats = new List<BlogCategory>
                {
                    new BlogCategory { Name = "Kỹ thuật & Bảo dưỡng", Slug = "ky-thuat-bao-duong" },
                    new BlogCategory { Name = "Tin tức xe máy", Slug = "tin-tuc-xe-may" }
                };
                context.BlogCategories.AddRange(blogCats);
                await context.SaveChangesAsync();

                if (!context.Blogs.Any())
                {
                    context.Blogs.AddRange(new List<Blog>
                    {
                        new Blog { 
                            Title = "Cách bảo dưỡng sên xe máy đúng cách", 
                            Slug = "cach-bao-duong-sen-xe-may", 
                            Content = "Nội dung hướng dẫn chi tiết về cách vệ sinh và bôi trơn sên xe máy tại nhà...", 
                            Thumbnail = "/assets/img/elements/blog-1.jpg", 
                            CategoryId = blogCats[0].Id, 
                            IsPublished = true, 
                            CreatedDate = DateTime.Now 
                        },
                        new Blog { 
                            Title = "Top 5 loại nhớt tốt nhất cho xe tay ga 2026", 
                            Slug = "top-5-loai-nhot-xe-tay-ga-2026", 
                            Content = "Phân tích và đánh giá các dòng nhớt tổng hợp chuyên dụng cho các dòng xe SH, AirBlade...", 
                            Thumbnail = "/assets/img/elements/blog-2.jpg", 
                            CategoryId = blogCats[1].Id, 
                            IsPublished = true, 
                            CreatedDate = DateTime.Now 
                        }
                    });
                }
            }

            // 11. Seed Shipping Methods
            if (!context.ShippingMethods.Any())
            {
                context.ShippingMethods.AddRange(new List<ShippingMethod>
                {
                    new ShippingMethod { Name = "Giao hàng nhanh (2-3 ngày)", Cost = 30000, EstimatedDays = "2-3 ngày" },
                    new ShippingMethod { Name = "Giao hàng hỏa tốc (2H)", Cost = 50000, EstimatedDays = "2 giờ" },
                    new ShippingMethod { Name = "Giao hàng tiêu chuẩn", Cost = 15000, EstimatedDays = "4-5 ngày" }
                });
            }

            // 12. Seed Product Reviews
            if (!context.ProductReviews.Any())
            {
                var products = context.Products.ToList();
                var customers = context.Customers.ToList();
                if (products.Any() && customers.Any())
                {
                    context.ProductReviews.AddRange(new List<ProductReview>
                    {
                        new ProductReview { ProductId = products[0].ProductId, CustomerId = customers[0].CustomerId, Rating = 5, Comment = "Sản phẩm rất tốt, giao hàng nhanh!", Status = "Approved", CreatedDate = DateTime.Now },
                        new ProductReview { ProductId = products[1].ProductId, CustomerId = customers[0].CustomerId, Rating = 4, Comment = "Giá cả hợp lý, nhân viên nhiệt tình.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-1) }
                    });
                }
            }

            await context.SaveChangesAsync();
        }
    }
}
