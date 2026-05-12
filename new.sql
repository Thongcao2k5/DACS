USE MotorcycleShopDB;
GO
BEGIN TRANSACTION;
DECLARE @Pid INT, @Vid INT, @Aid INT, @ValId INT, @CatId INT, @BrandId INT;

-- Create New Categories
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Dầu nhớt & Bôi trơn') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Dầu nhớt & Bôi trơn', 'dau-nhot-boi-tron', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Lốp xe & Vành') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Lốp xe & Vành', 'lop-xe-vanh', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hệ thống phanh') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Hệ thống phanh', 'he-thong-phanh', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Giảm xóc') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Giảm xóc', 'giam-xoc', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Ắc quy & Điện') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Ắc quy & Điện', 'ac-quy-ien', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Mũ & Bảo hộ') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Mũ & Bảo hộ', 'mu-bao-ho', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Phụ tùng & Phụ kiện') INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'Phụ tùng & Phụ kiện', 'phu-tung-phu-kien', 1);

-- CATEGORY: Dầu nhớt & Bôi trơn
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Dầu nhớt & Bôi trơn');

-- Product: Dầu nhớt Motul 7100 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motul') INSERT INTO Brands (BrandName) VALUES (N'Motul');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Motul');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Motul 7100 10W40', @CatId, @BrandId, N'<p>Dầu nhớt Motul 7100 10W40 là dòng dầu nhớt tổng hợp cao cấp nổi tiếng đến từ Pháp, được phát triển dành riêng cho các dòng xe côn tay và xe thể thao vận hành ở hiệu suất cao. Sản phẩm sử dụng công nghệ Ester độc quyền giúp tạo lớp màng bôi trơn bền chắc, giảm tối đa ma sát giữa các chi tiết máy và bảo vệ động cơ trong điều kiện hoạt động liên tục ở nhiệt độ cao. Nhờ khả năng ổn định độ nhớt cực tốt, dầu giúp động cơ vận hành êm ái, sang số nhẹ và hạn chế nóng máy khi đi đường dài hoặc chạy tốc độ cao.</p><p><strong>Phù hợp:</strong> Xe côn tay, xe thể thao</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic (100% tổng hợp)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN/SP, JASO MA2</li><li>Dung tích: 1L và 1.1L, 1.3L, 1.5L</li><li>Chu kỳ thay nhớt: 3000 – 5000 km</li><li>Tính năng: Giảm ma sát, bảo vệ hộp số, làm mát động cơ</li><li>Xuất xứ: Pháp</li></ul>', 'dau-nhot-motul-7100-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MOTUL7100-1L', N'1L', 320000, 384000, 224000, 70, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MOTUL7100-15L', N'1.5L', 450000, 540000, 315000, 50, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.5L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.5L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.5L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dầu nhớt Fuchs Silkolene Pro 4 10W40 XP
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Fuchs (Đức)') INSERT INTO Brands (BrandName) VALUES (N'Fuchs (Đức)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Fuchs (Đức)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Fuchs Silkolene Pro 4 10W40 XP', @CatId, @BrandId, N'<p>Fuchs Silkolene Pro 4 10W40 XP sử dụng công nghệ XP đột phá giúp tăng cường sức mạnh động cơ và tiết kiệm nhiên liệu. Với khả năng chống mài mòn vượt trội và ổn định nhiệt độ, sản phẩm giúp động cơ vận hành bền bỉ ngay cả trong điều kiện khắc nghiệt nhất của các giải đua. Lớp màng dầu bám chặt vào bề mặt kim loại giúp bảo vệ máy tối đa từ lúc khởi động.</p><p><strong>Phù hợp:</strong> Xe số, xe côn tay, xe PKL</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic Ester Base</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 3000 – 4000 km</li><li>Tính năng: Tối ưu công suất, bảo vệ bề mặt kim loại, ổn định áp suất dầu</li><li>Xuất xứ: Đức (Sản xuất tại Anh)</li></ul>', 'dau-nhot-fuchs-silkolene-pro-4-10w40-xp', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rcf5-lt7m583wecoi97@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'FUCHS-PRO4-1L', N'1L', 285000, 342000, 199500, 90, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rcf5-lt7m583wecoi97@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dầu nhớt Liqui Moly Motorbike Street Race 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Liqui Moly') INSERT INTO Brands (BrandName) VALUES (N'Liqui Moly');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Liqui Moly');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Liqui Moly Motorbike Street Race 10W40', @CatId, @BrandId, N'<p>Là sản phẩm chính thức của giải đua Moto2 và Moto3, Liqui Moly Street Race mang lại khả năng bôi trơn hoàn hảo. Dầu giúp bộ ly hợp (côn) hoạt động cực kỳ mượt mà, không bị trượt nồi. Khả năng làm sạch động cơ của Liqui Moly luôn đứng đầu phân khúc, giúp loại bỏ cặn bẩn và duy trì hiệu suất máy như mới.</p><p><strong>Phù hợp:</strong> Các dòng xe côn tay 150cc và xe PKL</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic (Tổng hợp toàn phần)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN Plus, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 3000 – 4500 km</li><li>Tính năng: Chống trượt ly hợp, làm sạch động cơ, chịu nhiệt cao</li><li>Xuất xứ: Đức</li></ul>', 'dau-nhot-liqui-moly-motorbike-street-race-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj9ed86a78che3@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIQUI-STREET-RACE-1L', N'1L', 360000, 432000, 251999, 65, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj9ed86a78che3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dầu nhớt Shell Advance Ultra 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Shell') INSERT INTO Brands (BrandName) VALUES (N'Shell');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Shell');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Shell Advance Ultra 10W40', @CatId, @BrandId, N'<p>Shell Advance Ultra được sản xuất từ khí thiên nhiên bằng công nghệ Shell PurePlus độc quyền. Dầu có độ tinh khiết cực cao, giúp duy trì công suất mạnh mẽ và bảo vệ động cơ khỏi các tác nhân gây hại. Sản phẩm giúp xe vận hành êm ái, giảm tiếng ồn động cơ và tiết kiệm nhiên liệu hiệu quả cho những chuyến đi dài.</p><p><strong>Phù hợp:</strong> Xe số đời mới, xe côn tay phổ thông</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: 100% Synthetic (Tổng hợp từ khí tự nhiên)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 2500 – 3500 km</li><li>Tính năng: Giữ sạch động cơ, giảm tiếng ồn, kéo dài tuổi thọ máy</li><li>Xuất xứ: Thái Lan / Việt Nam</li></ul>', 'dau-nhot-shell-advance-ultra-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj8lwxerffnp03@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SHELL-ULTRA-1L', N'1L', 260000, 312000, 182000, 150, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mj8lwxerffnp03@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dầu nhớt Repsol Racing 4T 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Repsol') INSERT INTO Brands (BrandName) VALUES (N'Repsol');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Repsol');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Repsol Racing 4T 10W40', @CatId, @BrandId, N'<p>Repsol Racing 4T là dòng dầu nhớt đại diện cho tinh thần của đội đua Repsol Honda tại MotoGP. Sản phẩm được thiết kế để bảo vệ tối đa hộp số và bộ ly hợp. Với công thức đặc biệt, dầu giúp xe phản ứng nhạy bén với tay ga, tăng tốc nhanh và duy trì màng dầu ổn định ở vòng tua máy cực cao.</p><p><strong>Phù hợp:</strong> Xe côn tay (Winner, Exciter, Raider) và Moto PKL</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: Fully Synthetic (Tổng hợp toàn phần)</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SN, JASO MA2</li><li>Dung tích: 1L</li><li>Chu kỳ thay nhớt: 3000 – 4000 km</li><li>Tính năng: Tăng tốc nhanh, bảo vệ hộp số tuyệt vời</li><li>Xuất xứ: Tây Ban Nha</li></ul>', 'dau-nhot-repsol-racing-4t-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/e209a889704c227eff6fc0c598b40aeb@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'REPSOL-RACING-1L', N'1L', 315000, 378000, 220500, 80, 'https://down-vn.img.susercontent.com/file/e209a889704c227eff6fc0c598b40aeb@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dầu nhớt Amsoil Metric 10W40
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Amsoil') INSERT INTO Brands (BrandName) VALUES (N'Amsoil');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Amsoil');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu nhớt Amsoil Metric 10W40', @CatId, @BrandId, N'<p>Amsoil Metric là dòng dầu nhớt Mỹ nổi tiếng với độ bền nhiệt cực cao. Sản phẩm giúp giảm thiểu tối đa tình trạng "nóng máy" - vấn đề thường gặp trên các dòng xe côn tay hiện nay. Công thức phụ gia tiên tiến của Amsoil giúp bảo vệ các chi tiết máy khỏi sự mài mòn hóa học và kéo dài thời gian sử dụng dầu lâu hơn so với các loại thông thường.</p><p><strong>Phù hợp:</strong> Xe PKL châu Âu, xe côn tay hiệu suất cao</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dầu: 100% Synthetic</li><li>Độ nhớt: SAE 10W40</li><li>Tiêu chuẩn: API SM/SN, JASO MA/MA2</li><li>Dung tích: 946ml (1 US Quart)</li><li>Chu kỳ thay nhớt: 4000 – 5000 km</li><li>Tính năng: Chống nóng máy, bảo vệ động cơ ưu việt, độ bền nhớt cao</li><li>Xuất xứ: Mỹ</li></ul>', 'dau-nhot-amsoil-metric-10w40', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/943bc75dc4f28a4ea3543314d98b7c7e@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'AMSOIL-METRIC-1L', N'946ml', 390000, 468000, 273000, 40, 'https://down-vn.img.susercontent.com/file/943bc75dc4f28a4ea3543314d98b7c7e@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'946ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'946ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'946ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Dầu nhớt & Bôi trơn
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Dầu nhớt & Bôi trơn');

-- Product: Dung dịch vệ sinh buồng đốt Liqui Moly Motorbike Carbon Cleaner
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Liqui Moly') INSERT INTO Brands (BrandName) VALUES (N'Liqui Moly');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Liqui Moly');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dung dịch vệ sinh buồng đốt Liqui Moly Motorbike Carbon Cleaner', @CatId, @BrandId, N'<p>Liqui Moly Carbon Cleaner là dung dịch phụ gia đổ trực tiếp vào bình xăng để làm sạch muội than bám trên đầu piston, súp bắp và buồng đốt sau thời gian dài vận hành. Sản phẩm giúp khôi phục công suất động cơ, giảm thiểu hiện tượng xe bị giật cục, gõ máy, đồng thời tối ưu hóa quá trình đốt cháy nhiên liệu để xe chạy bốc hơn và tiết kiệm xăng rõ rệt.</p><p><strong>Phù hợp:</strong> Tất cả các dòng xe máy (xe ga, xe số, xe côn tay)</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Phụ gia làm sạch (đổ pha xăng)</li><li>Dung tích: 80ml</li><li>Tỷ lệ pha: 1 chai 80ml dùng cho khoảng 5 – 8 lít xăng</li><li>Chu kỳ sử dụng: Mỗi 3000 – 5000 km/lần</li><li>Tính năng: Loại bỏ muội bám carbon, làm sạch kim phun/bộ chế hòa khí, tiết kiệm nhiên liệu</li><li>Xuất xứ: Đức</li></ul>', 'dung-dich-ve-sinh-buong-ot-liqui-moly-motorbike-carbon-cleaner', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-louu886sqr6373@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIQUI-CARBON-80ML', N'80ml', 95000, 114000, 66500, 200, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-louu886sqr6373@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Chai xịt dưỡng sên Spider Spray
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Spider Spray') INSERT INTO Brands (BrandName) VALUES (N'Spider Spray');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Spider Spray');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Chai xịt dưỡng sên Spider Spray', @CatId, @BrandId, N'<p>Xịt dưỡng sên Spider Spray nổi bật với công nghệ tạo màng liên kết dạng tơ nhện bám cực chắc vào các mắt sên, hạn chế tối đa tình trạng văng dung dịch ra mâm xe khi chạy tốc độ cao. Sản phẩm giúp sên vận hành êm ái, giảm ma sát, chống rỉ sét hiệu quả và kéo dài tuổi thọ của bộ nhông sên dĩa, đặc biệt chịu nước cực tốt khi đi trời mưa.</p><p><strong>Phù hợp:</strong> Xe côn tay, xe số sử dụng sên trần (không hộp sên)</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Dạng xịt tạo màng bám (Tơ nhện)</li><li>Dung tích: 600ml</li><li>Tính năng: Bôi trơn mắt sên, chống nước, chống rỉ sét, hạn chế văng</li><li>Xuất xứ: Việt Nam (Nguyên liệu nhập khẩu)</li></ul>', 'chai-xit-duong-sen-spider-spray', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rd6s-m6p6ijzvenize7@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SPIDER-SPRAY-600ML', N'600ml', 190000, 228000, 133000, 120, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rd6s-m6p6ijzvenize7@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'600ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'600ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'600ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dung dịch vệ sinh sên WOW Chain Cleaner
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'WOW') INSERT INTO Brands (BrandName) VALUES (N'WOW');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'WOW');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dung dịch vệ sinh sên WOW Chain Cleaner', @CatId, @BrandId, N'<p>WOW Chain Cleaner là trợ thủ đắc lực giúp đánh bay nhanh chóng mọi vết dầu mỡ, bụi đất bẩn bám lâu ngày trên nhông sên dĩa. Công thức đặc biệt của sản phẩm cực kỳ an toàn cho các loại sên có vòng cao su (như O-ring, X-ring, Z-ring), giúp bề mặt sên sạch bóng như mới mà không làm khô ráp hay hỏng các chi tiết cao su bên trong.</p><p><strong>Phù hợp:</strong> Tất cả các dòng xe số, xe côn tay sử dụng xích truyền động</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Dạng xịt tẩy rửa mạnh</li><li>Dung tích: 500ml</li><li>Tính năng: Tẩy sạch dầu mỡ, bùn đất bám trên sên, an toàn cho sên có vòng cao su</li><li>Xuất xứ: Thái Lan</li></ul>', 'dung-dich-ve-sinh-sen-wow-chain-cleaner', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/c3cd4e6c4ee1b828969863aa9483fa72@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'WOW-CHAIN-CLEAN-500ML', N'500ml', 110000, 132000, 77000, 150, 'https://down-vn.img.susercontent.com/file/c3cd4e6c4ee1b828969863aa9483fa72@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'500ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Nước làm mát động cơ Liqui Moly Coolant Ready Mix RAF 12 Plus
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Liqui Moly') INSERT INTO Brands (BrandName) VALUES (N'Liqui Moly');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Liqui Moly');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Nước làm mát động cơ Liqui Moly Coolant Ready Mix RAF 12 Plus', @CatId, @BrandId, N'<p>Nước làm mát Liqui Moly đỏ là dòng sản phẩm cao cấp đã pha sẵn, sử dụng công nghệ OAT tiên tiến giúp tối ưu hóa khả năng truyền nhiệt và làm mát động cơ cực nhanh. Với thành phần chống ăn mòn vượt trội, sản phẩm ngăn ngừa tối đa tình trạng đóng cặn bẩn, rỉ sét trong két nước và đường ống, giúp hệ thống làm mát hoạt động bền bỉ, ổn định nhiệt độ xe khi đi đường dài.</p><p><strong>Phù hợp:</strong> Xe ga và xe côn tay sử dụng hệ thống làm mát bằng dung dịch</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Nước làm mát pha sẵn (Ready Mix - Không cần pha thêm nước)</li><li>Màu sắc: Đỏ (Pink/Red)</li><li>Dung tích: 1L</li><li>Chu kỳ thay thế: Khoảng 20.000 km hoặc sau 2 năm sử dụng</li><li>Tính năng: Giải nhiệt nhanh, chống ăn mòn két nước, chống đóng cặn</li><li>Xuất xứ: Đức</li></ul>', 'nuoc-lam-mat-ong-co-liqui-moly-coolant-ready-mix-raf-12-plus', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mg57qr02x4p9e4@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIQUI-COOLANT-RED-1L', N'1L', 175000, 210000, 122499, 85, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mg57qr02x4p9e4@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dung dịch súc rửa động cơ Motul Engine Clean Moto
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motul') INSERT INTO Brands (BrandName) VALUES (N'Motul');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Motul');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dung dịch súc rửa động cơ Motul Engine Clean Moto', @CatId, @BrandId, N'<p>Motul Engine Clean được đổ trực tiếp vào phần nhớt cũ trước khi thay nhớt mới. Dung dịch có tác dụng trung hòa axit, làm lỏng và cuốn trôi toàn bộ cặn bùn, muội carbon và mạt kim loại bám lâu ngày trong các ngóc ngách của lốc máy. Quá trình này giúp động cơ sạch sẽ hoàn toàn, tạo môi trường tối ưu để nhớt mới phát huy tối đa công năng bôi trơn.</p><p><strong>Phù hợp:</strong> Tất cả các dòng xe máy 4 thì</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Phụ gia súc lốc máy (hòa chung với nhớt cũ trước khi xả)</li><li>Dung tích: 200ml</li><li>Cách dùng: Đổ vào lốc nhớt cũ, nổ máy không tải 10 - 15 phút rồi xả bỏ hoàn toàn</li><li>Tính năng: Đẩy sạch cặn bẩn trong lốc máy, trung hòa axit, bảo vệ động cơ</li><li>Xuất xứ: Pháp</li></ul>', 'dung-dich-suc-rua-ong-co-motul-engine-clean-moto', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmr7d8p4ggle51@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MOTUL-ENGINE-CLEAN-200ML', N'200ml', 80000, 96000, 56000, 95, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmr7d8p4ggle51@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'200ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'200ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'200ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Chai xịt bóng vỏ (lốp) xe Sonax Tyre Care
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Sonax') INSERT INTO Brands (BrandName) VALUES (N'Sonax');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Sonax');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Chai xịt bóng vỏ (lốp) xe Sonax Tyre Care', @CatId, @BrandId, N'<p>Sonax Tyre Care là dung dịch chăm sóc lốp xe chuyên sâu dạng bọt mịn. Sản phẩm không chỉ mang lại vẻ ngoài đen bóng, sạch sẽ như mới cho lốp xe mà còn thấm sâu vào các thớ cao su, giữ cho lốp luôn có độ đàn hồi tốt, ngăn ngừa hiện tượng nứt nẻ, bạc màu và lão hóa lốp do tác động của ánh nắng mặt trời và thời tiết.</p><p><strong>Phù hợp:</strong> Tất cả các loại lốp (vỏ) xe máy, ô tô</p><h3>Thông số kỹ thuật</h3><ul><li>Loại dung dịch: Dạng xịt tạo bọt dưỡng cao su</li><li>Dung tích: 400ml</li><li>Tính năng: Làm đen bóng lốp, chống nứt nẻ, bảo dưỡng và kéo dài tuổi thọ cao su</li><li>Xuất xứ: Đức</li></ul>', 'chai-xit-bong-vo-lop-xe-sonax-tyre-care', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/1e366c2a033455e0ee252a3286efa494@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SONAX-TYRE-CARE-400ML', N'400ml', 210000, 252000, 147000, 60, 'https://down-vn.img.susercontent.com/file/1e366c2a033455e0ee252a3286efa494@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'400ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'400ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'400ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Hệ thống phanh
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Hệ thống phanh');

-- Product: Bố thắng Brembo Carbon Ceramic
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Brembo') INSERT INTO Brands (BrandName) VALUES (N'Brembo');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Brembo');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bố thắng Brembo Carbon Ceramic', @CatId, @BrandId, N'<p>Bố thắng Brembo Carbon Ceramic được cấu tạo từ hỗn hợp gốm và carbon cao cấp, mang lại lực phanh ổn định và êm ái. Sản phẩm giúp giảm thiểu tình trạng bó phanh khi hoạt động ở nhiệt độ cao và không gây mòn đĩa phanh nhanh như các loại bố kim loại thông thường. Đây là phụ tùng thay thế hoàn hảo cho những người dùng muốn cải thiện độ an toàn và cảm giác phanh thực tế trên xe.</p><p><strong>Phù hợp:</strong> Xe côn tay (Winner, Exciter), xe PKL</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Carbon Ceramic (Gốm carbon)</li><li>Khả năng chịu nhiệt: Cực tốt, không bị biến dạng ở nhiệt độ cao</li><li>Đặc tính: Ít tạo bụi phanh, không gây tiếng kêu rít</li><li>Chu kỳ thay thế: 10.000 – 15.000 km tùy điều kiện sử dụng</li><li>Tính năng: Phanh êm, lực phanh chuẩn, bảo vệ đĩa phanh</li><li>Xuất xứ: Ý</li></ul>', 'bo-thang-brembo-carbon-ceramic', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/JM4AAeSwBGxpxk8j/s-l1600.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-PAD-FRONT', N'Hàng Trước', 550000, 660000, 385000, 50, 'https://i.ebayimg.com/images/g/JM4AAeSwBGxpxk8j/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Trước') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Hàng Trước');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Trước');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-PAD-REAR', N'Hàng Sau', 480000, 576000, 336000, 30, 'https://i.ebayimg.com/images/g/JM4AAeSwBGxpxk8j/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Sau') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Hàng Sau');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Hàng Sau');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Đĩa phanh Galfer lòng nhôm (Size 245mm)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Galfer') INSERT INTO Brands (BrandName) VALUES (N'Galfer');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Galfer');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Đĩa phanh Galfer lòng nhôm (Size 245mm)', @CatId, @BrandId, N'<p>Đĩa phanh Galfer lòng nhôm được thiết kế với kiểu dáng răng cưa đặc trưng, không chỉ tăng tính thẩm mỹ mà còn giúp tản nhiệt cực nhanh khi phanh gấp. Phần lòng đĩa làm từ hợp kim nhôm CNC nhuộm màu sắc sảo, giúp trọng lượng đĩa nhẹ hơn đĩa zin đáng kể nhưng vẫn đảm bảo độ bền và độ cứng vững chắc dưới áp lực phanh lớn.</p><p><strong>Phù hợp:</strong> Exciter 150, Winner X, Vario (có pát chuyển)</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Thép chịu lực chịu nhiệt + Lòng nhôm CNC</li><li>Đường kính: 245mm</li><li>Độ dày: 3.5mm - 4.0mm</li><li>Kiểu dáng: Răng cưa (Wave design)</li><li>Tính năng: Tăng lực phanh, tản nhiệt nhanh, trang trí xe</li><li>Xuất xứ: Tây Ban Nha (Gia công CNC)</li></ul>', 'ia-phanh-galfer-long-nhom-size-245mm', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-maz55dzozro881_tn', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GALFER-245-BLACK', N'Lòng Đen', 1250000, 1500000, 875000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-maz55dzozro881_tn', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lòng Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GALFER-245-GOLD', N'Lòng Vàng', 1250000, 1500000, 875000, 15, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-maz55dzozro881_tn', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lòng Vàng');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lòng Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Tay thắng Racing Boy (RCB)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Racing Boy (RCB)') INSERT INTO Brands (BrandName) VALUES (N'Racing Boy (RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Racing Boy (RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Tay thắng Racing Boy (RCB)', @CatId, @BrandId, N'<p>Tay thắng RCB dòng E2 là mẫu nâng cấp phổ biến nhất nhờ giá thành hợp lý và độ bền cao. Tay thắng được làm từ nhôm nguyên khối, cảm giác bóp phanh êm ái, chắc chắn hơn tay thắng zin. Thiết kế khí động học cùng các nấc điều chỉnh giúp người lái dễ dàng tùy chỉnh khoảng cách tay thắng sao cho phù hợp với kích thước bàn tay, giảm mỏi khi đi đường dài.</p><p><strong>Phù hợp:</strong> Các dòng xe phổ thông (Wave, Dream, Future, Exciter, Winner)</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhôm đúc nguyên khối</li><li>Màu sắc: Đen, Bạc, Đỏ, Vàng, Xanh</li><li>Dung tích bình dầu: Tích hợp (đối với bên phải)</li><li>Tính năng: Điều chỉnh cự ly bóp phanh, tăng độ thẩm mỹ, lực bóp êm</li><li>Xuất xứ: Malaysia</li></ul>', 'tay-thang-racing-boy-rcb', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7raum-ma1kw8r5xuw251@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-E2-RIGHT', N'Bên Phải (Có bình dầu)', 450000, 540000, 315000, 60, 'https://down-vn.img.susercontent.com/file/sg-11134201-7raum-ma1kw8r5xuw251@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Phải (Có bình dầu)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bên Phải (Có bình dầu)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Phải (Có bình dầu)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-E2-LEFT', N'Bên Trái (Tay côn/phanh sau)', 250000, 300000, 175000, 40, 'https://down-vn.img.susercontent.com/file/sg-11134201-7raum-ma1kw8r5xuw251@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Trái (Tay côn/phanh sau)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bên Trái (Tay côn/phanh sau)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bên Trái (Tay côn/phanh sau)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dây dầu Hel chính hãng bấm đầu Earl's
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Hel Performance') INSERT INTO Brands (BrandName) VALUES (N'Hel Performance');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Hel Performance');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dây dầu Hel chính hãng bấm đầu Earl''s', @CatId, @BrandId, N'<p>Dây dầu Hel nổi tiếng với lõi Teflon chịu nhiệt và lớp vỏ bọc thép không gỉ (Stainless Steel braided). Khác với dây cao su zin thường bị giãn nở khi dầu nóng làm phanh bị "lún", dây Hel giữ cho áp suất dầu luôn ổn định, giúp lực phanh truyền từ tay thắng xuống heo dầu luôn tức thời và chính xác nhất.</p><p><strong>Phù hợp:</strong> Tất cả các loại xe máy</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Lõi Teflon, vỏ bép thép không gỉ, bọc nhựa bảo vệ</li><li>Độ dài: 95cm (Phổ thông cho thắng trước)</li><li>Khả năng chịu áp: Lên đến 12.000 psi</li><li>Tính năng: Không giãn nở dây, tối ưu lực phanh, chống rò rỉ</li><li>Xuất xứ: Vương Quốc Anh (UK)</li></ul>', 'day-dau-hel-chinh-hang-bam-au-earls', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9nbjdewit1eb0@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HEL-RED-95CM', N'Màu Đỏ', 850000, 1020000, 595000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9nbjdewit1eb0@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HEL-CARBON-95CM', N'Màu Xanh Carbon', 850000, 1020000, 595000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9nbjdewit1eb0@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Xanh Carbon') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Xanh Carbon');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Xanh Carbon');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dầu thắng Brembo Brake Fluid DOT 4
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Brembo') INSERT INTO Brands (BrandName) VALUES (N'Brembo');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Brembo');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dầu thắng Brembo Brake Fluid DOT 4', @CatId, @BrandId, N'<p>Dầu thắng Brembo DOT 4 có điểm sôi cao vượt trội so với các loại dầu thông thường, giúp ngăn chặn hiện tượng "khóa hơi" (vapor lock) khi phanh liên tục trên đèo dốc hoặc chạy tốc độ cao. Dung dịch có độ nhớt ổn định giúp hệ thống phanh phản ứng nhạy bén, đồng thời chứa các chất phụ gia chống ăn mòn tuyệt vời cho các chi tiết kim loại và cao su bên trong heo dầu, tay thắng.</p><p><strong>Phù hợp:</strong> Hệ thống phanh đĩa trước và sau các dòng xe máy, ô tô</p><h3>Thông số kỹ thuật</h3><ul><li>Tiêu chuẩn: DOT 4</li><li>Điểm sôi khô: 260°C</li><li>Điểm sôi ướt: 165°C</li><li>Dung tích: 500ml</li><li>Tính năng: Chịu nhiệt cao, bảo vệ ron cao su, chống ăn mòn</li><li>Xuất xứ: Ý</li></ul>', 'dau-thang-brembo-brake-fluid-dot-4', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m26xdv8iy8c4c4@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BREMBO-DOT4-500ML', N'500ml', 290000, 348000, 203000, 120, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m26xdv8iy8c4c4@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'500ml');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'500ml');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Lốp xe & Vành
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Lốp xe & Vành');

-- Product: Lốp Michelin Pilot Street 2
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Michelin (Pháp)') INSERT INTO Brands (BrandName) VALUES (N'Michelin (Pháp)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Michelin (Pháp)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Michelin Pilot Street 2', @CatId, @BrandId, N'<p>Michelin Pilot Street 2 là dòng lốp danh tiếng với thiết kế gai lốp mới lấy cảm hứng từ lốp xe đua MotoGP. Các rãnh gai được tính toán tỉ mỉ giúp thoát nước cực nhanh, đảm bảo khả năng bám đường tuyệt vời trên bề mặt đường ướt. Hợp chất cao su đặc biệt giúp lốp có độ bền cao, ít bị ăn mòn và tăng quãng đường sử dụng, mang lại cảm giác lái tự tin và an toàn trong mọi điều kiện thời tiết.</p><p><strong>Phù hợp:</strong> Exciter, Winner, Vario, Air Blade, Raider</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Pilot Street 2 (Gai mũi tên)</li><li>Chất liệu: Hợp chất cao su Silica</li><li>Cấu trúc: Lốp không săm (TL)</li><li>Tính năng: Bám đường ướt vượt trội, độ bền cao, ổn định tay lái</li><li>Xuất xứ: Thái Lan / Việt Nam</li></ul>', 'lop-michelin-pilot-street-2', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/FvwAAOSwsZthSUDR/s-l1600.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MICH-PS2-709017', N'70/90-17 (Lốp trước)', 660000, 792000, 461999, 40, 'https://i.ebayimg.com/images/g/FvwAAOSwsZthSUDR/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17 (Lốp trước)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17 (Lốp trước)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17 (Lốp trước)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MICH-PS2-809017', N'80/90-17 (Lốp sau/trước)', 790000, 948000, 553000, 45, 'https://i.ebayimg.com/images/g/FvwAAOSwsZthSUDR/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17 (Lốp sau/trước)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17 (Lốp sau/trước)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17 (Lốp sau/trước)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lốp Pirelli Diablo Rosso Sport
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Pirelli (Ý)') INSERT INTO Brands (BrandName) VALUES (N'Pirelli (Ý)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Pirelli (Ý)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Pirelli Diablo Rosso Sport', @CatId, @BrandId, N'<p>Pirelli Diablo Rosso Sport mang DNA của dòng lốp Superbike danh tiếng vào các dòng xe nhỏ. Thiết kế gai lốp dạng "chớp" (Flash) đặc trưng không chỉ tăng độ ngầu cho xe mà còn tối ưu hóa diện tích tiếp xúc mặt đường khi nghiêng xe vào cua. Đây là lựa chọn số 1 cho những người dùng yêu thích tốc độ, cần độ bám đường tối đa ở cả đường khô và đường ướt.</p><p><strong>Phù hợp:</strong> Xe côn tay, xe thể thao (Underbone & Sportbike)</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Diablo Rosso Sport (Racing DNA)</li><li>Chất liệu: Cao su hiệu suất cao</li><li>Tính năng: Tối ưu khả năng vào cua, phản hồi lái chính xác, bám đường cực tốt</li><li>Xuất xứ: Indonesia</li></ul>', 'lop-pirelli-diablo-rosso-sport', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/E-AAAOSwIJ9mpCy8/s-l1600.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'PIRELLI-DRS-7090', N'70/90-17', 620000, 744000, 434000, 30, 'https://i.ebayimg.com/images/g/E-AAAOSwIJ9mpCy8/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'PIRELLI-DRS-12070', N'120/70-17 (Lốp sau size lớn)', 1150000, 1380000, 805000, 30, 'https://i.ebayimg.com/images/g/E-AAAOSwIJ9mpCy8/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau size lớn)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'120/70-17 (Lốp sau size lớn)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau size lớn)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lốp Dunlop TT902
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Dunlop (Nhật Bản)') INSERT INTO Brands (BrandName) VALUES (N'Dunlop (Nhật Bản)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Dunlop (Nhật Bản)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Dunlop TT902', @CatId, @BrandId, N'<p>Dunlop TT902 là dòng lốp tiêu chuẩn cho các dòng xe số phổ thông tại Việt Nam. Với thiết kế gai lốp truyền thống nhưng được cải tiến sâu về mặt kỹ thuật, lốp giúp xe vận hành nhẹ nhàng, tiết kiệm nhiên liệu và có khả năng chống đinh tốt. Dunlop TT902 nổi tiếng với sự bền bỉ, ít bị nứt nẻ sau thời gian dài sử dụng dưới nắng mưa.</p><p><strong>Phù hợp:</strong> Wave, Dream, Future, Future Neo</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: TT902</li><li>Đặc tính: Vận hành êm ái, bền bỉ, tiết kiệm xăng</li><li>Xuất xứ: Thái Lan / Việt Nam</li></ul>', 'lop-dunlop-tt902', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zwl-mimudeqcge86eb@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DUNLOP-TT902-7090', N'70/90-17', 420000, 504000, 294000, 70, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zwl-mimudeqcge86eb@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DUNLOP-TT902-8090', N'80/90-17', 510000, 612000, 357000, 50, 'https://down-vn.img.susercontent.com/file/sg-11134201-81zwl-mimudeqcge86eb@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lốp Aspira Premio Sportivo
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Aspira (Indonesia) - Thuộc tập đoàn Pirelli') INSERT INTO Brands (BrandName) VALUES (N'Aspira (Indonesia) - Thuộc tập đoàn Pirelli');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Aspira (Indonesia) - Thuộc tập đoàn Pirelli');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Aspira Premio Sportivo', @CatId, @BrandId, N'<p>Aspira Premio Sportivo được thừa hưởng công nghệ từ hãng Pirelli danh tiếng nhưng có mức giá dễ tiếp cận hơn. Lốp có thiết kế gai hướng tâm độc đáo giúp ổn định thân xe ở tốc độ cao và cho cảm giác lái rất chắc chắn. Hợp chất cao su lâu mòn giúp người dùng tiết kiệm chi phí bảo trì mà vẫn đảm bảo hiệu suất vận hành tốt.</p><p><strong>Phù hợp:</strong> Xe ga (Vario, Air Blade, Click), xe côn tay</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: Sportivo (Thể thao đường trường)</li><li>Công nghệ: Pro-Duo (Hai lớp hợp chất cao su)</li><li>Tính năng: Chống mài mòn tốt, ổn định khi chạy tốc độ cao</li><li>Xuất xứ: Indonesia</li></ul>', 'lop-aspira-premio-sportivo', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0jvnjstci335c@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ASPIRA-SP-908014', N'90/80-14 (Cho Vario/AB)', 550000, 660000, 385000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0jvnjstci335c@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-14 (Cho Vario/AB)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-14 (Cho Vario/AB)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-14 (Cho Vario/AB)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'ASPIRA-SP-1008014', N'100/80-14 (Cho Vario/AB)', 680000, 816000, 475999, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0jvnjstci335c@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-14 (Cho Vario/AB)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-14 (Cho Vario/AB)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-14 (Cho Vario/AB)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lốp Continental ContiStreet
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Continental (Đức)') INSERT INTO Brands (BrandName) VALUES (N'Continental (Đức)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Continental (Đức)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Continental ContiStreet', @CatId, @BrandId, N'<p>Continental ContiStreet là dòng lốp được phát triển bởi các kỹ sư Đức, dựa trên dòng lốp PKL ContiRoad nổi tiếng. Lốp có thiết kế rãnh gai sâu giúp thoát nước hiệu quả và tăng độ bám khi nghiêng xe. Đặc biệt, lốp được cấu tạo để giữ được hiệu suất ổn định từ khi mới lắp cho đến khi lốp mòn gần hết, không bị chai cứng theo thời gian.</p><p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><h3>Thông số kỹ thuật</h3><ul><li>Kiểu gai: ContiStreet</li><li>Công nghệ: Engineered in Germany</li><li>Tính năng: Hiệu suất đồng nhất suốt vòng đời lốp, bám đường vượt trội</li><li>Xuất xứ: Hàn Quốc / Đông Nam Á</li></ul>', 'lop-continental-contistreet', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/0ygAAOSwBYNlwJ1h/s-l1600.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'CONTI-STREET-12070', N'120/70-17 (Lốp sau)', 1050000, 1260000, 735000, 40, 'https://i.ebayimg.com/images/g/0ygAAOSwBYNlwJ1h/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'120/70-17 (Lốp sau)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'120/70-17 (Lốp sau)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lốp Maxxis
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Maxxis (Đài Loan)') INSERT INTO Brands (BrandName) VALUES (N'Maxxis (Đài Loan)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Maxxis (Đài Loan)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lốp Maxxis', @CatId, @BrandId, N'<p>Maxxis Diamond là dòng lốp "quốc dân" nổi tiếng với thiết kế gai kim cương 3D ở hai bên thành lốp. Thiết kế này giúp tăng diện tích tiếp xúc khi xe vào cua và hỗ trợ thoát nước cực tốt. Với ưu điểm giá thành rẻ, độ bền cao và ít ăn đinh, đây là lựa chọn tối ưu cho người dùng phổ thông, sinh viên hoặc xe chạy dịch vụ.</p><p><strong>Phù hợp:</strong> Xe số, xe ga phổ thông</p><h3>Thông số kỹ thuật</h3><ul><li>Đặc tính: Giá thành rẻ, gai kim cương tăng độ bám khi nghiêng xe</li><li>Xuất xứ: Việt Nam (Công nghệ Đài Loan)</li></ul>', 'lop-maxxis', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdx4-lz420fzlivqg30@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MAXXIS-DIA-7090', N'70/90-17', 310000, 372000, 217000, 80, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdx4-lz420fzlivqg30@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'MAXXIS-DIA-8090', N'80/90-17', 380000, 456000, 266000, 70, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdx4-lz420fzlivqg30@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Phụ tùng & Phụ kiện
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Phụ tùng & Phụ kiện');

-- Product: Gương chiếu hậu Rizoma Elisse
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Rizoma (Phong cách)') INSERT INTO Brands (BrandName) VALUES (N'Rizoma (Phong cách)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Rizoma (Phong cách)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Gương chiếu hậu Rizoma Elisse', @CatId, @BrandId, N'<p>Gương Rizoma Elisse được gia công hoàn toàn từ nhôm CNC sắc sảo với mặt kính chống chói màu xanh đặc trưng, giúp người lái quan sát tốt hơn khi có ánh đèn xe phía sau chiếu vào ban đêm. Thiết kế góc cạnh thể thao, sang trọng, có thể xoay 360 độ linh hoạt để điều chỉnh góc nhìn. Đây là món đồ chơi không thể thiếu để làm gọn và tăng độ thẩm mỹ cho phần đầu xe.</p><p><strong>Phù hợp:</strong> Tất cả các dòng xe máy</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhôm CNC nguyên khối</li><li>Mặt kính: Kính xanh chống chói</li><li>Màu sắc: Đen, Bạc, Vàng</li><li>Tính năng: Quan sát phía sau, chống chói, trang trí xe</li><li>Phụ kiện: Đầy đủ ốc pát đi kèm cho mọi loại xe</li></ul>', 'guong-chieu-hau-rizoma-elisse', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/5141006c835d998d627b52d3dbc04afa@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RIZOMA-ELISSE-BLK', N'Màu Đen', 250000, 300000, 175000, 60, 'https://down-vn.img.susercontent.com/file/5141006c835d998d627b52d3dbc04afa@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Đen');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RIZOMA-ELISSE-SIL', N'Màu Bạc', 250000, 300000, 175000, 40, 'https://down-vn.img.susercontent.com/file/5141006c835d998d627b52d3dbc04afa@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Bạc');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Bao tay Barracuda
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Barracuda') INSERT INTO Brands (BrandName) VALUES (N'Barracuda');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Barracuda');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bao tay Barracuda', @CatId, @BrandId, N'<p>Bao tay Barracuda nổi tiếng với thiết kế kết hợp giữa cao su mềm mại và các vòng nhôm CNC tinh tế. Sản phẩm mang lại cảm giác cầm nắm cực kỳ êm ái, bám tay kể cả khi trời mưa hoặc ra mồ hôi tay, giúp giảm rung chấn từ ghi đông truyền lên bàn tay khi đi đường dài. Thiết kế mang đậm phong cách châu Âu, tạo điểm nhấn đẳng cấp cho tay lái.</p><p><strong>Phù hợp:</strong> Tất cả các loại xe máy</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Cao su chống trượt + Nhôm CNC</li><li>Màu sắc: Đen-Bạc, Đen-Đỏ, Đen-Vàng</li><li>Tính năng: Tăng độ bám tay, giảm tê tay, trang trí tay lái</li><li>Xuất xứ: Ý</li></ul>', 'bao-tay-barracuda', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdvc-lyrnjw91qhhjab@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BARRA-GRIPS-BS', N'Đen-Bạc', 450000, 540000, 315000, 30, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdvc-lyrnjw91qhhjab@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen-Bạc');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BARRA-GRIPS-BR', N'Đen-Đỏ', 450000, 540000, 315000, 20, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rdvc-lyrnjw91qhhjab@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen-Đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen-Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Xi nhan Spirit Beast L19
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Spirit Beast') INSERT INTO Brands (BrandName) VALUES (N'Spirit Beast');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Spirit Beast');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Xi nhan Spirit Beast L19', @CatId, @BrandId, N'<p>Spirit Beast L19 là dòng xi nhan LED có thiết kế mũi tên hiện đại và hiệu ứng chạy đuổi (Audi style) cực kỳ bắt mắt. Đèn có 2 chế độ: đèn định vị ban ngày (màu xanh hoặc đỏ) và đèn xi nhan (màu vàng). Vỏ đèn làm từ nhựa ABS cao cấp kết hợp cao su dẻo chống gãy khi va chạm, đảm bảo độ bền cao và khả năng chống nước tuyệt đối.</p><p><strong>Phù hợp:</strong> Exciter, Winner, Raider, Vario, các dòng xe tay ga</p><h3>Thông số kỹ thuật</h3><ul><li>Loại bóng: LED SMD siêu sáng</li><li>Tính năng: Chống nước IP67, hiệu ứng chạy đuổi</li><li>Điện áp: 12V</li><li>Màu định vị: Xanh dương / Đỏ</li><li>Xuất xứ: Trung Quốc (Nội địa cao cấp)</li></ul>', 'xi-nhan-spirit-beast-l19', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/265389658c38016fcfb32cd5ba8c7c08@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SPIRIT-L19-BLUE', N'Định vị xanh dương', 280000, 336000, 196000, 70, 'https://down-vn.img.susercontent.com/file/265389658c38016fcfb32cd5ba8c7c08@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị xanh dương') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Định vị xanh dương');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị xanh dương');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'SPIRIT-L19-RED', N'Định vị đỏ', 280000, 336000, 196000, 50, 'https://down-vn.img.susercontent.com/file/265389658c38016fcfb32cd5ba8c7c08@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Định vị đỏ');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Định vị đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Gác chân sau nhôm CNC nguyên khối
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'H2C / Racing Boy ( RCB)') INSERT INTO Brands (BrandName) VALUES (N'H2C / Racing Boy ( RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'H2C / Racing Boy ( RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Gác chân sau nhôm CNC nguyên khối', @CatId, @BrandId, N'<p>Thay thế cho gác chân sắt bọc cao su nguyên bản, gác chân nhôm CNC mang lại vẻ ngoài cứng cáp và sắc lạnh. Các đường rãnh được phay CNC tỉ mỉ không chỉ giúp trang trí mà còn tăng độ ma sát cho người ngồi sau, tránh trơn trượt chân khi đi mưa. Màu nhôm nhuộm Anode bền bỉ, không bị bay màu theo thời gian.</p><p><strong>Phù hợp:</strong> Wave, Dream, Future, Vario, Air Blade</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Hợp kim nhôm 6061 CNC</li><li>Màu sắc: Bạc, Đen, Đỏ</li><li>Lắp đặt: Plug and Play (như zin)</li><li>Tính năng: Chống trượt, tăng tính thẩm mỹ cho thân xe</li></ul>', 'gac-chan-sau-nhom-cnc-nguyen-khoi', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmsz1v3h337p80@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'CNC-FOOTREST-SIL', N'Màu Bạc CNC', 350000, 420000, 244999, 40, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmsz1v3h337p80@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc CNC') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Bạc CNC');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Bạc CNC');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Cùm tăng tốc Domino
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Domino') INSERT INTO Brands (BrandName) VALUES (N'Domino');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Domino');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Cùm tăng tốc Domino', @CatId, @BrandId, N'<p>Cùm tăng tốc Domino giúp rút ngắn hành trình tay ga, giúp xe vọt nhanh hơn và đạt tốc độ tối đa trong thời gian ngắn hơn. Đây là món đồ chơi cực kỳ hữu ích cho những ai yêu thích cảm giác lái thể thao và muốn xe phản ứng nhạy bén hơn. Sản phẩm đi kèm 2 ống ga để tùy chỉnh độ nhạy theo ý thích người lái.</p><p><strong>Phù hợp:</strong> Xe côn tay (Exciter, Winner, PKL), xe độ</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Nhựa kỹ thuật cao cấp + Nhôm</li><li>Phụ kiện: Bao gồm 2 dây ga Thái Lan và ống ga</li><li>Tính năng: Rút ngắn hành trình ga, giúp xe tăng tốc nhanh</li><li>Xuất xứ: Ý</li></ul>', 'cum-tang-toc-domino', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-m00j050teonhba@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DOMINO-XM2-ITALY', N'Mẫu 2 dây ga dưới (XM2)', 1850000, 2220000, 1295000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-m00j050teonhba@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu 2 dây ga dưới (XM2)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu 2 dây ga dưới (XM2)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu 2 dây ga dưới (XM2)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Giảm xóc
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Giảm xóc');

-- Product: Phuộc Ohlins HO110
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Ohlins') INSERT INTO Brands (BrandName) VALUES (N'Ohlins');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Ohlins');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Ohlins HO110', @CatId, @BrandId, N'<p>Ohlins HO110 là dòng giảm xóc đẳng cấp nhất dành cho xe tay ga nhỏ. Với thiết kế bình dầu dưới màu vàng đặc trưng, phuộc mang lại khả năng kiểm soát hành trình nhún cực kỳ tinh tế. Công nghệ bình dầu giúp dầu không bị nóng khi hoạt động liên tục, đảm bảo độ êm ái và ổn định tuyệt đối dù đi một mình hay chở nặng. Sản phẩm cho phép người dùng tùy chỉnh sâu vào độ nén lò xo và độ hồi của phuộc.</p><p><strong>Phù hợp:</strong> Honda Vario, Click, Vision, Sh Mode</p><h3>Thông số kỹ thuật</h3><ul><li>Chiều cao: 330mm</li><li>Tính năng tùy chỉnh: Compression, Rebound, Preload</li><li>Phụ kiện: Kèm thêm 1 lò xo phụ</li><li>Tính năng: Giảm chấn thông minh, tăng độ bám đường khi vào cua</li><li>Xuất xứ: Thụy Điển (Sản xuất tại Thái Lan)</li></ul>', 'phuoc-ohlins-ho110', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://i.ebayimg.com/images/g/fDgAAeSwsGZpqHYg/s-l1600.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'OHLINS-HO110', N'Màu Vàng', 8600000, 10320000, 6020000, 15, 'https://i.ebayimg.com/images/g/fDgAAeSwsGZpqHYg/s-l1600.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Màu Vàng');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Màu Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Phuộc YSS G-Series dòng Hybrid
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS') INSERT INTO Brands (BrandName) VALUES (N'YSS');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'YSS');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc YSS G-Series dòng Hybrid', @CatId, @BrandId, N'<p>YSS G-Series Hybrid là sự kết hợp hoàn hảo giữa khí Nitơ áp suất cao và dầu thủy lực. Thiết kế bình dầu giúp giải nhiệt nhanh, giữ cho phuộc không bị "đuối" khi đi đường dài. Đây là lựa chọn thay thế phuộc zin tốt nhất trong tầm giá, mang lại cảm giác lái đầm chắc, triệt tiêu lực chấn động từ mặt đường rất hiệu quả, giúp bảo vệ khung sườn và mang lại sự thoải mái cho người ngồi sau.</p><p><strong>Phù hợp:</strong> Air Blade, PCX, NVX, SH Việt Nam</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Bình dầu rời chứa khí Nitơ</li><li>Màu sắc: Lò xo đỏ - Bình dầu bạc</li><li>Tính năng: Tăng độ ổn định thân xe, chịu tải tốt</li><li>Xuất xứ: Thái Lan</li></ul>', 'phuoc-yss-g-series-dong-hybrid', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://www.omniaracing.net/images/products2/ammortizzatori-e-sospensioni/ammortizzatori/YSS_RG362-350TRWJ-19-888l.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'YSS-GSERIES-AB', N'Cho Air Blade (320mm)', 2450000, 2940000, 1715000, 25, 'https://www.omniaracing.net/images/products2/ammortizzatori-e-sospensioni/ammortizzatori/YSS_RG362-350TRWJ-19-888l.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Air Blade (320mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Air Blade (320mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Air Blade (320mm)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'YSS-GSERIES-NVX', N'Cho NVX (305mm)', 2800000, 3360000, 1959999, 20, 'https://www.omniaracing.net/images/products2/ammortizzatori-e-sospensioni/ammortizzatori/YSS_RG362-350TRWJ-19-888l.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho NVX (305mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho NVX (305mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho NVX (305mm)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Phuộc Racing Boy (RCB)
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Racing Boy (RCB)') INSERT INTO Brands (BrandName) VALUES (N'Racing Boy (RCB)');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Racing Boy (RCB)');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Racing Boy (RCB)', @CatId, @BrandId, N'<p>RCB VD Series là dòng phuộc đỉnh cao của nhà RCB với điểm nhấn là ty phuộc mạ vàng sang trọng và chống trầy xước. Sản phẩm có đầy đủ các núm tăng chỉnh tăng giảm độ hồi và độ nén, cho phép người dùng cá nhân hóa cảm giác lái theo đúng cân nặng và sở thích. Thân phuộc được làm từ nhôm CNC sắc sảo, giúp tản nhiệt nhanh và tăng độ bền cơ học cho hệ thống giảm xóc.</p><p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><h3>Thông số kỹ thuật</h3><ul><li>Tính năng tùy chỉnh: Preload, Rebound, Compression</li><li>Đặc điểm: Ty vàng chống ma sát cao</li><li>Tính năng: Chỉnh độ nhún cứng/mềm linh hoạt, phong cách thể thao</li><li>Xuất xứ: Malaysia</li></ul>', 'phuoc-racing-boy-rcb', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-7ra26-mbbteios4tbq55@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-VD-EX150', N'Cho Exciter (208mm)', 4200000, 5040000, 2940000, 15, 'https://down-vn.img.susercontent.com/file/sg-11134201-7ra26-mbbteios4tbq55@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter (208mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Exciter (208mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Exciter (208mm)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RCB-VD-WINNER', N'Cho Winner (225mm)', 4350000, 5220000, 3045000, 15, 'https://down-vn.img.susercontent.com/file/sg-11134201-7ra26-mbbteios4tbq55@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Winner (225mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Winner (225mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Winner (225mm)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Phuộc trước LCM
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'LCM') INSERT INTO Brands (BrandName) VALUES (N'LCM');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'LCM');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc trước LCM', @CatId, @BrandId, N'<p>Phuộc trước LCM là giải pháp khắc phục triệt để hiện tượng kêu "cụp cụp" kinh điển trên dòng xe Exciter. Với thiết kế ty phuộc lớn và chảng ba đúc dày dặn, bộ phuộc này mang lại sự vững chãi tuyệt đối cho tay lái. Xe sẽ không còn tình trạng sàn lắc khi qua ổ gà hay khi phanh gấp, giúp người lái tự tin hơn rất nhiều khi di chuyển ở tốc độ cao.</p><p><strong>Phù hợp:</strong> Exciter 150/155</p><h3>Thông số kỹ thuật</h3><ul><li>Trọn bộ: Gồm ty phuộc, chảng ba, pát heo dầu</li><li>Kích thước: Ty lớn (phong cách Winner)</li><li>Tính năng: Triệt tiêu tiếng kêu phuộc trước, tăng độ đầm chắc cho đầu xe</li><li>Xuất xứ: Đài Loan</li></ul>', 'phuoc-truoc-lcm', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/c82d7d4dfc9926b982f28f8dcfffb914@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LCM-FRONT-EX150', N'Full bộ cho Ex150', 3850000, 4620000, 2695000, 20, 'https://down-vn.img.susercontent.com/file/c82d7d4dfc9926b982f28f8dcfffb914@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Full bộ cho Ex150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Full bộ cho Ex150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Full bộ cho Ex150');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Phuộc Nitron DNA
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Nitron DNA') INSERT INTO Brands (BrandName) VALUES (N'Nitron DNA');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Nitron DNA');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Phuộc Nitron DNA', @CatId, @BrandId, N'<p>Phuộc Nitron DNA thu hút mọi ánh nhìn với tone màu xanh ngọc đặc trưng. Đây là dòng phuộc được thiết kế dành riêng cho thị trường Đông Nam Á, tối ưu hóa cho điều kiện mặt đường nhiều ổ gà và gờ giảm tốc. Phuộc vận hành rất mượt mà ở tốc độ thấp và cực kỳ ổn định khi đi nhanh, giúp giảm áp lực lên cột sống người lái và tăng tuổi thọ cho các chi tiết nhựa trên xe.</p><p><strong>Phù hợp:</strong> Vario, Vision, SH, Exciter</p><h3>Thông số kỹ thuật</h3><ul><li>Màu sắc: Xanh Nitron</li><li>Tính năng tùy chỉnh: Nấc chỉnh Rebound (độ hồi) và Preload (lò xo)</li><li>Cấu tạo: Nhôm CNC cao cấp</li><li>Tính năng: Thẩm mỹ cao, độ nhún êm ái, bền bỉ</li><li>Xuất xứ: Công nghệ Anh Quốc</li></ul>', 'phuoc-nitron-dna', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mfzcppxfos97de@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'NITRON-DNA-330', N'Cho Vario (330mm)', 2650000, 3180000, 1854999, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mfzcppxfos97de@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario (330mm)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Vario (330mm)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario (330mm)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Phụ tùng & Phụ kiện
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Phụ tùng & Phụ kiện');

-- Product: Bugi NGK Iridium IX CPR8EAIX-9
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'NGK') INSERT INTO Brands (BrandName) VALUES (N'NGK');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'NGK');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bugi NGK Iridium IX CPR8EAIX-9', @CatId, @BrandId, N'<p>Đầu điện cực bằng kim loại quý Iridium siêu nhỏ giúp tia lửa tập trung mạnh mẽ, hỗ trợ đốt cháy nhiên liệu triệt để, giúp xe khởi động dễ dàng và tiết kiệm xăng hơn.</p><p><strong>Phù hợp:</strong> Exciter, Winner, Raider, Vario, Air Blade</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu điện cực: Iridium</li><li>Mã sản phẩm: CPR8EAIX-9</li><li>Độ bền: 30.000 – 50.000 km</li><li>Tính năng: Đánh lửa cực mạnh, chịu nhiệt cao</li><li>Xuất xứ: Nhật Bản</li></ul>', 'bugi-ngk-iridium-ix-cpr8eaix-9', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m1z8lbs1bycb26@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'NGK-IRIDIUM-IX-LONG', N'Chân dài (Cho Exciter/Winner/Vario)', 220000, 264000, 154000, 150, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m1z8lbs1bycb26@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Chân dài (Cho Exciter/Winner/Vario)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Chân dài (Cho Exciter/Winner/Vario)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Chân dài (Cho Exciter/Winner/Vario)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lọc gió trụ K&N 1280
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'K&N') INSERT INTO Brands (BrandName) VALUES (N'K&N');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'K&N');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lọc gió trụ K&N 1280', @CatId, @BrandId, N'<p>Lọc gió vĩnh cửu có khả năng vệ sinh và tái sử dụng, giúp lượng không khí nạp vào buồng đốt mạnh hơn lọc giấy zin, tối ưu công suất động cơ.</p><p><strong>Phù hợp:</strong> Xe độ họng xăng lớn, xe côn tay đi lọc trụ</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Lưới cotton tẩm dầu (Gauze)</li><li>Kích thước: Miệng họng 51mm</li><li>Tính năng: Tăng lưu lượng khí nạp, lọc bụi mịn, tái sử dụng được</li><li>Xuất xứ: Mỹ</li></ul>', 'loc-gio-tru-kn-1280', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-22100-kgs7glreobjvfb@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'KN-1280-USA-51', N'Họng 51mm', 950000, 1140000, 665000, 40, 'https://down-vn.img.susercontent.com/file/sg-11134201-22100-kgs7glreobjvfb@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Họng 51mm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Họng 51mm');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Họng 51mm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Bộ nồi xe tay ga FCC
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'FCC') INSERT INTO Brands (BrandName) VALUES (N'FCC');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'FCC');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bộ nồi xe tay ga FCC', @CatId, @BrandId, N'<p>Phụ tùng thay thế tiêu chuẩn giúp khắc phục hoàn toàn tình trạng rung đầu khi lên ga, giúp xe bắt nồi nhạy và vận hành êm ái hơn.</p><p><strong>Phù hợp:</strong> Honda SH, Vario, Air Blade, Vision</p><h3>Thông số kỹ thuật</h3><ul><li>Trọn bộ: Gồm Chuông nồi và Bố ba càng</li><li>Chất liệu: Hợp kim chịu nhiệt, phíp bố cao cấp</li><li>Tính năng: Chống rung đầu, không trượt nồi</li><li>Xuất xứ: Nhật Bản</li></ul>', 'bo-noi-xe-tay-ga-fcc', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lqylf5yi9ltwc1@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'FCC-SET-VARIO', N'Bộ cho Vario/AB 125-150', 850000, 1020000, 595000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lqylf5yi9ltwc1@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB 125-150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Vario/AB 125-150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB 125-150');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'FCC-SET-SHVN', N'Bộ cho SH Việt Nam', 1200000, 1440000, 840000, 15, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lqylf5yi9ltwc1@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho SH Việt Nam') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho SH Việt Nam');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho SH Việt Nam');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lá côn độ Light Speed Racing
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Light Speed') INSERT INTO Brands (BrandName) VALUES (N'Light Speed');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Light Speed');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lá côn độ Light Speed Racing', @CatId, @BrandId, N'<p>Hợp chất giấy nén chịu nhiệt cao tăng độ bám, chống cháy lá côn khi vận hành ở cường độ cao, giúp cảm giác bóp côn và sang số dứt khoát.</p><p><strong>Phù hợp:</strong> Exciter 150/155, Winner X</p><h3>Thông số kỹ thuật</h3><ul><li>Số lượng: Bộ 5 lá</li><li>Chất liệu: Phíp giấy chịu nhiệt cao cấp</li><li>Tính năng: Bắt nồi nhanh, chống cháy, sạch nhớt</li><li>Xuất xứ: Đài Loan</li></ul>', 'la-con-o-light-speed-racing', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0lpf5kdmewd10@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-CLUTCH-EX150', N'Bộ cho Exciter 150', 450000, 540000, 315000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0lpf5kdmewd10@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-CLUTCH-WINNER', N'Bộ cho Winner X', 480000, 576000, 336000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0lpf5kdmewd10@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Lò xo đầu độ Uma Racing
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Uma Racing') INSERT INTO Brands (BrandName) VALUES (N'Uma Racing');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Uma Racing');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Lò xo đầu độ Uma Racing', @CatId, @BrandId, N'<p>Thép đàn hồi cường độ cao giúp súp bắp đóng mở chính xác ở vòng tua cao, không bị lún lò xo, bảo vệ động cơ khi ép máy tốc độ cao.</p><p><strong>Phù hợp:</strong> Exciter 135/150, Winner X (Xe độ máy)</p><h3>Thông số kỹ thuật</h3><ul><li>Số lượng: Bộ 4 lò xo</li><li>Chất liệu: Thép Silicon (SiCr)</li><li>Tính năng: Chịu vòng tua máy cao, độ đàn hồi bền bỉ</li><li>Xuất xứ: Malaysia</li></ul>', 'lo-xo-au-o-uma-racing', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/sg-11134201-82627-mj58vlox2jggc3@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'UMA-SPRING-EX', N'Bộ cho Exciter', 380000, 456000, 266000, 25, 'https://down-vn.img.susercontent.com/file/sg-11134201-82627-mj58vlox2jggc3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'UMA-SPRING-WIN', N'Bộ cho Winner', 420000, 504000, 294000, 25, 'https://down-vn.img.susercontent.com/file/sg-11134201-82627-mj58vlox2jggc3@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Winner');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Ắc quy & Điện
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Ắc quy & Điện');

-- Product: Đèn LED trợ sáng Bi Cầu Mini X-Light M10
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'X-Light') INSERT INTO Brands (BrandName) VALUES (N'X-Light');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'X-Light');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Đèn LED trợ sáng Bi Cầu Mini X-Light M10', @CatId, @BrandId, N'<p>X-Light M10 là dòng đèn trợ sáng bi cầu mini có kích thước nhỏ gọn nhưng cường độ sáng cực mạnh. Đèn có tích hợp hai chế độ: Cos (ánh sáng vàng) và Pha (ánh sáng trắng) với đường cắt chống chói cho người đối diện. Sản phẩm có khả năng chống nước chuẩn IP68, giúp người lái quan sát rõ mặt đường trong mọi điều kiện thời tiết như mưa lớn hay sương mù.</p><p><strong>Phù hợp:</strong> Tất cả các dòng xe máy</p><h3>Thông số kỹ thuật</h3><ul><li>Công suất: 20W - 25W</li><li>Chế độ sáng: Cos vàng - Pha trắng</li><li>Chống nước: IP68</li><li>Điện áp: 9V - 36V</li><li>Tính năng: Tăng khả năng quan sát ban đêm, chống chói người đối diện</li><li>Xuất xứ: Trung Quốc (Công nghệ Việt Nam)</li></ul>', 'en-led-tro-sang-bi-cau-mini-x-light-m10', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsxujpyancexbc@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'XLIGHT-M10-PAIR', N'Cặp 2 đèn', 650000, 780000, 455000, 35, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsxujpyancexbc@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cặp 2 đèn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cặp 2 đèn');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cặp 2 đèn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'XLIGHT-M10-SINGLE', N'Lẻ 1 đèn', 350000, 420000, 244999, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsxujpyancexbc@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích cỡ') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích cỡ');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích cỡ');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lẻ 1 đèn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Lẻ 1 đèn');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Lẻ 1 đèn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Sạc Độ HCE
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'HCE') INSERT INTO Brands (BrandName) VALUES (N'HCE');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'HCE');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Sạc Độ HCE', @CatId, @BrandId, N'<p>Sạc độ HCE giúp ổn định dòng điện từ mâm lửa lên bình ắc quy, giúp sạc bình nhanh hơn và ổn định hơn so với sạc zin. Sản phẩm đặc biệt quan trọng cho các xe lắp thêm nhiều thiết bị điện như đèn LED, định vị, chống trộm mà không lo hết bình hay cháy cuộn lửa. Sạc HCE có tính năng tự ngắt khi bình đầy để bảo vệ tuổi thọ ắc quy.</p><p><strong>Phù hợp:</strong> Exciter 150, Winner X, các xe lên nhiều đèn trợ sáng</p><h3>Thông số kỹ thuật</h3><ul><li>Loại: Sạc 3 pha thông minh</li><li>Tính năng: Chuyển điện máy thành điện bình ổn định, tự ngắt khi đầy</li><li>Lắp đặt: Plug and Play (như zin)</li><li>Tính năng: Hỗ trợ hệ thống đèn trợ sáng công suất lớn</li><li>Xuất xứ: Việt Nam</li></ul>', 'sac-o-hce', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzjrnyupqybx50@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HCE-CHARGER-HONDA', N'Dòng xe Honda (Winner/Vario)', 480000, 576000, 336000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzjrnyupqybx50@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Honda (Winner/Vario)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dòng xe Honda (Winner/Vario)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Honda (Winner/Vario)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'HCE-CHARGER-YAMAHA', N'Dòng xe Yamaha (Exciter)', 480000, 576000, 336000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzjrnyupqybx50@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Yamaha (Exciter)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dòng xe Yamaha (Exciter)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dòng xe Yamaha (Exciter)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Bộ khóa chống trộm Zoro
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Pitech') INSERT INTO Brands (BrandName) VALUES (N'Pitech');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Pitech');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bộ khóa chống trộm Zoro', @CatId, @BrandId, N'<p>Fox là bộ khóa chống trộm cao cấp điều khiển qua điện thoại và remote nhận diện người dùng. Sản phẩm tích hợp đầy đủ các tính năng an toàn: Chống trộm, chống cướp (tự tắt máy khi remote rời xa xe), tìm xe trong bãi và định vị vị trí xe qua GPS. Hệ thống lắp đặt bằng jack cắm zin, không cắt dây điện của xe, đảm bảo an toàn tuyệt đối cho hệ thống điện.</p><p><strong>Phù hợp:</strong> Tất cả các dòng xe máy</p><h3>Thông số kỹ thuật</h3><ul><li>Kết nối: Bluetooth 4.2 / GPS</li><li>Tính năng: Chống cướp tự động, định vị GPS, tìm xe trong bãi</li><li>Quản lý: App trên Smartphone (iOS/Android)</li><li>Phụ kiện: 1 bộ điều khiển trung tâm + 1 Remote Pi</li><li>Xuất xứ: Việt Nam</li></ul>', 'bo-khoa-chong-trom-zoro', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsmkf9qdupax9c@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'PITECH-FOX-FULL', N'Bộ đầy đủ (Full Set)', 1550000, 1860000, 1085000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lsmkf9qdupax9c@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ đầy đủ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ đầy đủ (Full Set)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ đầy đủ (Full Set)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Ắc quy khô GS Platinum GTZ6V
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'GS Platinum') INSERT INTO Brands (BrandName) VALUES (N'GS Platinum');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'GS Platinum');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Ắc quy khô GS Platinum GTZ6V', @CatId, @BrandId, N'<p>Ắc quy GS Platinum là dòng bình khô cao cấp có dòng phóng điện ổn định và tuổi thọ vượt trội. Với dung lượng 5Ah, bình đảm bảo khả năng khởi động (đề máy) nhạy bén ngay cả trong thời tiết lạnh. Thiết kế bình kín khí không cần bảo dưỡng, an toàn và không gây rò rỉ axit làm hỏng khung sườn xe.</p><p><strong>Phù hợp:</strong> Air Blade, Vario, Winner, Exciter 150/155, Lead</p><h3>Thông số kỹ thuật</h3><ul><li>Điện thế: 12V</li><li>Dung lượng: 5Ah</li><li>Kích thước: 113 x 70 x 105 mm</li><li>Loại bình: Bình VRLA (khô, kín khí)</li><li>Tính năng: Cung cấp nguồn điện ổn định cho hệ thống khởi động và chiếu sáng</li><li>Xuất xứ: Việt Nam (Công nghệ Nhật Bản)</li></ul>', 'ac-quy-kho-gs-platinum-gtz6v', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mhx29qpiccg0e1@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'GS-GTZ6V-PLATINUM', N'Bình GTZ6V (5Ah)', 380000, 456000, 266000, 80, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mhx29qpiccg0e1@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bình GTZ6V (5Ah)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bình GTZ6V (5Ah)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bình GTZ6V (5Ah)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Cùm công tắc Light Master
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Light Master') INSERT INTO Brands (BrandName) VALUES (N'Light Master');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Light Master');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Cùm công tắc Light Master', @CatId, @BrandId, N'<p>Cùm công tắc Light Master không chỉ mang lại vẻ ngoài hiện đại với các nút bấm có đèn LED xanh bắt mắt mà còn tích hợp đầy đủ các chức năng cần thiết như: Tắt máy tạm thời, Passing (đá đèn), bật tắt đèn pha. Các nút bấm có độ phản hồi tốt, chống nước và bền bỉ dưới mọi điều kiện thời tiết.</p><p><strong>Phù hợp:</strong> Exciter 150, Winner X, NVX, Vario (Chế nhẹ)</p><h3>Thông số kỹ thuật</h3><ul><li>Màu LED: Xanh dương</li><li>Chức năng: Full chức năng (Còi, Xi nhan, Passing, Tắt máy, Đề)</li><li>Lắp đặt: Jack cắm theo xe (Exciter/Winner)</li><li>Tính năng: Trang trí dàn ghi đông, hỗ trợ đá đèn xin đường</li><li>Xuất xứ: Trung Quốc (Nội địa cao cấp)</li></ul>', 'cum-cong-tac-light-master', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn055qocpm2qc8@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LM-SWITCH-EX150', N'Mẫu cho Exciter 150', 550000, 660000, 385000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn055qocpm2qc8@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Exciter 150');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LM-SWITCH-WINNERX', N'Mẫu cho Winner X', 550000, 660000, 385000, 20, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mn055qocpm2qc8@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Mẫu cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Mẫu cho Winner X');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- CATEGORY: Phụ tùng & Phụ kiện
SET @CatId = (SELECT CategoryId FROM Categories WHERE CategoryName = N'Phụ tùng & Phụ kiện');

-- Product: Nhông sên dĩa DID Vàng
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'DID') INSERT INTO Brands (BrandName) VALUES (N'DID');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'DID');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Nhông sên dĩa DID Vàng', @CatId, @BrandId, N'<p>Bộ nhông sên dĩa DID Vàng là sự lựa chọn hàng đầu cho các dòng xe số và xe côn tay. Với công nghệ nhiệt luyện đặc biệt của Nhật Bản, sên DID có độ bền cực cao, khả năng chịu tải lớn và rất ít bị giãn (chùn) sau thời gian dài sử dụng. Màu vàng bắt mắt giúp tăng tính thẩm mỹ, làm nổi bật phần chân xe.</p><p><strong>Phù hợp:</strong> Exciter 135/150, Winner X, Wave, Dream, Future</p><h3>Thông số kỹ thuật</h3><ul><li>Loại sên: 428D (9 ly)</li><li>Màu sắc: Vàng (Gold)</li><li>Chất liệu: Thép hợp kim nhiệt luyện</li><li>Tính năng: Truyền tải lực mượt mà, độ bền cao, thẩm mỹ đẹp</li><li>Xuất xứ: Nhật Bản (Gia công Thái Lan)</li></ul>', 'nhong-sen-dia-did-vang', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/fe2a17702ee1ea8ea6f325e5d0dda364@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DID-GOLD-EX150', N'Bộ cho Exciter 150 (14T-42T)', 450000, 540000, 315000, 40, 'https://down-vn.img.susercontent.com/file/fe2a17702ee1ea8ea6f325e5d0dda364@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150 (14T-42T)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter 150 (14T-42T)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150 (14T-42T)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'DID-GOLD-WAVE', N'Bộ cho Wave/Dream (14T-36T)', 320000, 384000, 224000, 60, 'https://down-vn.img.susercontent.com/file/fe2a17702ee1ea8ea6f325e5d0dda364@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Wave/Dream (14T-36T)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Wave/Dream (14T-36T)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Wave/Dream (14T-36T)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Dây curoa Bando
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Bando') INSERT INTO Brands (BrandName) VALUES (N'Bando');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Bando');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Dây curoa Bando', @CatId, @BrandId, N'<p>Bando là nhà sản xuất dây curoa số 1 thế giới. Dòng Bando Xanh (2 mặt răng) là phân khúc cao cấp nhất dành cho xe tay ga. Thiết kế hai mặt răng giúp dây cực kỳ linh hoạt, thoát nhiệt nhanh hơn và giảm thiểu tình trạng trượt dây khi xe vận hành ở tốc độ cao hoặc chở nặng, từ đó giúp xe vận hành êm ái và tiết kiệm nhiên liệu.</p><p><strong>Phù hợp:</strong> Honda SH, Vario, Air Blade, Vision</p><h3>Thông số kỹ thuật</h3><ul><li>Cấu tạo: Cao su chịu nhiệt + sợi Polyamide</li><li>Kiểu dáng: Double Notch (2 mặt răng)</li><li>Tính năng: Độ bền vượt trội, chống giãn, vận hành cực êm</li><li>Chu kỳ thay thế: 20.000 km</li><li>Xuất xứ: Nhật Bản</li></ul>', 'day-curoa-bando', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lz636qmassrl4f@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-BLUE-VARIO', N'Cho Vario/AB 125-150', 550000, 660000, 385000, 45, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lz636qmassrl4f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario/AB 125-150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho Vario/AB 125-150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho Vario/AB 125-150');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-BLUE-SH', N'Cho SH Việt Nam', 750000, 900000, 525000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lz636qmassrl4f@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho SH Việt Nam') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cho SH Việt Nam');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cho SH Việt Nam');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Sên RK Takasago 428 ELO
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RK Takasago') INSERT INTO Brands (BrandName) VALUES (N'RK Takasago');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'RK Takasago');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Sên RK Takasago 428 ELO', @CatId, @BrandId, N'<p>Sên RK ELO có tích hợp phớt cao su (O-ring) giữa các mắt sên, giúp giữ lớp mỡ bôi trơn bên trong lõi sên không bị văng ra ngoài. Điều này giúp sên vận hành cực kỳ êm ái, giảm tiếng ồn "xè xè" khó chịu và tăng tuổi thọ sên gấp 2 lần so với sên không phớt. Đây là lựa chọn tuyệt vời cho các chuyến đi tour đường dài.</p><p><strong>Phù hợp:</strong> Exciter 155, Winner X, Raider, Satria</p><h3>Thông số kỹ thuật</h3><ul><li>Loại sên: 428 ELO (Có phớt cao su)</li><li>Màu sắc: Vàng (Gold)</li><li>Độ dài: 132 mắt</li><li>Tính năng: Giảm tiếng ồn, giữ mỡ bôi trơn, bền bỉ vượt trội</li><li>Xuất xứ: Nhật Bản (Gia công Malaysia)</li></ul>', 'sen-rk-takasago-428-elo', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-23020-xyb69suljunvac@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'RK-428ELO-GOLD', N'1 Sợi (132 mắt)', 850000, 1020000, 595000, 35, 'https://down-vn.img.susercontent.com/file/vn-11134201-23020-xyb69suljunvac@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1 Sợi (132 mắt)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1 Sợi (132 mắt)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1 Sợi (132 mắt)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Nhông sên dĩa Light Speed
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Light Speed Racing') INSERT INTO Brands (BrandName) VALUES (N'Light Speed Racing');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Light Speed Racing');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Nhông sên dĩa Light Speed', @CatId, @BrandId, N'<p>Dòng NSD Light Speed hướng tới sự bền bỉ và cứng cáp với lớp sơn tĩnh điện đen mờ chống rỉ sét. Nhông và dĩa được phay CNC từ thép C45 chất lượng cao, đảm bảo độ tròn tuyệt đối, giúp sên bắt vào răng dĩa êm ái, không gây rung lắc ở tốc độ cao. Đây là bộ sản phẩm có mức giá cực tốt so với hiệu năng mang lại.</p><p><strong>Phù hợp:</strong> Exciter, Winner, Sonic</p><h3>Thông số kỹ thuật</h3><ul><li>Chất liệu: Thép C45 tinh luyện</li><li>Màu sắc: Đen mờ (Matte Black)</li><li>Quy cách: 7 ly hoặc 9 ly tùy loại xe</li><li>Tính năng: Chống mài mòn tốt, vận hành ổn định, giá thành hợp lý</li><li>Xuất xứ: Việt Nam (Công nghệ Đài Loan)</li></ul>', 'nhong-sen-dia-light-speed', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-x37jsz9k0aovb9@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-SPEED-EX150', N'Bộ cho Exciter 150', 380000, 456000, 266000, 30, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-x37jsz9k0aovb9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Exciter 150');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Exciter 150');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'LIGHT-SPEED-WINNER', N'Bộ cho Winner X', 390000, 468000, 273000, 25, 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-x37jsz9k0aovb9@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Winner X');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Winner X');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

-- Product: Bi nồi Bando cho xe tay ga
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Bando') INSERT INTO Brands (BrandName) VALUES (N'Bando');
SET @BrandId = (SELECT BrandId FROM Brands WHERE BrandName = N'Bando');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'Bi nồi Bando cho xe tay ga', @CatId, @BrandId, N'<p>Bi nồi Bando được sản xuất bằng nhựa tự bôi trơn chất lượng cao, chịu nhiệt và chống mài mòn cực tốt. Bi có trọng lượng chuẩn xác tuyệt đối, giúp ly hợp trước hoạt động mượt mà, xe lên ga nhanh và ổn định, không bị tình trạng rung rần hay hú nồi do bi mòn không đều.</p><p><strong>Phù hợp:</strong> Vario, Air Blade, Vision, SH, Lead</p><h3>Thông số kỹ thuật</h3><ul><li>Số lượng: Bộ 6 viên</li><li>Chất liệu: Nhựa chịu nhiệt + Lõi hợp kim</li><li>Tính năng: Giúp xe tăng tốc mượt, giảm tiếng ồn bộ nồi</li><li>Xuất xứ: Nhật Bản (Gia công Việt Nam)</li></ul>', 'bi-noi-bando-cho-xe-tay-ga', 1, 0, GETDATE(), 0);
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsmscx5a@resize_w900_nl.webp', 1, 0);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-ROLLER-VARIO', N'Bộ cho Vario/AB (18g/20g)', 180000, 216000, 125999, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsmscx5a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB (18g/20g)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Vario/AB (18g/20g)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vario/AB (18g/20g)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, 'BANDO-ROLLER-VISION', N'Bộ cho Vision/Lead (12g/15g)', 160000, 192000, 112000, 60, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu2t3dfsmscx5a@resize_w900_nl.webp', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vision/Lead (12g/15g)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bộ cho Vision/Lead (12g/15g)');
SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bộ cho Vision/Lead (12g/15g)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @ValId) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);

COMMIT;