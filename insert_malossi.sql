-- SCRIPT NHẬP DỮ LIỆU CHUẨN (MOTO-SHOP STYLE)
-- Sản phẩm: Bi nồi Vision Malossi (Full size)

BEGIN TRANSACTION;
BEGIN TRY
    -- 1. PRODUCT (1 sản phẩm duy nhất)
    INSERT INTO Products (ProductName, CategoryId, BrandId, Slug, Description, IsActive, IsFeatured, IsDeleted, CreatedDate)
    VALUES (
        N'Bi nồi Vision 2011-2023 Malossi cao cấp (Full size)',
        -- CategoryId: Bộ nồi trước (Dựa trên ID 191 hoặc tìm kiếm lại)
        (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName LIKE N'%nồi trước%'),
        -- BrandId: Malossi
        (SELECT BrandId FROM Brands WHERE BrandName = N'Malossi'),
        'bi-noi-vision-malossi-full-size',
        N'<h2>Bi nồi Malossi cao cấp cho Honda Vision</h2>
        <p>Bi nồi Malossi là dòng sản phẩm hiệu năng cao đến từ Italy, giúp cải thiện rõ rệt khả năng tăng tốc, giảm độ ì của xe và mang lại trải nghiệm lái mượt mà hơn.</p>
        <h3>Ưu điểm nổi bật</h3>
        <ul>
        <li>Tăng tốc nhanh, đề-pa bốc</li>
        <li>Giảm rung giật khi vận hành</li>
        <li>Chất liệu PA66 + sợi carbon siêu bền</li>
        <li>Tuổi thọ cao hơn bi zin 2-3 lần</li>
        </ul>
        <h3>Ứng dụng</h3>
        <p>Phù hợp cho các dòng xe Honda Vision, Air Blade, Lead, Vario.</p>
        <h3>Lưu ý</h3>
        <p>Nên chọn đúng trọng lượng bi để phù hợp nhu cầu sử dụng (đề-pa mạnh hoặc chạy hậu).</p>',
        1, -- IsActive
        0, -- IsFeatured
        0, -- IsDeleted
        GETDATE()
    );

    DECLARE @ProductId INT = SCOPE_IDENTITY();

    -- 2. VARIANTS (biến thể trọng lượng + giá)
    INSERT INTO ProductVariants (ProductId, VariantName, Price, OriginalPrice, SKU, StockQuantity, CreatedDate, CostPrice)
    VALUES
    (@ProductId, N'9 gram', 140000, 180000, 'MAL-VIS-09G', 50, GETDATE(), 100000),
    (@ProductId, N'10 gram', 145000, 185000, 'MAL-VIS-10G', 45, GETDATE(), 105000),
    (@ProductId, N'11 gram', 150000, 190000, 'MAL-VIS-11G', 40, GETDATE(), 110000),
    (@ProductId, N'12 gram', 155000, 195000, 'MAL-VIS-12G', 35, GETDATE(), 115000),
    (@ProductId, N'13 gram', 160000, 200000, 'MAL-VIS-13G', 30, GETDATE(), 120000),
    (@ProductId, N'14 gram', 165000, 210000, 'MAL-VIS-14G', 25, GETDATE(), 125000);

    -- 3. ATTRIBUTES (Cần khớp với schema chuẩn: ProductAttributes -> AttributeValues -> ProductVariantAttributeValue)
    -- Đảm bảo có thuộc tính 'Trọng lượng'
    IF NOT EXISTS (SELECT 1 FROM ProductAttributes WHERE AttributeName = N'Trọng lượng')
        INSERT INTO ProductAttributes (AttributeName) VALUES (N'Trọng lượng');
    
    DECLARE @AttrId INT = (SELECT AttributeId FROM ProductAttributes WHERE AttributeName = N'Trọng lượng');

    -- Link từng variant với giá trị thuộc tính tương ứng
    DECLARE @VariantId INT, @VName NVARCHAR(510);
    DECLARE variant_cursor CURSOR FOR 
    SELECT ProductVariantId, VariantName FROM ProductVariants WHERE ProductId = @ProductId;

    OPEN variant_cursor;
    FETCH NEXT FROM variant_cursor INTO @VariantId, @VName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Thêm giá trị vào AttributeValues nếu chưa có
        IF NOT EXISTS (SELECT 1 FROM AttributeValues WHERE AttributeId = @AttrId AND Value = @VName)
            INSERT INTO AttributeValues (AttributeId, Value) VALUES (@AttrId, @VName);
        
        DECLARE @ValueId INT = (SELECT ValueId FROM AttributeValues WHERE AttributeId = @AttrId AND Value = @VName);

        -- Link Variant với Value
        INSERT INTO ProductVariantAttributeValue (ProductVariantId, ValueId) VALUES (@VariantId, @ValueId);

        FETCH NEXT FROM variant_cursor INTO @VariantId, @VName;
    END;

    CLOSE variant_cursor;
    DEALLOCATE variant_cursor;

    -- 4. ẢNH SẢN PHẨM
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder)
    VALUES
    (@ProductId, '/assets/img/products/malossi-roller-main.jpg', 1, 0),
    (@ProductId, '/assets/img/products/malossi-roller-1.jpg', 0, 1),
    (@ProductId, '/assets/img/products/malossi-roller-2.jpg', 0, 2),
    (@ProductId, '/assets/img/products/malossi-roller-3.jpg', 0, 3);

    PRINT 'Da nhap san pham Malossi voi day du bien the va thuoc tinh thanh cong.';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Loi nhap lieu: ' + ERROR_MESSAGE();
END CATCH;
