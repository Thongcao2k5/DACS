using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using MotoShop.Data.Data;

#nullable disable

namespace MotoShop.Data.Migrations
{
    [DbContext(typeof(MotoShopDbContext))]
    [Migration("20260513000100_PromotionStage1Unified")]
    public partial class PromotionStage1Unified : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
IF OBJECT_ID('Promotions', 'U') IS NULL
BEGIN
    CREATE TABLE Promotions
    (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL,
        Slug NVARCHAR(255) NULL,
        Description NVARCHAR(MAX) NULL,
        PromotionType NVARCHAR(50) NOT NULL CONSTRAINT DF_Promotions_PromotionType DEFAULT('ProductDiscount'),
        DiscountType NVARCHAR(20) NOT NULL CONSTRAINT DF_Promotions_DiscountType DEFAULT('Percent'),
        DiscountValue DECIMAL(18,2) NOT NULL CONSTRAINT DF_Promotions_DiscountValue DEFAULT(0),
        MaxDiscountAmount DECIMAL(18,2) NULL,
        MinOrderAmount DECIMAL(18,2) NULL,
        CouponCode NVARCHAR(100) NULL,
        StartDate DATETIME NOT NULL CONSTRAINT DF_Promotions_StartDate DEFAULT(GETDATE()),
        EndDate DATETIME NOT NULL CONSTRAINT DF_Promotions_EndDate DEFAULT(DATEADD(day, 7, GETDATE())),
        UsageLimit INT NULL,
        UsedCount INT NOT NULL CONSTRAINT DF_Promotions_UsedCount DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_Promotions_IsActive DEFAULT(1),
        IsFeatured BIT NOT NULL CONSTRAINT DF_Promotions_IsFeatured DEFAULT(0),
        Priority INT NOT NULL CONSTRAINT DF_Promotions_Priority DEFAULT(0),
        BannerImage NVARCHAR(500) NULL,
        BackgroundColor NVARCHAR(50) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_Promotions_CreatedAt DEFAULT(GETDATE()),
        UpdatedAt DATETIME NULL
    );
END

IF OBJECT_ID('Promotions', 'U') IS NOT NULL
BEGIN
    IF COL_LENGTH('Promotions', 'PromotionId') IS NOT NULL AND COL_LENGTH('Promotions', 'Id') IS NULL
        EXEC sp_rename 'Promotions.PromotionId', 'Id', 'COLUMN';

    IF COL_LENGTH('Promotions', 'PromotionName') IS NOT NULL AND COL_LENGTH('Promotions', 'Name') IS NULL
        EXEC sp_rename 'Promotions.PromotionName', 'Name', 'COLUMN';

    IF COL_LENGTH('Promotions', 'DiscountValue') IS NULL
        ALTER TABLE Promotions ADD DiscountValue DECIMAL(18,2) NOT NULL CONSTRAINT DF_Promotions_DiscountValue DEFAULT(0);

    IF COL_LENGTH('Promotions', 'PromotionType') IS NULL
        ALTER TABLE Promotions ADD PromotionType NVARCHAR(50) NOT NULL CONSTRAINT DF_Promotions_PromotionType DEFAULT('ProductDiscount');

    IF COL_LENGTH('Promotions', 'Slug') IS NULL
        ALTER TABLE Promotions ADD Slug NVARCHAR(255) NULL;

    IF COL_LENGTH('Promotions', 'MaxDiscountAmount') IS NULL
        ALTER TABLE Promotions ADD MaxDiscountAmount DECIMAL(18,2) NULL;

    IF COL_LENGTH('Promotions', 'MinOrderAmount') IS NULL
        ALTER TABLE Promotions ADD MinOrderAmount DECIMAL(18,2) NULL;

    IF COL_LENGTH('Promotions', 'CouponCode') IS NULL
        ALTER TABLE Promotions ADD CouponCode NVARCHAR(100) NULL;

    IF COL_LENGTH('Promotions', 'UsageLimit') IS NULL
        ALTER TABLE Promotions ADD UsageLimit INT NULL;

    IF COL_LENGTH('Promotions', 'UsedCount') IS NULL
        ALTER TABLE Promotions ADD UsedCount INT NOT NULL CONSTRAINT DF_Promotions_UsedCount DEFAULT(0);

    IF COL_LENGTH('Promotions', 'IsFeatured') IS NULL
        ALTER TABLE Promotions ADD IsFeatured BIT NOT NULL CONSTRAINT DF_Promotions_IsFeatured DEFAULT(0);

    IF COL_LENGTH('Promotions', 'Priority') IS NULL
        ALTER TABLE Promotions ADD Priority INT NOT NULL CONSTRAINT DF_Promotions_Priority DEFAULT(0);

    IF COL_LENGTH('Promotions', 'BannerImage') IS NULL
        ALTER TABLE Promotions ADD BannerImage NVARCHAR(500) NULL;

    IF COL_LENGTH('Promotions', 'BackgroundColor') IS NULL
        ALTER TABLE Promotions ADD BackgroundColor NVARCHAR(50) NULL;

    IF COL_LENGTH('Promotions', 'CreatedAt') IS NULL
        ALTER TABLE Promotions ADD CreatedAt DATETIME NOT NULL CONSTRAINT DF_Promotions_CreatedAt DEFAULT(GETDATE());

    IF COL_LENGTH('Promotions', 'UpdatedAt') IS NULL
        ALTER TABLE Promotions ADD UpdatedAt DATETIME NULL;

    IF COL_LENGTH('Promotions', 'DiscountAmount') IS NOT NULL AND COL_LENGTH('Promotions', 'DiscountPercentage') IS NOT NULL
        EXEC('UPDATE Promotions
              SET DiscountValue = CASE
                      WHEN DiscountType = ''Fixed'' THEN ISNULL(DiscountAmount, DiscountValue)
                      ELSE ISNULL(DiscountPercentage, DiscountValue)
                  END,
                  PromotionType = ISNULL(PromotionType, ''ProductDiscount''),
                  UsedCount = ISNULL(UsedCount, 0),
                  IsFeatured = ISNULL(IsFeatured, 0),
                  Priority = ISNULL(Priority, 0),
                  CreatedAt = ISNULL(CreatedAt, GETDATE())
              WHERE DiscountValue = 0');
    ELSE
        EXEC('UPDATE Promotions
              SET PromotionType = ISNULL(PromotionType, ''ProductDiscount''),
                  UsedCount = ISNULL(UsedCount, 0),
                  IsFeatured = ISNULL(IsFeatured, 0),
                  Priority = ISNULL(Priority, 0),
                  CreatedAt = ISNULL(CreatedAt, GETDATE())');
END

IF OBJECT_ID('PromotionProducts', 'U') IS NULL
BEGIN
    CREATE TABLE PromotionProducts
    (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PromotionId INT NOT NULL,
        ProductId INT NOT NULL
    );
END

IF OBJECT_ID('PromotionProducts', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PromotionProducts_PromotionId' AND object_id = OBJECT_ID('PromotionProducts'))
        CREATE INDEX IX_PromotionProducts_PromotionId ON PromotionProducts (PromotionId);

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PromotionProducts_ProductId' AND object_id = OBJECT_ID('PromotionProducts'))
        CREATE INDEX IX_PromotionProducts_ProductId ON PromotionProducts (ProductId);
END
" );
            // Make legacy columns nullable so Phase 2 INSERT (without those columns) won't fail
            migrationBuilder.Sql(@"
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'ALTER TABLE Promotions DROP CONSTRAINT [' + dc.name + ']; '
FROM sys.default_constraints dc
JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('Promotions')
  AND c.name IN ('DiscountPercentage','DiscountAmount','MinOrderValue','MinQuantity');
IF LEN(@sql) > 0 EXEC(@sql);

IF COL_LENGTH('Promotions','DiscountPercentage') IS NOT NULL
    ALTER TABLE Promotions ALTER COLUMN DiscountPercentage DECIMAL(18,2) NULL;
IF COL_LENGTH('Promotions','DiscountAmount') IS NOT NULL
    ALTER TABLE Promotions ALTER COLUMN DiscountAmount DECIMAL(18,2) NULL;
IF COL_LENGTH('Promotions','MinOrderValue') IS NOT NULL
    ALTER TABLE Promotions ALTER COLUMN MinOrderValue DECIMAL(18,2) NULL;
IF COL_LENGTH('Promotions','MinQuantity') IS NOT NULL
    ALTER TABLE Promotions ALTER COLUMN MinQuantity INT NULL;
" );
            // Phase 2: data migration — separate batch so new columns are visible at parse time
            migrationBuilder.Sql(@"
IF OBJECT_ID('Coupons', 'U') IS NOT NULL AND OBJECT_ID('Promotions', 'U') IS NOT NULL
BEGIN
    INSERT INTO Promotions (Name, Slug, Description, PromotionType, DiscountType, DiscountValue, MaxDiscountAmount, MinOrderAmount, CouponCode, StartDate, EndDate, UsageLimit, UsedCount, IsActive, IsFeatured, Priority, BannerImage, BackgroundColor, CreatedAt, UpdatedAt)
    SELECT
        c.Code,
        LOWER(REPLACE(c.Code, ' ', '-')),
        NULL,
        'Voucher',
        CASE WHEN LOWER(c.DiscountType) = 'fixed' THEN 'Fixed' ELSE 'Percent' END,
        c.DiscountValue,
        NULL,
        c.MinOrderValue,
        c.Code,
        GETDATE(),
        c.ExpiryDate,
        NULLIF(c.UsageLimit, 0),
        c.UsedCount,
        c.IsActive,
        0,
        0,
        NULL,
        NULL,
        GETDATE(),
        NULL
    FROM Coupons c
    WHERE NOT EXISTS (
        SELECT 1
        FROM Promotions p
        WHERE p.CouponCode = c.Code
    );
END

IF OBJECT_ID('FlashSales', 'U') IS NOT NULL AND OBJECT_ID('Promotions', 'U') IS NOT NULL
BEGIN
    INSERT INTO Promotions (Name, Slug, Description, PromotionType, DiscountType, DiscountValue, MaxDiscountAmount, MinOrderAmount, CouponCode, StartDate, EndDate, UsageLimit, UsedCount, IsActive, IsFeatured, Priority, BannerImage, BackgroundColor, CreatedAt, UpdatedAt)
    SELECT
        fs.Title,
        LOWER(REPLACE(fs.Title, ' ', '-')),
        fs.Description,
        'FlashSale',
        'Fixed',
        0,
        NULL,
        NULL,
        NULL,
        fs.StartDate,
        fs.EndDate,
        NULL,
        0,
        fs.IsActive,
        0,
        0,
        NULL,
        NULL,
        GETDATE(),
        NULL
    FROM FlashSales fs
    WHERE NOT EXISTS (
        SELECT 1
        FROM Promotions p
        WHERE p.PromotionType = 'FlashSale'
          AND p.Name = fs.Title
          AND p.StartDate = fs.StartDate
          AND p.EndDate = fs.EndDate
    );
END

IF OBJECT_ID('FlashSaleProducts', 'U') IS NOT NULL AND OBJECT_ID('PromotionProducts', 'U') IS NOT NULL AND OBJECT_ID('FlashSales', 'U') IS NOT NULL
BEGIN
    INSERT INTO PromotionProducts (PromotionId, ProductId)
    SELECT p.Id, fsp.ProductId
    FROM FlashSaleProducts fsp
    INNER JOIN FlashSales fs ON fs.FlashSaleId = fsp.FlashSaleId
    INNER JOIN Promotions p
        ON p.PromotionType = 'FlashSale'
       AND p.Name = fs.Title
       AND p.StartDate = fs.StartDate
       AND p.EndDate = fs.EndDate
    WHERE NOT EXISTS (
        SELECT 1
        FROM PromotionProducts pp
        WHERE pp.PromotionId = p.Id
          AND pp.ProductId = fsp.ProductId
    );
END
" );
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
IF OBJECT_ID('PromotionProducts', 'U') IS NOT NULL
BEGIN
    DELETE FROM PromotionProducts
    WHERE PromotionId IN (SELECT Id FROM Promotions WHERE PromotionType IN ('Voucher', 'FlashSale'));
END

IF OBJECT_ID('Promotions', 'U') IS NOT NULL
BEGIN
    IF COL_LENGTH('Promotions', 'UpdatedAt') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN UpdatedAt;
    IF COL_LENGTH('Promotions', 'CreatedAt') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN CreatedAt;
    IF COL_LENGTH('Promotions', 'BackgroundColor') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN BackgroundColor;
    IF COL_LENGTH('Promotions', 'BannerImage') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN BannerImage;
    IF COL_LENGTH('Promotions', 'Priority') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN Priority;
    IF COL_LENGTH('Promotions', 'IsFeatured') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN IsFeatured;
    IF COL_LENGTH('Promotions', 'UsedCount') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN UsedCount;
    IF COL_LENGTH('Promotions', 'UsageLimit') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN UsageLimit;
    IF COL_LENGTH('Promotions', 'CouponCode') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN CouponCode;
    IF COL_LENGTH('Promotions', 'MinOrderAmount') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN MinOrderAmount;
    IF COL_LENGTH('Promotions', 'MaxDiscountAmount') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN MaxDiscountAmount;
    IF COL_LENGTH('Promotions', 'Slug') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN Slug;
    IF COL_LENGTH('Promotions', 'PromotionType') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN PromotionType;
    IF COL_LENGTH('Promotions', 'DiscountValue') IS NOT NULL
        ALTER TABLE Promotions DROP COLUMN DiscountValue;

    IF COL_LENGTH('Promotions', 'Name') IS NOT NULL AND COL_LENGTH('Promotions', 'PromotionName') IS NULL
        EXEC sp_rename 'Promotions.Name', 'PromotionName', 'COLUMN';

    IF COL_LENGTH('Promotions', 'Id') IS NOT NULL AND COL_LENGTH('Promotions', 'PromotionId') IS NULL
        EXEC sp_rename 'Promotions.Id', 'PromotionId', 'COLUMN';
END

IF OBJECT_ID('PromotionProducts', 'U') IS NOT NULL
BEGIN
    DELETE FROM PromotionProducts WHERE PromotionId IN (SELECT PromotionId FROM Promotions WHERE PromotionName IS NULL);
END
" );
        }
    }
}
