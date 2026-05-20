using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace MotoShop.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddSubCategoriesProductUsagesPromotionScopes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[ShippingMethods]') AND name = N'EstimatedDaysInt')
    ALTER TABLE [ShippingMethods] ADD [EstimatedDaysInt] int NOT NULL CONSTRAINT [DF_ShippingMethods_EstimatedDaysInt] DEFAULT 0;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[ShippingMethods]') AND name = N'FreeShipThreshold')
    ALTER TABLE [ShippingMethods] ADD [FreeShipThreshold] decimal(18,2) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[ShippingMethods]') AND name = N'Provider')
    ALTER TABLE [ShippingMethods] ADD [Provider] nvarchar(100) NULL;
");

            migrationBuilder.AddColumn<DateTime>(
                name: "CompletedAt",
                table: "ServiceBookings",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ApplyType",
                table: "Promotions",
                type: "nvarchar(30)",
                maxLength: 30,
                nullable: false,
                defaultValue: "");

            migrationBuilder.Sql(@"
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[ProductVariants]') AND name = N'Weight')
    ALTER TABLE [ProductVariants] ADD [Weight] int NOT NULL CONSTRAINT [DF_ProductVariants_Weight] DEFAULT 0;
");

            migrationBuilder.AddColumn<int>(
                name: "SubCategoryId",
                table: "Products",
                type: "int",
                nullable: true);

            migrationBuilder.Sql(@"
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Orders]') AND name = N'ShippingDistrictId')
    ALTER TABLE [Orders] ADD [ShippingDistrictId] int NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Orders]') AND name = N'ShippingFee')
    ALTER TABLE [Orders] ADD [ShippingFee] decimal(18,2) NOT NULL CONSTRAINT [DF_Orders_ShippingFee] DEFAULT 0;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Orders]') AND name = N'ShippingProvinceCode')
    ALTER TABLE [Orders] ADD [ShippingProvinceCode] nvarchar(20) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Orders]') AND name = N'ShippingWardCode')
    ALTER TABLE [Orders] ADD [ShippingWardCode] nvarchar(20) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[AddressesNew]') AND name = N'DistrictId')
    ALTER TABLE [AddressesNew] ADD [DistrictId] int NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[AddressesNew]') AND name = N'WardCode')
    ALTER TABLE [AddressesNew] ADD [WardCode] nvarchar(20) NULL;
");

            migrationBuilder.CreateTable(
                name: "ProductUsages",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Slug = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductUsages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PromotionCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PromotionId = table.Column<int>(type: "int", nullable: false),
                    CategoryId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PromotionCategories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PromotionCategories_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "CategoryId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PromotionCategories_Promotions_PromotionId",
                        column: x => x.PromotionId,
                        principalTable: "Promotions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PromotionProductVariants",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PromotionId = table.Column<int>(type: "int", nullable: false),
                    ProductVariantId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PromotionProductVariants", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PromotionProductVariants_ProductVariants_ProductVariantId",
                        column: x => x.ProductVariantId,
                        principalTable: "ProductVariants",
                        principalColumn: "ProductVariantId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PromotionProductVariants_Promotions_PromotionId",
                        column: x => x.PromotionId,
                        principalTable: "Promotions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "SubCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Slug = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CategoryId = table.Column<int>(type: "int", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubCategories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SubCategories_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "CategoryId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ProductProductUsages",
                columns: table => new
                {
                    ProductId = table.Column<int>(type: "int", nullable: false),
                    ProductUsageId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductProductUsages", x => new { x.ProductId, x.ProductUsageId });
                    table.ForeignKey(
                        name: "FK_ProductProductUsages_ProductUsages_ProductUsageId",
                        column: x => x.ProductUsageId,
                        principalTable: "ProductUsages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ProductProductUsages_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "ProductId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PromotionSubCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PromotionId = table.Column<int>(type: "int", nullable: false),
                    SubCategoryId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PromotionSubCategories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PromotionSubCategories_Promotions_PromotionId",
                        column: x => x.PromotionId,
                        principalTable: "Promotions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PromotionSubCategories_SubCategories_SubCategoryId",
                        column: x => x.SubCategoryId,
                        principalTable: "SubCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "ProductUsages",
                columns: new[] { "Id", "Description", "IsActive", "Name", "Slug" },
                values: new object[,]
                {
                    { 1, null, true, "Tang toc", "tang-toc" },
                    { 2, null, true, "Tiet kiem nhien lieu", "tiet-kiem-nhien-lieu" },
                    { 3, null, true, "Bao ve dong co", "bao-ve-dong-co" },
                    { 4, null, true, "Giam rung", "giam-rung" },
                    { 5, null, true, "Tang hieu suat phanh", "tang-hieu-suat-phanh" },
                    { 6, null, true, "Phu hop xe tay ga", "phu-hop-xe-tay-ga" },
                    { 7, null, true, "Phu hop xe so", "phu-hop-xe-so" },
                    { 8, null, true, "Trang tri xe", "trang-tri-xe" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Products_SubCategoryId",
                table: "Products",
                column: "SubCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductProductUsages_ProductUsageId",
                table: "ProductProductUsages",
                column: "ProductUsageId");

            migrationBuilder.CreateIndex(
                name: "IX_PromotionCategories_CategoryId",
                table: "PromotionCategories",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_PromotionCategories_PromotionId",
                table: "PromotionCategories",
                column: "PromotionId");

            migrationBuilder.CreateIndex(
                name: "IX_PromotionProductVariants_ProductVariantId",
                table: "PromotionProductVariants",
                column: "ProductVariantId");

            migrationBuilder.CreateIndex(
                name: "IX_PromotionProductVariants_PromotionId",
                table: "PromotionProductVariants",
                column: "PromotionId");

            migrationBuilder.CreateIndex(
                name: "IX_PromotionSubCategories_PromotionId",
                table: "PromotionSubCategories",
                column: "PromotionId");

            migrationBuilder.CreateIndex(
                name: "IX_PromotionSubCategories_SubCategoryId",
                table: "PromotionSubCategories",
                column: "SubCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_SubCategories_CategoryId_Slug",
                table: "SubCategories",
                columns: new[] { "CategoryId", "Slug" });

            migrationBuilder.AddForeignKey(
                name: "FK_Products_SubCategories_SubCategoryId",
                table: "Products",
                column: "SubCategoryId",
                principalTable: "SubCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Products_SubCategories_SubCategoryId",
                table: "Products");

            migrationBuilder.DropTable(
                name: "ProductProductUsages");

            migrationBuilder.DropTable(
                name: "PromotionCategories");

            migrationBuilder.DropTable(
                name: "PromotionProductVariants");

            migrationBuilder.DropTable(
                name: "PromotionSubCategories");

            migrationBuilder.DropTable(
                name: "ProductUsages");

            migrationBuilder.DropTable(
                name: "SubCategories");

            migrationBuilder.DropIndex(
                name: "IX_Products_SubCategoryId",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "EstimatedDaysInt",
                table: "ShippingMethods");

            migrationBuilder.DropColumn(
                name: "FreeShipThreshold",
                table: "ShippingMethods");

            migrationBuilder.DropColumn(
                name: "Provider",
                table: "ShippingMethods");

            migrationBuilder.DropColumn(
                name: "CompletedAt",
                table: "ServiceBookings");

            migrationBuilder.DropColumn(
                name: "ApplyType",
                table: "Promotions");

            migrationBuilder.DropColumn(
                name: "Weight",
                table: "ProductVariants");

            migrationBuilder.DropColumn(
                name: "SubCategoryId",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "ShippingDistrictId",
                table: "Orders");

            migrationBuilder.DropColumn(
                name: "ShippingFee",
                table: "Orders");

            migrationBuilder.DropColumn(
                name: "ShippingProvinceCode",
                table: "Orders");

            migrationBuilder.DropColumn(
                name: "ShippingWardCode",
                table: "Orders");

            migrationBuilder.DropColumn(
                name: "DistrictId",
                table: "AddressesNew");

            migrationBuilder.DropColumn(
                name: "WardCode",
                table: "AddressesNew");
        }
    }
}
