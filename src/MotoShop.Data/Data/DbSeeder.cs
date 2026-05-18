using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Enums;
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
                        Address = "123 ÄÆ°á»ng Sá»‘ 1, Quáº­n 1, TP.HCM",
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
                        new Category { CategoryName = "Dáº§u nhá»›t & BĂ´i trÆ¡n",  Slug = "dau-nhot-boi-tron",  Icon = "bxs-droplet",     IsActive = true },
                        new Category { CategoryName = "Lá»‘p xe & VĂ nh",         Slug = "lop-xe-vanh",        Icon = "bx-rotate-right",  IsActive = true },
                        new Category { CategoryName = "Há»‡ thá»‘ng phanh",        Slug = "he-thong-phanh",     Icon = "bxs-stop-circle",  IsActive = true },
                        new Category { CategoryName = "Giáº£m xĂ³c",              Slug = "giam-xoc",           Icon = "bx-equalizer",     IsActive = true },
                        new Category { CategoryName = "áº®c quy & Äiá»‡n",         Slug = "ac-quy-dien",        Icon = "bx-bolt-circle",   IsActive = true },
                        new Category { CategoryName = "MÅ© & Báº£o há»™",           Slug = "mu-bao-ho",          Icon = "bx-hard-hat",      IsActive = true },
                        new Category { CategoryName = "Phá»¥ tĂ¹ng & Phá»¥ kiá»‡n",   Slug = "phu-tung-phu-kien",  Icon = "bx-cog",           IsActive = true }
                    });
                    await context.SaveChangesAsync();
                }

                // 6. SEED BRANDS â€” thĂªm tá»«ng brand náº¿u chÆ°a cĂ³ (upsert-style)
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
                        new ShippingMethod { Name = "Hỏa tốc 2H",     Cost = 50000, EstimatedDays = "2 giờ",    IsActive = true },
                        new ShippingMethod { Name = "Tiêu chuẩn",     Cost = 15000, EstimatedDays = "4-5 ngày", IsActive = true }
                    });
                    await context.SaveChangesAsync();
                }

                // 8. SEED SERVICE CATEGORIES + SERVICES + COMBOS
                // Chỉ seed khi chưa có danh mục. Không xóa dữ liệu dịch vụ/booking hiện có trong seeder.
                if (!context.ServiceCategories.Any())
                {
                    // --- Danh má»¥c dá»‹ch vá»¥ ---
                    var scBaoDuong = new ServiceCategory { CategoryName = "Báº£o dÆ°á»¡ng", Slug = "bao-duong", Icon = "bx-wrench", DisplayOrder = 1 };
                    var scRuaXe   = new ServiceCategory { CategoryName = "Rá»­a xe",    Slug = "rua-xe",    Icon = "bx-droplet",    DisplayOrder = 2 };
                    var scCuuHo   = new ServiceCategory { CategoryName = "Cá»©u há»™",    Slug = "cuu-ho",    Icon = "bx-car-crash",  DisplayOrder = 3 };
                    var scDoXe    = new ServiceCategory { CategoryName = "Äá»™ xe",     Slug = "do-xe",     Icon = "bx-customize",  DisplayOrder = 4 };
                    var scPhuTung = new ServiceCategory { CategoryName = "Phá»¥ tĂ¹ng",  Slug = "phu-tung",  Icon = "bx-cog",        DisplayOrder = 5 };
                    var scKiemTra = new ServiceCategory { CategoryName = "Kiá»ƒm tra",  Slug = "kiem-tra",  Icon = "bx-search-alt", DisplayOrder = 6 };
                    context.ServiceCategories.AddRange(scBaoDuong, scRuaXe, scCuuHo, scDoXe, scPhuTung, scKiemTra);
                    await context.SaveChangesAsync();

                    // â”€â”€ Báº¢O DÆ¯á» NG â”€â”€
                    var sv01 = new Service { ServiceName = "Thay nhá»›t mĂ¡y + lá»c dáº§u", Slug = "thay-nhot-may-loc-dau", CategoryId = scBaoDuong.CategoryId, Price = 20000, OriginalPrice = null, Duration = 15, WarrantyDays = 90, IsPopular = true, Tags = "nhanh,chinh-hang,bao-hanh", ShortDescription = "Dáº§u nhá»›t chĂ­nh hĂ£ng, thay lá»c dáº§u má»›i, kiá»ƒm tra má»©c dáº§u toĂ n diá»‡n.", Description = "Sá»­ dá»¥ng dáº§u nhá»›t chĂ­nh hĂ£ng Motul, Castrol hoáº·c theo yĂªu cáº§u khĂ¡ch hĂ ng. Thay lá»c dáº§u má»›i, kiá»ƒm tra má»©c dáº§u, vá»‡ sinh náº¯p Ä‘á»• dáº§u. Báº£o hĂ nh 3 thĂ¡ng hoáº·c 3.000km.", TotalBookings = 342, AverageRating = 4.9m, TotalReviews = 128, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };
                    var sv02 = new Service { ServiceName = "Báº£o dÆ°á»¡ng Ä‘á»‹nh ká»³ 5.000km", Slug = "bao-duong-dinh-ky-5000km", CategoryId = scBaoDuong.CategoryId, Price = 280000, OriginalPrice = 350000, Duration = 45, WarrantyDays = 30, IsPopular = true, Tags = "toan-dien,dinh-ky,bao-hanh", ShortDescription = "Thay nhá»›t, lá»c giĂ³, bugi, kiá»ƒm tra phanh, xĂ­ch nhĂ´ng toĂ n diá»‡n.", Description = "GĂ³i báº£o dÆ°á»¡ng Ä‘á»‹nh ká»³ 5.000km bao gá»“m: thay dáº§u nhá»›t + lá»c dáº§u, vá»‡ sinh lá»c giĂ³, thay bugi, kiá»ƒm tra vĂ  hiá»‡u chá»‰nh phanh trÆ°á»›c/sau, kiá»ƒm tra xĂ­ch nhĂ´ng, bÆ¡m lá»‘p Ä‘Ăºng Ă¡p suáº¥t, kiá»ƒm tra Ä‘Ă¨n vĂ  Ä‘iá»‡n. PhĂ¹ há»£p cho táº¥t cáº£ dĂ²ng xe tay ga vĂ  cĂ´n tay.", TotalBookings = 215, AverageRating = 4.8m, TotalReviews = 89, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv03 = new Service { ServiceName = "Thay lá»‘p xe + cĂ¢n báº±ng bĂ¡nh", Slug = "thay-lop-xe-can-bang-banh", CategoryId = scBaoDuong.CategoryId, Price = 50000, OriginalPrice = null, Duration = 20, WarrantyDays = 30, IsPopular = false, Tags = "lop-xe,michelin,dunlop", ShortDescription = "Thay lá»‘p Michelin, Dunlop, IRC chĂ­nh hĂ£ng. CĂ¢n báº±ng vĂ  chá»‰nh Ă¡p suáº¥t chuáº©n.", Description = "Thay lá»‘p xe chĂ­nh hĂ£ng cĂ¡c thÆ°Æ¡ng hiá»‡u: Michelin, Dunlop, IRC, Maxxis. Bao gá»“m cĂ´ng thay, cĂ¢n báº±ng bĂ¡nh, kiá»ƒm tra vĂ  bÆ¡m Ă¡p suáº¥t chuáº©n theo khuyáº¿n cĂ¡o nhĂ  sáº£n xuáº¥t. Há»— trá»£ táº¥t cáº£ kĂ­ch thÆ°á»›c lá»‘p phá»• biáº¿n táº¡i Viá»‡t Nam.", TotalBookings = 178, AverageRating = 4.7m, TotalReviews = 64, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800", IsActive = true };
                    var sv04 = new Service { ServiceName = "Sá»­a phanh + thay mĂ¡ phanh", Slug = "sua-phanh-thay-ma-phanh", CategoryId = scBaoDuong.CategoryId, Price = 80000, OriginalPrice = null, Duration = 30, WarrantyDays = 30, IsPopular = false, Tags = "phanh,an-toan,brembo", ShortDescription = "Kiá»ƒm tra, hiá»‡u chá»‰nh phanh trÆ°á»›c/sau. Thay mĂ¡ phanh Brembo chĂ­nh hĂ£ng náº¿u cáº§n.", Description = "Kiá»ƒm tra toĂ n bá»™ há»‡ thá»‘ng phanh: mĂ¡ phanh, Ä‘Ä©a phanh, dáº§u phanh, dĂ¢y phanh. Hiá»‡u chá»‰nh Ä‘á»™ Äƒn phanh, thay mĂ¡ phanh Brembo náº¿u mĂ²n dÆ°á»›i má»©c an toĂ n. GiĂ¡ chÆ°a bao gá»“m phá»¥ tĂ¹ng thay tháº¿.", TotalBookings = 143, AverageRating = 4.9m, TotalReviews = 52, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv05 = new Service { ServiceName = "Thay bugi + vá»‡ sinh kim phun", Slug = "thay-bugi-ve-sinh-kim-phun", CategoryId = scBaoDuong.CategoryId, Price = 45000, OriginalPrice = null, Duration = 25, WarrantyDays = 30, IsPopular = false, Tags = "bugi,ngk,kim-phun", ShortDescription = "Thay bugi NGK chĂ­nh hĂ£ng, vá»‡ sinh kim phun xÄƒng, cĂ¢n chá»‰nh há»—n há»£p nhiĂªn liá»‡u.", Description = "Thay bugi NGK Standard hoáº·c Iridium theo yĂªu cáº§u. Vá»‡ sinh kim phun xÄƒng báº±ng mĂ¡y siĂªu Ă¢m chuyĂªn dá»¥ng, cĂ¢n chá»‰nh há»—n há»£p nhiĂªn liá»‡u, kiá»ƒm tra cáº£m biáº¿n. GiĂºp xe tiáº¿t kiá»‡m xÄƒng vĂ  tÄƒng hiá»‡u suáº¥t Ä‘á»™ng cÆ¡.", TotalBookings = 98, AverageRating = 4.6m, TotalReviews = 38, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };

                    // â”€â”€ Rá»¬A XE â”€â”€
                    var sv06 = new Service { ServiceName = "Rá»­a xe cÆ¡ báº£n", Slug = "rua-xe-co-ban", CategoryId = scRuaXe.CategoryId, Price = 30000, OriginalPrice = null, Duration = 20, WarrantyDays = 0, IsPopular = true, Tags = "rua-xe,sach-se,nhanh", ShortDescription = "Rá»­a sáº¡ch toĂ n bá»™ xe báº±ng mĂ¡y xá»‹t Ă¡p lá»±c cao, lau khĂ´, xá»‹t bĂ³ng nhá»±a.", Description = "Rá»­a xe báº±ng mĂ¡y xá»‹t Ă¡p lá»±c cao Karcher chuyĂªn dá»¥ng. XĂ  phĂ²ng xe mĂ¡y chuyĂªn dá»¥ng, khĂ´ng Äƒn mĂ²n sÆ¡n. Lau khĂ´ báº±ng khÄƒn microfiber, xá»‹t bĂ³ng nhá»±a Ä‘en cho cĂ¡c chi tiáº¿t nhá»±a.", TotalBookings = 512, AverageRating = 4.7m, TotalReviews = 201, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800", IsActive = true };
                    var sv07 = new Service { ServiceName = "Rá»­a xe cao cáº¥p + Ä‘Ă¡nh bĂ³ng", Slug = "rua-xe-cao-cap-danh-bong", CategoryId = scRuaXe.CategoryId, Price = 80000, OriginalPrice = 100000, Duration = 45, WarrantyDays = 0, IsPopular = false, Tags = "danh-bong,cao-cap,bong-dep", ShortDescription = "Rá»­a sáº¡ch, Ä‘Ă¡nh bĂ³ng toĂ n thĂ¢n xe, xá»­ lĂ½ váº¿t xÆ°á»›c nháº¹, báº£o vá»‡ sÆ¡n.", Description = "Rá»­a xe Ă¡p lá»±c cao, Ä‘Ă¡nh bĂ³ng toĂ n thĂ¢n báº±ng mĂ¡y polisher chuyĂªn nghiá»‡p. Xá»­ lĂ½ váº¿t xÆ°á»›c nháº¹, phá»¥c há»“i Ä‘á»™ bĂ³ng sÆ¡n, phá»§ nano báº£o vá»‡ sÆ¡n 3 thĂ¡ng. Káº¿t quáº£: xe sĂ¡ng bĂ³ng nhÆ° má»›i xuáº¥t xÆ°á»Ÿng.", TotalBookings = 87, AverageRating = 4.8m, TotalReviews = 34, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };
                    var sv08 = new Service { ServiceName = "Vá»‡ sinh ná»“i xe ga", Slug = "ve-sinh-noi-xe-ga", CategoryId = scRuaXe.CategoryId, Price = 150000, OriginalPrice = null, Duration = 30, WarrantyDays = 7, IsPopular = true, Tags = "noi-xe-ga,ve-sinh,boc-hon", ShortDescription = "LĂ m sáº¡ch bá»™ ná»“i CVT giĂºp xe cháº¡y bá»‘c hÆ¡n, tiáº¿t kiá»‡m nhiĂªn liá»‡u.", Description = "ThĂ¡o vĂ  vá»‡ sinh toĂ n bá»™ bá»™ ná»“i CVT: puly trÆ°á»›c/sau, dĂ¢y curoa, bi nhĂ´ng. LĂ m sáº¡ch bá»¥i báº©n, kiá»ƒm tra Ä‘á»™ mĂ²n dĂ¢y curoa vĂ  bi nhĂ´ng, tÆ° váº¥n thay tháº¿ náº¿u cáº§n. Xe cháº¡y bá»‘c hÆ¡n 15-20% sau khi vá»‡ sinh.", TotalBookings = 234, AverageRating = 4.9m, TotalReviews = 98, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv09 = new Service { ServiceName = "Vá»‡ sinh bĂ¬nh xÄƒng + thĂ´ng nhiĂªn liá»‡u", Slug = "ve-sinh-binh-xang-thong-nhien-lieu", CategoryId = scRuaXe.CategoryId, Price = 120000, OriginalPrice = null, Duration = 40, WarrantyDays = 14, IsPopular = false, Tags = "binh-xang,thong-nhien-lieu,xe-cu", ShortDescription = "Vá»‡ sinh bĂ¬nh xÄƒng, lá»c xÄƒng, thĂ´ng Ä‘Æ°á»ng dáº«n nhiĂªn liá»‡u. PhĂ¹ há»£p xe cÅ© hay ngháº¹t xÄƒng.", Description = "ThĂ¡o vá»‡ sinh bĂ¬nh xÄƒng báº±ng dung dá»‹ch chuyĂªn dá»¥ng, thay lá»c xÄƒng má»›i, thĂ´ng vĂ  kiá»ƒm tra toĂ n bá»™ Ä‘Æ°á»ng dáº«n nhiĂªn liá»‡u. PhĂ¹ há»£p cho xe bá»‹ ngháº¹t xÄƒng, cháº¡y khĂ´ng Ä‘á»u, hay táº¯t mĂ¡y Ä‘á»™t ngá»™t.", TotalBookings = 76, AverageRating = 4.7m, TotalReviews = 29, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv10 = new Service { ServiceName = "Phá»§ nano báº£o vá»‡ xe", Slug = "phu-nano-bao-ve-xe", CategoryId = scRuaXe.CategoryId, Price = 200000, OriginalPrice = 250000, Duration = 60, WarrantyDays = 90, IsPopular = false, Tags = "nano,bao-ve-son,chong-xuoc", ShortDescription = "Phá»§ lá»›p nano ceramic báº£o vá»‡ sÆ¡n xe khá»i bá»¥i báº©n, UV vĂ  xÆ°á»›c nháº¹ trong 3 thĂ¡ng.", Description = "LĂ m sáº¡ch bá» máº·t, clay bar loáº¡i bá» táº¡p cháº¥t, phá»§ lá»›p nano ceramic chuyĂªn dá»¥ng. Báº£o vá»‡ sÆ¡n xe khá»i tia UV, bá»¥i báº©n, mÆ°a axit, váº¿t xÆ°á»›c nháº¹. Xe dá»… rá»­a hÆ¡n, bĂ³ng Ä‘áº¹p bá»n 3-6 thĂ¡ng.", TotalBookings = 45, AverageRating = 4.8m, TotalReviews = 18, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };

                    // â”€â”€ Cá»¨U Há»˜ â”€â”€
                    var sv11 = new Service { ServiceName = "Cá»©u há»™ xe cháº¿t mĂ¡y táº¡i chá»—", Slug = "cuu-ho-xe-chet-may-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 150000, OriginalPrice = null, Duration = 30, WarrantyDays = 0, IsPopular = true, Tags = "cuu-ho,khan-cap,24-7", ShortDescription = "Ká»¹ thuáº­t viĂªn Ä‘áº¿n táº­n nÆ¡i xá»­ lĂ½ xe cháº¿t mĂ¡y trong vĂ²ng 30 phĂºt.", Description = "Dá»‹ch vá»¥ cá»©u há»™ kháº©n cáº¥p 24/7. Ká»¹ thuáº­t viĂªn cĂ³ kinh nghiá»‡m sáº½ Ä‘áº¿n táº­n nÆ¡i trong vĂ²ng 30 phĂºt (ná»™i thĂ nh). Xá»­ lĂ½ cĂ¡c sá»± cá»‘: háº¿t xÄƒng, há»ng Ä‘iá»‡n, cháº¿t áº¯c quy, há»ng khá»Ÿi Ä‘á»™ng. PhĂ­ di chuyá»ƒn tĂ­nh theo km náº¿u ngoĂ i ná»™i thĂ nh.", TotalBookings = 189, AverageRating = 4.9m, TotalReviews = 76, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv12 = new Service { ServiceName = "Thay áº¯c quy táº¡i chá»—", Slug = "thay-ac-quy-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 50000, OriginalPrice = null, Duration = 15, WarrantyDays = 365, IsPopular = false, Tags = "ac-quy,thay-tai-cho,gs-yuasa", ShortDescription = "Mang áº¯c quy má»›i Ä‘áº¿n táº­n nÆ¡i, thay vĂ  test ngay táº¡i chá»—. Báº£o hĂ nh 12 thĂ¡ng.", Description = "Ká»¹ thuáº­t viĂªn mang áº¯c quy GS, Yuasa, Motobatt chĂ­nh hĂ£ng Ä‘áº¿n táº­n nÆ¡i thay. Test mĂ¡y phĂ¡t Ä‘iá»‡n, kiá»ƒm tra há»‡ thá»‘ng Ä‘iá»‡n tá»•ng thá»ƒ. Báº£o hĂ nh áº¯c quy 12 thĂ¡ng, Ä‘á»•i má»›i náº¿u lá»—i.", TotalBookings = 134, AverageRating = 4.8m, TotalReviews = 54, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv13 = new Service { ServiceName = "VĂ¡ lá»‘p kháº©n cáº¥p táº¡i chá»—", Slug = "va-lop-khan-cap-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 80000, OriginalPrice = null, Duration = 20, WarrantyDays = 30, IsPopular = true, Tags = "va-lop,kep-dinh,nhanh", ShortDescription = "VĂ¡ lá»‘p khĂ´ng ruá»™t (tubeless) táº¡i chá»— báº±ng dĂ¢y vĂ¡ chuyĂªn nghiá»‡p. Nhanh chĂ³ng vĂ  bá»n.", Description = "VĂ¡ lá»‘p tubeless báº±ng dĂ¢y vĂ¡ Moto chuyĂªn nghiá»‡p hoáº·c vĂ¡ nguá»™i tĂ¹y má»©c Ä‘á»™ há»ng. BÆ¡m láº¡i Ă¡p suáº¥t chuáº©n, kiá»ƒm tra rĂ² rá»‰. KhĂ´ng Ă¡p dá»¥ng cho lá»‘p há»ng quĂ¡ 3 lá»— hoáº·c há»ng thĂ nh lá»‘p.", TotalBookings = 267, AverageRating = 4.7m, TotalReviews = 103, ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800", IsActive = true };
                    var sv14 = new Service { ServiceName = "KĂ©o xe vá» xÆ°á»Ÿng", Slug = "keo-xe-ve-xuong", CategoryId = scCuuHo.CategoryId, Price = 200000, OriginalPrice = null, Duration = 60, WarrantyDays = 0, IsPopular = false, Tags = "keo-xe,tai-nan,hu-nang", ShortDescription = "KĂ©o xe vá» xÆ°á»Ÿng khi há»ng náº·ng khĂ´ng sá»­a Ä‘Æ°á»£c táº¡i chá»—. PhĂ­ tĂ­nh theo km.", Description = "Dá»‹ch vá»¥ kĂ©o xe báº±ng xe táº£i chuyĂªn dá»¥ng. PhĂ­ cÆ¡ báº£n 200.000â‚« trong bĂ¡n kĂ­nh 5km, +20.000â‚«/km tiáº¿p theo. Äá»™i ngÅ© chuyĂªn nghiá»‡p, báº£o Ä‘áº£m xe nguyĂªn váº¹n trong quĂ¡ trĂ¬nh váº­n chuyá»ƒn. Há»— trá»£ 24/7.", TotalBookings = 78, AverageRating = 4.6m, TotalReviews = 31, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };
                    var sv15 = new Service { ServiceName = "Sáº¡c áº¯c quy táº¡i chá»—", Slug = "sac-ac-quy-tai-cho", CategoryId = scCuuHo.CategoryId, Price = 30000, OriginalPrice = null, Duration = 45, WarrantyDays = 0, IsPopular = false, Tags = "sac-ac-quy,het-dien,nhanh", ShortDescription = "Sáº¡c áº¯c quy nhanh táº¡i chá»— báº±ng mĂ¡y sáº¡c thĂ´ng minh. Xong trong 30-45 phĂºt.", Description = "Sáº¡c áº¯c quy báº±ng mĂ¡y sáº¡c CTEK hoáº·c NOCO chuyĂªn nghiá»‡p. Phá»¥c há»“i áº¯c quy bá»‹ háº¿t hoĂ n toĂ n, kiá»ƒm tra sá»©c khá»e áº¯c quy sau khi sáº¡c, tÆ° váº¥n cĂ³ nĂªn thay má»›i khĂ´ng.", TotalBookings = 156, AverageRating = 4.8m, TotalReviews = 58, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };

                    // â”€â”€ Äá»˜ XE â”€â”€
                    var sv16 = new Service { ServiceName = "Láº¯p Ä‘Ă¨n LED + Ä‘Ă¨n trá»£ sĂ¡ng", Slug = "lap-den-led-den-tro-sang", CategoryId = scDoXe.CategoryId, Price = 150000, OriginalPrice = 180000, Duration = 60, WarrantyDays = 180, IsPopular = true, Tags = "den-led,do-xe,sang-hon", ShortDescription = "Láº¯p Ä‘Ă¨n LED pha sĂ¡ng hÆ¡n, Ä‘Ă¨n trá»£ sĂ¡ng 30W-50W. Báº£o hĂ nh 6 thĂ¡ng.", Description = "Thay tháº¿ Ä‘Ă¨n pha halogen sang LED cao cáº¥p sĂ¡ng gáº¥p 3 láº§n. Láº¯p thĂªm Ä‘Ă¨n trá»£ sĂ¡ng Yamaha, Osram 30-50W cho xe phÆ°á»£t vĂ  xe cĂ´n. Äi dĂ¢y Ä‘iá»‡n gá»n gĂ ng, chá»‘ng nÆ°á»›c IP67. Báº£o hĂ nh 6 thĂ¡ng.", TotalBookings = 145, AverageRating = 4.8m, TotalReviews = 56, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv17 = new Service { ServiceName = "Láº¯p giáº£m xĂ³c háº­u Ohlins/YSS", Slug = "lap-giam-xoc-hau-ohlins-yss", CategoryId = scDoXe.CategoryId, Price = 200000, OriginalPrice = null, Duration = 45, WarrantyDays = 30, IsPopular = false, Tags = "giam-xoc,ohlins,yss,do-xe", ShortDescription = "ThĂ¡o láº¯p giáº£m xĂ³c háº­u cao cáº¥p Ohlins, YSS. CĂ¢n chá»‰nh chiá»u cao vĂ  Ä‘á»™ cá»©ng.", Description = "ThĂ¡o giáº£m xĂ³c háº­u cÅ©, láº¯p giáº£m xĂ³c Ohlins S36E hoáº·c YSS G-Plus theo yĂªu cáº§u. CĂ¢n chá»‰nh chiá»u cao xe, Ä‘iá»u chá»‰nh Ä‘á»™ cá»©ng phĂ¹ há»£p cĂ¢n náº·ng ngÆ°á»i lĂ¡i. Kiá»ƒm tra gĂ³c lĂ¡i sau khi láº¯p. GiĂ¡ chÆ°a bao gá»“m giáº£m xĂ³c.", TotalBookings = 89, AverageRating = 4.9m, TotalReviews = 34, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv18 = new Service { ServiceName = "Láº¯p á»‘p ná»™i tháº¥t + decal", Slug = "lap-op-noi-that-decal", CategoryId = scDoXe.CategoryId, Price = 100000, OriginalPrice = null, Duration = 60, WarrantyDays = 90, IsPopular = false, Tags = "op-xe,decal,do-ngoai-that", ShortDescription = "Láº¯p á»‘p nhá»±a ABS cao cáº¥p, dĂ¡n decal tem xe theo yĂªu cáº§u. 100+ máº«u cĂ³ sáºµn.", Description = "Láº¯p á»‘p ná»™i tháº¥t, á»‘p bĂ¬nh xÄƒng, á»‘p Ä‘uĂ´i xe báº±ng nhá»±a ABS cao cáº¥p khĂ´ng phai mĂ u. DĂ¡n decal tem xe theo máº«u cĂ³ sáºµn hoáº·c thiáº¿t káº¿ theo yĂªu cáº§u. Báº£o hĂ nh khĂ´ng bong trĂ³c 3 thĂ¡ng.", TotalBookings = 67, AverageRating = 4.7m, TotalReviews = 25, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };
                    var sv19 = new Service { ServiceName = "Láº¯p há»‡ thá»‘ng Ă¢m thanh Bluetooth", Slug = "lap-he-thong-am-thanh-bluetooth", CategoryId = scDoXe.CategoryId, Price = 300000, OriginalPrice = 380000, Duration = 90, WarrantyDays = 180, IsPopular = false, Tags = "am-thanh,bluetooth,loa-xe", ShortDescription = "Láº¯p loa Bluetooth khĂ´ng dĂ¢y, káº¿t ná»‘i Ä‘iá»‡n thoáº¡i, nghe nháº¡c khi lĂ¡i xe.", Description = "Láº¯p há»‡ thá»‘ng loa Bluetooth chá»‘ng nÆ°á»›c IPX5 lĂªn ghi Ä‘Ă´ng hoáº·c yĂªn xe. Káº¿t ná»‘i Ä‘iá»‡n thoáº¡i qua Bluetooth, Ă¢m lÆ°á»£ng lá»›n rĂµ rĂ ng ngay cáº£ khi cháº¡y tá»‘c Ä‘á»™ cao. TĂ­ch há»£p nĂºt Ä‘iá»u khiá»ƒn trĂªn tay lĂ¡i. Báº£o hĂ nh 6 thĂ¡ng.", TotalBookings = 43, AverageRating = 4.6m, TotalReviews = 17, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv20 = new Service { ServiceName = "Láº¯p khĂ³a chá»‘ng trá»™m thĂ´ng minh", Slug = "lap-khoa-chong-trom-thong-minh", CategoryId = scDoXe.CategoryId, Price = 180000, OriginalPrice = null, Duration = 60, WarrantyDays = 365, IsPopular = true, Tags = "khoa-chong-trom,bao-mat,gps", ShortDescription = "Láº¯p khĂ³a chá»‘ng trá»™m cáº£m biáº¿n rung + cáº£nh bĂ¡o Ä‘iá»‡n thoáº¡i. Báº£o hĂ nh 12 thĂ¡ng.", Description = "Láº¯p há»‡ thá»‘ng chá»‘ng trá»™m thĂ´ng minh: cáº£m biáº¿n rung, cĂ²i cáº£nh bĂ¡o 120dB, gá»­i thĂ´ng bĂ¡o vá» Ä‘iá»‡n thoáº¡i qua app. Má»™t sá»‘ model cĂ³ tĂ­ch há»£p GPS theo dĂµi vá»‹ trĂ­ xe realtime. GiĂ¡ chÆ°a bao gá»“m thiáº¿t bá»‹.", TotalBookings = 112, AverageRating = 4.8m, TotalReviews = 44, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };

                    // â”€â”€ PHá»¤ TĂ™NG â”€â”€
                    var sv21 = new Service { ServiceName = "Thay xĂ­ch nhĂ´ng Ä‘Ä©a", Slug = "thay-xich-nhong-dia", CategoryId = scPhuTung.CategoryId, Price = 60000, OriginalPrice = null, Duration = 30, WarrantyDays = 90, IsPopular = true, Tags = "xich-nhong,cong-thay,chinh-hang", ShortDescription = "CĂ´ng thay xĂ­ch nhĂ´ng Ä‘Ä©a chĂ­nh hĂ£ng Honda/Yamaha. CĂ¢n chá»‰nh xĂ­ch Ä‘Ăºng Ä‘á»™ cÄƒng.", Description = "ThĂ¡o láº¯p bá»™ xĂ­ch nhĂ´ng Ä‘Ä©a, cĂ¢n chá»‰nh Ä‘á»™ cÄƒng xĂ­ch theo tiĂªu chuáº©n nhĂ  sáº£n xuáº¥t. BĂ´i má»¡ chuyĂªn dá»¥ng, kiá»ƒm tra Ä‘á»™ mĂ²n vĂ  tÆ° váº¥n chu ká»³ thay tiáº¿p theo. GiĂ¡ chÆ°a bao gá»“m xĂ­ch nhĂ´ng.", TotalBookings = 198, AverageRating = 4.8m, TotalReviews = 78, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv22 = new Service { ServiceName = "Thay gÆ°Æ¡ng + Ä‘Ă¨n xi nhan", Slug = "thay-guong-den-xi-nhan", CategoryId = scPhuTung.CategoryId, Price = 30000, OriginalPrice = null, Duration = 15, WarrantyDays = 30, IsPopular = false, Tags = "guong,xi-nhan,chinh-hang", ShortDescription = "Thay gÆ°Æ¡ng chiáº¿u háº­u vĂ  Ä‘Ă¨n xi nhan chĂ­nh hĂ£ng. Nhanh chĂ³ng, giĂ¡ ráº».", Description = "Thay gÆ°Æ¡ng chiáº¿u háº­u Honda, Yamaha, Piaggio chĂ­nh hĂ£ng. Thay bĂ³ng Ä‘Ă¨n xi nhan, kiá»ƒm tra máº¡ch Ä‘iá»‡n. GiĂ¡ lĂ  cĂ´ng láº¯p, chÆ°a bao gá»“m phá»¥ tĂ¹ng. Há»— trá»£ tÆ° váº¥n chá»n gÆ°Æ¡ng phĂ¹ há»£p xe.", TotalBookings = 145, AverageRating = 4.7m, TotalReviews = 55, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv23 = new Service { ServiceName = "Thay dĂ¢y curoa xe ga", Slug = "thay-day-curoa-xe-ga", CategoryId = scPhuTung.CategoryId, Price = 80000, OriginalPrice = null, Duration = 40, WarrantyDays = 90, IsPopular = false, Tags = "day-curoa,xe-ga,chinh-hang", ShortDescription = "Thay dĂ¢y curoa chĂ­nh hĂ£ng, kiá»ƒm tra bi nhĂ´ng, Ä‘iá»u chá»‰nh cĂ´n tá»± Ä‘á»™ng.", Description = "ThĂ¡o há»™p sá»‘ CVT, thay dĂ¢y curoa má»›i chĂ­nh hĂ£ng theo Ä‘Ăºng model xe. Kiá»ƒm tra vĂ  thay bi nhĂ´ng náº¿u mĂ²n, vá»‡ sinh vĂ  bĂ´i má»¡ há»™p sá»‘, cĂ¢n chá»‰nh cĂ´n tá»± Ä‘á»™ng. GiĂ¡ chÆ°a bao gá»“m dĂ¢y curoa.", TotalBookings = 167, AverageRating = 4.8m, TotalReviews = 64, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv24 = new Service { ServiceName = "Thay lá»c giĂ³ + vá»‡ sinh bá»™ cháº¿ hĂ²a khĂ­", Slug = "thay-loc-gio-ve-sinh-bo-che-hoa-khi", CategoryId = scPhuTung.CategoryId, Price = 50000, OriginalPrice = null, Duration = 30, WarrantyDays = 30, IsPopular = false, Tags = "loc-gio,che-hoa-khi,tiet-kiem-xang", ShortDescription = "Thay lá»c giĂ³ má»›i, vá»‡ sinh bá»™ cháº¿ hĂ²a khĂ­ giĂºp xe tiáº¿t kiá»‡m xÄƒng hÆ¡n 10%.", Description = "Thay lá»c giĂ³ theo Ä‘Ăºng OEM xe, vá»‡ sinh buá»“ng phao vĂ  kim ga bá»™ cháº¿ hĂ²a khĂ­ báº±ng dung dá»‹ch chuyĂªn dá»¥ng. CĂ¢n chá»‰nh tá»‰ lá»‡ há»—n há»£p nhiĂªn liá»‡u-khĂ´ng khĂ­ tá»‘i Æ°u. GiĂ¡ chÆ°a bao gá»“m lá»c giĂ³.", TotalBookings = 123, AverageRating = 4.7m, TotalReviews = 47, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv25 = new Service { ServiceName = "Thay nhá»›t há»™p sá»‘ + nhá»›t phuá»™c", Slug = "thay-nhot-hop-so-nhot-phuoc", CategoryId = scPhuTung.CategoryId, Price = 35000, OriginalPrice = null, Duration = 20, WarrantyDays = 30, IsPopular = false, Tags = "nhot-hop-so,nhot-phuoc,bao-duong", ShortDescription = "Thay nhá»›t há»™p sá»‘ xe cĂ´n tay vĂ  nhá»›t phuá»™c trÆ°á»›c. ThÆ°á»ng bá»‹ bá» qua khi báº£o dÆ°á»¡ng.", Description = "Thay nhá»›t há»™p sá»‘ xe cĂ´n tay (thÆ°á»ng bá» quĂªn khi thay nhá»›t Ä‘á»‹nh ká»³), thay nhá»›t phuá»™c trÆ°á»›c giĂºp phuá»™c Ăªm hÆ¡n. Kiá»ƒm tra Ä‘á»™ rĂ² rá»‰, tÆ° váº¥n chu ká»³ thay tiáº¿p theo. GiĂ¡ chÆ°a bao gá»“m nhá»›t.", TotalBookings = 89, AverageRating = 4.8m, TotalReviews = 33, ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800", IsActive = true };

                    // â”€â”€ KIá»‚M TRA â”€â”€
                    var sv26 = new Service { ServiceName = "Kiá»ƒm tra tá»•ng quĂ¡t miá»…n phĂ­", Slug = "kiem-tra-tong-quat-mien-phi", CategoryId = scKiemTra.CategoryId, Price = 0, OriginalPrice = null, Duration = 20, WarrantyDays = 0, IsPopular = true, Tags = "mien-phi,kiem-tra,tu-van", ShortDescription = "Kiá»ƒm tra 20 háº¡ng má»¥c an toĂ n miá»…n phĂ­. Nháº­n bĂ¡o cĂ¡o tĂ¬nh tráº¡ng xe chi tiáº¿t.", Description = "Kiá»ƒm tra 20 háº¡ng má»¥c: phanh, lá»‘p, Ä‘Ă¨n, Ä‘iá»‡n, nhá»›t, xĂ­ch, phuá»™c, bugi, lá»c giĂ³, áº¯c quy... Nháº­n bĂ¡o cĂ¡o chi tiáº¿t tĂ¬nh tráº¡ng xe, tÆ° váº¥n Æ°u tiĂªn sá»­a chá»¯a. HoĂ n toĂ n miá»…n phĂ­, khĂ´ng Ă©p mua thĂªm dá»‹ch vá»¥.", TotalBookings = 456, AverageRating = 4.9m, TotalReviews = 187, ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800", IsActive = true };
                    var sv27 = new Service { ServiceName = "Kiá»ƒm tra há»‡ thá»‘ng Ä‘iá»‡n", Slug = "kiem-tra-he-thong-dien", CategoryId = scKiemTra.CategoryId, Price = 50000, OriginalPrice = null, Duration = 30, WarrantyDays = 0, IsPopular = false, Tags = "kiem-tra-dien,ac-quy,may-phat", ShortDescription = "Kiá»ƒm tra áº¯c quy, mĂ¡y phĂ¡t Ä‘iá»‡n, há»‡ thá»‘ng Ä‘Ă¡nh lá»­a, relay vĂ  cáº§u chĂ¬ toĂ n bá»™.", Description = "DĂ¹ng thiáº¿t bá»‹ chuyĂªn dá»¥ng kiá»ƒm tra: sá»©c khá»e áº¯c quy (CCA), Ä‘iá»‡n Ă¡p mĂ¡y phĂ¡t, bá»™ náº¡p Ä‘iá»‡n, há»‡ thá»‘ng Ä‘Ă¡nh lá»­a, relay, cáº§u chĂ¬. TĂ¬m nguyĂªn nhĂ¢n xe hay háº¿t Ä‘iá»‡n, khá»Ÿi Ä‘á»™ng yáº¿u, Ä‘Ă¨n chá»›p táº¯t báº¥t thÆ°á»ng.", TotalBookings = 134, AverageRating = 4.8m, TotalReviews = 51, ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800", IsActive = true };
                    var sv28 = new Service { ServiceName = "Äá»c lá»—i Ä‘á»™ng cÆ¡ (OBD/FI)", Slug = "doc-loi-dong-co-obd-fi", CategoryId = scKiemTra.CategoryId, Price = 80000, OriginalPrice = null, Duration = 20, WarrantyDays = 0, IsPopular = false, Tags = "doc-loi,fi,obd,cam-bien", ShortDescription = "Äá»c vĂ  xĂ³a lá»—i há»‡ thá»‘ng FI (phun xÄƒng Ä‘iá»‡n tá»­) báº±ng thiáº¿t bá»‹ chuyĂªn dá»¥ng.", Description = "Káº¿t ná»‘i thiáº¿t bá»‹ cháº©n Ä‘oĂ¡n chuyĂªn dá»¥ng Ä‘á»c mĂ£ lá»—i Ä‘á»™ng cÆ¡ FI/EFI. XĂ¡c Ä‘á»‹nh chĂ­nh xĂ¡c cáº£m biáº¿n hoáº·c linh kiá»‡n lá»—i, xĂ³a lá»—i sau khi sá»­a chá»¯a. Há»— trá»£ Honda (HDS), Yamaha (YDT), Suzuki, Kawasaki.", TotalBookings = 98, AverageRating = 4.8m, TotalReviews = 38, ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800", IsActive = true };
                    var sv29 = new Service { ServiceName = "Kiá»ƒm tra vĂ  cĂ¢n chá»‰nh carburetor", Slug = "kiem-tra-can-chinh-carburetor", CategoryId = scKiemTra.CategoryId, Price = 60000, OriginalPrice = null, Duration = 30, WarrantyDays = 14, IsPopular = false, Tags = "carburetor,can-chinh,xe-cu", ShortDescription = "Kiá»ƒm tra, vá»‡ sinh vĂ  cĂ¢n chá»‰nh bá»™ cháº¿ hĂ²a khĂ­ cho xe dĂ¹ng xÄƒng cÆ¡ há»c (khĂ´ng FI).", Description = "ThĂ¡o vá»‡ sinh toĂ n bá»™ bá»™ cháº¿ hĂ²a khĂ­, cĂ¢n chá»‰nh vĂ­t giĂ³, kim ga, phao xÄƒng Ä‘Ăºng má»±c. PhĂ¹ há»£p xe cÅ© dĂ¹ng carburetor: Wave cÅ©, Dream, xe cĂ´n Ä‘á»i cÅ©. Xe cháº¡y Ä‘á»u hÆ¡n, tiáº¿t kiá»‡m xÄƒng hÆ¡n.", TotalBookings = 78, AverageRating = 4.7m, TotalReviews = 29, ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800", IsActive = true };
                    var sv30 = new Service { ServiceName = "Kiá»ƒm tra trÆ°á»›c chuyáº¿n Ä‘i dĂ i", Slug = "kiem-tra-truoc-chuyen-di-dai", CategoryId = scKiemTra.CategoryId, Price = 100000, OriginalPrice = 150000, Duration = 45, WarrantyDays = 0, IsPopular = true, Tags = "truoc-chuyen-di,phuot,an-toan", ShortDescription = "Kiá»ƒm tra toĂ n diá»‡n xe trÆ°á»›c chuyáº¿n phÆ°á»£t dĂ i. Äáº£m báº£o an toĂ n tuyá»‡t Ä‘á»‘i cho hĂ nh trĂ¬nh.", Description = "GĂ³i kiá»ƒm tra chuyĂªn biá»‡t cho chuyáº¿n Ä‘i dĂ i: lá»‘p xe (Ă¡p suáº¥t, Ä‘á»™ mĂ²n, váº¿t ná»©t), phanh (mĂ¡ phanh, dáº§u phanh), xĂ­ch nhĂ´ng (Ä‘á»™ cÄƒng, Ä‘á»™ mĂ²n), Ä‘Ă¨n chiáº¿u sĂ¡ng, áº¯c quy vĂ  Ä‘iá»‡n, nhá»›t mĂ¡y, lá»c giĂ³. Cáº¥p bĂ¡o cĂ¡o kiá»ƒm tra kĂ¨m khuyáº¿n nghá»‹. PhĂ¹ há»£p xe cĂ´n tay vĂ  xe phÆ°á»£t.", TotalBookings = 167, AverageRating = 4.9m, TotalReviews = 68, ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800", IsActive = true };

                    context.Services.AddRange(sv01, sv02, sv03, sv04, sv05, sv06, sv07, sv08, sv09, sv10, sv11, sv12, sv13, sv14, sv15, sv16, sv17, sv18, sv19, sv20, sv21, sv22, sv23, sv24, sv25, sv26, sv27, sv28, sv29, sv30);
                    await context.SaveChangesAsync();

                    // --- ServiceImages chi tiáº¿t ---
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

                    // --- Combo dá»‹ch vá»¥ ---
                    var combo1 = new ServiceCombo { ComboName = "GĂ³i Báº£o dÆ°á»¡ng CÆ¡ báº£n",    TotalPrice = 65000,  DiscountPrice = 55000,  Description = "GĂ³i tiáº¿t kiá»‡m cho báº£o dÆ°á»¡ng hĂ ng thĂ¡ng. Thay nhá»›t + thay bugi trong má»™t láº§n ghĂ©.",                                               ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800" };
                    var combo2 = new ServiceCombo { ComboName = "GĂ³i Báº£o dÆ°á»¡ng ToĂ n Diá»‡n", TotalPrice = 375000, DiscountPrice = 320000, Description = "GĂ³i báº£o dÆ°á»¡ng Ä‘á»‹nh ká»³ Ä‘áº§y Ä‘á»§ nháº¥t. PhĂ¹ há»£p xe Ä‘Ă£ cháº¡y 5.000â€“10.000km.",                                                      ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800" };
                    var combo3 = new ServiceCombo { ComboName = "GĂ³i Rá»­a xe + Báº£o dÆ°á»¡ng",  TotalPrice = 110000, DiscountPrice = 90000,  Description = "Káº¿t há»£p thay nhá»›t vĂ  rá»­a xe cao cáº¥p. Xe vá»«a báº£o dÆ°á»¡ng vá»«a sáº¡ch bĂ³ng.",                                                        ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800" };
                    var combo4 = new ServiceCombo { ComboName = "GĂ³i An ToĂ n Phanh + Lá»‘p", TotalPrice = 130000, DiscountPrice = 110000, Description = "Kiá»ƒm tra vĂ  sá»­a phanh, thay lá»‘p cĂ¹ng lĂºc. An toĂ n toĂ n diá»‡n cho cáº£ xe.",                                                      ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800" };
                    var combo5 = new ServiceCombo { ComboName = "GĂ³i PhÆ°á»£t An ToĂ n",        TotalPrice = 290000, DiscountPrice = 240000, Description = "Chuáº©n bá»‹ hoĂ n háº£o trÆ°á»›c chuyáº¿n phÆ°á»£t dĂ i. Äáº£m báº£o xe luĂ´n trong tráº¡ng thĂ¡i tá»‘t nháº¥t.",                                        ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800" };
                    var combo6 = new ServiceCombo { ComboName = "GĂ³i Äá»™ xe CÆ¡ báº£n",         TotalPrice = 430000, DiscountPrice = 380000, Description = "GĂ³i Ä‘á»™ xe phá»• biáº¿n nháº¥t: LED sĂ¡ng hÆ¡n, giáº£m xĂ³c tá»‘t hÆ¡n, ngoáº¡i tháº¥t Ä‘áº¹p hÆ¡n.",                                                ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800" };
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

                // 9. SEED PRODUCTS
                if (!context.Products.Any())
                {
                    var catMap   = await context.Categories.ToDictionaryAsync(c => c.Slug ?? "", c => c.CategoryId);
                    var brandMap = await context.Brands.ToDictionaryAsync(b => b.BrandName, b => b.BrandId);

                    int cOil  = catMap.GetValueOrDefault("dau-nhot-boi-tron");
                    int cTire = catMap.GetValueOrDefault("lop-xe-vanh");
                    int cBrk  = catMap.GetValueOrDefault("he-thong-phanh");
                    int cShk  = catMap.GetValueOrDefault("giam-xoc");
                    int cBat  = catMap.GetValueOrDefault("ac-quy-dien");
                    int cHelm = catMap.GetValueOrDefault("mu-bao-ho");
                    int cPart = catMap.GetValueOrDefault("phu-tung-phu-kien");

                    int bMotul = brandMap.GetValueOrDefault("Motul");
                    int bLiqui = brandMap.GetValueOrDefault("Liqui Moly");
                    int bBrem  = brandMap.GetValueOrDefault("Brembo");
                    int bMich  = brandMap.GetValueOrDefault("Michelin");
                    int bOhl   = brandMap.GetValueOrDefault("Ohlins");
                    int bYSS   = brandMap.GetValueOrDefault("YSS");
                    int bHonda = brandMap.GetValueOrDefault("Honda");
                    int bYama  = brandMap.GetValueOrDefault("Yamaha");
                    int bNGK   = brandMap.GetValueOrDefault("NGK");

                    var products = new List<Product>
                    {
                        new Product { CategoryId = cOil,  BrandId = bMotul, ProductName = "Dầu nhớt Motul 3000 4T",        Slug = "dau-nhot-motul-3000-4t",       Description = "Dầu nhớt khoáng Motul 3000 4T đặc biệt cho xe máy 4 thì. Bảo vệ động cơ tối ưu, giảm ma sát và mài mòn.",           IsFeatured = true,  IsActive = true, SoldCount = 420 },
                        new Product { CategoryId = cOil,  BrandId = bMotul, ProductName = "Dầu nhớt Motul 7100 4T",        Slug = "dau-nhot-motul-7100-4t",       Description = "Nhớt tổng hợp 100% Motul 7100 4T cao cấp. Hiệu suất vượt trội, phù hợp xe thể thao và xe phân khối lớn.",         IsFeatured = true,  IsActive = true, SoldCount = 312 },
                        new Product { CategoryId = cOil,  BrandId = bLiqui, ProductName = "Dầu nhớt Liqui Moly Scooter",  Slug = "dau-nhot-liqui-moly-scooter",  Description = "Nhớt bán tổng hợp Liqui Moly đặc chế cho xe tay ga. Bảo vệ bộ côn CVT, giảm tiêu hao nhiên liệu.",                  IsFeatured = false, IsActive = true, SoldCount = 198 },
                        new Product { CategoryId = cOil,  BrandId = bHonda, ProductName = "Lọc dầu Honda chính hãng",     Slug = "loc-dau-honda-chinh-hang",     Description = "Lọc dầu chính hãng Honda phù hợp Wave Alpha, Wave RSX, AirBlade, SH. Lọc sạch tạp chất, bảo vệ động cơ.",           IsFeatured = false, IsActive = true, SoldCount = 534 },
                        new Product { CategoryId = cTire, BrandId = bMich,  ProductName = "Lốp Michelin Pilot Street 2",  Slug = "lop-michelin-pilot-street-2",  Description = "Lốp Michelin Pilot Street 2 chống trượt vượt trội, bền bỉ trên mọi địa hình. Tiêu chuẩn OEM xe Honda, Yamaha.",       IsFeatured = true,  IsActive = true, SoldCount = 267 },
                        new Product { CategoryId = cTire, BrandId = bMich,  ProductName = "Lốp Michelin City Grip 2",     Slug = "lop-michelin-city-grip-2",     Description = "Lốp Michelin City Grip 2 thiết kế riêng cho đô thị. Bám đường xuất sắc khi trời mưa, tiếng ồn thấp.",                IsFeatured = false, IsActive = true, SoldCount = 189 },
                        new Product { CategoryId = cTire, BrandId = bMich,  ProductName = "Lốp Dunlop TT900 GP",          Slug = "lop-dunlop-tt900-gp",          Description = "Lốp Dunlop TT900 GP thể thao, kết cấu đặc biệt giúp xe bám đường ở tốc độ cao. Phù hợp xe côn tay.",                IsFeatured = false, IsActive = true, SoldCount = 145 },
                        new Product { CategoryId = cBrk,  BrandId = bBrem,  ProductName = "Má phanh Brembo Sintered",     Slug = "ma-phanh-brembo-sintered",     Description = "Má phanh Brembo Sintered hiệu năng cao, chịu nhiệt tốt. Tăng lực phanh 30% so với má phanh thường. Cho Wave, AirBlade.", IsFeatured = true,  IsActive = true, SoldCount = 356 },
                        new Product { CategoryId = cBrk,  BrandId = bMotul, ProductName = "Dầu phanh Motul RBF 660",      Slug = "dau-phanh-motul-rbf-660",      Description = "Dầu phanh Motul RBF 660 DOT 4 Racing. Điểm sôi khô 325°C, điểm sôi ướt 204°C. Dành cho xe thể thao.",              IsFeatured = false, IsActive = true, SoldCount = 123 },
                        new Product { CategoryId = cShk,  BrandId = bYSS,   ProductName = "Giảm xóc YSS G-Plus",          Slug = "giam-xoc-yss-g-plus",          Description = "Giảm xóc sau YSS G-Plus nâng cấp, hành trình 330mm. Điều chỉnh độ cứng 5 cấp. Phù hợp Wave, Future, Exciter.",      IsFeatured = true,  IsActive = true, SoldCount = 98  },
                        new Product { CategoryId = cShk,  BrandId = bOhl,   ProductName = "Giảm xóc Ohlins S36E",         Slug = "giam-xoc-ohlins-s36e",         Description = "Giảm xóc Ohlins S36E cao cấp nhập khẩu chính hãng Thụy Điển. Công nghệ TTX, êm ái và ổn định tuyệt vời.",           IsFeatured = true,  IsActive = true, SoldCount = 43  },
                        new Product { CategoryId = cBat,  BrandId = bHonda, ProductName = "Ắc quy GS GTZ5S",              Slug = "ac-quy-gs-gtz5s",              Description = "Ắc quy GS GTZ5S 12V-3.5Ah MF không cần bảo dưỡng. Khởi động mạnh mẽ, tuổi thọ cao. Bảo hành 12 tháng.",             IsFeatured = false, IsActive = true, SoldCount = 234 },
                        new Product { CategoryId = cHelm, BrandId = bYama,  ProductName = "Mũ bảo hiểm AGV K1 S",         Slug = "mu-bao-hiem-agv-k1-s",         Description = "Mũ AGV K1 S full face cao cấp nhập khẩu Ý. Vỏ ngoài sợi composite, lưỡi trai kép chống sương mù. Chứng nhận DOT+ECE.", IsFeatured = true,  IsActive = true, SoldCount = 76  },
                        new Product { CategoryId = cPart, BrandId = bNGK,   ProductName = "Bugi NGK CR8E",                Slug = "bugi-ngk-cr8e",                Description = "Bugi NGK CR8E chính hãng, phù hợp Honda Wave, AirBlade, Vario. Đánh lửa ổn định, bền bỉ, tiết kiệm nhiên liệu.",     IsFeatured = false, IsActive = true, SoldCount = 678 },
                        new Product { CategoryId = cPart, BrandId = bNGK,   ProductName = "Bugi NGK Iridium CPR8EAIX",   Slug = "bugi-ngk-iridium-cpr8eaix",   Description = "Bugi NGK Iridium cao cấp, điện cực iridium siêu mảnh. Tuổi thọ gấp 4 lần bugi thường. Xe chạy mượt và tiết kiệm xăng.", IsFeatured = false, IsActive = true, SoldCount = 245 },
                        new Product { CategoryId = cPart, BrandId = bYama,  ProductName = "Bộ nhông xích Yamaha Exciter", Slug = "nhong-xich-yamaha-exciter",    Description = "Bộ nhông xích chính hãng Yamaha cho Exciter 155. Thép tôi cứng, chống mài mòn. Bao gồm xích 428H, nhông trước 14T, đĩa 42T.", IsFeatured = false, IsActive = true, SoldCount = 167 },
                        new Product { CategoryId = cPart, BrandId = bHonda, ProductName = "Lọc gió Honda Air Blade 160",  Slug = "loc-gio-honda-air-blade-160",  Description = "Lọc gió chính hãng Honda cho Air Blade 160. Lọc bụi hiệu quả, đảm bảo hỗn hợp nhiên liệu tối ưu.",                  IsFeatured = false, IsActive = true, SoldCount = 312 },
                        new Product { CategoryId = cPart, BrandId = bHonda, ProductName = "Gương chiếu hậu Honda SH",     Slug = "guong-chieu-hau-honda-sh",     Description = "Gương chiếu hậu chính hãng Honda SH 125i/150i. Tầm nhìn rộng, chống chói, điều chỉnh dễ dàng.",                    IsFeatured = false, IsActive = true, SoldCount = 89  },
                        new Product { CategoryId = cOil,  BrandId = bHonda, ProductName = "Nhớt phuộc Honda 10W30",       Slug = "nhot-phuoc-honda-10w30",       Description = "Dầu nhớt phuộc trước chính hãng Honda 10W30. Giữ phuộc hoạt động êm ái, chống rò rỉ, bảo hành 30 ngày.",              IsFeatured = false, IsActive = true, SoldCount = 145 },
                        new Product { CategoryId = cBrk,  BrandId = bBrem,  ProductName = "Dầu phanh Brembo Dot 4",       Slug = "dau-phanh-brembo-dot4",        Description = "Dầu phanh Brembo DOT 4 Racing. Điểm sôi cao, độ nhớt ổn định theo nhiệt độ. Phù hợp mọi xe có phanh đĩa.",           IsFeatured = false, IsActive = true, SoldCount = 134 },
                    };
                    context.Products.AddRange(products);
                    await context.SaveChangesAsync();

                    // Variants
                    var imgOil1  = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600";
                    var imgOil2  = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=600";
                    var imgTire  = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=600";
                    var imgBrk   = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=600";
                    var imgShk   = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600";
                    var imgBat   = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600";
                    var imgHelm  = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=600";
                    var imgPart  = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=600";

                    var p = products; // shorthand
                    var variants = new List<ProductVariant>
                    {
                        // Motul 3000
                        new ProductVariant { ProductId = p[0].ProductId, VariantName = "Motul 3000 4T 10W40 - 0.8L", Price = 95000,    OriginalPrice = 110000,  CostPrice = 70000,  StockQuantity = 150, SKU = "MOT3000-08", ImageUrl = imgOil1 },
                        new ProductVariant { ProductId = p[0].ProductId, VariantName = "Motul 3000 4T 10W40 - 1L",   Price = 115000,   OriginalPrice = 130000,  CostPrice = 85000,  StockQuantity = 120, SKU = "MOT3000-10", ImageUrl = imgOil1 },
                        // Motul 7100
                        new ProductVariant { ProductId = p[1].ProductId, VariantName = "Motul 7100 4T 10W40 - 1L",   Price = 195000,   OriginalPrice = null,     CostPrice = 145000, StockQuantity = 80,  SKU = "MOT7100-10", ImageUrl = imgOil2 },
                        new ProductVariant { ProductId = p[1].ProductId, VariantName = "Motul 7100 4T 5W40 - 1L",    Price = 205000,   OriginalPrice = null,     CostPrice = 155000, StockQuantity = 60,  SKU = "MOT7100-5W", ImageUrl = imgOil2 },
                        // Liqui Moly
                        new ProductVariant { ProductId = p[2].ProductId, VariantName = "Liqui Moly Scooter 10W40 - 0.8L", Price = 185000, OriginalPrice = 210000, CostPrice = 140000, StockQuantity = 70,  SKU = "LQSC-08",   ImageUrl = imgOil1 },
                        // Lọc dầu Honda
                        new ProductVariant { ProductId = p[3].ProductId, VariantName = "Lọc dầu Honda Wave/AirBlade", Price = 35000,    OriginalPrice = null,     CostPrice = 22000,  StockQuantity = 200, SKU = "LDHONDA-WA", ImageUrl = imgPart },
                        new ProductVariant { ProductId = p[3].ProductId, VariantName = "Lọc dầu Honda SH/PCX",        Price = 42000,    OriginalPrice = null,     CostPrice = 28000,  StockQuantity = 180, SKU = "LDHONDA-SH", ImageUrl = imgPart },
                        // Michelin Pilot Street 2
                        new ProductVariant { ProductId = p[4].ProductId, VariantName = "Pilot Street 2 90/90-14 F",   Price = 450000,   OriginalPrice = 490000,  CostPrice = 340000, StockQuantity = 45,  SKU = "MCH-PS2-F",  ImageUrl = imgTire },
                        new ProductVariant { ProductId = p[4].ProductId, VariantName = "Pilot Street 2 100/80-14 R",  Price = 490000,   OriginalPrice = 530000,  CostPrice = 370000, StockQuantity = 40,  SKU = "MCH-PS2-R",  ImageUrl = imgTire },
                        // Michelin City Grip 2
                        new ProductVariant { ProductId = p[5].ProductId, VariantName = "City Grip 2 90/90-14",         Price = 420000,   OriginalPrice = null,     CostPrice = 315000, StockQuantity = 35,  SKU = "MCH-CG2-14", ImageUrl = imgTire },
                        new ProductVariant { ProductId = p[5].ProductId, VariantName = "City Grip 2 100/90-10",        Price = 395000,   OriginalPrice = null,     CostPrice = 295000, StockQuantity = 30,  SKU = "MCH-CG2-10", ImageUrl = imgTire },
                        // Dunlop TT900
                        new ProductVariant { ProductId = p[6].ProductId, VariantName = "TT900 GP 80/90-17 F",          Price = 320000,   OriginalPrice = 350000,  CostPrice = 240000, StockQuantity = 55,  SKU = "DUN-TT9-F",  ImageUrl = imgTire },
                        new ProductVariant { ProductId = p[6].ProductId, VariantName = "TT900 GP 100/90-17 R",         Price = 360000,   OriginalPrice = 390000,  CostPrice = 270000, StockQuantity = 50,  SKU = "DUN-TT9-R",  ImageUrl = imgTire },
                        // Brembo Sintered
                        new ProductVariant { ProductId = p[7].ProductId, VariantName = "Brembo Sin. Wave Alpha/RSX",   Price = 250000,   OriginalPrice = 290000,  CostPrice = 185000, StockQuantity = 60,  SKU = "BRE-SIN-WA", ImageUrl = imgBrk },
                        new ProductVariant { ProductId = p[7].ProductId, VariantName = "Brembo Sin. AirBlade/Vario",   Price = 280000,   OriginalPrice = 320000,  CostPrice = 210000, StockQuantity = 55,  SKU = "BRE-SIN-AB", ImageUrl = imgBrk },
                        new ProductVariant { ProductId = p[7].ProductId, VariantName = "Brembo Sin. Exciter/NVX",      Price = 350000,   OriginalPrice = 390000,  CostPrice = 265000, StockQuantity = 40,  SKU = "BRE-SIN-EX", ImageUrl = imgBrk },
                        // Dầu phanh Motul RBF 660
                        new ProductVariant { ProductId = p[8].ProductId, VariantName = "Motul RBF 660 DOT4 - 250ml",  Price = 280000,   OriginalPrice = null,     CostPrice = 210000, StockQuantity = 40,  SKU = "MOTRB-250",  ImageUrl = imgBrk },
                        // YSS G-Plus
                        new ProductVariant { ProductId = p[9].ProductId, VariantName = "YSS G-Plus Wave Alpha/RSX",    Price = 1250000,  OriginalPrice = 1450000, CostPrice = 950000, StockQuantity = 25,  SKU = "YSS-GP-WA",  ImageUrl = imgShk },
                        new ProductVariant { ProductId = p[9].ProductId, VariantName = "YSS G-Plus AirBlade/PCX",      Price = 1450000,  OriginalPrice = 1650000, CostPrice = 1100000,StockQuantity = 20,  SKU = "YSS-GP-AB",  ImageUrl = imgShk },
                        new ProductVariant { ProductId = p[9].ProductId, VariantName = "YSS G-Plus Exciter 155",        Price = 1550000,  OriginalPrice = 1750000, CostPrice = 1180000,StockQuantity = 18,  SKU = "YSS-GP-EX",  ImageUrl = imgShk },
                        // Ohlins S36E
                        new ProductVariant { ProductId = p[10].ProductId, VariantName = "Ohlins S36E 330mm Black",     Price = 3500000,  OriginalPrice = null,     CostPrice = 2700000,StockQuantity = 10,  SKU = "OHL-S36-BK", ImageUrl = imgShk },
                        new ProductVariant { ProductId = p[10].ProductId, VariantName = "Ohlins S36E 350mm Gold",      Price = 3800000,  OriginalPrice = null,     CostPrice = 2950000,StockQuantity = 8,   SKU = "OHL-S36-GD", ImageUrl = imgShk },
                        // Ắc quy GS
                        new ProductVariant { ProductId = p[11].ProductId, VariantName = "GS GTZ5S 12V-3.5Ah MF",      Price = 320000,   OriginalPrice = null,     CostPrice = 240000, StockQuantity = 40,  SKU = "GS-GTZ5S",   ImageUrl = imgBat },
                        new ProductVariant { ProductId = p[11].ProductId, VariantName = "GS YTX9-BS 12V-8Ah MF",      Price = 580000,   OriginalPrice = null,     CostPrice = 440000, StockQuantity = 25,  SKU = "GS-YTX9",    ImageUrl = imgBat },
                        // Mũ AGV K1 S
                        new ProductVariant { ProductId = p[12].ProductId, VariantName = "AGV K1 S - Size M - Đen",    Price = 1800000,  OriginalPrice = 2100000, CostPrice = 1380000,StockQuantity = 15,  SKU = "AGV-K1-M-BK",ImageUrl = imgHelm },
                        new ProductVariant { ProductId = p[12].ProductId, VariantName = "AGV K1 S - Size L - Đen",    Price = 1800000,  OriginalPrice = 2100000, CostPrice = 1380000,StockQuantity = 12,  SKU = "AGV-K1-L-BK",ImageUrl = imgHelm },
                        new ProductVariant { ProductId = p[12].ProductId, VariantName = "AGV K1 S - Size XL - Trắng", Price = 1900000,  OriginalPrice = 2200000, CostPrice = 1450000,StockQuantity = 10,  SKU = "AGV-K1-XL-W",ImageUrl = imgHelm },
                        // Bugi NGK CR8E
                        new ProductVariant { ProductId = p[13].ProductId, VariantName = "NGK CR8E - 1 cái",            Price = 45000,    OriginalPrice = null,     CostPrice = 30000,  StockQuantity = 300, SKU = "NGK-CR8E-1", ImageUrl = imgPart },
                        new ProductVariant { ProductId = p[13].ProductId, VariantName = "NGK CR8E - Hộp 10 cái",      Price = 420000,   OriginalPrice = 450000,  CostPrice = 285000, StockQuantity = 50,  SKU = "NGK-CR8E-10",ImageUrl = imgPart },
                        // Bugi NGK Iridium
                        new ProductVariant { ProductId = p[14].ProductId, VariantName = "NGK Iridium CPR8EAIX",        Price = 125000,   OriginalPrice = null,     CostPrice = 88000,  StockQuantity = 120, SKU = "NGK-IRD-8",  ImageUrl = imgPart },
                        // Nhông xích Yamaha
                        new ProductVariant { ProductId = p[15].ProductId, VariantName = "Bộ nhông xích Exciter 155 - Standard", Price = 380000, OriginalPrice = 420000, CostPrice = 285000, StockQuantity = 30, SKU = "YAM-NX-EX-STD", ImageUrl = imgPart },
                        new ProductVariant { ProductId = p[15].ProductId, VariantName = "Bộ nhông xích Exciter 155 - Racing",   Price = 520000, OriginalPrice = null,    CostPrice = 395000, StockQuantity = 20, SKU = "YAM-NX-EX-RC",  ImageUrl = imgPart },
                        // Lọc gió Air Blade
                        new ProductVariant { ProductId = p[16].ProductId, VariantName = "Lọc gió Air Blade 160 chính hãng",    Price = 85000,  OriginalPrice = null,     CostPrice = 55000,  StockQuantity = 90,  SKU = "HONDA-LG-AB",  ImageUrl = imgPart },
                        // Gương SH
                        new ProductVariant { ProductId = p[17].ProductId, VariantName = "Gương SH 125i - Bên phải",    Price = 180000,   OriginalPrice = null,     CostPrice = 130000, StockQuantity = 35,  SKU = "HONDA-GU-SH-R",ImageUrl = imgPart },
                        new ProductVariant { ProductId = p[17].ProductId, VariantName = "Gương SH 125i - Bên trái",    Price = 180000,   OriginalPrice = null,     CostPrice = 130000, StockQuantity = 35,  SKU = "HONDA-GU-SH-L",ImageUrl = imgPart },
                        // Nhớt phuộc
                        new ProductVariant { ProductId = p[18].ProductId, VariantName = "Nhớt phuộc Honda 10W30 - 100ml", Price = 45000, OriginalPrice = null,     CostPrice = 30000,  StockQuantity = 110, SKU = "HONDA-NP-100", ImageUrl = imgOil1 },
                        // Dầu phanh Brembo
                        new ProductVariant { ProductId = p[19].ProductId, VariantName = "Brembo DOT 4 Racing - 250ml", Price = 220000,   OriginalPrice = null,     CostPrice = 165000, StockQuantity = 45,  SKU = "BRE-DOT4-250", ImageUrl = imgBrk },
                    };
                    context.ProductVariants.AddRange(variants);
                    await context.SaveChangesAsync();

                    // Primary images for each product
                    var productImages = products.SelectMany((pr, i) =>
                    {
                        string[] imgs = i switch
                        {
                            0 or 1 or 2 => new[] { imgOil1, imgOil2 },
                            3           => new[] { imgPart, imgOil1 },
                            4 or 5 or 6 => new[] { imgTire, imgBrk },
                            7 or 8      => new[] { imgBrk,  imgShk },
                            9 or 10     => new[] { imgShk,  imgBrk },
                            11          => new[] { imgBat,  imgPart },
                            12          => new[] { imgHelm, imgPart },
                            _           => new[] { imgPart, imgOil1 },
                        };
                        return imgs.Select((url, idx) => new ProductImage
                        {
                            ProductId    = pr.ProductId,
                            ImageUrl     = url,
                            IsPrimary    = idx == 0,
                            DisplayOrder = idx
                        });
                    }).ToList();
                    context.ProductImages.AddRange(productImages);
                    await context.SaveChangesAsync();
                }

                // 10. SEED CUSTOMERS
                if (!context.Customers.Any())
                {
                    var customers = new[]
                    {
                        new Customer { FullName = "Nguyễn Văn An",     Email = "an.nguyen@gmail.com",     Phone = "0901234561", Address = "12 Lê Lợi, Q.1, TP.HCM",          CreatedDate = DateTime.Now.AddDays(-180) },
                        new Customer { FullName = "Trần Thị Bích",     Email = "bich.tran@gmail.com",     Phone = "0912345672", Address = "34 Nguyễn Huệ, Q.1, TP.HCM",      CreatedDate = DateTime.Now.AddDays(-150) },
                        new Customer { FullName = "Lê Minh Cường",     Email = "cuong.le@gmail.com",      Phone = "0923456783", Address = "56 Trần Hưng Đạo, Q.5, TP.HCM",   CreatedDate = DateTime.Now.AddDays(-130) },
                        new Customer { FullName = "Phạm Thị Duyên",    Email = "duyen.pham@gmail.com",    Phone = "0934567894", Address = "78 Điện Biên Phủ, Q.3, TP.HCM",   CreatedDate = DateTime.Now.AddDays(-110) },
                        new Customer { FullName = "Hoàng Văn Đức",     Email = "duc.hoang@gmail.com",     Phone = "0945678905", Address = "90 Cách Mạng Tháng 8, Q.10",       CreatedDate = DateTime.Now.AddDays(-95)  },
                        new Customer { FullName = "Vũ Thị Hoa",        Email = "hoa.vu@gmail.com",        Phone = "0956789016", Address = "23 Bình Thạnh, TP.HCM",            CreatedDate = DateTime.Now.AddDays(-80)  },
                        new Customer { FullName = "Đặng Văn Hùng",     Email = "hung.dang@gmail.com",     Phone = "0967890127", Address = "45 Phú Nhuận, TP.HCM",             CreatedDate = DateTime.Now.AddDays(-70)  },
                        new Customer { FullName = "Bùi Thị Lan",       Email = "lan.bui@gmail.com",       Phone = "0978901238", Address = "67 Gò Vấp, TP.HCM",               CreatedDate = DateTime.Now.AddDays(-60)  },
                        new Customer { FullName = "Ngô Văn Long",      Email = "long.ngo@gmail.com",      Phone = "0989012349", Address = "89 Tân Bình, TP.HCM",              CreatedDate = DateTime.Now.AddDays(-50)  },
                        new Customer { FullName = "Đinh Thị Mai",      Email = "mai.dinh@gmail.com",      Phone = "0990123450", Address = "101 Quận 7, TP.HCM",              CreatedDate = DateTime.Now.AddDays(-40)  },
                        new Customer { FullName = "Lý Văn Nam",        Email = "nam.ly@gmail.com",        Phone = "0901357901", Address = "15 Bình Dương",                    CreatedDate = DateTime.Now.AddDays(-30)  },
                        new Customer { FullName = "Tô Thị Oanh",       Email = "oanh.to@gmail.com",       Phone = "0912468012", Address = "27 Đồng Nai",                      CreatedDate = DateTime.Now.AddDays(-20)  },
                        new Customer { FullName = "Hồ Văn Phúc",       Email = "phuc.ho@gmail.com",       Phone = "0923579123", Address = "39 Long An",                       CreatedDate = DateTime.Now.AddDays(-12)  },
                        new Customer { FullName = "Dương Thị Quỳnh",   Email = "quynh.duong@gmail.com",   Phone = "0934680234", Address = "51 Tiền Giang",                    CreatedDate = DateTime.Now.AddDays(-7)   },
                        new Customer { FullName = "Châu Văn Rồng",     Email = "rong.chau@gmail.com",     Phone = "0945791345", Address = "63 Vũng Tàu",                      CreatedDate = DateTime.Now.AddDays(-3)   },
                    };
                    context.Customers.AddRange(customers);
                    await context.SaveChangesAsync();
                }

                // 11. SEED ORDERS + ORDER ITEMS + STATUS HISTORY
                if (!context.Orders.Any())
                {
                    var allCustomers = await context.Customers.ToListAsync();
                    var allVariants  = await context.ProductVariants.ToListAsync();
                    if (allCustomers.Any() && allVariants.Any())
                    {
                        var rng = new Random(42);
                        var statuses   = new[] { "Completed","Completed","Completed","Completed","Completed","Pending","Confirmed","Shipping","Cancelled" };
                        var pmethods   = new[] { "COD","COD","VNPay","VNPay","Momo","ZaloPay" };
                        var allOrders  = new List<Order>();
                        var allItems   = new List<OrderItem>();
                        var allHistory = new List<OrderStatusHistory>();

                        for (int i = 0; i < 100; i++)
                        {
                            var customer = allCustomers[rng.Next(allCustomers.Count)];
                            var status   = statuses[rng.Next(statuses.Length)];
                            var date     = DateTime.Now.AddDays(-rng.Next(1, 91)).Date.AddHours(rng.Next(8, 21)).AddMinutes(rng.Next(0, 60));

                            // 1-3 items per order
                            int itemCount = rng.Next(1, 4);
                            var picked = Enumerable.Range(0, itemCount)
                                .Select(_ => allVariants[rng.Next(allVariants.Count)])
                                .ToList();

                            decimal total = 0;
                            var oItems = picked.Select(v => {
                                int qty = rng.Next(1, 4);
                                decimal price = v.Price;
                                total += qty * price;
                                return new OrderItem { ProductVariantId = v.ProductVariantId, Quantity = qty, Price = price };
                            }).ToList();

                            var order = new Order
                            {
                                CustomerId    = customer.CustomerId,
                                OrderDate     = date,
                                TotalAmount   = total,
                                DiscountAmount = 0,
                                Status        = status,
                                ShippingAddress = customer.Address,
                                PaymentMethod = pmethods[rng.Next(pmethods.Length)],
                                PaymentStatus = status == "Cancelled" ? "Refunded" : status == "Completed" ? "Paid" : "Pending",
                            };
                            allOrders.Add(order);
                            oItems.ForEach(it => it.Order = order);
                            allItems.AddRange(oItems);

                            if (status == "Completed")
                            {
                                allHistory.Add(new OrderStatusHistory
                                {
                                    Order = order,
                                    Status = "Confirmed",
                                    ChangedDate = date.AddHours(rng.Next(1, 3))
                                });
                                allHistory.Add(new OrderStatusHistory
                                {
                                    Order = order,
                                    Status = "Shipping",
                                    ChangedDate = date.AddHours(rng.Next(4, 12))
                                });
                                allHistory.Add(new OrderStatusHistory
                                {
                                    Order = order,
                                    Status = "Completed",
                                    ChangedDate = date.AddHours(rng.Next(24, 72))
                                });
                            }
                            else if (status == "Cancelled")
                            {
                                allHistory.Add(new OrderStatusHistory { Order = order, Status = "Cancelled", ChangedDate = date.AddHours(rng.Next(1, 5)) });
                            }
                        }

                        context.Orders.AddRange(allOrders);
                        await context.SaveChangesAsync();

                        // Gán OrderId sau khi lưu
                        allItems.ForEach(it => it.OrderId = it.Order!.OrderId);
                        allHistory.ForEach(h => h.OrderId = h.Order!.OrderId);
                        // Xóa reference để tránh duplicate insert
                        allItems.ForEach(it => it.Order = null);
                        allHistory.ForEach(h => h.Order = null);

                        context.OrderItems.AddRange(allItems);
                        context.OrderStatusHistory.AddRange(allHistory);
                        await context.SaveChangesAsync();
                    }
                }

                // 12. SEED BANNERS + SLIDERS
                if (!context.Banners.Any())
                {
                    context.Banners.AddRange(
                        new Banner { Title = "Khuyến mãi mùa hè - Giảm đến 30%",       ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200", LinkUrl = "/san-pham",      Position = "home-top",    DisplayOrder = 1, IsActive = true },
                        new Banner { Title = "Nhớt Motul chính hãng - Ưu đãi tháng 5",  ImageUrl = "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=1200", LinkUrl = "/san-pham/dau-nhot-motul-3000-4t", Position = "home-top", DisplayOrder = 2, IsActive = true },
                        new Banner { Title = "Dịch vụ bảo dưỡng - Miễn phí kiểm tra",   ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1200", LinkUrl = "/dich-vu",       Position = "home-mid",    DisplayOrder = 1, IsActive = true },
                        new Banner { Title = "Lốp Michelin - Bám đường mọi điều kiện",  ImageUrl = "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=1200", LinkUrl = "/san-pham/lop-michelin-pilot-street-2", Position = "sidebar", DisplayOrder = 1, IsActive = true }
                    );
                    await context.SaveChangesAsync();
                }

                if (!context.Sliders.Any())
                {
                    context.Sliders.AddRange(
                        new Slider { Title = "MotoShop - Phụ tùng xe máy chính hãng",        ImageUrl = "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1600", LinkUrl = "/san-pham",  Position = 1, IsActive = true },
                        new Slider { Title = "Dịch vụ bảo dưỡng chuyên nghiệp tại nhà",      ImageUrl = "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=1600", LinkUrl = "/dich-vu",   Position = 2, IsActive = true },
                        new Slider { Title = "Giảm xóc YSS & Ohlins - Nhập khẩu chính hãng", ImageUrl = "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=1600", LinkUrl = "/san-pham",  Position = 3, IsActive = true },
                        new Slider { Title = "Mũ bảo hiểm AGV - An toàn tuyệt đối",          ImageUrl = "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=1600", LinkUrl = "/san-pham",  Position = 4, IsActive = true },
                        new Slider { Title = "Bugi NGK - Đánh lửa ổn định, tiết kiệm xăng",  ImageUrl = "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=1600", LinkUrl = "/san-pham",  Position = 5, IsActive = true }
                    );
                    await context.SaveChangesAsync();
                }

                // 14. SEED NEW PROMOTIONS VOUCHERS
                if (!context.Promotions.Any(p => p.PromotionType == PromotionType.Voucher))
                {
                    context.Promotions.AddRange(
                        new Promotion
                        {
                            Name = "WELCOME10",
                            Slug = "welcome10",
                            PromotionType = PromotionType.Voucher,
                            DiscountType = DiscountType.Percent,
                            DiscountValue = 10,
                            MinOrderAmount = 200000,
                            CouponCode = "WELCOME10",
                            StartDate = DateTime.Now.AddDays(-1),
                            EndDate = DateTime.Now.AddMonths(3),
                            UsageLimit = 100,
                            UsedCount = 23,
                            IsActive = true
                        },
                        new Promotion
                        {
                            Name = "MOTOSHOP50",
                            Slug = "motoshop50",
                            PromotionType = PromotionType.Voucher,
                            DiscountType = DiscountType.Fixed,
                            DiscountValue = 50000,
                            MinOrderAmount = 500000,
                            CouponCode = "MOTOSHOP50",
                            StartDate = DateTime.Now.AddDays(-1),
                            EndDate = DateTime.Now.AddMonths(2),
                            UsageLimit = 50,
                            UsedCount = 8,
                            IsActive = true
                        },
                        new Promotion
                        {
                            Name = "SUMMER20",
                            Slug = "summer20",
                            PromotionType = PromotionType.Voucher,
                            DiscountType = DiscountType.Percent,
                            DiscountValue = 20,
                            MinOrderAmount = 300000,
                            CouponCode = "SUMMER20",
                            StartDate = DateTime.Now.AddDays(-1),
                            EndDate = DateTime.Now.AddMonths(1),
                            UsageLimit = 200,
                            UsedCount = 67,
                            IsActive = true
                        },
                        new Promotion
                        {
                            Name = "VIP100K",
                            Slug = "vip100k",
                            PromotionType = PromotionType.Voucher,
                            DiscountType = DiscountType.Fixed,
                            DiscountValue = 100000,
                            MinOrderAmount = 1000000,
                            CouponCode = "VIP100K",
                            StartDate = DateTime.Now.AddDays(-1),
                            EndDate = DateTime.Now.AddMonths(6),
                            UsageLimit = 20,
                            UsedCount = 3,
                            IsActive = true
                        },
                        new Promotion
                        {
                            Name = "FREESHIP",
                            Slug = "freeship",
                            PromotionType = PromotionType.Voucher,
                            DiscountType = DiscountType.Fixed,
                            DiscountValue = 30000,
                            MinOrderAmount = 150000,
                            CouponCode = "FREESHIP",
                            StartDate = DateTime.Now.AddDays(-1),
                            EndDate = DateTime.Now.AddMonths(1),
                            UsageLimit = 500,
                            UsedCount = 134,
                            IsActive = true
                        }
                    );
                    await context.SaveChangesAsync();
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERR] Seeding Error: {ex.Message}\n{ex.StackTrace}");
            }
        }
    }
}
