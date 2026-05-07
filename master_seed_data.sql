-- MASTER SEED DATA FOR MOTOSHOP (FIXED VERSION)
-- Bao gồm: 12 Danh mục, 12 Thương hiệu và 10 Sản phẩm mẫu chuẩn từ Phụ Tùng Anh Em
USE MotorcycleShopDB;
GO

BEGIN TRANSACTION;

-- ==========================================
-- 1. CLEAN UP DỮ LIỆU CŨ
-- ==========================================
UPDATE Products SET CategoryId = NULL, BrandId = NULL;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
DELETE FROM PromotionProducts;
DELETE FROM FlashSaleProducts;
DELETE FROM Categories;
DELETE FROM Brands;
DELETE FROM Products;

-- ==========================================
-- 2. THÊM DANH MỤC (CATEGORIES)
-- ==========================================
DECLARE @CatId INT;

-- 1. BỘ NỒI XE TAY GA
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 'bx-cycling', 1);
SET @CatId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi trước', 'bo-noi-truoc', @CatId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi sau', 'bo-noi-sau', @CatId, 1);

-- 2. NHÔNG - SÊN - DĨA
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong-sen-dia', 'bx-loader-circle', 1);
SET @CatId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Combo 3 món', 'combo-3-mon', @CatId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Sên', 'sen', @CatId, 1);

-- 3. MÁY SẠC - BÌNH ĐIỆN
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac-binh-dien', 'bx-battery', 1);
SET @CatId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bình điện phân khối lớn', 'binh-dien-pkl', @CatId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Máy sạc - phụ kiện', 'may-sac-phu-kien', @CatId, 1);

-- 4. LỌC GIÓ
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 'bx-wind', 1);
SET @CatId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc gió Yamaha', 'loc-gio-yamaha', @CatId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc gió Honda', 'loc-gio-honda', @CatId, 1);

-- 5. BỐ THẮNG
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 'bx-disc', 1);
SET @CatId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bố thắng đùm', 'bo-thang-dum', @CatId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bố thắng đĩa', 'bo-thang-dia', @CatId, 1);

-- Thêm các danh mục cha khác (đơn giản hóa)
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 'bx-unite', 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia-nhot', 'bx-droplet', 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe-nieng-xe', 'bx-target-lock', 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 'bx-git-commit', 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 'bx-rocket', 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 'bx-shape-circle', 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 'bx-box', 1);

-- ==========================================
-- 3. THÊM THƯƠNG HIỆU (BRANDS)
-- ==========================================
INSERT INTO Brands (BrandName, LogoUrl, Description)
VALUES 
(N'Malossi', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Malossi_logo.svg/1200px-Malossi_logo.svg.png', N'Xuất xứ: Italy. Thương hiệu hàng đầu chuyên về bộ nồi hiệu năng cao.'),
(N'Motobatt', 'https://www.motobatt.com/image/catalog/logo.png', N'Xuất xứ: USA. Công nghệ ắc quy Gel QuadFlex độc quyền.'),
(N'CRG', 'https://constructorsrg.com/templates/beez3/images/logo.png', N'Xuất xứ: USA. Phụ kiện điều khiển CNC cao cấp.'),
(N'Yaguso', 'https://yaguso.com/wp-content/uploads/2021/05/logo-yaguso.png', N'Xuất xứ: Thailand. Căm và niềng xe máy mạ chrome cao cấp.'),
(N'Senarco', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_cyt.png', N'Xuất xứ: Malaysia. Dầu nhớt và phụ gia bảo trì xe máy.');

-- ==========================================
-- 4. THÊM SẢN PHẨM MẪU (PRODUCTS)
-- ==========================================
DECLARE @Pid INT;

-- SP 1: Bi nồi Malossi
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Bi nồi Vision 2011-2020 Malossi Phiên bản đỏ', 'bi-noi-vision-malossi', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bộ nồi trước'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'Malossi'),
       N'<p>Bi nồi cao cấp gia cường sợi carbon từ Malossi Ý, giúp xe tăng tốc mượt mà, độ bền cực cao.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 140000, 185000, 100, 'MAL-VIS-01', GETDATE(), 100000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/bi-noi-vision_medium.jpg', 1, 0);

-- SP 2: Bố 3 càng Malossi
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Bố 3 càng SH Mode gia cường sợi carbon Malossi', 'bo-3-cang-sh-malossi', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bộ nồi sau'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'Malossi'),
       N'<p>Bố 3 càng mặt bố đen cao cấp, gia cường 30% sợi carbon, chống rung đầu khi khởi hành.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 309000, 380000, 50, 'MAL-SH-02', GETDATE(), 250000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/bo-3-cang_medium.jpg', 1, 0);

-- SP 3: Combo NSD CRG
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Combo nhông sên dĩa Raider Fi sên vàng CRG', 'combo-nsd-raider-crg', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Combo 3 món'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'CRG'),
       N'<p>Bộ nhông sên dĩa cao cấp cho Suzuki Raider Fi, sên vàng 428H dày dặn, bền bỉ.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 535000, 650000, 30, 'CRG-NSD-RAI', GETDATE(), 450000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/nsd-vang_medium.jpg', 1, 0);

-- SP 4: Bình điện Motobatt
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Bình điện Motobatt Quadflex 11.5Ah PKL', 'binh-motobatt-11ah', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bình điện phân khối lớn'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'Motobatt'),
       N'<p>Dòng bình điện khủng cho xe PKL, công nghệ Gel 4 cực QuadFlex, dòng xả CCA cực cao.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 2648000, 3200000, 10, 'MTB-11AH-PKL', GETDATE(), 2000000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/motobatt-quadflex_medium.jpg', 1, 0);

-- SP 5: Lọc gió Malossi
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Lọc Gió Dầu MALOSSI Vision 2016 chính hãng', 'loc-gio-vision-malossi', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Lọc gió Honda'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'Malossi'),
       N'<p>Lọc gió dầu giấy lọc cao cấp Malossi giúp lọc bụi triệt để, bảo vệ động cơ tối ưu.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 63200, 85000, 200, 'MAL-LOC-VIS', GETDATE(), 45000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/loc-gio-vision_medium.jpg', 1, 0);

-- SP 6: Nhớt Senarco
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Nhớt Senarco Ultimax 10W40 Tổng hợp 100%', 'nhot-senarco-ultimax', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Nhớt 4 thì'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'Senarco'),
       N'<p>Nhớt tổng hợp hoàn toàn thế hệ mới, chu kỳ thay nhớt trên 3000KM, giúp máy êm mát.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 364000, 420000, 100, 'SEN-ULTI-01', GETDATE(), 300000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/senarco-ultimax_medium.jpg', 1, 0);

-- SP 7: Bố thắng CRG
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Bố thắng đùm sau SH Mode CRG Nhôm ADC12', 'bo-thang-sh-mode-crg', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bố thắng đùm'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'CRG'),
       N'<p>Làm từ nhôm ADC12 nguyên khối, tăng khả năng ma sát và độ bền, không gây hại cho may-ơ.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 105000, 135000, 80, 'CRG-BT-SH', GETDATE(), 80000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/bo-thang-dum_medium.jpg', 1, 0);

-- SP 8: Chén cổ CRG
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Chén cổ Exciter 150 Hợp kim thép CRG', 'chen-co-ex150-crg', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CHÉN CỔ'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'CRG'),
       N'<p>Chất liệu thép hợp kim chịu lực cực tốt, giúp tay lái nhẹ nhàng và ổn định.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 95000, 120000, 40, 'CRG-CC-EX150', GETDATE(), 70000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/chen-co_medium.jpg', 1, 0);

-- SP 9: Dây thắng CRG
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Dây thắng Vespa thép chịu lực CRG', 'day-thang-vespa-crg', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Dây thắng'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'CRG'),
       N'<p>Thép chịu lực chống mài mòn và co giãn, đảm bảo lực phanh chuẩn xác cho dòng xe Vespa.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 195000, 240000, 30, 'CRG-DT-VES', GETDATE(), 150000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/day-thang_medium.jpg', 1, 0);

-- SP 10: Căm Yaguso
INSERT INTO Products (ProductName, Slug, CategoryId, BrandId, Description, IsActive, CreatedDate, IsDeleted, IsFeatured)
SELECT N'Căm Thái Lan Chrome Yaguso Diamond cao cấp', 'cam-yaguso-diamond', 
       (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CĂM XE MÁY'),
       (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = 'Yaguso'),
       N'<p>Mạ Chrome 3 lớp sáng bóng, phiên bản Diamond chịu lực cực cao, nhập khẩu Thái Lan.</p>', 1, GETDATE(), 0, 1;
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, StockQuantity, SKU, CreatedDate, CostPrice) VALUES (@Pid, N'Mặc định', 671200, 850000, 60, 'YAG-DIA-01', GETDATE(), 500000);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, 'https://product.hstatic.net/1000282430/product/cam-yaguso_medium.jpg', 1, 0);

COMMIT;
SELECT N'NẠP MASTER DATA THÀNH CÔNG!' AS Status;
GO
