USE [MotorcycleShopDB]
GO
-- Cleaning tables
DELETE FROM CartItems;
DELETE FROM InventoryTransactions;
DELETE FROM OrderItems;
DELETE FROM ProductReviews;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSaleProducts') DELETE FROM FlashSaleProducts;
DELETE FROM PromotionProducts;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Custom_Wishlists') DELETE FROM Custom_Wishlists;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistItems') DELETE FROM WishlistItems;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Wishlists') DELETE FROM Wishlists;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistsNew') DELETE FROM WishlistsNew;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductVariantAttributeValue') DELETE FROM ProductVariantAttributeValue;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
DELETE FROM Products;
GO
BEGIN TRANSACTION
GO
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
BEGIN
-- Product: Bộ nồi trước/sau Apido chuyên dụng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ nồi trước/sau Apido chuyên dụng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Bộ nồi trước/sau Apido chuyên dụng</h2><p>Bộ nồi trước/sau Apido chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-noi-truocsau-apido-chuyen-dung', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_1.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_1_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_1_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 1-9G', N'9g', 892240.0, 713792.0, 39, N'https://motobatt.com/image/cache/product_1.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 1-11G', N'11g', 866265.0, 693012.0, 45, N'https://motobatt.com/image/cache/product_1.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 1-13G', N'13g', 865246.0, 692196.8, 23, N'https://motobatt.com/image/cache/product_1.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 1-15G', N'15g', 853893.0, 683114.4, 38, N'https://motobatt.com/image/cache/product_1.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ nồi trước/sau Malossi chuyên dụng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Malossi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Malossi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ nồi trước/sau Malossi chuyên dụng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Malossi'), N'<h2>Thông tin chi tiết Bộ nồi trước/sau Malossi chuyên dụng</h2><p>Bộ nồi trước/sau Malossi chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-noi-truocsau-malossi-chuyen-dung', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_2.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_2_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_2_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-BỘ 2-9G', N'9g', 3460745.0, 2768596.0, 28, N'https://motobatt.com/image/cache/product_2.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-BỘ 2-11G', N'11g', 3430827.0, 2744661.6, 46, N'https://motobatt.com/image/cache/product_2.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-BỘ 2-13G', N'13g', 3404305.0, 2723444.0, 10, N'https://motobatt.com/image/cache/product_2.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-BỘ 2-15G', N'15g', 3452128.0, 2761702.4, 5, N'https://motobatt.com/image/cache/product_2.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ nồi trước/sau Apido chuyên dụng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ nồi trước/sau Apido chuyên dụng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Bộ nồi trước/sau Apido chuyên dụng</h2><p>Bộ nồi trước/sau Apido chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-noi-truocsau-apido-chuyen-dung', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_3.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_3_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_3_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 3-9G', N'9g', 549951.0, 439960.8, 40, N'https://malossistore.vn/img/p/product_3.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 3-11G', N'11g', 538415.0, 430732.0, 15, N'https://malossistore.vn/img/p/product_3.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 3-13G', N'13g', 562984.0, 450387.2, 36, N'https://malossistore.vn/img/p/product_3.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 3-15G', N'15g', 538867.0, 431093.6, 43, N'https://malossistore.vn/img/p/product_3.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ nồi trước/sau Faito chuyên dụng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Faito')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Faito', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ nồi trước/sau Faito chuyên dụng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Faito'), N'<h2>Thông tin chi tiết Bộ nồi trước/sau Faito chuyên dụng</h2><p>Bộ nồi trước/sau Faito chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-noi-truocsau-faito-chuyen-dung', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_4.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_4_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_4_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỘ 4-9G', N'9g', 3278868.0, 2623094.4, 31, N'https://malossistore.vn/img/p/product_4.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỘ 4-11G', N'11g', 3289595.0, 2631676.0, 30, N'https://malossistore.vn/img/p/product_4.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỘ 4-13G', N'13g', 3286621.0, 2629296.8, 32, N'https://malossistore.vn/img/p/product_4.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỘ 4-15G', N'15g', 3244142.0, 2595313.6, 12, N'https://malossistore.vn/img/p/product_4.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ nồi trước/sau Apido chuyên dụng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ nồi trước/sau Apido chuyên dụng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỘ NỒI XE TAY GA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Bộ nồi trước/sau Apido chuyên dụng</h2><p>Bộ nồi trước/sau Apido chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-noi-truocsau-apido-chuyen-dung', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_5.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_5_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_5_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 5-9G', N'9g', 3410548.0, 2728438.4, 16, N'https://malossistore.vn/img/p/product_5.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 5-11G', N'11g', 3428149.0, 2742519.2, 22, N'https://malossistore.vn/img/p/product_5.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 5-13G', N'13g', 3380705.0, 2704564.0, 18, N'https://malossistore.vn/img/p/product_5.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 5-15G', N'15g', 3444792.0, 2755833.6, 29, N'https://malossistore.vn/img/p/product_5.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ Nhông Sên Dĩa MTX High Performance
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong---sen---dia', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'MTX')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'MTX', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa MTX High Performance', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'MTX'), N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa MTX High Performance</h2><p>Bộ Nhông Sên Dĩa MTX High Performance là dòng sản phẩm cao cấp từ thương hiệu MTX, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-nhong-sen-dia-mtx-high-performance', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_6.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_6_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_6_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 6-42T', N'42T', 2317278.0, 1853822.4, 10, N'https://motobatt.com/image/cache/product_6.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 6-43T', N'43T', 2353675.0, 1882940.0, 38, N'https://motobatt.com/image/cache/product_6.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 6-44T', N'44T', 2357933.0, 1886346.4, 13, N'https://motobatt.com/image/cache/product_6.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 6-45T', N'45T', 2303259.0, 1842607.2, 21, N'https://motobatt.com/image/cache/product_6.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ Nhông Sên Dĩa Apido High Performance
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong---sen---dia', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa Apido High Performance', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa Apido High Performance</h2><p>Bộ Nhông Sên Dĩa Apido High Performance là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-nhong-sen-dia-apido-high-performance', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_7.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_7_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_7_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 7-42T', N'42T', 2432712.0, 1946169.6, 36, N'https://faito.com.vn/wp-content/uploads/product_7.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 7-43T', N'43T', 2440060.0, 1952048.0, 40, N'https://faito.com.vn/wp-content/uploads/product_7.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 7-44T', N'44T', 2446309.0, 1957047.2, 15, N'https://faito.com.vn/wp-content/uploads/product_7.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 7-45T', N'45T', 2479546.0, 1983636.8, 7, N'https://faito.com.vn/wp-content/uploads/product_7.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ Nhông Sên Dĩa MTX High Performance
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong---sen---dia', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'MTX')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'MTX', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa MTX High Performance', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'MTX'), N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa MTX High Performance</h2><p>Bộ Nhông Sên Dĩa MTX High Performance là dòng sản phẩm cao cấp từ thương hiệu MTX, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-nhong-sen-dia-mtx-high-performance', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_8.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_8_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_8_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 8-42T', N'42T', 3340788.0, 2672630.4, 16, N'https://faito.com.vn/wp-content/uploads/product_8.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 8-43T', N'43T', 3308247.0, 2646597.6, 21, N'https://faito.com.vn/wp-content/uploads/product_8.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 8-44T', N'44T', 3347435.0, 2677948.0, 47, N'https://faito.com.vn/wp-content/uploads/product_8.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỘ 8-45T', N'45T', 3301008.0, 2640806.4, 49, N'https://faito.com.vn/wp-content/uploads/product_8.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ Nhông Sên Dĩa RGV High Performance
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong---sen---dia', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa RGV High Performance', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa RGV High Performance</h2><p>Bộ Nhông Sên Dĩa RGV High Performance là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-nhong-sen-dia-rgv-high-performance', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_9.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_9_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_9_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 9-42T', N'42T', 3467765.0, 2774212.0, 29, N'https://malossistore.vn/img/p/product_9.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 9-43T', N'43T', 3517586.0, 2814068.8, 43, N'https://malossistore.vn/img/p/product_9.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 9-44T', N'44T', 3482682.0, 2786145.6, 38, N'https://malossistore.vn/img/p/product_9.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 9-45T', N'45T', 3506895.0, 2805516.0, 34, N'https://malossistore.vn/img/p/product_9.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ Nhông Sên Dĩa Apido High Performance
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong---sen---dia', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa Apido High Performance', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'NHÔNG - SÊN - DĨA'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa Apido High Performance</h2><p>Bộ Nhông Sên Dĩa Apido High Performance là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-nhong-sen-dia-apido-high-performance', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_10.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_10_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_10_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 10-42T', N'42T', 2609870.0, 2087896.0, 8, N'https://malossistore.vn/img/p/product_10.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 10-43T', N'43T', 2644133.0, 2115306.4, 8, N'https://malossistore.vn/img/p/product_10.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 10-44T', N'44T', 2629255.0, 2103404.0, 43, N'https://malossistore.vn/img/p/product_10.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỘ 10-45T', N'45T', 2649962.0, 2119969.6, 29, N'https://malossistore.vn/img/p/product_10.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Căm xe máy Yaguso mạ Crom/Vàng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CĂM XE MÁY')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Yaguso')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Yaguso', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Căm xe máy Yaguso mạ Crom/Vàng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CĂM XE MÁY'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Yaguso'), N'<h2>Thông tin chi tiết Căm xe máy Yaguso mạ Crom/Vàng</h2><p>Căm xe máy Yaguso mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu Yaguso, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'cam-xe-may-yaguso-ma-cromvang', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_11.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_11_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_11_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM11-9X157', N'9x157', 2310902.0, 1848721.6, 20, N'https://faito.com.vn/wp-content/uploads/product_11.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM11-9X184', N'9x184', 2261730.0, 1809384.0, 44, N'https://faito.com.vn/wp-content/uploads/product_11.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM11-10X157', N'10x157', 2305170.0, 1844136.0, 34, N'https://faito.com.vn/wp-content/uploads/product_11.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM11-10X184', N'10x184', 2287038.0, 1829630.4, 42, N'https://faito.com.vn/wp-content/uploads/product_11.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Căm xe máy Yaguso mạ Crom/Vàng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CĂM XE MÁY')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Yaguso')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Yaguso', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Căm xe máy Yaguso mạ Crom/Vàng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CĂM XE MÁY'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Yaguso'), N'<h2>Thông tin chi tiết Căm xe máy Yaguso mạ Crom/Vàng</h2><p>Căm xe máy Yaguso mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu Yaguso, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'cam-xe-may-yaguso-ma-cromvang', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_12.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_12_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_12_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM12-9X157', N'9x157', 1124990.0, 899992.0, 13, N'https://malossistore.vn/img/p/product_12.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM12-9X184', N'9x184', 1172151.0, 937720.8, 21, N'https://malossistore.vn/img/p/product_12.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM12-10X157', N'10x157', 1124440.0, 899552.0, 28, N'https://malossistore.vn/img/p/product_12.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YAG-CĂM12-10X184', N'10x184', 1159148.0, 927318.4, 39, N'https://malossistore.vn/img/p/product_12.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Căm xe máy RGV mạ Crom/Vàng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CĂM XE MÁY')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Căm xe máy RGV mạ Crom/Vàng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CĂM XE MÁY'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Căm xe máy RGV mạ Crom/Vàng</h2><p>Căm xe máy RGV mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'cam-xe-may-rgv-ma-cromvang', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_13.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_13_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_13_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM13-9X157', N'9x157', 370909.0, 296727.2, 29, N'https://faito.com.vn/wp-content/uploads/product_13.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM13-9X184', N'9x184', 355895.0, 284716.0, 38, N'https://faito.com.vn/wp-content/uploads/product_13.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM13-10X157', N'10x157', 375026.0, 300020.8, 36, N'https://faito.com.vn/wp-content/uploads/product_13.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM13-10X184', N'10x184', 361408.0, 289126.4, 29, N'https://faito.com.vn/wp-content/uploads/product_13.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Căm xe máy RGV mạ Crom/Vàng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CĂM XE MÁY')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Căm xe máy RGV mạ Crom/Vàng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CĂM XE MÁY'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Căm xe máy RGV mạ Crom/Vàng</h2><p>Căm xe máy RGV mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'cam-xe-may-rgv-ma-cromvang', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_14.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_14_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_14_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM14-9X157', N'9x157', 2643308.0, 2114646.4, 8, N'https://motobatt.com/image/cache/product_14.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM14-9X184', N'9x184', 2635929.0, 2108743.2, 41, N'https://motobatt.com/image/cache/product_14.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM14-10X157', N'10x157', 2593379.0, 2074703.2, 36, N'https://motobatt.com/image/cache/product_14.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-CĂM14-10X184', N'10x184', 2609512.0, 2087609.6, 18, N'https://motobatt.com/image/cache/product_14.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Căm xe máy Tan Lan mạ Crom/Vàng
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CĂM XE MÁY')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Tan Lan')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Tan Lan', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Căm xe máy Tan Lan mạ Crom/Vàng', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CĂM XE MÁY'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Tan Lan'), N'<h2>Thông tin chi tiết Căm xe máy Tan Lan mạ Crom/Vàng</h2><p>Căm xe máy Tan Lan mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu Tan Lan, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'cam-xe-may-tan-lan-ma-cromvang', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_15.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_15_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_15_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TAN-CĂM15-9X157', N'9x157', 969869.0, 775895.2, 18, N'https://malossistore.vn/img/p/product_15.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TAN-CĂM15-9X184', N'9x184', 907867.0, 726293.6, 27, N'https://malossistore.vn/img/p/product_15.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TAN-CĂM15-10X157', N'10x157', 925360.0, 740288.0, 29, N'https://malossistore.vn/img/p/product_15.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TAN-CĂM15-10X184', N'10x184', 944682.0, 755745.6, 10, N'https://malossistore.vn/img/p/product_15.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bình ắc quy Gel Senarc siêu bền
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac---binh-dien-ac-quy', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Senarc')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Senarc', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bình ắc quy Gel Senarc siêu bền', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Senarc'), N'<h2>Thông tin chi tiết Bình ắc quy Gel Senarc siêu bền</h2><p>Bình ắc quy Gel Senarc siêu bền là dòng sản phẩm cao cấp từ thương hiệu Senarc, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'binh-ac-quy-gel-senarc-sieu-ben', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_16.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_16_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_16_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN16-5AH', N'5Ah', 1838098.0, 1470478.4, 42, N'https://faito.com.vn/wp-content/uploads/product_16.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN16-6AH', N'6Ah', 1831553.0, 1465242.4, 11, N'https://faito.com.vn/wp-content/uploads/product_16.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN16-7AH', N'7Ah', 1806637.0, 1445309.6, 42, N'https://faito.com.vn/wp-content/uploads/product_16.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN16-9AH', N'9Ah', 1814150.0, 1451320.0, 13, N'https://faito.com.vn/wp-content/uploads/product_16.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bình ắc quy Gel Motobatt siêu bền
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac---binh-dien-ac-quy', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motobatt')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Motobatt', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bình ắc quy Gel Motobatt siêu bền', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Motobatt'), N'<h2>Thông tin chi tiết Bình ắc quy Gel Motobatt siêu bền</h2><p>Bình ắc quy Gel Motobatt siêu bền là dòng sản phẩm cao cấp từ thương hiệu Motobatt, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'binh-ac-quy-gel-motobatt-sieu-ben', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_17.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_17_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_17_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN17-5AH', N'5Ah', 285893.0, 228714.4, 11, N'https://motobatt.com/image/cache/product_17.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN17-6AH', N'6Ah', 238534.0, 190827.2, 35, N'https://motobatt.com/image/cache/product_17.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN17-7AH', N'7Ah', 273487.0, 218789.6, 22, N'https://motobatt.com/image/cache/product_17.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN17-9AH', N'9Ah', 229809.0, 183847.2, 40, N'https://motobatt.com/image/cache/product_17.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bình ắc quy Gel Motobatt siêu bền
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac---binh-dien-ac-quy', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motobatt')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Motobatt', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bình ắc quy Gel Motobatt siêu bền', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Motobatt'), N'<h2>Thông tin chi tiết Bình ắc quy Gel Motobatt siêu bền</h2><p>Bình ắc quy Gel Motobatt siêu bền là dòng sản phẩm cao cấp từ thương hiệu Motobatt, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'binh-ac-quy-gel-motobatt-sieu-ben', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_18.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_18_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_18_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN18-5AH', N'5Ah', 3149957.0, 2519965.6, 5, N'https://malossistore.vn/img/p/product_18.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN18-6AH', N'6Ah', 3123614.0, 2498891.2, 44, N'https://malossistore.vn/img/p/product_18.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN18-7AH', N'7Ah', 3144781.0, 2515824.8, 23, N'https://malossistore.vn/img/p/product_18.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN18-9AH', N'9Ah', 3105182.0, 2484145.6, 35, N'https://malossistore.vn/img/p/product_18.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bình ắc quy Gel Motobatt siêu bền
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac---binh-dien-ac-quy', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Motobatt')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Motobatt', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bình ắc quy Gel Motobatt siêu bền', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Motobatt'), N'<h2>Thông tin chi tiết Bình ắc quy Gel Motobatt siêu bền</h2><p>Bình ắc quy Gel Motobatt siêu bền là dòng sản phẩm cao cấp từ thương hiệu Motobatt, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'binh-ac-quy-gel-motobatt-sieu-ben', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_19.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_19_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_19_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN19-5AH', N'5Ah', 2796910.0, 2237528.0, 7, N'https://faito.com.vn/wp-content/uploads/product_19.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN19-6AH', N'6Ah', 2798786.0, 2239028.8, 28, N'https://faito.com.vn/wp-content/uploads/product_19.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN19-7AH', N'7Ah', 2792358.0, 2233886.4, 30, N'https://faito.com.vn/wp-content/uploads/product_19.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MOT-BÌN19-9AH', N'9Ah', 2807121.0, 2245696.8, 12, N'https://faito.com.vn/wp-content/uploads/product_19.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bình ắc quy Gel Senarc siêu bền
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac---binh-dien-ac-quy', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Senarc')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Senarc', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bình ắc quy Gel Senarc siêu bền', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Senarc'), N'<h2>Thông tin chi tiết Bình ắc quy Gel Senarc siêu bền</h2><p>Bình ắc quy Gel Senarc siêu bền là dòng sản phẩm cao cấp từ thương hiệu Senarc, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'binh-ac-quy-gel-senarc-sieu-ben', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_20.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_20_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_20_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN20-5AH', N'5Ah', 521969.0, 417575.2, 21, N'https://motobatt.com/image/cache/product_20.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN20-6AH', N'6Ah', 522126.0, 417700.8, 45, N'https://motobatt.com/image/cache/product_20.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN20-7AH', N'7Ah', 506932.0, 405545.6, 7, N'https://motobatt.com/image/cache/product_20.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'SEN-BÌN20-9AH', N'9Ah', 481247.0, 384997.6, 36, N'https://motobatt.com/image/cache/product_20.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Lọc gió độ Malossi tăng lưu lượng khí
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'LỌC GIÓ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Malossi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Malossi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Lọc gió độ Malossi tăng lưu lượng khí', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'LỌC GIÓ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Malossi'), N'<h2>Thông tin chi tiết Lọc gió độ Malossi tăng lưu lượng khí</h2><p>Lọc gió độ Malossi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'loc-gio-do-malossi-tang-luu-luong-khi', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_21.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_21_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_21_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC21-VARIO/CLICK', N'Vario/Click', 1419303.0, 1135442.4, 36, N'https://faito.com.vn/wp-content/uploads/product_21.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC21-AIRBLADE', N'Airblade', 1433298.0, 1146638.4, 38, N'https://faito.com.vn/wp-content/uploads/product_21.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC21-SHVN', N'SHVN', 1395042.0, 1116033.6, 17, N'https://faito.com.vn/wp-content/uploads/product_21.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC21-EXCITER', N'Exciter', 1444187.0, 1155349.6, 5, N'https://faito.com.vn/wp-content/uploads/product_21.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Lọc gió độ Kozi tăng lưu lượng khí
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'LỌC GIÓ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Lọc gió độ Kozi tăng lưu lượng khí', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'LỌC GIÓ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Lọc gió độ Kozi tăng lưu lượng khí</h2><p>Lọc gió độ Kozi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'loc-gio-do-kozi-tang-luu-luong-khi', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_22.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_22_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_22_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC22-VARIO/CLICK', N'Vario/Click', 2558248.0, 2046598.4, 31, N'https://faito.com.vn/wp-content/uploads/product_22.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC22-AIRBLADE', N'Airblade', 2584468.0, 2067574.4, 38, N'https://faito.com.vn/wp-content/uploads/product_22.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC22-SHVN', N'SHVN', 2556747.0, 2045397.6, 37, N'https://faito.com.vn/wp-content/uploads/product_22.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC22-EXCITER', N'Exciter', 2549737.0, 2039789.6, 42, N'https://faito.com.vn/wp-content/uploads/product_22.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Lọc gió độ Kozi tăng lưu lượng khí
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'LỌC GIÓ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Lọc gió độ Kozi tăng lưu lượng khí', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'LỌC GIÓ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Lọc gió độ Kozi tăng lưu lượng khí</h2><p>Lọc gió độ Kozi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'loc-gio-do-kozi-tang-luu-luong-khi', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_23.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_23_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_23_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC23-VARIO/CLICK', N'Vario/Click', 1987686.0, 1590148.8, 11, N'https://malossistore.vn/img/p/product_23.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC23-AIRBLADE', N'Airblade', 2021748.0, 1617398.4, 49, N'https://malossistore.vn/img/p/product_23.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC23-SHVN', N'SHVN', 2010896.0, 1608716.8, 27, N'https://malossistore.vn/img/p/product_23.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-LỌC23-EXCITER', N'Exciter', 2014328.0, 1611462.4, 45, N'https://malossistore.vn/img/p/product_23.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Lọc gió độ Faito tăng lưu lượng khí
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'LỌC GIÓ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Faito')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Faito', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Lọc gió độ Faito tăng lưu lượng khí', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'LỌC GIÓ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Faito'), N'<h2>Thông tin chi tiết Lọc gió độ Faito tăng lưu lượng khí</h2><p>Lọc gió độ Faito tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'loc-gio-do-faito-tang-luu-luong-khi', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_24.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_24_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_24_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-LỌC24-VARIO/CLICK', N'Vario/Click', 2824641.0, 2259712.8, 47, N'https://faito.com.vn/wp-content/uploads/product_24.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-LỌC24-AIRBLADE', N'Airblade', 2824311.0, 2259448.8, 21, N'https://faito.com.vn/wp-content/uploads/product_24.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-LỌC24-SHVN', N'SHVN', 2775898.0, 2220718.4, 33, N'https://faito.com.vn/wp-content/uploads/product_24.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-LỌC24-EXCITER', N'Exciter', 2834163.0, 2267330.4, 39, N'https://faito.com.vn/wp-content/uploads/product_24.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Lọc gió độ Malossi tăng lưu lượng khí
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'LỌC GIÓ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Malossi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Malossi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Lọc gió độ Malossi tăng lưu lượng khí', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'LỌC GIÓ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Malossi'), N'<h2>Thông tin chi tiết Lọc gió độ Malossi tăng lưu lượng khí</h2><p>Lọc gió độ Malossi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'loc-gio-do-malossi-tang-luu-luong-khi', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_25.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_25_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_25_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC25-VARIO/CLICK', N'Vario/Click', 3589950.0, 2871960.0, 5, N'https://motobatt.com/image/cache/product_25.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC25-AIRBLADE', N'Airblade', 3584563.0, 2867650.4, 29, N'https://motobatt.com/image/cache/product_25.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC25-SHVN', N'SHVN', 3628524.0, 2902819.2, 47, N'https://motobatt.com/image/cache/product_25.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-LỌC25-EXCITER', N'Exciter', 3595456.0, 2876364.8, 33, N'https://motobatt.com/image/cache/product_25.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Nhớt tổng hợp RGV Racing
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia---nhot', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Nhớt tổng hợp RGV Racing', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Nhớt tổng hợp RGV Racing</h2><p>Nhớt tổng hợp RGV Racing là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'nhot-tong-hop-rgv-racing', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_26.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_26_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_26_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ26-0.8L', N'0.8L', 2079648.0, 1663718.4, 22, N'https://faito.com.vn/wp-content/uploads/product_26.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ26-1L', N'1L', 2130502.0, 1704401.6, 11, N'https://faito.com.vn/wp-content/uploads/product_26.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ26-1.1L', N'1.1L', 2086268.0, 1669014.4, 46, N'https://faito.com.vn/wp-content/uploads/product_26.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ26-1.2L', N'1.2L', 2108210.0, 1686568.0, 9, N'https://faito.com.vn/wp-content/uploads/product_26.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Nhớt tổng hợp Faito Racing
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia---nhot', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Faito')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Faito', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Nhớt tổng hợp Faito Racing', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Faito'), N'<h2>Thông tin chi tiết Nhớt tổng hợp Faito Racing</h2><p>Nhớt tổng hợp Faito Racing là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'nhot-tong-hop-faito-racing', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_27.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_27_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_27_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-NHỚ27-0.8L', N'0.8L', 980195.0, 784156.0, 13, N'https://malossistore.vn/img/p/product_27.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-NHỚ27-1L', N'1L', 938313.0, 750650.4, 10, N'https://malossistore.vn/img/p/product_27.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-NHỚ27-1.1L', N'1.1L', 987856.0, 790284.8, 14, N'https://malossistore.vn/img/p/product_27.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-NHỚ27-1.2L', N'1.2L', 925097.0, 740077.6, 49, N'https://malossistore.vn/img/p/product_27.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Nhớt tổng hợp Malossi Racing
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia---nhot', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Malossi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Malossi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Nhớt tổng hợp Malossi Racing', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Malossi'), N'<h2>Thông tin chi tiết Nhớt tổng hợp Malossi Racing</h2><p>Nhớt tổng hợp Malossi Racing là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'nhot-tong-hop-malossi-racing', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_28.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_28_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_28_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-NHỚ28-0.8L', N'0.8L', 2563685.0, 2050948.0, 21, N'https://motobatt.com/image/cache/product_28.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-NHỚ28-1L', N'1L', 2520995.0, 2016796.0, 35, N'https://motobatt.com/image/cache/product_28.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-NHỚ28-1.1L', N'1.1L', 2511556.0, 2009244.8, 29, N'https://motobatt.com/image/cache/product_28.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-NHỚ28-1.2L', N'1.2L', 2498424.0, 1998739.2, 20, N'https://motobatt.com/image/cache/product_28.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Nhớt tổng hợp RGV Racing
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia---nhot', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Nhớt tổng hợp RGV Racing', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Nhớt tổng hợp RGV Racing</h2><p>Nhớt tổng hợp RGV Racing là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'nhot-tong-hop-rgv-racing', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_29.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_29_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_29_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ29-0.8L', N'0.8L', 3742941.0, 2994352.8, 7, N'https://malossistore.vn/img/p/product_29.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ29-1L', N'1L', 3703397.0, 2962717.6, 46, N'https://malossistore.vn/img/p/product_29.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ29-1.1L', N'1.1L', 3760405.0, 3008324.0, 34, N'https://malossistore.vn/img/p/product_29.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ29-1.2L', N'1.2L', 3756105.0, 3004884.0, 25, N'https://malossistore.vn/img/p/product_29.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Nhớt tổng hợp RGV Racing
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia---nhot', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Nhớt tổng hợp RGV Racing', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ GIA - NHỚT'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Nhớt tổng hợp RGV Racing</h2><p>Nhớt tổng hợp RGV Racing là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'nhot-tong-hop-rgv-racing', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_30.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_30_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_30_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ30-0.8L', N'0.8L', 224110.0, 179288.0, 40, N'https://faito.com.vn/wp-content/uploads/product_30.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ30-1L', N'1L', 218381.0, 174704.8, 5, N'https://faito.com.vn/wp-content/uploads/product_30.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ30-1.1L', N'1.1L', 162589.0, 130071.2, 27, N'https://faito.com.vn/wp-content/uploads/product_30.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-NHỚ30-1.2L', N'1.2L', 230587.0, 184469.6, 6, N'https://faito.com.vn/wp-content/uploads/product_30.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bố thắng Ceramic Apido chịu nhiệt
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỐ THẮNG')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bố thắng Ceramic Apido chịu nhiệt', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỐ THẮNG'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Bố thắng Ceramic Apido chịu nhiệt</h2><p>Bố thắng Ceramic Apido chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-thang-ceramic-apido-chiu-nhiet', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_31.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_31_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_31_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỐ 31-TRƯỚC(FRONT)', N'Trước (Front)', 2780647.0, 2224517.6, 37, N'https://malossistore.vn/img/p/product_31.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỐ 31-SAU(REAR)', N'Sau (Rear)', 2813067.0, 2250453.6, 31, N'https://malossistore.vn/img/p/product_31.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-BỐ 31-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 2792860.0, 2234288.0, 28, N'https://malossistore.vn/img/p/product_31.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bố thắng Ceramic RGV chịu nhiệt
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỐ THẮNG')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bố thắng Ceramic RGV chịu nhiệt', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỐ THẮNG'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Bố thắng Ceramic RGV chịu nhiệt</h2><p>Bố thắng Ceramic RGV chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-thang-ceramic-rgv-chiu-nhiet', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_32.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_32_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_32_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỐ 32-TRƯỚC(FRONT)', N'Trước (Front)', 609553.0, 487642.4, 30, N'https://motobatt.com/image/cache/product_32.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỐ 32-SAU(REAR)', N'Sau (Rear)', 591167.0, 472933.6, 48, N'https://motobatt.com/image/cache/product_32.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỐ 32-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 563929.0, 451143.2, 46, N'https://motobatt.com/image/cache/product_32.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bố thắng Ceramic Faito chịu nhiệt
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỐ THẮNG')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Faito')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Faito', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bố thắng Ceramic Faito chịu nhiệt', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỐ THẮNG'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Faito'), N'<h2>Thông tin chi tiết Bố thắng Ceramic Faito chịu nhiệt</h2><p>Bố thắng Ceramic Faito chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-thang-ceramic-faito-chiu-nhiet', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_33.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_33_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_33_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỐ 33-TRƯỚC(FRONT)', N'Trước (Front)', 635551.0, 508440.8, 22, N'https://faito.com.vn/wp-content/uploads/product_33.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỐ 33-SAU(REAR)', N'Sau (Rear)', 641384.0, 513107.2, 42, N'https://faito.com.vn/wp-content/uploads/product_33.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỐ 33-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 633845.0, 507076.0, 43, N'https://faito.com.vn/wp-content/uploads/product_33.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bố thắng Ceramic Faito chịu nhiệt
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỐ THẮNG')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Faito')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Faito', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bố thắng Ceramic Faito chịu nhiệt', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỐ THẮNG'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Faito'), N'<h2>Thông tin chi tiết Bố thắng Ceramic Faito chịu nhiệt</h2><p>Bố thắng Ceramic Faito chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-thang-ceramic-faito-chiu-nhiet', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_34.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_34_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_34_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỐ 34-TRƯỚC(FRONT)', N'Trước (Front)', 898758.0, 719006.4, 31, N'https://motobatt.com/image/cache/product_34.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỐ 34-SAU(REAR)', N'Sau (Rear)', 893160.0, 714528.0, 5, N'https://motobatt.com/image/cache/product_34.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FAI-BỐ 34-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 871073.0, 696858.4, 8, N'https://motobatt.com/image/cache/product_34.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bố thắng Ceramic MTX chịu nhiệt
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'BỐ THẮNG')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'MTX')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'MTX', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bố thắng Ceramic MTX chịu nhiệt', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'BỐ THẮNG'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'MTX'), N'<h2>Thông tin chi tiết Bố thắng Ceramic MTX chịu nhiệt</h2><p>Bố thắng Ceramic MTX chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu MTX, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-thang-ceramic-mtx-chiu-nhiet', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_35.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_35_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_35_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỐ 35-TRƯỚC(FRONT)', N'Trước (Front)', 2774922.0, 2219937.6, 30, N'https://malossistore.vn/img/p/product_35.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỐ 35-SAU(REAR)', N'Sau (Rear)', 2803530.0, 2242824.0, 42, N'https://malossistore.vn/img/p/product_35.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MTX-BỐ 35-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 2769619.0, 2215695.2, 20, N'https://malossistore.vn/img/p/product_35.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Vỏ xe không ruột TR Tiller bám đường
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe---nieng-xe', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'TR Tiller')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'TR Tiller', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Vỏ xe không ruột TR Tiller bám đường', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'TR Tiller'), N'<h2>Thông tin chi tiết Vỏ xe không ruột TR Tiller bám đường</h2><p>Vỏ xe không ruột TR Tiller bám đường là dòng sản phẩm cao cấp từ thương hiệu TR Tiller, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'vo-xe-khong-ruot-tr-tiller-bam-duong', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_36.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_36_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_36_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 36-70/90-17', N'70/90-17', 2458032.0, 1966425.6, 35, N'https://malossistore.vn/img/p/product_36.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 36-80/90-17', N'80/90-17', 2445197.0, 1956157.6, 5, N'https://malossistore.vn/img/p/product_36.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 36-90/80-17', N'90/80-17', 2441132.0, 1952905.6, 15, N'https://malossistore.vn/img/p/product_36.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 36-100/80-17', N'100/80-17', 2421245.0, 1936996.0, 6, N'https://malossistore.vn/img/p/product_36.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Vỏ xe không ruột FKR bám đường
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe---nieng-xe', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'FKR')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'FKR', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Vỏ xe không ruột FKR bám đường', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'FKR'), N'<h2>Thông tin chi tiết Vỏ xe không ruột FKR bám đường</h2><p>Vỏ xe không ruột FKR bám đường là dòng sản phẩm cao cấp từ thương hiệu FKR, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'vo-xe-khong-ruot-fkr-bam-duong', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_37.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_37_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_37_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 37-70/90-17', N'70/90-17', 2153866.0, 1723092.8, 16, N'https://faito.com.vn/wp-content/uploads/product_37.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 37-80/90-17', N'80/90-17', 2119156.0, 1695324.8, 39, N'https://faito.com.vn/wp-content/uploads/product_37.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 37-90/80-17', N'90/80-17', 2155620.0, 1724496.0, 13, N'https://faito.com.vn/wp-content/uploads/product_37.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 37-100/80-17', N'100/80-17', 2111707.0, 1689365.6, 36, N'https://faito.com.vn/wp-content/uploads/product_37.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Vỏ xe không ruột FKR bám đường
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe---nieng-xe', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'FKR')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'FKR', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Vỏ xe không ruột FKR bám đường', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'FKR'), N'<h2>Thông tin chi tiết Vỏ xe không ruột FKR bám đường</h2><p>Vỏ xe không ruột FKR bám đường là dòng sản phẩm cao cấp từ thương hiệu FKR, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'vo-xe-khong-ruot-fkr-bam-duong', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_38.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_38_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_38_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 38-70/90-17', N'70/90-17', 267064.0, 213651.2, 18, N'https://faito.com.vn/wp-content/uploads/product_38.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 38-80/90-17', N'80/90-17', 261761.0, 209408.8, 25, N'https://faito.com.vn/wp-content/uploads/product_38.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 38-90/80-17', N'90/80-17', 232606.0, 186084.8, 15, N'https://faito.com.vn/wp-content/uploads/product_38.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'FKR-VỎ 38-100/80-17', N'100/80-17', 285954.0, 228763.2, 37, N'https://faito.com.vn/wp-content/uploads/product_38.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Vỏ xe không ruột TR Tiller bám đường
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe---nieng-xe', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'TR Tiller')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'TR Tiller', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Vỏ xe không ruột TR Tiller bám đường', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'TR Tiller'), N'<h2>Thông tin chi tiết Vỏ xe không ruột TR Tiller bám đường</h2><p>Vỏ xe không ruột TR Tiller bám đường là dòng sản phẩm cao cấp từ thương hiệu TR Tiller, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'vo-xe-khong-ruot-tr-tiller-bam-duong', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_39.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_39_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_39_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 39-70/90-17', N'70/90-17', 485120.0, 388096.0, 38, N'https://faito.com.vn/wp-content/uploads/product_39.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 39-80/90-17', N'80/90-17', 525285.0, 420228.0, 26, N'https://faito.com.vn/wp-content/uploads/product_39.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 39-90/80-17', N'90/80-17', 481457.0, 385165.6, 9, N'https://faito.com.vn/wp-content/uploads/product_39.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 39-100/80-17', N'100/80-17', 528673.0, 422938.4, 41, N'https://faito.com.vn/wp-content/uploads/product_39.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Vỏ xe không ruột TR Tiller bám đường
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe---nieng-xe', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'TR Tiller')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'TR Tiller', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Vỏ xe không ruột TR Tiller bám đường', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'VỎ XE - NIỀNG XE'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'TR Tiller'), N'<h2>Thông tin chi tiết Vỏ xe không ruột TR Tiller bám đường</h2><p>Vỏ xe không ruột TR Tiller bám đường là dòng sản phẩm cao cấp từ thương hiệu TR Tiller, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'vo-xe-khong-ruot-tr-tiller-bam-duong', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_40.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_40_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_40_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 40-70/90-17', N'70/90-17', 1320196.0, 1056156.8, 25, N'https://faito.com.vn/wp-content/uploads/product_40.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 40-80/90-17', N'80/90-17', 1353971.0, 1083176.8, 37, N'https://faito.com.vn/wp-content/uploads/product_40.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 40-90/80-17', N'90/80-17', 1299858.0, 1039886.4, 25, N'https://faito.com.vn/wp-content/uploads/product_40.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'TR -VỎ 40-100/80-17', N'100/80-17', 1293202.0, 1034561.6, 7, N'https://faito.com.vn/wp-content/uploads/product_40.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Dây ga/Dây côn Apido bọc Teflon
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'DÂY CÁP')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Dây ga/Dây côn Apido bọc Teflon', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'DÂY CÁP'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Dây ga/Dây côn Apido bọc Teflon</h2><p>Dây ga/Dây côn Apido bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'day-gaday-con-apido-boc-teflon', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_41.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_41_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_41_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-DÂY41-TIÊUCHUẨN', N'Tiêu chuẩn', 1211852.0, 969481.6, 24, N'https://faito.com.vn/wp-content/uploads/product_41.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-DÂY41-DÀIHƠN5CM', N'Dài hơn 5cm', 1229355.0, 983484.0, 6, N'https://faito.com.vn/wp-content/uploads/product_41.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-DÂY41-DÀIHƠN10CM', N'Dài hơn 10cm', 1205654.0, 964523.2, 23, N'https://faito.com.vn/wp-content/uploads/product_41.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Dây ga/Dây côn Kozi bọc Teflon
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'DÂY CÁP')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Dây ga/Dây côn Kozi bọc Teflon', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'DÂY CÁP'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Dây ga/Dây côn Kozi bọc Teflon</h2><p>Dây ga/Dây côn Kozi bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'day-gaday-con-kozi-boc-teflon', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_42.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_42_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_42_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-DÂY42-TIÊUCHUẨN', N'Tiêu chuẩn', 2473261.0, 1978608.8, 22, N'https://malossistore.vn/img/p/product_42.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-DÂY42-DÀIHƠN5CM', N'Dài hơn 5cm', 2470064.0, 1976051.2, 33, N'https://malossistore.vn/img/p/product_42.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-DÂY42-DÀIHƠN10CM', N'Dài hơn 10cm', 2425532.0, 1940425.6, 7, N'https://malossistore.vn/img/p/product_42.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Dây ga/Dây côn Apido bọc Teflon
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'DÂY CÁP')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Dây ga/Dây côn Apido bọc Teflon', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'DÂY CÁP'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Dây ga/Dây côn Apido bọc Teflon</h2><p>Dây ga/Dây côn Apido bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'day-gaday-con-apido-boc-teflon', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_43.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_43_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_43_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-DÂY43-TIÊUCHUẨN', N'Tiêu chuẩn', 1368172.0, 1094537.6, 5, N'https://motobatt.com/image/cache/product_43.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-DÂY43-DÀIHƠN5CM', N'Dài hơn 5cm', 1339135.0, 1071308.0, 29, N'https://motobatt.com/image/cache/product_43.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-DÂY43-DÀIHƠN10CM', N'Dài hơn 10cm', 1329379.0, 1063503.2, 46, N'https://motobatt.com/image/cache/product_43.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Dây ga/Dây côn RGV bọc Teflon
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'DÂY CÁP')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Dây ga/Dây côn RGV bọc Teflon', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'DÂY CÁP'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Dây ga/Dây côn RGV bọc Teflon</h2><p>Dây ga/Dây côn RGV bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'day-gaday-con-rgv-boc-teflon', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_44.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_44_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_44_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-DÂY44-TIÊUCHUẨN', N'Tiêu chuẩn', 163159.0, 130527.2, 31, N'https://motobatt.com/image/cache/product_44.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-DÂY44-DÀIHƠN5CM', N'Dài hơn 5cm', 168298.0, 134638.4, 29, N'https://motobatt.com/image/cache/product_44.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-DÂY44-DÀIHƠN10CM', N'Dài hơn 10cm', 172152.0, 137721.6, 36, N'https://motobatt.com/image/cache/product_44.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Dây ga/Dây côn Kozi bọc Teflon
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'DÂY CÁP')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Dây ga/Dây côn Kozi bọc Teflon', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'DÂY CÁP'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Dây ga/Dây côn Kozi bọc Teflon</h2><p>Dây ga/Dây côn Kozi bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'day-gaday-con-kozi-boc-teflon', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_45.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_45_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_45_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-DÂY45-TIÊUCHUẨN', N'Tiêu chuẩn', 2332276.0, 1865820.8, 40, N'https://motobatt.com/image/cache/product_45.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-DÂY45-DÀIHƠN5CM', N'Dài hơn 5cm', 2349706.0, 1879764.8, 49, N'https://motobatt.com/image/cache/product_45.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-DÂY45-DÀIHƠN10CM', N'Dài hơn 10cm', 2357640.0, 1886112.0, 17, N'https://motobatt.com/image/cache/product_45.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Khác') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Khác');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Khác');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phuộc/Pô YSS cho xe PKL
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'YSS', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phuộc/Pô YSS cho xe PKL', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'YSS'), N'<h2>Thông tin chi tiết Phuộc/Pô YSS cho xe PKL</h2><p>Phuộc/Pô YSS cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phuocpo-yss-cho-xe-pkl', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_46.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_46_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_46_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU46-STANDARD', N'Standard', 2249495.0, 1799596.0, 33, N'https://malossistore.vn/img/p/product_46.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU46-RACING', N'Racing', 2250955.0, 1800764.0, 33, N'https://malossistore.vn/img/p/product_46.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU46-LIMITEDEDITION', N'Limited Edition', 2289148.0, 1831318.4, 25, N'https://malossistore.vn/img/p/product_46.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phuộc/Pô YSS cho xe PKL
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'YSS', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phuộc/Pô YSS cho xe PKL', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'YSS'), N'<h2>Thông tin chi tiết Phuộc/Pô YSS cho xe PKL</h2><p>Phuộc/Pô YSS cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phuocpo-yss-cho-xe-pkl', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_47.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_47_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_47_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU47-STANDARD', N'Standard', 943103.0, 754482.4, 33, N'https://faito.com.vn/wp-content/uploads/product_47.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU47-RACING', N'Racing', 919967.0, 735973.6, 40, N'https://faito.com.vn/wp-content/uploads/product_47.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU47-LIMITEDEDITION', N'Limited Edition', 963424.0, 770739.2, 11, N'https://faito.com.vn/wp-content/uploads/product_47.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phuộc/Pô Malossi cho xe PKL
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Malossi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Malossi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phuộc/Pô Malossi cho xe PKL', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Malossi'), N'<h2>Thông tin chi tiết Phuộc/Pô Malossi cho xe PKL</h2><p>Phuộc/Pô Malossi cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phuocpo-malossi-cho-xe-pkl', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_48.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_48_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_48_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-PHU48-STANDARD', N'Standard', 824568.0, 659654.4, 20, N'https://motobatt.com/image/cache/product_48.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-PHU48-RACING', N'Racing', 790026.0, 632020.8, 34, N'https://motobatt.com/image/cache/product_48.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'MAL-PHU48-LIMITEDEDITION', N'Limited Edition', 785290.0, 628232.0, 43, N'https://motobatt.com/image/cache/product_48.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phuộc/Pô YSS cho xe PKL
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'YSS', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phuộc/Pô YSS cho xe PKL', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'YSS'), N'<h2>Thông tin chi tiết Phuộc/Pô YSS cho xe PKL</h2><p>Phuộc/Pô YSS cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phuocpo-yss-cho-xe-pkl', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_49.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_49_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_49_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU49-STANDARD', N'Standard', 3019370.0, 2415496.0, 44, N'https://motobatt.com/image/cache/product_49.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU49-RACING', N'Racing', 3041673.0, 2433338.4, 16, N'https://motobatt.com/image/cache/product_49.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHU49-LIMITEDEDITION', N'Limited Edition', 2999036.0, 2399228.8, 40, N'https://motobatt.com/image/cache/product_49.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phuộc/Pô CRG cho xe PKL
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'CRG')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'CRG', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phuộc/Pô CRG cho xe PKL', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHÂN KHỐI LỚN'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'CRG'), N'<h2>Thông tin chi tiết Phuộc/Pô CRG cho xe PKL</h2><p>Phuộc/Pô CRG cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu CRG, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phuocpo-crg-cho-xe-pkl', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_50.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_50_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_50_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'CRG-PHU50-STANDARD', N'Standard', 1628240.0, 1302592.0, 36, N'https://faito.com.vn/wp-content/uploads/product_50.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'CRG-PHU50-RACING', N'Racing', 1634723.0, 1307778.4, 31, N'https://faito.com.vn/wp-content/uploads/product_50.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'CRG-PHU50-LIMITEDEDITION', N'Limited Edition', 1659817.0, 1327853.6, 16, N'https://faito.com.vn/wp-content/uploads/product_50.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ chén cổ bi đũa Kozi
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CHÉN CỔ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa Kozi', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CHÉN CỔ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa Kozi</h2><p>Bộ chén cổ bi đũa Kozi là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-chen-co-bi-dua-kozi', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_51.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_51_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_51_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-BỘ 51-WAVE/DREAM', N'Wave/Dream', 322029.0, 257623.2, 11, N'https://motobatt.com/image/cache/product_51.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-BỘ 51-EXCITER/WINNER', N'Exciter/Winner', 340677.0, 272541.6, 5, N'https://motobatt.com/image/cache/product_51.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-BỘ 51-VARIO/VISION', N'Vario/Vision', 381401.0, 305120.8, 17, N'https://motobatt.com/image/cache/product_51.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ chén cổ bi đũa RGV
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CHÉN CỔ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CHÉN CỔ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-chen-co-bi-dua-rgv', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_52.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_52_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_52_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 52-WAVE/DREAM', N'Wave/Dream', 848124.0, 678499.2, 39, N'https://malossistore.vn/img/p/product_52.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 52-EXCITER/WINNER', N'Exciter/Winner', 837757.0, 670205.6, 43, N'https://malossistore.vn/img/p/product_52.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 52-VARIO/VISION', N'Vario/Vision', 843767.0, 675013.6, 19, N'https://malossistore.vn/img/p/product_52.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ chén cổ bi đũa RGV
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CHÉN CỔ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CHÉN CỔ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-chen-co-bi-dua-rgv', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_53.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_53_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_53_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 53-WAVE/DREAM', N'Wave/Dream', 2899149.0, 2319319.2, 42, N'https://faito.com.vn/wp-content/uploads/product_53.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 53-EXCITER/WINNER', N'Exciter/Winner', 2922914.0, 2338331.2, 13, N'https://faito.com.vn/wp-content/uploads/product_53.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 53-VARIO/VISION', N'Vario/Vision', 2934635.0, 2347708.0, 43, N'https://faito.com.vn/wp-content/uploads/product_53.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ chén cổ bi đũa RGV
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CHÉN CỔ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CHÉN CỔ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-chen-co-bi-dua-rgv', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_54.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_54_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_54_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 54-WAVE/DREAM', N'Wave/Dream', 2066628.0, 1653302.4, 26, N'https://motobatt.com/image/cache/product_54.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 54-EXCITER/WINNER', N'Exciter/Winner', 2126931.0, 1701544.8, 10, N'https://motobatt.com/image/cache/product_54.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 54-VARIO/VISION', N'Vario/Vision', 2099457.0, 1679565.6, 10, N'https://motobatt.com/image/cache/product_54.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Bộ chén cổ bi đũa RGV
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'CHÉN CỔ')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'RGV')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'CHÉN CỔ'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'RGV'), N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'bo-chen-co-bi-dua-rgv', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_55.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_55_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_55_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 55-WAVE/DREAM', N'Wave/Dream', 1334330.0, 1067464.0, 26, N'https://motobatt.com/image/cache/product_55.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 55-EXCITER/WINNER', N'Exciter/Winner', 1312115.0, 1049692.0, 46, N'https://motobatt.com/image/cache/product_55.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'RGV-BỘ 55-VARIO/VISION', N'Vario/Vision', 1343976.0, 1075180.8, 30, N'https://motobatt.com/image/cache/product_55.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phụ kiện trang trí Kozi CNC
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phụ kiện trang trí Kozi CNC', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Phụ kiện trang trí Kozi CNC</h2><p>Phụ kiện trang trí Kozi CNC là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phu-kien-trang-tri-kozi-cnc', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_56_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_56_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ56-VÀNG', N'Vàng', 1729132.0, 1383305.6, 47, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ56-ĐỎ', N'Đỏ', 1709315.0, 1367452.0, 19, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ56-XANH', N'Xanh', 1706757.0, 1365405.6, 20, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ56-BẠC', N'Bạc', 1712276.0, 1369820.8, 7, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ56-ĐEN', N'Đen', 1711334.0, 1369067.2, 38, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phụ kiện trang trí YSS CNC
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'YSS')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'YSS', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phụ kiện trang trí YSS CNC', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'YSS'), N'<h2>Thông tin chi tiết Phụ kiện trang trí YSS CNC</h2><p>Phụ kiện trang trí YSS CNC là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phu-kien-trang-tri-yss-cnc', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_57.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_57_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_57_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHỤ57-VÀNG', N'Vàng', 1140703.0, 912562.4, 14, N'https://malossistore.vn/img/p/product_57.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHỤ57-ĐỎ', N'Đỏ', 1116622.0, 893297.6, 22, N'https://malossistore.vn/img/p/product_57.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHỤ57-XANH', N'Xanh', 1115227.0, 892181.6, 29, N'https://malossistore.vn/img/p/product_57.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHỤ57-BẠC', N'Bạc', 1120761.0, 896608.8, 6, N'https://malossistore.vn/img/p/product_57.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'YSS-PHỤ57-ĐEN', N'Đen', 1113056.0, 890444.8, 42, N'https://malossistore.vn/img/p/product_57.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phụ kiện trang trí Kozi CNC
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phụ kiện trang trí Kozi CNC', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Phụ kiện trang trí Kozi CNC</h2><p>Phụ kiện trang trí Kozi CNC là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phu-kien-trang-tri-kozi-cnc', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_58.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_58_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_58_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ58-VÀNG', N'Vàng', 784265.0, 627412.0, 24, N'https://malossistore.vn/img/p/product_58.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ58-ĐỎ', N'Đỏ', 824249.0, 659399.2, 26, N'https://malossistore.vn/img/p/product_58.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ58-XANH', N'Xanh', 795326.0, 636260.8, 23, N'https://malossistore.vn/img/p/product_58.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ58-BẠC', N'Bạc', 803812.0, 643049.6, 45, N'https://malossistore.vn/img/p/product_58.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ58-ĐEN', N'Đen', 828002.0, 662401.6, 29, N'https://malossistore.vn/img/p/product_58.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phụ kiện trang trí Kozi CNC
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Kozi')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phụ kiện trang trí Kozi CNC', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Kozi'), N'<h2>Thông tin chi tiết Phụ kiện trang trí Kozi CNC</h2><p>Phụ kiện trang trí Kozi CNC là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phu-kien-trang-tri-kozi-cnc', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_59_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_59_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ59-VÀNG', N'Vàng', 2921264.0, 2337011.2, 33, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ59-ĐỎ', N'Đỏ', 2955324.0, 2364259.2, 6, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ59-XANH', N'Xanh', 2899272.0, 2319417.6, 40, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ59-BẠC', N'Bạc', 2944677.0, 2355741.6, 13, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'KOZ-PHỤ59-ĐEN', N'Đen', 2912029.0, 2329623.2, 21, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
END
BEGIN
-- Product: Phụ kiện trang trí Apido CNC
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC')
    INSERT INTO Categories (CategoryName, Slug, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 1);
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = N'Apido')
    INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/default.png');
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsFeatured, IsActive, CreatedDate)
VALUES (N'Phụ kiện trang trí Apido CNC', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'PHỤ KIỆN KHÁC'), (SELECT TOP 1 BrandId FROM Brands WHERE BrandName = N'Apido'), N'<h2>Thông tin chi tiết Phụ kiện trang trí Apido CNC</h2><p>Phụ kiện trang trí Apido CNC là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', 'phu-kien-trang-tri-apido-cnc', 0, 1, GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_60.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_60_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_60_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-PHỤ60-VÀNG', N'Vàng', 2875818.0, 2300654.4, 28, N'https://motobatt.com/image/cache/product_60.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-PHỤ60-ĐỎ', N'Đỏ', 2867667.0, 2294133.6, 9, N'https://motobatt.com/image/cache/product_60.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-PHỤ60-XANH', N'Xanh', 2865575.0, 2292460.0, 19, N'https://motobatt.com/image/cache/product_60.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-PHỤ60-BẠC', N'Bạc', 2863814.0, 2291051.2, 36, N'https://motobatt.com/image/cache/product_60.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, ImageUrl, CreatedDate)
VALUES (@Pid, N'API-PHỤ60-ĐEN', N'Đen', 2861227.0, 2288981.6, 40, N'https://motobatt.com/image/cache/product_60.jpg', GETDATE());
SET @Vid = SCOPE_IDENTITY();
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
IF NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = @Vid AND ValueId = @Valid) INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
END
COMMIT
GO
