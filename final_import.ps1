$server = "MSI\SQLEXPRESS"
$db = "MotorcycleShopDB"

$sql = @"
BEGIN TRANSACTION;
-- 1. Xóa sạch dữ liệu sản phẩm và liên quan
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

-- 2. Nhập Danh mục (Categories)
DECLARE @ParentId INT;

INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 'bx-cycling', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi trước', 'bo-noi-truoc', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi sau', 'bo-noi-sau', @ParentId, 1);

INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong-sen-dia', 'bx-loader-circle', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Sên', 'sen', @ParentId, 1);

-- 3. Nhập Sản phẩm Malossi
DECLARE @CatId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bộ nồi trước');
DECLARE @BrandId INT = (SELECT BrandId FROM Brands WHERE BrandName = N'Malossi');

INSERT INTO Products (ProductName, CategoryId, BrandId, Slug, Description, IsActive, IsFeatured, IsDeleted, CreatedDate)
VALUES (N'Bi nồi Vision 2011-2023 Malossi cao cấp (Full size)', @CatId, @BrandId, 'bi-noi-vision-malossi-full-size', N'Bi nồi Malossi cao cấp cho Honda Vision', 1, 0, 0, GETDATE());

DECLARE @ProductId INT = SCOPE_IDENTITY();

-- 4. Nhập Biến thể (Variants)
INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, SKU, StockQuantity, CreatedDate, CostPrice)
VALUES
(@ProductId, N'9 gram', 140000, 180000, 'MAL-VIS-09G', 50, GETDATE(), 100000),
(@ProductId, N'10 gram', 145000, 185000, 'MAL-VIS-10G', 45, GETDATE(), 105000),
(@ProductId, N'11 gram', 150000, 190000, 'MAL-VIS-11G', 40, GETDATE(), 110000),
(@ProductId, N'12 gram', 155000, 195000, 'MAL-VIS-12G', 35, GETDATE(), 115000),
(@ProductId, N'13 gram', 160000, 200000, 'MAL-VIS-13G', 30, GETDATE(), 120000),
(@ProductId, N'14 gram', 165000, 210000, 'MAL-VIS-14G', 25, GETDATE(), 125000);

-- 5. Nhập Thuộc tính (Attributes)
IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng')
    INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
DECLARE @AttrId INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');

-- Link Variant với Thuộc tính
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId)
SELECT pv.ProductVariantId, av.ValueId
FROM ProductVariants pv
CROSS JOIN (
    SELECT ValueId, Value FROM AttributeValues WHERE AttributeId = @AttrId
) av
WHERE pv.ProductId = @ProductId AND pv.VariantName = av.Value;

-- Nếu chưa có giá trị trong AttributeValues thì chèn mới (logic đơn giản hóa)
INSERT INTO AttributeValues (AttributeId, Value)
SELECT @AttrId, VariantName FROM ProductVariants 
WHERE ProductId = @ProductId 
AND VariantName NOT IN (SELECT Value FROM AttributeValues WHERE AttributeId = @AttrId);

-- Chạy lại link sau khi đã có đủ Value
INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId)
SELECT pv.ProductVariantId, av.ValueId
FROM ProductVariants pv
JOIN AttributeValues av ON pv.VariantName = av.Value
WHERE pv.ProductId = @ProductId AND av.AttributeId = @AttrId
AND NOT EXISTS (SELECT 1 FROM ProductVariantAttributeValue WHERE ProductVariantId = pv.ProductVariantId AND ValueId = av.ValueId);

-- 6. Nhập Ảnh
INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
VALUES (@ProductId, '/assets/img/products/malossi-roller-main.jpg', 1, 0);

COMMIT;
"@

Invoke-Sqlcmd -ServerInstance $server -Database $db -Query $sql
Write-Host "Xử lý hoàn tất!"
