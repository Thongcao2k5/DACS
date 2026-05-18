using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MotoShop.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddPromotionProductQuantityTracking : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Quantity",
                table: "PromotionProducts",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SoldQuantity",
                table: "PromotionProducts",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Quantity",
                table: "PromotionProducts");

            migrationBuilder.DropColumn(
                name: "SoldQuantity",
                table: "PromotionProducts");
        }
    }
}
