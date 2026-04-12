using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MotoShop.Data.Migrations
{
    /// <inheritdoc />
    public partial class UpdateShippingMethodFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsApproved",
                table: "ProductReviews");

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "ShippingMethods",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "ShippingMethods",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Services",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "ProductReviews",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "IsLocked",
                table: "Customers",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<decimal>(
                name: "MinOrderValue",
                table: "Coupons",
                type: "decimal(18,2)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsageLimit",
                table: "Coupons",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "UsedCount",
                table: "Coupons",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "BookingCode",
                table: "ServiceBookings",
                type: "nvarchar(max)",
                nullable: true,
                computedColumnSql: "'DV'+right('000000'+CONVERT([nvarchar],[BookingId]),(6))",
                stored: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BookingCode",
                table: "ServiceBookings");

            migrationBuilder.DropColumn(
                name: "Description",
                table: "ShippingMethods");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "ShippingMethods");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Services");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "ProductReviews");

            migrationBuilder.DropColumn(
                name: "IsLocked",
                table: "Customers");

            migrationBuilder.DropColumn(
                name: "MinOrderValue",
                table: "Coupons");

            migrationBuilder.DropColumn(
                name: "UsageLimit",
                table: "Coupons");

            migrationBuilder.DropColumn(
                name: "UsedCount",
                table: "Coupons");

            migrationBuilder.AddColumn<bool>(
                name: "IsApproved",
                table: "ProductReviews",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }
    }
}
