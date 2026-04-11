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

            // 3. CLEAR OLD DATA (Dọn dẹp để nạp bộ dữ liệu chuẩn mới)
            context.ProductImages.RemoveRange(context.ProductImages);
            context.ProductVariants.RemoveRange(context.ProductVariants);
            context.Products.RemoveRange(context.Products);
            context.Categories.RemoveRange(context.Categories);
            context.Brands.RemoveRange(context.Brands);
            await context.SaveChangesAsync();

            // 4. HELPER METHODS
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
                    Slug = name.ToLower().Replace(" ", "-").Replace("đ", "d").Replace("/", "-").Replace(".", "-").Replace(" ", ""),
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

            // 5. NẠP DỮ LIỆU THEO DANH MỤC

            #region PHỤ TÙNG MÁY
            await AddProductAsync("Piston UMA Racing", "PHỤ TÙNG MÁY", "UMA Racing", "Dòng piston nâng cấp hiệu suất cao, hợp kim nhôm CNC, nhẹ và bền. Tương thích Exciter, Winner.", "https://umaracing.com/wp-content/uploads/2022/04/Racing-Piston.png", 
                new List<(string, decimal, string)> { ("62mm", 850000, "UMA-P62"), ("65mm", 950000, "UMA-P65") });

            await AddProductAsync("Trục cam BRT", "PHỤ TÙNG MÁY", "BRT", "Cải thiện thời gian đóng mở xupap, tăng hiệu suất nạp xả. Xuất xứ Indonesia.", "https://product.hstatic.net/1000375176/product/dsc04816_5e2fee57d0eb45e8802c2d37348db04b_master.jpg", 
                new List<(string, decimal, string)> { ("Stage 1", 1200000, "BRT-C1"), ("Stage 2", 1500000, "BRT-C2") });

            await AddProductAsync("Xupap Inox Racing", "PHỤ TÙNG MÁY", "Racing Parts", "Xupap inox chịu nhiệt lên đến 700°C, tăng độ bền cho động cơ độ.", "https://cdn.hstatic.net/products/200000263155/screenshot_2025-07-23_043343_85f7674fde2b40a39576bb947c03f8a7.png", 
                new List<(string, decimal, string)> { ("Intake", 300000, "XV-IN"), ("Exhaust", 350000, "XV-EX") });

            await AddProductAsync("Bugi NGK Iridium", "PHỤ TÙNG MÁY", "NGK", "Tăng hiệu suất đánh lửa, giúp máy mượt và tiết kiệm xăng. Tuổi thọ 30.000km.", "https://ngkntk.com.vn/upload/images/Laser%201.jpg", 
                new List<(string, decimal, string)> { ("CR7", 220000, "NGK-CR7"), ("CR8", 240000, "NGK-CR8") });

            await AddProductAsync("Lọc gió DNA", "PHỤ TÙNG MÁY", "DNA", "Lọc gió sợi tổng hợp, tăng 98% lượng khí sạch vào buồng đốt.", "https://shop2banh.vn/images/thumbs/2022/10/loc-gio-dna-chinh-hang-danh-cho-honda-sh350i-1938-slide-products-63468754645dc.jpg", 
                new List<(string, decimal, string)> { ("Exciter", 800000, "DNA-EX"), ("Winner", 780000, "DNA-WIN") });

            await AddProductAsync("Mobin sườn Racing Boy", "PHỤ TÙNG MÁY", "RCB", "Tăng cường dòng điện đánh lửa, cải thiện sức mạnh động cơ.", "https://tuantienracing.com/thumbs/600x400x2/upload/product/vai-tro-mobin-suon-1574.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 500000, "MOBIN-RCB") });

            await AddProductAsync("Kim phun xăng Bosch", "PHỤ TÙNG MÁY", "Bosch", "Tối ưu lượng nhiên liệu phun, tăng hiệu suất buồng đốt.", "https://product.hstatic.net/200000536179/product/51epfgw8qwl._ac_sl1500__a422140993ba4853bda6d47f91dc72ce_1024x1024.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 700000, "INJ-BOSCH") });

            await AddProductAsync("Bơm xăng điện Denso", "PHỤ TÙNG MÁY", "Denso", "Cung cấp nhiên liệu ổn định, điện áp 12V, lưu lượng 90L/h.", "https://densovietnam.vn/wp-content/uploads/2021/04/195131-9300-1-scaled.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 900000, "PUMP-DEN") });

            await AddProductAsync("ECU độ UMA Racing", "PHỤ TÙNG MÁY", "UMA Racing", "Điều chỉnh xăng lửa, tối ưu Mapping cho xe độ hiệu suất cao.", "https://product.hstatic.net/200000263155/product/c29a346f-4136-46b9-9748-9810aae498cf_369233d893474d7286a5069d7a789212.jpg", 
                new List<(string, decimal, string)> { ("Standard", 3500000, "ECU-UMA") });

            await AddProductAsync("Bộ nồi SSS Racing", "PHỤ TÙNG MÁY", "SSS", "Tăng tốc nhanh, giảm trượt nồi, bốc hơn nồi zin.", "https://cdn.hstatic.net/products/200000692635/b__c_n_sau_wave_s_110__rsx_110__wave_blade_honda___22100k09l01___53f57beb54d147709a9bc07c1dc58695_1024x1024.jpg", 
                new List<(string, decimal, string)> { ("Full bộ", 2200000, "SSS-FULL") });
            #endregion

            #region DÀN CHÂN
            await AddProductAsync("Mâm RCB Racing Boy", "DÀN CHÂN", "RCB", "Mâm đúc CNC thể thao, nhẹ, tăng ổn định khi vào cua.", "https://shop2banh.vn/images/thumbs/2018/03/mam-rcb-chinh-hang-cho-wave-dream-future-sirius-jupiter-exciter-135-doi-dau-695-slide-products-5aa09bfe05fd6.jpg", 
                new List<(string, decimal, string)> { ("Đen", 6500000, "RCB-B"), ("Vàng", 6800000, "RCB-G") });

            await AddProductAsync("Phuộc trước Ohlins Upside Down", "DÀN CHÂN", "Ohlins", "Giảm xóc hành trình ngược cao cấp, êm ái vượt trội.", "https://detailingnation.vn/cdn/shop/files/OhlinsFRGT219745mmYamahaR1_3ca3f66a-47d7-437f-8b09-912a9f465253_1080x.png?v=1724121441", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 12000000, "OHL-F") });

            await AddProductAsync("Phuộc sau YSS G-Sport", "DÀN CHÂN", "YSS", "Có bình dầu, chỉnh được 3 cấp độ cứng, cực kỳ ổn định.", "https://shop2banh.vn/images/thumbs/2022/08/phuoc-yss-g-sport-chinh-hang-cho-honda-ab160-1893-slide-products-62f1daef99ab7.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 3500000, "YSS-R") });

            await AddProductAsync("Heo dầu Brembo M4", "DÀN CHÂN", "Brembo", "4 Piston đối xứng, lực phanh cực mạnh và an toàn.", "https://product.hstatic.net/200000341373/product/m4-108-01_956affece1fd4584aba1542ea3902994.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 6500000, "BR-M4") });

            await AddProductAsync("Đĩa thắng Galfer", "DÀN CHÂN", "Galfer", "Thép carbon tản nhiệt tốt, kích thước 260mm.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/477/832/products/6695bf01-34db-47df-b6c2-6c1cfe7a4cc3.jpg?v=1679503242737", 
                new List<(string, decimal, string)> { ("260mm", 2200000, "GAL-260") });

            await AddProductAsync("Dây dầu HEL Performance", "DÀN CHÂN", "HEL", "Lõi thép bọc Teflon, không giãn nở ở áp suất cao.", "https://ttracing.net/wp-content/uploads/2025/04/DAY-HEL-CHINH-HANG-BAM-VESPA.jpeg", 
                new List<(string, decimal, string)> { ("Đỏ", 600000, "HEL-R"), ("Xanh", 600000, "HEL-B") });

            await AddProductAsync("Gác chân CNC Racing", "DÀN CHÂN", "CNC Racing", "Nhôm CNC chống trượt, thẩm mỹ cao cho xe độ.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC04MQIMp52-XbZoMr5wTd2zDZXYyO1D0tFw&s", 
                new List<(string, decimal, string)> { ("Đen", 500000, "GC-B"), ("Đỏ", 520000, "GC-R") });

            await AddProductAsync("Pát heo dầu CNC", "DÀN CHÂN", "Custom", "Nhôm CNC 10mm, giúp gắn heo dầu lớn lên xe zin.", "https://down-vn.img.susercontent.com/file/sg-11134201-7rbl5-lm8sigdr5wa1c0", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 350000, "PAT-CNC") });

            await AddProductAsync("Chảng ba CNC Racing", "DÀN CHÂN", "CNC Racing", "Tăng độ cứng vững cho đầu xe khi chạy tốc độ cao.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/455/876/products/pst17r-02.jpg?v=1664879598100", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 2500000, "CHANG-BA") });

            await AddProductAsync("Trục bánh trước sau Titan", "DÀN CHÂN", "Titan Parts", "Titan siêu nhẹ và cứng, không rỉ sét theo thời gian.", "https://img.lazcdn.com/g/p/0a5fb4b0c21dd2f536db8cc1c4b4f2c6.jpg_720x720q80.jpg", 
                new List<(string, decimal, string)> { ("Trước", 700000, "TRUC-T"), ("Sau", 800000, "TRUC-S") });
            #endregion

            #region NHỚT MÁY
            await AddProductAsync("Motul 300V Factory Line", "NHỚT MÁY", "Motul", "Công nghệ Ester Core độc quyền cho xe đua.", "https://product.hstatic.net/200000038440/product/0-09_2fdeaf1e233a4acca1348fa2a85d04f3_cbc538665d7547269cad642ed2e30e1a_29d7ead10d254242b9ffbe2d5655e7e8_master.jpg", 
                new List<(string, decimal, string)> { ("1L", 420000, "MOTUL-1"), ("2L", 800000, "MOTUL-2") });

            await AddProductAsync("Castrol Power1 Racing", "NHỚT MÁY", "Castrol", "Tăng tốc nhanh hơn, tối ưu hiệu suất đốt cháy.", "https://www.fc-moto.de/WebRoot/FCMotoDB/Shops/10207048/6139/E498/7667/5994/DCD1/AC1E/1405/D41D/POWER1_RACING_4T_5W-40_1l_png_img_500_medium_2_ml.jpg", 
                new List<(string, decimal, string)> { ("1L", 300000, "CASTROL-R") });

            await AddProductAsync("Shell Advance Ultra", "NHỚT MÁY", "Shell", "Công nghệ PurePlus giúp làm sạch động cơ tuyệt đối.", "https://product.hstatic.net/200000341373/product/shell_advance_10w40_692c68c826d141abac25bde72c23dbd0_1024x1024.jpg", 
                new List<(string, decimal, string)> { ("1L", 280000, "SHELL-U") });

            await AddProductAsync("Repsol Moto Racing", "NHỚT MÁY", "Repsol", "Chuyên dụng cho xe thể thao, chịu nhiệt cực tốt.", "https://shop2banh.vn/images/thumbs/2023/06/nhot-repsol-racing-10w40-1l-508-slide-products-6488398ce5378.png", 
                new List<(string, decimal, string)> { ("1L", 350000, "REPSOL-R") });

            await AddProductAsync("Liqui Moly Street Race", "NHỚT MÁY", "Liqui Moly", "Nhớt Đức cao cấp, bảo vệ máy vượt trội.", "https://bizweb.dktcdn.net/100/360/787/products/15-9fde6dfc-da4f-417a-b4fe-672cc24bacdf.jpg?v=1751006533747", 
                new List<(string, decimal, string)> { ("1L", 400000, "LIQUI") });

            await AddProductAsync("Total Hi-Perf 4T", "NHỚT MÁY", "Total", "Tiết kiệm nhiên liệu, phù hợp xe đi phố hằng ngày.", "https://dxm.content-center.totalenergies.com/api/wedia/dam/transform/xysh7dg731ta74k8f43wbfpxgr/hi-perf-4t-700-10w-40-0.8l.webp", 
                new List<(string, decimal, string)> { ("1L", 250000, "TOTAL") });

            await AddProductAsync("Motorex Top Speed", "NHỚT MÁY", "Motorex", "Giảm rung, tăng tuổi thọ chi tiết máy bên trong.", "https://cdn.shopify.com/s/files/1/2637/7322/files/Motorex_15W50_Top_Speed_720x.jpg?v=1719917727", 
                new List<(string, decimal, string)> { ("1L", 450000, "MOTOREX") });

            await AddProductAsync("Fuchs Silkolene Pro 4", "NHỚT MÁY", "Fuchs", "Dòng nhớt hiệu suất cao cho xe côn tay.", "https://shop2banh.vn/images/thumbs/2022/10/nhot-fuchs-silkolene-pro-4-10w40-xp-1064-slide-products-635f32393264d.jpg", 
                new List<(string, decimal, string)> { ("1L", 420000, "FUCHS") });

            await AddProductAsync("ENEOS Racing Street", "NHỚT MÁY", "ENEOS", "Nhớt Nhật Bản, ổn định và êm ái.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSVsL2wrx-xzINnu2OomsLAeFZQBQ_xuxu4A&s", 
                new List<(string, decimal, string)> { ("1L", 270000, "ENEOS") });

            await AddProductAsync("Amsoil Metric Motorcycle", "NHỚT MÁY", "Amsoil", "Nhớt Mỹ cao cấp, kéo dài chu kỳ thay nhớt.", "https://shop2banh.vn/images/thumbs/2022/12/nhot-amsoil-10w40-synthetic-metric-946ml-362-slide-products-639fe35a385e3.jpg", 
                new List<(string, decimal, string)> { ("1L", 500000, "AMSOIL") });
            #endregion

            #region ĐỒ CHƠI XE
            await AddProductAsync("Tay thắng CRG Folding", "ĐỒ CHƠI XE", "CRG", "Nhôm CNC, gập chống gãy, chỉnh được xa gần.", "https://www.tinomotor.vn/storage/pagedata/100113/img/slide/product/3292/277786935_2744964482466268_7290132748879786037_n.jpg", 
                new List<(string, decimal, string)> { ("Đen", 1800000, "CRG-B"), ("Đỏ", 1850000, "CRG-R") });

            await AddProductAsync("Gương Rizoma Reverse", "ĐỒ CHƠI XE", "Rizoma", "Thiết kế thể thao, nhôm CNC xoay 360 độ.", "https://imgwebikenet-8743.kxcdn.com/catalogue/images/159436/35_01_imgi_232_bs072a_backview_jpg.jpg", 
                new List<(string, decimal, string)> { ("Đen", 1200000, "RIZ-B") });

            await AddProductAsync("Đèn LED trợ sáng L4X", "ĐỒ CHƠI XE", "L4X", "Công suất 40W, ánh sáng cực mạnh cho tour xa.", "https://dailydaunhot.com/wp-content/uploads/2019/05/%C4%90%C3%A8n-Tr%E1%BB%A3-S%C3%A1ng-L4x.jpg", 
                new List<(string, decimal, string)> { ("1 bóng", 500000, "LED-L4X") });

            await AddProductAsync("Móc treo đồ CNC", "ĐỒ CHƠI XE", "Custom", "Tiện lợi và thẩm mỹ cho xe phố.", "https://shop2banh.vn/images/thumbs/2022/11/moc-treo-do-cnc-cho-honda-sh-1954-slide-products-636339ae0f583.jpg", 
                new List<(string, decimal, string)> { ("Đen", 120000, "MOC-B"), ("Đỏ", 130000, "MOC-R") });

            await AddProductAsync("Pad biển số CNC", "ĐỒ CHƠI XE", "Custom", "Gọn gàng, phong cách thể thao.", "https://www.vnride.com/wp-content/uploads/2024/05/z5461231207594_45485a0005b31e19b584698471e09908.jpg", 
                new List<(string, decimal, string)> { ("Đen", 300000, "PAD-B") });

            await AddProductAsync("Bao tay Domino", "ĐỒ CHƠI XE", "Domino", "Cao su cao cấp, tăng độ bám khi cầm lái.", "https://detailingnation.vn/cdn/shop/files/DSC0240.jpg?v=1685597937", 
                new List<(string, decimal, string)> { ("Đen", 250000, "DOM-B"), ("Xanh", 260000, "DOM-X") });

            await AddProductAsync("Ốp pô Carbon", "ĐỒ CHƠI XE", "Custom", "Chống nóng và tăng vẻ thể thao.", "https://img.websosanh.vn/v2/users/wss/images/op-po-e-vision-moi-2021/e8a02c45872c4.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 600000, "OP-CARBON") });

            await AddProductAsync("Kính chắn gió mini", "ĐỒ CHƠI XE", "Custom", "Nhựa ABS, giảm lực gió khi đi nhanh.", "https://product.hstatic.net/200000925405/product/kinh_chan_gio_mini_honda_cgx150_honda_wuyang__4__7fb65f4132e94db1a80863b9261b6ee9_master.jpg", 
                new List<(string, decimal, string)> { ("Trong suốt", 400000, "KINH-TS") });

            await AddProductAsync("Xi nhan LED Spirit Beast", "ĐỒ CHƠI XE", "Spirit Beast", "Thiết kế nhỏ gọn, tiết kiệm điện.", "https://ctshop.vn/wp-content/uploads/2019/08/z6546952445041_e1e71a6f1ea4926b2c655cb135fb136e-scaled.jpg", 
                new List<(string, decimal, string)> { ("Cặp", 350000, "SIGNAL-SB") });

            await AddProductAsync("Tem dán phản quang", "ĐỒ CHƠI XE", "Decal", "An toàn ban đêm, thẩm mỹ cao.", "https://down-vn.img.susercontent.com/file/606db21d23e3e254f20cca13a47b4e96", 
                new List<(string, decimal, string)> { ("Bộ full", 200000, "TEM-R") });
            #endregion

            #region VỎ LỐP XE
            await AddProductAsync("Michelin Pilot Street 2", "VỎ LỐP XE", "Michelin", "Bám đường cực tốt ngay cả khi trời mưa.", "https://dxm.contentcenter.michelin.com/api/wedia/dam/transform/b98rpyxf61b4qzptzsictt3x6a/mo-93_tire_michelin_pilot-street-2_ww_set_a_main_1-30_nopad.webp?t=resize&height=500", 
                new List<(string, decimal, string)> { ("Trước", 550000, "MIC-F"), ("Sau", 750000, "MIC-R") });

            await AddProductAsync("Pirelli Diablo Rosso Sport", "VỎ LỐP XE", "Pirelli", "Lốp thể thao chuyên dụng vào cua tốc độ cao.", "https://shop2banh.vn/images/thumbs/2025/09/lop-pirelli-diablo-rosso-sport-9080-17-12070-17-2058-slide-products-68b80eaebdf85.jpg", 
                new List<(string, decimal, string)> { ("Trước", 1200000, "PIR-F"), ("Sau", 1800000, "PIR-R") });

            await AddProductAsync("IRC NR77", "VỎ LỐP XE", "IRC", "Lốp phổ thông bền bỉ cho xe đi hằng ngày.", "https://konquer.ca/wp-content/uploads/2023/02/IRC-NR77-Tire.webp", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 400000, "IRC") });

            await AddProductAsync("Dunlop TT900", "VỎ LỐP XE", "Dunlop", "Lốp thể thao được ưa chuộng nhất của Dunlop.", "https://images.genialmotor.it/DUNLOP/SENZA_CORNICE/tt900.jpg", 
                new List<(string, decimal, string)> { ("Trước", 900000, "DUN-F"), ("Sau", 1100000, "DUN-R") });

            await AddProductAsync("Maxxis M6029", "VỎ LỐP XE", "Maxxis", "Lốp giá rẻ nhưng chất lượng ổn định.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-DQU_Isy0H4g-5cRt3mLniU9R4g6Ucb4ZYA&s", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 500000, "MAX") });

            await AddProductAsync("Bridgestone Battlax BT39", "VỎ LỐP XE", "Bridgestone", "Độ bám đường cực cao cho xe độ.", "https://www.bridgestone.com/products/motorcycle_tires/products/assets/img/detail/pr016-detail_01.png", 
                new List<(string, decimal, string)> { ("Trước", 1500000, "BS-F"), ("Sau", 2000000, "BS-R") });

            await AddProductAsync("Metzeler Sportec Street", "VỎ LỐP XE", "Metzeler", "Lốp touring Đức, tuổi thọ lên đến 22.000km.", "https://www.rubbex.com/images/thumbs/081/0814188_Metzeler-80-90-14-40S-Sportec-Street-Rear-M-C-15240696-full.jpg_550.webp", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1300000, "METZ") });

            await AddProductAsync("Continental ContiGo", "VỎ LỐP XE", "Continental", "Lốp touring bền bỉ, ổn định đường dài.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT10rLMlQ_8kt12jklFsWncrnVU_ggWYiV_PQ&s", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1200000, "CONTI") });

            await AddProductAsync("CST Adreno Sport", "VỎ LỐP XE", "CST", "Gai lốp thể thao, bám đường tốt.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6i10FEohDZkA_olH0hcew5jw9l3et4fGHhg&s", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 800000, "CST") });

            await AddProductAsync("Kenda K775", "VỎ LỐP XE", "Kenda", "Lốp đa dụng đi được cả phố và địa hình nhẹ.", "https://cdn11.bigcommerce.com/s-t49hlhoupu/images/stencil/1280x1280/products/5860/11939/13365956035ebabe967af9c1589296790__10335.1597769469.jpg?c=1", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 700000, "KENDA") });
            #endregion
        }
    }
}
