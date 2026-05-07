import re

def parse_price(price_str):
    try:
        return float(price_str.replace('VND', '').replace(',', '').strip())
    except:
        return 0.0

def parse_int(int_str):
    try:
        return int(int_str.strip())
    except:
        return 0

category_map = {
    "BỘ NỒI XE TAY GA": 460,
    "NHÔNG - SÊN - DĨA": 463,
    "CĂM XE MÁY": 467,
    "MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)": 472,
    "LỌC GIÓ": 477,
    "PHỤ GIA - NHỚT": 480,
    "BỐ THẮNG": 482,
    "VỎ XE - NIỀNG XE": 485,
    "DÂY CÁP": 488,
    "PHÂN KHỐI LỚN": 494,
    "CHÉN CỔ": 500,
    "PHỤ KIỆN KHÁC": 501
}

brand_map = {
    "MTX": 60, "Malossi": 61, "Motobatt": 62, "Senarc": 63, "Yaguso": 64, 
    "CRG": 65, "Tan Lan": 66, "Orange": 67, "FKR": 68, "Faito": 69, 
    "RGV": 70, "Apido": 71, "YSS": 72, "FMF": 73, "TR Tiller": 74, 
    "CT Cytracing": 75, "Kozi": 76
}

def get_attribute_name(variant_name, category_name):
    vn_lower = variant_name.lower()
    if 'g' in vn_lower and any(c in vn_lower for c in '0123456789'):
        return "Trọng lượng"
    if 't' in vn_lower and any(c in vn_lower for c in '0123456789'):
        return "Thông số"
    if 'x' in vn_lower or '/' in vn_lower or '-' in vn_lower:
        if category_name == "LỌC GIÓ" or category_name == "CHÉN CỔ":
            return "Loại xe"
        return "Kích thước"
    if 'ah' in vn_lower:
        return "Dung lượng"
    if 'l' in vn_lower and any(c in vn_lower for c in '0123456789'):
        return "Dung tích"
    if any(pos in vn_lower for pos in ['trước', 'sau', 'cả bộ']):
        return "Vị trí"
    if any(length in vn_lower for length in ['tiêu chuẩn', 'dài hơn']):
        return "Chiều dài"
    if any(ver in vn_lower for ver in ['standard', 'racing', 'limited']):
        return "Phiên bản"
    if any(color in vn_lower for color in ['vàng', 'đỏ', 'xanh', 'bạc', 'đen']):
        return "Màu sắc"
    return "Thông số"

with open('F:/DACS/generated_products_v2.txt', 'r', encoding='utf-8') as f:
    content = f.read()

# Use regex to find products
raw_products = re.split(r'Sản phẩm \d+:', content)
products = []

for rp in raw_products[1:]:
    lines = rp.strip().split('\n')
    p = {}
    variants = []
    in_variants = False
    
    for line in lines:
        line = line.strip()
        if not line: continue
        if line.startswith('- Tên:'):
            p['name'] = line.replace('- Tên:', '').strip()
        elif line.startswith('- Danh mục:'):
            p['category'] = line.replace('- Danh mục:', '').strip()
        elif line.startswith('- Thương hiệu:'):
            p['brand'] = line.replace('- Thương hiệu:', '').strip()
        elif line.startswith('- Giá gốc:'):
            p['orig_price'] = parse_price(line.replace('- Giá gốc:', '').strip())
        elif line.startswith('- Giá bán:'):
            p['price'] = parse_price(line.replace('- Giá bán:', '').strip())
        elif line.startswith('- Kho:'):
            p['stock'] = parse_int(line.replace('- Kho:', '').strip())
        elif line.startswith('- SKU:'):
            p['sku'] = line.replace('- SKU:', '').strip()
        elif line.startswith('- Ảnh chính:'):
            p['main_img'] = line.replace('- Ảnh chính:', '').strip()
        elif line.startswith('- Ảnh phụ:'):
            p['extra_imgs'] = [img.strip() for img in line.replace('- Ảnh phụ:', '').split(',') if img.strip()]
        elif line.startswith('- Variants:'):
            in_variants = True
        elif line.startswith('- Mô tả HTML:'):
            in_variants = False
            p['desc'] = line.replace('- Mô tả HTML:', '').strip()
        elif in_variants and line.startswith('+'):
            try:
                parts = line.replace('+', '').split(' - ')
                if len(parts) >= 4:
                    v = {
                        'name': parts[0].strip(),
                        'price': parse_price(parts[1].strip()),
                        'sku': parts[2].strip(),
                        'stock': parse_int(parts[3].strip())
                    }
                    variants.append(v)
            except:
                pass
    
    p['variants'] = variants
    if 'category' in p:
        products.append(p)

sql = []
sql.append("USE [MotorcycleShopDB]")
sql.append("GO")
sql.append("BEGIN TRANSACTION")
sql.append("GO")

all_attributes = set()
for p in products:
    for v in p['variants']:
        all_attributes.add(get_attribute_name(v['name'], p['category']))

for attr in sorted(list(all_attributes)):
    sql.append(f"IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'{attr}') INSERT INTO ProductAttributes (AttributeName) VALUES (N'{attr}');")

sql.append("GO")

for p in products:
    cat_id = category_map.get(p['category'], 'NULL')
    brand_id = brand_map.get(p['brand'], 'NULL')
    
    p_name = p['name'].replace("'", "''")
    p_desc = p['desc'].replace("'", "''")
    
    sql.append(f"-- Product: {p_name}")
    sql.append(f"DECLARE @Pid INT, @Vid INT, @Aid INT, @Valid INT;")
    sql.append(f"INSERT INTO Products (ProductName, CategoryId, BrandId, Description, ImageUrl, OriginalPrice, Price, Stock, SKU, CreatedDate)")
    sql.append(f"VALUES (N'{p_name}', {cat_id}, {brand_id}, N'{p_desc}', N'{p['main_img']}', {p['orig_price']}, {p['price']}, {p['stock']}, N'{p['sku']}', GETDATE());")
    sql.append("SET @Pid = SCOPE_IDENTITY();")
    
    sql.append(f"INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'{p['main_img']}', 1, 0);")
    for i, img in enumerate(p['extra_imgs']):
        sql.append(f"INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@Pid, N'{img}', 0, {i+1});")
    
    for v in p['variants']:
        v_name = v['name'].replace("'", "''")
        attr_name = get_attribute_name(v['name'], p['category'])
        sql.append(f"INSERT INTO ProductVariants (ProductId, SKU, VariantName, Price, OriginalPrice, StockQuantity, ImageUrl)")
        sql.append(f"VALUES (@Pid, N'{v['sku']}', N'{v_name}', {v['price']}, {p['orig_price']}, {v['stock']}, N'{p['main_img']}');")
        sql.append("SET @Vid = SCOPE_IDENTITY();")
        
        sql.append(f"SET @Aid = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'{attr_name}');")
        sql.append(f"IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'{v_name}') INSERT INTO AttributeValues (AttributeId, Value) VALUES (@Aid, N'{v_name}');")
        sql.append(f"SET @Valid = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @Aid AND Value = N'{v_name}');")
        sql.append(f"INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@Vid, @Valid);")

    sql.append("GO")

sql.append("COMMIT TRANSACTION")
sql.append("GO")

with open('F:/DACS/final_import_v2.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(sql))

print(f"Processed {len(products)} products.")
print(f"Total variants: {sum(len(p['variants']) for p in products)}")
