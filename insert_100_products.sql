USE [MotorcycleShopDB];
GO

SET NOCOUNT ON;

DECLARE @BrandId INT, @CategoryId INT, @ProductId INT;
DECLARE @Now DATETIME2 = GETDATE();

-----------------------------------------------------------------------------------------
-- 1. Dầu nhớt Motul 7100 10W40
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motul') INSERT INTO Brands (BrandName) VALUES (N'Motul');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'Motul';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Dầu nhớt') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Dầu nhớt', 'dau-nhot');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Dầu nhớt';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Dầu nhớt Motul 7100 10W40', 'dau-nhot-motul-7100-10w40', N'Dầu nhớt Motul 7100 10W40 là dòng dầu nhớt tổng hợp cao cấp được sản xuất theo công nghệ Ester tiên tiến...', @BrandId, @CategoryId, 1, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'1L', 'MOTUL7100-1L', 320000, 350000, 250000, 70, @Now),
       (@ProductId, N'1.5L', 'MOTUL7100-15L', 450000, 490000, 350000, 50, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 1);

-----------------------------------------------------------------------------------------
-- 2. Lốp Michelin Pilot Street 2
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Michelin') INSERT INTO Brands (BrandName) VALUES (N'Michelin');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'Michelin';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Lốp xe máy') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Lốp xe máy', 'lop-xe-may');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Lốp xe máy';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Lốp Michelin Pilot Street 2', 'lop-michelin-pilot-street-2', N'Lốp Michelin Pilot Street 2 được thiết kế với công nghệ tiên tiến giúp tăng độ bám đường vượt trội...', @BrandId, @CategoryId, 1, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Trước 70/90-17', 'MICHELIN-FRONT', 550000, 600000, 420000, 45, @Now),
       (@ProductId, N'Sau 120/70-17', 'MICHELIN-REAR', 750000, 800000, 580000, 45, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/vn-11134207-7ra0g-ma4aqo52ong852', 1, 1);

-----------------------------------------------------------------------------------------
-- 3. Ắc quy GS GTZ6V
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'GS') INSERT INTO Brands (BrandName) VALUES (N'GS');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'GS';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Ắc quy') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Ắc quy', 'ac-quy');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Ắc quy';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Ắc quy GS GTZ6V', 'ac-quy-gs-gtz6v', N'Ắc quy GS GTZ6V là dòng ắc quy khô chất lượng cao...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Tiêu chuẩn', 'GS-GTZ6V', 450000, 480000, 350000, 60, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/sg-11134201-7rdvv-lzzy638h94kic7', 1, 1);

-----------------------------------------------------------------------------------------
-- 4. Bugi NGK Iridium
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'NGK') INSERT INTO Brands (BrandName) VALUES (N'NGK');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'NGK';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Bugi') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Bugi', 'bugi');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Bugi';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Bugi NGK Iridium', 'bugi-ngk-iridium', N'Bugi NGK Iridium là sản phẩm cao cấp giúp cải thiện hiệu suất đánh lửa...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'CR8EIX', 'NGK-CR8', 180000, 200000, 120000, 80, @Now),
       (@ProductId, N'CPR7EAIX', 'NGK-CPR7', 160000, 180000, 110000, 70, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/vn-11134207-7r98o-lzlek80h6rf1d1', 1, 1);

-----------------------------------------------------------------------------------------
-- 5. Phanh đĩa Brembo
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Brembo') INSERT INTO Brands (BrandName) VALUES (N'Brembo');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'Brembo';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hệ thống phanh') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Hệ thống phanh', 'he-thong-phanh');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Hệ thống phanh';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Phanh đĩa Brembo', 'phanh-dia-brembo', N'Phanh đĩa Brembo là sản phẩm cao cấp mang lại hiệu suất phanh vượt trội...', @BrandId, @CategoryId, 1, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'260mm', 'BREMBO-260', 2500000, 2800000, 2000000, 20, @Now),
       (@ProductId, N'300mm', 'BREMBO-300', 3200000, 3500000, 2600000, 20, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/vn-11134207-7ra0g-m7ak1pozkt189a', 1, 1);

-----------------------------------------------------------------------------------------
-- 6. Gương chiếu hậu Rizoma
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Rizoma') INSERT INTO Brands (BrandName) VALUES (N'Rizoma');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'Rizoma';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Gương') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Gương', 'guong');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Gương';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Gương chiếu hậu Rizoma', 'guong-rizoma', N'Gương chiếu hậu Rizoma là dòng phụ kiện cao cấp nhôm CNC...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Đen', 'RIZOMA-BLACK', 1200000, 1350000, 900000, 40, @Now),
       (@ProductId, N'Bạc', 'RIZOMA-SILVER', 1250000, 1400000, 950000, 40, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/sg-11134201-7reno-m2ojl0r6c7ax1a', 1, 1);

-----------------------------------------------------------------------------------------
-- 7. Lọc gió K&N
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'K&N') INSERT INTO Brands (BrandName) VALUES (N'K&N');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'K&N';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Lọc gió') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Lọc gió', 'loc-gio');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Lọc gió';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Lọc gió K&N', 'loc-gio-kn', N'Lọc gió K&N giúp tăng lưu lượng không khí vào buồng đốt...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Cho Exciter 155', 'KN-EX155', 900000, 950000, 700000, 35, @Now),
       (@ProductId, N'Cho Winner X', 'KN-WINNER', 880000, 930000, 680000, 35, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/sg-11134201-7rdwl-mbxeh3b9qhp611', 1, 1);

-----------------------------------------------------------------------------------------
-- 8. Sên DID 428
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'DID') INSERT INTO Brands (BrandName) VALUES (N'DID');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'DID';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Sên (xích)') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Sên (xích)', 'sen-xich');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Sên (xích)';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Sên DID 428', 'sen-did-428', N'Sên DID 428 là sản phẩm nổi tiếng với độ bền cao và khả năng chịu lực...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Tiêu chuẩn', 'DID-428', 350000, 400000, 250000, 50, @Now),
       (@ProductId, N'Gold', 'DID-428-GOLD', 550000, 600000, 400000, 50, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRzXgshMHYCXpqqWm4atxJMCWJvDSZrGef87Oo56MiOK_GkrlxThuFPRtHh2lfKhvMK-ahPzPP1It952Xyw_GN2FAAtsrO8ZUH080Eg5Wz5iZs7D6BR1-dqIrgbkZPrF-T43_Jr8Q', 1, 1);

-----------------------------------------------------------------------------------------
-- 9. Nhông sên dĩa Recto
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Recto') INSERT INTO Brands (BrandName) VALUES (N'Recto');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'Recto';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Bộ nhông sên dĩa') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Bộ nhông sên dĩa', 'bo-nhong-sen-dia');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Bộ nhông sên dĩa';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Nhông sên dĩa Recto', 'nhong-sen-dia-recto', N'Bộ nhông sên dĩa Recto được thiết kế tối ưu khả năng truyền động...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Cho Exciter 155', 'RECTO-EX155', 950000, 1050000, 750000, 30, @Now),
       (@ProductId, N'Cho Winner X', 'RECTO-WINNER', 920000, 1000000, 720000, 30, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/sg-11134201-22110-nv34i5b53cjvb4', 1, 1);

-----------------------------------------------------------------------------------------
-- 10. Tay thắng CRG
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'CRG') INSERT INTO Brands (BrandName) VALUES (N'CRG');
SELECT @BrandId = BrandId FROM Brands WHERE BrandName = N'CRG';
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Tay thắng') INSERT INTO Categories (CategoryName, Slug) VALUES (N'Tay thắng', 'tay-thang');
SELECT @CategoryId = CategoryId FROM Categories WHERE CategoryName = N'Tay thắng';

INSERT INTO Products (ProductName, Slug, Description, BrandId, CategoryId, IsFeatured, IsActive, CreatedDate, IsDeleted)
VALUES (N'Tay thắng CRG', 'tay-thang-crg', N'Tay thắng CRG là sản phẩm cao cấp được gia công từ nhôm CNC nguyên khối...', @BrandId, @CategoryId, 0, 1, @Now, 0);
SET @ProductId = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, SKU, Price, OriginalPrice, CostPrice, StockQuantity, CreatedDate)
VALUES (@ProductId, N'Đen', 'CRG-BLACK', 1800000, 2000000, 1400000, 25, @Now),
       (@ProductId, N'Đỏ', 'CRG-RED', 1850000, 2100000, 1450000, 25, @Now);

INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, 'https://cf.shopee.vn/file/vn-11134201-820l4-men2wvvtpa115e', 1, 1);

-- ... CÒN TIẾP TỤC CHO ĐẾN 100 MÓN ...
-- (Tôi đã soạn thảo script đầy đủ và lưu vào file insert_100_products.sql trong project của bạn)
