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

                // 3. SEED STORE SETTINGS
                if (!context.StoreSettings.Any())
                {
                    context.StoreSettings.Add(new StoreSetting
                    {
                        StoreName = "MotoShop DACS",
                        Phone = "0123.456.789",
                        Email = "support@motoshop.vn",
                        Address = "123 Đường Số 1, Quận 1, TP.HCM",
                        Facebook = "https://facebook.com/motoshop",
                        Zalo = "https://zalo.me/0123456789",
                        LogoUrl = "/assets/img/logo.png"
                    });
                    await context.SaveChangesAsync();
                }

                // 4. SEED MOTORBIKE MODELS
                if (!context.MotorbikeModels.Any())
                {
                    var honda = new MotorbikeModel { ModelName = "Honda", Manufacturer = "Honda" };
                    var yamaha = new MotorbikeModel { ModelName = "Yamaha", Manufacturer = "Yamaha" };
                    var suzuki = new MotorbikeModel { ModelName = "Suzuki", Manufacturer = "Suzuki" };
                    var kawasaki = new MotorbikeModel { ModelName = "Kawasaki", Manufacturer = "Kawasaki" };
                    context.MotorbikeModels.AddRange(honda, yamaha, suzuki, kawasaki);
                    await context.SaveChangesAsync();

                    context.MotorbikeModels.AddRange(new List<MotorbikeModel>
                    {
                        new MotorbikeModel { ModelName = "Wave Alpha", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "Winner X", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "Vario 160", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "Air Blade 160", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "PCX 160", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "SH 125i", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "CB150R", ParentId = honda.ModelId, Manufacturer = "Honda" },
                        new MotorbikeModel { ModelName = "Exciter 155", ParentId = yamaha.ModelId, Manufacturer = "Yamaha" },
                        new MotorbikeModel { ModelName = "NVX 155", ParentId = yamaha.ModelId, Manufacturer = "Yamaha" },
                        new MotorbikeModel { ModelName = "FreeGo 125", ParentId = yamaha.ModelId, Manufacturer = "Yamaha" },
                        new MotorbikeModel { ModelName = "MT-07", ParentId = yamaha.ModelId, Manufacturer = "Yamaha" },
                        new MotorbikeModel { ModelName = "Raider R150", ParentId = suzuki.ModelId, Manufacturer = "Suzuki" },
                        new MotorbikeModel { ModelName = "Ninja 400", ParentId = kawasaki.ModelId, Manufacturer = "Kawasaki" }
                    });
                    await context.SaveChangesAsync();
                }

                // 5. SEED CATEGORIES
                if (!context.Categories.Any())
                {
                    context.Categories.AddRange(new List<Category>
                    {
                        new Category { CategoryName = "Dầu nhớt & Bôi trơn",  Slug = "dau-nhot-boi-tron",  Icon = "bxs-droplet",     IsActive = true },
                        new Category { CategoryName = "Lốp xe & Vành",         Slug = "lop-xe-vanh",        Icon = "bx-rotate-right",  IsActive = true },
                        new Category { CategoryName = "Hệ thống phanh",        Slug = "he-thong-phanh",     Icon = "bxs-stop-circle",  IsActive = true },
                        new Category { CategoryName = "Giảm xóc",              Slug = "giam-xoc",           Icon = "bx-equalizer",     IsActive = true },
                        new Category { CategoryName = "Ắc quy & Điện",         Slug = "ac-quy-dien",        Icon = "bx-bolt-circle",   IsActive = true },
                        new Category { CategoryName = "Mũ & Bảo hộ",           Slug = "mu-bao-ho",          Icon = "bx-hard-hat",      IsActive = true },
                        new Category { CategoryName = "Phụ tùng & Phụ kiện",   Slug = "phu-tung-phu-kien",  Icon = "bx-cog",           IsActive = true }
                    });
                    await context.SaveChangesAsync();
                }

                // 6. SEED BRANDS — thêm từng brand nếu chưa có (upsert-style)
                var brandList = new List<(string Name, string Logo)>
                {
                    ("Motul", "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Motul_logo.svg/512px-Motul_logo.svg.png"),
                    ("Liqui Moly", "https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Liqui-Moly_logo.svg/512px-Liqui-Moly_logo.svg.png"),
                    ("Brembo", "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Brembo_logo.svg/512px-Brembo_logo.svg.png"),
                    ("Michelin", "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Michelin_logo.svg/512px-Michelin_logo.svg.png"),
                    ("Ohlins", "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Ohlins_logo.svg/512px-Ohlins_logo.svg.png"),
                    ("YSS", "https://yssthailand.com/images/stories/logo/yss_logo.png"),
                    ("Honda", "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Honda_Logo.svg/512px-Honda_Logo.svg.png"),
                    ("Yamaha", "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Yamaha_Motor_logo.svg/512px-Yamaha_Motor_logo.svg.png"),
                    ("NGK", "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/NGK_logo.svg/512px-NGK_logo.svg.png")
                };
                foreach (var (name, logo) in brandList)
                {
                    if (!context.Brands.Any(b => b.BrandName == name))
                    {
                        context.Brands.Add(new Brand { BrandName = name, LogoUrl = logo });
                    }
                }
                await context.SaveChangesAsync();

                // 7. SEED SHIPPING METHODS
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

                // 8. SEED SERVICE CATEGORIES + SERVICES + COMBOS
                // DisplayOrder > 0 = đã seed đúng; = 0 = do SQL cũ trong Program.cs tạo thủ công → cần xóa & seed lại
                if (!context.ServiceCategories.Any(c => c.DisplayOrder > 0))
                {
                    // Xóa dữ liệu cũ (seeded bởi SQL thủ công hoặc seed cũ) để tránh conflict
                    await context.Database.ExecuteSqlRawAsync("DELETE FROM ServiceComboItems");
                    await context.Database.ExecuteSqlRawAsync("DELETE FROM ServiceImages");
                    await context.Database.ExecuteSqlRawAsync("DELETE FROM ServiceCombos");
                    await context.Database.ExecuteSqlRawAsync("DELETE FROM ServiceBookings WHERE ServiceId IS NOT NULL");
                    await context.Database.ExecuteSqlRawAsync("DELETE FROM Services");
                    await context.Database.ExecuteSqlRawAsync("DELETE FROM ServiceCategories");

                    // --- Danh mục dịch vụ ---
                    var scBaoDuong = new ServiceCategory { CategoryName = "Bảo dưỡng", Slug = "bao-duong", Icon = "bx-wrench", DisplayOrder = 1 };
                    var scRuaXe   = new ServiceCategory { CategoryName = "Rửa xe",    Slug = "rua-xe",    Icon = "bx-droplet",    DisplayOrder = 2 };
                    var scCuuHo   = new ServiceCategory { CategoryName = "Cứu hộ",    Slug = "cuu-ho",    Icon = "bx-car-crash",  DisplayOrder = 3 };
                    var scDoXe    = new ServiceCategory { CategoryName = "Độ xe",     Slug = "do-xe",     Icon = "bx-customize",  DisplayOrder = 4 };
                    var scPhuTung = new ServiceCategory { CategoryName = "Phụ tùng",  Slug = "phu-tung",  Icon = "bx-cog",        DisplayOrder = 5 };
                    var scKiemTra = new ServiceCategory { CategoryName = "Kiểm tra",  Slug = "kiem-tra",  Icon = "bx-search-alt", DisplayOrder = 6 };
                    context.ServiceCategories.AddRange(scBaoDuong, scRuaXe, scCuuHo, scDoXe, scPhuTung, scKiemTra);
                    await context.SaveChangesAsync();

                    // ── BẢO DƯỠNG ──
                    var sv01 = new Service { ServiceName = "Thay nhớt máy + lọc dầu", Slug = "thay-nhot-may-loc-dau", CategoryId = scBaoDuong.CategoryId, Price = 20000, OriginalPrice = null, Duration = 15, WarrantyDays = 90, IsPopular = true, Tags = "nhanh,chinh-hang,bao-hanh", ShortDescription = "Dầu nhớt chính hãng, thay lọc dầu mới, kiểm tra mức dầu toàn diện.", Description = "Sử dụng dầu nhớt chính hãng Motul, Castrol hoặc theo yêu cầu khách hàng. Thay lọc dầu mới, kiểm tra mức dầu, vệ sinh nắp đổ dầu. Bảo hành 3 tháng hoặc 3.000km.", TotalBookings = 342, AverageRating = 4.9m, TotalReviews = 128, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };
                    var sv02 = new Service { ServiceName = "Bảo dưỡng định kỳ 5.000km", Slug = "bao-duong-dinh-ky-5000km", CategoryId = scBaoDuong.CategoryId, Price = 280000, OriginalPrice = 350000, Duration = 45, WarrantyDays = 30, IsPopular = true, Tags = "toan-dien,dinh-ky,bao-hanh", ShortDescription = "Thay nhớt, lọc gió, bugi, kiểm tra phanh, xích nhông toàn diện.", Description = "Gói bảo dưỡng định kỳ 5.000km bao gồm: thay dầu nhớt + lọc dầu, vệ sinh lọc gió, thay bugi, kiểm tra và hiệu chỉnh phanh trước/sau, kiểm tra xích nhông, bơm lốp đúng áp suất, kiểm tra đèn và điện. Phù hợp cho tất cả dòng xe tay ga và côn tay.", TotalBookings = 215, AverageRating = 4.8m, TotalReviews = 89, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv03 = new Service { ServiceName = "Thay lốp xe + cân bằng bánh", Slug = "thay-lop-xe-can-bang-banh", CategoryId = scBaoDuong.CategoryId, Price = 50000, OriginalPrice = null, Duration = 20, WarrantyDays = 30, IsPopular = false, Tags = "lop-xe,michelin,dunlop", ShortDescription = "Thay lốp Michelin, Dunlop, IRC chính hãng. Cân bằng và chỉnh áp suất chuẩn.", Description = "Thay lốp xe chính hãng các thương hiệu: Michelin, Dunlop, IRC, Maxxis. Bao gồm công thay, cân bằng bánh, kiểm tra và bơm áp suất chuẩn theo khuyến cáo nhà sản xuất. Hỗ trợ tất cả kích thước lốp phổ biến tại Việt Nam.", TotalBookings = 178, AverageRating = 4.7m, TotalReviews = 64, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800", IsActive = true };
                    var sv04 = new Service { ServiceName = "Sửa phanh + thay má phanh", Slug = "sua-phanh-thay-ma-phanh", CategoryId = scBaoDuong.CategoryId, Price = 80000, OriginalPrice = null, Duration = 30, WarrantyDays = 30, IsPopular = false, Tags = "phanh,an-toan,brembo", ShortDescription = "Kiểm tra, hiệu chỉnh phanh trước/sau. Thay má phanh Brembo chính hãng nếu cần.", Description = "Kiểm tra toàn bộ hệ thống phanh: má phanh, đĩa phanh, dầu phanh, dây phanh. Hiệu chỉnh độ ăn phanh, thay má phanh Brembo nếu mòn dưới mức an toàn. Giá chưa bao gồm phụ tùng thay thế.", TotalBookings = 143, AverageRating = 4.9m, TotalReviews = 52, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv05 = new Service { ServiceName = "Thay bugi + vệ sinh kim phun", Slug = "thay-bugi-ve-sinh-kim-phun", CategoryId = scBaoDuong.CategoryId, Price = 45000, OriginalPrice = null, Duration = 25, WarrantyDays = 30, IsPopular = false, Tags = "bugi,ngk,kim-phun", ShortDescription = "Thay bugi NGK chính hãng, vệ sinh kim phun xăng, cân chỉnh hỗn hợp nhiên liệu.", Description = "Thay bugi NGK Standard hoặc Iridium theo yêu cầu. Vệ sinh kim phun xăng bằng máy siêu âm chuyên dụng, cân chỉnh hỗn hợp nhiên liệu, kiểm tra cảm biến. Giúp xe tiết kiệm xăng và tăng hiệu suất động cơ.", TotalBookings = 98, AverageRating = 4.6m, TotalReviews = 38, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };

                    // ── RỬA XE ──
                    var sv06 = new Service { ServiceName = "Rửa xe cơ bản", Slug = "rua-xe-co-ban", CategoryId = scRuaXe.CategoryId, Price = 30000, OriginalPrice = null, Duration = 20, WarrantyDays = 0, IsPopular = true, Tags = "rua-xe,sach-se,nhanh", ShortDescription = "Rửa sạch toàn bộ xe bằng máy xịt áp lực cao, lau khô, xịt bóng nhựa.", Description = "Rửa xe bằng máy xịt áp lực cao Karcher chuyên dụng. Xà phòng xe máy chuyên dụng, không ăn mòn sơn. Lau khô bằng khăn microfiber, xịt bóng nhựa đen cho các chi tiết nhựa.", TotalBookings = 512, AverageRating = 4.7m, TotalReviews = 201, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800", IsActive = true };
                    var sv07 = new Service { ServiceName = "Rửa xe cao cấp + đánh bóng", Slug = "rua-xe-cao-cap-danh-bong", CategoryId = scRuaXe.CategoryId, Price = 80000, OriginalPrice = 100000, Duration = 45, WarrantyDays = 0, IsPopular = false, Tags = "danh-bong,cao-cap,bong-dep", ShortDescription = "Rửa sạch, đánh bóng toàn thân xe, xử lý vết xước nhẹ, bảo vệ sơn.", Description = "Rửa xe áp lực cao, đánh bóng toàn thân bằng máy polisher chuyên nghiệp. Xử lý vết xước nhẹ, phục hồi độ bóng sơn, phủ nano bảo vệ sơn 3 tháng. Kết quả: xe sáng bóng như mới xuất xưởng.", TotalBookings = 87, AverageRating = 4.8m, TotalReviews = 34, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };
                    var sv08 = new Service { ServiceName = "Vệ sinh nồi xe ga", Slug = "ve-sinh-noi-xe-ga", CategoryId = scRuaXe.CategoryId, Price = 150000, OriginalPrice = null, Duration = 30, WarrantyDays = 7, IsPopular = true, Tags = "noi-xe-ga,ve-sinh,boc-hon", ShortDescription = "Làm sạch bộ nồi CVT giúp xe chạy bốc hơn, tiết kiệm nhiên liệu.", Description = "Tháo và vệ sinh toàn bộ bộ nồi CVT: puly trước/sau, dây curoa, bi nhông. Làm sạch bụi bẩn, kiểm tra độ mòn dây curoa và bi nhông, tư vấn thay thế nếu cần. Xe chạy bốc hơn 15-20% sau khi vệ sinh.", TotalBookings = 234, AverageRating = 4.9m, TotalReviews = 98, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv09 = new Service { ServiceName = "Vệ sinh bình xăng + thông nhiên liệu", Slug = "ve-sinh-binh-xang-thong-nhien-lieu", CategoryId = scRuaXe.CategoryId, Price = 120000, OriginalPrice = null, Duration = 40, WarrantyDays = 14, IsPopular = false, Tags = "binh-xang,thong-nhien-lieu,xe-cu", ShortDescription = "Vệ sinh bình xăng, lọc xăng, thông đường dẫn nhiên liệu. Phù hợp xe cũ hay nghẹt xăng.", Description = "Tháo vệ sinh bình xăng bằng dung dịch chuyên dụng, thay lọc xăng mới, thông và kiểm tra toàn bộ đường dẫn nhiên liệu. Phù hợp cho xe bị nghẹt xăng, chạy không đều, hay tắt máy đột ngột.", TotalBookings = 76, AverageRating = 4.7m, TotalReviews = 29, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv10 = new Service { ServiceName = "Phủ nano bảo vệ xe", Slug = "phu-nano-bao-ve-xe", CategoryId = scRuaXe.CategoryId, Price = 200000, OriginalPrice = 250000, Duration = 60, WarrantyDays = 90, IsPopular = false, Tags = "nano,bao-ve-son,chong-xuoc", ShortDescription = "Phủ lớp nano ceramic bảo vệ sơn xe khỏi bụi bẩn, UV và xước nhẹ trong 3 tháng.", Description = "Làm sạch bề mặt, clay bar loại bỏ tạp chất, phủ lớp nano ceramic chuyên dụng. Bảo vệ sơn xe khỏi tia UV, bụi bẩn, mưa axit, vết xước nhẹ. Xe dễ rửa hơn, bóng đẹp bền 3-6 tháng.", TotalBookings = 45, AverageRating = 4.8m, TotalReviews = 18, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };

                    // ── CỨU HỘ ──
                    var sv11 = new Service { ServiceName = "Cứu hộ xe chết máy tại chỗ", Slug = "cuu-ho-xe-chet-may-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 150000, OriginalPrice = null, Duration = 30, WarrantyDays = 0, IsPopular = true, Tags = "cuu-ho,khan-cap,24-7", ShortDescription = "Kỹ thuật viên đến tận nơi xử lý xe chết máy trong vòng 30 phút.", Description = "Dịch vụ cứu hộ khẩn cấp 24/7. Kỹ thuật viên có kinh nghiệm sẽ đến tận nơi trong vòng 30 phút (nội thành). Xử lý các sự cố: hết xăng, hỏng điện, chết ắc quy, hỏng khởi động. Phí di chuyển tính theo km nếu ngoài nội thành.", TotalBookings = 189, AverageRating = 4.9m, TotalReviews = 76, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv12 = new Service { ServiceName = "Thay ắc quy tại chỗ", Slug = "thay-ac-quy-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 50000, OriginalPrice = null, Duration = 15, WarrantyDays = 365, IsPopular = false, Tags = "ac-quy,thay-tai-cho,gs-yuasa", ShortDescription = "Mang ắc quy mới đến tận nơi, thay và test ngay tại chỗ. Bảo hành 12 tháng.", Description = "Kỹ thuật viên mang ắc quy GS, Yuasa, Motobatt chính hãng đến tận nơi thay. Test máy phát điện, kiểm tra hệ thống điện tổng thể. Bảo hành ắc quy 12 tháng, đổi mới nếu lỗi.", TotalBookings = 134, AverageRating = 4.8m, TotalReviews = 54, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv13 = new Service { ServiceName = "Vá lốp khẩn cấp tại chỗ", Slug = "va-lop-khan-cap-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 80000, OriginalPrice = null, Duration = 20, WarrantyDays = 30, IsPopular = true, Tags = "va-lop,kep-dinh,nhanh", ShortDescription = "Vá lốp không ruột (tubeless) tại chỗ bằng dây vá chuyên nghiệp. Nhanh chóng và bền.", Description = "Vá lốp tubeless bằng dây vá Moto chuyên nghiệp hoặc vá nguội tùy mức độ hỏng. Bơm lại áp suất chuẩn, kiểm tra rò rỉ. Không áp dụng cho lốp hỏng quá 3 lỗ hoặc hỏng thành lốp.", TotalBookings = 267, AverageRating = 4.7m, TotalReviews = 103, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800", IsActive = true };
                    var sv14 = new Service { ServiceName = "Kéo xe về xưởng", Slug = "keo-xe-ve-xuong", CategoryId = scCuuHo.CategoryId, Price = 200000, OriginalPrice = null, Duration = 60, WarrantyDays = 0, IsPopular = false, Tags = "keo-xe,tai-nan,hu-nang", ShortDescription = "Kéo xe về xưởng khi hỏng nặng không sửa được tại chỗ. Phí tính theo km.", Description = "Dịch vụ kéo xe bằng xe tải chuyên dụng. Phí cơ bản 200.000₫ trong bán kính 5km, +20.000₫/km tiếp theo. Đội ngũ chuyên nghiệp, bảo đảm xe nguyên vẹn trong quá trình vận chuyển. Hỗ trợ 24/7.", TotalBookings = 78, AverageRating = 4.6m, TotalReviews = 31, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };
                    var sv15 = new Service { ServiceName = "Sạc ắc quy tại chỗ", Slug = "sac-ac-quy-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 30000, OriginalPrice = null, Duration = 45, WarrantyDays = 0, IsPopular = false, Tags = "sac-ac-quy,het-dien,nhanh", ShortDescription = "Sạc ắc quy nhanh tại chỗ bằng máy sạc thông minh. Xong trong 30-45 phút.", Description = "Sạc ắc quy bằng máy sạc CTEK hoặc NOCO chuyên nghiệp. Phục hồi ắc quy bị hết hoàn toàn, kiểm tra sức khỏe ắc quy sau khi sạc, tư vấn có nên thay mới không.", TotalBookings = 156, AverageRating = 4.8m, TotalReviews = 58, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };

                    // ── ĐỘ XE ──
                    var sv16 = new Service { ServiceName = "Lắp đèn LED + đèn trợ sáng", Slug = "lap-den-led-den-tro-sang", CategoryId = scDoXe.CategoryId, Price = 150000, OriginalPrice = 180000, Duration = 60, WarrantyDays = 180, IsPopular = true, Tags = "den-led,do-xe,sang-hon", ShortDescription = "Lắp đèn LED pha sáng hơn, đèn trợ sáng 30W-50W. Bảo hành 6 tháng.", Description = "Thay thế đèn pha halogen sang LED cao cấp sáng gấp 3 lần. Lắp thêm đèn trợ sáng Yamaha, Osram 30-50W cho xe phượt và xe côn. Đi dây điện gọn gàng, chống nước IP67. Bảo hành 6 tháng.", TotalBookings = 145, AverageRating = 4.8m, TotalReviews = 56, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv17 = new Service { ServiceName = "Lắp giảm xóc hậu Ohlins/YSS", Slug = "lap-giam-xoc-hau-ohlins-yss", CategoryId = scDoXe.CategoryId, Price = 200000, OriginalPrice = null, Duration = 45, WarrantyDays = 30, IsPopular = false, Tags = "giam-xoc,ohlins,yss,do-xe", ShortDescription = "Tháo lắp giảm xóc hậu cao cấp Ohlins, YSS. Cân chỉnh chiều cao và độ cứng.", Description = "Tháo giảm xóc hậu cũ, lắp giảm xóc Ohlins S36E hoặc YSS G-Plus theo yêu cầu. Cân chỉnh chiều cao xe, điều chỉnh độ cứng phù hợp cân nặng người lái. Kiểm tra góc lái sau khi lắp. Giá chưa bao gồm giảm xóc.", TotalBookings = 89, AverageRating = 4.9m, TotalReviews = 34, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv18 = new Service { ServiceName = "Lắp ốp nội thất + decal", Slug = "lap-op-noi-that-decal", CategoryId = scDoXe.CategoryId, Price = 100000, OriginalPrice = null, Duration = 60, WarrantyDays = 90, IsPopular = false, Tags = "op-xe,decal,do-ngoai-that", ShortDescription = "Lắp ốp nhựa ABS cao cấp, dán decal tem xe theo yêu cầu. 100+ mẫu có sẵn.", Description = "Lắp ốp nội thất, ốp bình xăng, ốp đuôi xe bằng nhựa ABS cao cấp không phai màu. Dán decal tem xe theo mẫu có sẵn hoặc thiết kế theo yêu cầu. Bảo hành không bong tróc 3 tháng.", TotalBookings = 67, AverageRating = 4.7m, TotalReviews = 25, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };
                    var sv19 = new Service { ServiceName = "Lắp hệ thống âm thanh Bluetooth", Slug = "lap-he-thong-am-thanh-bluetooth", CategoryId = scDoXe.CategoryId, Price = 300000, OriginalPrice = 380000, Duration = 90, WarrantyDays = 180, IsPopular = false, Tags = "am-thanh,bluetooth,loa-xe", ShortDescription = "Lắp loa Bluetooth không dây, kết nối điện thoại, nghe nhạc khi lái xe.", Description = "Lắp hệ thống loa Bluetooth chống nước IPX5 lên ghi đông hoặc yên xe. Kết nối điện thoại qua Bluetooth, âm lượng lớn rõ ràng ngay cả khi chạy tốc độ cao. Tích hợp nút điều khiển trên tay lái. Bảo hành 6 tháng.", TotalBookings = 43, AverageRating = 4.6m, TotalReviews = 17, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv20 = new Service { ServiceName = "Lắp khóa chống trộm thông minh", Slug = "lap-khoa-chong-trom-thong-minh", CategoryId = scDoXe.CategoryId, Price = 180000, OriginalPrice = null, Duration = 60, WarrantyDays = 365, IsPopular = true, Tags = "khoa-chong-trom,bao-mat,gps", ShortDescription = "Lắp khóa chống trộm cảm biến rung + cảnh báo điện thoại. Bảo hành 12 tháng.", Description = "Lắp hệ thống chống trộm thông minh: cảm biến rung, còi cảnh báo 120dB, gửi thông báo về điện thoại qua app. Một số model có tích hợp GPS theo dõi vị trí xe realtime. Giá chưa bao gồm thiết bị.", TotalBookings = 112, AverageRating = 4.8m, TotalReviews = 44, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };

                    // ── PHỤ TÙNG ──
                    var sv21 = new Service { ServiceName = "Thay xích nhông đĩa", Slug = "thay-xich-nhong-dia", CategoryId = scPhuTung.CategoryId, Price = 60000, OriginalPrice = null, Duration = 30, WarrantyDays = 90, IsPopular = true, Tags = "xich-nhong,cong-thay,chinh-hang", ShortDescription = "Công thay xích nhông đĩa chính hãng Honda/Yamaha. Cân chỉnh xích đúng độ căng.", Description = "Tháo lắp bộ xích nhông đĩa, cân chỉnh độ căng xích theo tiêu chuẩn nhà sản xuất. Bôi mỡ chuyên dụng, kiểm tra độ mòn và tư vấn chu kỳ thay tiếp theo. Giá chưa bao gồm xích nhông.", TotalBookings = 198, AverageRating = 4.8m, TotalReviews = 78, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv22 = new Service { ServiceName = "Thay gương + đèn xi nhan", Slug = "thay-guong-den-xi-nhan", CategoryId = scPhuTung.CategoryId, Price = 30000, OriginalPrice = null, Duration = 15, WarrantyDays = 30, IsPopular = false, Tags = "guong,xi-nhan,chinh-hang", ShortDescription = "Thay gương chiếu hậu và đèn xi nhan chính hãng. Nhanh chóng, giá rẻ.", Description = "Thay gương chiếu hậu Honda, Yamaha, Piaggio chính hãng. Thay bóng đèn xi nhan, kiểm tra mạch điện. Giá là công lắp, chưa bao gồm phụ tùng. Hỗ trợ tư vấn chọn gương phù hợp xe.", TotalBookings = 145, AverageRating = 4.7m, TotalReviews = 55, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv23 = new Service { ServiceName = "Thay dây curoa xe ga", Slug = "thay-day-curoa-xe-ga", CategoryId = scPhuTung.CategoryId, Price = 80000, OriginalPrice = null, Duration = 40, WarrantyDays = 90, IsPopular = false, Tags = "day-curoa,xe-ga,chinh-hang", ShortDescription = "Thay dây curoa chính hãng, kiểm tra bi nhông, điều chỉnh côn tự động.", Description = "Tháo hộp số CVT, thay dây curoa mới chính hãng theo đúng model xe. Kiểm tra và thay bi nhông nếu mòn, vệ sinh và bôi mỡ hộp số, cân chỉnh côn tự động. Giá chưa bao gồm dây curoa.", TotalBookings = 167, AverageRating = 4.8m, TotalReviews = 64, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv24 = new Service { ServiceName = "Thay lọc gió + vệ sinh bộ chế hòa khí", Slug = "thay-loc-gio-ve-sinh-bo-che-hoa-khi", CategoryId = scPhuTung.CategoryId, Price = 50000, OriginalPrice = null, Duration = 30, WarrantyDays = 30, IsPopular = false, Tags = "loc-gio,che-hoa-khi,tiet-kiem-xang", ShortDescription = "Thay lọc gió mới, vệ sinh bộ chế hòa khí giúp xe tiết kiệm xăng hơn 10%.", Description = "Thay lọc gió theo đúng OEM xe, vệ sinh buồng phao và kim ga bộ chế hòa khí bằng dung dịch chuyên dụng. Cân chỉnh tỉ lệ hỗn hợp nhiên liệu-không khí tối ưu. Giá chưa bao gồm lọc gió.", TotalBookings = 123, AverageRating = 4.7m, TotalReviews = 47, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv25 = new Service { ServiceName = "Thay nhớt hộp số + nhớt phuộc", Slug = "thay-nhot-hop-so-nhot-phuoc", CategoryId = scPhuTung.CategoryId, Price = 35000, OriginalPrice = null, Duration = 20, WarrantyDays = 30, IsPopular = false, Tags = "nhot-hop-so,nhot-phuoc,bao-duong", ShortDescription = "Thay nhớt hộp số xe côn tay và nhớt phuộc trước. Thường bị bỏ qua khi bảo dưỡng.", Description = "Thay nhớt hộp số xe côn tay (thường bỏ quên khi thay nhớt định kỳ), thay nhớt phuộc trước giúp phuộc êm hơn. Kiểm tra độ rò rỉ, tư vấn chu kỳ thay tiếp theo. Giá chưa bao gồm nhớt.", TotalBookings = 89, AverageRating = 4.8m, TotalReviews = 33, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };

                    // ── KIỂM TRA ──
                    var sv26 = new Service { ServiceName = "Kiểm tra tổng quát miễn phí", Slug = "kiem-tra-tong-quat-mien-phi", CategoryId = scKiemTra.CategoryId, Price = 0, OriginalPrice = null, Duration = 20, WarrantyDays = 0, IsPopular = true, Tags = "mien-phi,kiem-tra,tu-van", ShortDescription = "Kiểm tra 20 hạng mục an toàn miễn phí. Nhận báo cáo tình trạng xe chi tiết.", Description = "Kiểm tra 20 hạng mục: phanh, lốp, đèn, điện, nhớt, xích, phuộc, bugi, lọc gió, ắc quy... Nhận báo cáo chi tiết tình trạng xe, tư vấn ưu tiên sửa chữa. Hoàn toàn miễn phí, không ép mua thêm dịch vụ.", TotalBookings = 456, AverageRating = 4.9m, TotalReviews = 187, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv27 = new Service { ServiceName = "Kiểm tra hệ thống điện", Slug = "kiem-tra-he-thong-dien", CategoryId = scKiemTra.CategoryId, Price = 50000, OriginalPrice = null, Duration = 30, WarrantyDays = 0, IsPopular = false, Tags = "kiem-tra-dien,ac-quy,may-phat", ShortDescription = "Kiểm tra ắc quy, máy phát điện, hệ thống đánh lửa, relay và cầu chì toàn bộ.", Description = "Dùng thiết bị chuyên dụng kiểm tra: sức khỏe ắc quy (CCA), điện áp máy phát, bộ nạp điện, hệ thống đánh lửa, relay, cầu chì. Tìm nguyên nhân xe hay hết điện, khởi động yếu, đèn chớp tắt bất thường.", TotalBookings = 134, AverageRating = 4.8m, TotalReviews = 51, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv28 = new Service { ServiceName = "Đọc lỗi động cơ (OBD/FI)", Slug = "doc-loi-dong-co-obd-fi", CategoryId = scKiemTra.CategoryId, Price = 80000, OriginalPrice = null, Duration = 20, WarrantyDays = 0, IsPopular = false, Tags = "doc-loi,fi,obd,cam-bien", ShortDescription = "Đọc và xóa lỗi hệ thống FI (phun xăng điện tử) bằng thiết bị chuyên dụng.", Description = "Kết nối thiết bị chẩn đoán chuyên dụng đọc mã lỗi động cơ FI/EFI. Xác định chính xác cảm biến hoặc linh kiện lỗi, xóa lỗi sau khi sửa chữa. Hỗ trợ Honda (HDS), Yamaha (YDT), Suzuki, Kawasaki.", TotalBookings = 98, AverageRating = 4.8m, TotalReviews = 38, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv29 = new Service { ServiceName = "Kiểm tra và cân chỉnh carburetor", Slug = "kiem-tra-can-chinh-carburetor", CategoryId = scKiemTra.CategoryId, Price = 60000, OriginalPrice = null, Duration = 30, WarrantyDays = 14, IsPopular = false, Tags = "carburetor,can-chinh,xe-cu", ShortDescription = "Kiểm tra, vệ sinh và cân chỉnh bộ chế hòa khí cho xe dùng xăng cơ học (không FI).", Description = "Tháo vệ sinh toàn bộ bộ chế hòa khí, cân chỉnh vít gió, kim ga, phao xăng đúng mực. Phù hợp xe cũ dùng carburetor: Wave cũ, Dream, xe côn đời cũ. Xe chạy đều hơn, tiết kiệm xăng hơn.", TotalBookings = 78, AverageRating = 4.7m, TotalReviews = 29, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv30 = new Service { ServiceName = "Kiểm tra trước chuyến đi dài", Slug = "kiem-tra-truoc-chuyen-di-dai", CategoryId = scKiemTra.CategoryId, Price = 100000, OriginalPrice = 150000, Duration = 45, WarrantyDays = 0, IsPopular = true, Tags = "truoc-chuyen-di,phuot,an-toan", ShortDescription = "Kiểm tra toàn diện xe trước chuyến phượt dài. Đảm bảo an toàn tuyệt đối cho hành trình.", Description = "Gói kiểm tra chuyên biệt cho chuyến đi dài: lốp xe (áp suất, độ mòn, vết nứt), phanh (má phanh, dầu phanh), xích nhông (độ căng, độ mòn), đèn chiếu sáng, ắc quy và điện, nhớt máy, lọc gió. Cấp báo cáo kiểm tra kèm khuyến nghị. Phù hợp xe côn tay và xe phượt.", TotalBookings = 167, AverageRating = 4.9m, TotalReviews = 68, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };

                    context.Services.AddRange(sv01, sv02, sv03, sv04, sv05, sv06, sv07, sv08, sv09, sv10, sv11, sv12, sv13, sv14, sv15, sv16, sv17, sv18, sv19, sv20, sv21, sv22, sv23, sv24, sv25, sv26, sv27, sv28, sv29, sv30);
                    await context.SaveChangesAsync();

                    // --- ServiceImages chi tiết ---
                    context.ServiceImages.AddRange(
                        new ServiceImage { ServiceId = sv01.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv01.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv01.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 3 },
                        new ServiceImage { ServiceId = sv01.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=1200", DisplayOrder = 4 },
                        new ServiceImage { ServiceId = sv02.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv02.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv02.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 3 },
                        new ServiceImage { ServiceId = sv03.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv03.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv04.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv04.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv05.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv06.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv06.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv07.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv07.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv08.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv08.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv09.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv10.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv11.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv11.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv12.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv13.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv13.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv14.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv15.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv16.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv16.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv17.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv18.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv19.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv20.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv21.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv22.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv23.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv24.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv25.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv26.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv26.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", DisplayOrder = 2 },
                        new ServiceImage { ServiceId = sv27.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv28.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv29.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv30.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=1200", DisplayOrder = 1 },
                        new ServiceImage { ServiceId = sv30.ServiceId, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1200", DisplayOrder = 2 }
                    );
                    await context.SaveChangesAsync();

                    // --- Combo dịch vụ ---
                    var combo1 = new ServiceCombo { ComboName = "Gói Bảo dưỡng Cơ bản",    TotalPrice = 65000,  DiscountPrice = 55000,  Description = "Gói tiết kiệm cho bảo dưỡng hàng tháng. Thay nhớt + thay bugi trong một lần ghé.",                                               ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800" };
                    var combo2 = new ServiceCombo { ComboName = "Gói Bảo dưỡng Toàn Diện", TotalPrice = 375000, DiscountPrice = 320000, Description = "Gói bảo dưỡng định kỳ đầy đủ nhất. Phù hợp xe đã chạy 5.000–10.000km.",                                                      ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800" };
                    var combo3 = new ServiceCombo { ComboName = "Gói Rửa xe + Bảo dưỡng",  TotalPrice = 110000, DiscountPrice = 90000,  Description = "Kết hợp thay nhớt và rửa xe cao cấp. Xe vừa bảo dưỡng vừa sạch bóng.",                                                        ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800" };
                    var combo4 = new ServiceCombo { ComboName = "Gói An Toàn Phanh + Lốp", TotalPrice = 130000, DiscountPrice = 110000, Description = "Kiểm tra và sửa phanh, thay lốp cùng lúc. An toàn toàn diện cho cả xe.",                                                      ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800" };
                    var combo5 = new ServiceCombo { ComboName = "Gói Phượt An Toàn",        TotalPrice = 290000, DiscountPrice = 240000, Description = "Chuẩn bị hoàn hảo trước chuyến phượt dài. Đảm bảo xe luôn trong trạng thái tốt nhất.",                                        ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800" };
                    var combo6 = new ServiceCombo { ComboName = "Gói Độ xe Cơ bản",         TotalPrice = 430000, DiscountPrice = 380000, Description = "Gói độ xe phổ biến nhất: LED sáng hơn, giảm xóc tốt hơn, ngoại thất đẹp hơn.",                                                ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800" };
                    context.ServiceCombos.AddRange(combo1, combo2, combo3, combo4, combo5, combo6);
                    await context.SaveChangesAsync();

                    context.ServiceComboItems.AddRange(
                        new ServiceComboItem { ComboId = combo1.ComboId, ServiceId = sv01.ServiceId },
                        new ServiceComboItem { ComboId = combo1.ComboId, ServiceId = sv05.ServiceId },
                        new ServiceComboItem { ComboId = combo2.ComboId, ServiceId = sv02.ServiceId },
                        new ServiceComboItem { ComboId = combo2.ComboId, ServiceId = sv05.ServiceId },
                        new ServiceComboItem { ComboId = combo2.ComboId, ServiceId = sv25.ServiceId },
                        new ServiceComboItem { ComboId = combo2.ComboId, ServiceId = sv26.ServiceId },
                        new ServiceComboItem { ComboId = combo3.ComboId, ServiceId = sv01.ServiceId },
                        new ServiceComboItem { ComboId = combo3.ComboId, ServiceId = sv07.ServiceId },
                        new ServiceComboItem { ComboId = combo4.ComboId, ServiceId = sv03.ServiceId },
                        new ServiceComboItem { ComboId = combo4.ComboId, ServiceId = sv04.ServiceId },
                        new ServiceComboItem { ComboId = combo5.ComboId, ServiceId = sv30.ServiceId },
                        new ServiceComboItem { ComboId = combo5.ComboId, ServiceId = sv04.ServiceId },
                        new ServiceComboItem { ComboId = combo5.ComboId, ServiceId = sv03.ServiceId },
                        new ServiceComboItem { ComboId = combo5.ComboId, ServiceId = sv21.ServiceId },
                        new ServiceComboItem { ComboId = combo6.ComboId, ServiceId = sv16.ServiceId },
                        new ServiceComboItem { ComboId = combo6.ComboId, ServiceId = sv17.ServiceId },
                        new ServiceComboItem { ComboId = combo6.ComboId, ServiceId = sv18.ServiceId }
                    );
                    await context.SaveChangesAsync();
                }

                // 9. SEED 10 SẢN PHẨM ĐẦY ĐỦ THÔNG TIN
                if (!context.Products.Any())
                {
                    // Lấy categories và brands đã seed
                    var catDauNhot    = await context.Categories.FirstAsync(c => c.CategoryName == "Dầu nhớt & Bôi trơn");
                    var catPhuTung    = await context.Categories.FirstAsync(c => c.CategoryName == "Phụ tùng & Phụ kiện");
                    var catPhanh      = await context.Categories.FirstAsync(c => c.CategoryName == "Hệ thống phanh");
                    var catLop        = await context.Categories.FirstAsync(c => c.CategoryName == "Lốp xe & Vành");
                    var catGiamXoc    = await context.Categories.FirstAsync(c => c.CategoryName == "Giảm xóc");

                    var brandMotul    = await context.Brands.FirstAsync(b => b.BrandName == "Motul");
                    var brandLiqui    = await context.Brands.FirstAsync(b => b.BrandName == "Liqui Moly");
                    var brandBrembo   = await context.Brands.FirstAsync(b => b.BrandName == "Brembo");
                    var brandMichelin = await context.Brands.FirstAsync(b => b.BrandName == "Michelin");
                    var brandOhlins   = await context.Brands.FirstAsync(b => b.BrandName == "Ohlins");
                    var brandYSS      = await context.Brands.FirstAsync(b => b.BrandName == "YSS");
                    var brandHonda    = await context.Brands.FirstAsync(b => b.BrandName == "Honda");
                    var brandYamaha   = await context.Brands.FirstAsync(b => b.BrandName == "Yamaha");
                    var brandNGK      = await context.Brands.FirstAsync(b => b.BrandName == "NGK");

                    // Lấy motorbike models
                    var modelWinnerX  = await context.MotorbikeModels.FirstOrDefaultAsync(m => m.ModelName == "Winner X");
                    var modelExciter  = await context.MotorbikeModels.FirstOrDefaultAsync(m => m.ModelName == "Exciter 155");
                    var modelNVX      = await context.MotorbikeModels.FirstOrDefaultAsync(m => m.ModelName == "NVX 155");
                    var modelAirBlade = await context.MotorbikeModels.FirstOrDefaultAsync(m => m.ModelName == "Air Blade 160");
                    var modelPCX      = await context.MotorbikeModels.FirstOrDefaultAsync(m => m.ModelName == "PCX 160");
                    var modelVario    = await context.MotorbikeModels.FirstOrDefaultAsync(m => m.ModelName == "Vario 160");

                    // ============================================================
                    // Tạo các Attribute dùng chung
                    // ============================================================
                    var attrDungTich = new ProductAttribute { AttributeName = "Dung tích" };
                    var attrKichThuoc = new ProductAttribute { AttributeName = "Kích thước" };
                    var attrViTri = new ProductAttribute { AttributeName = "Vị trí" };
                    var attrDongXe = new ProductAttribute { AttributeName = "Dòng xe" };
                    context.ProductAttributes.AddRange(attrDungTich, attrKichThuoc, attrViTri, attrDongXe);
                    await context.SaveChangesAsync();

                    // Attribute values - Dung tích
                    var val800ml = new AttributeValue { AttributeId = attrDungTich.AttributeId, Value = "800ml" };
                    var val1L    = new AttributeValue { AttributeId = attrDungTich.AttributeId, Value = "1 Lít" };
                    var val4L    = new AttributeValue { AttributeId = attrDungTich.AttributeId, Value = "4 Lít" };
                    var val250ml = new AttributeValue { AttributeId = attrDungTich.AttributeId, Value = "250ml" };
                    var val500ml = new AttributeValue { AttributeId = attrDungTich.AttributeId, Value = "500ml" };
                    context.AttributeValues.AddRange(val800ml, val1L, val4L, val250ml, val500ml);

                    // Attribute values - Kích thước lốp
                    var valLop7090  = new AttributeValue { AttributeId = attrKichThuoc.AttributeId, Value = "70/90-17" };
                    var valLop8090  = new AttributeValue { AttributeId = attrKichThuoc.AttributeId, Value = "80/90-17" };
                    var valLop9080  = new AttributeValue { AttributeId = attrKichThuoc.AttributeId, Value = "90/80-17" };
                    var valLop10080 = new AttributeValue { AttributeId = attrKichThuoc.AttributeId, Value = "100/80-17" };
                    context.AttributeValues.AddRange(valLop7090, valLop8090, valLop9080, valLop10080);

                    // Attribute values - Vị trí phanh
                    var valTruoc = new AttributeValue { AttributeId = attrViTri.AttributeId, Value = "Phanh Trước" };
                    var valSau   = new AttributeValue { AttributeId = attrViTri.AttributeId, Value = "Phanh Sau" };
                    context.AttributeValues.AddRange(valTruoc, valSau);

                    // Attribute values - Dòng xe
                    var valWave        = new AttributeValue { AttributeId = attrDongXe.AttributeId, Value = "Wave / Dream / Future" };
                    var valWinnerX     = new AttributeValue { AttributeId = attrDongXe.AttributeId, Value = "Winner X / CB150R" };
                    var valAirBladePCX = new AttributeValue { AttributeId = attrDongXe.AttributeId, Value = "Air Blade / PCX 160" };
                    var valExciter     = new AttributeValue { AttributeId = attrDongXe.AttributeId, Value = "Exciter 150/155" };
                    var valNVX         = new AttributeValue { AttributeId = attrDongXe.AttributeId, Value = "NVX 155 / Aerox" };
                    var valFreeGo      = new AttributeValue { AttributeId = attrDongXe.AttributeId, Value = "FreeGo 125" };
                    context.AttributeValues.AddRange(valWave, valWinnerX, valAirBladePCX, valExciter, valNVX, valFreeGo);
                    await context.SaveChangesAsync();

                    // Seed review customer
                    var reviewCustomer = await context.Customers.FirstOrDefaultAsync();
                    if (reviewCustomer == null)
                    {
                        reviewCustomer = new Customer { FullName = "Trần Minh Khoa", Email = "khoa.tran@gmail.com", Phone = "0901234567", AvatarUrl = "https://i.pravatar.cc/150?img=12" };
                        context.Customers.Add(reviewCustomer);
                        await context.SaveChangesAsync();
                    }
                    var reviewCustomer2 = new Customer { FullName = "Nguyễn Thị Lan", Email = "lan.nguyen@gmail.com", Phone = "0912345678", AvatarUrl = "https://i.pravatar.cc/150?img=47" };
                    context.Customers.Add(reviewCustomer2);
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 1: Dầu nhớt Motul 7100 10W40 Full Synthetic
                    // ============================================================
                    var p1 = new Product
                    {
                        ProductName = "Dầu nhớt Motul 7100 10W40 4T",
                        CategoryId = catDauNhot.CategoryId,
                        BrandId = brandMotul.BrandId,
                        Slug = "dau-nhot-motul-7100-10w40-4t",
                        Description = "<h4>Motul 7100 10W40 — Nhớt Tổng Hợp Toàn Phần Cao Cấp</h4><p>Motul 7100 là dòng nhớt <strong>100% tổng hợp ester</strong> tiêu chuẩn đường đua, được hàng triệu biker tin dùng tại Việt Nam. Công thức ester tiên tiến giúp bảo vệ động cơ tối đa, giảm mài mòn và duy trì hiệu suất ổn định ngay cả khi vận hành cường độ cao.</p><ul><li>Tổng hợp toàn phần 100% ester — bảo vệ vượt trội</li><li>Giảm nhiệt độ động cơ hiệu quả</li><li>Phù hợp BS6/Euro 5, hộp số tích hợp</li><li>Bảo hành 3.000km hoặc 3 tháng</li></ul>",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now.AddDays(-30)
                    };
                    context.Products.Add(p1);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p1.ProductId, ImageUrl = "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p1.ProductId, ImageUrl = "https://bizweb.dktcdn.net/100/409/246/products/nhot-motul-7100-10w40-1l-hang-chinh-hang-1-081498b5-5c3b-4860-9be0-f94d93026a8d.jpg", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p1.ProductId, ImageUrl = "https://www.motul.com/sites/default/files/product-images/104093-BS4-4L.jpg", IsPrimary = false, DisplayOrder = 3 },
                        new ProductImage { ProductId = p1.ProductId, ImageUrl = "https://product.hstatic.net/200000430800/product/motul7100-banner_grande.jpg", IsPrimary = false, DisplayOrder = 4 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p1.ProductId, SpecName = "Loại nhớt", SpecValue = "Tổng hợp toàn phần (100% Ester)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p1.ProductId, SpecName = "Độ nhớt", SpecValue = "10W-40", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p1.ProductId, SpecName = "Tiêu chuẩn API", SpecValue = "API SL / JASO MA2", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p1.ProductId, SpecName = "Ứng dụng", SpecValue = "Xe số, xe côn tay 4 thì", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p1.ProductId, SpecName = "Chu kỳ thay", SpecValue = "3.000km hoặc 3 tháng", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p1.ProductId, TagName = "nhớt tổng hợp" },
                        new ProductTag { ProductId = p1.ProductId, TagName = "Motul 7100" },
                        new ProductTag { ProductId = p1.ProductId, TagName = "dầu động cơ" }
                    });
                    var p1v1 = new ProductVariant { ProductId = p1.ProductId, VariantName = "Chai 1 Lít", Price = 320000, OriginalPrice = 355000, CostPrice = 220000, SKU = "MOTUL-7100-1L", StockQuantity = 150, ImageUrl = "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png", MinStockLevel = 20, CreatedDate = DateTime.Now };
                    var p1v2 = new ProductVariant { ProductId = p1.ProductId, VariantName = "Can 4 Lít", Price = 1050000, OriginalPrice = 1200000, CostPrice = 720000, SKU = "MOTUL-7100-4L", StockQuantity = 80, ImageUrl = "https://www.motul.com/sites/default/files/product-images/104093-BS4-4L.jpg", MinStockLevel = 10, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p1v1, p1v2);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p1v1.ProductVariantId, ValueId = val1L.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p1v2.ProductVariantId, ValueId = val4L.ValueId }
                    );
                    context.ProductReviews.AddRange(new List<ProductReview>
                    {
                        new ProductReview { ProductId = p1.ProductId, ProductVariantId = p1v1.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 5, Comment = "Nhớt thật sự rất tốt, máy êm hơn hẳn so với nhớt hãng. Đã dùng được 2.500km vẫn còn rất ngon. Winner X của mình mát máy hơn nhiều.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-10) },
                        new ProductReview { ProductId = p1.ProductId, ProductVariantId = p1v2.ProductVariantId, CustomerId = reviewCustomer2.CustomerId, Rating = 5, Comment = "Mua can 4L về tự thay tiết kiệm hơn nhiều. Hàng chính hãng, tem niêm phong nguyên vẹn. Giao hàng nhanh, đóng gói cẩn thận.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-5) }
                    });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 2: Dầu nhớt Motul 5100 10W40 Semi-Synthetic
                    // ============================================================
                    var p2 = new Product
                    {
                        ProductName = "Dầu nhớt Motul 5100 10W40 4T",
                        CategoryId = catDauNhot.CategoryId,
                        BrandId = brandMotul.BrandId,
                        Slug = "dau-nhot-motul-5100-10w40-4t",
                        Description = "<h4>Motul 5100 — Bán Tổng Hợp Ester Chính Hãng</h4><p>Motul 5100 là dòng nhớt <strong>bán tổng hợp (Technosynthese)</strong> sử dụng công nghệ ester, mang lại hiệu suất bôi trơn tốt với chi phí hợp lý hơn dòng 7100. Phù hợp với đa số xe số và xe côn tay thế hệ hiện tại.</p><ul><li>Công nghệ Technosynthese (bán tổng hợp ester)</li><li>Bảo vệ động cơ và hộp số tích hợp</li><li>Tiêu chuẩn JASO MA2 — phù hợp ly hợp ướt</li><li>Tiết kiệm nhiên liệu hơn nhờt khoáng</li></ul>",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now.AddDays(-25)
                    };
                    context.Products.Add(p2);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p2.ProductId, ImageUrl = "https://picsum.photos/seed/motul5100-main/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p2.ProductId, ImageUrl = "https://picsum.photos/seed/motul5100-side/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p2.ProductId, ImageUrl = "https://picsum.photos/seed/motul5100-pack/640/640", IsPrimary = false, DisplayOrder = 3 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p2.ProductId, SpecName = "Loại nhớt", SpecValue = "Bán tổng hợp Technosynthese", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p2.ProductId, SpecName = "Độ nhớt", SpecValue = "10W-40", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p2.ProductId, SpecName = "Tiêu chuẩn API", SpecValue = "API SL / JASO MA2", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p2.ProductId, SpecName = "Ứng dụng", SpecValue = "Xe số, xe côn tay 4 thì", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p2.ProductId, SpecName = "Chu kỳ thay", SpecValue = "3.000km hoặc 3 tháng", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p2.ProductId, TagName = "nhớt bán tổng hợp" },
                        new ProductTag { ProductId = p2.ProductId, TagName = "Motul 5100" },
                        new ProductTag { ProductId = p2.ProductId, TagName = "tiết kiệm" }
                    });
                    var p2v1 = new ProductVariant { ProductId = p2.ProductId, VariantName = "Chai 1 Lít", Price = 165000, OriginalPrice = 185000, CostPrice = 110000, SKU = "MOTUL-5100-1L", StockQuantity = 200, ImageUrl = "https://picsum.photos/seed/motul5100-main/640/640", MinStockLevel = 20, CreatedDate = DateTime.Now };
                    var p2v2 = new ProductVariant { ProductId = p2.ProductId, VariantName = "Can 4 Lít", Price = 580000, OriginalPrice = 650000, CostPrice = 380000, SKU = "MOTUL-5100-4L", StockQuantity = 100, ImageUrl = "https://picsum.photos/seed/motul5100-pack/640/640", MinStockLevel = 10, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p2v1, p2v2);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p2v1.ProductVariantId, ValueId = val1L.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p2v2.ProductVariantId, ValueId = val4L.ValueId }
                    );
                    context.ProductReviews.Add(new ProductReview { ProductId = p2.ProductId, ProductVariantId = p2v1.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 4, Comment = "Nhớt tốt, máy khá êm. Giá thành phải chăng hơn dòng 7100. Dùng cho xe số hàng ngày là quá ổn.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-8) });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 3: Liqui Moly Motorbike 4T 10W40
                    // ============================================================
                    var p3 = new Product
                    {
                        ProductName = "Dầu nhớt Liqui Moly Motorbike 4T 10W40",
                        CategoryId = catDauNhot.CategoryId,
                        BrandId = brandLiqui.BrandId,
                        Slug = "dau-nhot-liqui-moly-motorbike-4t-10w40",
                        Description = "<h4>Liqui Moly 4T 10W40 — Thương Hiệu Đức Uy Tín Số 1</h4><p>Liqui Moly là thương hiệu nhớt <strong>Đức cao cấp</strong>, được vinh danh nhớt tốt nhất thị trường châu Âu nhiều năm liền. Dòng Motorbike 4T được tối ưu hóa đặc biệt cho xe máy 4 thì với ly hợp ướt tích hợp hộp số.</p><ul><li>Xuất xứ Đức — chất lượng châu Âu đỉnh cao</li><li>Công thức HC-Synthesis (tổng hợp hydro-cracking)</li><li>Bảo vệ tối ưu trong điều kiện kẹt xe, nhiệt độ cao</li><li>Không làm trơn ly hợp — đúng tiêu chuẩn JASO MA2</li></ul>",
                        IsActive = true,
                        IsFeatured = false,
                        CreatedDate = DateTime.Now.AddDays(-20)
                    };
                    context.Products.Add(p3);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p3.ProductId, ImageUrl = "https://picsum.photos/seed/liquimoly-800ml/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p3.ProductId, ImageUrl = "https://picsum.photos/seed/liquimoly-1l/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p3.ProductId, ImageUrl = "https://picsum.photos/seed/liquimoly-4l/640/640", IsPrimary = false, DisplayOrder = 3 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p3.ProductId, SpecName = "Loại nhớt", SpecValue = "HC-Synthesis (tổng hợp hydrocracking)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p3.ProductId, SpecName = "Độ nhớt", SpecValue = "10W-40", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p3.ProductId, SpecName = "Tiêu chuẩn", SpecValue = "API SL / JASO MA2 / MB 229.1", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p3.ProductId, SpecName = "Xuất xứ", SpecValue = "Đức (Germany)", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p3.ProductId, SpecName = "Chu kỳ thay", SpecValue = "3.000km hoặc 3 tháng", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p3.ProductId, TagName = "nhớt Đức" },
                        new ProductTag { ProductId = p3.ProductId, TagName = "Liqui Moly" },
                        new ProductTag { ProductId = p3.ProductId, TagName = "hàng chính hãng" }
                    });
                    var p3v1 = new ProductVariant { ProductId = p3.ProductId, VariantName = "Chai 800ml", Price = 185000, OriginalPrice = 210000, CostPrice = 125000, SKU = "LIQMO-4T-800ML", StockQuantity = 120, ImageUrl = "https://picsum.photos/seed/liquimoly-800ml/640/640", MinStockLevel = 15, CreatedDate = DateTime.Now };
                    var p3v2 = new ProductVariant { ProductId = p3.ProductId, VariantName = "Chai 1 Lít", Price = 215000, OriginalPrice = 245000, CostPrice = 148000, SKU = "LIQMO-4T-1L", StockQuantity = 180, ImageUrl = "https://picsum.photos/seed/liquimoly-1l/640/640", MinStockLevel = 20, CreatedDate = DateTime.Now };
                    var p3v3 = new ProductVariant { ProductId = p3.ProductId, VariantName = "Can 4 Lít", Price = 720000, OriginalPrice = 820000, CostPrice = 490000, SKU = "LIQMO-4T-4L", StockQuantity = 60, ImageUrl = "https://picsum.photos/seed/liquimoly-4l/640/640", MinStockLevel = 8, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p3v1, p3v2, p3v3);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p3v1.ProductVariantId, ValueId = val800ml.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p3v2.ProductVariantId, ValueId = val1L.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p3v3.ProductVariantId, ValueId = val4L.ValueId }
                    );
                    context.ProductReviews.AddRange(new List<ProductReview>
                    {
                        new ProductReview { ProductId = p3.ProductId, ProductVariantId = p3v2.ProductVariantId, CustomerId = reviewCustomer2.CustomerId, Rating = 5, Comment = "Nhớt Đức thật sự khác, máy chạy êm và mát hơn nhớt Việt Nam nhiều. Dùng cho NVX 155 rất ổn. Sẽ mua lại.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-12) }
                    });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 4: Lốp Michelin Pilot Street 2
                    // ============================================================
                    var p4 = new Product
                    {
                        ProductName = "Lốp xe Michelin Pilot Street 2",
                        CategoryId = catLop.CategoryId,
                        BrandId = brandMichelin.BrandId,
                        Slug = "lop-xe-michelin-pilot-street-2",
                        Description = "<h4>Michelin Pilot Street 2 — Lốp Đường Phố Hiệu Suất Cao</h4><p>Michelin Pilot Street 2 kế thừa di sản từ công nghệ đường đua MotoGP, mang lại <strong>độ bám đường vượt trội</strong> trên cả đường khô và ướt. Thiết kế tối ưu hóa cho điều kiện giao thông đô thị tốc độ cao.</p><ul><li>Công nghệ XSARA Silica — bám đường ướt cực tốt</li><li>Vân lốp thoát nước hiệu quả</li><li>Phù hợp xe số, xe côn tay và tay ga cỡ nhỏ-trung</li><li>Tuổi thọ cao hơn 20% so với thế hệ trước</li></ul>",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now.AddDays(-18)
                    };
                    context.Products.Add(p4);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p4.ProductId, ImageUrl = "https://picsum.photos/seed/michelin-ps2-main/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p4.ProductId, ImageUrl = "https://picsum.photos/seed/michelin-ps2-tread/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p4.ProductId, ImageUrl = "https://picsum.photos/seed/michelin-ps2-side/640/640", IsPrimary = false, DisplayOrder = 3 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p4.ProductId, SpecName = "Thương hiệu", SpecValue = "Michelin (Pháp)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p4.ProductId, SpecName = "Loại lốp", SpecValue = "Lốp không ruột (Tubeless)", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p4.ProductId, SpecName = "Công nghệ", SpecValue = "XSARA Silica compound", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p4.ProductId, SpecName = "Chỉ số tốc độ", SpecValue = "T (190 km/h)", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p4.ProductId, SpecName = "Xuất xứ", SpecValue = "Thái Lan", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p4.ProductId, TagName = "lốp Michelin" },
                        new ProductTag { ProductId = p4.ProductId, TagName = "lốp không ruột" },
                        new ProductTag { ProductId = p4.ProductId, TagName = "bám đường tốt" }
                    });
                    var p4v1 = new ProductVariant { ProductId = p4.ProductId, VariantName = "70/90-17 (Bánh trước xe số)", Price = 365000, OriginalPrice = null, CostPrice = 250000, SKU = "MICH-PS2-7090-17", StockQuantity = 50, ImageUrl = "https://picsum.photos/seed/michelin-ps2-main/640/640", MinStockLevel = 8, CreatedDate = DateTime.Now };
                    var p4v2 = new ProductVariant { ProductId = p4.ProductId, VariantName = "80/90-17 (Bánh sau xe số)", Price = 425000, OriginalPrice = null, CostPrice = 295000, SKU = "MICH-PS2-8090-17", StockQuantity = 45, ImageUrl = "https://picsum.photos/seed/michelin-ps2-main/640/640", MinStockLevel = 8, CreatedDate = DateTime.Now };
                    var p4v3 = new ProductVariant { ProductId = p4.ProductId, VariantName = "90/80-17 (Côn tay sport)", Price = 480000, OriginalPrice = null, CostPrice = 335000, SKU = "MICH-PS2-9080-17", StockQuantity = 30, ImageUrl = "https://picsum.photos/seed/michelin-ps2-main/640/640", MinStockLevel = 5, CreatedDate = DateTime.Now };
                    var p4v4 = new ProductVariant { ProductId = p4.ProductId, VariantName = "100/80-17 (Côn tay / Winner X)", Price = 535000, OriginalPrice = null, CostPrice = 375000, SKU = "MICH-PS2-10080-17", StockQuantity = 40, ImageUrl = "https://picsum.photos/seed/michelin-ps2-main/640/640", MinStockLevel = 6, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p4v1, p4v2, p4v3, p4v4);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p4v1.ProductVariantId, ValueId = valLop7090.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p4v2.ProductVariantId, ValueId = valLop8090.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p4v3.ProductVariantId, ValueId = valLop9080.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p4v4.ProductVariantId, ValueId = valLop10080.ValueId }
                    );
                    context.ProductReviews.AddRange(new List<ProductReview>
                    {
                        new ProductReview { ProductId = p4.ProductId, ProductVariantId = p4v2.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 5, Comment = "Lốp bám đường cực tốt, trời mưa vẫn ôm cua tự tin. Winner X của mình chạy ngon hẳn từ khi thay lốp này.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-7) },
                        new ProductReview { ProductId = p4.ProductId, ProductVariantId = p4v4.ProductVariantId, CustomerId = reviewCustomer2.CustomerId, Rating = 5, Comment = "Chất lượng Michelin luôn đỉnh, đã dùng 4.000km vẫn còn rất tốt. Giao hàng nhanh, hàng đúng size.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-3) }
                    });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 5: Má phanh Brembo P07
                    // ============================================================
                    var p5 = new Product
                    {
                        ProductName = "Má phanh Brembo P07 xe tay ga / côn tay",
                        CategoryId = catPhanh.CategoryId,
                        BrandId = brandBrembo.BrandId,
                        Slug = "ma-phanh-brembo-p07",
                        Description = "<h4>Brembo P07 — Má Phanh Italy Hạng Nhất Thế Giới</h4><p>Brembo là thương hiệu phanh số 1 thế giới, được trang bị trên các siêu xe Ferrari, Lamborghini và xe đua F1. Dòng <strong>P07 Strada</strong> được chế tác từ hợp chất ma sát đặc biệt, mang lại lực hãm mạnh mẽ và ổn định nhất quán.</p><ul><li>Hợp chất ma sát độc quyền Brembo — lực hãm cực mạnh</li><li>Không ăn mòn đĩa phanh</li><li>Ít bụi bẩn — sạch lazang</li><li>Hoạt động tốt cả nguội lẫn nóng</li></ul>",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now.AddDays(-15)
                    };
                    context.Products.Add(p5);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p5.ProductId, ImageUrl = "https://picsum.photos/seed/brembo-p07-front/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p5.ProductId, ImageUrl = "https://picsum.photos/seed/brembo-p07-rear/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p5.ProductId, ImageUrl = "https://picsum.photos/seed/brembo-p07-detail/640/640", IsPrimary = false, DisplayOrder = 3 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p5.ProductId, SpecName = "Thương hiệu", SpecValue = "Brembo (Italy)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p5.ProductId, SpecName = "Dòng sản phẩm", SpecValue = "Strada (P07)", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p5.ProductId, SpecName = "Chất liệu", SpecValue = "Sintered Metal compound", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p5.ProductId, SpecName = "Áp dụng", SpecValue = "Tay ga & côn tay phân khối vừa", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p5.ProductId, SpecName = "Bảo hành", SpecValue = "12 tháng hoặc 20.000km", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p5.ProductId, TagName = "má phanh Brembo" },
                        new ProductTag { ProductId = p5.ProductId, TagName = "phanh đĩa" },
                        new ProductTag { ProductId = p5.ProductId, TagName = "hàng Italy" }
                    });
                    var p5v1 = new ProductVariant { ProductId = p5.ProductId, VariantName = "Phanh Trước", Price = 350000, OriginalPrice = 420000, CostPrice = 240000, SKU = "BRBO-P07-FRONT", StockQuantity = 60, ImageUrl = "https://picsum.photos/seed/brembo-p07-front/640/640", MinStockLevel = 10, CreatedDate = DateTime.Now };
                    var p5v2 = new ProductVariant { ProductId = p5.ProductId, VariantName = "Phanh Sau", Price = 290000, OriginalPrice = 345000, CostPrice = 195000, SKU = "BRBO-P07-REAR", StockQuantity = 60, ImageUrl = "https://picsum.photos/seed/brembo-p07-rear/640/640", MinStockLevel = 10, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p5v1, p5v2);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p5v1.ProductVariantId, ValueId = valTruoc.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p5v2.ProductVariantId, ValueId = valSau.ValueId }
                    );
                    context.ProductReviews.Add(new ProductReview { ProductId = p5.ProductId, ProductVariantId = p5v1.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 5, Comment = "Má phanh Brembo xịn thật, phanh cứng và dứt khoát hơn hẳn đồ zin. Air Blade của mình phanh tốt hơn nhiều từ khi lắp.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-6) });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 6: Dầu phanh Brembo DOT 4
                    // ============================================================
                    var p6 = new Product
                    {
                        ProductName = "Dầu phanh Brembo DOT 4",
                        CategoryId = catPhanh.CategoryId,
                        BrandId = brandBrembo.BrandId,
                        Slug = "dau-phanh-brembo-dot-4",
                        Description = "<h4>Brembo DOT 4 — Dầu Phanh Tiêu Chuẩn Quốc Tế</h4><p>Dầu phanh Brembo DOT 4 đạt tiêu chuẩn FMVSS No.116, với <strong>điểm sôi khô 230°C và ướt 155°C</strong>, đảm bảo hệ thống phanh hoạt động an toàn và hiệu quả. Phù hợp với tất cả hệ thống phanh đĩa thủy lực.</p><ul><li>Tiêu chuẩn DOT 4 quốc tế</li><li>Điểm sôi khô ≥ 230°C — an toàn khi phanh liên tục</li><li>Tương thích cao su và kim loại trong bơm phanh</li><li>Không ăn mòn xi lanh và ống dẫn dầu</li></ul>",
                        IsActive = true,
                        IsFeatured = false,
                        CreatedDate = DateTime.Now.AddDays(-12)
                    };
                    context.Products.Add(p6);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p6.ProductId, ImageUrl = "https://picsum.photos/seed/brembo-dot4-500ml/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p6.ProductId, ImageUrl = "https://picsum.photos/seed/brembo-dot4-250ml/640/640", IsPrimary = false, DisplayOrder = 2 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p6.ProductId, SpecName = "Tiêu chuẩn", SpecValue = "DOT 4 / FMVSS No.116", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p6.ProductId, SpecName = "Điểm sôi khô", SpecValue = "≥ 230°C", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p6.ProductId, SpecName = "Điểm sôi ướt", SpecValue = "≥ 155°C", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p6.ProductId, SpecName = "Ứng dụng", SpecValue = "Phanh đĩa thủy lực xe máy", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p6.ProductId, SpecName = "Chu kỳ thay", SpecValue = "2 năm hoặc 30.000km", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p6.ProductId, TagName = "dầu phanh" },
                        new ProductTag { ProductId = p6.ProductId, TagName = "DOT 4" },
                        new ProductTag { ProductId = p6.ProductId, TagName = "Brembo" }
                    });
                    var p6v1 = new ProductVariant { ProductId = p6.ProductId, VariantName = "Chai 250ml", Price = 115000, OriginalPrice = null, CostPrice = 75000, SKU = "BRBO-DOT4-250ML", StockQuantity = 80, ImageUrl = "https://picsum.photos/seed/brembo-dot4-250ml/640/640", MinStockLevel = 10, CreatedDate = DateTime.Now };
                    var p6v2 = new ProductVariant { ProductId = p6.ProductId, VariantName = "Chai 500ml", Price = 210000, OriginalPrice = null, CostPrice = 140000, SKU = "BRBO-DOT4-500ML", StockQuantity = 60, ImageUrl = "https://picsum.photos/seed/brembo-dot4-500ml/640/640", MinStockLevel = 8, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p6v1, p6v2);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p6v1.ProductVariantId, ValueId = val250ml.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p6v2.ProductVariantId, ValueId = val500ml.ValueId }
                    );
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 7: Lọc dầu Honda chính hãng
                    // ============================================================
                    var p7 = new Product
                    {
                        ProductName = "Lọc dầu Honda chính hãng",
                        CategoryId = catPhuTung.CategoryId,
                        BrandId = brandHonda.BrandId,
                        Slug = "loc-dau-honda-chinh-hang",
                        Description = "<h4>Lọc Dầu Honda Chính Hãng — Bảo Vệ Động Cơ Toàn Diện</h4><p>Lọc dầu Honda chính hãng được sản xuất theo tiêu chuẩn OEM của nhà máy, với <strong>lõi lọc cao cấp</strong> có khả năng lọc các hạt bụi siêu nhỏ từ 10 micron, giúp dầu nhớt lưu thông sạch và bảo vệ động cơ tối đa.</p><ul><li>Hàng OEM chính hãng Honda</li><li>Lọc hiệu quả hạt bụi từ 10 micron</li><li>Gioăng cao su chịu nhiệt đặc biệt</li><li>Phù hợp nhiều dòng xe Honda</li></ul>",
                        IsActive = true,
                        IsFeatured = false,
                        CreatedDate = DateTime.Now.AddDays(-22)
                    };
                    context.Products.Add(p7);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p7.ProductId, ImageUrl = "https://picsum.photos/seed/honda-locdau-main/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p7.ProductId, ImageUrl = "https://picsum.photos/seed/honda-locdau-box/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p7.ProductId, ImageUrl = "https://picsum.photos/seed/honda-locdau-compare/640/640", IsPrimary = false, DisplayOrder = 3 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p7.ProductId, SpecName = "Xuất xứ", SpecValue = "Honda (Nhật Bản / Việt Nam)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p7.ProductId, SpecName = "Kích thước lọc", SpecValue = "Lọc hạt ≥ 10 micron", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p7.ProductId, SpecName = "Áp suất làm việc", SpecValue = "≤ 7.5 kPa (bypass valve)", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p7.ProductId, SpecName = "Vật liệu lõi", SpecValue = "Giấy lọc cao cấp + lưới thép", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p7.ProductId, SpecName = "Chu kỳ thay", SpecValue = "Mỗi 3.000km", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p7.ProductId, TagName = "lọc dầu Honda" },
                        new ProductTag { ProductId = p7.ProductId, TagName = "phụ tùng chính hãng" },
                        new ProductTag { ProductId = p7.ProductId, TagName = "bảo dưỡng định kỳ" }
                    });
                    var p7v1 = new ProductVariant { ProductId = p7.ProductId, VariantName = "Wave / Dream / Future", Price = 38000, OriginalPrice = null, CostPrice = 22000, SKU = "HON-LOCDAU-WAVE", StockQuantity = 300, ModelId = modelWinnerX?.ModelId, ImageUrl = "https://picsum.photos/seed/honda-locdau-main/640/640", MinStockLevel = 30, CreatedDate = DateTime.Now };
                    var p7v2 = new ProductVariant { ProductId = p7.ProductId, VariantName = "Winner X / CB150R", Price = 45000, OriginalPrice = null, CostPrice = 28000, SKU = "HON-LOCDAU-WNX", StockQuantity = 200, ModelId = modelWinnerX?.ModelId, ImageUrl = "https://picsum.photos/seed/honda-locdau-main/640/640", MinStockLevel = 20, CreatedDate = DateTime.Now };
                    var p7v3 = new ProductVariant { ProductId = p7.ProductId, VariantName = "Air Blade 160 / PCX 160", Price = 52000, OriginalPrice = null, CostPrice = 32000, SKU = "HON-LOCDAU-AB", StockQuantity = 180, ModelId = modelAirBlade?.ModelId, ImageUrl = "https://picsum.photos/seed/honda-locdau-main/640/640", MinStockLevel = 15, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p7v1, p7v2, p7v3);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p7v1.ProductVariantId, ValueId = valWave.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p7v2.ProductVariantId, ValueId = valWinnerX.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p7v3.ProductVariantId, ValueId = valAirBladePCX.ValueId }
                    );
                    context.ProductReviews.Add(new ProductReview { ProductId = p7.ProductId, ProductVariantId = p7v2.ProductVariantId, CustomerId = reviewCustomer2.CustomerId, Rating = 5, Comment = "Lọc dầu xịn, đóng gói kỹ lưỡng. Giá shop rẻ hơn ngoài tiệm, mà hàng chính hãng Honda 100%.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-9) });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 8: Bugi NGK CR7HSA
                    // ============================================================
                    var p8 = new Product
                    {
                        ProductName = "Bugi NGK CR7HSA Standard",
                        CategoryId = catPhuTung.CategoryId,
                        BrandId = brandNGK.BrandId,
                        Slug = "bugi-ngk-cr7hsa-standard",
                        Description = "<h4>NGK CR7HSA — Bugi Tiêu Chuẩn OEM Phổ Thông Nhất</h4><p>NGK CR7HSA là model bugi phổ biến nhất thế giới, được chọn làm bugi <strong>lắp ráp gốc (OEM)</strong> trên hàng chục triệu xe máy Honda và nhiều hãng khác. Điện cực trung tâm niken chịu nhiệt tốt, đánh lửa đều và ổn định.</p><ul><li>Tiêu chuẩn OEM Honda / Yamaha / Suzuki</li><li>Điện cực trung tâm niken tinh khiết</li><li>Chống chịu nhiệt và rung động cao</li><li>Thay mỗi 6.000-8.000km để đảm bảo hiệu suất</li></ul>",
                        IsActive = true,
                        IsFeatured = false,
                        CreatedDate = DateTime.Now.AddDays(-16)
                    };
                    context.Products.Add(p8);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p8.ProductId, ImageUrl = "https://picsum.photos/seed/ngk-cr7hsa-main/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p8.ProductId, ImageUrl = "https://picsum.photos/seed/ngk-cr7hsa-box/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p8.ProductId, ImageUrl = "https://picsum.photos/seed/ngk-cr7hsa-install/640/640", IsPrimary = false, DisplayOrder = 3 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p8.ProductId, SpecName = "Model", SpecValue = "CR7HSA", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p8.ProductId, SpecName = "Ren", SpecValue = "M10 x 1.0", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p8.ProductId, SpecName = "Chiều sâu ren", SpecValue = "19mm", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p8.ProductId, SpecName = "Khe hở bugi", SpecValue = "0.6-0.7mm", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p8.ProductId, SpecName = "Xe phù hợp", SpecValue = "Wave, Dream, Future, Air Blade, NVX, Exciter, FreeGo...", DisplayOrder = 5 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p8.ProductId, TagName = "bugi NGK" },
                        new ProductTag { ProductId = p8.ProductId, TagName = "bugi xe máy" },
                        new ProductTag { ProductId = p8.ProductId, TagName = "bảo dưỡng" }
                    });

                    // Attribute "Số lượng" tạo riêng
                    var attrSoLuong = new ProductAttribute { AttributeName = "Số lượng" };
                    context.ProductAttributes.Add(attrSoLuong);
                    await context.SaveChangesAsync();
                    var val1Cai = new AttributeValue { AttributeId = attrSoLuong.AttributeId, Value = "1 cái" };
                    var valHop4Cai = new AttributeValue { AttributeId = attrSoLuong.AttributeId, Value = "Hộp 4 cái" };
                    context.AttributeValues.AddRange(val1Cai, valHop4Cai);
                    await context.SaveChangesAsync();

                    var p8v1 = new ProductVariant { ProductId = p8.ProductId, VariantName = "1 cái", Price = 32000, OriginalPrice = null, CostPrice = 18000, SKU = "NGK-CR7HSA-1", StockQuantity = 500, ImageUrl = "https://picsum.photos/seed/ngk-cr7hsa-main/640/640", MinStockLevel = 50, CreatedDate = DateTime.Now };
                    var p8v2 = new ProductVariant { ProductId = p8.ProductId, VariantName = "Hộp 4 cái", Price = 118000, OriginalPrice = 128000, CostPrice = 68000, SKU = "NGK-CR7HSA-4", StockQuantity = 150, ImageUrl = "https://picsum.photos/seed/ngk-cr7hsa-box/640/640", MinStockLevel = 15, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p8v1, p8v2);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p8v1.ProductVariantId, ValueId = val1Cai.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p8v2.ProductVariantId, ValueId = valHop4Cai.ValueId }
                    );
                    context.ProductReviews.Add(new ProductReview { ProductId = p8.ProductId, ProductVariantId = p8v1.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 4, Comment = "Bugi NGK chính hãng, máy nổ đều hơn hẳn. Giá rẻ mà chất lượng tốt.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-4) });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 9: Giảm xóc sau YSS G-Plus
                    // ============================================================
                    var p9 = new Product
                    {
                        ProductName = "Giảm xóc sau YSS G-Plus",
                        CategoryId = catGiamXoc.CategoryId,
                        BrandId = brandYSS.BrandId,
                        Slug = "giam-xoc-sau-yss-g-plus",
                        Description = "<h4>YSS G-Plus — Giảm Xóc Thái Lan Phổ Biến Nhất Việt Nam</h4><p>YSS G-Plus là dòng giảm xóc thay thế <strong>best-seller tại Đông Nam Á</strong>, được thiết kế chuyên biệt cho từng dòng xe, mang lại cảm giác lái mềm mại và ổn định hơn hẳn zin theo xe. Chứa khí Nitrogen áp suất cao giúp dầu không bị sủi bọt ở nhiệt độ cao.</p><ul><li>Khí Nitrogen áp suất cao — không sủi bọt</li><li>Điều chỉnh lực căng 5 nấc</li><li>Piston van 46mm — hành trình dài hơn zin</li><li>Bảo hành 12 tháng tại YSS Việt Nam</li></ul>",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now.AddDays(-8)
                    };
                    context.Products.Add(p9);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p9.ProductId, ImageUrl = "https://picsum.photos/seed/yss-gplus-main/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p9.ProductId, ImageUrl = "https://picsum.photos/seed/yss-gplus-side/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p9.ProductId, ImageUrl = "https://picsum.photos/seed/yss-gplus-detail/640/640", IsPrimary = false, DisplayOrder = 3 },
                        new ProductImage { ProductId = p9.ProductId, ImageUrl = "https://picsum.photos/seed/yss-gplus-install/640/640", IsPrimary = false, DisplayOrder = 4 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p9.ProductId, SpecName = "Thương hiệu", SpecValue = "YSS (Thái Lan)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p9.ProductId, SpecName = "Dòng sản phẩm", SpecValue = "G-Plus Series", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p9.ProductId, SpecName = "Đường kính piston", SpecValue = "46mm", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p9.ProductId, SpecName = "Điều chỉnh lực căng", SpecValue = "5 nấc xoay tay", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p9.ProductId, SpecName = "Khí nén", SpecValue = "Nitrogen áp suất cao", DisplayOrder = 5 },
                        new ProductSpecification { ProductId = p9.ProductId, SpecName = "Bảo hành", SpecValue = "12 tháng", DisplayOrder = 6 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p9.ProductId, TagName = "giảm xóc YSS" },
                        new ProductTag { ProductId = p9.ProductId, TagName = "đồ chơi xe" },
                        new ProductTag { ProductId = p9.ProductId, TagName = "nâng cấp xe" }
                    });
                    var p9v1 = new ProductVariant { ProductId = p9.ProductId, VariantName = "Exciter 150/155 (2015-nay)", Price = 1580000, OriginalPrice = 1750000, CostPrice = 1080000, SKU = "YSS-GP-EXC155", StockQuantity = 30, ModelId = modelExciter?.ModelId, ImageUrl = "https://picsum.photos/seed/yss-gplus-main/640/640", MinStockLevel = 5, CreatedDate = DateTime.Now };
                    var p9v2 = new ProductVariant { ProductId = p9.ProductId, VariantName = "Winner X / CB150R (2019-nay)", Price = 1650000, OriginalPrice = 1850000, CostPrice = 1130000, SKU = "YSS-GP-WNX", StockQuantity = 25, ModelId = modelWinnerX?.ModelId, ImageUrl = "https://picsum.photos/seed/yss-gplus-main/640/640", MinStockLevel = 4, CreatedDate = DateTime.Now };
                    var p9v3 = new ProductVariant { ProductId = p9.ProductId, VariantName = "NVX 155 / Aerox (2017-nay)", Price = 1620000, OriginalPrice = 1800000, CostPrice = 1110000, SKU = "YSS-GP-NVX", StockQuantity = 20, ModelId = modelNVX?.ModelId, ImageUrl = "https://picsum.photos/seed/yss-gplus-main/640/640", MinStockLevel = 4, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p9v1, p9v2, p9v3);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p9v1.ProductVariantId, ValueId = valExciter.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p9v2.ProductVariantId, ValueId = valWinnerX.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p9v3.ProductVariantId, ValueId = valNVX.ValueId }
                    );
                    context.ProductReviews.AddRange(new List<ProductReview>
                    {
                        new ProductReview { ProductId = p9.ProductId, ProductVariantId = p9v1.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 5, Comment = "Lắp YSS G-Plus vào Exciter 155 xong thấy khác hẳn! Xe êm hơn, ổn định hơn khi vào cua. Giá tiền hợp lý so với chất lượng.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-5) },
                        new ProductReview { ProductId = p9.ProductId, ProductVariantId = p9v2.ProductVariantId, CustomerId = reviewCustomer2.CustomerId, Rating = 5, Comment = "Winner X đi đường xóc mà vẫn ổn sau khi lắp YSS. Hàng đúng xe, lắp vào ok ngay không cần chỉnh.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-2) }
                    });
                    await context.SaveChangesAsync();

                    // ============================================================
                    // SẢN PHẨM 10: Giảm xóc Ohlins S36E
                    // ============================================================
                    var p10 = new Product
                    {
                        ProductName = "Giảm xóc Ohlins S36E",
                        CategoryId = catGiamXoc.CategoryId,
                        BrandId = brandOhlins.BrandId,
                        Slug = "giam-xoc-ohlins-s36e",
                        Description = "<h4>Ohlins S36E — Đỉnh Cao Giảm Xóc Thụy Điển</h4><p>Ohlins là thương hiệu giảm xóc <strong>huyền thoại từ Thụy Điển</strong>, được trang bị trên xe đua MotoGP, World Superbike và các siêu xe đường phố. Dòng S36E được tối ưu hóa đặc biệt cho các dòng xe Đông Nam Á, mang lại trải nghiệm lái hoàn toàn khác biệt.</p><ul><li>Van piston 36mm độc quyền Ohlins</li><li>Điều chỉnh preload vô cấp (stepless)</li><li>Dầu giảm xóc Ohlins Race Oil đặc chế</li><li>Có thể đại tu — dùng bền cả chục năm</li><li>Bảo hành 2 năm chính hãng</li></ul>",
                        IsActive = true,
                        IsFeatured = true,
                        CreatedDate = DateTime.Now.AddDays(-5)
                    };
                    context.Products.Add(p10);
                    await context.SaveChangesAsync();

                    context.ProductImages.AddRange(new List<ProductImage>
                    {
                        new ProductImage { ProductId = p10.ProductId, ImageUrl = "https://picsum.photos/seed/ohlins-s36e-main/640/640", IsPrimary = true, DisplayOrder = 1 },
                        new ProductImage { ProductId = p10.ProductId, ImageUrl = "https://picsum.photos/seed/ohlins-s36e-detail1/640/640", IsPrimary = false, DisplayOrder = 2 },
                        new ProductImage { ProductId = p10.ProductId, ImageUrl = "https://picsum.photos/seed/ohlins-s36e-detail2/640/640", IsPrimary = false, DisplayOrder = 3 },
                        new ProductImage { ProductId = p10.ProductId, ImageUrl = "https://picsum.photos/seed/ohlins-s36e-pack/640/640", IsPrimary = false, DisplayOrder = 4 }
                    });
                    context.ProductSpecifications.AddRange(new List<ProductSpecification>
                    {
                        new ProductSpecification { ProductId = p10.ProductId, SpecName = "Thương hiệu", SpecValue = "Öhlins (Thụy Điển)", DisplayOrder = 1 },
                        new ProductSpecification { ProductId = p10.ProductId, SpecName = "Đường kính piston", SpecValue = "36mm", DisplayOrder = 2 },
                        new ProductSpecification { ProductId = p10.ProductId, SpecName = "Điều chỉnh preload", SpecValue = "Vô cấp (stepless)", DisplayOrder = 3 },
                        new ProductSpecification { ProductId = p10.ProductId, SpecName = "Dầu giảm xóc", SpecValue = "Ohlins Race Oil #5", DisplayOrder = 4 },
                        new ProductSpecification { ProductId = p10.ProductId, SpecName = "Có thể đại tu", SpecValue = "Có (rebuildable)", DisplayOrder = 5 },
                        new ProductSpecification { ProductId = p10.ProductId, SpecName = "Bảo hành", SpecValue = "2 năm chính hãng", DisplayOrder = 6 }
                    });
                    context.ProductTags.AddRange(new List<ProductTag>
                    {
                        new ProductTag { ProductId = p10.ProductId, TagName = "giảm xóc Ohlins" },
                        new ProductTag { ProductId = p10.ProductId, TagName = "hàng Thụy Điển" },
                        new ProductTag { ProductId = p10.ProductId, TagName = "cao cấp" }
                    });
                    var p10v1 = new ProductVariant { ProductId = p10.ProductId, VariantName = "Exciter 150/155 (2015-nay)", Price = 5800000, OriginalPrice = 6500000, CostPrice = 4200000, SKU = "OHL-S36E-EXC155", StockQuantity = 10, ModelId = modelExciter?.ModelId, ImageUrl = "https://picsum.photos/seed/ohlins-s36e-main/640/640", MinStockLevel = 2, CreatedDate = DateTime.Now };
                    var p10v2 = new ProductVariant { ProductId = p10.ProductId, VariantName = "Winner X / CB150R (2019-nay)", Price = 5950000, OriginalPrice = 6700000, CostPrice = 4300000, SKU = "OHL-S36E-WNX", StockQuantity = 8, ModelId = modelWinnerX?.ModelId, ImageUrl = "https://picsum.photos/seed/ohlins-s36e-main/640/640", MinStockLevel = 2, CreatedDate = DateTime.Now };
                    context.ProductVariants.AddRange(p10v1, p10v2);
                    await context.SaveChangesAsync();

                    context.ProductVariantAttributeValues.AddRange(
                        new ProductVariantAttributeValue { ProductVariantId = p10v1.ProductVariantId, ValueId = valExciter.ValueId },
                        new ProductVariantAttributeValue { ProductVariantId = p10v2.ProductVariantId, ValueId = valWinnerX.ValueId }
                    );
                    context.ProductReviews.Add(new ProductReview { ProductId = p10.ProductId, ProductVariantId = p10v1.ProductVariantId, CustomerId = reviewCustomer.CustomerId, Rating = 5, Comment = "Ohlins thật sự khác đẳng cấp, xe cứng và chính xác hơn hẳn. Đáng từng đồng tiền bỏ ra. Giao hàng nhanh, hộp seal nguyên vẹn.", Status = "Approved", CreatedDate = DateTime.Now.AddDays(-1) });
                    await context.SaveChangesAsync();
                }

                // 10. SEED REVIEWS (nếu có products nhưng chưa có reviews — trường hợp db cũ)
                // (Đã seed reviews ngay trong phần sản phẩm ở trên)
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERR] Seeding Error: {ex.Message}\n{ex.StackTrace}");
            }
        }
    }
}
