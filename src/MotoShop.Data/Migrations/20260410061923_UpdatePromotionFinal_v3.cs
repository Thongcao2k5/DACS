using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MotoShop.Data.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePromotionFinal_v3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DiscountType",
                table: "Promotions",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "MinOrderValue",
                table: "Promotions",
                type: "decimal(18,2)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "MinQuantity",
                table: "Promotions",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DiscountType",
                table: "Promotions");

            migrationBuilder.DropColumn(
                name: "MinOrderValue",
                table: "Promotions");

            migrationBuilder.DropColumn(
                name: "MinQuantity",
                table: "Promotions");
        }
    }
}
