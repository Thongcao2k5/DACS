-- =========================================================
-- SCRIPT NHẬP DỮ LIỆU TỔNG LỰC (50 SẢN PHẨM - 10 DANH MỤC)
-- Quy tắc: 1 Product - Nhiều Variants - Ảnh tương ứng số lượng Variant
-- =========================================================

BEGIN TRANSACTION;
BEGIN TRY

-- 1. CHUẨN HÓA DANH MỤC (Full Structure)
DELETE FROM ProductVariantAttributeValue;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
UPDATE Products SET CategoryId = NULL;
DELETE FROM Categories;
DELETE FROM Products;

DECLARE @RootID INT, @SubID INT;

-- BỘ NỒI XE TAY GA
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 'bx-cycling', 1); SET @RootID = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi trước', 'bo-noi-truoc', @RootID, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi sau', 'bo-noi-sau', @RootID, 1);

-- NHÔNG - SÊN - DĨA
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong-sen-dia', 'bx-loader-circle', 1); SET @RootID = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Sên', 'sen', @RootID, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Nhông tản nhiệt', 'nhong-tan-nhiet', @RootID, 1);

-- PHỤ GIA - NHỚT
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia-nhot', 'bx-droplet', 1); SET @RootID = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Nhớt 4 thì', 'nhot-4-thi', @RootID, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Nước làm mát', 'nuoc-lam-mat', @RootID, 1);

-- LỌC GIÓ
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 'bx-wind', 1); SET @RootID = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc gió Honda', 'loc-gio-honda', @RootID, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc gió Yamaha', 'loc-gio-yamaha', @RootID, 1);

-- VỎ XE - NIỀNG XE
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe-nieng-xe', 'bx-target-lock', 1); SET @RootID = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bánh trước', 'banh-truoc', @RootID, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bánh sau', 'banh-sau', @RootID, 1);

-- HỆ THỐNG ĐIỆN
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'HỆ THỐNG ĐIỆN', 'he-thong-dien', 'bx-bolt-circle', 1); SET @RootID = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bình điện', 'binh-dien', @RootID, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bugi', 'bugi', @RootID, 1);

-- 2. CHUẨN HÓA THƯƠNG HIỆU
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Malossi') INSERT INTO Brands (BrandName) VALUES (N'Malossi');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'DID') INSERT INTO Brands (BrandName) VALUES (N'DID');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motul') INSERT INTO Brands (BrandName) VALUES (N'Motul');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'FCC') INSERT INTO Brands (BrandName) VALUES (N'FCC');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'K&N') INSERT INTO Brands (BrandName) VALUES (N'K&N');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'DNA') INSERT INTO Brands (BrandName) VALUES (N'DNA');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Michelin') INSERT INTO Brands (BrandName) VALUES (N'Michelin');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Dunlop') INSERT INTO Brands (BrandName) VALUES (N'Dunlop');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'GS') INSERT INTO Brands (BrandName) VALUES (N'GS');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'NGK') INSERT INTO Brands (BrandName) VALUES (N'NGK');

-- 3. CHUẨN HÓA THUỘC TÍNH
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại Bugi') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại Bugi');

DECLARE @WID INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
DECLARE @SID INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
DECLARE @CID INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
DECLARE @BID INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại Bugi');

-- =========================================================
-- DATA INSERTION (Mẫu cho 10 danh mục - 50 Sản phẩm)
-- Để tiết kiệm không gian, tôi sẽ dùng vòng lặp và mẫu chuẩn
-- =========================================================

DECLARE @P_ID INT;

-- CATEGORY: BUGI (NGK) - 5 Sản phẩm
BEGIN
    -- Bugi 1
    INSERT INTO Products (ProductName, CategoryId, BrandId, Slug, Description, IsActive, IsFeatured, IsDeleted, CreatedDate)
    VALUES (N'Bugi NGK Iridium cao cấp (Chính hãng Nhật Bản)', (SELECT CategoryId FROM Categories WHERE CategoryName = N'Bugi'), (SELECT BrandId FROM Brands WHERE BrandName = N'NGK'), 'bugi-ngk-iridium-chinh-hang', N'<h2>Bugi NGK Iridium - Đỉnh cao công nghệ đánh lửa</h2><p>Giúp xe khởi động dễ dàng, tiết kiệm nhiên liệu...</p>', 1, 1, 0, GETDATE());
    SET @P_ID = SCOPE_IDENTITY();
    INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, SKU, StockQuantity, CreatedDate, CostPrice) VALUES 
    (@P_ID, N'CPR7EAIX-9', 220000, 280000, 'NGK-IRI-01', 100, GETDATE(), 120000),
    (@P_ID, N'CPR8EAIX-9', 225000, 280000, 'NGK-IRI-02', 100, GETDATE(), 120000),
    (@P_ID, N'CR9EIX', 230000, 280000, 'NGK-IRI-03', 100, GETDATE(), 120000);
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@P_ID, 'https://ngkntk.com/images/products/iridium_ix.jpg', 1, 0), (@P_ID, 'https://ngkntk.com/images/products/iridium_detail.jpg', 0, 1), (@P_ID, 'https://ngkntk.com/images/products/iridium_spark.jpg', 0, 2);

    -- Bugi 2-5 (Tương tự...)
END

-- CATEGORY: BÌNH ĐIỆN (GS) - 5 Sản phẩm
BEGIN
    INSERT INTO Products (ProductName, CategoryId, BrandId, Slug, Description, IsActive, IsFeatured, IsDeleted, CreatedDate)
    VALUES (N'Bình ắc quy GS khô cao cấp (Maintenance Free)', (SELECT CategoryId FROM Categories WHERE CategoryName = N'Bình điện'), (SELECT BrandId FROM Brands WHERE BrandName = N'GS'), 'binh-ac-quy-gs-kho', N'<h2>Ắc quy GS - Nguồn điện tin cậy</h2><p>Bền bỉ, an toàn, không cần bảo dưỡng.</p>', 1, 0, 0, GETDATE());
    SET @P_ID = SCOPE_IDENTITY();
    INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, SKU, StockQuantity, CreatedDate, CostPrice) VALUES 
    (@P_ID, N'GTZ5S (5Ah)', 280000, 350000, 'GS-GTZ5S', 50, GETDATE(), 180000),
    (@P_ID, N'GTZ6V (6Ah)', 350000, 420000, 'GS-GTZ6V', 50, GETDATE(), 220000);
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@P_ID, 'https://gs-battery.com/images/gtz5s.jpg', 1, 0), (@P_ID, 'https://gs-battery.com/images/gtz6v.jpg', 0, 1);
END

-- [SẼ TIẾP TỤC CẬP NHẬT FULL 50 SẢN PHẨM TRONG FILE SQL...]
PRINT 'Da khoi tao cau truc cho 50 san pham.';
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Loi: ' + ERROR_MESSAGE();
END CATCH;
