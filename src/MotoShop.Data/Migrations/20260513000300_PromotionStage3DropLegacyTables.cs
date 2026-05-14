using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using MotoShop.Data.Data;

#nullable disable

namespace MotoShop.Data.Migrations
{
    [DbContext(typeof(MotoShopDbContext))]
    [Migration("20260513000300_PromotionStage3DropLegacyTables")]
    public partial class PromotionStage3DropLegacyTables : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
IF OBJECT_ID('FK_Orders_Coupons_CouponId', 'F') IS NOT NULL
    ALTER TABLE Orders DROP CONSTRAINT FK_Orders_Coupons_CouponId;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_CouponId' AND object_id = OBJECT_ID('Orders'))
    DROP INDEX IX_Orders_CouponId ON Orders;

IF OBJECT_ID('FlashSaleProducts', 'U') IS NOT NULL
    DROP TABLE FlashSaleProducts;

IF OBJECT_ID('FlashSales', 'U') IS NOT NULL
    DROP TABLE FlashSales;

IF OBJECT_ID('Coupons', 'U') IS NOT NULL
    DROP TABLE Coupons;
");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
IF OBJECT_ID('Coupons', 'U') IS NULL
BEGIN
    CREATE TABLE Coupons
    (
        Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Coupons PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL,
        DiscountValue DECIMAL(18,2) NOT NULL,
        DiscountType NVARCHAR(20) NOT NULL,
        MinOrderValue DECIMAL(18,2) NULL,
        UsageLimit INT NOT NULL CONSTRAINT DF_Coupons_UsageLimit DEFAULT(0),
        UsedCount INT NOT NULL CONSTRAINT DF_Coupons_UsedCount DEFAULT(0),
        ExpiryDate DATETIME2 NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Coupons_IsActive DEFAULT(1)
    );
END

IF OBJECT_ID('FlashSales', 'U') IS NULL
BEGIN
    CREATE TABLE FlashSales
    (
        FlashSaleId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_FlashSales PRIMARY KEY,
        Title NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        StartDate DATETIME2 NOT NULL,
        EndDate DATETIME2 NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_FlashSales_IsActive DEFAULT(1)
    );
END

IF OBJECT_ID('FlashSaleProducts', 'U') IS NULL
BEGIN
    CREATE TABLE FlashSaleProducts
    (
        Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_FlashSaleProducts PRIMARY KEY,
        FlashSaleId INT NOT NULL,
        ProductId INT NOT NULL,
        FlashSalePrice DECIMAL(18,2) NOT NULL,
        Quantity INT NOT NULL,
        SoldQuantity INT NOT NULL CONSTRAINT DF_FlashSaleProducts_SoldQuantity DEFAULT(0)
    );
END
");
        }
    }
}
