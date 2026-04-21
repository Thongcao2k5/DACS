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
            // 1. SEED ROLES
            if (!roleManager.Roles.Any())
            {
                await roleManager.CreateAsync(new IdentityRole("Admin"));
                await roleManager.CreateAsync(new IdentityRole("Staff"));
                await roleManager.CreateAsync(new IdentityRole("Customer"));
            }

            // 2. SEED USERS
            var adminUser = await userManager.FindByEmailAsync("admin@motoshop.vn");
            if (adminUser == null)
            {
                adminUser = new IdentityUser { UserName = "admin@motoshop.vn", Email = "admin@motoshop.vn", EmailConfirmed = true };
                await userManager.CreateAsync(adminUser, "Admin@123");
                await userManager.AddToRoleAsync(adminUser, "Admin");
            }

            var testUser = await userManager.FindByEmailAsync("thongminhcao2k5@gmail.com");
            if (testUser == null)
            {
                testUser = new IdentityUser { UserName = "thongminhcao2k5@gmail.com", Email = "thongminhcao2k5@gmail.com", EmailConfirmed = true };
                await userManager.CreateAsync(testUser, "123123..");
                await userManager.AddToRoleAsync(testUser, "Customer");
            }

            // 3. HELPER METHODS
            async Task<Category> EnsureCategoryAsync(string name)
            {
                var category = await context.Categories.FirstOrDefaultAsync(c => c.CategoryName == name);
                if (category == null)
                {
                    category = new Category { 
                        CategoryName = name, 
                        Slug = name.ToLower().Replace(" ", "-").Replace("đ", "d").Replace("/", "-") 
                    };
                    context.Categories.Add(category);
                    await context.SaveChangesAsync();
                }
                return category;
            }

            async Task<Brand> EnsureBrandAsync(string name)
            {
                var brand = await context.Brands.FirstOrDefaultAsync(b => b.BrandName == name);
                if (brand == null)
                {
                    brand = new Brand { BrandName = name };
                    context.Brands.Add(brand);
                    await context.SaveChangesAsync();
                }
                return brand;
            }

            async Task AddProductAsync(
                string name,
                string categoryName,
                string brandName,
                string description,
                string imageUrl,
                List<(string vName, decimal price, string sku)> variants,
                bool isFeatured = true)
            {
                var cat = await EnsureCategoryAsync(categoryName);
                var brand = await EnsureBrandAsync(brandName);

                var product = new Product
                {
                    ProductName = name,
                    CategoryId = cat.CategoryId,
                    BrandId = brand.BrandId,
                    Description = description,
                    Slug = name.ToLower().Replace(" ", "-").Replace("đ", "d").Replace("/", "-").Replace(".", "-").Replace(" ", "").Replace("(", "").Replace(")", ""),
                    IsActive = true,
                    IsFeatured = isFeatured,
                    CreatedDate = DateTime.Now
                };

                context.Products.Add(product);
                await context.SaveChangesAsync();

                context.ProductImages.Add(new ProductImage { ProductId = product.ProductId, ImageUrl = imageUrl, IsPrimary = true });

                foreach (var v in variants)
                {
                    context.ProductVariants.Add(new ProductVariant
                    {
                        ProductId = product.ProductId,
                        VariantName = v.vName,
                        Price = v.price,
                        SKU = v.sku,
                        StockQuantity = 100,
                        ImageUrl = imageUrl,
                        CreatedDate = DateTime.Now
                    });
                }
                await context.SaveChangesAsync();
            }

            // 4. SEED PRODUCTS
            if (!context.Products.Any())
            {
                #region PHỤ TÙNG MÁY
                await AddProductAsync("Piston UMA Racing", "PHỤ TÙNG MÁY", "UMA Racing", "Dòng piston nâng cấp hiệu suất cao.", "https://umaracing.com/wp-content/uploads/2022/04/Racing-Piston.png", 
                    new List<(string, decimal, string)> { ("62mm", 850000, "UMA-P62"), ("65mm", 950000, "UMA-P65") });

                await AddProductAsync("Trục cam BRT", "PHỤ TÙNG MÁY", "BRT", "Cải thiện nạp xả cho xe độ.", "https://product.hstatic.net/1000375176/product/dsc04816_5e2fee57d0eb45e8802c2d37348db04b_master.jpg", 
                    new List<(string, decimal, string)> { ("Stage 1", 1200000, "BRT-C1") });

                await AddProductAsync("Bugi NGK Iridium", "PHỤ TÙNG MÁY", "NGK", "Tăng hiệu suất đánh lửa.", "https://ngkntk.com.vn/upload/images/Laser%201.jpg", 
                    new List<(string, decimal, string)> { ("CR7", 220000, "NGK-CR7") });
                #endregion

                #region DÀN CHÂN
                await AddProductAsync("Mâm RCB Racing Boy", "DÀN CHÂN", "RCB", "Mâm đúc CNC thể thao.", "https://shop2banh.vn/images/thumbs/2018/03/mam-rcb-chinh-hang-cho-wave-dream-future-sirius-jupiter-exciter-135-doi-dau-695-slide-products-5aa09bfe05fd6.jpg", 
                    new List<(string, decimal, string)> { ("Đen", 6500000, "RCB-B") });

                await AddProductAsync("Phuộc sau YSS G-Sport", "DÀN CHÂN", "YSS", "Có bình dầu, chỉnh được độ cứng.", "https://shop2banh.vn/images/thumbs/2022/08/phuoc-yss-g-sport-chinh-hang-cho-honda-ab160-1893-slide-products-62f1daef99ab7.jpg", 
                    new List<(string, decimal, string)> { ("Tiêu chuẩn", 3500000, "YSS-R") });

                await AddProductAsync("Heo dầu Brembo M4", "DÀN CHÂN", "Brembo", "Lực phanh cực mạnh.", "https://product.hstatic.net/200000341373/product/m4-108-01_956affece1fd4584aba1542ea3902994.jpg", 
                    new List<(string, decimal, string)> { ("Tiêu chuẩn", 6500000, "BR-M4") });
                #endregion

                #region NHỚT MÁY
                await AddProductAsync("Motul 300V Factory Line", "NHỚT MÁY", "Motul", "Công nghệ Ester Core cho xe đua.", "https://product.hstatic.net/200000038440/product/0-09_2fdeaf1e233a4acca1348fa2a85d04f3_cbc538665d7547269cad642ed2e30e1a_29d7ead10d254242b9ffbe2d5655e7e8_master.jpg", 
                    new List<(string, decimal, string)> { ("1L", 420000, "MOTUL-1") });

                await AddProductAsync("Shell Advance Ultra", "NHỚT MÁY", "Shell", "Làm sạch động cơ tuyệt đối.", "https://product.hstatic.net/200000341373/product/shell_advance_10w40_692c68c826d141abac25bde72c23dbd0_1024x1024.jpg", 
                    new List<(string, decimal, string)> { ("1L", 280000, "SHELL-U") });
                #endregion

                #region ĐỒ CHƠI XE
                await AddProductAsync("Tay thắng CRG Folding", "ĐỒ CHƠI XE", "CRG", "Nhôm CNC gập chống gãy.", "https://www.tinomotor.vn/storage/pagedata/100113/img/slide/product/3292/277786935_2744964482466268_7290132748879786037_n.jpg", 
                    new List<(string, decimal, string)> { ("Đen", 1800000, "CRG-B") });

                await AddProductAsync("Gương Rizoma Reverse", "ĐỒ CHƠI XE", "Rizoma", "Thiết kế thể thao nhôm CNC.", "https://imgwebikenet-8743.kxcdn.com/catalogue/images/159436/35_01_imgi_232_bs072a_backview_jpg.jpg", 
                    new List<(string, decimal, string)> { ("Đen", 1200000, "RIZ-B") });
                #endregion

                #region VỎ LỐP XE
                await AddProductAsync("Michelin Pilot Street 2", "VỎ LỐP XE", "Michelin", "Bám đường cực tốt.", "https://dxm.contentcenter.michelin.com/api/wedia/dam/transform/b98rpyxf61b4qzptzsictt3x6a/mo-93_tire_michelin_pilot-street-2_ww_set_a_main_1-30_nopad.webp", 
                    new List<(string, decimal, string)> { ("Trước", 550000, "MIC-F") });

                await AddProductAsync("Pirelli Diablo Rosso Sport", "VỎ LỐP XE", "Pirelli", "Lốp thể thao chuyên dụng.", "https://shop2banh.vn/images/thumbs/2025/09/lop-pirelli-diablo-rosso-sport-9080-17-12070-17-2058-slide-products-68b80eaebdf85.jpg", 
                    new List<(string, decimal, string)> { ("Sau", 1800000, "PIR-R") });
                #endregion
            }

            // 5. SEED CUSTOMERS
            if (!context.Customers.Any())
            {
                var customers = new List<Customer>
                {
                    new Customer { UserId = testUser.Id, FullName = "Thông Minh Cao", Email = "thongminhcao2k5@gmail.com", Phone = "0900000000", Address = "Địa chỉ của Thông", CreatedDate = DateTime.Now },
                    new Customer { FullName = "Nguyễn Văn A", Email = "vana@gmail.com", Phone = "0901234567", Address = "123 Lê Lợi, Q.1, HCM", CreatedDate = DateTime.Now },
                    new Customer { FullName = "Trần Thị B", Email = "thib@gmail.com", Phone = "0912345678", Address = "456 CMT8, Q.3, HCM", CreatedDate = DateTime.Now }
                };
                context.Customers.AddRange(customers);
                await context.SaveChangesAsync();
            }

            // 6. SEED ORDERS
            if (!context.Orders.Any())
            {
                var customers = await context.Customers.ToListAsync();
                var variants = await context.ProductVariants.ToListAsync();

                if (customers.Count >= 2 && variants.Count >= 2)
                {
                    context.Orders.Add(new Order 
                    { 
                        CustomerId = customers[0].CustomerId, 
                        OrderDate = DateTime.Now.AddDays(-1), 
                        Status = "Pending", 
                        TotalAmount = variants[0].Price, 
                        PaymentStatus = "Unpaid", 
                        ShippingAddress = customers[0].Address,
                        OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[0].ProductVariantId, Quantity = 1, Price = variants[0].Price } }
                    });
                    
                    context.Orders.Add(new Order 
                    { 
                        CustomerId = customers[1].CustomerId, 
                        OrderDate = DateTime.Now.AddDays(-2), 
                        Status = "Completed", 
                        TotalAmount = variants[1].Price, 
                        PaymentStatus = "Paid", 
                        ShippingAddress = customers[1].Address,
                        OrderItems = new List<OrderItem> { new OrderItem { ProductVariantId = variants[1].ProductVariantId, Quantity = 1, Price = variants[1].Price } }
                    });
                }
            }

            // 7. SEED PROMOTIONS
            if (!context.Promotions.Any())
            {
                var promo1 = new Promotion 
                { 
                    PromotionName = "Siêu hội Giảm giá - Giảm 10%", 
                    Description = "Giảm giá 10% cho toàn bộ sản phẩm trên hệ thống.",
                    DiscountType = "Percentage",
                    DiscountPercentage = 10,
                    StartDate = DateTime.Now.AddDays(-2),
                    EndDate = DateTime.Now.AddDays(30),
                    IsActive = true
                };

                var promo2 = new Promotion 
                { 
                    PromotionName = "Xả kho Phụ tùng - Giảm 50k", 
                    Description = "Giảm giá trực tiếp 50.000đ cho một số mặt hàng.",
                    DiscountType = "FixedAmount",
                    DiscountAmount = 50000,
                    StartDate = DateTime.Now.AddDays(-5),
                    EndDate = DateTime.Now.AddDays(15),
                    IsActive = true
                };

                context.Promotions.AddRange(new List<Promotion> { promo1, promo2 });
                await context.SaveChangesAsync();

                // Gán TẤT CẢ sản phẩm vào khuyến mãi
                var allProducts = await context.Products.ToListAsync();
                foreach (var product in allProducts)
                {
                    var promoId = product.ProductId % 2 == 0 ? promo1.PromotionId : promo2.PromotionId;
                    context.PromotionProducts.Add(new PromotionProduct { PromotionId = promoId, ProductId = product.ProductId });
                }
                await context.SaveChangesAsync();
            }

            // 8. SEED COUPONS
            if (!context.Coupons.Any())
            {
                context.Coupons.AddRange(new List<Coupon>
                {
                    new Coupon { Code = "HELLO2026", DiscountType = "Percentage", DiscountValue = 10, UsageLimit = 100, UsedCount = 0, ExpiryDate = DateTime.Now.AddYears(1), MinOrderValue = 0, IsActive = true },
                    new Coupon { Code = "MOTO50K", DiscountType = "FixedAmount", DiscountValue = 50000, UsageLimit = 50, UsedCount = 0, ExpiryDate = DateTime.Now.AddMonths(6), MinOrderValue = 500000, IsActive = true },
                    new Coupon { Code = "VIP100", DiscountType = "FixedAmount", DiscountValue = 100000, UsageLimit = 20, UsedCount = 0, ExpiryDate = DateTime.Now.AddMonths(3), MinOrderValue = 1000000, IsActive = true },
                    new Coupon { Code = "SIEUDEAL", DiscountType = "Percentage", DiscountValue = 50, UsageLimit = 10, UsedCount = 0, ExpiryDate = DateTime.Now.AddMonths(1), MinOrderValue = 2000000, IsActive = true },
                    new Coupon { Code = "HETLUOT", DiscountType = "Percentage", DiscountValue = 20, UsageLimit = 10, UsedCount = 10, ExpiryDate = DateTime.Now.AddYears(1), MinOrderValue = 0, IsActive = true },
                    new Coupon { Code = "HETHAN", DiscountType = "Percentage", DiscountValue = 99, UsageLimit = 100, UsedCount = 0, ExpiryDate = DateTime.Now.AddDays(-10), MinOrderValue = 0, IsActive = true }
                });
            }

            // 9. SEED SLIDERS & BANNERS
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

            // 10. SEED BLOG CATEGORIES & BLOGS
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
                        new Blog { Title = "Cách bảo dưỡng sên xe máy đúng cách", Slug = "cach-bao-duong-sen-xe-may", Content = "Nội dung hướng dẫn chi tiết về cách vệ sinh sên...", Thumbnail = "/assets/img/elements/blog-1.jpg", CategoryId = blogCats[0].Id, Status = 1, CreatedDate = DateTime.Now },
                        new Blog { Title = "Top 5 loại nhớt tốt nhất 2026", Slug = "top-5-loai-nhot-xe-tay-ga-2026", Content = "Phân tích và đánh giá các dòng nhớt tổng hợp...", Thumbnail = "/assets/img/elements/blog-2.jpg", CategoryId = blogCats[1].Id, Status = 1, CreatedDate = DateTime.Now }
                    });
                }
            }

            // 11. SEED SHIPPING METHODS
            if (!context.ShippingMethods.Any())
            {
                context.ShippingMethods.AddRange(new List<ShippingMethod>
                {
                    new ShippingMethod { Name = "Giao hàng tiêu chuẩn", Cost = 0, EstimatedDays = "3-5 ngày", Description = "Miễn phí vận chuyển cho mọi đơn hàng", IsActive = true },
                    new ShippingMethod { Name = "Giao hàng nhanh", Cost = 35000, EstimatedDays = "1-2 ngày", Description = "Nhận hàng sớm nhất có thể", IsActive = true }
                });
            }

            // 12. SEED PRODUCT REVIEWS
            if (!context.ProductReviews.Any())
            {
                var products = context.Products.ToList();
                var customers = context.Customers.ToList();
                if (products.Any() && customers.Any())
                {
                    context.ProductReviews.Add(new ProductReview { ProductId = products[0].ProductId, CustomerId = customers[0].CustomerId, Rating = 5, Comment = "Sản phẩm tuyệt vời!", Status = "Approved", CreatedDate = DateTime.Now });
                }
            }

            // 13. SEED SERVICES
            if (!context.Services.Any())
            {
                context.Services.AddRange(new List<Service>
                {
                    new Service { ServiceName = "Bảo dưỡng định kỳ (Full)", Price = 350000, Description = "Kiểm tra tổng quát 24 hạng mục, vệ sinh nồi, họng xăng và thay nhớt máy.", ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f91cbba527?w=500", IsActive = true },
                    new Service { ServiceName = "Lắp đặt Phuộc & Phanh", Price = 150000, Description = "Thay thế phuộc Ohlins, YSS, heo dầu Brembo chuẩn kỹ thuật, không cấn cọ.", ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500", IsActive = true },
                    new Service { ServiceName = "ECU & Xăng Lửa", Price = 800000, Description = "Dynojet chuyên sâu, tối ưu công suất động cơ, giúp xe bốc và mượt hơn.", ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f91cbba527?w=500", IsActive = true },
                    new Service { ServiceName = "Cứu hộ tận nơi 24/7", Price = 200000, Description = "Hỗ trợ sửa chữa lưu động, chở xe về trung tâm khi gặp sự cố trên đường.", ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f91cbba527?w=500", IsActive = true },
                    new Service { ServiceName = "Rửa xe Detail siêu sạch", Price = 120000, Description = "Rửa xe không chạm, vệ sinh chi tiết máy, dưỡng nhựa nhám và xịt nano bóng.", ImageUrl = "https://images.unsplash.com/photo-1558981403-c5f91cbba527?w=500", IsActive = true }
                });
            }

            // 14. SEED MOTORBIKE MODELS
            if (!context.MotorbikeModels.Any())
            {
                var motorbikeData = new Dictionary<string, List<string>>
                {
                    { "Honda", new List<string> { "Vision 110cc", "SH 125i/150i", "SH 350i", "Air Blade 125/160", "Winner X (K2P)", "Winner V1", "Lead 125", "Vario 125/150/160", "PCX 125/150/160", "Future 125 FI", "Wave Alpha 110", "Wave RSX FI", "Blade 110", "CBR150R", "CB150R Exmotion", "Monkey", "Super Cub C125", "Rebel 300/500" } },
                    { "Yamaha", new List<string> { "Exciter 155 VVA", "Exciter 150", "Exciter 135", "NVX 125/155 V1/V2", "Janus 125", "Grande (Nozza)", "Latte", "FreeGo 125", "Sirius 110 (Xăng cơ)", "Sirius FI", "Jupiter Finn", "Jupiter Gravita/RC", "YZF-R15 V3/V4", "MT-15", "XS155R", "FZ150i", "TFX 150" } },
                    { "Suzuki", new List<string> { "Raider R150 FI", "Satria F150 FI", "GSX-R150", "GSX-S150", "Burgman Street", "Impulse 125", "Address 110", "V-Strom 250" } },
                    { "Vespa", new List<string> { "Vespa Sprint 125/150", "Vespa Primavera 125", "Vespa GTS 150/300" } },
                    { "Piaggio", new List<string> { "Liberty 125 iGet", "Medley 125/150", "Zip 100" } },
                    { "SYM", new List<string> { "Attila Elizabeth/Venus", "Shark 125", "Galaxy 110/125", "Elegant 50/110", "Star SR 125/170" } },
                    { "Kawasaki", new List<string> { "Z1000", "Z900", "Ninja 400", "Z400" } },
                    { "Ducati", new List<string> { "Monster 797/821", "Panigale V2/V4", "Scrambler 800" } },
                    { "BMW", new List<string> { "S1000RR", "G310GS/R", "R1250GS" } },
                    { "VinFast", new List<string> { "Theon", "Feliz", "Klara S", "Vento" } }
                };

                foreach (var brand in motorbikeData)
                {
                    foreach (var modelName in brand.Value)
                    {
                        context.MotorbikeModels.Add(new MotorbikeModel 
                        { 
                            Manufacturer = brand.Key, 
                            ModelName = modelName 
                        });
                    }
                }
                await context.SaveChangesAsync();
            }

            // 11. Seed Blog Categories
            if (!context.BlogCategories.Any())
            {
                var blogCats = new List<BlogCategory>
                {
                    new BlogCategory { Name = "Tin tức sự kiện", Slug = "tin-tuc-su-kien" },
                    new BlogCategory { Name = "Kỹ thuật - Bảo trì", Slug = "ky-thuat-bao-tri" },
                    new BlogCategory { Name = "Đánh giá xe", Slug = "danh-gia-xe" },
                    new BlogCategory { Name = "Phụ tùng chính hãng", Slug = "phu-tung-chinh-hang" }
                };
                context.BlogCategories.AddRange(blogCats);
                await context.SaveChangesAsync();
            }

            // 12. Seed Blogs
            if (!context.Blogs.Any())
            {
                var firstCat = await context.BlogCategories.FirstAsync();
                var blogs = new List<Blog>
                {
                    new Blog 
                    { 
                        Title = "Hướng dẫn bảo dưỡng xích tải (sên) đúng cách", 
                        Slug = "huong-dan-bao-duong-xich-tai-dung-cach",
                        Content = "<p>Việc bảo dưỡng xích tải định kỳ giúp xe vận hành êm ái và kéo dài tuổi thọ bộ nhông sên dĩa...</p>",
                        CategoryId = firstCat.Id,
                        Status = 1,
                        CreatedDate = DateTime.Now,
                        Thumbnail = "https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=800&q=80"
                    },
                    new Blog 
                    { 
                        Title = "Top 5 loại dầu nhớt tốt nhất cho xe tay ga 2024", 
                        Slug = "top-5-loai-dau-nhot-tot-nhat-2024",
                        Content = "<p>Chọn đúng loại dầu nhớt giúp động cơ xe tay ga tản nhiệt tốt hơn và tiết kiệm xăng...</p>",
                        CategoryId = firstCat.Id,
                        Status = 1,
                        CreatedDate = DateTime.Now.AddDays(-1),
                        Thumbnail = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?auto=format&fit=crop&w=800&q=80"
                    },
                    new Blog 
                    { 
                        Title = "Dấu hiệu nhận biết bugi xe máy cần được thay thế", 
                        Slug = "dau-hieu-nhan-biet-bugi-can-thay-the",
                        Content = "<p>Bugi là bộ phận quan trọng trong hệ thống đánh lửa. Nếu bugi hỏng, xe sẽ khó nổ máy hoặc chết máy giữa chừng...</p>",
                        CategoryId = firstCat.Id,
                        Status = 0, // Draft
                        CreatedDate = DateTime.Now.AddDays(-2),
                        Thumbnail = "https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&w=800&q=80"
                    }
                };
                context.Blogs.AddRange(blogs);
                await context.SaveChangesAsync();
            }

            await context.SaveChangesAsync();
        }
    }
}
