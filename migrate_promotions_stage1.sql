-- SQL Migration Script for Unified Promotion System
-- MotoShop DACS - Phase 1

-- 1. Create new tables if not exist (handled by EF, but for manual script)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Promotions')
BEGIN
    CREATE TABLE Promotions (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL,
        Slug NVARCHAR(255) NULL,
        Description NVARCHAR(MAX) NULL,
        PromotionType NVARCHAR(50) NOT NULL,
        DiscountType NVARCHAR(20) NOT NULL,
        DiscountValue DECIMAL(18, 2) NOT NULL,
        MaxDiscountAmount DECIMAL(18, 2) NULL,
        MinOrderAmount DECIMAL(18, 2) NULL,
        CouponCode NVARCHAR(100) NULL,
        StartDate DATETIME NOT NULL,
        EndDate DATETIME NOT NULL,
        UsageLimit INT NULL,
        UsedCount INT DEFAULT 0,
        IsActive BIT DEFAULT 1,
        IsFeatured BIT DEFAULT 0,
        Priority INT DEFAULT 0,
        BannerImage NVARCHAR(500) NULL,
        BackgroundColor NVARCHAR(50) NULL,
        CreatedAt DATETIME DEFAULT GETDATE(),
        UpdatedAt DATETIME NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PromotionProducts')
BEGIN
    CREATE TABLE PromotionProducts (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        PromotionId INT NOT NULL,
        ProductId INT NOT NULL,
        CONSTRAINT FK_PromotionProducts_Promotions FOREIGN KEY (PromotionId) REFERENCES Promotions(Id) ON DELETE CASCADE,
        CONSTRAINT FK_PromotionProducts_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE
    );
END

-- 2. Migrate Flash Sales
INSERT INTO Promotions (Name, Description, PromotionType, DiscountType, DiscountValue, StartDate, EndDate, IsActive, CreatedAt)
SELECT Title, Description, 'FlashSale', 'Percent', 10, StartDate, EndDate, IsActive, GETDATE()
FROM FlashSales;

-- Link Flash Sale Products
-- (Assuming we need to match by ProductId)
INSERT INTO PromotionProducts (PromotionId, ProductId)
SELECT p.Id, fsp.ProductId
FROM FlashSaleProducts fsp
JOIN FlashSales fs ON fsp.FlashSaleId = fs.FlashSaleId
JOIN Promotions p ON p.Name = fs.Title AND p.PromotionType = 'FlashSale';

-- 3. Migrate Coupons
INSERT INTO Promotions (Name, CouponCode, PromotionType, DiscountType, DiscountValue, MinOrderAmount, UsageLimit, UsedCount, EndDate, IsActive, CreatedAt)
SELECT 'Voucher ' + Code, Code, 'Voucher', 
       CASE WHEN DiscountType = 'Percentage' THEN 'Percent' ELSE 'Fixed' END,
       DiscountValue, MinOrderValue, UsageLimit, UsedCount, ExpiryDate, IsActive, GETDATE()
FROM Coupons;

-- 4. Backup old tables (Optional but requested "không xóa")
-- (They are already in the DB, EF will just ignore them if not in DbContext or map them to Old...)
GO
PRINT 'Migration to Unified Promotions completed successfully.';
