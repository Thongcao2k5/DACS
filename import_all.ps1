$ErrorActionPreference = "Stop"
$server = "MSI\SQLEXPRESS"
$db = "MotorcycleShopDB"

Write-Host "Starting Data Import with Unicode support..."

# 1. Clear Data
$clearSql = @"
BEGIN TRANSACTION;
DELETE FROM CartItems;
DELETE FROM OrderItems;
DELETE FROM ProductReviews;
DELETE FROM InventoryTransactions;
DELETE FROM ProductVariantAttributeValue;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
UPDATE Products SET CategoryId = NULL;
DELETE FROM Categories;
DELETE FROM Products;
COMMIT;
"@
Invoke-Sqlcmd -ServerInstance $server -Database $db -Query $clearSql

# 2. Import Categories (From clean update_categories.sql)
$categoriesSql = Get-Content 'update_categories.sql' -Raw -Encoding UTF8
Invoke-Sqlcmd -ServerInstance $server -Database $db -Query $categoriesSql

# 3. Import Malossi Product
$productSql = Get-Content 'insert_malossi.sql' -Raw -Encoding UTF8
Invoke-Sqlcmd -ServerInstance $server -Database $db -Query $productSql

Write-Host "Data Import Completed Successfully!"
