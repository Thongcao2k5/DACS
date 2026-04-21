using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MotoShop.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddServiceComboTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ComboId",
                table: "ServiceBookings",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ServiceCombos",
                columns: table => new
                {
                    ComboId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ComboName = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    TotalPrice = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    DiscountPrice = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ImageUrl = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ServiceCombos", x => x.ComboId);
                });

            migrationBuilder.CreateTable(
                name: "ServiceComboItems",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ComboId = table.Column<int>(type: "int", nullable: false),
                    ServiceId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ServiceComboItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ServiceComboItems_ServiceCombos_ComboId",
                        column: x => x.ComboId,
                        principalTable: "ServiceCombos",
                        principalColumn: "ComboId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ServiceComboItems_Services_ServiceId",
                        column: x => x.ServiceId,
                        principalTable: "Services",
                        principalColumn: "ServiceId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ServiceBookings_ComboId",
                table: "ServiceBookings",
                column: "ComboId");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceComboItems_ComboId",
                table: "ServiceComboItems",
                column: "ComboId");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceComboItems_ServiceId",
                table: "ServiceComboItems",
                column: "ServiceId");

            migrationBuilder.AddForeignKey(
                name: "FK_ServiceBookings_ServiceCombos_ComboId",
                table: "ServiceBookings",
                column: "ComboId",
                principalTable: "ServiceCombos",
                principalColumn: "ComboId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ServiceBookings_ServiceCombos_ComboId",
                table: "ServiceBookings");

            migrationBuilder.DropTable(
                name: "ServiceComboItems");

            migrationBuilder.DropTable(
                name: "ServiceCombos");

            migrationBuilder.DropIndex(
                name: "IX_ServiceBookings_ComboId",
                table: "ServiceBookings");

            migrationBuilder.DropColumn(
                name: "ComboId",
                table: "ServiceBookings");
        }
    }
}
