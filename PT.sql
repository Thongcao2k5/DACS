USE MotorcycleShopDB;
GO
BEGIN TRANSACTION;
DECLARE @Pid INT, @Vid INT, @Aid INT, @ValId INT, @CatId INT, @BrandId INT;

-- Initialize Categories

-- CATEGORY: Dầu nhớt & Bôi trơn
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Dầu nhớt & Bôi trơn') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Dầu nhớt & Bôi trơn', 'dau-nhot-boi-tron', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Dầu nhớt & Bôi trơn');

-- Product: Dầu nhớt Motul 7100 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motul') INSERT INTO Brands (BrandName) VALUES (N'Motul');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Motul');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Motul 7100 10W40', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay, xe thể thao</p><p>Dầu nhớt Motul 7100 10W40 là dòng dầu nhớt tổng hợp cao cấp nổi tiếng đến từ Pháp, được phát triển dành riêng cho các dòng xe côn tay và xe thể thao vận hành ở hiệu suất cao. Sản phẩm sử dụng công nghệ Ester độc quyền giúp tạo lớp màng bôi trơn bền chắc, giảm tối đa ma sát giữa các chi tiết máy và bảo vệ động cơ trong điều kiện hoạt động liên tục ở nhiệt độ cao. Nhờ khả năng ổn định độ nhớt cực tốt, dầu giúp động cơ vận hành êm ái, sang số nhẹ và hạn chế nóng máy khi đi đường dài hoặc chạy tốc độ cao.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic (100% tổng hợp)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN/SP, JASO MA2</li><li>Dung tích: 1L và 1.1L, 1.3L, 1.5L</li><li>Chu kỳ thay nhớt: 3000 – 5000 km</li><li>Tính năng: Giảm ma sát, bảo vệ hộp số, làm mát động cơ</li><li>Xuất xứ: Pháp</li></ul>', 'dau-nhot-motul-7100-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mg4vpmxvjcb0da@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MOTUL7100-1L', N'1L', 320000, 384000, 256000, 70, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mg4vpmxvjcb0da@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MOTUL7100-15L', N'1.5L', 450000, 540000, 360000, 50, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mg4vpmxvjcb0da@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.5L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.5L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.5L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m77v0lyjxo1oc7@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m77jwjyrie8xd2@resize_w900_nl.webp', 0, 2);

-- Product: Dầu nhớt Fuchs Silkolene Pro 4 10W40 XP
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Fuchs (Đức)') INSERT INTO Brands (BrandName) VALUES (N'Fuchs (Đức)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Fuchs (Đức)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Fuchs Silkolene Pro 4 10W40 XP', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe số, xe côn tay, xe PKL</p><p>Fuchs Silkolene Pro 4 10W40 XP sử dụng công nghệ XP đột phá giúp tăng cường sức mạnh động cơ và tiết kiệm nhiên liệu. Với khả năng chống mài mòn vượt trội và ổn định nhiệt độ, sản phẩm giúp động cơ vận hành bền bỉ ngay cả trong điều kiện khắc nghiệt nhất của các giải đua. Lớp màng dầu bám chặt vào bề mặt kim loại giúp bảo vệ máy tối đa từ lúc khởi động.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic Ester Base</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 3000 – 4000 km</li><li>Tính năng: Tối ưu công suất, bảo vệ bề mặt kim loại, ổn định áp suất dầu</li><li>Xuất xứ: Đức (Sản xuất tại Anh)</li></ul>', 'dau-nhot-fuchs-silkolene-pro-4-10w40-xp', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-matk1h8n9z7w3b@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'FUCHS-PRO4-1L', N'1L', 285000, 342000, 228000, 90, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-matk1h8n9z7w3b@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-matk1h8nflho61@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-matk1h8n9z29f3@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-matk1h8ne6x8aa@resize_w900_nl.webp', 0, 3);

-- Product: Dầu nhớt Liqui Moly Motorbike Street Race 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Liqui Moly') INSERT INTO Brands (BrandName) VALUES (N'Liqui Moly');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Liqui Moly');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Liqui Moly Motorbike Street Race 10W40', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Các dòng xe côn tay 150cc và xe PKL</p><p>Là sản phẩm chính thức của giải đua Moto2 và Moto3, Liqui Moly Street Race mang lại khả năng bôi trơn hoàn hảo. Dầu giúp bộ ly hợp (côn) hoạt động cực kỳ mượt mà, không bị trượt nồi. Khả năng làm sạch động cơ của Liqui Moly luôn đứng đầu phân khúc, giúp loại bỏ cặn bẩn và duy trì hiệu suất máy như mới.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic (Tổng hợp toàn phần)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN Plus, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 3000 – 4500 km</li><li>Tính năng: Chống trượt ly hợp, làm sạch động cơ, chịu nhiệt cao</li><li>Xuất xứ: Đức</li></ul>', 'dau-nhot-liqui-moly-motorbike-street-race-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsi61571lj15d3@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIQUI-STREET-RACE-1L', N'1L', 360000, 432000, 288000, 65, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsi61571lj15d3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsi6157162s96d@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsi6156r6hfo42@resize_w900_nl.webp', 0, 2);

-- Product: Dầu nhớt Shell Advance Ultra 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Shell') INSERT INTO Brands (BrandName) VALUES (N'Shell');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Shell');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Shell Advance Ultra 10W40', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe số đời mới, xe côn tay phổ thông</p><p>Shell Advance Ultra được sản xuất từ khí thiên nhiên bằng công nghệ Shell PurePlus độc quyền. Dầu có độ tinh khiết cực cao, giúp duy trì công suất mạnh mẽ và bảo vệ động cơ khỏi các tác nhân gây hại. Sản phẩm giúp xe vận hành êm ái, giảm tiếng ồn động cơ và tiết kiệm nhiên liệu hiệu quả cho những chuyến đi dài.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: 100% Synthetic (Tổng hợp từ khí tự nhiên)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 2500 – 3500 km</li><li>Tính năng: Giữ sạch động cơ, giảm tiếng ồn, kéo dài tuổi thọ máy</li><li>Xuất xứ: Thái Lan / Việt Nam</li></ul>', 'dau-nhot-shell-advance-ultra-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj8lwxerffnp03@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SHELL-ULTRA-1L', N'1L', 260000, 312000, 208000, 150, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj8lwxerffnp03@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj8lx4zpabyf07@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/02899c54295f087d7721188a4a6888f2@resize_w900_nl.webp', 0, 2);

-- Product: Dầu nhớt Repsol Racing 4T 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Repsol') INSERT INTO Brands (BrandName) VALUES (N'Repsol');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Repsol');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Repsol Racing 4T 10W40', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay (Winner, Exciter, Raider) và Moto PKL</p><p>Repsol Racing 4T là dòng dầu nhớt đại diện cho tinh thần của đội đua Repsol Honda tại MotoGP. Sản phẩm được thiết kế để bảo vệ tối đa hộp số và bộ ly hợp. Với công thức đặc biệt, dầu giúp xe phản ứng nhạy bén với tay ga, tăng tốc nhanh và duy trì màng dầu ổn định ở vòng tua máy cực cao.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic (Tổng hợp toàn phần)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 3000 – 4000 km</li><li>Tính năng: Tăng tốc nhanh, bảo vệ hộp số tuyệt vời</li><li>Xuất xứ: Tây Ban Nha</li></ul>', 'dau-nhot-repsol-racing-4t-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/e7edb819dad17c9190b1084421428694@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'REPSOL-RACING-1L', N'1L', 315000, 378000, 252000, 80, 'https://down-vn.img.susercontent.com/file/e7edb819dad17c9190b1084421428694@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rcdu-m6fb7f0jhf107f@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rcdc-m6fb7f9z50lwb5@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rcbt-m6fb7fiuqkh5a0@resize_w900_nl.webp', 0, 3);

-- Product: Dầu nhớt Amsoil Metric 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Amsoil') INSERT INTO Brands (BrandName) VALUES (N'Amsoil');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Amsoil');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Amsoil Metric 10W40', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe PKL châu Âu, xe côn tay hiệu suất cao</p><p>Amsoil Metric là dòng dầu nhớt Mỹ nổi tiếng với độ bền nhiệt cực cao. Sản phẩm giúp giảm thiểu tối đa tình trạng "nóng máy" - vấn đề thường gặp trên các dòng xe côn tay hiện nay. Công thức phụ gia tiên tiến của Amsoil giúp bảo vệ các chi tiết máy khỏi sự mài mòn hóa học và kéo dài thời gian sử dụng dầu lâu hơn so với các loại thông thường.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: 100% Synthetic</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SM/SN, JASO MA/MA2</li><li>Dung tích: 946ml (1 US Quart)</li><li>Chu kỳ thay nhớt: 4000 – 5000 km</li><li>Tính năng: Chống nóng máy, bảo vệ động cơ ưu việt, độ bền nhớt cao</li><li>Xuất xứ: Mỹ</li></ul>', 'dau-nhot-amsoil-metric-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/943bc75dc4f28a4ea3543314d98b7c7e@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'AMSOIL-METRIC-1L', N'946ml', 390000, 468000, 312000, 40, 'https://down-vn.img.susercontent.com/file/943bc75dc4f28a4ea3543314d98b7c7e@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'946ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'946ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'946ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk3azad6zw93ec@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk3b3s32odfqce@resize_w900_nl.webp', 0, 2);

-- Product: Dung dịch vệ sinh buồng đốt Liqui Moly Motorbike Carbon Cleaner
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Liqui Moly') INSERT INTO Brands (BrandName) VALUES (N'Liqui Moly');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Liqui Moly');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dung dịch vệ sinh buồng đốt Liqui Moly Motorbike Carbon Cleaner', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các dòng xe máy (xe ga, xe số, xe côn tay)</p><p>Liqui Moly Carbon Cleaner là dung dịch phụ gia đổ trực tiếp vào bình xăng để làm sạch muội than bám trên đầu piston, súp bắp và buồng đốt sau thời gian dài vận hành. Sản phẩm giúp khôi phục công suất động cơ, giảm thiểu hiện tượng xe bị giật cục, gõ máy, đồng thời tối ưu hóa quá trình đốt cháy nhiên liệu để xe chạy bốc hơn và tiết kiệm xăng rõ rệt.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Phụ gia làm sạch (đổ pha xăng)</li><li>Dung tích: 80ml</li><li>Tỷ lệ pha: 1 chai 80ml dùng cho khoảng 5 – 8 lít xăng</li><li>Chu kỳ sử dụng: Mỗi 3000 – 5000 km/lần</li><li>Tính năng: Loại bỏ muội bám carbon, làm sạch kim phun/bộ chế hòa khí, tiết kiệm nhiên liệu</li><li>Xuất xứ: Đức</li></ul>', 'dung-dich-ve-sinh-buong-ot-liqui-moly-motorbike-carbon-cleaner', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/d3ecce426d08eda41d15623480a7afbe@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIQUI-CARBON-80ML', N'80ml', 95000, 114000, 76000, 200, 'https://down-vn.img.susercontent.com/file/d3ecce426d08eda41d15623480a7afbe@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/9f961fc2b3ab6177a396beae3bc77d39@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/1d47a7ee6a07f3c40f0dfdb7888b2ba3@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/1e55b82c3546703b72092e40408fb07d@resize_w900_nl.webp', 0, 3);

-- Product: Chai xịt dưỡng sên Spider Spray
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Spider Spray') INSERT INTO Brands (BrandName) VALUES (N'Spider Spray');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Spider Spray');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Chai xịt dưỡng sên Spider Spray', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay, xe số sử dụng sên trần (không hộp sên)</p><p>Xịt dưỡng sên Spider Spray nổi bật với công nghệ tạo màng liên kết dạng tơ nhện bám cực chắc vào các mắt sên, hạn chế tối đa tình trạng văng dung dịch ra mâm xe khi chạy tốc độ cao. Sản phẩm giúp sên vận hành êm ái, giảm ma sát, chống rỉ sét hiệu quả và kéo dài tuổi thọ của bộ nhông sên dĩa, đặc biệt chịu nước cực tốt khi đi trời mưa.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Dạng xịt tạo màng bám (Tơ nhện)</li><li>Dung tích: 600ml</li><li>Tính năng: Bôi trơn mắt sên, chống nước, chống rỉ sét, hạn chế văng</li><li>Xuất xứ: Việt Nam (Nguyên liệu nhập khẩu)</li></ul>', 'chai-xit-duong-sen-spider-spray', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/25260fe1c8227330495bb172e1c92c62@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SPIDER-SPRAY-600ML', N'600ml', 190000, 228000, 152000, 120, 'https://down-vn.img.susercontent.com/file/25260fe1c8227330495bb172e1c92c62@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'600ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'600ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'600ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b3bab7e5b941f3b360d634de70b454b1@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/ccefed3f64f9027382f7684f0bee1f8b@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/bbc0fb19d3b3a2ddbc91a5b8d2afe58b@resize_w900_nl.webp', 0, 3);

-- Product: Dung dịch vệ sinh sên WOW Chain Cleaner
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'WOW') INSERT INTO Brands (BrandName) VALUES (N'WOW');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'WOW');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dung dịch vệ sinh sên WOW Chain Cleaner', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các dòng xe số, xe côn tay sử dụng xích truyền động</p><p>WOW Chain Cleaner là trợ thủ đắc lực giúp đánh bay nhanh chóng mọi vết dầu mỡ, bụi đất bẩn bám lâu ngày trên nhông sên dĩa. Công thức đặc biệt của sản phẩm cực kỳ an toàn cho các loại sên có vòng cao su (như O-ring, X-ring, Z-ring), giúp bề mặt sên sạch bóng như mới mà không làm khô ráp hay hỏng các chi tiết cao su bên trong.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Dạng xịt tẩy rửa mạnh</li><li>Dung tích: 500ml</li><li>Tính năng: Tẩy sạch dầu mỡ, bùn đất bám trên sên, an toàn cho sên có vòng cao su</li><li>Xuất xứ: Thái Lan</li></ul>', 'dung-dich-ve-sinh-sen-wow-chain-cleaner', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/c3cd4e6c4ee1b828969863aa9483fa72@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'WOW-CHAIN-CLEAN-500ML', N'500ml', 110000, 132000, 88000, 150, 'https://down-vn.img.susercontent.com/file/c3cd4e6c4ee1b828969863aa9483fa72@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'500ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b99812c5b362b90845e869394e1148a8@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/4f0e45e85d5cb09d2a9cd4b41610828a@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/bfe58e7bd38c19ed3902b00dcdb8880a@resize_w900_nl.webp', 0, 3);

-- Product: Nước làm mát động cơ Liqui Moly Coolant Ready Mix RAF 12 Plus
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Liqui Moly') INSERT INTO Brands (BrandName) VALUES (N'Liqui Moly');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Liqui Moly');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Nước làm mát động cơ Liqui Moly Coolant Ready Mix RAF 12 Plus', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe ga và xe côn tay sử dụng hệ thống làm mát bằng dung dịch</p><p>Nước làm mát Liqui Moly đỏ là dòng sản phẩm cao cấp đã pha sẵn, sử dụng công nghệ OAT tiên tiến giúp tối ưu hóa khả năng truyền nhiệt và làm mát động cơ cực nhanh. Với thành phần chống ăn mòn vượt trội, sản phẩm ngăn ngừa tối đa tình trạng đóng cặn bẩn, rỉ sét trong két nước và đường ống, giúp hệ thống làm mát hoạt động bền bỉ, ổn định nhiệt độ xe khi đi đường dài.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Nước làm mát pha sẵn (Ready Mix - Không cần pha thêm nước)</li><li>Màu sắc: Đỏ (Pink/Red)</li><li>Dung tích: 1L</li><li>Chu kỳ thay thế: Khoảng 20.000 km hoặc sau 2 năm sử dụng</li><li>Tính năng: Giải nhiệt nhanh, chống ăn mòn két nước, chống đóng cặn</li><li>Xuất xứ: Đức</li></ul>', 'nuoc-lam-mat-ong-co-liqui-moly-coolant-ready-mix-raf-12-plus', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/c92e9d4cf3a284e9730df18bac194558@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIQUI-COOLANT-RED-1L', N'1L', 175000, 210000, 140000, 85, 'https://down-vn.img.susercontent.com/file/c92e9d4cf3a284e9730df18bac194558@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/7ed3f7f19b5601e232d4ce944055ba0b@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/982e7264b03c2fefcbd17b839adfc27d@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b153104d12042f4058038123b7005530@resize_w900_nl.webp', 0, 3);

-- Product: Dung dịch súc rửa động cơ Motul Engine Clean Moto
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motul') INSERT INTO Brands (BrandName) VALUES (N'Motul');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Motul');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dung dịch súc rửa động cơ Motul Engine Clean Moto', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các dòng xe máy 4 thì</p><p>Motul Engine Clean được đổ trực tiếp vào phần nhớt cũ trước khi thay nhớt mới. Dung dịch có tác dụng trung hòa axit, làm lỏng và cuốn trôi toàn bộ cặn bùn, muội carbon và mạt kim loại bám lâu ngày trong các ngóc ngách của lốc máy. Quá trình này giúp động cơ sạch sẽ hoàn toàn, tạo môi trường tối ưu để nhớt mới phát huy tối đa công năng bôi trơn.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Phụ gia súc lốc máy (hòa chung với nhớt cũ trước khi xả)</li><li>Dung tích: 200ml</li><li>Cách dùng: Đổ vào lốc nhớt cũ, nổ máy không tải 10 - 15 phút rồi xả bỏ hoàn toàn</li><li>Tính năng: Đẩy sạch cặn bẩn trong lốc máy, trung hòa axit, bảo vệ động cơ</li><li>Xuất xứ: Pháp</li></ul>', 'dung-dich-suc-rua-ong-co-motul-engine-clean-moto', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mm8ij0ozi41t0a@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MOTUL-ENGINE-CLEAN-200ML', N'200ml', 80000, 96000, 64000, 95, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mm8ij0ozi41t0a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'200ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'200ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'200ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lwwkfc0w4r171e@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lwwkfc0w3cgrc4@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lwwkfc0w1xwbe3@resize_w900_nl.webp', 0, 3);

-- Product: Chai xịt bóng vỏ (lốp) xe Sonax Tyre Care
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Sonax') INSERT INTO Brands (BrandName) VALUES (N'Sonax');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Sonax');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Chai xịt bóng vỏ (lốp) xe Sonax Tyre Care', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các loại lốp (vỏ) xe máy, ô tô</p><p>Sonax Tyre Care là dung dịch chăm sóc lốp xe chuyên sâu dạng bọt mịn. Sản phẩm không chỉ mang lại vẻ ngoài đen bóng, sạch sẽ như mới cho lốp xe mà còn thấm sâu vào các thớ cao su, giữ cho lốp luôn có độ đàn hồi tốt, ngăn ngừa hiện tượng nứt nẻ, bạc màu và lão hóa lốp do tác động của ánh nắng mặt trời và thời tiết.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Dạng xịt tạo bọt dưỡng cao su</li><li>Dung tích: 400ml</li><li>Tính năng: Làm đen bóng lốp, chống nứt nẻ, bảo dưỡng và kéo dài tuổi thọ cao su</li><li>Xuất xứ: Đức</li></ul>', 'chai-xit-bong-vo-lop-xe-sonax-tyre-care', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/0d8754ab9ae00d67b3842bb268bd56b9@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SONAX-TYRE-CARE-400ML', N'400ml', 210000, 252000, 168000, 60, 'https://down-vn.img.susercontent.com/file/0d8754ab9ae00d67b3842bb268bd56b9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'400ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'400ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'400ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/dd28ba0a7aadcd28fd1d6115c05d8884@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/d2c7663f00e369a7f603ed2b3424f5ee@resize_w900_nl.webp', 0, 2);

-- CATEGORY: Lốp xe & Vành
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Lốp xe & Vành') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Lốp xe & Vành', 'lop-xe-vanh', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Lốp xe & Vành');

-- Product: Lốp Michelin Pilot Street 2
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Michelin (Pháp)') INSERT INTO Brands (BrandName) VALUES (N'Michelin (Pháp)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Michelin (Pháp)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Michelin Pilot Street 2', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter, Winner, Vario, Air Blade, Raider</p><p>Michelin Pilot Street 2 là dòng lốp danh tiếng với thiết kế gai lốp mới lấy cảm hứng từ lốp xe đua MotoGP. Các rãnh gai được tính toán tỉ mỉ giúp thoát nước cực nhanh, đảm bảo khả năng bám đường tuyệt vời trên bề mặt đường ướt. Hợp chất cao su đặc biệt giúp lốp có độ bền cao, ít bị ăn mòn và tăng quãng đường sử dụng, mang lại cảm giác lái tự tin và an toàn trong mọi điều kiện thời tiết.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Pilot Street 2 (Gai mũi tên)</li><li>Chất liệu: Hợp chất cao su Silica</li><li>Cấu trúc: Lốp không săm (TL)</li><li>Tính năng: Bám đường ướt vượt trội, độ bền cao, ổn định tay lái</li><li>Xuất xứ: Thái Lan / Việt Nam</li></ul>', 'lop-michelin-pilot-street-2', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/525259a10ea68bf66fd1c5d8289af2c0@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MICH-PS2-709017', N'70/90-17 (Lốp trước)', 660000, 792000, 528000, 40, 'https://down-vn.img.susercontent.com/file/525259a10ea68bf66fd1c5d8289af2c0@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17 (Lốp trước)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17 (Lốp trước)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17 (Lốp trước)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MICH-PS2-809017', N'80/90-17 (Lốp sau/trước)', 790000, 948000, 632000, 45, 'https://down-vn.img.susercontent.com/file/525259a10ea68bf66fd1c5d8289af2c0@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17 (Lốp sau/trước)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17 (Lốp sau/trước)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17 (Lốp sau/trước)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-me2nylqj6fpe6f@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-me2nylqj7u9u65@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Pirelli Diablo Rosso Sport
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Pirelli (Ý)') INSERT INTO Brands (BrandName) VALUES (N'Pirelli (Ý)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Pirelli (Ý)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Pirelli Diablo Rosso Sport', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay, xe thể thao (Underbone & Sportbike)</p><p>Pirelli Diablo Rosso Sport mang DNA của dòng lốp Superbike danh tiếng vào các dòng xe nhỏ. Thiết kế gai lốp dạng "chớp" (Flash) đặc trưng không chỉ tăng độ ngầu cho xe mà còn tối ưu hóa diện tích tiếp xúc mặt đường khi nghiêng xe vào cua. Đây là lựa chọn số 1 cho những người dùng yêu thích tốc độ, cần độ bám đường tối đa ở cả đường khô và đường ướt.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Diablo Rosso Sport (Racing DNA)</li><li>Chất liệu: Cao su hiệu suất cao</li><li>Tính năng: Tối ưu khả năng vào cua, phản hồi lái chính xác, bám đường cực tốt</li><li>Xuất xứ: Indonesia</li></ul>', 'lop-pirelli-diablo-rosso-sport', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx68fwu7ue3fa7@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'PIRELLI-DRS-7090', N'70/90-17', 620000, 744000, 496000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx68fwu7ue3fa7@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'PIRELLI-DRS-12070', N'120/70-17 (Lốp sau size lớn)', 1150000, 1380000, 920000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx68fwu7ue3fa7@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau size lớn)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'120/70-17 (Lốp sau size lớn)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau size lớn)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx68fwu7vsnvf6@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx68fwu7x78bca@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Dunlop TT902
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Dunlop (Nhật Bản)') INSERT INTO Brands (BrandName) VALUES (N'Dunlop (Nhật Bản)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Dunlop (Nhật Bản)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Dunlop TT902', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Wave, Dream, Future, Future Neo</p><p>Dunlop TT902 là dòng lốp tiêu chuẩn cho các dòng xe số phổ thông tại Việt Nam. Với thiết kế gai lốp truyền thống nhưng được cải tiến sâu về mặt kỹ thuật, lốp giúp xe vận hành nhẹ nhàng, tiết kiệm nhiên liệu và có khả năng chống đinh tốt. Dunlop TT902 nổi tiếng với sự bền bỉ, ít bị nứt nẻ sau thời gian dài sử dụng dưới nắng mưa.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: TT902</li><li>Đặc tính: Vận hành êm ái, bền bỉ, tiết kiệm xăng</li><li>Xuất xứ: Thái Lan / Việt Nam</li></ul>', 'lop-dunlop-tt902', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zv9-mimuddmuz30h18@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DUNLOP-TT902-7090', N'70/90-17', 420000, 504000, 336000, 70, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zv9-mimuddmuz30h18@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DUNLOP-TT902-8090', N'80/90-17', 510000, 612000, 408000, 50, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zv9-mimuddmuz30h18@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zv4-mimuddhplkhvb7@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zwc-mimuddb9r20y30@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Aspira Premio Sportivo
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Aspira (Indonesia) - Thuộc tập đoàn Pirelli') INSERT INTO Brands (BrandName) VALUES (N'Aspira (Indonesia) - Thuộc tập đoàn Pirelli');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Aspira (Indonesia) - Thuộc tập đoàn Pirelli');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Aspira Premio Sportivo', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe ga (Vario, Air Blade, Click), xe côn tay</p><p>Aspira Premio Sportivo được thừa hưởng công nghệ từ hãng Pirelli danh tiếng nhưng có mức giá dễ tiếp cận hơn. Lốp có thiết kế gai hướng tâm độc đáo giúp ổn định thân xe ở tốc độ cao và cho cảm giác lái rất chắc chắn. Hợp chất cao su lâu mòn giúp người dùng tiết kiệm chi phí bảo trì mà vẫn đảm bảo hiệu suất vận hành tốt.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Sportivo (Thể thao đường trường)</li><li>Công nghệ: Pro-Duo (Hai lớp hợp chất cao su)</li><li>Tính năng: Chống mài mòn tốt, ổn định khi chạy tốc độ cao</li><li>Xuất xứ: Indonesia</li></ul>', 'lop-aspira-premio-sportivo', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0jvqzv5k3xp56@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ASPIRA-SP-908014', N'90/80-14 (Cho Vario/AB)', 550000, 660000, 440000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0jvqzv5k3xp56@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-14 (Cho Vario/AB)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-14 (Cho Vario/AB)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-14 (Cho Vario/AB)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ASPIRA-SP-1008014', N'100/80-14 (Cho Vario/AB)', 680000, 816000, 544000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0jvqzv5k3xp56@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-14 (Cho Vario/AB)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-14 (Cho Vario/AB)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-14 (Cho Vario/AB)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/f16b6de6b6cb27d40fa3836867475209@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/2d9317467441d40d131926c7f8023281@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Continental ContiStreet
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Continental (Đức)') INSERT INTO Brands (BrandName) VALUES (N'Continental (Đức)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Continental (Đức)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Continental ContiStreet', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><p>Continental ContiStreet là dòng lốp được phát triển bởi các kỹ sư Đức, dựa trên dòng lốp PKL ContiRoad nổi tiếng. Lốp có thiết kế rãnh gai sâu giúp thoát nước hiệu quả và tăng độ bám khi nghiêng xe. Đặc biệt, lốp được cấu tạo để giữ được hiệu suất ổn định từ khi mới lắp cho đến khi lốp mòn gần hết, không bị chai cứng theo thời gian.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: ContiStreet</li><li>Công nghệ: Engineered in Germany</li><li>Tính năng: Hiệu suất đồng nhất suốt vòng đời lốp, bám đường vượt trội</li><li>Xuất xứ: Hàn Quốc / Đông Nam Á</li></ul>', 'lop-continental-contistreet', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-824hy-mdyf4ec63sao16@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'CONTI-STREET-12070', N'120/70-17 (Lốp sau)', 1050000, 1260000, 840000, 40, 'https://down-vn.img.susercontent.com/file/sg-11134201-824hy-mdyf4ec63sao16@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'120/70-17 (Lốp sau)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-824gf-mdyf4ern7ksk8a@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-824jh-mdyf4f98side80@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Maxxis
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Maxxis (Đài Loan)') INSERT INTO Brands (BrandName) VALUES (N'Maxxis (Đài Loan)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Maxxis (Đài Loan)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Maxxis', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe số, xe ga phổ thông</p><p>Maxxis Diamond là dòng lốp "quốc dân" nổi tiếng với thiết kế gai kim cương 3D ở hai bên thành lốp. Thiết kế này giúp tăng diện tích tiếp xúc khi xe vào cua và hỗ trợ thoát nước cực tốt. Với ưu điểm giá thành rẻ, độ bền cao và ít ăn đinh, đây là lựa chọn tối ưu cho người dùng phổ thông, sinh viên hoặc xe chạy dịch vụ.</p><h3>Thông số kỹ thuật</h3><ul><li>Đặc tính: Giá thành rẻ, gai kim cương tăng độ bám khi nghiêng xe</li><li>Xuất xứ: Việt Nam (Công nghệ Đài Loan)</li></ul>', 'lop-maxxis', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livol5xmu5zm95@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MAXXIS-DIA-7090', N'70/90-17', 310000, 372000, 248000, 80, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livol5xmu5zm95@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MAXXIS-DIA-8090', N'80/90-17', 380000, 456000, 304000, 70, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livol5xmu5zm95@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livol5xnm9ci4e@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livol5xmsrf608@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Metzeler Sportec Street
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Metzeler (Đức)') INSERT INTO Brands (BrandName) VALUES (N'Metzeler (Đức)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Metzeler (Đức)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Metzeler Sportec Street', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter, Winner, Raider, CBR150, các dòng xe côn tay</p><p>Metzeler Sportec Street là dòng lốp cao cấp đến từ thương hiệu "Voi con" lừng danh của Đức. Lốp được thiết kế để mang lại sự cân bằng hoàn hảo giữa độ bám đường và sự êm ái khi di chuyển trong đô thị. Cấu trúc lốp cứng cáp giúp xe giữ thăng bằng tốt khi chạy ở tốc độ cao và giảm thiểu tình trạng sàng lắc. Các rãnh gai đối xứng giúp thoát nước nhanh chóng, mang lại sự an toàn tuyệt đối khi đi dưới trời mưa.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Sportec Street</li><li>Chất liệu: Hợp chất Silica tăng cường</li><li>Tính năng: Ổn định tay lái, bám đường ướt, cảm giác lái linh hoạt</li><li>Xuất xứ: Indonesia (Công nghệ Đức)</li></ul>', 'lop-metzeler-sportec-street', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/tjcAAeSwPMBpCMRz/s-l1600.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'METZ-STREET-7090', N'70/90-17', 650000, 780000, 520000, 25, 'https://i.ebayimg.com/images/g/tjcAAeSwPMBpCMRz/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'METZ-STREET-12070', N'120/70-17', 1080000, 1296000, 864000, 30, 'https://i.ebayimg.com/images/g/tjcAAeSwPMBpCMRz/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'120/70-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/4ZwAAeSwNE9pCMR1/s-l1600.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/vTkAAeSwX3xpCMSA/s-l1600.webp', 0, 2);

-- Product: Lốp Chengshin C6501
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Chengshin (Đài Loan)') INSERT INTO Brands (BrandName) VALUES (N'Chengshin (Đài Loan)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Chengshin (Đài Loan)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Chengshin C6501', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Air Blade, Vision, Vario, Click</p><p>Chengshin C6501 là sự lựa chọn hàng đầu cho phân khúc thay thế nguyên bản (OEM) nhờ độ bền bỉ đáng kinh ngạc và mức giá cực kỳ tiết kiệm. Lốp có thiết kế gai truyền thống với các rãnh sâu, tập trung vào khả năng chịu tải và chống đinh. Hợp chất cao su dày dặn giúp lốp có tuổi thọ cao, phù hợp cho những người thường xuyên di chuyển đường dài hoặc chạy xe dịch vụ trong thành phố.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: C6501 (Gai kim cương cải tiến)</li><li>Đặc tính: Siêu bền, chịu tải tốt, chống mài mòn vượt trội</li><li>Xuất xứ: Việt Nam</li></ul>', 'lop-chengshin-c6501', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lixa9q7abqj0f9@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'CHENG-C6501-8090', N'80/90-14 (Lốp trước)', 390000, 468000, 312000, 100, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lixa9q7abqj0f9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-14 (Lốp trước)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-14 (Lốp trước)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-14 (Lốp trước)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'CHENG-C6501-9090', N'90/90-14 (Lốp sau)', 460000, 552000, 368000, 100, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lixa9q7abqj0f9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/90-14 (Lốp sau)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/90-14 (Lốp sau)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/90-14 (Lốp sau)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lixa9q7ad53g75@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7qvfn-lhubnsa7ourc15@resize_w900_nl.webp', 0, 2);

-- Product: Lốp Bridgestone Battlax BT-39SS
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Bridgestone (Nhật Bản)') INSERT INTO Brands (BrandName) VALUES (N'Bridgestone (Nhật Bản)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Bridgestone (Nhật Bản)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Bridgestone Battlax BT-39SS', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay chạy sân, xe độ hiệu suất cao</p><p>Bridgestone Battlax BT-39SS là dòng lốp huyền thoại dành cho các tín đồ đam mê tốc độ và chạy sân (track day). Với hợp chất cao su cực mềm và khả năng làm nóng nhanh, lốp mang lại độ bám đường "như dính" ngay cả khi nghiêng xe ở góc cực thấp. Thiết kế gai lốp tối giản để tối ưu diện tích tiếp xúc, giúp người lái phản xạ cực nhanh với các tình huống gắt trên đường đua.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Battlax BT-39 (Sport-Bias)</li><li>Công nghệ: Racing Compound (Cao su mềm)</li><li>Tính năng: Độ bám đường đỉnh cao, tối ưu cho ôm cua và tăng tốc</li><li>Xuất xứ: Nhật Bản / Thái Lan</li></ul>', 'lop-bridgestone-battlax-bt-39ss', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://imgwebikenet-8743.kxcdn.com/catalogue/images/44179/battlax_bt-39ss_f_s.jpg', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BRIDGE-BT39-8090', N'80/90-17', 1250000, 1500000, 1000000, 15, 'https://imgwebikenet-8743.kxcdn.com/catalogue/images/44179/battlax_bt-39ss_f_s.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BRIDGE-BT39-9080', N'90/80-17', 1450000, 1740000, 1160000, 15, 'https://imgwebikenet-8743.kxcdn.com/catalogue/images/44179/battlax_bt-39ss_f_s.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://imgwebikenet-8743.kxcdn.com/catalogue/images/49226/MCS00351_02_s.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://imgwebikenet-8743.kxcdn.com/photo/impression/e1/e1d0f9a31c093b18d40544b8f17dbf89L_s.jpg', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://imgwebikenet-8743.kxcdn.com/photo/article/76/1372663276776L_s.jpg', 0, 3);

-- Product: Lốp IRC (Inoue) NR87
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'IRC (Nhật Bản)') INSERT INTO Brands (BrandName) VALUES (N'IRC (Nhật Bản)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'IRC (Nhật Bản)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp IRC (Inoue) NR87', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150, Winner đời đầu, NVX</p><p>IRC NR87 là dòng lốp tiêu chuẩn được trang bị cho nhiều dòng xe tay côn xuất xưởng tại Việt Nam. Lốp nổi tiếng với sự ổn định, dễ sử dụng và tính trung hòa cao, phù hợp cho nhiều loại địa hình từ đường nhựa đến đường sỏi đá nhẹ. Kết cấu khung lốp chắc chắn giúp giảm thiểu tình trạng biến dạng khi va chạm ổ gà, bảo vệ vành xe (mâm) tốt hơn.</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: NR87 (Gai thể thao phổ thông)</li><li>Đặc tính: Êm ái, ổn định khi chở nặng, dễ điều khiển</li><li>Xuất xứ: Việt Nam</li></ul>', 'lop-irc-inoue-nr87', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvydsfzvcuzd48@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'IRC-NR87-7090', N'70/90-17', 480000, 576000, 384000, 45, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvydsfzvcuzd48@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'IRC-NR87-12070', N'120/70-17', 890000, 1068000, 712000, 45, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvydsfzvcuzd48@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'120/70-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvydsfzvbgex97@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvydsfzvfo4984@resize_w900_nl.webp', 0, 2);

-- CATEGORY: Hệ thống phanh
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hệ thống phanh') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Hệ thống phanh', 'he-thong-phanh', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Hệ thống phanh');

-- Product: Bố thắng Brembo Carbon Ceramic
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Brembo') INSERT INTO Brands (BrandName) VALUES (N'Brembo');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Brembo');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bố thắng Brembo Carbon Ceramic', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay (Winner, Exciter), xe PKL</p><p>Bố thắng Brembo Carbon Ceramic được cấu tạo từ hỗn hợp gốm và carbon cao cấp, mang lại lực phanh ổn định và êm ái. Sản phẩm giúp giảm thiểu tình trạng bó phanh khi hoạt động ở nhiệt độ cao và không gây mòn đĩa phanh nhanh như các loại bố kim loại thông thường. Đây là phụ tùng thay thế hoàn hảo cho những người dùng muốn cải thiện độ an toàn và cảm giác phanh thực tế trên xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Carbon Ceramic (Gốm carbon)</li><li>Khả năng chịu nhiệt: Cực tốt, không bị biến dạng ở nhiệt độ cao</li><li>Đặc tính: Ít tạo bụi phanh, không gây tiếng kêu rít</li><li>Chu kỳ thay thế: 10.000 – 15.000 km tùy điều kiện sử dụng</li><li>Tính năng: Phanh êm, lực phanh chuẩn, bảo vệ đĩa phanh</li><li>Xuất xứ: Ý</li></ul>', 'bo-thang-brembo-carbon-ceramic', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mi2haj2ofeo69c@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-PAD-FRONT', N'Hàng Trước', 550000, 660000, 440000, 50, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mi2haj2ofeo69c@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Trước') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Hàng Trước');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Trước');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-PAD-REAR', N'Hàng Sau', 480000, 576000, 384000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mi2haj2ofeo69c@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Sau') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Hàng Sau');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Sau');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mi2haj2eeepy33@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mi2haj2ed05if8@resize_w900_nl.webp', 0, 2);

-- Product: Đĩa phanh Galfer lòng nhôm (Size 245mm)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Galfer') INSERT INTO Brands (BrandName) VALUES (N'Galfer');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Galfer');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Đĩa phanh Galfer lòng nhôm (Size 245mm)', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150, Winner X, Vario (có pát chuyển)</p><p>Đĩa phanh Galfer lòng nhôm được thiết kế với kiểu dáng răng cưa đặc trưng, không chỉ tăng tính thẩm mỹ mà còn giúp tản nhiệt cực nhanh khi phanh gấp. Phần lòng đĩa làm từ hợp kim nhôm CNC nhuộm màu sắc sảo, giúp trọng lượng đĩa nhẹ hơn đĩa zin đáng kể nhưng vẫn đảm bảo độ bền và độ cứng vững chắc dưới áp lực phanh lớn.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Thép chịu lực chịu nhiệt + Lòng nhôm CNC</li><li>Đường kính: 245mm</li><li>Độ dày: 3.5mm - 4.0mm</li><li>Kiểu dáng: Răng cưa (Wave design)</li><li>Tính năng: Tăng lực phanh, tản nhiệt nhanh, trang trí xe</li><li>Xuất xứ: Tây Ban Nha (Gia công CNC)</li></ul>', 'ia-phanh-galfer-long-nhom-size-245mm', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdxf-md6a2ka605ec07@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GALFER-245-BLACK', N'Lòng Đen', 1250000, 1500000, 1000000, 20, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdxf-md6a2ka605ec07@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lòng Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GALFER-245-GOLD', N'Lòng Vàng', 1250000, 1500000, 1000000, 15, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdxf-md6a2ka605ec07@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lòng Vàng');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdym-md6a2lnjzu4g2f@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdw7-md6a2n35xpvybb@resize_w900_nl.webp', 0, 2);

-- Product: Tay thắng Racing Boy (RCB)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Racing Boy (RCB)') INSERT INTO Brands (BrandName) VALUES (N'Racing Boy (RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Racing Boy (RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Tay thắng Racing Boy (RCB)', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Các dòng xe phổ thông (Wave, Dream, Future, Exciter, Winner)</p><p>Tay thắng RCB dòng E2 là mẫu nâng cấp phổ biến nhất nhờ giá thành hợp lý và độ bền cao. Tay thắng được làm từ nhôm nguyên khối, cảm giác bóp phanh êm ái, chắc chắn hơn tay thắng zin. Thiết kế khí động học cùng các nấc điều chỉnh giúp người lái dễ dàng tùy chỉnh khoảng cách tay thắng sao cho phù hợp với kích thước bàn tay, giảm mỏi khi đi đường dài.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhôm đúc nguyên khối</li><li>Màu sắc: Đen, Bạc, Đỏ, Vàng, Xanh</li><li>Dung tích bình dầu: Tích hợp (đối với bên phải)</li><li>Tính năng: Điều chỉnh cự ly bóp phanh, tăng độ thẩm mỹ, lực bóp êm</li><li>Xuất xứ: Malaysia</li></ul>', 'tay-thang-racing-boy-rcb', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5wi3zip5d1204@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-E2-RIGHT', N'Bên Phải (Có bình dầu)', 450000, 540000, 360000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5wi3zip5d1204@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Phải (Có bình dầu)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bên Phải (Có bình dầu)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Phải (Có bình dầu)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-E2-LEFT', N'Bên Trái (Tay côn/phanh sau)', 250000, 300000, 200000, 40, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5wi3zip5d1204@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Trái (Tay côn/phanh sau)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bên Trái (Tay côn/phanh sau)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Trái (Tay côn/phanh sau)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5wi3zhl6zhyd1@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5wi3zj95yd267@resize_w900_nl.webp', 0, 2);

-- Product: Dây dầu Hel chính hãng bấm đầu Earl's
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Hel Performance') INSERT INTO Brands (BrandName) VALUES (N'Hel Performance');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Hel Performance');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dây dầu Hel chính hãng bấm đầu Earl''s', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các loại xe máy</p><p>Dây dầu Hel nổi tiếng với lõi Teflon chịu nhiệt và lớp vỏ bọc thép không gỉ (Stainless Steel braided). Khác với dây cao su zin thường bị giãn nở khi dầu nóng làm phanh bị "lún", dây Hel giữ cho áp suất dầu luôn ổn định, giúp lực phanh truyền từ tay thắng xuống heo dầu luôn tức thời và chính xác nhất.</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Lõi Teflon, vỏ bép thép không gỉ, bọc nhựa bảo vệ</li><li>Độ dài: 95cm (Phổ thông cho thắng trước)</li><li>Khả năng chịu áp: Lên đến 12.000 psi</li><li>Tính năng: Không giãn nở dây, tối ưu lực phanh, chống rò rỉ</li><li>Xuất xứ: Vương Quốc Anh (UK)</li></ul>', 'day-dau-hel-chinh-hang-bam-au-earls', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m7kuc0abq8tv99@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HEL-RED-95CM', N'Màu Đỏ', 850000, 1020000, 680000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m7kuc0abq8tv99@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HEL-CARBON-95CM', N'Màu Xanh Carbon', 850000, 1020000, 680000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m7kuc0abq8tv99@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Xanh Carbon') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Xanh Carbon');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Xanh Carbon');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m7kuc0abrneb81@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m7kuc0abt1yrac@resize_w900_nl.webp', 0, 2);

-- Product: Dầu thắng Brembo Brake Fluid DOT 4
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Brembo') INSERT INTO Brands (BrandName) VALUES (N'Brembo');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Brembo');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu thắng Brembo Brake Fluid DOT 4', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Hệ thống phanh đĩa trước và sau các dòng xe máy, ô tô</p><p>Dầu thắng Brembo DOT 4 có điểm sôi cao vượt trội so với các loại dầu thông thường, giúp ngăn chặn hiện tượng "khóa hơi" (vapor lock) khi phanh liên tục trên đèo dốc hoặc chạy tốc độ cao. Dung dịch có độ nhớt ổn định giúp hệ thống phanh phản ứng nhạy bén, đồng thời chứa các chất phụ gia chống ăn mòn tuyệt vời cho các chi tiết kim loại và cao su bên trong heo dầu, tay thắng.</p><h3>Thông số kỹ thuật</h3><ul><li>Tiêu chuẩn: DOT 4</li><li>Điểm sôi khô: 260°C</li><li>Điểm sôi ướt: 165°C</li><li>Dung tích: 500ml</li><li>Tính năng: Chịu nhiệt cao, bảo vệ ron cao su, chống ăn mòn</li><li>Xuất xứ: Ý</li></ul>', 'dau-thang-brembo-brake-fluid-dot-4', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m26xathpl6esea@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-DOT4-500ML', N'500ml', 290000, 348000, 232000, 120, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m26xathpl6esea@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'500ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m26xdv8iy8c4c4@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m26xel2l5778c2@resize_w900_nl.webp', 0, 2);

-- Product: Heo dầu Brembo 2 Piston Đối Xứng
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Brembo') INSERT INTO Brands (BrandName) VALUES (N'Brembo');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Brembo');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Heo dầu Brembo 2 Piston Đối Xứng', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Nâng cấp cho phanh sau hoặc phanh trước các dòng xe độ</p><p>Heo dầu Brembo 2 Piston đối xứng là món đồ chơi "quốc dân" trong làng xe độ. Với thiết kế 2 piston đối xứng giúp lực phanh tác động đều lên cả hai mặt má phanh, mang lại cảm giác phanh mượt mà và kiểm soát tốt hơn hẳn heo 1 piston zin. Thân heo được đúc bằng hợp kim nhôm cường độ cao, vừa nhẹ vừa giúp tản nhiệt tối ưu khi vận hành liên tục.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Hợp kim nhôm đúc</li><li>Cấu tạo: 2 Piston đối xứng (Đường kính 32mm)</li><li>Màu sắc: Xám Titan (Logo đỏ), Vàng đồng</li><li>Tính năng: Tăng lực phanh, kiểm soát lực bóp chính xác, thẩm mỹ cao</li><li>Xuất xứ: Ý</li></ul>', 'heo-dau-brembo-2-piston-oi-xung', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4r7ekhx7x5s2f@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-2P-GREY', N'Màu Xám Titan', 2850000, 3420000, 2280000, 15, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4r7ekhx7x5s2f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Xám Titan') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Xám Titan');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Xám Titan');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-2P-GOLD', N'Màu Vàng Đồng', 2950000, 3540000, 2360000, 10, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4r7ekhx7x5s2f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng Đồng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Vàng Đồng');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng Đồng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbgksekqfepwee@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbgksekqfeknc9@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbgksekgftc401@resize_w900_nl.webp', 0, 3);

-- Product: Đĩa phanh KingSpeed (Size 267mm)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'KingSpeed') INSERT INTO Brands (BrandName) VALUES (N'KingSpeed');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'KingSpeed');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Đĩa phanh KingSpeed (Size 267mm)', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> NVX, Exciter 150/155, Winner (Cần pát chuyên dụng)</p><p>Đĩa phanh KingSpeed nổi bật với thiết kế lòng nhôm CNC được nhuộm màu rực rỡ và phần lưỡi đĩa bằng thép không gỉ chất lượng cao. Với kích thước lớn 267mm, đĩa không chỉ tạo ngoại hình hầm hố mà còn giúp tăng cánh tay đòn, từ đó cải thiện đáng kể lực phanh. Các lỗ thoát khí được phân bổ khoa học giúp vệ sinh má phanh và làm mát hệ thống cực nhanh.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Thép SUS420 chịu nhiệt + Lòng nhôm 7075 CNC</li><li>Đường kính: 267mm</li><li>Kiểu lắp: 5 lỗ ốc (Dành cho dòng Yamaha/Honda tùy pát)</li><li>Tính năng: Chống biến dạng nhiệt, tăng lực thắng, trang trí dàn chân</li><li>Xuất xứ: Đài Loan</li></ul>', 'ia-phanh-kingspeed-size-267mm', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbkc-lpw4pvs95xl181@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'KS-267-BLACK', N'Lòng Đen', 950000, 1140000, 760000, 25, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbkc-lpw4pvs95xl181@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lòng Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'KS-267-RED', N'Lòng Đỏ', 950000, 1140000, 760000, 15, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbkc-lpw4pvs95xl181@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lòng Đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rblk-lpw4pwhi4zetf0@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbl9-lpw4px536gxxd2@resize_w900_nl.webp', 0, 2);

-- Product: Bố thắng (Má phanh) Elig Sintered
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Elig') INSERT INTO Brands (BrandName) VALUES (N'Elig');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Elig');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bố thắng (Má phanh) Elig Sintered', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Các dòng xe phổ thông và phân khối lớn (Nissin, Brembo)</p><p>Bố thắng Elig dòng Sintered là bước đột phá về công nghệ ma sát. Được chế tạo bằng cách nén các hạt kim loại ở nhiệt độ cao, sản phẩm cho độ bám cực gắt ngay cả khi vừa mới lắp đặt. Điểm mạnh nhất của Elig Sintered là hiệu suất không thay đổi dù trong điều kiện mưa gió, bùn đất hay khi đĩa phanh đang cực nóng.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Kim loại tổng hợp (Sintered Metal)</li><li>Tiêu chuẩn: ISO 9001, TS 16949</li><li>Đặc tính: Chịu nhiệt lên đến 500°C, độ bền gấp 2 lần bố thường</li><li>Chu kỳ thay thế: 15.000 - 20.000 km</li><li>Tính năng: Phanh gấp an toàn, chống trượt phanh dưới mưa</li><li>Xuất xứ: Đài Loan (Sản xuất tại Việt Nam)</li></ul>', 'bo-thang-ma-phanh-elig-sintered', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mggaj9wpep729a@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ELIG-ST-FRONT', N'Cho Heo Zin (Trước)', 280000, 336000, 224000, 100, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mggaj9wpep729a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Heo Zin (Trước)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Heo Zin (Trước)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Heo Zin (Trước)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ELIG-ST-2P', N'Cho Heo Brembo 2P', 350000, 420000, 280000, 50, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mggaj9wpep729a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Heo Brembo 2P') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Heo Brembo 2P');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Heo Brembo 2P');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mggaitrzpte010@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-7ras8-m3ug8rzhwmuta0@resize_w900_nl.webp', 0, 2);

-- Product: Cùm tay thắng Adelin PX-1 (Radial Master Cylinder)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Adelin') INSERT INTO Brands (BrandName) VALUES (N'Adelin');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Adelin');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Cùm tay thắng Adelin PX-1 (Radial Master Cylinder)', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay, xe PKL nâng cấp phanh</p><p>Adelin PX-1 là mẫu cùm phanh mang thiết kế hướng tâm (piston đặt vuông góc với tay thắng), giúp lực bóp truyền trực tiếp và tuyến tính hơn so với cùm phanh ngang truyền thống. Tay thắng có khả năng chống gãy khi va chạm và có núm chỉnh cự ly xa gần rất tiện lợi. Đây là giải pháp nâng cấp hiệu năng phanh chuyên nghiệp với chi phí cực kỳ hợp lý.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhôm CNC nguyên khối</li><li>Đường kính Piston: 17.5mm</li><li>Màu sắc: Xám lỳ (Hard Anodized)</li><li>Tính năng: Tăng độ nhạy phanh, tùy chỉnh lực bóp, chống gãy tay thắng</li><li>Xuất xứ: Trung Quốc (Hàng chính hãng nội địa)</li></ul>', 'cum-tay-thang-adelin-px-1-radial-master-cylinder', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbkw-llp18eyhc5w0b0@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ADELIN-PX1-R', N'Tay Bên Phải', 1650000, 1980000, 1320000, 30, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbkw-llp18eyhc5w0b0@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tay Bên Phải') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tay Bên Phải');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tay Bên Phải');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7r99d-llp18fo0dmhv94@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rblu-llp18gcza9uhc8@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbmj-llp18h7s6te343@resize_w900_nl.webp', 0, 3);

-- Product: Bình dầu rời Bonamici Aluminum
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Bonamici Racing') INSERT INTO Brands (BrandName) VALUES (N'Bonamici Racing');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Bonamici Racing');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bình dầu rời Bonamici Aluminum', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Các dòng xe sử dụng cùm thắng rời (RCS, Adelin, RCB)</p><p>Bình dầu Bonamici là món trang trí không thể thiếu cho những bộ cùm thắng cao cấp. Được tiện CNC từ nhôm 6061, bình dầu có thiết kế góc cạnh, mạnh mẽ với mặt kính thăm dầu trong suốt giúp người dùng dễ dàng kiểm tra lượng dầu bên trong. Lớp sơn Anodized bền màu giúp sản phẩm giữ được vẻ đẹp sắc sảo sau thời gian dài sử dụng.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhôm 6061-T6 CNC</li><li>Màu sắc: Đen, Đỏ, Vàng, Xanh dương</li><li>Cấu tạo: Có kính thăm dầu, nắp vặn có ron cao su chống rò rỉ</li><li>Tính năng: Chứa dầu phanh, tăng tính thẩm mỹ cho ghi đông</li><li>Xuất xứ: Ý (Hoặc hàng 1:1 tùy phân khúc)</li></ul>', 'binh-dau-roi-bonamici-aluminum', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9wl6utjv21mf7@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BONA-TANK-BK', N'Màu Đen', 350000, 420000, 280000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9wl6utjv21mf7@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BONA-TANK-RD', N'Màu Đỏ', 350000, 420000, 280000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9wl6utjv21mf7@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-m05sp55cgfprfd@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-m05sp55cf0tp9e@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-m05sp55cc80f4b@resize_w900_nl.webp', 0, 3);

-- CATEGORY: Giảm xóc
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Giảm xóc') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Giảm xóc', 'giam-xoc', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Giảm xóc');

-- Product: Phuộc Ohlins HO110
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Ohlins') INSERT INTO Brands (BrandName) VALUES (N'Ohlins');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Ohlins');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Ohlins HO110', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Honda Vario, Click, Vision, Sh Mode</p><p>Ohlins HO110 là dòng giảm xóc đẳng cấp nhất dành cho xe tay ga nhỏ. Với thiết kế bình dầu dưới màu vàng đặc trưng, phuộc mang lại khả năng kiểm soát hành trình nhún cực kỳ tinh tế. Công nghệ bình dầu giúp dầu không bị nóng khi hoạt động liên tục, đảm bảo độ êm ái và ổn định tuyệt đối dù đi một mình hay chở nặng. Sản phẩm cho phép người dùng tùy chỉnh sâu vào độ nén lò xo và độ hồi của phuộc.</p><h3>Thông số kỹ thuật</h3><ul><li>Chiều cao: 330mm</li><li>Tính năng tùy chỉnh: Compression, Rebound, Preload</li><li>Phụ kiện: Kèm thêm 1 lò xo phụ</li><li>Tính năng: Giảm chấn thông minh, tăng độ bám đường khi vào cua</li><li>Xuất xứ: Thụy Điển (Sản xuất tại Thái Lan)</li></ul>', 'phuoc-ohlins-ho110', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mgiu9nzgxij163@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'OHLINS-HO110', N'Màu Vàng', 8600000, 10320000, 6880000, 15, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mgiu9nzgxij163@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Vàng');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mgiu9nzdf3ew98@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mgiu9nzjclqme6@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mgiu9nzdghzc47@resize_w900_nl.webp', 0, 3);

-- Product: Phuộc YSS G-Series dòng Hybrid
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS') INSERT INTO Brands (BrandName) VALUES (N'YSS');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'YSS');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc YSS G-Series dòng Hybrid', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Air Blade, PCX, NVX, SH Việt Nam</p><p>YSS G-Series Hybrid là sự kết hợp hoàn hảo giữa khí Nitơ áp suất cao và dầu thủy lực. Thiết kế bình dầu giúp giải nhiệt nhanh, giữ cho phuộc không bị "đuối" khi đi đường dài. Đây là lựa chọn thay thế phuộc zin tốt nhất trong tầm giá, mang lại cảm giác lái đầm chắc, triệt tiêu lực chấn động từ mặt đường rất hiệu quả, giúp bảo vệ khung sườn và mang lại sự thoải mái cho người ngồi sau.</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Bình dầu rời chứa khí Nitơ</li><li>Màu sắc: Lò xo đỏ - Bình dầu bạc</li><li>Tính năng: Tăng độ ổn định thân xe, chịu tải tốt</li><li>Xuất xứ: Thái Lan</li></ul>', 'phuoc-yss-g-series-dong-hybrid', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk7sfc12zymd00@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'YSS-GSERIES-AB', N'Cho Air Blade (320mm)', 2450000, 2940000, 1960000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk7sfc12zymd00@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Air Blade (320mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Air Blade (320mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Air Blade (320mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'YSS-GSERIES-NVX', N'Cho NVX (305mm)', 2800000, 3360000, 2240000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk7sfc12zymd00@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho NVX (305mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho NVX (305mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho NVX (305mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk7sfc1299tta5@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mk7sfc0syyo5df@resize_w900_nl.webp', 0, 2);

-- Product: Phuộc Racing Boy (RCB)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Racing Boy (RCB)') INSERT INTO Brands (BrandName) VALUES (N'Racing Boy (RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Racing Boy (RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Racing Boy (RCB)', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><p>RCB VD Series là dòng phuộc đỉnh cao của nhà RCB với điểm nhấn là ty phuộc mạ vàng sang trọng và chống trầy xước. Sản phẩm có đầy đủ các núm tăng chỉnh tăng giảm độ hồi và độ nén, cho phép người dùng cá nhân hóa cảm giác lái theo đúng cân nặng và sở thích. Thân phuộc được làm từ nhôm CNC sắc sảo, giúp tản nhiệt nhanh và tăng độ bền cơ học cho hệ thống giảm xóc.</p><h3>Thông số kỹ thuật</h3><ul><li>Tính năng tùy chỉnh: Preload, Rebound, Compression</li><li>Đặc điểm: Ty vàng chống ma sát cao</li><li>Tính năng: Chỉnh độ nhún cứng/mềm linh hoạt, phong cách thể thao</li><li>Xuất xứ: Malaysia</li></ul>', 'phuoc-racing-boy-rcb', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rfh1-m9zgngau01218d@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-VD-EX150', N'Cho Exciter (208mm)', 4200000, 5040000, 3360000, 15, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rfh1-m9zgngau01218d@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter (208mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Exciter (208mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter (208mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-VD-WINNER', N'Cho Winner (225mm)', 4350000, 5220000, 3480000, 15, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rfh1-m9zgngau01218d@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Winner (225mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Winner (225mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Winner (225mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rfft-m9zgngl3nr6k1d@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rffa-m9zgngyp3v2u61@resize_w900_nl.webp', 0, 2);

-- Product: Phuộc trước LCM
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'LCM') INSERT INTO Brands (BrandName) VALUES (N'LCM');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'LCM');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc trước LCM', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150/155</p><p>Phuộc trước LCM là giải pháp khắc phục triệt để hiện tượng kêu "cụp cụp" kinh điển trên dòng xe Exciter. Với thiết kế ty phuộc lớn và chảng ba đúc dày dặn, bộ phuộc này mang lại sự vững chãi tuyệt đối cho tay lái. Xe sẽ không còn tình trạng sàn lắc khi qua ổ gà hay khi phanh gấp, giúp người lái tự tin hơn rất nhiều khi di chuyển ở tốc độ cao.</p><h3>Thông số kỹ thuật</h3><ul><li>Trọn bộ: Gồm ty phuộc, chảng ba, pát heo dầu</li><li>Kích thước: Ty lớn (phong cách Winner)</li><li>Tính năng: Triệt tiêu tiếng kêu phuộc trước, tăng độ đầm chắc cho đầu xe</li><li>Xuất xứ: Đài Loan</li></ul>', 'phuoc-truoc-lcm', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-makrbl6xk7a078@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LCM-FRONT-EX150', N'Full bộ cho Ex150', 3850000, 4620000, 3080000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-makrbl6xk7a078@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Full bộ cho Ex150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Full bộ cho Ex150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Full bộ cho Ex150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-makrbpjp6sig71@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-makrbs57grfbf1@resize_w900_nl.webp', 0, 2);

-- Product: Phuộc Nitron DNA
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Nitron DNA') INSERT INTO Brands (BrandName) VALUES (N'Nitron DNA');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Nitron DNA');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Nitron DNA', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Vario, Vision, SH, Exciter</p><p>Phuộc Nitron DNA thu hút mọi ánh nhìn với tone màu xanh ngọc đặc trưng. Đây là dòng phuộc được thiết kế dành riêng cho thị trường Đông Nam Á, tối ưu hóa cho điều kiện mặt đường nhiều ổ gà và gờ giảm tốc. Phuộc vận hành rất mượt mà ở tốc độ thấp và cực kỳ ổn định khi đi nhanh, giúp giảm áp lực lên cột sống người lái và tăng tuổi thọ cho các chi tiết nhựa trên xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Màu sắc: Xanh Nitron</li><li>Tính năng tùy chỉnh: Nấc chỉnh Rebound (độ hồi) và Preload (lò xo)</li><li>Cấu tạo: Nhôm CNC cao cấp</li><li>Tính năng: Thẩm mỹ cao, độ nhún êm ái, bền bỉ</li><li>Xuất xứ: Công nghệ Anh Quốc</li></ul>', 'phuoc-nitron-dna', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lopl660rjv9nea@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'NITRON-DNA-330', N'Cho Vario (330mm)', 2650000, 3180000, 2120000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lopl660rjv9nea@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario (330mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Vario (330mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario (330mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lopl660seseod3@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lopl661l37tc1b@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltwc1q1zkc22fd@resize_w900_nl.webp', 0, 3);

-- Product: Phuộc Ohlins HO811 (Bình dầu rời)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Ohlins') INSERT INTO Brands (BrandName) VALUES (N'Ohlins');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Ohlins');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Ohlins HO811 (Bình dầu rời)', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Honda SH300i, SH350i</p><p>Ohlins HO811 là biểu tượng của sự sang trọng và hiệu năng dành cho các dòng xe ga lớn. Với thiết kế bình dầu rời nằm ngang, phuộc cung cấp một hành trình nhún cực kỳ ổn định, giúp triệt tiêu hoàn toàn hiện tượng sàn lắc đuôi xe khi vào cua ở tốc độ cao. Khả năng tùy chỉnh linh hoạt cho phép người lái thiết lập độ cứng mềm chính xác theo tải trọng, mang lại trải nghiệm êm ái như những dòng xe hơi hạng sang.</p><h3>Thông số kỹ thuật</h3><ul><li>Chiều cao: 400mm</li><li>Tính năng tùy chỉnh: Preload, Rebound, Compression</li><li>Đặc điểm: Bình dầu rời màu vàng Gold, lò xo vàng</li><li>Tính năng: Tối ưu hóa độ bám đường, giữ vững thân xe ở tốc độ cao</li><li>Xuất xứ: Thụy Điển (Sản xuất tại Thái Lan)</li></ul>', 'phuoc-ohlins-ho811-binh-dau-roi', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbozqj5rqvea00@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'OHLINS-HO811', N'Màu Vàng', 15500000, 18600000, 12400000, 10, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbozqj5rqvea00@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Vàng');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbozqj75oub6ee@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbozqj7fofoy5c@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbozqj8jmtm239@resize_w900_nl.webp', 0, 3);

-- Product: Phuộc YSS G-Sport
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS') INSERT INTO Brands (BrandName) VALUES (N'YSS');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'YSS');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc YSS G-Sport', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Vario, Click, Vision, Scoopy</p><p>Dòng Black Series của YSS mang đến vẻ ngoài cực kỳ quyền lực với tông màu đen huyền bí. G-Sport được trang bị tính năng "Thread Spring Preload" giúp tùy chỉnh độ nén lò xo bằng vòng ren và "Rebound Adjustable" với 30 nấc chỉnh độ hồi của phuộc. Đây là giải pháp hoàn hảo cho những ai muốn sự êm ái vượt trội hơn phuộc zin nhưng vẫn giữ được nét kín đáo, tinh tế cho chiếc xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Chiều cao: 330mm</li><li>Tính năng tùy chỉnh: Preload, Rebound (30 nấc)</li><li>Cấu tạo: Thân nhôm đúc, bình dầu khí Nitơ</li><li>Tính năng: Nhún êm, không bị sàng khi chở nặng, độ bền cao</li><li>Xuất xứ: Thái Lan</li></ul>', 'phuoc-yss-g-sport', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/thumbs/images/g/JVwAAOSwv05oT8gP/s-l500.jpg', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'YSS-GSPORT-BLACK', N'Full Black', 3650000, 4380000, 2920000, 35, 'https://i.ebayimg.com/thumbs/images/g/JVwAAOSwv05oT8gP/s-l500.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Full Black') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Full Black');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Full Black');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/G44AAOSwrmZoT8gP/s-l1600.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/q8kAAOSwlLtoT8gO/s-l1600.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/JTQAAOSwEwZoT8gP/s-l1600.webp', 0, 3);

-- Product: Phuộc RCB dòng C Series
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Racing Boy (RCB)') INSERT INTO Brands (BrandName) VALUES (N'Racing Boy (RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Racing Boy (RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc RCB dòng C Series', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Sirius, Jupiter, Wave, Dream, Future</p><p>RCB C Series là dòng phuộc "quốc dân" dành cho các dòng xe số phổ thông. Dù không có bình dầu, nhưng piston và ty phuộc được thiết kế lớn hơn zin giúp xe vận hành chắc chắn, không bị sàn lắc khi chở thêm người. Thiết kế đơn giản, hiện đại với nhiều màu sắc bắt mắt giúp tăng thêm điểm nhấn thẩm mỹ cho dàn chân của xe mà không cần chế cháo phức tạp.</p><h3>Thông số kỹ thuật</h3><ul><li>Chiều cao: 275mm (Sirius/Ju) - 335mm (Wave/Dream)</li><li>Chất liệu: Hợp kim thép cao cấp</li><li>Tính năng: Thay thế phuộc zin, cải thiện độ nhún, chịu tải tốt</li><li>Màu sắc: Đỏ, Đen, Vàng, Trắng</li><li>Xuất xứ: Malaysia</li></ul>', 'phuoc-rcb-dong-c-series', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn41lsum6znpe3@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-C-SIRIUS', N'Cho Sirius (275mm)', 850000, 1020000, 680000, 50, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn41lsum6znpe3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Sirius (275mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Sirius (275mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Sirius (275mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-C-WAVE', N'Cho Wave/Future (335mm)', 850000, 1020000, 680000, 50, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn41lsum6znpe3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Wave/Future (335mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Wave/Future (335mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Wave/Future (335mm)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn41lsutkgzk17@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn41lsuzt7uu04@resize_w900_nl.webp', 0, 2);

-- Product: Phuộc Koni
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Koni (Việt Nam - Công nghệ Châu Âu)') INSERT INTO Brands (BrandName) VALUES (N'Koni (Việt Nam - Công nghệ Châu Âu)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Koni (Việt Nam - Công nghệ Châu Âu)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Koni', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Air Blade, Vision, Vario, SH Mode</p><p>Phuộc Koni là sự lựa chọn kinh tế nhưng mang lại hiệu quả bất ngờ. Với thiết kế không bình dầu gọn gàng, Koni tập trung vào độ bền của phốt và khả năng chịu nhiệt của dầu thủy lực bên trong. Phuộc giúp xe vận hành êm ái qua các gờ giảm tốc và không bị hiện tượng "kịch" hành trình như các loại phuộc rẻ tiền khác trên thị trường.</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Hệ thống thủy lực kép</li><li>Đặc tính: Ty phuộc mạ crom chống ăn mòn</li><li>Tính năng: Vận hành êm ái trong phố, lắp đặt như zin (Plug & Play)</li><li>Xuất xứ: Việt Nam</li></ul>', 'phuoc-koni', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8h4i5inmrgn67@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'KONI-SCOOTER-BK', N'Màu Đen Lò xo Đen', 650000, 780000, 520000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8h4i5inmrgn67@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen Lò xo Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đen Lò xo Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen Lò xo Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8h4i5ino61324@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8h4i5inlcvi46@resize_w900_nl.webp', 0, 2);

-- Product: Bộ giảm xóc trước KTC
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'KTC') INSERT INTO Brands (BrandName) VALUES (N'KTC');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'KTC');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bộ giảm xóc trước KTC', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150, Winner X, Vario</p><p>Điểm nhấn lớn nhất của bộ phuộc này chính là lớp mạ Titan 7 màu (PVD) trên ty phuộc, mang lại vẻ ngoài cực kỳ nổi bật và cá tính. Không chỉ đẹp, lớp mạ này còn giúp giảm ma sát khi ty phuộc chuyển động, giúp hành trình nhún mượt mà hơn. Đi kèm là bộ dầu phuộc chuyên dụng giúp xe ổn định hơn khi di chuyển trên các cung đường xấu.</p><h3>Thông số kỹ thuật</h3><ul><li>Trọn bộ: Cặp ty phuộc + Dầu phuộc chuyên dụng</li><li>Đặc điểm: Ty mạ PVD 7 màu chống trầy</li><li>Tính năng: Tăng tính thẩm mỹ, làm mượt hành trình giảm xóc trước</li><li>Xuất xứ: Đài Loan</li></ul>', 'bo-giam-xoc-truoc-ktc', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/fec088225fa4d6ef22e62d09396820cd@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'KTC-TY7M-EX', N'Cho Exciter 150', 1250000, 1500000, 1000000, 20, 'https://down-vn.img.susercontent.com/file/fec088225fa4d6ef22e62d09396820cd@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter 150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/64153215b7dad68f92053111fa898bea@resize_w900_nl.webp', 0, 1);

-- CATEGORY: Ắc quy & Điện
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Ắc quy & Điện') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Ắc quy & Điện', 'ac-quy-ien', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Ắc quy & Điện');

-- Product: Đèn LED trợ sáng Bi Cầu Mini X-Light M10
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'X-Light') INSERT INTO Brands (BrandName) VALUES (N'X-Light');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'X-Light');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Đèn LED trợ sáng Bi Cầu Mini X-Light M10', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các dòng xe máy</p><p>X-Light M10 là dòng đèn trợ sáng bi cầu mini có kích thước nhỏ gọn nhưng cường độ sáng cực mạnh. Đèn có tích hợp hai chế độ: Cos (ánh sáng vàng) và Pha (ánh sáng trắng) với đường cắt chống chói cho người đối diện. Sản phẩm có khả năng chống nước chuẩn IP68, giúp người lái quan sát rõ mặt đường trong mọi điều kiện thời tiết như mưa lớn hay sương mù.</p><h3>Thông số kỹ thuật</h3><ul><li>Công suất: 20W - 25W</li><li>Chế độ sáng: Cos vàng - Pha trắng</li><li>Chống nước: IP68</li><li>Điện áp: 9V - 36V</li><li>Tính năng: Tăng khả năng quan sát ban đêm, chống chói người đối diện</li><li>Xuất xứ: Trung Quốc (Công nghệ Việt Nam)</li></ul>', 'en-led-tro-sang-bi-cau-mini-x-light-m10', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx3sym1q5tcr48@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'XLIGHT-M10-PAIR', N'Cặp 2 đèn', 650000, 780000, 520000, 35, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx3sym1q5tcr48@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cặp 2 đèn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cặp 2 đèn');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cặp 2 đèn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'XLIGHT-M10-SINGLE', N'Lẻ 1 đèn', 350000, 420000, 280000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx3sym1q5tcr48@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lẻ 1 đèn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lẻ 1 đèn');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lẻ 1 đèn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx3sym1q77x7c2@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m42nk9hhw5ggfd@resize_w900_nl.webp', 0, 2);

-- Product: Sạc Độ HCE
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'HCE') INSERT INTO Brands (BrandName) VALUES (N'HCE');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'HCE');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Sạc Độ HCE', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150, Winner X, các xe lên nhiều đèn trợ sáng</p><p>Sạc độ HCE giúp ổn định dòng điện từ mâm lửa lên bình ắc quy, giúp sạc bình nhanh hơn và ổn định hơn so với sạc zin. Sản phẩm đặc biệt quan trọng cho các xe lắp thêm nhiều thiết bị điện như đèn LED, định vị, chống trộm mà không lo hết bình hay cháy cuộn lửa. Sạc HCE có tính năng tự ngắt khi bình đầy để bảo vệ tuổi thọ ắc quy.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại: Sạc 3 pha thông minh</li><li>Tính năng: Chuyển điện máy thành điện bình ổn định, tự ngắt khi đầy</li><li>Lắp đặt: Plug and Play (như zin)</li><li>Tính năng: Hỗ trợ hệ thống đèn trợ sáng công suất lớn</li><li>Xuất xứ: Việt Nam</li></ul>', 'sac-o-hce', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9ycubtnglfmfe@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HCE-CHARGER-HONDA', N'Dòng xe Honda (Winner/Vario)', 480000, 576000, 384000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9ycubtnglfmfe@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Honda (Winner/Vario)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dòng xe Honda (Winner/Vario)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Honda (Winner/Vario)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HCE-CHARGER-YAMAHA', N'Dòng xe Yamaha (Exciter)', 480000, 576000, 384000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9ycubtnglfmfe@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Yamaha (Exciter)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dòng xe Yamaha (Exciter)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Yamaha (Exciter)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9ycubtncdhg31@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9ycubu7bk907d@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mclho1asjm3g3b@resize_w900_nl.webp', 0, 3);

-- Product: Bộ khóa chống trộm Zoro
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Pitech') INSERT INTO Brands (BrandName) VALUES (N'Pitech');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Pitech');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bộ khóa chống trộm Zoro', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các dòng xe máy</p><p>Fox là bộ khóa chống trộm cao cấp điều khiển qua điện thoại và remote nhận diện người dùng. Sản phẩm tích hợp đầy đủ các tính năng an toàn: Chống trộm, chống cướp (tự tắt máy khi remote rời xa xe), tìm xe trong bãi và định vị vị trí xe qua GPS. Hệ thống lắp đặt bằng jack cắm zin, không cắt dây điện của xe, đảm bảo an toàn tuyệt đối cho hệ thống điện.</p><h3>Thông số kỹ thuật</h3><ul><li>Kết nối: Bluetooth 4.2 / GPS</li><li>Tính năng: Chống cướp tự động, định vị GPS, tìm xe trong bãi</li><li>Quản lý: App trên Smartphone (iOS/Android)</li><li>Phụ kiện: 1 bộ điều khiển trung tâm + 1 Remote Pi</li><li>Xuất xứ: Việt Nam</li></ul>', 'bo-khoa-chong-trom-zoro', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rccv-lsgnfnry30j9ce@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'PITECH-FOX-FULL', N'Bộ đầy đủ (Full Set)', 1550000, 1860000, 1240000, 25, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rccv-lsgnfnry30j9ce@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ đầy đủ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ đầy đủ (Full Set)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ đầy đủ (Full Set)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-llejm23wfxe0b4@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-llejm23wiqiw9b@resize_w900_nl.webp', 0, 2);

-- Product: Ắc quy khô GS Platinum GTZ6V
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'GS Platinum') INSERT INTO Brands (BrandName) VALUES (N'GS Platinum');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'GS Platinum');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Ắc quy khô GS Platinum GTZ6V', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Air Blade, Vario, Winner, Exciter 150/155, Lead</p><p>Ắc quy GS Platinum là dòng bình khô cao cấp có dòng phóng điện ổn định và tuổi thọ vượt trội. Với dung lượng 5Ah, bình đảm bảo khả năng khởi động (đề máy) nhạy bén ngay cả trong thời tiết lạnh. Thiết kế bình kín khí không cần bảo dưỡng, an toàn và không gây rò rỉ axit làm hỏng khung sườn xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Điện thế: 12V</li><li>Dung lượng: 5Ah</li><li>Kích thước: 113 x 70 x 105 mm</li><li>Loại bình: Bình VRLA (khô, kín khí)</li><li>Tính năng: Cung cấp nguồn điện ổn định cho hệ thống khởi động và chiếu sáng</li><li>Xuất xứ: Việt Nam (Công nghệ Nhật Bản)</li></ul>', 'ac-quy-kho-gs-platinum-gtz6v', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdvv-lzzy638h94kic7@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GS-GTZ6V-PLATINUM', N'Bình GTZ6V (5Ah)', 380000, 456000, 304000, 80, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdvv-lzzy638h94kic7@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bình GTZ6V (5Ah)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bình GTZ6V (5Ah)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bình GTZ6V (5Ah)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmwl7kl9kwsod4@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmwl9628s83off@resize_w900_nl.webp', 0, 2);

-- Product: Cùm công tắc Light Master
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Light Master') INSERT INTO Brands (BrandName) VALUES (N'Light Master');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Light Master');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Cùm công tắc Light Master', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150, Winner X, NVX, Vario (Chế nhẹ)</p><p>Cùm công tắc Light Master không chỉ mang lại vẻ ngoài hiện đại với các nút bấm có đèn LED xanh bắt mắt mà còn tích hợp đầy đủ các chức năng cần thiết như: Tắt máy tạm thời, Passing (đá đèn), bật tắt đèn pha. Các nút bấm có độ phản hồi tốt, chống nước và bền bỉ dưới mọi điều kiện thời tiết.</p><h3>Thông số kỹ thuật</h3><ul><li>Màu LED: Xanh dương</li><li>Chức năng: Full chức năng (Còi, Xi nhan, Passing, Tắt máy, Đề)</li><li>Lắp đặt: Jack cắm theo xe (Exciter/Winner)</li><li>Tính năng: Trang trí dàn ghi đông, hỗ trợ đá đèn xin đường</li><li>Xuất xứ: Taiwan</li></ul>', 'cum-cong-tac-light-master', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbpbsdeack16fd@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LM-SWITCH-EX150', N'Mẫu cho Exciter 150', 550000, 660000, 440000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbpbsdeack16fd@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Exciter 150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LM-SWITCH-WINNERX', N'Mẫu cho Winner X', 550000, 660000, 440000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbpbsdeack16fd@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Winner X');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbpbsdeafcs2e1@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbpbsdeagrci9c@resize_w900_nl.webp', 0, 2);

-- Product: Ắc quy khô Globe WTZ7L-BP
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Globe') INSERT INTO Brands (BrandName) VALUES (N'Globe');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Globe');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Ắc quy khô Globe WTZ7L-BP', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> SH125/150, PCX, NVX, các dòng xe lên nhiều đèn trợ sáng</p><p>Globe WTZ7L-BP là dòng ắc quy dung lượng cao (7Ah) thường được trang bị cho các dòng xe tay ga cao cấp hoặc xe phân khối lớn. Với khả năng lưu trữ điện năng lớn, bình giúp hệ thống khởi động vận hành mạnh mẽ và hỗ trợ tốt cho các thiết bị điện gắn thêm như đèn trợ sáng, còi đôi. Thiết kế chống tràn và chống rung động giúp bình hoạt động bền bỉ trên mọi địa hình.</p><h3>Thông số kỹ thuật</h3><ul><li>Điện thế: 12V</li><li>Dung lượng: 7Ah</li><li>Kích thước: 113 x 70 x 130 mm</li><li>Đặc tính: Miễn bảo trì, dòng phóng điện cao (CCA)</li><li>Tính năng: Cung cấp nguồn điện dồi dào, ổn định cho xe ga lớn</li><li>Xuất xứ: Việt Nam (Công nghệ Đài Loan)</li></ul>', 'ac-quy-kho-globe-wtz7l-bp', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb6mhxajisbce8@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GLOBE-WTZ7L-7AH', N'Bình WTZ7L-BP', 490000, 588000, 392000, 45, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb6mhxajisbce8@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bình WTZ7L-BP') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bình WTZ7L-BP');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bình WTZ7L-BP');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb6mi3vrvmc756@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb6milx1hi3ca5@resize_w900_nl.webp', 0, 2);

-- Product: Bugi NGK Iridium IX
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'NGK (Nhật Bản)') INSERT INTO Brands (BrandName) VALUES (N'NGK (Nhật Bản)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'NGK (Nhật Bản)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bugi NGK Iridium IX', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150/155, Winner, Vario, Air Blade, Raider</p><p>Bugi NGK Iridium IX sở hữu đầu cực trung tâm làm từ kim loại quý Iridium với độ nóng chảy cực cao. Điều này cho phép tạo ra tia lửa điện cực mạnh và tập trung, giúp quá trình đốt cháy nhiên liệu triệt để hơn. Sử dụng bugi Iridium giúp xe khởi động dễ dàng hơn, tăng tốc mượt mà và tiết kiệm nhiên liệu đáng kể so với bugi tiêu chuẩn.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Đầu kim Iridium</li><li>Chỉ số nhiệt: 8</li><li>Đặc tính: Khả năng đánh lửa cực nhạy, chịu nhiệt cao</li><li>Chu kỳ thay thế: 15.000 – 20.000 km</li><li>Tính năng: Tối ưu hóa hiệu suất động cơ, giảm tình trạng đóng cặn carbon</li><li>Xuất xứ: Nhật Bản</li></ul>', 'bugi-ngk-iridium-ix', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b3aa76c7cd5c19fdabe0abd91c420b21@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'NGK-IRIDIUM-IX', N'Mẫu chân dài (CPR8EAIX-9)', 220000, 264000, 176000, 150, 'https://down-vn.img.susercontent.com/file/b3aa76c7cd5c19fdabe0abd91c420b21@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu chân dài (CPR8EAIX-9)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu chân dài (CPR8EAIX-9)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu chân dài (CPR8EAIX-9)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/41a3e1929fd89d47dd1682e6d542b686@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/081f22c03c52eb1b58121fe632fcc0e3@resize_w900_nl.webp', 0, 2);

-- Product: Đèn hậu LED TST mẫu Audi
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'TST Design') INSERT INTO Brands (BrandName) VALUES (N'TST Design');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'TST Design');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Đèn hậu LED TST mẫu Audi', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><p>Đèn hậu TST lấy cảm hứng từ các dòng xe hơi Audi sang trọng với hiệu ứng chạy LED (Sequential) cực đẹp khi xi nhan. Đèn có nhiều chế độ chớp Stop khi bóp phanh, giúp tăng khả năng nhận diện cho xe phía sau. Mặt kính đèn được phủ màu khói (Smoke) mang lại vẻ ngoài mạnh mẽ và cứng cáp cho phần đuôi xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại LED: LED SMD siêu sáng</li><li>Chế độ: Demi, Brake (chớp F1), Signal (chạy Audi)</li><li>Màu sắc: Kính khói, ánh sáng đỏ/vàng</li><li>Lắp đặt: Plug and Play (Thay thế đèn zin)</li><li>Tính năng: Trang trí xe, tăng hiệu năng cảnh báo</li><li>Xuất xứ: Đài Loan</li></ul>', 'en-hau-led-tst-mau-audi', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8yp4piinczm45@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'TST-TAIL-EX', N'Cho Exciter 150/155', 750000, 900000, 600000, 12, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8yp4piinczm45@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter 150/155') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Exciter 150/155');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter 150/155');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'TST-TAIL-WINNERX', N'Cho Winner X', 750000, 900000, 600000, 8, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8yp4piinczm45@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Winner X');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8yjvjcuhl6vca@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8yjvmw7b7u665@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8yjvq6ohu9z16@resize_w900_nl.webp', 0, 3);

-- Product: Mobin sườn MSD
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'MSD') INSERT INTO Brands (BrandName) VALUES (N'MSD');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'MSD');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Mobin sườn MSD', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe xăng cơ (Carburetor) và xe phun xăng điện tử (FI)</p><p>Mobin sườn MSD là phụ tùng không thể thiếu cho các bản độ máy. Sản phẩm giúp khuếch đại dòng điện từ IC/ECU đến bugi một cách mạnh mẽ và nhanh chóng. Lửa ra từ mobin MSD có màu xanh đậm, tia lửa dài và dứt khoát, giúp động cơ đốt sạch hoàn toàn hỗn hợp xăng gió, từ đó cải thiện gia tốc và giúp xe vận hành ổn định ở dải vòng tua cao.</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Lõi đồng nguyên chất, vỏ nhựa cách điện cao cấp</li><li>Đặc tính: Điện áp đầu ra cực cao, chống nhiễu tốt</li><li>Phụ kiện: Kèm dây phin MSD chính hãng</li><li>Tính năng: Tăng khả năng đánh lửa, hỗ trợ xe bốc hơn</li><li>Xuất xứ: Mỹ (USA)</li></ul>', 'mobin-suon-msd', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4jzj3xu73t331_tn', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phân loại') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phân loại');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phân loại');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MSD-COIL-FI', N'Mẫu cho xe FI', 2100000, 2520000, 1680000, 15, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4jzj3xu73t331_tn', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho xe FI') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu cho xe FI');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho xe FI');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4jzjbtync6oa7@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4jzjj3c0u87a1@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4jzjp5f8inkf7@resize_w900_nl.webp', 0, 3);

-- CATEGORY: Mũ & Bảo hộ
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Mũ & Bảo hộ') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Mũ & Bảo hộ', 'mu-bao-ho', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Mũ & Bảo hộ');

-- CATEGORY: Phụ tùng & Phụ kiện
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Phụ tùng & Phụ kiện') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Phụ tùng & Phụ kiện', 'phu-tung-phu-kien', 1);
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Phụ tùng & Phụ kiện');

-- Product: Gương chiếu hậu Rizoma Elisse
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Rizoma (Phong cách)') INSERT INTO Brands (BrandName) VALUES (N'Rizoma (Phong cách)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Rizoma (Phong cách)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Gương chiếu hậu Rizoma Elisse', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các dòng xe máy</p><p>Gương Rizoma Elisse được gia công hoàn toàn từ nhôm CNC sắc sảo với mặt kính chống chói màu xanh đặc trưng, giúp người lái quan sát tốt hơn khi có ánh đèn xe phía sau chiếu vào ban đêm. Thiết kế góc cạnh thể thao, sang trọng, có thể xoay 360 độ linh hoạt để điều chỉnh góc nhìn. Đây là món đồ chơi không thể thiếu để làm gọn và tăng độ thẩm mỹ cho phần đầu xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhôm CNC nguyên khối</li><li>Mặt kính: Kính xanh chống chói</li><li>Màu sắc: Đen, Bạc, Vàng</li><li>Tính năng: Quan sát phía sau, chống chói, trang trí xe</li><li>Phụ kiện: Đầy đủ ốc pát đi kèm cho mọi loại xe</li></ul>', 'guong-chieu-hau-rizoma-elisse', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzi4lnjldykt9f@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RIZOMA-ELISSE-BLK', N'Màu Đen', 250000, 300000, 200000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzi4lnjldykt9f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RIZOMA-ELISSE-SIL', N'Màu Bạc', 250000, 300000, 200000, 40, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzi4lnjldykt9f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Bạc');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjbcbzs3sgzq82@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjbcbzt3rj0kf3@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjbcbztb0sn6cf@resize_w900_nl.webp', 0, 3);

-- Product: Bao tay Barracuda
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Barracuda') INSERT INTO Brands (BrandName) VALUES (N'Barracuda');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Barracuda');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bao tay Barracuda', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Tất cả các loại xe máy</p><p>Bao tay Barracuda nổi tiếng với thiết kế kết hợp giữa cao su mềm mại và các vòng nhôm CNC tinh tế. Sản phẩm mang lại cảm giác cầm nắm cực kỳ êm ái, bám tay kể cả khi trời mưa hoặc ra mồ hôi tay, giúp giảm rung chấn từ ghi đông truyền lên bàn tay khi đi đường dài. Thiết kế mang đậm phong cách châu Âu, tạo điểm nhấn đẳng cấp cho tay lái.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Cao su chống trượt + Nhôm CNC</li><li>Màu sắc: Đen-Bạc, Đen-Đỏ, Đen-Vàng</li><li>Tính năng: Tăng độ bám tay, giảm tê tay, trang trí tay lái</li><li>Xuất xứ: Ý</li></ul>', 'bao-tay-barracuda', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/d8c4f25d948f645ba43a9ed4d0224423@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BARRA-GRIPS-BS', N'Đen-Bạc', 450000, 540000, 360000, 30, 'https://down-vn.img.susercontent.com/file/d8c4f25d948f645ba43a9ed4d0224423@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen-Bạc');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BARRA-GRIPS-BR', N'Đen-Đỏ', 450000, 540000, 360000, 20, 'https://down-vn.img.susercontent.com/file/d8c4f25d948f645ba43a9ed4d0224423@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen-Đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/f8b3d115ff56df3b531e399fb40a6eee@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/eb31a99fbc262932e5942d2e1234dd8a@resize_w900_nl.webp', 0, 2);

-- Product: Xi nhan Spirit Beast L19
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Spirit Beast') INSERT INTO Brands (BrandName) VALUES (N'Spirit Beast');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Spirit Beast');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Xi nhan Spirit Beast L19', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter, Winner, Raider, Vario, các dòng xe tay ga</p><p>Spirit Beast L19 là dòng xi nhan LED có thiết kế mũi tên hiện đại và hiệu ứng chạy đuổi (Audi style) cực kỳ bắt mắt. Đèn có 2 chế độ: đèn định vị ban ngày (màu xanh hoặc đỏ) và đèn xi nhan (màu vàng). Vỏ đèn làm từ nhựa ABS cao cấp kết hợp cao su dẻo chống gãy khi va chạm, đảm bảo độ bền cao và khả năng chống nước tuyệt đối.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại bóng: LED SMD siêu sáng</li><li>Tính năng: Chống nước IP67, hiệu ứng chạy đuổi</li><li>Điện áp: 12V</li><li>Màu định vị: Xanh dương / Đỏ</li><li>Xuất xứ: Trung Quốc (Nội địa cao cấp)</li></ul>', 'xi-nhan-spirit-beast-l19', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m3w8w33jgs2p8e@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SPIRIT-L19-BLUE', N'Định vị xanh dương', 280000, 336000, 224000, 70, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m3w8w33jgs2p8e@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị xanh dương') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Định vị xanh dương');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị xanh dương');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SPIRIT-L19-RED', N'Định vị đỏ', 280000, 336000, 224000, 50, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m3w8w33jgs2p8e@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Định vị đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/ca53675a69ec6cbb85ff4f9c8291496f@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b378c66e609d4a637e434118d837a487@resize_w900_nl.webp', 0, 2);

-- Product: Gác chân sau nhôm CNC nguyên khối
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'H2C / Racing Boy ( RCB)') INSERT INTO Brands (BrandName) VALUES (N'H2C / Racing Boy ( RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'H2C / Racing Boy ( RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Gác chân sau nhôm CNC nguyên khối', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Wave, Dream, Future, Vario, Air Blade</p><p>Thay thế cho gác chân sắt bọc cao su nguyên bản, gác chân nhôm CNC mang lại vẻ ngoài cứng cáp và sắc lạnh. Các đường rãnh được phay CNC tỉ mỉ không chỉ giúp trang trí mà còn tăng độ ma sát cho người ngồi sau, tránh trơn trượt chân khi đi mưa. Màu nhôm nhuộm Anode bền bỉ, không bị bay màu theo thời gian.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Hợp kim nhôm 6061 CNC</li><li>Màu sắc: Bạc, Đen, Đỏ</li><li>Lắp đặt: Plug and Play (như zin)</li><li>Tính năng: Chống trượt, tăng tính thẩm mỹ cho thân xe</li></ul>', 'gac-chan-sau-nhom-cnc-nguyen-khoi', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-levbs3v4hh7b3e@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'CNC-FOOTREST-SIL', N'Màu Bạc CNC', 350000, 420000, 280000, 40, 'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-levbs3v4hh7b3e@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc CNC') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Bạc CNC');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc CNC');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-gzrgns238gov48@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-levbs3qeodje80@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-levbs3rsmclz32@resize_w900_nl.webp', 0, 3);

-- Product: Cùm tăng tốc Domino
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Domino') INSERT INTO Brands (BrandName) VALUES (N'Domino');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Domino');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Cùm tăng tốc Domino', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe côn tay (Exciter, Winner, PKL), xe độ</p><p>Cùm tăng tốc Domino giúp rút ngắn hành trình tay ga, giúp xe vọt nhanh hơn và đạt tốc độ tối đa trong thời gian ngắn hơn. Đây là món đồ chơi cực kỳ hữu ích cho những ai yêu thích cảm giác lái thể thao và muốn xe phản ứng nhạy bén hơn. Sản phẩm đi kèm 2 ống ga để tùy chỉnh độ nhạy theo ý thích người lái.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhựa kỹ thuật cao cấp + Nhôm</li><li>Phụ kiện: Bao gồm 2 dây ga Thái Lan và ống ga</li><li>Tính năng: Rút ngắn hành trình ga, giúp xe tăng tốc nhanh</li><li>Xuất xứ: Ý</li></ul>', 'cum-tang-toc-domino', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/cf796129c560a341f3a47a07cc958c72@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DOMINO-XM2-ITALY', N'Mẫu 2 dây ga dưới (XM2)', 1850000, 2220000, 1480000, 30, 'https://down-vn.img.susercontent.com/file/cf796129c560a341f3a47a07cc958c72@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu 2 dây ga dưới (XM2)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu 2 dây ga dưới (XM2)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu 2 dây ga dưới (XM2)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/7c6ddb3f4920c08a623847682c5a9355@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/a98b74be3f80aedd9e74c5ab7f7ec879@resize_w900_nl.webp', 0, 2);

-- Product: Bugi NGK Iridium IX CPR8EAIX-9
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'NGK') INSERT INTO Brands (BrandName) VALUES (N'NGK');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'NGK');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bugi NGK Iridium IX CPR8EAIX-9', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter, Winner, Raider, Vario, Air Blade</p><p>Đầu điện cực bằng kim loại quý Iridium siêu nhỏ giúp tia lửa tập trung mạnh mẽ, hỗ trợ đốt cháy nhiên liệu triệt để, giúp xe khởi động dễ dàng và tiết kiệm xăng hơn.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu điện cực: Iridium</li><li>Mã sản phẩm: CPR8EAIX-9</li><li>Độ bền: 30.000 – 50.000 km</li><li>Tính năng: Đánh lửa cực mạnh, chịu nhiệt cao</li><li>Xuất xứ: Nhật Bản</li></ul>', 'bugi-ngk-iridium-ix-cpr8eaix-9', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/cf26d32bbda4d2ce4d04ce8c8a3747c3@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'NGK-IRIDIUM-IX-LONG', N'Chân dài (Cho Exciter/Winner/Vario)', 220000, 264000, 176000, 150, 'https://down-vn.img.susercontent.com/file/cf26d32bbda4d2ce4d04ce8c8a3747c3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Chân dài (Cho Exciter/Winner/Vario)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Chân dài (Cho Exciter/Winner/Vario)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Chân dài (Cho Exciter/Winner/Vario)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/7e4a82648dcf1443d16e58b5f671aeaa@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/93ba0e9f03d37eacb06cd3dcb075c279@resize_w900_nl.webp', 0, 2);

-- Product: Lọc gió trụ K&N 1280
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'K&N') INSERT INTO Brands (BrandName) VALUES (N'K&N');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'K&N');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lọc gió trụ K&N 1280', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Xe độ họng xăng lớn, xe côn tay đi lọc trụ</p><p>Lọc gió vĩnh cửu có khả năng vệ sinh và tái sử dụng, giúp lượng không khí nạp vào buồng đốt mạnh hơn lọc giấy zin, tối ưu công suất động cơ.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Lưới cotton tẩm dầu (Gauze)</li><li>Kích thước: Miệng họng 51mm</li><li>Tính năng: Tăng lưu lượng khí nạp, lọc bụi mịn, tái sử dụng được</li><li>Xuất xứ: Mỹ</li></ul>', 'loc-gio-tru-kn-1280', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-22100-kgs7glreobjvfb@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'KN-1280-USA-51', N'Họng 51mm', 950000, 1140000, 760000, 40, 'https://down-vn.img.susercontent.com/file/sg-11134201-22100-kgs7glreobjvfb@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Họng 51mm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Họng 51mm');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Họng 51mm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/84bf5e0b7ee8fc24505af34b57478ac3@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-22100-f264amreobjv30@resize_w900_nl.webp', 0, 2);

-- Product: Bộ nồi xe tay ga FCC
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'FCC') INSERT INTO Brands (BrandName) VALUES (N'FCC');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'FCC');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bộ nồi xe tay ga FCC', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Honda SH, Vario, Air Blade, Vision</p><p>Phụ tùng thay thế tiêu chuẩn giúp khắc phục hoàn toàn tình trạng rung đầu khi lên ga, giúp xe bắt nồi nhạy và vận hành êm ái hơn.</p><h3>Thông số kỹ thuật</h3><ul><li>Trọn bộ: Gồm Chuông nồi và Bố ba càng</li><li>Chất liệu: Hợp kim chịu nhiệt, phíp bố cao cấp</li><li>Tính năng: Chống rung đầu, không trượt nồi</li><li>Xuất xứ: Nhật Bản</li></ul>', 'bo-noi-xe-tay-ga-fcc', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m6nk2cujyj4obe@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'FCC-SET-VARIO', N'Bộ cho Vario/AB 125-150', 850000, 1020000, 680000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m6nk2cujyj4obe@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB 125-150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Vario/AB 125-150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB 125-150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'FCC-SET-SHVN', N'Bộ cho SH Việt Nam', 1200000, 1440000, 960000, 15, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m6nk2cujyj4obe@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho SH Việt Nam') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho SH Việt Nam');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho SH Việt Nam');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m6nk2cuty4iged@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m6nk2cuty4hk11@resize_w900_nl.webp', 0, 2);

-- Product: Lá côn độ Light Speed Racing
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Light Speed') INSERT INTO Brands (BrandName) VALUES (N'Light Speed');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Light Speed');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lá côn độ Light Speed Racing', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><p>Hợp chất giấy nén chịu nhiệt cao tăng độ bám, chống cháy lá côn khi vận hành ở cường độ cao, giúp cảm giác bóp côn và sang số dứt khoát.</p><h3>Thông số kỹ thuật</h3><ul><li>Số lượng: Bộ 5 lá</li><li>Chất liệu: Phíp giấy chịu nhiệt cao cấp</li><li>Tính năng: Bắt nồi nhanh, chống cháy, sạch nhớt</li><li>Xuất xứ: Đài Loan</li></ul>', 'la-con-o-light-speed-racing', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/4a082b44d0bd9bfe529bd917f42ef7a3@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-CLUTCH-EX150', N'Bộ cho Exciter 150', 450000, 540000, 360000, 30, 'https://down-vn.img.susercontent.com/file/4a082b44d0bd9bfe529bd917f42ef7a3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-CLUTCH-WINNER', N'Bộ cho Winner X', 480000, 576000, 384000, 30, 'https://down-vn.img.susercontent.com/file/4a082b44d0bd9bfe529bd917f42ef7a3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b78bd6b1888a33b0e74cb39c01fe14b6@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/84dac407855de5ca7e73094784674507@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/b4900244a725b66e23596ec6d9418244@resize_w900_nl.webp', 0, 3);

-- Product: Lò xo đầu độ Uma Racing
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Uma Racing') INSERT INTO Brands (BrandName) VALUES (N'Uma Racing');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Uma Racing');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lò xo đầu độ Uma Racing', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 135/150, Winner X (Xe độ máy)</p><p>Thép đàn hồi cường độ cao giúp súp bắp đóng mở chính xác ở vòng tua cao, không bị lún lò xo, bảo vệ động cơ khi ép máy tốc độ cao.</p><h3>Thông số kỹ thuật</h3><ul><li>Số lượng: Bộ 4 lò xo</li><li>Chất liệu: Thép Silicon (SiCr)</li><li>Tính năng: Chịu vòng tua máy cao, độ đàn hồi bền bỉ</li><li>Xuất xứ: Malaysia</li></ul>', 'lo-xo-au-o-uma-racing', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-82608-mj58vlibrf2e1f@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'UMA-SPRING-EX', N'Bộ cho Exciter', 380000, 456000, 304000, 25, 'https://down-vn.img.susercontent.com/file/sg-11134201-82608-mj58vlibrf2e1f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'UMA-SPRING-WIN', N'Bộ cho Winner', 420000, 504000, 336000, 25, 'https://down-vn.img.susercontent.com/file/sg-11134201-82608-mj58vlibrf2e1f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Winner');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-82627-mj58vlox2jggc3@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-8260c-mj58vlxg12pz39@resize_w900_nl.webp', 0, 2);

-- Product: Nhông sên dĩa DID Vàng
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'DID') INSERT INTO Brands (BrandName) VALUES (N'DID');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'DID');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Nhông sên dĩa DID Vàng', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 135/150, Winner X, Wave, Dream, Future</p><p>Bộ nhông sên dĩa DID Vàng là sự lựa chọn hàng đầu cho các dòng xe số và xe côn tay. Với công nghệ nhiệt luyện đặc biệt của Nhật Bản, sên DID có độ bền cực cao, khả năng chịu tải lớn và rất ít bị giãn (chùn) sau thời gian dài sử dụng. Màu vàng bắt mắt giúp tăng tính thẩm mỹ, làm nổi bật phần chân xe.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại sên: 428D (9 ly)</li><li>Màu sắc: Vàng (Gold)</li><li>Chất liệu: Thép hợp kim nhiệt luyện</li><li>Tính năng: Truyền tải lực mượt mà, độ bền cao, thẩm mỹ đẹp</li><li>Xuất xứ: Nhật Bản (Gia công Thái Lan)</li></ul>', 'nhong-sen-dia-did-vang', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mato6us1wg6035@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DID-GOLD-EX150', N'Bộ cho Exciter 150 (14T-42T)', 450000, 540000, 360000, 40, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mato6us1wg6035@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150 (14T-42T)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter 150 (14T-42T)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150 (14T-42T)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DID-GOLD-WAVE', N'Bộ cho Wave/Dream (14T-36T)', 320000, 384000, 256000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mato6us1wg6035@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Wave/Dream (14T-36T)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Wave/Dream (14T-36T)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Wave/Dream (14T-36T)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-22120-32k1rh939ukve4@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mato6us1wfyv03@resize_w900_nl.webp', 0, 2);

-- Product: Dây curoa Bando
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Bando') INSERT INTO Brands (BrandName) VALUES (N'Bando');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Bando');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dây curoa Bando', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Honda SH, Vario, Air Blade, Vision</p><p>Bando là nhà sản xuất dây curoa số 1 thế giới. Dòng Bando Xanh (2 mặt răng) là phân khúc cao cấp nhất dành cho xe tay ga. Thiết kế hai mặt răng giúp dây cực kỳ linh hoạt, thoát nhiệt nhanh hơn và giảm thiểu tình trạng trượt dây khi xe vận hành ở tốc độ cao hoặc chở nặng, từ đó giúp xe vận hành êm ái và tiết kiệm nhiên liệu.</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Cao su chịu nhiệt + sợi Polyamide</li><li>Kiểu dáng: Double Notch (2 mặt răng)</li><li>Tính năng: Độ bền vượt trội, chống giãn, vận hành cực êm</li><li>Chu kỳ thay thế: 20.000 km</li><li>Xuất xứ: Nhật Bản</li></ul>', 'day-curoa-bando', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4qgowjnem6n32@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-BLUE-VARIO', N'Cho Vario/AB 125-150', 550000, 660000, 440000, 45, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4qgowjnem6n32@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario/AB 125-150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Vario/AB 125-150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario/AB 125-150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-BLUE-SH', N'Cho SH Việt Nam', 750000, 900000, 600000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4qgowjnem6n32@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho SH Việt Nam') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho SH Việt Nam');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho SH Việt Nam');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4qgowjnd76o0c@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m4qgowjnbsm8a6@resize_w900_nl.webp', 0, 2);

-- Product: Sên RK Takasago 428 ELO
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RK Takasago') INSERT INTO Brands (BrandName) VALUES (N'RK Takasago');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'RK Takasago');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Sên RK Takasago 428 ELO', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter 155, Winner X, Raider, Satria</p><p>Sên RK ELO có tích hợp phớt cao su (O-ring) giữa các mắt sên, giúp giữ lớp mỡ bôi trơn bên trong lõi sên không bị văng ra ngoài. Điều này giúp sên vận hành cực kỳ êm ái, giảm tiếng ồn "xè xè" khó chịu và tăng tuổi thọ sên gấp 2 lần so với sên không phớt. Đây là lựa chọn tuyệt vời cho các chuyến đi tour đường dài.</p><h3>Thông số kỹ thuật</h3><ul><li>Loại sên: 428 ELO (Có phớt cao su)</li><li>Màu sắc: Vàng (Gold)</li><li>Độ dài: 132 mắt</li><li>Tính năng: Giảm tiếng ồn, giữ mỡ bôi trơn, bền bỉ vượt trội</li><li>Xuất xứ: Nhật Bản (Gia công Malaysia)</li></ul>', 'sen-rk-takasago-428-elo', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj10qiq7oceq30@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RK-428ELO-GOLD', N'1 Sợi (132 mắt)', 850000, 1020000, 680000, 35, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj10qiq7oceq30@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1 Sợi (132 mắt)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1 Sợi (132 mắt)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1 Sợi (132 mắt)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj10qiq7r5jm74@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj10qiq7mxuafa@resize_w900_nl.webp', 0, 2);

-- Product: Nhông sên dĩa Light Speed
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Light Speed Racing') INSERT INTO Brands (BrandName) VALUES (N'Light Speed Racing');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Light Speed Racing');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Nhông sên dĩa Light Speed', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Exciter, Winner, Sonic</p><p>Dòng NSD Light Speed hướng tới sự bền bỉ và cứng cáp với lớp sơn tĩnh điện đen mờ chống rỉ sét. Nhông và dĩa được phay CNC từ thép C45 chất lượng cao, đảm bảo độ tròn tuyệt đối, giúp sên bắt vào răng dĩa êm ái, không gây rung lắc ở tốc độ cao. Đây là bộ sản phẩm có mức giá cực tốt so với hiệu năng mang lại.</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Thép C45 tinh luyện</li><li>Màu sắc: Đen mờ (Matte Black)</li><li>Quy cách: 7 ly hoặc 9 ly tùy loại xe</li><li>Tính năng: Chống mài mòn tốt, vận hành ổn định, giá thành hợp lý</li><li>Xuất xứ: Việt Nam (Công nghệ Đài Loan)</li></ul>', 'nhong-sen-dia-light-speed', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-x37jsz9k0aovb9@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-SPEED-EX150', N'Bộ cho Exciter 150', 380000, 456000, 304000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-x37jsz9k0aovb9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-SPEED-WINNER', N'Bộ cho Winner X', 390000, 468000, 312000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-x37jsz9k0aovb9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzpodzcwxd8t30@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzpodzdgwk9t9b@resize_w900_nl.webp', 0, 2);

-- Product: Bi nồi Bando cho xe tay ga
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Bando') INSERT INTO Brands (BrandName) VALUES (N'Bando');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Bando');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bi nồi Bando cho xe tay ga', @CatId, @BrandId, N'<p><strong>Phù hợp:</strong> Vario, Air Blade, Vision, SH, Lead</p><p>Bi nồi Bando được sản xuất bằng nhựa tự bôi trơn chất lượng cao, chịu nhiệt và chống mài mòn cực tốt. Bi có trọng lượng chuẩn xác tuyệt đối, giúp ly hợp trước hoạt động mượt mà, xe lên ga nhanh và ổn định, không bị tình trạng rung rần hay hú nồi do bi mòn không đều.</p><h3>Thông số kỹ thuật</h3><ul><li>Số lượng: Bộ 6 viên</li><li>Chất liệu: Nhựa chịu nhiệt + Lõi hợp kim</li><li>Tính năng: Giúp xe tăng tốc mượt, giảm tiếng ồn bộ nồi</li><li>Xuất xứ: Nhật Bản (Gia công Việt Nam)</li></ul>', 'bi-noi-bando-cho-xe-tay-ga', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsmscx5a@resize_w900_nl.webp', 1, 0);
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại sản phẩm');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại sản phẩm');
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-ROLLER-VARIO', N'Bộ cho Vario/AB (18g/20g)', 180000, 216000, 144000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsmscx5a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB (18g/20g)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Vario/AB (18g/20g)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB (18g/20g)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-ROLLER-VISION', N'Bộ cho Vision/Lead (12g/15g)', 160000, 192000, 128000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsmscx5a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vision/Lead (12g/15g)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Vision/Lead (12g/15g)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vision/Lead (12g/15g)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsle7323@resize_w900_nl.webp', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dft0ufza6@resize_w900_nl.webp', 0, 2);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsldshde@resize_w900_nl.webp', 0, 3);

COMMIT;