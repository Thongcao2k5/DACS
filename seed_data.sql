-- 1. Create tables if not exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSales')
    CREATE TABLE FlashSales (FlashSaleId INT IDENTITY PRIMARY KEY, Title NVARCHAR(255) NOT NULL, Description NVARCHAR(MAX), StartDate DATETIME NOT NULL, EndDate DATETIME NOT NULL, IsActive BIT DEFAULT 1);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSaleProducts')
    CREATE TABLE FlashSaleProducts (Id INT IDENTITY PRIMARY KEY, FlashSaleId INT NOT NULL, ProductId INT NOT NULL, FlashSalePrice DECIMAL(18,2) NOT NULL, Quantity INT NOT NULL, SoldQuantity INT DEFAULT 0);

-- 2. Clear existing data
DELETE FROM FlashSaleProducts;
DELETE FROM FlashSales;

-- 3. Insert Flash Sale
DECLARE @FSID INT;
INSERT INTO FlashSales (Title, Description, StartDate, EndDate, IsActive)
VALUES (N'SĂN SALE GIỜ VÀNG - PHỤ TÙNG KHỦNG', N'Ưu đãi đặc biệt hôm nay', GETDATE(), DATEADD(day, 2, GETDATE()), 1);
SET @FSID = SCOPE_IDENTITY();

-- 4. Assign products to Flash Sale
INSERT INTO FlashSaleProducts (FlashSaleId, ProductId, FlashSalePrice, Quantity, SoldQuantity)
SELECT TOP 5 @FSID, ProductId, 150000, 100, 15 FROM Products WHERE IsActive = 1;

-- 5. Insert Promotion (Using correct PromotionName column)
DELETE FROM Promotions;
INSERT INTO Promotions (PromotionName, Description, DiscountType, DiscountPercentage, DiscountAmount, StartDate, EndDate, IsActive)
VALUES (N'ƯU ĐÃI THÁNG 5', N'Giảm giá mùa hè', 'Percentage', 10, 0, GETDATE(), DATEADD(month, 1, GETDATE()), 1);

-- 6. Update OriginalPrice to simulate discounts
UPDATE ProductVariants
SET OriginalPrice = Price * 1.5
WHERE ProductId IN (SELECT TOP 12 ProductId FROM Products WHERE IsActive = 1);
