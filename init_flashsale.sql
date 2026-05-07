-- 1. Tạo bảng nếu chưa có (để chắc chắn)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSales')
    CREATE TABLE FlashSales (FlashSaleId INT IDENTITY PRIMARY KEY, Title NVARCHAR(255) NOT NULL, Description NVARCHAR(MAX), StartDate DATETIME NOT NULL, EndDate DATETIME NOT NULL, IsActive BIT DEFAULT 1);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSaleProducts')
    CREATE TABLE FlashSaleProducts (Id INT IDENTITY PRIMARY KEY, FlashSaleId INT NOT NULL, ProductId INT NOT NULL, FlashSalePrice DECIMAL(18,2) NOT NULL, Quantity INT NOT NULL, SoldQuantity INT DEFAULT 0);

-- 2. Xóa dữ liệu cũ để test sạch
DELETE FROM FlashSaleProducts;
DELETE FROM FlashSales;

-- 3. Khởi tạo chương trình Flash Sale
DECLARE @FSID INT;
INSERT INTO FlashSales (Title, Description, StartDate, EndDate, IsActive)
VALUES (N'SĂN SALE GIỜ VÀNG - PHỤ TÙNG KHỦNG', N'Ưu đãi đặc biệt hôm nay - Đừng bỏ lỡ!', GETDATE(), DATEADD(day, 2, GETDATE()), 1);
SET @FSID = SCOPE_IDENTITY();

-- 4. Lấy 20 sản phẩm đầu tiên có trong DB để gán vào Flash Sale (để có scroll bar)
INSERT INTO FlashSaleProducts (FlashSaleId, ProductId, FlashSalePrice, Quantity, SoldQuantity)
SELECT TOP 20 @FSID, ProductId, 150000, 100, 15 FROM Products;

-- 5. Cập nhật giá niêm yết (OriginalPrice) cho các sản phẩm này để hiện nhãn % giảm giá
UPDATE ProductVariants
SET OriginalPrice = Price * 1.5
WHERE ProductId IN (SELECT TOP 20 ProductId FROM Products);

-- 6. Tạo Khuyến mãi thường
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Promotions')
    CREATE TABLE Promotions (PromotionId INT IDENTITY PRIMARY KEY, PromotionName NVARCHAR(255), Description NVARCHAR(MAX), StartDate DATETIME, EndDate DATETIME, IsActive BIT DEFAULT 1);

DELETE FROM Promotions;
INSERT INTO Promotions (PromotionName, Description, StartDate, EndDate, IsActive, DiscountType, DiscountPercentage, DiscountAmount)
VALUES (N'ƯU ĐÃI THÁNG 5', N'Giảm giá mùa hè', GETDATE(), DATEADD(month, 1, GETDATE()), 1, 'Percentage', 10, 0);
