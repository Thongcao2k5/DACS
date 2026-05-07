import re
import os

def generate_sql():
    with open('generated_products_v2.txt', 'r', encoding='utf-8') as f:
        content = f.read()

    products = re.split(r'Sản phẩm \d+:', content)[1:]
    
    cat_map = {
        'BỘ NỒI XE TAY GA': 460,
        'NHÔNG - SÊN - DĨA': 463,
        'CĂM XE MÁY': 467,
        'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)': 472,
        'LỌC GIÓ': 477,
        'PHỤ GIA - NHỚT': 480,
        'BỐ THẮNG': 482,
        'VỎ XE - NIỀNG XE': 485,
        'DÂY CÁP': 488,
        'PHÂN KHỐI LỚN': 494,
        'CHÉN CỔ': 500,
        'PHỤ KIỆN KHÁC': 501
    }
    
    brand_map = {
        'MTX': 60, 'Malossi': 61, 'Motobatt': 62, 'Senarc': 63, 'Yaguso': 64,
        'CRG': 65, 'Tan Lan': 66, 'Orange': 67, 'FKR': 68, 'Faito': 69,
        'RGV': 70, 'Apido': 71, 'YSS': 72, 'FMF': 73, 'TR Tiller': 74,
        'CT Cytracing': 75, 'Kozi': 76
    }

    sql = ["USE MotorcycleShopDB;", "GO", "BEGIN TRANSACTION;", "DECLARE @Pid INT, @Vid INT, @Aid INT, @ValId INT;"]
    
    for p_text in products:
        try:
            name = re.search(r'- Tên: (.+)', p_text).group(1).strip()
            cat = re.search(r'- Danh mục: (.+)', p_text).group(1).strip()
            brand = re.search(r'- Thương hiệu: (.+)', p_text).group(1).strip()
            desc = re.search(r'- Mô tả HTML: (.+)', p_text, re.DOTALL).group(1).strip()
            main_img = re.search(r'- Ảnh chính: (.+)', p_text).group(1).strip()
            extra_imgs = re.search(r'- Ảnh phụ: (.+)', p_text).group(1).strip().split(', ')
            
            cid = cat_map.get(cat, 501)
            bid = brand_map.get(brand, 76)
            slug = re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-')
            
            # Clean description for SQL
            desc = desc.replace("'", "''")
            name = name.replace("'", "''")
            
            sql.append(f"\n-- Product: {name}")
            sql.append(f"INSERT INTO Products (ProductName, CategoryId, BrandId, Description, Slug, IsActive, IsFeatured, CreatedDate, IsDeleted) VALUES (N'{name}', {cid}, {bid}, N'{desc}', '{slug}', 1, 0, GETDATE(), 0);")
            sql.append("SET @Pid = SCOPE_IDENTITY();")
            
            # Images
            sql.append(f"INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, '{main_img}', 1, 0);")
            for i, img in enumerate(extra_imgs):
                sql.append(f"INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, '{img}', 0, {i+1});")
                
            # Variants
            variants_match = re.search(r'- Variants:\n((?:    \+ .+\n?)+)', p_text)
            if variants_match:
                for v_line in variants_match.group(1).strip().split('\n'):
                    # Format: + value - price - SKU - stock
                    v_parts = v_line.strip('+ ').split(' - ')
                    if len(v_parts) >= 4:
                        v_val = v_parts[0].strip()
                        v_price = v_parts[1].replace(' VND', '').replace(',', '').strip()
                        v_sku = v_parts[2].strip()
                        v_stock = v_parts[3].strip()
                        
                        v_orig_price = int(float(v_price) * 1.2) # Est original price
                        v_cost = int(float(v_price) * 0.8)
                        
                        sql.append(f"  INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate) VALUES (@Pid, '{v_sku}', N'{v_val}', {v_price}, {v_orig_price}, {v_cost}, {v_stock}, '{main_img}', GETDATE());")
                        sql.append("  SET @Vid = SCOPE_IDENTITY();")
                        
                        # Attributes (Simple Weight/Size mapping)
                        attr_name = "Thông số"
                        sql.append(f"  IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'{attr_name}') INSERT INTO ProductAttributes (AttributeName) VALUES (N'{attr_name}');")
                        sql.append(f"  SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'{attr_name}');")
                        sql.append(f"  IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'{v_val}') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'{v_val}');")
                        sql.append(f"  SET @ValId = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'{v_val}');")
                        sql.append(f"  INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @ValId);")
                        
        except Exception as e:
            print(f"Error parsing product: {e}")

    sql.append("\nCOMMIT;")
    sql.append("GO")
    
    with open('final_import_v5.sql', 'w', encoding='utf-16') as f:
        f.write('\n'.join(sql))

if __name__ == "__main__":
    generate_sql()
