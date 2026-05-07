$connectionString = "Server=MSI\SQLEXPRESS;Database=MotorcycleShopDB;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True"

# 1. Clear existing data
$clearSql = @"
BEGIN TRANSACTION;
UPDATE Products SET CategoryId = NULL;
DELETE FROM Categories;
DELETE FROM ProductVariantAttributeValue;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
DELETE FROM Products;
COMMIT;
"@
Invoke-Sqlcmd -ServerInstance "MSI\SQLEXPRESS" -Database "MotorcycleShopDB" -Query $clearSql

# 2. Insert Categories
$categoriesSql = @"
BEGIN TRANSACTION;
DECLARE @ParentId INT;
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 'bx-cycling', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi trước', 'bo-noi-truoc', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi sau', 'bo-noi-sau', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong-sen-dia', 'bx-loader-circle', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Combo 2 món', 'combo-2-mon', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Combo 3 món', 'combo-3-mon', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia-nhot', 'bx-droplet', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Nhớt 4 thì', 'nhot-4-thi', @ParentId, 1);
COMMIT;
"@
Invoke-Sqlcmd -ServerInstance "MSI\SQLEXPRESS" -Database "MotorcycleShopDB" -Query $categoriesSql

# 3. Insert Product (Malossi)
$productSql = @"
BEGIN TRANSACTION;
DECLARE @CatId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Bộ nồi trước');
DECLARE @BrandId INT = (SELECT BrandId FROM Brands WHERE BrandName = N'Malossi');

INSERT INTO Products (ProductName, CategoryId, BrandId, Slug, Description, IsActive, IsFeatured, IsDeleted, CreatedDate)
VALUES (N'Bi nồi Vision 2011-2023 Malossi cao cấp (Full size)', @CatId, @BrandId, 'bi-noi-vision-malossi-full-size', N'Chi tiết sản phẩm Malossi...', 1, 0, 0, GETDATE());

DECLARE @ProductId INT = SCOPE_IDENTITY();

INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, SKU, StockQuantity, CreatedDate, CostPrice)
VALUES
(@ProductId, N'9 gram', 140000, 180000, 'MAL-VIS-09G', 50, GETDATE(), 100000),
(@ProductId, N'10 gram', 145000, 185000, 'MAL-VIS-10G', 45, GETDATE(), 105000),
(@ProductId, N'11 gram', 150000, 190000, 'MAL-VIS-11G', 40, GETDATE(), 110000);

IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng')
    INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
DECLARE @AttrId INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');

INSERT INTO AttributeValues (AttributeId, Value) VALUES (@AttrId, N'9 gram'), (@AttrId, N'10 gram'), (@AttrId, N'11 gram');

INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId)
SELECT pv.ProductVariantId, av.ValueId
FROM ProductVariants pv
JOIN AttributeValues av ON pv.VariantName = av.Value
WHERE pv.ProductId = @ProductId AND av.AttributeId = @AttrId;

COMMIT;
"@
Invoke-Sqlcmd -ServerInstance "MSI\SQLEXPRESS" -Database "MotorcycleShopDB" -Query $productSql
