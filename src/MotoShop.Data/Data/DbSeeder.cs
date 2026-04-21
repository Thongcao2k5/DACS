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
            // 3. CLEAR OLD DATA (BẮT BUỘC: Xóa sạch dữ liệu cũ để cập nhật bộ 100 sản phẩm và ảnh mới)
            context.InventoryTransactions.RemoveRange(context.InventoryTransactions);
            context.OrderItems.RemoveRange(context.OrderItems);
            context.Orders.RemoveRange(context.Orders);
            context.ProductReviews.RemoveRange(context.ProductReviews);
            context.PromotionProducts.RemoveRange(context.PromotionProducts);
            context.ProductImages.RemoveRange(context.ProductImages);
            context.ProductVariants.RemoveRange(context.ProductVariants);
            context.Products.RemoveRange(context.Products);
            context.Categories.RemoveRange(context.Categories);
            context.Brands.RemoveRange(context.Brands);
            context.Promotions.RemoveRange(context.Promotions);
            context.Coupons.RemoveRange(context.Coupons);
            context.Blogs.RemoveRange(context.Blogs);
            context.BlogCategories.RemoveRange(context.BlogCategories);
            context.Services.RemoveRange(context.Services);
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
            // 5. NẠP DỮ LIỆU SẢN PHẨM MỚI (100 SẢN PHẨM)

            #region 01. DẦU NHỚT & PHỤ TRỢ (MOTUL, LIQUI MOLY, ...)
            await AddProductAsync("Dầu nhớt Motul 7100 10W40", "DẦU NHỚT", "Motul", "Sử dụng công nghệ Ester Core độc quyền giúp giảm ma sát tối đa giữa các chi tiết máy, bảo vệ động cơ toàn diện.", "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png", 
                new List<(string, decimal, string)> { ("Bản 1L", 320000, "MOTUL7100-1L"), ("Bản 1.1L", 350000, "MOTUL7100-1.1L") });

                await AddProductAsync("Trục cam BRT", "PHỤ TÙNG MÁY", "BRT", "Cải thiện nạp xả cho xe độ.", "https://product.hstatic.net/1000375176/product/dsc04816_5e2fee57d0eb45e8802c2d37348db04b_master.jpg", 
                    new List<(string, decimal, string)> { ("Stage 1", 1200000, "BRT-C1") });
            await AddProductAsync("Dung dịch vệ sinh sên Motul C1", "BẢO DƯỠNG", "Motul", "Giúp tẩy sạch các lớp dầu mỡ cũ, bụi bẩn và rỉ sét bám trên sên xe nhanh chóng.", "https://shop2banh.vn/images/thumbs/2024/08/motul-c1.png", 
                new List<(string, decimal, string)> { ("Chai xịt 400ml", 165000, "MOTUL-C1-CLEAN") });

                await AddProductAsync("Bugi NGK Iridium", "PHỤ TÙNG MÁY", "NGK", "Tăng hiệu suất đánh lửa.", "https://ngkntk.com.vn/upload/images/Laser%201.jpg", 
                    new List<(string, decimal, string)> { ("CR7", 220000, "NGK-CR7") });
                #endregion
            await AddProductAsync("Xịt dưỡng sên Motul C2 (Road)", "BẢO DƯỠNG", "Motul", "Tạo lớp màng bảo vệ bôi trơn chuyên dụng cho sên xe chạy đường phố, giảm ma sát.", "https://shop2banh.vn/images/thumbs/2024/08/motul-c2.png", 
                new List<(string, decimal, string)> { ("Chai xịt 400ml", 185000, "MOTUL-C2-LUBE") });

            await AddProductAsync("Dung dịch làm mát Liqui Moly Red", "BẢO DƯỠNG", "Liqui Moly", "Giúp giải nhiệt động cơ nhanh chóng, ngăn chặn tình trạng quá nhiệt và đóng cặn két nước.", "https://shop2banh.vn/images/thumbs/2024/05/nuoc-mat-liqui-moly.png", 
                new List<(string, decimal, string)> { ("Chai 1L", 185000, "LIQUI-COOLANT-RED") });

            await AddProductAsync("Dầu phanh Brembo DOT4", "BẢO DƯỠNG", "Brembo", "Dung dịch thủy lực cao cấp có điểm sôi cực cao, duy trì áp suất phanh ổn định.", "https://detailingnation.vn/cdn/shop/files/brembo-dot4.jpg", 
                new List<(string, decimal, string)> { ("Chai 250ml", 180000, "BREMBO-DOT4") });

            await AddProductAsync("Bộ vệ sinh lọc gió K&N", "BẢO DƯỠNG", "K&N", "Combo gồm chai tẩy rửa và chai xịt dầu dưỡng chuyên dụng khôi phục hiệu suất lọc gió.", "https://shop2banh.vn/images/thumbs/2024/02/bo-ve-sinh-loc-gio-kn.jpg", 
                new List<(string, decimal, string)> { ("Bộ combo", 380000, "KN-RECHARGE-KIT") });
            #endregion

                #region DÀN CHÂN
                await AddProductAsync("Mâm RCB Racing Boy", "DÀN CHÂN", "RCB", "Mâm đúc CNC thể thao.", "https://shop2banh.vn/images/thumbs/2018/03/mam-rcb-chinh-hang-cho-wave-dream-future-sirius-jupiter-exciter-135-doi-dau-695-slide-products-5aa09bfe05fd6.jpg", 
                    new List<(string, decimal, string)> { ("Đen", 6500000, "RCB-B") });
            #region 02. HỆ THỐNG PHANH (BREMBO, GALFER, ELIG, ...)
            await AddProductAsync("Phanh đĩa Brembo Oro", "HỆ THỐNG PHANH", "Brembo", "Chế tạo từ hợp kim thép Carbon nhiệt luyện khắt khe, ma sát ổn định ở nhiệt độ cao.", "https://cf.shopee.vn/file/vn-11134207-7ra0g-m7ak1pozkt189a", 
                new List<(string, decimal, string)> { ("Size 260mm", 2500000, "BREMBO-260") });

                await AddProductAsync("Phuộc sau YSS G-Sport", "DÀN CHÂN", "YSS", "Có bình dầu, chỉnh được độ cứng.", "https://shop2banh.vn/images/thumbs/2022/08/phuoc-yss-g-sport-chinh-hang-cho-honda-ab160-1893-slide-products-62f1daef99ab7.jpg", 
                    new List<(string, decimal, string)> { ("Tiêu chuẩn", 3500000, "YSS-R") });
            await AddProductAsync("Heo dầu Brembo M4 Monoblock", "HỆ THỐNG PHANH", "Brembo", "Dòng heo dầu 4 piston đối xứng đúc nguyên khối nổi tiếng toàn cầu về lực phanh mạnh mẽ.", "https://detailingnation.vn/cdn/shop/files/brembo-m4.jpg", 
                new List<(string, decimal, string)> { ("Bên Trái/Phải", 12500000, "BREMBO-M4") });

            await AddProductAsync("Cùm phanh Brembo RCS 19 Corsa Corta", "HỆ THỐNG PHANH", "Brembo", "Đỉnh cao của hệ thống kiểm soát lực phanh với 3 chế độ tùy chỉnh cảm giác phanh.", "https://tinomotor.vn/storage/pagedata/100113/img/images/product/brembo-rcs19.jpg", 
                new List<(string, decimal, string)> { ("Bên Phải", 8800000, "BREMBO-RCS19-CC") });

                await AddProductAsync("Heo dầu Brembo M4", "DÀN CHÂN", "Brembo", "Lực phanh cực mạnh.", "https://product.hstatic.net/200000341373/product/m4-108-01_956affece1fd4584aba1542ea3902994.jpg", 
                    new List<(string, decimal, string)> { ("Tiêu chuẩn", 6500000, "BR-M4") });
                #endregion
            await AddProductAsync("Đĩa thắng Galfer Wave Floating", "HỆ THỐNG PHANH", "Galfer", "Thiết kế hình sóng độc đáo giúp tản nhiệt nhanh, chất liệu thép High-Carbon.", "https://shop2banh.vn/images/thumbs/2024/01/dia-thang-galfer-wave.jpg", 
                new List<(string, decimal, string)> { ("Size 267mm", 3800000, "GALFER-WAVE") });

            await AddProductAsync("Bố thắng Elig Ceramic Sintered", "HỆ THỐNG PHANH", "Elig", "Sản xuất từ hợp chất gốm và hợp kim đồng cao cấp, lực ma sát mạnh mẽ.", "https://elig.com.vn/wp-content/uploads/2019/08/bo-thang-elig-gom.jpg", 
                new List<(string, decimal, string)> { ("Dành cho Exciter", 150000, "ELIG-CERAMIC-EX") });

            await AddProductAsync("Phanh đĩa sau Nissin chính hãng", "HỆ THỐNG PHANH", "Nissin", "Đảm bảo hiệu suất phanh sau ổn định và đồng bộ với hệ thống phanh trước.", "https://phutunghonda.com/wp-content/uploads/2021/03/dia-phanh-nissin.jpg", 
                new List<(string, decimal, string)> { ("Size 190mm", 450000, "NISSIN-REAR-DISK") });

            await AddProductAsync("Dây dầu HEL Carbon", "HỆ THỐNG PHANH", "HEL", "Lõi nhựa Teflon bọc lưới thép không gỉ giúp loại bỏ hiện tượng giãn nở dây dầu.", "https://detailingnation.vn/cdn/shop/files/hel-line.jpg", 
                new List<(string, decimal, string)> { ("Sợi 90cm", 550000, "HEL-CARBON-90") });
            #endregion

                #region NHỚT MÁY
                await AddProductAsync("Motul 300V Factory Line", "NHỚT MÁY", "Motul", "Công nghệ Ester Core cho xe đua.", "https://product.hstatic.net/200000038440/product/0-09_2fdeaf1e233a4acca1348fa2a85d04f3_cbc538665d7547269cad642ed2e30e1a_29d7ead10d254242b9ffbe2d5655e7e8_master.jpg", 
                    new List<(string, decimal, string)> { ("1L", 420000, "MOTUL-1") });
            #region 03. DÀN CHÂN & GIẢM XÓC (MICHELIN, YSS, OHLINS, ...)
            await AddProductAsync("Lốp Michelin Pilot Street 2", "LỐP XE", "Michelin", "Thiết kế rãnh gai lấy cảm hứng từ MotoGP giúp thoát nước cực nhanh.", "https://shop2banh.vn/images/thumbs/2024/09/lop-michelin-pilot-street-2-cho-xe-tay-ga-2058-slide-products-66e123a1a123.jpg", 
                new List<(string, decimal, string)> { ("Bánh trước 70/90-17", 550000, "MICHELIN-F"), ("Bánh sau 120/70-17", 750000, "MICHELIN-R") });

                await AddProductAsync("Shell Advance Ultra", "NHỚT MÁY", "Shell", "Làm sạch động cơ tuyệt đối.", "https://product.hstatic.net/200000341373/product/shell_advance_10w40_692c68c826d141abac25bde72c23dbd0_1024x1024.jpg", 
                    new List<(string, decimal, string)> { ("1L", 280000, "SHELL-U") });
                #endregion
            await AddProductAsync("Phuộc sau YSS G-Series", "GIẢM XÓC", "YSS", "Hệ thống giảm xóc sử dụng công nghệ dầu và khí Nitơ tiên tiến, cực kỳ êm ái.", "https://shop2banh.vn/images/thumbs/2022/08/phuoc-yss-g-series-cho-exciter-150-1893-slide-products-62f1daef99ab7.jpg", 
                new List<(string, decimal, string)> { ("Dòng G-Series", 3500000, "YSS-G-SERIES") });

            await AddProductAsync("Trợ lực sườn Ohlins chính hãng", "ĐỒ CHƠI XE", "Ohlins", "Giúp ổn định tay lái khi xe vận hành ở tốc độ cao hoặc đi qua đoạn đường xấu.", "https://shop2banh.vn/images/thumbs/2023/04/tro-luc-ohlins-chinh-hang-120mm-2050-slide-products-6447895e6f53e.jpg", 
                new List<(string, decimal, string)> { ("Bản 120mm", 12500000, "OHLINS-STEERING-63") });

            await AddProductAsync("Mâm xe Kuni đúc xương cá", "DÀN CHÂN", "Kuni", "Thiết kế nan hoa dày đặc như xương cá, nhôm đúc nguyên khối chắc chắn.", "https://shop2banh.vn/images/thumbs/2017/12/mam-kuni-cho-exciter-150-517-slide-products-5a26569eb2e5d.jpg", 
                new List<(string, decimal, string)> { ("Cặp mâm", 2500000, "KUNI-WHEEL-SET") });
            #endregion

            #region 07. TRUYỀN ĐỘNG & NỒI XE GA (BANDO, DR.PULLEY, ...)
            await AddProductAsync("Dây curoa Bando Green Label", "TRUYỀN ĐỘNG", "Bando", "Sở hữu độ bền vượt trội nhờ hợp chất cao su tổng hợp kết hợp sợi bố gia cường.", "https://shop2banh.vn/images/thumbs/2023/08/day-curoa-bando-cho-sh-1938-slide-products-64e4567a1b123.jpg", 
                new List<(string, decimal, string)> { ("Dành cho Air Blade", 420000, "BANDO-GREEN") });
            #endregion

            #region 08. PHỤ TÙNG ĐỘ MÁY (UMA, KEIHIN, ARACER, ...)
            await AddProductAsync("Kim phun xăng độ Keihin", "HỆ THỐNG ĐIỆN", "Keihin", "Tăng cường lưu lượng xăng phun vào buồng đốt cho xe nâng cấp piston lớn.", "https://shop2banh.vn/images/thumbs/2022/11/kim-phun-keihin-chinh-hang-1954-slide-products-636339ae0f583.jpg", 
                new List<(string, decimal, string)> { ("Bản 160cc", 850000, "KEIHIN-INJECTOR-160") });

            await AddProductAsync("Lòng nhôm kiếng mạ Ceramic", "PHỤ TÙNG MÁY", "YCS", "Lớp mạ Ceramic siêu cứng giúp giảm ma sát tối đa, tản nhiệt nhanh.", "https://shop2banh.vn/images/thumbs/2023/05/long-kieng-ycs-62mm-cho-exciter-2050-slide-products-645321a1b123.jpg", 
                new List<(string, decimal, string)> { ("Size 62mm/65mm", 3200000, "YCS-CERAMIC-CYLINDER") });

            await AddProductAsync("Piston nén cao cấp FJN", "PHỤ TÙNG MÁY", "FJN", "Gia công bằng phương pháp nén áp lực cao, bền bỉ dưới áp suất lớn.", "https://shop2banh.vn/images/thumbs/2023/05/piston-nen-fjn-62mm-2050-slide-products-645321a1b123.jpg", 
                new List<(string, decimal, string)> { ("Size 62mm", 1100000, "FJN-FORGED-PISTON") });
            #endregion

            #region 06. HỆ THỐNG ĐIỆN & ĐÈN (GS, NGK, CREE, KOSO, ...)
            await AddProductAsync("Khóa Smartkey Honda K01", "HỆ THỐNG ĐIỆN", "Honda", "Nhận diện thẻ từ RFID bảo mật, báo động 110dB, chống dắt xe.", "https://shop2banh.vn/images/thumbs/2022/10/khoa-smartkey-honda-chinh-hang-1938-slide-products-63468754645dc.jpg", 
                new List<(string, decimal, string)> { ("Full bộ", 2200000, "HONDA-SMARTKEY") });
            #endregion

                #region ĐỒ CHƠI XE
                await AddProductAsync("Tay thắng CRG Folding", "ĐỒ CHƠI XE", "CRG", "Nhôm CNC gập chống gãy.", "https://www.tinomotor.vn/storage/pagedata/100113/img/slide/product/3292/277786935_2744964482466268_7290132748879786037_n.jpg", 
                    new List<(string, decimal, string)> { ("Đen", 1800000, "CRG-B") });

                await AddProductAsync("Gương Rizoma Reverse", "ĐỒ CHƠI XE", "Rizoma", "Thiết kế thể thao nhôm CNC.", "https://imgwebikenet-8743.kxcdn.com/catalogue/images/159436/35_01_imgi_232_bs072a_backview_jpg.jpg", 
                    new List<(string, decimal, string)> { ("Đen", 1200000, "RIZ-B") });
                #endregion
            #region 09. DỊCH VỤ & COMBO (30 DỊCH VỤ)
            if (!context.Services.Any())
            {
                var services = new List<Service>
                {
                    // Bảo dưỡng động cơ
                    new Service { ServiceName = "Thay nhớt máy tiêu chuẩn", Price = 20000, Description = "Tiền công thay nhớt và kiểm tra ốc xả.", IsActive = true, ImageUrl = "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100.png" },
                    new Service { ServiceName = "Vệ sinh nồi xe tay ga", Price = 150000, Description = "Loại bỏ bụi bẩn, giúp xe chạy mượt và bốc hơn.", IsActive = true, ImageUrl = "https://shop2banh.vn/images/thumbs/2023/10/ve-sinh-noi-xe-tay-ga.jpg" },
                    new Service { ServiceName = "Vệ sinh kim phun Fi", Price = 120000, Description = "Dùng sóng siêu âm làm sạch lỗ kim phun xăng.", IsActive = true },
                    new Service { ServiceName = "Vệ sinh họng xăng & Buồng đốt", Price = 180000, Description = "Tẩy sạch muội than bám trong buồng đốt.", IsActive = true },
                    new Service { ServiceName = "Điều chỉnh khe hở xupap", Price = 150000, Description = "Giúp động cơ hoạt động êm ái, tránh kêu gào.", IsActive = true },
                    
                    // Dàn chân & Phanh
                    new Service { ServiceName = "Vệ sinh & Bảo dưỡng heo dầu", Price = 100000, Description = "Làm sạch pít-tông và tra mỡ chịu nhiệt.", IsActive = true },
                    new Service { ServiceName = "Thay dầu phanh thủy lực", Price = 80000, Description = "Thay dầu DOT 4 giúp phanh nhạy và an toàn.", IsActive = true },
                    new Service { ServiceName = "Cân mâm xe đúc", Price = 150000, Description = "Khắc phục tình trạng bánh xe bị đảo.", IsActive = true },
                    new Service { ServiceName = "Thay lốp xe máy (Công)", Price = 50000, Description = "Tiền công thay lốp bằng máy ra vỏ chuyên dụng.", IsActive = true },
                    new Service { ServiceName = "Bảo dưỡng chén cổ", Price = 250000, Description = "Tra mỡ bò và chỉnh độ rơ cho tay lái.", IsActive = true },
                    
                    // Truyền động
                    new Service { ServiceName = "Vệ sinh & Dưỡng sên", Price = 70000, Description = "Dùng dung dịch chuyên dụng vệ sinh sên trần.", IsActive = true },
                    new Service { ServiceName = "Tăng sên & Bôi trơn", Price = 20000, Description = "Kiểm tra độ chùng và tra dầu sên.", IsActive = true },
                    new Service { ServiceName = "Thay bộ nhông sên dĩa (Công)", Price = 80000, Description = "Công thay thế bộ truyền động cho xe số.", IsActive = true },
                    
                    // Hệ thống điện
                    new Service { ServiceName = "Kiểm tra & Sạc bình ắc quy", Price = 30000, Description = "Đo dòng sạc và phục hồi bình yếu.", IsActive = true },
                    new Service { ServiceName = "Lắp khóa Smartkey Honda", Price = 500000, Description = "Lắp đặt và đồng bộ hệ thống khóa thông minh.", IsActive = true },
                    new Service { ServiceName = "Độ đèn trợ sáng (Lắp đặt)", Price = 150000, Description = "Công lắp đặt và đi dây điện chống cháy.", IsActive = true },
                    new Service { ServiceName = "Kiểm tra hệ thống điện toàn xe", Price = 100000, Description = "Dùng máy đọc lỗi chuyên dụng.", IsActive = true },
                    
                    // Khác
                    new Service { ServiceName = "Rửa xe chi tiết (Detailing)", Price = 120000, Description = "Rửa sâu vào các ngóc ngách động cơ.", IsActive = true },
                    new Service { ServiceName = "Súc két nước & Thay nước mát", Price = 150000, Description = "Đảm bảo giải nhiệt tốt cho động cơ.", IsActive = true },
                    new Service { ServiceName = "Thay lọc gió (Công)", Price = 20000, Description = "Miễn phí công nếu mua lọc gió tại shop.", IsActive = true }
                };
                context.Services.AddRange(services);
                await context.SaveChangesAsync();

                // Tạo Combo
                if (!context.ServiceCombos.Any())
                {
                    var combo1 = new ServiceCombo { 
                        ComboName = "COMBO BẢO DƯỠNG TỔNG QUÁT (XE GA)", 
                        TotalPrice = 650000, 
                        DiscountPrice = 550000, 
                        Description = "Bao gồm: Vệ sinh nồi, Vệ sinh kim phun, Buồng đốt, Thay nhớt máy & nhớt lap.", 
                        IsActive = true 
                    };
                    context.ServiceCombos.Add(combo1);
                    await context.SaveChangesAsync();

                    var sVsn = services.First(s => s.ServiceName.Contains("Vệ sinh nồi"));
                    var sVkp = services.First(s => s.ServiceName.Contains("Vệ sinh kim phun"));
                    
                    context.ServiceComboItems.Add(new ServiceComboItem { ComboId = combo1.ComboId, ServiceId = sVsn.ServiceId });
                    context.ServiceComboItems.Add(new ServiceComboItem { ComboId = combo1.ComboId, ServiceId = sVkp.ServiceId });

                    var combo2 = new ServiceCombo { 
                        ComboName = "COMBO PHƯỢT AN TOÀN", 
                        TotalPrice = 300000, 
                        DiscountPrice = 220000, 
                        Description = "Kiểm tra phanh, thay dầu phanh, vệ sinh sên và kiểm tra lốp.", 
                        IsActive = true 
                    };
                    context.ServiceCombos.Add(combo2);
                    await context.SaveChangesAsync();

                    var sDauPhanh = services.First(s => s.ServiceName.Contains("Thay dầu phanh"));
                    var sVsen = services.First(s => s.ServiceName.Contains("Vệ sinh & Dưỡng sên"));

                    context.ServiceComboItems.Add(new ServiceComboItem { ComboId = combo2.ComboId, ServiceId = sDauPhanh.ServiceId });
                    context.ServiceComboItems.Add(new ServiceComboItem { ComboId = combo2.ComboId, ServiceId = sVsen.ServiceId });
                }
                await context.SaveChangesAsync();
            }
            #endregion


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
                        new Blog { 
                            Title = "5 Mẹo Bảo Dưỡng Nồi Xe Tay Ga Giúp Xe Chạy Êm Và Bốc", 
                            Slug = "5-meo-bao-duong-noi-xe-tay-ga", 
                            Content = @"<p>Sau một thời gian sử dụng từ 5.000 - 7.000km, xe tay ga thường có hiện tượng bị rung đầu khi lên ga hoặc máy kêu gào nhưng xe không đi. Đây chính là dấu hiệu cho thấy bộ nồi của bạn cần được vệ sinh và bảo dưỡng.</p>
                                      <h3>1. Tại sao phải vệ sinh nồi?</h3>
                                      <p>Bộ nồi xe tay ga hoạt động theo cơ chế ma sát khô. Bụi bẩn từ dây curoa và bố ba càng sẽ bám đầy vào chuông nồi, gây ra hiện tượng trượt và mất công suất.</p>
                                      <p><img src='https://shop2banh.vn/images/thumbs/2023/10/ve-sinh-noi-xe-tay-ga-o-dau-uy-tin-gia-tot-1938-slide-products-65239e2d36a13.jpg' alt='Vệ sinh nồi xe tay ga' /></p>
                                      <h3>2. Quy trình vệ sinh tiêu chuẩn</h3>
                                      <ul>
                                        <li>Mở lốc nồi, kiểm tra dây curoa có bị nứt hay không.</li>
                                        <li>Vệ sinh bi nồi, kiểm tra độ mòn của các viên bi.</li>
                                        <li>Vệ sinh chuông nồi và bố ba càng, dùng giấy nhám mịn xả nhẹ bề mặt.</li>
                                        <li>Vệ sinh lọc gió nồi (nếu có).</li>
                                      </ul>
                                      <p>Việc vệ sinh nồi định kỳ không chỉ giúp xe chạy mượt hơn mà còn tiết kiệm xăng đáng kể.</p>", 
                            Thumbnail = "https://shop2banh.vn/images/thumbs/2023/10/ve-sinh-noi-xe-tay-ga-o-dau-uy-tin-gia-tot-1938-slide-products-65239e2d36a13.jpg", 
                            CategoryId = blogCats[0].Id, 
                            IsPublished = true, 
                            CreatedDate = DateTime.Now 
                        },
                        new Blog { 
                            Title = "Đánh Giá Lốp Michelin Pilot Street 2 - Vua Đường Mưa Cho Xe Côn Tay", 
                            Slug = "danh-gia-lop-michelin-pilot-street-2", 
                            Content = @"<p> Michelin Pilot Street 2 là dòng lốp được mong đợi nhất dành cho các tín đồ dòng xe côn tay như Exciter, Winner và các dòng xe tay ga phổ thông.</p>
                                      <h3>Thiết kế rãnh gai độc đáo</h3>
                                      <p>Khác với thế hệ đầu, Pilot Street 2 có các rãnh gai trung tâm giúp thoát nước cực nhanh, tăng độ bám đường trên bề mặt ướt.</p>
                                      <p><img src='https://shop2banh.vn/images/thumbs/2024/09/lop-michelin-pilot-street-2-cho-xe-tay-ga-2058-slide-products-66e123a1a123.jpg' alt='Lốp Michelin Pilot Street 2' /></p>
                                      <h3>Độ bền và hiệu suất</h3>
                                      <p>Lốp được cấu tạo từ hợp chất cao su đặc biệt giúp tăng tuổi thọ lên đến 20.000km mà vẫn giữ được độ mềm và bám đường ổn định.</p>
                                      <p>Đây là sự lựa chọn hàng đầu nếu bạn thường xuyên di chuyển trong điều kiện thời tiết mưa gió tại Việt Nam.</p>", 
                            Thumbnail = "https://shop2banh.vn/images/thumbs/2024/09/lop-michelin-pilot-street-2-cho-xe-tay-ga-2058-slide-products-66e123a1a123.jpg", 
                            CategoryId = blogCats[1].Id, 
                            IsPublished = true, 
                            CreatedDate = DateTime.Now 
                        },
                        new Blog { 
                            Title = "Thay Nhớt Máy: Đừng Đợi Đến Khi Động Cơ Kêu Cứu", 
                            Slug = "thay-nhot-may-dinh-ky", 
                            Content = @"<p>Dầu nhớt được ví như dòng máu của động cơ. Thay nhớt đúng định kỳ là cách rẻ nhất và hiệu quả nhất để bảo vệ chiếc xe của bạn.</p>
                                      <h3>Dấu hiệu cần thay nhớt ngay</h3>
                                      <ul>
                                        <li>Máy nóng hơn bình thường chỉ sau 15-20 phút di chuyển.</li>
                                        <li>Tiếng động cơ kêu to, lạch cạch ở khu vực đầu bò.</li>
                                        <li>Xe chạy cảm giác ì, không còn bốc như trước.</li>
                                      </ul>
                                      <p><img src='https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png' alt='Dầu nhớt Motul 7100' /></p>
                                      <h3>Lời khuyên từ chuyên gia</h3>
                                      <p>Đối với nhớt bán tổng hợp, bạn nên thay sau mỗi 1.500km. Với nhớt tổng hợp toàn phần (Full Synthetic) như Motul 7100 hay Liqui Moly, bạn có thể đi đến 2.500 - 3.000km.</p>", 
                            Thumbnail = "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png", 
                            CategoryId = blogCats[0].Id, 
                            IsPublished = true, 
                            CreatedDate = DateTime.Now 
                        }
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
