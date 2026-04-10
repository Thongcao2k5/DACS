using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Models;

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

            // 3. CLEAR OLD DATA (KEEP ROLES AND USERS)
            context.ProductImages.RemoveRange(context.ProductImages);
            context.ProductVariants.RemoveRange(context.ProductVariants);
            context.ProductReviews.RemoveRange(context.ProductReviews);
            context.CartItems.RemoveRange(context.CartItems);
            context.OrderItems.RemoveRange(context.OrderItems);
            context.InventoryTransactions.RemoveRange(context.InventoryTransactions);
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
                List<(string vName, decimal price, string sku)> variants)
            {
                var cat = await EnsureCategoryAsync(categoryName);
                var brand = await EnsureBrandAsync(brandName);

                var product = new Product
                {
                    ProductName = name,
                    CategoryId = cat.CategoryId,
                    BrandId = brand.BrandId,
                    Description = description,
                    Slug = name.ToLower().Replace(" ", "-").Replace("đ", "d").Replace("/", "-").Replace(".", "-"),
                    IsActive = true,
                    IsFeatured = true,
                    CreatedDate = DateTime.Now
                };

                context.Products.Add(product);
                await context.SaveChangesAsync();

                context.ProductImages.Add(new ProductImage
                {
                    ProductId = product.ProductId,
                    ImageUrl = imageUrl,
                    IsPrimary = true
                });

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

            // 5. SEED 100 PRODUCTS
            
            // 1. Dầu nhớt Motul 7100 10W40
            await AddProductAsync("Dầu nhớt Motul 7100 10W40", "Dầu nhớt động cơ", "Motul", "Dầu nhớt tổng hợp cao cấp giúp động cơ vận hành êm ái, tăng tuổi thọ máy. Thông số: Fully Synthetic, 10W40, API SN, JASO MA2.", "https://shop2banh.vn/images/thumbs/2024/08/nhot-motul-7100-10w40-1l-2346-slide-products-66c41032b2819.png", 
                new List<(string, decimal, string)> { ("1L", 320000, "MOTUL7100-1L"), ("1.5L", 450000, "MOTUL7100-15L") });

            // 2. Lốp Michelin Pilot Street 2
            await AddProductAsync("Lốp Michelin Pilot Street 2", "Lốp xe máy", "Michelin", "Lốp bám đường tốt, phù hợp đi phố và đi mưa. Chất liệu cao su cao cấp, tuổi thọ ~20.000km.", "https://cf.shopee.vn/file/vn-11134207-7ra0g-ma4aqo52ong852", 
                new List<(string, decimal, string)> { ("Trước 70/90-17", 550000, "MICHELIN-FRONT"), ("Sau 120/70-17", 750000, "MICHELIN-REAR") });

            // 3. Ắc quy GS GTZ6V
            await AddProductAsync("Ắc quy GS GTZ6V", "Ắc quy", "GS", "Ắc quy khô, bền, phù hợp nhiều dòng xe phổ thông. 12V - 5Ah.", "https://cf.shopee.vn/file/sg-11134201-7rdvv-lzzy638h94kic7", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 450000, "GS-GTZ6V") });

            // 4. Bugi NGK Iridium
            await AddProductAsync("Bugi NGK Iridium", "Bugi", "NGK", "Tăng hiệu suất đốt cháy, tiết kiệm nhiên liệu. Tuổi thọ ~40.000km.", "https://cf.shopee.vn/file/vn-11134207-7r98o-lzlek80h6rf1d1", 
                new List<(string, decimal, string)> { ("CR8EIX", 180000, "NGK-CR8"), ("CPR7EAIX", 160000, "NGK-CPR7") });

            // 5. Phanh đĩa Brembo
            await AddProductAsync("Phanh đĩa Brembo", "Hệ thống phanh", "Brembo", "Phanh cao cấp cho xe thể thao, lực bóp mạnh, an toàn cao. Chất liệu hợp kim nhôm.", "https://cf.shopee.vn/file/vn-11134207-7ra0g-m7ak1pozkt189a", 
                new List<(string, decimal, string)> { ("260mm", 2500000, "BREMBO-260"), ("300mm", 3200000, "BREMBO-300") });

            // 6. Gương chiếu hậu Rizoma
            await AddProductAsync("Gương chiếu hậu Rizoma", "Gương", "Rizoma", "Thiết kế thể thao, tăng tính thẩm mỹ cho xe. Chất liệu nhôm CNC.", "https://cf.shopee.vn/file/sg-11134201-7reno-m2ojl0r6c7ax1a", 
                new List<(string, decimal, string)> { ("Đen", 1200000, "RIZOMA-BLACK"), ("Bạc", 1250000, "RIZOMA-SILVER") });

            // 7. Lọc gió K&N
            await AddProductAsync("Lọc gió K&N", "Lọc gió", "K&N", "Tăng lưu lượng gió, cải thiện hiệu suất động cơ. Loại tái sử dụng, tuổi thọ >50.000km.", "https://cf.shopee.vn/file/sg-11134201-7rdwl-mbxeh3b9qhp611", 
                new List<(string, decimal, string)> { ("Cho Exciter 155", 900000, "KN-EX155"), ("Cho Winner X", 880000, "KN-WINNER") });

            // 8. Sên DID 428
            await AddProductAsync("Sên DID 428", "Sên (xích)", "DID", "Sên bền, chịu lực tốt, phù hợp xe côn tay và xe số. Thép cường lực, tuổi thọ ~25.000km.", "https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRzXgshMHYCXpqqWm4atxJMCWJvDSZrGef87Oo56MiOK_GkrlxThuFPRtHh2lfKhvMK-ahPzPP1It952Xyw_GN2FAAtsrO8ZUH080Eg5Wz5iZs7D6BR1-dqIrgbkZPrF-T43_Jr8Q&usqp=CAc", 
                new List<(string, decimal, string)> { ("428 Tiêu chuẩn", 350000, "DID-428"), ("428 Vàng Gold", 550000, "DID-428-GOLD") });

            // 9. Nhông sên dĩa Recto
            await AddProductAsync("Nhông sên dĩa Recto", "Bộ nhông sên dĩa", "Recto", "Bộ truyền động tối ưu cho xe côn tay. Thép hợp kim độ bền cao.", "https://cf.shopee.vn/file/sg-11134201-22110-nv34i5b53cjvb4", 
                new List<(string, decimal, string)> { ("Cho Exciter 155", 950000, "RECTO-EX155"), ("Cho Winner X", 920000, "RECTO-WINNER") });

            // 10. Tay thắng CRG
            await AddProductAsync("Tay thắng CRG", "Tay thắng", "CRG", "Tay thắng CNC cao cấp, điều chỉnh được độ xa gần. Tính năng gập chống gãy.", "https://cf.shopee.vn/file/vn-11134201-820l4-men2wvvtpa115e", 
                new List<(string, decimal, string)> { ("Đen", 1800000, "CRG-BLACK"), ("Đỏ", 1850000, "CRG-RED") });

            // 11. Đèn LED trợ sáng L4X
            await AddProductAsync("Đèn LED trợ sáng L4X", "Đèn trợ sáng", "L4X", "Tăng độ sáng khi đi đêm, đi tour. Công suất 40W, ánh sáng trắng.", "https://cf.shopee.vn/file/sg-11134201-7rd3m-lvevl9p97rhuf4", 
                new List<(string, decimal, string)> { ("1 bóng", 500000, "L4X-1"), ("2 bóng", 900000, "L4X-2") });

            // 12. Phuộc sau YSS
            await AddProductAsync("Phuộc sau YSS", "Giảm xóc sau", "YSS", "Giảm xóc êm ái, phù hợp đi phố và đi tour. Loại Mono-shock tải trọng cao.", "https://cf.shopee.vn/file/4c229fb05edf79352b048fe50e381a1e", 
                new List<(string, decimal, string)> { ("Cho Exciter", 2800000, "YSS-EX"), ("Cho Winner", 2700000, "YSS-WIN") });

            // 13. Bộ nồi độ SSS
            await AddProductAsync("Bộ nồi độ SSS", "Bộ nồi", "SSS", "Tăng tốc nhanh, bốc hơn. Hợp kim chịu nhiệt cao cấp.", "https://dochoixemay68.com/wp-content/uploads/2022/10/NOI.jpg", 
                new List<(string, decimal, string)> { ("Full bộ", 2200000, "SSS-FULL") });

            // 14. Cùm tăng tốc Domino
            await AddProductAsync("Cùm tăng tốc Domino", "Tay ga nhanh", "Domino", "Rút ga nhanh hơn, phù hợp xe độ. Nhôm CNC chuyên dụng.", "https://cf.shopee.vn/file/vn-11134207-7qukw-levpnwo86t7b40", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1200000, "DOMINO-STD") });

            // 15. Kính chắn gió Puig
            await AddProductAsync("Kính chắn gió Puig", "Kính chắn gió", "Puig", "Giảm gió tạt khi chạy tốc độ cao. Chất liệu nhựa ABS bền bỉ.", "https://imgwebikenet-8743.kxcdn.com/catalogue/images/102977/3490H_1.jpg", 
                new List<(string, decimal, string)> { ("Trong suốt", 1500000, "PUIG-CLEAR"), ("Đen khói", 1600000, "PUIG-SMOKE") });

            // 16. Pad biển số CNC
            await AddProductAsync("Pad biển số CNC", "Pad biển số", "CNC Racing", "Trang trí, tăng tính thẩm mỹ. Nhôm CNC sắc sảo.", "https://cf.shopee.vn/file/sg-11134201-7rceo-m6jj7vpx3md782", 
                new List<(string, decimal, string)> { ("Đen", 300000, "PAD-BLACK"), ("Đỏ", 320000, "PAD-RED") });

            // 17. Tay dắt sau Biker
            await AddProductAsync("Tay dắt sau Biker", "Tay dắt", "Biker", "Hỗ trợ dắt xe, trang trí. Nhôm CNC chắc chắn.", "https://yamaha-motor.com.vn/wp/wp-content/uploads/2023/12/2-4.jpg", 
                new List<(string, decimal, string)> { ("Cho Exciter", 600000, "BIKER-EX"), ("Cho Winner", 580000, "BIKER-WIN") });

            // 18. Đĩa tải CNC
            await AddProductAsync("Đĩa tải CNC", "Đĩa tải", "Phụ tùng truyền động", "Truyền động bánh sau, thép bền bỉ.", "https://down-vn.img.susercontent.com/file/0f60a595135247008b0ca02d5b17ad3d", 
                new List<(string, decimal, string)> { ("40T", 400000, "DISC-40"), ("42T", 420000, "DISC-42") });

            // 19. Ốc titan GR5
            await AddProductAsync("Ốc titan GR5", "Ốc xe", "Titanium", "Trang trí, siêu nhẹ, chất liệu Titanium GR5.", "https://cf.shopee.vn/file/a4a30ade00b13b76af4de537fe741bf1", 
                new List<(string, decimal, string)> { ("Bộ 10 con", 250000, "TITAN-10"), ("Bộ 20 con", 450000, "TITAN-20") });

            // 20. Pô độ Akrapovic
            await AddProductAsync("Pô độ Akrapovic", "Ống xả", "Akrapovic", "Tăng âm thanh, hiệu suất. Chất liệu Titanium cực nhẹ.", "https://cf.shopee.vn/file/vn-11134207-7ra0g-m8h60r63apfo85", 
                new List<(string, decimal, string)> { ("Slip-on", 5500000, "AKRA-SLIP"), ("Full system", 12000000, "AKRA-FULL") });

            // 21. Lọc nhớt Honda
            await AddProductAsync("Lọc nhớt Honda", "Lọc nhớt", "Honda", "Giúp lọc cặn bẩn trong dầu, bảo vệ động cơ. Giấy lọc cao cấp.", "https://cf.shopee.vn/file/6f338502d1b4d4957219552d35117307", 
                new List<(string, decimal, string)> { ("Cho Winner", 90000, "LOCNHOT-WIN"), ("Cho Air Blade", 85000, "LOCNHOT-AB") });

            // 22. Dây ga UMA Racing
            await AddProductAsync("Dây ga UMA Racing", "Dây ga", "UMA Racing", "Dây ga nhẹ, tăng độ nhạy. Cáp thép không gỉ.", "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcR0JJkndkB2MOnw71VD4-crw-RqTrWBvjKYJCIG_WTWbLbEdWOGHXi0gKOr057YBrYtRASwF7YohwzSEMSEM2ZnXtvYs60sEDyfKVVH2wzMJTZI3u02r-Krz6Q_7yimrz2XH_PDhw&usqp=CAc", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 250000, "UMA-GA") });

            // 23. Heo dầu Brembo M4
            await AddProductAsync("Heo dầu Brembo M4", "Heo dầu", "Brembo", "Tăng lực phanh, độ an toàn cao. 4 piston đối xứng.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/477/832/products/1-8e89a2e3-ab89-45f8-a731-8952e3f845c1.png?v=1749883483687", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 6500000, "BREMBO-M4") });

            // 24. Đĩa thắng Galfer
            await AddProductAsync("Đĩa thắng Galfer", "Đĩa phanh", "Galfer", "Tản nhiệt tốt, bền bỉ, đường kính 260mm.", "https://cf.shopee.vn/file/vn-11134207-7r98o-lmbg3cqp77j368", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 2200000, "GALFER-260") });

            // 25. Bố thắng Elig
            await AddProductAsync("Bố thắng Elig", "Má phanh", "Elig", "Bám tốt, ít mòn, chất liệu hợp kim cao cấp.", "https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSMiJo0rivfTLtlZWq5xXfrZZUSSgs4f7EMbJbpYup7QnqZ7XYR5Sx23xaeHTkatYRst5qfuN7AkLMrKMIl7V6x8bU9wlaUwO4eyVHlXbwkNxlanv-cTutGvflCLKNlYvwgc4LT09Q&usqp=CAc", 
                new List<(string, decimal, string)> { ("Trước", 300000, "ELIG-F"), ("Sau", 280000, "ELIG-R") });

            // 26. Tay côn TWM
            await AddProductAsync("Tay côn TWM", "Tay côn", "TWM", "Êm, dễ bóp, chất liệu nhôm CNC cao cấp.", "https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSlIjQEf8D0S8RP6FlX0QpjJPl5KAc0XWZBwXWmdfBjuX0KKc25D-j8ufpXFD2KOQUDzxTCbMK0PT5TGNtdd8b2rQHphyGoB6Tbgkqf53Ih1CaQzbt8vGfiTsFt-RGqkpnEeQQzig&usqp=CAc", 
                new List<(string, decimal, string)> { ("Đen", 1500000, "TWM-BLACK") });

            // 27. Dè chắn bùn Carbon
            await AddProductAsync("Dè chắn bùn Carbon", "Dè", "Carbon", "Nhẹ, đẹp, chất liệu Carbon Fiber thật.", "https://cf.shopee.vn/file/sg-11134201-821f5-mhaafgv1qebud1", 
                new List<(string, decimal, string)> { ("Trước", 800000, "DE-F"), ("Sau", 900000, "DE-R") });

            // 28. Chắn xích CNC
            await AddProductAsync("Chắn xích CNC", "Chắn xích", "CNC Racing", "Bảo vệ xích, chất liệu nhôm CNC.", "https://qawing.com/wp-content/uploads/2022/05/QAWG23A00590.jpg", 
                new List<(string, decimal, string)> { ("Đen", 450000, "CX-BLACK") });

            // 29. Cổ pô Titan
            await AddProductAsync("Cổ pô Titan", "Cổ pô", "Titanium", "Tăng hiệu suất, giải nhiệt cực nhanh, chất liệu Titanium.", "https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcTKPPOZsqcI2byKcLbSvAAwtEWXlHHlYV1XuVjv-xJJKCqoLaRu0Q_wJRQJJAZLjOKJQxrwCfkNiiTLD_eAmWfR-ee_IazIhQ7t8wMkurvKvIcZ70v0Q544iAdbjIhSQVAqLlJVpsg&usqp=CAc", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 2000000, "COP-TI") });

            // 30. Đồng hồ Koso
            await AddProductAsync("Đồng hồ Koso", "Đồng hồ điện tử", "Koso", "Hiển thị tốc độ, vòng tua, loại LCD hiện đại.", "https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQpGVpwDITKMs6EUQteDc4mpNHmfhfgiS1f1aCMnZrx4FSqJR8NW4buSTZI_7icMgcQpO7KjQbBgZTyCMjRm0N8GuSu7EkrVxlvYxCvojJnY9BXzU1d6nl10ZUvPGYDq3SCjxfPkHg&usqp=CAc", 
                new List<(string, decimal, string)> { ("Mini", 1800000, "KOSO-MINI"), ("Full", 3500000, "KOSO-FULL") });

            // 31. Gác chân Biker
            await AddProductAsync("Gác chân Biker", "Gác chân", "Biker", "Chống trượt, nhôm CNC bền bỉ.", "https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRTBfmCdjsr1t_vglxVw93UGd3LnHe_xDpx0Kjcv7JypfZnK2nvGVxlJsmq2ktW126TA6aqQpvVn_KPKRgntkIe0HOknShvJFSsXq77hcaf67NTUK0Wwy86cfikPYN45gBr_0ceBdw&usqp=CAc", 
                new List<(string, decimal, string)> { ("Đen", 500000, "GC-BLACK") });

            // 32. Bình dầu Rizoma
            await AddProductAsync("Bình dầu Rizoma", "Bình dầu", "Rizoma", "Trang trí, chất liệu nhôm CNC.", "https://cdn.doxemay.com/2024/05/binh-dau-rizoma-wave-360-slide-products-5707533fcdd0b.jpg", 
                new List<(string, decimal, string)> { ("Tròn", 700000, "BD-ROUND"), ("Vuông", 750000, "BD-SQUARE") });

            // 33. Lưới bảo vệ két nước
            await AddProductAsync("Lưới bảo vệ két nước", "Bảo vệ két nước", "Honda", "Tránh đá văng, thép không gỉ.", "https://autostyle.vn/wp-content/uploads/2025/03/Luoi-Che-ket-Nuoc-Nhap-Thai-Cho-Xe-Ford-Next-Gen-3.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 350000, "KET-STD") });

            // 34. Dây dầu HEL
            await AddProductAsync("Dây dầu HEL", "Dây dầu", "HEL", "Tăng lực phanh, lõi thép cao cấp.", "https://biraceshop.com/watermark/product/560x520x1/upload/product/f50b84ec-a272-4923-8ee5-a41f1ffb22cd-8189.jpeg", 
                new List<(string, decimal, string)> { ("Trước", 600000, "HEL-F"), ("Sau", 550000, "HEL-R") });

            // 35. Công tắc Domino
            await AddProductAsync("Công tắc Domino", "Công tắc", "Domino", "Điều khiển tiện lợi, chất liệu nhựa + kim loại.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/477/832/products/1-43d13d09-ea46-45d8-9759-4278e268585e.png?v=1752205421260", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 900000, "DOM-SW") });

            // 36. Bình xăng con UMA
            await AddProductAsync("Bình xăng con UMA", "Bình xăng con", "UMA Racing", "Tăng hiệu suất, đường kính 28mm.", "https://bizweb.dktcdn.net/thumb/grande/100/444/341/products/5d17e08fd43b9fcd91577e84ea41c987-tn-jpeg-1685098423622.jpg?v=1685098426203", 
                new List<(string, decimal, string)> { ("28mm", 1700000, "UMA-28") });

            // 37. Ốp pô Carbon
            await AddProductAsync("Ốp pô Carbon", "Ốp pô", "Carbon", "Chống nóng, thời trang, Carbon Fiber thật.", "https://fmanracing.com/images/op-chong-nong-carbon-lon-dai-1-1608433494911.jpeg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 650000, "OPPO-C") });

            // 38. Móc treo đồ CNC
            await AddProductAsync("Móc treo đồ CNC", "Móc treo", "Honda", "Treo đồ tiện lợi, nhôm CNC.", "https://shop2banh.vn/images/thumbs/2022/11/moc-treo-do-cnc-cho-honda-sh-1954-slide-products-636339ae0f583.jpg", 
                new List<(string, decimal, string)> { ("Đen", 120000, "MOC-BLACK") });

            // 39. Đèn xi nhan LED
            await AddProductAsync("Đèn xi nhan LED", "Xi nhan", "LED", "Nháy sáng rõ, tiết kiệm điện.", "https://img.lazcdn.com/g/p/8b683eeeb455082f66406f8256d78bd6.jpg_720x720q80.jpg", 
                new List<(string, decimal, string)> { ("Trước", 200000, "XN-F"), ("Sau", 200000, "XN-R") });

            // 40. Ốp bảo vệ tay lái
            await AddProductAsync("Ốp bảo vệ tay lái", "Bảo vệ tay lái", "Honda", "Chống gãy, nhựa ABS siêu bền.", "https://trangtrixemayhoangtri.com/upload/product/747187187298.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 300000, "TAY-OP") });

            // 41. Dây curoa Bando
            await AddProductAsync("Dây curoa Bando", "Dây curoa", "Bando", "Truyền động xe ga, cao su cao cấp siêu bền.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/419/633/products/day-cua-roa-bando-01.png?v=1702262036117", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 450000, "BANDO") });

            // 42. Bi nồi Dr.Pulley
            await AddProductAsync("Bi nồi Dr.Pulley", "Bi nồi", "Dr.Pulley", "Tăng tốc, trọng lượng 10g.", "https://imgwebikenet-8743.kxcdn.com/catalogue/18903/20-15-001.jpg", 
                new List<(string, decimal, string)> { ("10g", 300000, "DRP-10") });

            // 43. Chuông nồi CNC
            await AddProductAsync("Chuông nồi CNC", "Chuông nồi", "Honda", "Tản nhiệt tốt, thép siêu cứng.", "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lxyycuzd7s2h55", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 600000, "CHUONG") });

            // 44. Lò xo nồi
            await AddProductAsync("Lò xo nồi", "Lò xo", "Honda", "Tăng độ bám, độ cứng cao.", "https://product.hstatic.net/200000692635/product/_noi_sonic_150r__winner__cbr_150r__cb_150r_chinh_hang_honda_1_bo_4_cai_0e70bd8e1ff84b059f97b6d2d0ccf4e1_master.png", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 150000, "LOXO") });

            // 45. Dầu phanh DOT4
            await AddProductAsync("Dầu phanh DOT4", "Dầu phanh", "HPK", "Truyền lực phanh, tiêu chuẩn DOT4.", "https://hpk.vn/wp-content/uploads/2024/06/a3-12.png", 
                new List<(string, decimal, string)> { ("500ml", 120000, "DOT4") });

            // 46. Nắp nhớt CNC
            await AddProductAsync("Nắp nhớt CNC", "Nắp nhớt", "Honda", "Trang trí, nhôm CNC.", "https://cbcworkshop.com/wp-content/uploads/2025/06/CNC-Nap-nhot-Triumph-3.webp", 
                new List<(string, decimal, string)> { ("Đỏ", 150000, "NAP-RED"), ("Xanh", 150000, "NAP-BLUE") });

            // 47. Cảm biến tốc độ
            await AddProductAsync("Cảm biến tốc độ", "Sensor", "Honda", "Đo tốc độ điện tử.", "https://binhduongngoisao.vn/wp-content/uploads/2025/03/ce1baa3m20bie1babfn20te1bb91c20c491e1bb9920xe-1.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 500000, "SPEED") });

            // 48. Bộ dây điện độ
            await AddProductAsync("Bộ dây điện độ", "Dây điện", "Honda", "Dùng cho xe độ, lõi đồng.", "https://down-vn.img.susercontent.com/file/ed8eb637d3559c21031be82e19c84a1c", 
                new List<(string, decimal, string)> { ("Full bộ", 700000, "DAYDIEN") });

            // 49. Khóa chống trộm Smart Lock
            await AddProductAsync("Khóa chống trộm Smart Lock", "Khóa", "Smart Lock", "Chống trộm thông minh.", "https://down-vn.img.susercontent.com/file/sg-11134201-22120-js20aq4s2qkv53", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1200000, "LOCK") });

            // 50. Camera hành trình xe máy
            await AddProductAsync("Camera hành trình xe máy", "Camera", "DJI", "Ghi hình khi di chuyển, Full HD.", "https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/m/a/may-quay-chong-rung-dji-osmo-pocket-3-advanced-4k_1.png", 
                new List<(string, decimal, string)> { ("1 cam", 1500000, "CAM1"), ("2 cam", 2500000, "CAM2") });

            // 51. Lọc gió DNA
            await AddProductAsync("Lọc gió DNA", "Lọc gió", "DNA", "Tăng hiệu suất hút gió, sợi tổng hợp.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRy2HpyvvVBGIvMQP-nYInazzoyp96ar_hoAA&s", 
                new List<(string, decimal, string)> { ("Cho Exciter", 850000, "DNA-EX"), ("Cho Winner", 830000, "DNA-WIN") });

            // 52. Bánh mâm RCB
            await AddProductAsync("Bánh mâm RCB", "Mâm xe", "RCB", "Tăng thẩm mỹ và độ cứng, hợp kim nhôm.", "https://congtuan.vn/upload/images/2019/10/360x360-1571035975-mamrcb5cayexciter.jpg", 
                new List<(string, decimal, string)> { ("17 inch", 6500000, "RCB-17") });

            // 53. Pô SC Project
            await AddProductAsync("Pô SC Project", "Ống xả", "SC Project", "Âm thanh lớn, thể thao, Titanium.", "https://drsmotor.vn/upload/product/z4276763258536afaca5fce871405db4b1a3e9cfd055b9-3574.jpg", 
                new List<(string, decimal, string)> { ("Slip-on", 7500000, "SCP-SLIP") });

            // 54. Heo dầu Nissin
            await AddProductAsync("Heo dầu Nissin", "Heo dầu", "Nissin", "Phanh ổn định, 2 piston.", "https://product.hstatic.net/1000375176/product/img_7814_1ab7de96f44149de99e01ba0992ef14a_master.png", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1800000, "NISSIN-2P") });

            // 55. Đĩa tải nhôm CNC
            await AddProductAsync("Đĩa tải nhôm CNC", "Đĩa tải", "Honda", "Nhẹ, tăng tốc, nhôm CNC.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRq-KPAu9Szb3xaSHLl6zp0ncBIJTB1OnwGlQ&s", 
                new List<(string, decimal, string)> { ("40T", 600000, "CNC-40") });

            // 56. Tay thắng Brembo RCS
            await AddProductAsync("Tay thắng Brembo RCS", "Tay thắng", "Brembo", "Cao cấp, lực bóp mạnh, nhôm CNC.", "https://detailingnation.vn/cdn/shop/files/rcs14.jpg?v=1692209764", 
                new List<(string, decimal, string)> { ("19RCS", 6800000, "RCS19") });

            // 57. Cùm côn Brembo
            await AddProductAsync("Cùm côn Brembo", "Cùm côn", "Brembo", "Êm, chính xác, nhôm CNC.", "https://www.tinomotor.vn/storage/pagedata/100113/img/images/product/4361_455147990_2402565639946622_5370200924436166458_n.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 5500000, "BREMBO-CL") });

            // 58. Bộ dây thắng HEL Performance
            await AddProductAsync("Bộ dây thắng HEL Performance", "Dây thắng", "HEL", "Tăng độ ổn định, lõi thép.", "https://bbracing.vn/watermark/product/900x600x6/upload/product/1-2-6492.jpg", 
                new List<(string, decimal, string)> { ("Full bộ", 1200000, "HEL-FULL") });

            // 59. Két nước độ
            await AddProductAsync("Két nước độ", "Két nước", "Honda", "Làm mát tốt hơn, nhôm.", "https://img.lazcdn.com/g/p/d0ae4a03b48f79551e36c629970ef2bd.jpg_720x720q80.jpg", 
                new List<(string, decimal, string)> { ("Lớn", 1800000, "RAD-BIG") });

            // 60. Quạt két nước
            await AddProductAsync("Quạt két nước", "Quạt làm mát", "Honda", "Hỗ trợ làm mát động cơ, 12V.", "https://down-vn.img.susercontent.com/file/15237d49bd76d9e0e7f86eb96aad9b6d", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 400000, "FAN") });

            // 61. Pát biển số rút gọn
            await AddProductAsync("Pát biển số rút gọn", "Pát biển số", "Honda", "Gọn gàng, thể thao, nhôm CNC.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToRv7jAfNMkW_xnALIw7Lw4X_uMZ1PNBPjIQ&s", 
                new List<(string, decimal, string)> { ("Đen", 350000, "PAT-BIEN") });

            // 62. Đèn hậu LED
            await AddProductAsync("Đèn hậu LED", "Đèn hậu", "LED", "Sáng rõ, tiết kiệm điện.", "https://xenangtrungquoc.net/wp-content/uploads/2022/12/den-hau-xe-nang.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 300000, "HAU-LED") });

            // 63. Baga sau
            await AddProductAsync("Baga sau", "Baga", "Givi", "Chở đồ, thép.", "https://shopgivi.com/wp-content/uploads/2024/01/BAGA-SAU-XE-YAMAHA-PG-1-2.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 450000, "BAGA") });

            // 64. Thùng Givi
            await AddProductAsync("Thùng Givi", "Thùng chứa đồ", "Givi", "Tiện lợi đi xa, dung tích 30L.", "https://vivuphuot.com/wp-content/uploads/2022/10/410_20180201021412.jpg", 
                new List<(string, decimal, string)> { ("30L", 1200000, "GIVI-30") });

            // 65. Pad chống đổ
            await AddProductAsync("Pad chống đổ", "Pad chống đổ", "Honda", "Bảo vệ xe khi ngã, nhựa + kim loại.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/381/742/products/8348dd3e-a046-45da-bf0e-74e8eee7f331.jpg?v=1734754258180", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 500000, "PAD") });

            // 66. Thanh chống đổ
            await AddProductAsync("Thanh chống đổ", "Khung chống đổ", "Honda", "Bảo vệ thân xe, thép.", "https://www.vnride.com/wp-content/uploads/2023/12/Chong-do-khung-Quay-tren-cho-HONDA-XL750-Transalp-7.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1000000, "FRAME") });

            // 67. Ốp sườn carbon
            await AddProductAsync("Ốp sườn carbon", "Ốp sườn", "Carbon", "Trang trí, carbon thật.", "https://tinomotor.vn/storage/pagedata/100113/img/images/product/2524_%E1%BB%90p%20s%C6%B0%E1%BB%9Dn%205tr8.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 1200000, "SUON") });

            // 68. Đèn pha LED
            await AddProductAsync("Đèn pha LED", "Đèn pha", "LED", "Tăng sáng.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBpm5mEo8mPen3LfGDuXlhYfq4gQGSIPKJsg&s", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 700000, "PHA") });

            // 69. Bóng đèn Philips
            await AddProductAsync("Bóng đèn Philips", "Bóng đèn", "Philips", "Ánh sáng tốt, Halogen H4.", "https://bizweb.dktcdn.net/100/152/658/products/philips-halogen-xv-pro150-h4.jpg?v=1639041852870", 
                new List<(string, decimal, string)> { ("H4", 150000, "PHILIPS") });

            // 70. Dây curoa BRT
            await AddProductAsync("Dây curoa BRT", "Dây curoa", "BRT", "Bền hơn, cao su.", "https://product.hstatic.net/1000375176/product/img_8109_b8c9e62d5d9e41bcbee846445c4f7da3_master.png", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 600000, "BRT") });

            // 71. Bộ nồi BRT
            await AddProductAsync("Bộ nồi BRT", "Bộ nồi", "BRT", "Tăng tốc, hợp kim.", "https://cdn.hstatic.net/products/1000375176/dsc05817_1aa853659144480b9031486c6f555f10_master.jpg", 
                new List<(string, decimal, string)> { ("Full", 2500000, "BRT-NOI") });

            // 72. ECU độ
            await AddProductAsync("ECU độ", "ECU", "BRT", "Tăng hiệu suất, điện tử.", "https://bizweb.dktcdn.net/100/431/877/articles/05-e2092a1eb71e4e79bcd161505265716a-grande.jpg?v=1627279057247", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 3500000, "ECU") });

            // 73. IC độ
            await AddProductAsync("IC độ", "IC", "Honda", "Tăng vòng tua, điện tử.", "https://phutungthuanthanh.com/wp-content/uploads/2019/03/icex1.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 800000, "IC") });

            // 74. Bộ mobin sườn
            await AddProductAsync("Bộ mobin sườn", "Mobin", "Honda", "Tăng đánh lửa, 12V.", "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ls87m51qtrycec", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 500000, "MOBIN") });

            // 75. Lọc xăng
            await AddProductAsync("Lọc xăng", "Lọc xăng", "Honda", "Lọc tạp chất, nhựa.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/459/279/products/loc-xang2-jpg.webp?v=1675588237987", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 100000, "LOCXANG") });

            // 76. Kim phun xăng
            await AddProductAsync("Kim phun xăng", "Kim phun", "Honda", "Tăng hiệu suất, điện tử.", "https://vietnamgarage.vn/wp-content/uploads/2023/11/Kim-Phun-Nhien-Lieu-O-to-2.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 700000, "INJECTOR") });

            // 77. Bơm xăng điện
            await AddProductAsync("Bơm xăng điện", "Bơm xăng", "Honda", "Cung cấp nhiên liệu, 12V.", "https://vapgroup.com.vn/public_folder/files_upload/202410/56ad5fb7840a5d8db56606bbd0855e6a.webp", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 900000, "PUMP") });

            // 78. Lọc nhớt CNC
            await AddProductAsync("Lọc nhớt CNC", "Lọc nhớt", "Honda", "Tái sử dụng, nhôm.", "https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m53xu8dz56v726", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 400000, "LOC-CNC") });

            // 79. Ốp bình xăng
            await AddProductAsync("Ốp bình xăng", "Ốp", "Honda", "Trang trí, nhựa.", "https://hoimexe.com/wp-content/uploads/2023/10/op-binh-xang-honda-rebel-300-500.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 350000, "OPXANG") });

            // 80. Tem xe
            await AddProductAsync("Tem xe", "Tem", "Decal", "Trang trí, decal.", "https://inminhkhang.com/wp-content/uploads/2023/11/tem-dan-xe-4.webp", 
                new List<(string, decimal, string)> { ("Full bộ", 500000, "TEM") });

            // 81. Dán keo xe
            await AddProductAsync("Dán keo xe", "Keo bảo vệ", "Honda", "Chống trầy, trong suốt.", "https://bizweb.dktcdn.net/100/460/221/files/dan-keo-xe-bao-nhieu-tien-3.jpg?v=1709548025516", 
                new List<(string, decimal, string)> { ("Full xe", 1000000, "KEO") });

            // 82. Bọc yên xe
            await AddProductAsync("Bọc yên xe", "Yên", "Da", "Êm hơn, da.", "https://3mp.vn/wp-content/uploads/2024/07/yen-xe-wave-9-600x450-1.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 400000, "YEN") });

            // 83. Gù tay lái
            await AddProductAsync("Gù tay lái", "Gù", "Honda", "Chống rung, kim loại.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/381/742/products/68dc3475-0ea6-4f26-b232-92b39a672b63.jpg?v=1708933977430", 
                new List<(string, decimal, string)> { ("Đen", 250000, "GU") });

            // 84. Tay nắm cao su
            await AddProductAsync("Tay nắm cao su", "Tay nắm", "Honda", "Chống trượt, cao su.", "https://www.tinomotor.vn/storage/pagedata/100113/img/images/product/594_1.JPG", 
                new List<(string, decimal, string)> { ("Đen", 120000, "GRIP") });

            // 85. Ốp tay thắng
            await AddProductAsync("Ốp tay thắng", "Ốp", "Honda", "Trang trí, nhựa.", "https://file.hstatic.net/1000238613/file/3_d373c2f4266546a3a78dede3267f47ed.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 100000, "OPTAY") });

            // 86. Công tắc phụ
            await AddProductAsync("Công tắc phụ", "Công tắc", "Honda", "Bật/tắt phụ kiện, điện.", "https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSsHhYHoK3KVWXxSZtHVyeSjOKka_J94-Xp55q7p7gfeUwLbM4iVYbtSJrdJYaaOAwyZ8iJ5zozxvsYNNJSl_19EnSN1sozOcR9KmOWoV8I&usqp=CAc", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 80000, "SW") });

            // 87. Sạc USB xe máy
            await AddProductAsync("Sạc USB xe máy", "Sạc", "Honda", "Sạc điện thoại, 5V.", "https://bizweb.dktcdn.net/100/356/047/files/e3d71ca7-1216-48f8-9354-4a055860f14a-jpeg.jpg?v=1632802505478", 
                new List<(string, decimal, string)> { ("2 cổng", 200000, "USB") });

            // 88. Đồng hồ áp suất lốp
            await AddProductAsync("Đồng hồ áp suất lốp", "Đồng hồ", "TPMS", "Đo áp suất điện tử.", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-IIqvH338hSx5IxrIsGafjRwd65DrGQLaXw&s", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 600000, "TPMS") });

            // 89. Bơm mini xe máy
            await AddProductAsync("Bơm mini xe máy", "Bơm", "Honda", "Bơm lốp, 12V.", "https://boba.vn/static/san-pham/doi-song/qua-tang-hang-thu-cong/moc-khoa/bom-hoi-mini-xe-may/maybomhoi.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 350000, "PUMP-MINI") });

            // 90. Khóa đĩa chống trộm
            await AddProductAsync("Khóa đĩa chống trộm", "Khóa", "Honda", "Bảo vệ xe, kim loại.", "https://cuahangkhoa.com/upload/files/sanpham/102.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 250000, "LOCK-DISC") });

            // 91. Chuông báo động
            await AddProductAsync("Chuông báo động", "Báo động", "Honda", "Chống trộm, âm thanh lớn.", "https://cdn.chiaki.vn/unsafe/0x480/left/top/smart/filters:quality(75)/https://chiaki.vn/upload/product-gallery/118220/chuong-bao-dong-chong-trom-xe-may-ctfast-ks-sp22r-1720500684118220.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 300000, "ALARM") });

            // 92. Áo trùm xe
            await AddProductAsync("Áo trùm xe", "Phụ kiện", "Honda", "Bảo vệ xe, chống nước.", "https://vn-test-11.slatic.net/p/52e3569ab5483aabca8f3b038d350445.jpg", 
                new List<(string, decimal, string)> { ("Size L", 200000, "COVER") });

            // 93. Giá đỡ điện thoại
            await AddProductAsync("Giá đỡ điện thoại", "Giá đỡ", "Honda", "Gắn điện thoại, nhựa.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/345/516/products/gia-do-dien-thoai-hop-kim-nhom-cao-cap-1.jpg?v=1702535977867", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 150000, "HOLDER") });

            // 94. Kính chống chói
            await AddProductAsync("Kính chống chói", "Kính", "Honda", "Giảm chói, nhựa.", "https://img.lazcdn.com/g/p/8065c9a96c7b6084e93308e9277c6498.jpg_720x720q80.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 180000, "KINH") });

            // 95. Dây ràng đồ
            await AddProductAsync("Dây ràng đồ", "Dây", "Honda", "Cố định đồ, cao su.", "https://media.loveitopcdn.com/38164/day-thun-rang-do-xe-may-moc-thep.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 50000, "DAY") });

            // 96. Bọc tay lái mùa đông
            await AddProductAsync("Bọc tay lái mùa đông", "Bọc", "Honda", "Giữ ấm, vải.", "https://down-vn.img.susercontent.com/file/sg-11134201-7rblx-lo7ysxfgbmmp36", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 120000, "BOCTAY") });

            // 97. Chắn gió tay lái
            await AddProductAsync("Chắn gió tay lái", "Chắn gió", "Honda", "Chắn gió, nhựa.", "https://down-vn.img.susercontent.com/file/efe66264a364e21aaed83c5deec0869c", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 200000, "CHANGIO") });

            // 98. Lót sàn xe
            await AddProductAsync("Lót sàn xe", "Lót sàn", "Honda", "Chống bẩn, cao su.", "https://trangtrixemayhoangtri.com/upload/product/556962438432.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 180000, "LOT") });

            // 99. Bộ vệ sinh sên
            await AddProductAsync("Bộ vệ sinh sên", "Dụng cụ", "Honda", "Vệ sinh xích, full bộ.", "https://shop2banh.vn/images/thumbs/tags/ve-sinh-sen-va-boi-tron-395.jpg", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 250000, "CLEAN") });

            // 100. Dung dịch vệ sinh xe
            await AddProductAsync("Dung dịch vệ sinh xe", "Dung dịch", "Honda", "Làm sạch xe, 500ml.", "https://bizweb.dktcdn.net/thumb/1024x1024/100/360/787/products/1509.jpg?v=1564731972467", 
                new List<(string, decimal, string)> { ("Tiêu chuẩn", 100000, "WASH") });
        }
    }
}
