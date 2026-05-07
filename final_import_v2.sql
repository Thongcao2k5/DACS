USE [MotorcycleShopDB]
GO
BEGIN TRANSACTION
GO
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Chiều dài') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Dung tích') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Kích thước') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Loại xe') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Màu sắc') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Phiên bản') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Thông số') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Thông số');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Vị trí') INSERT INTO ProductAttributes (AttributeName) VALUES (N'Vị trí');
GO
-- Product: Bộ nồi trước/sau Apido chuyên dụng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ nồi trước/sau Apido chuyên dụng', 460, 71, N'<h2>Thông tin chi tiết Bộ nồi trước/sau Apido chuyên dụng</h2><p>Bộ nồi trước/sau Apido chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_1.jpg', 1159000.0, 869250.0, 39, N'API-BỘ 1', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_1.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_1_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_1_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 1-9G', N'9g', 892240.0, 1159000.0, 39, N'https://motobatt.com/image/cache/product_1.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 1-11G', N'11g', 866265.0, 1159000.0, 45, N'https://motobatt.com/image/cache/product_1.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 1-13G', N'13g', 865246.0, 1159000.0, 23, N'https://motobatt.com/image/cache/product_1.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 1-15G', N'15g', 853893.0, 1159000.0, 38, N'https://motobatt.com/image/cache/product_1.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ nồi trước/sau Malossi chuyên dụng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ nồi trước/sau Malossi chuyên dụng', 460, 61, N'<h2>Thông tin chi tiết Bộ nồi trước/sau Malossi chuyên dụng</h2><p>Bộ nồi trước/sau Malossi chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_2.jpg', 4334000.0, 3423860.0, 78, N'MAL-BỘ 2', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_2.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_2_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_2_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-BỘ 2-9G', N'9g', 3460745.0, 4334000.0, 28, N'https://motobatt.com/image/cache/product_2.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-BỘ 2-11G', N'11g', 3430827.0, 4334000.0, 46, N'https://motobatt.com/image/cache/product_2.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-BỘ 2-13G', N'13g', 3404305.0, 4334000.0, 10, N'https://motobatt.com/image/cache/product_2.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-BỘ 2-15G', N'15g', 3452128.0, 4334000.0, 5, N'https://motobatt.com/image/cache/product_2.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ nồi trước/sau Apido chuyên dụng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ nồi trước/sau Apido chuyên dụng', 460, 71, N'<h2>Thông tin chi tiết Bộ nồi trước/sau Apido chuyên dụng</h2><p>Bộ nồi trước/sau Apido chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_3.jpg', 742000.0, 556500.0, 24, N'API-BỘ 3', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_3.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_3_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_3_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 3-9G', N'9g', 549951.0, 742000.0, 40, N'https://malossistore.vn/img/p/product_3.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 3-11G', N'11g', 538415.0, 742000.0, 15, N'https://malossistore.vn/img/p/product_3.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 3-13G', N'13g', 562984.0, 742000.0, 36, N'https://malossistore.vn/img/p/product_3.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 3-15G', N'15g', 538867.0, 742000.0, 43, N'https://malossistore.vn/img/p/product_3.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ nồi trước/sau Faito chuyên dụng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ nồi trước/sau Faito chuyên dụng', 460, 69, N'<h2>Thông tin chi tiết Bộ nồi trước/sau Faito chuyên dụng</h2><p>Bộ nồi trước/sau Faito chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_4.jpg', 4294000.0, 3263440.0, 52, N'FAI-BỘ 4', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_4.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_4_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_4_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỘ 4-9G', N'9g', 3278868.0, 4294000.0, 31, N'https://malossistore.vn/img/p/product_4.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỘ 4-11G', N'11g', 3289595.0, 4294000.0, 30, N'https://malossistore.vn/img/p/product_4.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỘ 4-13G', N'13g', 3286621.0, 4294000.0, 32, N'https://malossistore.vn/img/p/product_4.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỘ 4-15G', N'15g', 3244142.0, 4294000.0, 12, N'https://malossistore.vn/img/p/product_4.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ nồi trước/sau Apido chuyên dụng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ nồi trước/sau Apido chuyên dụng', 460, 71, N'<h2>Thông tin chi tiết Bộ nồi trước/sau Apido chuyên dụng</h2><p>Bộ nồi trước/sau Apido chuyên dụng là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_5.jpg', 3998000.0, 3398300.0, 79, N'API-BỘ 5', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_5.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_5_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_5_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 5-9G', N'9g', 3410548.0, 3998000.0, 16, N'https://malossistore.vn/img/p/product_5.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 5-11G', N'11g', 3428149.0, 3998000.0, 22, N'https://malossistore.vn/img/p/product_5.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'11g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'11g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 5-13G', N'13g', 3380705.0, 3998000.0, 18, N'https://malossistore.vn/img/p/product_5.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'13g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'13g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 5-15G', N'15g', 3444792.0, 3998000.0, 29, N'https://malossistore.vn/img/p/product_5.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'15g');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'15g');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ Nhông Sên Dĩa MTX High Performance
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa MTX High Performance', 463, 60, N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa MTX High Performance</h2><p>Bộ Nhông Sên Dĩa MTX High Performance là dòng sản phẩm cao cấp từ thương hiệu MTX, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_6.jpg', 2640000.0, 2323200.0, 33, N'MTX-BỘ 6', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_6.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_6_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_6_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 6-42T', N'42T', 2317278.0, 2640000.0, 10, N'https://motobatt.com/image/cache/product_6.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 6-43T', N'43T', 2353675.0, 2640000.0, 38, N'https://motobatt.com/image/cache/product_6.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 6-44T', N'44T', 2357933.0, 2640000.0, 13, N'https://motobatt.com/image/cache/product_6.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 6-45T', N'45T', 2303259.0, 2640000.0, 21, N'https://motobatt.com/image/cache/product_6.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ Nhông Sên Dĩa Apido High Performance
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa Apido High Performance', 463, 71, N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa Apido High Performance</h2><p>Bộ Nhông Sên Dĩa Apido High Performance là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_7.jpg', 2736000.0, 2435040.0, 26, N'API-BỘ 7', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_7.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_7_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_7_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 7-42T', N'42T', 2432712.0, 2736000.0, 36, N'https://faito.com.vn/wp-content/uploads/product_7.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 7-43T', N'43T', 2440060.0, 2736000.0, 40, N'https://faito.com.vn/wp-content/uploads/product_7.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 7-44T', N'44T', 2446309.0, 2736000.0, 15, N'https://faito.com.vn/wp-content/uploads/product_7.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 7-45T', N'45T', 2479546.0, 2736000.0, 7, N'https://faito.com.vn/wp-content/uploads/product_7.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ Nhông Sên Dĩa MTX High Performance
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa MTX High Performance', 463, 60, N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa MTX High Performance</h2><p>Bộ Nhông Sên Dĩa MTX High Performance là dòng sản phẩm cao cấp từ thương hiệu MTX, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_8.jpg', 4187000.0, 3307730.0, 50, N'MTX-BỘ 8', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_8.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_8_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_8_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 8-42T', N'42T', 3340788.0, 4187000.0, 16, N'https://faito.com.vn/wp-content/uploads/product_8.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 8-43T', N'43T', 3308247.0, 4187000.0, 21, N'https://faito.com.vn/wp-content/uploads/product_8.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 8-44T', N'44T', 3347435.0, 4187000.0, 47, N'https://faito.com.vn/wp-content/uploads/product_8.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỘ 8-45T', N'45T', 3301008.0, 4187000.0, 49, N'https://faito.com.vn/wp-content/uploads/product_8.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ Nhông Sên Dĩa RGV High Performance
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa RGV High Performance', 463, 70, N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa RGV High Performance</h2><p>Bộ Nhông Sên Dĩa RGV High Performance là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_9.jpg', 4196000.0, 3482680.0, 30, N'RGV-BỘ 9', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_9.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_9_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_9_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 9-42T', N'42T', 3467765.0, 4196000.0, 29, N'https://malossistore.vn/img/p/product_9.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 9-43T', N'43T', 3517586.0, 4196000.0, 43, N'https://malossistore.vn/img/p/product_9.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 9-44T', N'44T', 3482682.0, 4196000.0, 38, N'https://malossistore.vn/img/p/product_9.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 9-45T', N'45T', 3506895.0, 4196000.0, 34, N'https://malossistore.vn/img/p/product_9.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ Nhông Sên Dĩa Apido High Performance
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ Nhông Sên Dĩa Apido High Performance', 463, 71, N'<h2>Thông tin chi tiết Bộ Nhông Sên Dĩa Apido High Performance</h2><p>Bộ Nhông Sên Dĩa Apido High Performance là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_10.jpg', 3477000.0, 2607750.0, 42, N'API-BỘ 10', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_10.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_10_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_10_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 10-42T', N'42T', 2609870.0, 3477000.0, 8, N'https://malossistore.vn/img/p/product_10.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'42T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'42T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 10-43T', N'43T', 2644133.0, 3477000.0, 8, N'https://malossistore.vn/img/p/product_10.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'43T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'43T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 10-44T', N'44T', 2629255.0, 3477000.0, 43, N'https://malossistore.vn/img/p/product_10.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'44T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'44T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỘ 10-45T', N'45T', 2649962.0, 3477000.0, 29, N'https://malossistore.vn/img/p/product_10.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'45T');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'45T');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Căm xe máy Yaguso mạ Crom/Vàng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Căm xe máy Yaguso mạ Crom/Vàng', 467, 64, N'<h2>Thông tin chi tiết Căm xe máy Yaguso mạ Crom/Vàng</h2><p>Căm xe máy Yaguso mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu Yaguso, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_11.jpg', 2923000.0, 2279940.0, 14, N'YAG-CĂM11', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_11.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_11_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_11_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM11-9X157', N'9x157', 2310902.0, 2923000.0, 20, N'https://faito.com.vn/wp-content/uploads/product_11.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM11-9X184', N'9x184', 2261730.0, 2923000.0, 44, N'https://faito.com.vn/wp-content/uploads/product_11.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM11-10X157', N'10x157', 2305170.0, 2923000.0, 34, N'https://faito.com.vn/wp-content/uploads/product_11.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM11-10X184', N'10x184', 2287038.0, 2923000.0, 42, N'https://faito.com.vn/wp-content/uploads/product_11.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Căm xe máy Yaguso mạ Crom/Vàng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Căm xe máy Yaguso mạ Crom/Vàng', 467, 64, N'<h2>Thông tin chi tiết Căm xe máy Yaguso mạ Crom/Vàng</h2><p>Căm xe máy Yaguso mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu Yaguso, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_12.jpg', 1285000.0, 1130800.0, 22, N'YAG-CĂM12', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_12.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_12_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_12_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM12-9X157', N'9x157', 1124990.0, 1285000.0, 13, N'https://malossistore.vn/img/p/product_12.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM12-9X184', N'9x184', 1172151.0, 1285000.0, 21, N'https://malossistore.vn/img/p/product_12.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM12-10X157', N'10x157', 1124440.0, 1285000.0, 28, N'https://malossistore.vn/img/p/product_12.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YAG-CĂM12-10X184', N'10x184', 1159148.0, 1285000.0, 39, N'https://malossistore.vn/img/p/product_12.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Căm xe máy RGV mạ Crom/Vàng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Căm xe máy RGV mạ Crom/Vàng', 467, 70, N'<h2>Thông tin chi tiết Căm xe máy RGV mạ Crom/Vàng</h2><p>Căm xe máy RGV mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_13.jpg', 403000.0, 326430.0, 42, N'RGV-CĂM13', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_13.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_13_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_13_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM13-9X157', N'9x157', 370909.0, 403000.0, 29, N'https://faito.com.vn/wp-content/uploads/product_13.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM13-9X184', N'9x184', 355895.0, 403000.0, 38, N'https://faito.com.vn/wp-content/uploads/product_13.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM13-10X157', N'10x157', 375026.0, 403000.0, 36, N'https://faito.com.vn/wp-content/uploads/product_13.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM13-10X184', N'10x184', 361408.0, 403000.0, 29, N'https://faito.com.vn/wp-content/uploads/product_13.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Căm xe máy RGV mạ Crom/Vàng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Căm xe máy RGV mạ Crom/Vàng', 467, 70, N'<h2>Thông tin chi tiết Căm xe máy RGV mạ Crom/Vàng</h2><p>Căm xe máy RGV mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_14.jpg', 3468000.0, 2601000.0, 14, N'RGV-CĂM14', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_14.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_14_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_14_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM14-9X157', N'9x157', 2643308.0, 3468000.0, 8, N'https://motobatt.com/image/cache/product_14.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM14-9X184', N'9x184', 2635929.0, 3468000.0, 41, N'https://motobatt.com/image/cache/product_14.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM14-10X157', N'10x157', 2593379.0, 3468000.0, 36, N'https://motobatt.com/image/cache/product_14.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-CĂM14-10X184', N'10x184', 2609512.0, 3468000.0, 18, N'https://motobatt.com/image/cache/product_14.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Căm xe máy Tan Lan mạ Crom/Vàng
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Căm xe máy Tan Lan mạ Crom/Vàng', 467, 66, N'<h2>Thông tin chi tiết Căm xe máy Tan Lan mạ Crom/Vàng</h2><p>Căm xe máy Tan Lan mạ Crom/Vàng là dòng sản phẩm cao cấp từ thương hiệu Tan Lan, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_15.jpg', 1137000.0, 920970.0, 74, N'TAN-CĂM15', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_15.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_15_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_15_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TAN-CĂM15-9X157', N'9x157', 969869.0, 1137000.0, 18, N'https://malossistore.vn/img/p/product_15.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TAN-CĂM15-9X184', N'9x184', 907867.0, 1137000.0, 27, N'https://malossistore.vn/img/p/product_15.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TAN-CĂM15-10X157', N'10x157', 925360.0, 1137000.0, 29, N'https://malossistore.vn/img/p/product_15.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x157');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x157');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TAN-CĂM15-10X184', N'10x184', 944682.0, 1137000.0, 10, N'https://malossistore.vn/img/p/product_15.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'10x184');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'10x184');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bình ắc quy Gel Senarc siêu bền
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bình ắc quy Gel Senarc siêu bền', 472, 63, N'<h2>Thông tin chi tiết Bình ắc quy Gel Senarc siêu bền</h2><p>Bình ắc quy Gel Senarc siêu bền là dòng sản phẩm cao cấp từ thương hiệu Senarc, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_16.jpg', 2140000.0, 1819000.0, 12, N'SEN-BÌN16', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_16.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_16_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_16_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN16-5AH', N'5Ah', 1838098.0, 2140000.0, 42, N'https://faito.com.vn/wp-content/uploads/product_16.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN16-6AH', N'6Ah', 1831553.0, 2140000.0, 11, N'https://faito.com.vn/wp-content/uploads/product_16.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN16-7AH', N'7Ah', 1806637.0, 2140000.0, 42, N'https://faito.com.vn/wp-content/uploads/product_16.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN16-9AH', N'9Ah', 1814150.0, 2140000.0, 13, N'https://faito.com.vn/wp-content/uploads/product_16.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bình ắc quy Gel Motobatt siêu bền
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bình ắc quy Gel Motobatt siêu bền', 472, 62, N'<h2>Thông tin chi tiết Bình ắc quy Gel Motobatt siêu bền</h2><p>Bình ắc quy Gel Motobatt siêu bền là dòng sản phẩm cao cấp từ thương hiệu Motobatt, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_17.jpg', 323000.0, 248710.0, 37, N'MOT-BÌN17', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_17.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_17_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_17_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN17-5AH', N'5Ah', 285893.0, 323000.0, 11, N'https://motobatt.com/image/cache/product_17.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN17-6AH', N'6Ah', 238534.0, 323000.0, 35, N'https://motobatt.com/image/cache/product_17.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN17-7AH', N'7Ah', 273487.0, 323000.0, 22, N'https://motobatt.com/image/cache/product_17.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN17-9AH', N'9Ah', 229809.0, 323000.0, 40, N'https://motobatt.com/image/cache/product_17.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bình ắc quy Gel Motobatt siêu bền
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bình ắc quy Gel Motobatt siêu bền', 472, 62, N'<h2>Thông tin chi tiết Bình ắc quy Gel Motobatt siêu bền</h2><p>Bình ắc quy Gel Motobatt siêu bền là dòng sản phẩm cao cấp từ thương hiệu Motobatt, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_18.jpg', 3585000.0, 3118950.0, 77, N'MOT-BÌN18', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_18.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_18_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_18_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN18-5AH', N'5Ah', 3149957.0, 3585000.0, 5, N'https://malossistore.vn/img/p/product_18.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN18-6AH', N'6Ah', 3123614.0, 3585000.0, 44, N'https://malossistore.vn/img/p/product_18.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN18-7AH', N'7Ah', 3144781.0, 3585000.0, 23, N'https://malossistore.vn/img/p/product_18.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN18-9AH', N'9Ah', 3105182.0, 3585000.0, 35, N'https://malossistore.vn/img/p/product_18.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bình ắc quy Gel Motobatt siêu bền
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bình ắc quy Gel Motobatt siêu bền', 472, 62, N'<h2>Thông tin chi tiết Bình ắc quy Gel Motobatt siêu bền</h2><p>Bình ắc quy Gel Motobatt siêu bền là dòng sản phẩm cao cấp từ thương hiệu Motobatt, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_19.jpg', 3303000.0, 2807550.0, 85, N'MOT-BÌN19', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_19.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_19_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_19_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN19-5AH', N'5Ah', 2796910.0, 3303000.0, 7, N'https://faito.com.vn/wp-content/uploads/product_19.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN19-6AH', N'6Ah', 2798786.0, 3303000.0, 28, N'https://faito.com.vn/wp-content/uploads/product_19.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN19-7AH', N'7Ah', 2792358.0, 3303000.0, 30, N'https://faito.com.vn/wp-content/uploads/product_19.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MOT-BÌN19-9AH', N'9Ah', 2807121.0, 3303000.0, 12, N'https://faito.com.vn/wp-content/uploads/product_19.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bình ắc quy Gel Senarc siêu bền
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bình ắc quy Gel Senarc siêu bền', 472, 63, N'<h2>Thông tin chi tiết Bình ắc quy Gel Senarc siêu bền</h2><p>Bình ắc quy Gel Senarc siêu bền là dòng sản phẩm cao cấp từ thương hiệu Senarc, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_20.jpg', 560000.0, 492800.0, 81, N'SEN-BÌN20', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_20.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_20_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_20_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN20-5AH', N'5Ah', 521969.0, 560000.0, 21, N'https://motobatt.com/image/cache/product_20.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'5Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'5Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN20-6AH', N'6Ah', 522126.0, 560000.0, 45, N'https://motobatt.com/image/cache/product_20.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'6Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'6Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN20-7AH', N'7Ah', 506932.0, 560000.0, 7, N'https://motobatt.com/image/cache/product_20.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'7Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'7Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'SEN-BÌN20-9AH', N'9Ah', 481247.0, 560000.0, 36, N'https://motobatt.com/image/cache/product_20.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung lượng');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'9Ah');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'9Ah');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Lọc gió độ Malossi tăng lưu lượng khí
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Lọc gió độ Malossi tăng lưu lượng khí', 477, 61, N'<h2>Thông tin chi tiết Lọc gió độ Malossi tăng lưu lượng khí</h2><p>Lọc gió độ Malossi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_21.jpg', 1568000.0, 1411200.0, 99, N'MAL-LỌC21', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_21.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_21_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_21_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC21-VARIO/CLICK', N'Vario/Click', 1419303.0, 1568000.0, 36, N'https://faito.com.vn/wp-content/uploads/product_21.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC21-AIRBLADE', N'Airblade', 1433298.0, 1568000.0, 38, N'https://faito.com.vn/wp-content/uploads/product_21.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC21-SHVN', N'SHVN', 1395042.0, 1568000.0, 17, N'https://faito.com.vn/wp-content/uploads/product_21.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC21-EXCITER', N'Exciter', 1444187.0, 1568000.0, 5, N'https://faito.com.vn/wp-content/uploads/product_21.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Lọc gió độ Kozi tăng lưu lượng khí
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Lọc gió độ Kozi tăng lưu lượng khí', 477, 76, N'<h2>Thông tin chi tiết Lọc gió độ Kozi tăng lưu lượng khí</h2><p>Lọc gió độ Kozi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_22.jpg', 3403000.0, 2552250.0, 23, N'KOZ-LỌC22', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_22.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_22_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_22_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC22-VARIO/CLICK', N'Vario/Click', 2558248.0, 3403000.0, 31, N'https://faito.com.vn/wp-content/uploads/product_22.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC22-AIRBLADE', N'Airblade', 2584468.0, 3403000.0, 38, N'https://faito.com.vn/wp-content/uploads/product_22.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC22-SHVN', N'SHVN', 2556747.0, 3403000.0, 37, N'https://faito.com.vn/wp-content/uploads/product_22.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC22-EXCITER', N'Exciter', 2549737.0, 3403000.0, 42, N'https://faito.com.vn/wp-content/uploads/product_22.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Lọc gió độ Kozi tăng lưu lượng khí
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Lọc gió độ Kozi tăng lưu lượng khí', 477, 76, N'<h2>Thông tin chi tiết Lọc gió độ Kozi tăng lưu lượng khí</h2><p>Lọc gió độ Kozi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_23.jpg', 2332000.0, 2005520.0, 21, N'KOZ-LỌC23', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_23.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_23_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_23_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC23-VARIO/CLICK', N'Vario/Click', 1987686.0, 2332000.0, 11, N'https://malossistore.vn/img/p/product_23.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC23-AIRBLADE', N'Airblade', 2021748.0, 2332000.0, 49, N'https://malossistore.vn/img/p/product_23.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC23-SHVN', N'SHVN', 2010896.0, 2332000.0, 27, N'https://malossistore.vn/img/p/product_23.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-LỌC23-EXCITER', N'Exciter', 2014328.0, 2332000.0, 45, N'https://malossistore.vn/img/p/product_23.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Lọc gió độ Faito tăng lưu lượng khí
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Lọc gió độ Faito tăng lưu lượng khí', 477, 69, N'<h2>Thông tin chi tiết Lọc gió độ Faito tăng lưu lượng khí</h2><p>Lọc gió độ Faito tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_24.jpg', 3245000.0, 2790700.0, 34, N'FAI-LỌC24', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_24.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_24_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_24_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-LỌC24-VARIO/CLICK', N'Vario/Click', 2824641.0, 3245000.0, 47, N'https://faito.com.vn/wp-content/uploads/product_24.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-LỌC24-AIRBLADE', N'Airblade', 2824311.0, 3245000.0, 21, N'https://faito.com.vn/wp-content/uploads/product_24.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-LỌC24-SHVN', N'SHVN', 2775898.0, 3245000.0, 33, N'https://faito.com.vn/wp-content/uploads/product_24.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-LỌC24-EXCITER', N'Exciter', 2834163.0, 3245000.0, 39, N'https://faito.com.vn/wp-content/uploads/product_24.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Lọc gió độ Malossi tăng lưu lượng khí
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Lọc gió độ Malossi tăng lưu lượng khí', 477, 61, N'<h2>Thông tin chi tiết Lọc gió độ Malossi tăng lưu lượng khí</h2><p>Lọc gió độ Malossi tăng lưu lượng khí là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_25.jpg', 4141000.0, 3602670.0, 47, N'MAL-LỌC25', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_25.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_25_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_25_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC25-VARIO/CLICK', N'Vario/Click', 3589950.0, 4141000.0, 5, N'https://motobatt.com/image/cache/product_25.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Click');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Click');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC25-AIRBLADE', N'Airblade', 3584563.0, 4141000.0, 29, N'https://motobatt.com/image/cache/product_25.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Airblade');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Airblade');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC25-SHVN', N'SHVN', 3628524.0, 4141000.0, 47, N'https://motobatt.com/image/cache/product_25.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Thông số');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'SHVN');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'SHVN');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-LỌC25-EXCITER', N'Exciter', 3595456.0, 4141000.0, 33, N'https://motobatt.com/image/cache/product_25.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Nhớt tổng hợp RGV Racing
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Nhớt tổng hợp RGV Racing', 480, 70, N'<h2>Thông tin chi tiết Nhớt tổng hợp RGV Racing</h2><p>Nhớt tổng hợp RGV Racing là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_26.jpg', 2338000.0, 2080820.0, 32, N'RGV-NHỚ26', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_26.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_26_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_26_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ26-0.8L', N'0.8L', 2079648.0, 2338000.0, 22, N'https://faito.com.vn/wp-content/uploads/product_26.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ26-1L', N'1L', 2130502.0, 2338000.0, 11, N'https://faito.com.vn/wp-content/uploads/product_26.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ26-1.1L', N'1.1L', 2086268.0, 2338000.0, 46, N'https://faito.com.vn/wp-content/uploads/product_26.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ26-1.2L', N'1.2L', 2108210.0, 2338000.0, 9, N'https://faito.com.vn/wp-content/uploads/product_26.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Nhớt tổng hợp Faito Racing
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Nhớt tổng hợp Faito Racing', 480, 69, N'<h2>Thông tin chi tiết Nhớt tổng hợp Faito Racing</h2><p>Nhớt tổng hợp Faito Racing là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_27.jpg', 1135000.0, 942050.0, 80, N'FAI-NHỚ27', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_27.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_27_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_27_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-NHỚ27-0.8L', N'0.8L', 980195.0, 1135000.0, 13, N'https://malossistore.vn/img/p/product_27.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-NHỚ27-1L', N'1L', 938313.0, 1135000.0, 10, N'https://malossistore.vn/img/p/product_27.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-NHỚ27-1.1L', N'1.1L', 987856.0, 1135000.0, 14, N'https://malossistore.vn/img/p/product_27.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-NHỚ27-1.2L', N'1.2L', 925097.0, 1135000.0, 49, N'https://malossistore.vn/img/p/product_27.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Nhớt tổng hợp Malossi Racing
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Nhớt tổng hợp Malossi Racing', 480, 61, N'<h2>Thông tin chi tiết Nhớt tổng hợp Malossi Racing</h2><p>Nhớt tổng hợp Malossi Racing là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_28.jpg', 2858000.0, 2515040.0, 49, N'MAL-NHỚ28', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_28.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_28_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_28_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-NHỚ28-0.8L', N'0.8L', 2563685.0, 2858000.0, 21, N'https://motobatt.com/image/cache/product_28.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-NHỚ28-1L', N'1L', 2520995.0, 2858000.0, 35, N'https://motobatt.com/image/cache/product_28.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-NHỚ28-1.1L', N'1.1L', 2511556.0, 2858000.0, 29, N'https://motobatt.com/image/cache/product_28.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-NHỚ28-1.2L', N'1.2L', 2498424.0, 2858000.0, 20, N'https://motobatt.com/image/cache/product_28.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Nhớt tổng hợp RGV Racing
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Nhớt tổng hợp RGV Racing', 480, 70, N'<h2>Thông tin chi tiết Nhớt tổng hợp RGV Racing</h2><p>Nhớt tổng hợp RGV Racing là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_29.jpg', 4316000.0, 3711760.0, 10, N'RGV-NHỚ29', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_29.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_29_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_29_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ29-0.8L', N'0.8L', 3742941.0, 4316000.0, 7, N'https://malossistore.vn/img/p/product_29.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ29-1L', N'1L', 3703397.0, 4316000.0, 46, N'https://malossistore.vn/img/p/product_29.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ29-1.1L', N'1.1L', 3760405.0, 4316000.0, 34, N'https://malossistore.vn/img/p/product_29.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ29-1.2L', N'1.2L', 3756105.0, 4316000.0, 25, N'https://malossistore.vn/img/p/product_29.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Nhớt tổng hợp RGV Racing
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Nhớt tổng hợp RGV Racing', 480, 70, N'<h2>Thông tin chi tiết Nhớt tổng hợp RGV Racing</h2><p>Nhớt tổng hợp RGV Racing là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_30.jpg', 235000.0, 180950.0, 69, N'RGV-NHỚ30', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_30.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_30_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_30_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ30-0.8L', N'0.8L', 224110.0, 235000.0, 40, N'https://faito.com.vn/wp-content/uploads/product_30.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'0.8L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'0.8L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ30-1L', N'1L', 218381.0, 235000.0, 5, N'https://faito.com.vn/wp-content/uploads/product_30.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ30-1.1L', N'1.1L', 162589.0, 235000.0, 27, N'https://faito.com.vn/wp-content/uploads/product_30.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.1L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.1L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-NHỚ30-1.2L', N'1.2L', 230587.0, 235000.0, 6, N'https://faito.com.vn/wp-content/uploads/product_30.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Dung tích');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'1.2L');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'1.2L');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bố thắng Ceramic Apido chịu nhiệt
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bố thắng Ceramic Apido chịu nhiệt', 482, 71, N'<h2>Thông tin chi tiết Bố thắng Ceramic Apido chịu nhiệt</h2><p>Bố thắng Ceramic Apido chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_31.jpg', 3283000.0, 2790550.0, 59, N'API-BỐ 31', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_31.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_31_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_31_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỐ 31-TRƯỚC(FRONT)', N'Trước (Front)', 2780647.0, 3283000.0, 37, N'https://malossistore.vn/img/p/product_31.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỐ 31-SAU(REAR)', N'Sau (Rear)', 2813067.0, 3283000.0, 31, N'https://malossistore.vn/img/p/product_31.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-BỐ 31-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 2792860.0, 3283000.0, 28, N'https://malossistore.vn/img/p/product_31.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bố thắng Ceramic RGV chịu nhiệt
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bố thắng Ceramic RGV chịu nhiệt', 482, 70, N'<h2>Thông tin chi tiết Bố thắng Ceramic RGV chịu nhiệt</h2><p>Bố thắng Ceramic RGV chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_32.jpg', 737000.0, 574860.0, 68, N'RGV-BỐ 32', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_32.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_32_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_32_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỐ 32-TRƯỚC(FRONT)', N'Trước (Front)', 609553.0, 737000.0, 30, N'https://motobatt.com/image/cache/product_32.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỐ 32-SAU(REAR)', N'Sau (Rear)', 591167.0, 737000.0, 48, N'https://motobatt.com/image/cache/product_32.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỐ 32-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 563929.0, 737000.0, 46, N'https://motobatt.com/image/cache/product_32.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bố thắng Ceramic Faito chịu nhiệt
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bố thắng Ceramic Faito chịu nhiệt', 482, 69, N'<h2>Thông tin chi tiết Bố thắng Ceramic Faito chịu nhiệt</h2><p>Bố thắng Ceramic Faito chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_33.jpg', 772000.0, 609880.0, 94, N'FAI-BỐ 33', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_33.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_33_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_33_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỐ 33-TRƯỚC(FRONT)', N'Trước (Front)', 635551.0, 772000.0, 22, N'https://faito.com.vn/wp-content/uploads/product_33.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỐ 33-SAU(REAR)', N'Sau (Rear)', 641384.0, 772000.0, 42, N'https://faito.com.vn/wp-content/uploads/product_33.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỐ 33-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 633845.0, 772000.0, 43, N'https://faito.com.vn/wp-content/uploads/product_33.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bố thắng Ceramic Faito chịu nhiệt
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bố thắng Ceramic Faito chịu nhiệt', 482, 69, N'<h2>Thông tin chi tiết Bố thắng Ceramic Faito chịu nhiệt</h2><p>Bố thắng Ceramic Faito chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu Faito, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_34.jpg', 1084000.0, 867200.0, 82, N'FAI-BỐ 34', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_34.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_34_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_34_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỐ 34-TRƯỚC(FRONT)', N'Trước (Front)', 898758.0, 1084000.0, 31, N'https://motobatt.com/image/cache/product_34.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỐ 34-SAU(REAR)', N'Sau (Rear)', 893160.0, 1084000.0, 5, N'https://motobatt.com/image/cache/product_34.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FAI-BỐ 34-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 871073.0, 1084000.0, 8, N'https://motobatt.com/image/cache/product_34.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bố thắng Ceramic MTX chịu nhiệt
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bố thắng Ceramic MTX chịu nhiệt', 482, 60, N'<h2>Thông tin chi tiết Bố thắng Ceramic MTX chịu nhiệt</h2><p>Bố thắng Ceramic MTX chịu nhiệt là dòng sản phẩm cao cấp từ thương hiệu MTX, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_35.jpg', 3269000.0, 2778650.0, 15, N'MTX-BỐ 35', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_35.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_35_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_35_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỐ 35-TRƯỚC(FRONT)', N'Trước (Front)', 2774922.0, 3269000.0, 30, N'https://malossistore.vn/img/p/product_35.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Trước (Front)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Trước (Front)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỐ 35-SAU(REAR)', N'Sau (Rear)', 2803530.0, 3269000.0, 42, N'https://malossistore.vn/img/p/product_35.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Sau (Rear)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Sau (Rear)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MTX-BỐ 35-CẢBỘ(FULLSET)', N'Cả bộ (Full Set)', 2769619.0, 3269000.0, 20, N'https://malossistore.vn/img/p/product_35.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Vị trí');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Cả bộ (Full Set)');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Cả bộ (Full Set)');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Vỏ xe không ruột TR Tiller bám đường
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Vỏ xe không ruột TR Tiller bám đường', 485, 74, N'<h2>Thông tin chi tiết Vỏ xe không ruột TR Tiller bám đường</h2><p>Vỏ xe không ruột TR Tiller bám đường là dòng sản phẩm cao cấp từ thương hiệu TR Tiller, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_36.jpg', 2909000.0, 2414470.0, 26, N'TR -VỎ 36', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_36.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_36_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_36_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 36-70/90-17', N'70/90-17', 2458032.0, 2909000.0, 35, N'https://malossistore.vn/img/p/product_36.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 36-80/90-17', N'80/90-17', 2445197.0, 2909000.0, 5, N'https://malossistore.vn/img/p/product_36.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 36-90/80-17', N'90/80-17', 2441132.0, 2909000.0, 15, N'https://malossistore.vn/img/p/product_36.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 36-100/80-17', N'100/80-17', 2421245.0, 2909000.0, 6, N'https://malossistore.vn/img/p/product_36.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Vỏ xe không ruột FKR bám đường
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Vỏ xe không ruột FKR bám đường', 485, 68, N'<h2>Thông tin chi tiết Vỏ xe không ruột FKR bám đường</h2><p>Vỏ xe không ruột FKR bám đường là dòng sản phẩm cao cấp từ thương hiệu FKR, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_37.jpg', 2653000.0, 2122400.0, 78, N'FKR-VỎ 37', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_37.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_37_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_37_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 37-70/90-17', N'70/90-17', 2153866.0, 2653000.0, 16, N'https://faito.com.vn/wp-content/uploads/product_37.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 37-80/90-17', N'80/90-17', 2119156.0, 2653000.0, 39, N'https://faito.com.vn/wp-content/uploads/product_37.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 37-90/80-17', N'90/80-17', 2155620.0, 2653000.0, 13, N'https://faito.com.vn/wp-content/uploads/product_37.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 37-100/80-17', N'100/80-17', 2111707.0, 2653000.0, 36, N'https://faito.com.vn/wp-content/uploads/product_37.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Vỏ xe không ruột FKR bám đường
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Vỏ xe không ruột FKR bám đường', 485, 68, N'<h2>Thông tin chi tiết Vỏ xe không ruột FKR bám đường</h2><p>Vỏ xe không ruột FKR bám đường là dòng sản phẩm cao cấp từ thương hiệu FKR, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_38.jpg', 286000.0, 251680.0, 17, N'FKR-VỎ 38', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_38.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_38_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_38_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 38-70/90-17', N'70/90-17', 267064.0, 286000.0, 18, N'https://faito.com.vn/wp-content/uploads/product_38.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 38-80/90-17', N'80/90-17', 261761.0, 286000.0, 25, N'https://faito.com.vn/wp-content/uploads/product_38.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 38-90/80-17', N'90/80-17', 232606.0, 286000.0, 15, N'https://faito.com.vn/wp-content/uploads/product_38.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'FKR-VỎ 38-100/80-17', N'100/80-17', 285954.0, 286000.0, 37, N'https://faito.com.vn/wp-content/uploads/product_38.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Vỏ xe không ruột TR Tiller bám đường
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Vỏ xe không ruột TR Tiller bám đường', 485, 74, N'<h2>Thông tin chi tiết Vỏ xe không ruột TR Tiller bám đường</h2><p>Vỏ xe không ruột TR Tiller bám đường là dòng sản phẩm cao cấp từ thương hiệu TR Tiller, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_39.jpg', 576000.0, 489600.0, 31, N'TR -VỎ 39', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_39.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_39_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_39_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 39-70/90-17', N'70/90-17', 485120.0, 576000.0, 38, N'https://faito.com.vn/wp-content/uploads/product_39.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 39-80/90-17', N'80/90-17', 525285.0, 576000.0, 26, N'https://faito.com.vn/wp-content/uploads/product_39.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 39-90/80-17', N'90/80-17', 481457.0, 576000.0, 9, N'https://faito.com.vn/wp-content/uploads/product_39.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 39-100/80-17', N'100/80-17', 528673.0, 576000.0, 41, N'https://faito.com.vn/wp-content/uploads/product_39.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Vỏ xe không ruột TR Tiller bám đường
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Vỏ xe không ruột TR Tiller bám đường', 485, 74, N'<h2>Thông tin chi tiết Vỏ xe không ruột TR Tiller bám đường</h2><p>Vỏ xe không ruột TR Tiller bám đường là dòng sản phẩm cao cấp từ thương hiệu TR Tiller, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_40.jpg', 1509000.0, 1312830.0, 32, N'TR -VỎ 40', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_40.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_40_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_40_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 40-70/90-17', N'70/90-17', 1320196.0, 1509000.0, 25, N'https://faito.com.vn/wp-content/uploads/product_40.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'70/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'70/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 40-80/90-17', N'80/90-17', 1353971.0, 1509000.0, 37, N'https://faito.com.vn/wp-content/uploads/product_40.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'80/90-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'80/90-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 40-90/80-17', N'90/80-17', 1299858.0, 1509000.0, 25, N'https://faito.com.vn/wp-content/uploads/product_40.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'90/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'90/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'TR -VỎ 40-100/80-17', N'100/80-17', 1293202.0, 1509000.0, 7, N'https://faito.com.vn/wp-content/uploads/product_40.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'100/80-17');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'100/80-17');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Dây ga/Dây côn Apido bọc Teflon
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Dây ga/Dây côn Apido bọc Teflon', 488, 71, N'<h2>Thông tin chi tiết Dây ga/Dây côn Apido bọc Teflon</h2><p>Dây ga/Dây côn Apido bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_41.jpg', 1457000.0, 1194740.0, 19, N'API-DÂY41', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_41.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_41_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_41_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-DÂY41-TIÊUCHUẨN', N'Tiêu chuẩn', 1211852.0, 1457000.0, 24, N'https://faito.com.vn/wp-content/uploads/product_41.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-DÂY41-DÀIHƠN5CM', N'Dài hơn 5cm', 1229355.0, 1457000.0, 6, N'https://faito.com.vn/wp-content/uploads/product_41.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-DÂY41-DÀIHƠN10CM', N'Dài hơn 10cm', 1205654.0, 1457000.0, 23, N'https://faito.com.vn/wp-content/uploads/product_41.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Dây ga/Dây côn Kozi bọc Teflon
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Dây ga/Dây côn Kozi bọc Teflon', 488, 76, N'<h2>Thông tin chi tiết Dây ga/Dây côn Kozi bọc Teflon</h2><p>Dây ga/Dây côn Kozi bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_42.jpg', 2943000.0, 2442690.0, 22, N'KOZ-DÂY42', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_42.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_42_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_42_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-DÂY42-TIÊUCHUẨN', N'Tiêu chuẩn', 2473261.0, 2943000.0, 22, N'https://malossistore.vn/img/p/product_42.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-DÂY42-DÀIHƠN5CM', N'Dài hơn 5cm', 2470064.0, 2943000.0, 33, N'https://malossistore.vn/img/p/product_42.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-DÂY42-DÀIHƠN10CM', N'Dài hơn 10cm', 2425532.0, 2943000.0, 7, N'https://malossistore.vn/img/p/product_42.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Dây ga/Dây côn Apido bọc Teflon
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Dây ga/Dây côn Apido bọc Teflon', 488, 71, N'<h2>Thông tin chi tiết Dây ga/Dây côn Apido bọc Teflon</h2><p>Dây ga/Dây côn Apido bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_43.jpg', 1567000.0, 1331950.0, 44, N'API-DÂY43', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_43.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_43_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_43_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-DÂY43-TIÊUCHUẨN', N'Tiêu chuẩn', 1368172.0, 1567000.0, 5, N'https://motobatt.com/image/cache/product_43.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-DÂY43-DÀIHƠN5CM', N'Dài hơn 5cm', 1339135.0, 1567000.0, 29, N'https://motobatt.com/image/cache/product_43.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-DÂY43-DÀIHƠN10CM', N'Dài hơn 10cm', 1329379.0, 1567000.0, 46, N'https://motobatt.com/image/cache/product_43.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Dây ga/Dây côn RGV bọc Teflon
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Dây ga/Dây côn RGV bọc Teflon', 488, 70, N'<h2>Thông tin chi tiết Dây ga/Dây côn RGV bọc Teflon</h2><p>Dây ga/Dây côn RGV bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_44.jpg', 210000.0, 182700.0, 30, N'RGV-DÂY44', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_44.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_44_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_44_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-DÂY44-TIÊUCHUẨN', N'Tiêu chuẩn', 163159.0, 210000.0, 31, N'https://motobatt.com/image/cache/product_44.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-DÂY44-DÀIHƠN5CM', N'Dài hơn 5cm', 168298.0, 210000.0, 29, N'https://motobatt.com/image/cache/product_44.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-DÂY44-DÀIHƠN10CM', N'Dài hơn 10cm', 172152.0, 210000.0, 36, N'https://motobatt.com/image/cache/product_44.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Dây ga/Dây côn Kozi bọc Teflon
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Dây ga/Dây côn Kozi bọc Teflon', 488, 76, N'<h2>Thông tin chi tiết Dây ga/Dây côn Kozi bọc Teflon</h2><p>Dây ga/Dây côn Kozi bọc Teflon là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_45.jpg', 2978000.0, 2322840.0, 46, N'KOZ-DÂY45', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_45.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_45_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_45_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-DÂY45-TIÊUCHUẨN', N'Tiêu chuẩn', 2332276.0, 2978000.0, 40, N'https://motobatt.com/image/cache/product_45.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Tiêu chuẩn');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Tiêu chuẩn');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-DÂY45-DÀIHƠN5CM', N'Dài hơn 5cm', 2349706.0, 2978000.0, 49, N'https://motobatt.com/image/cache/product_45.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 5cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 5cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-DÂY45-DÀIHƠN10CM', N'Dài hơn 10cm', 2357640.0, 2978000.0, 17, N'https://motobatt.com/image/cache/product_45.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Chiều dài');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Dài hơn 10cm');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Dài hơn 10cm');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phuộc/Pô YSS cho xe PKL
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phuộc/Pô YSS cho xe PKL', 494, 72, N'<h2>Thông tin chi tiết Phuộc/Pô YSS cho xe PKL</h2><p>Phuộc/Pô YSS cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_46.jpg', 2537000.0, 2257930.0, 38, N'YSS-PHU46', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_46.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_46_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_46_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU46-STANDARD', N'Standard', 2249495.0, 2537000.0, 33, N'https://malossistore.vn/img/p/product_46.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU46-RACING', N'Racing', 2250955.0, 2537000.0, 33, N'https://malossistore.vn/img/p/product_46.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU46-LIMITEDEDITION', N'Limited Edition', 2289148.0, 2537000.0, 25, N'https://malossistore.vn/img/p/product_46.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phuộc/Pô YSS cho xe PKL
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phuộc/Pô YSS cho xe PKL', 494, 72, N'<h2>Thông tin chi tiết Phuộc/Pô YSS cho xe PKL</h2><p>Phuộc/Pô YSS cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_47.jpg', 1059000.0, 931920.0, 74, N'YSS-PHU47', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_47.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_47_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_47_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU47-STANDARD', N'Standard', 943103.0, 1059000.0, 33, N'https://faito.com.vn/wp-content/uploads/product_47.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU47-RACING', N'Racing', 919967.0, 1059000.0, 40, N'https://faito.com.vn/wp-content/uploads/product_47.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU47-LIMITEDEDITION', N'Limited Edition', 963424.0, 1059000.0, 11, N'https://faito.com.vn/wp-content/uploads/product_47.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phuộc/Pô Malossi cho xe PKL
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phuộc/Pô Malossi cho xe PKL', 494, 61, N'<h2>Thông tin chi tiết Phuộc/Pô Malossi cho xe PKL</h2><p>Phuộc/Pô Malossi cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu Malossi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_48.jpg', 1056000.0, 792000.0, 19, N'MAL-PHU48', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_48.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_48_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_48_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-PHU48-STANDARD', N'Standard', 824568.0, 1056000.0, 20, N'https://motobatt.com/image/cache/product_48.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-PHU48-RACING', N'Racing', 790026.0, 1056000.0, 34, N'https://motobatt.com/image/cache/product_48.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'MAL-PHU48-LIMITEDEDITION', N'Limited Edition', 785290.0, 1056000.0, 43, N'https://motobatt.com/image/cache/product_48.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phuộc/Pô YSS cho xe PKL
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phuộc/Pô YSS cho xe PKL', 494, 72, N'<h2>Thông tin chi tiết Phuộc/Pô YSS cho xe PKL</h2><p>Phuộc/Pô YSS cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_49.jpg', 3368000.0, 2997520.0, 17, N'YSS-PHU49', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_49.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_49_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_49_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU49-STANDARD', N'Standard', 3019370.0, 3368000.0, 44, N'https://motobatt.com/image/cache/product_49.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU49-RACING', N'Racing', 3041673.0, 3368000.0, 16, N'https://motobatt.com/image/cache/product_49.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHU49-LIMITEDEDITION', N'Limited Edition', 2999036.0, 3368000.0, 40, N'https://motobatt.com/image/cache/product_49.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phuộc/Pô CRG cho xe PKL
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phuộc/Pô CRG cho xe PKL', 494, 65, N'<h2>Thông tin chi tiết Phuộc/Pô CRG cho xe PKL</h2><p>Phuộc/Pô CRG cho xe PKL là dòng sản phẩm cao cấp từ thương hiệu CRG, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_50.jpg', 2139000.0, 1625640.0, 11, N'CRG-PHU50', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_50.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_50_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_50_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'CRG-PHU50-STANDARD', N'Standard', 1628240.0, 2139000.0, 36, N'https://faito.com.vn/wp-content/uploads/product_50.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Standard');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Standard');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'CRG-PHU50-RACING', N'Racing', 1634723.0, 2139000.0, 31, N'https://faito.com.vn/wp-content/uploads/product_50.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Racing');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Racing');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'CRG-PHU50-LIMITEDEDITION', N'Limited Edition', 1659817.0, 2139000.0, 16, N'https://faito.com.vn/wp-content/uploads/product_50.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Phiên bản');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Limited Edition');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Limited Edition');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ chén cổ bi đũa Kozi
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa Kozi', 500, 76, N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa Kozi</h2><p>Bộ chén cổ bi đũa Kozi là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_51.jpg', 420000.0, 336000.0, 39, N'KOZ-BỘ 51', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_51.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_51_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_51_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-BỘ 51-WAVE/DREAM', N'Wave/Dream', 322029.0, 420000.0, 11, N'https://motobatt.com/image/cache/product_51.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-BỘ 51-EXCITER/WINNER', N'Exciter/Winner', 340677.0, 420000.0, 5, N'https://motobatt.com/image/cache/product_51.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-BỘ 51-VARIO/VISION', N'Vario/Vision', 381401.0, 420000.0, 17, N'https://motobatt.com/image/cache/product_51.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ chén cổ bi đũa RGV
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', 500, 70, N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_52.jpg', 1101000.0, 847770.0, 95, N'RGV-BỘ 52', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_52.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_52_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_52_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 52-WAVE/DREAM', N'Wave/Dream', 848124.0, 1101000.0, 39, N'https://malossistore.vn/img/p/product_52.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 52-EXCITER/WINNER', N'Exciter/Winner', 837757.0, 1101000.0, 43, N'https://malossistore.vn/img/p/product_52.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 52-VARIO/VISION', N'Vario/Vision', 843767.0, 1101000.0, 19, N'https://malossistore.vn/img/p/product_52.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ chén cổ bi đũa RGV
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', 500, 70, N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_53.jpg', 3809000.0, 2894840.0, 23, N'RGV-BỘ 53', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_53.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_53_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_53_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 53-WAVE/DREAM', N'Wave/Dream', 2899149.0, 3809000.0, 42, N'https://faito.com.vn/wp-content/uploads/product_53.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 53-EXCITER/WINNER', N'Exciter/Winner', 2922914.0, 3809000.0, 13, N'https://faito.com.vn/wp-content/uploads/product_53.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 53-VARIO/VISION', N'Vario/Vision', 2934635.0, 3809000.0, 43, N'https://faito.com.vn/wp-content/uploads/product_53.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ chén cổ bi đũa RGV
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', 500, 70, N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_54.jpg', 2663000.0, 2077140.0, 32, N'RGV-BỘ 54', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_54.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_54_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_54_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 54-WAVE/DREAM', N'Wave/Dream', 2066628.0, 2663000.0, 26, N'https://motobatt.com/image/cache/product_54.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 54-EXCITER/WINNER', N'Exciter/Winner', 2126931.0, 2663000.0, 10, N'https://motobatt.com/image/cache/product_54.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 54-VARIO/VISION', N'Vario/Vision', 2099457.0, 2663000.0, 10, N'https://motobatt.com/image/cache/product_54.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Bộ chén cổ bi đũa RGV
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Bộ chén cổ bi đũa RGV', 500, 70, N'<h2>Thông tin chi tiết Bộ chén cổ bi đũa RGV</h2><p>Bộ chén cổ bi đũa RGV là dòng sản phẩm cao cấp từ thương hiệu RGV, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_55.jpg', 1533000.0, 1303050.0, 10, N'RGV-BỘ 55', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_55.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_55_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_55_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 55-WAVE/DREAM', N'Wave/Dream', 1334330.0, 1533000.0, 26, N'https://motobatt.com/image/cache/product_55.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Wave/Dream');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Wave/Dream');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 55-EXCITER/WINNER', N'Exciter/Winner', 1312115.0, 1533000.0, 46, N'https://motobatt.com/image/cache/product_55.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Exciter/Winner');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Exciter/Winner');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'RGV-BỘ 55-VARIO/VISION', N'Vario/Vision', 1343976.0, 1533000.0, 30, N'https://motobatt.com/image/cache/product_55.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Loại xe');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vario/Vision');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vario/Vision');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phụ kiện trang trí Kozi CNC
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phụ kiện trang trí Kozi CNC', 501, 76, N'<h2>Thông tin chi tiết Phụ kiện trang trí Kozi CNC</h2><p>Phụ kiện trang trí Kozi CNC là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_56.jpg', 2261000.0, 1718360.0, 97, N'KOZ-PHỤ56', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_56.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_56_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_56_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ56-VÀNG', N'Vàng', 1729132.0, 2261000.0, 47, N'https://faito.com.vn/wp-content/uploads/product_56.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ56-ĐỎ', N'Đỏ', 1709315.0, 2261000.0, 19, N'https://faito.com.vn/wp-content/uploads/product_56.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ56-XANH', N'Xanh', 1706757.0, 2261000.0, 20, N'https://faito.com.vn/wp-content/uploads/product_56.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ56-BẠC', N'Bạc', 1712276.0, 2261000.0, 7, N'https://faito.com.vn/wp-content/uploads/product_56.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ56-ĐEN', N'Đen', 1711334.0, 2261000.0, 38, N'https://faito.com.vn/wp-content/uploads/product_56.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phụ kiện trang trí YSS CNC
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phụ kiện trang trí YSS CNC', 501, 72, N'<h2>Thông tin chi tiết Phụ kiện trang trí YSS CNC</h2><p>Phụ kiện trang trí YSS CNC là dòng sản phẩm cao cấp từ thương hiệu YSS, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_57.jpg', 1361000.0, 1102410.0, 29, N'YSS-PHỤ57', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_57.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_57_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_57_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHỤ57-VÀNG', N'Vàng', 1140703.0, 1361000.0, 14, N'https://malossistore.vn/img/p/product_57.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHỤ57-ĐỎ', N'Đỏ', 1116622.0, 1361000.0, 22, N'https://malossistore.vn/img/p/product_57.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHỤ57-XANH', N'Xanh', 1115227.0, 1361000.0, 29, N'https://malossistore.vn/img/p/product_57.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHỤ57-BẠC', N'Bạc', 1120761.0, 1361000.0, 6, N'https://malossistore.vn/img/p/product_57.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'YSS-PHỤ57-ĐEN', N'Đen', 1113056.0, 1361000.0, 42, N'https://malossistore.vn/img/p/product_57.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phụ kiện trang trí Kozi CNC
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phụ kiện trang trí Kozi CNC', 501, 76, N'<h2>Thông tin chi tiết Phụ kiện trang trí Kozi CNC</h2><p>Phụ kiện trang trí Kozi CNC là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://malossistore.vn/img/p/product_58.jpg', 974000.0, 779200.0, 59, N'KOZ-PHỤ58', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/product_58.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_58_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_58_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ58-VÀNG', N'Vàng', 784265.0, 974000.0, 24, N'https://malossistore.vn/img/p/product_58.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ58-ĐỎ', N'Đỏ', 824249.0, 974000.0, 26, N'https://malossistore.vn/img/p/product_58.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ58-XANH', N'Xanh', 795326.0, 974000.0, 23, N'https://malossistore.vn/img/p/product_58.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ58-BẠC', N'Bạc', 803812.0, 974000.0, 45, N'https://malossistore.vn/img/p/product_58.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ58-ĐEN', N'Đen', 828002.0, 974000.0, 29, N'https://malossistore.vn/img/p/product_58.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phụ kiện trang trí Kozi CNC
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phụ kiện trang trí Kozi CNC', 501, 76, N'<h2>Thông tin chi tiết Phụ kiện trang trí Kozi CNC</h2><p>Phụ kiện trang trí Kozi CNC là dòng sản phẩm cao cấp từ thương hiệu Kozi, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://faito.com.vn/wp-content/uploads/product_59.jpg', 3591000.0, 2908710.0, 13, N'KOZ-PHỤ59', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/product_59.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_59_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://faito.com.vn/wp-content/uploads/extra_59_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ59-VÀNG', N'Vàng', 2921264.0, 3591000.0, 33, N'https://faito.com.vn/wp-content/uploads/product_59.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ59-ĐỎ', N'Đỏ', 2955324.0, 3591000.0, 6, N'https://faito.com.vn/wp-content/uploads/product_59.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ59-XANH', N'Xanh', 2899272.0, 3591000.0, 40, N'https://faito.com.vn/wp-content/uploads/product_59.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ59-BẠC', N'Bạc', 2944677.0, 3591000.0, 13, N'https://faito.com.vn/wp-content/uploads/product_59.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'KOZ-PHỤ59-ĐEN', N'Đen', 2912029.0, 3591000.0, 21, N'https://faito.com.vn/wp-content/uploads/product_59.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
-- Product: Phụ kiện trang trí Apido CNC
DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)
VALUES (N'Phụ kiện trang trí Apido CNC', 501, 71, N'<h2>Thông tin chi tiết Phụ kiện trang trí Apido CNC</h2><p>Phụ kiện trang trí Apido CNC là dòng sản phẩm cao cấp từ thương hiệu Apido, được thiết kế để tối ưu hóa hiệu suất cho xe máy của bạn.</p><ul><li><strong>Đặc điểm nổi bật:</strong> Độ bền cực cao, khả năng chịu nhiệt tốt, thiết kế chuẩn xác.</li><li><strong>Thông số kỹ thuật:</strong> Chất liệu hợp kim cao cấp, đạt tiêu chuẩn ISO 9001.</li><li><strong>Hướng dẫn sử dụng:</strong> Lắp đặt trực tiếp như zin, không cần chế cháo.</li></ul><p>Sản phẩm được bảo hành chính hãng 6-12 tháng tùy dòng xe.</p>', N'https://motobatt.com/image/cache/product_60.jpg', 3481000.0, 2854420.0, 48, N'API-PHỤ60', GETDATE());
SET @Pid = SCOPE_IDENTITY();
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/product_60.jpg', 1, 0);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://malossistore.vn/img/p/extra_60_0.jpg', 0, 1);
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'https://motobatt.com/image/cache/extra_60_1.jpg', 0, 2);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-PHỤ60-VÀNG', N'Vàng', 2875818.0, 3481000.0, 28, N'https://motobatt.com/image/cache/product_60.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Vàng');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Vàng');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-PHỤ60-ĐỎ', N'Đỏ', 2867667.0, 3481000.0, 9, N'https://motobatt.com/image/cache/product_60.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đỏ');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đỏ');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-PHỤ60-XANH', N'Xanh', 2865575.0, 3481000.0, 19, N'https://motobatt.com/image/cache/product_60.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Kích thước');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Xanh');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Xanh');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-PHỤ60-BẠC', N'Bạc', 2863814.0, 3481000.0, 36, N'https://motobatt.com/image/cache/product_60.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Bạc');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Bạc');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)
VALUES (@Pid, N'API-PHỤ60-ĐEN', N'Đen', 2861227.0, 3481000.0, 40, N'https://motobatt.com/image/cache/product_60.jpg');
SET @Vid = SCOPE_IDENTITY();
SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Màu sắc');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'Đen');
SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'Đen');
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);
GO
COMMIT TRANSACTION
GO