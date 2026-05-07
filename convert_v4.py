import re

def convert_v3_to_v4(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Initial setup cleaning
    cleaning_sql = """-- Cleaning tables
DELETE FROM CartItems;
DELETE FROM InventoryTransactions;
DELETE FROM OrderItems;
DELETE FROM ProductReviews;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSaleProducts') DELETE FROM FlashSaleProducts;
DELETE FROM PromotionProducts;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Custom_Wishlists') DELETE FROM Custom_Wishlists;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistItems') DELETE FROM WishlistItems;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Wishlists') DELETE FROM Wishlists;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistsNew') DELETE FROM WishlistsNew;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductVariantAttributeValue') DELETE FROM ProductVariantAttributeValue;
DELETE FROM ProductImages;
DELETE FROM ProductVariants;
DELETE FROM Products;
"""

    # Replace the beginning
    # Find the start of insertions
    # v3 starts with:
    # USE [MotorcycleShopDB]
    # GO
    # BEGIN TRANSACTION
    # GO
    # DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;
    # GO
    
    header = "USE [MotorcycleShopDB]\nGO\n" + cleaning_sql + "GO\nBEGIN TRANSACTION\nGO\nDECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;\n"
    
    # Remove everything up to the first "-- Product:"
    parts = content.split('-- Product:', 1)
    if len(parts) < 2:
        print("Error: Could not find first product marker")
        return
    
    body = "-- Product:" + parts[1]
    
    # Remove COMMIT and GO from the very end of body if they exist
    body = re.sub(r'\s*COMMIT\s*GO\s*$', '', body, flags=re.IGNORECASE | re.MULTILINE)
    
    # Remove internal GO commands
    body = re.sub(r'\nGO\s*\n', '\n', body)
    
    # Wrap each product in BEGIN...END
    product_blocks = re.split(r'(-- Product:.*?\n)', body)
    
    new_body = ""
    for i in range(1, len(product_blocks), 2):
        marker = product_blocks[i]
        content_block = product_blocks[i+1]
        
        # Ensure CostPrice = 0.8 * Price
        def update_variant(match):
            prefix = match.group(1)
            price_str = match.group(2)
            price = float(price_str)
            cost_price = round(price * 0.8, 2)
            return f"{prefix}{price_str}, {cost_price}, "

        content_block = re.sub(r"(VALUES\s*\(@Pid,\s*N'[^']*',\s*N'[^']*',\s*)(\d+\.?\d*),\s*(\d+\.?\d*),\s*", update_variant, content_block)

        # Ensure IsFeatured = 0
        content_block = re.sub(r",\s*[01],\s*1,\s*GETDATE\(\)\)", ", 0, 1, GETDATE())", content_block)

        new_body += "BEGIN\n" + marker + content_block + "END\n"


    # Final footer
    footer = "\nCOMMIT\nGO\n"
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(header + new_body + footer)

convert_v3_to_v4('F:\\DACS\\final_import_v3.sql', 'F:\\DACS\\final_import_v4.sql')
