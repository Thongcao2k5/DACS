$sql = @"
BEGIN TRANSACTION;
-- 1. Xóa sạch dữ liệu
DELETE FROM CartItems;
DELETE FROM OrderItems;
DELETE FROM ProductReviews;
DELETE FROM InventoryTransactions;
DELETE FROM ProductVariantAttributeValue;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
UPDATE Products SET CategoryId = NULL;
DELETE FROM Categories;
DELETE FROM Products;

-- 2. Nhập Danh mục
DECLARE @ParentId INT;
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 'bx-cycling', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi trước', 'bo-noi-truoc', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi sau', 'bo-noi-sau', @ParentId, 1);

-- 3. Nhập Sản phẩm Malossi
DECLARE @CatId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bộ nồi trước');
DECLARE @BrandId INT = (SELECT BrandId FROM Brands WHERE BrandName = N'Malossi');

INSERT INTO Products (ProductName, CategoryId, BrandId, Slug, Description, IsActive, IsFeatured, IsDeleted, CreatedDate)
VALUES (N'Bi nồi Vision 2011-2023 Malossi cao cấp (Full size)', @CatId, @BrandId, 'bi-noi-vision-malossi-full-size', N'Bi nồi Malossi cao cấp cho Honda Vision', 1, 0, 0, GETDATE());

DECLARE @ProductId INT = SCOPE_IDENTITY();

-- 4. Biến thể
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, SKU, StockQuantity, CreatedDate, CostPrice)
VALUES
(@ProductId, N'9 gram', 140000, 180000, 'MAL-VIS-09G', 50, GETDATE(), 100000),
(@ProductId, N'10 gram', 145000, 185000, 'MAL-VIS-10G', 45, GETDATE(), 105000),
(@ProductId, N'11 gram', 150000, 190000, 'MAL-VIS-11G', 40, GETDATE(), 110000);

-- 5. Thuộc tính
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng')
    INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
DECLARE @AttrId INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');

-- Nhập Value nếu chưa có
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @AttrId AND Value = N'9 gram') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@AttrId, N'9 gram');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @AttrId AND Value = N'10 gram') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@AttrId, N'10 gram');
IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @AttrId AND Value = N'11 gram') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@AttrId, N'11 gram');

INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId)
SELECT pv.ProductVariantId, av.ValueId
FROM ProductVariants pv
JOIN AttributeValues av ON pv.VariantName = av.Value
WHERE pv.ProductId = @ProductId AND av.AttributeId = @AttrId;

-- 6. Ảnh
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, '/assets/img/products/malossi-roller-main.jpg', 1, 0);

COMMIT;
"@
[IO.File]::WriteAllText("final_fix.sql", $sql, [System.Text.Encoding]::Unicode)
