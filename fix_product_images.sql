-- ============================================================
-- fix_product_images.sql
-- Fix broken hotlink-blocked image URLs in MotoShop DB
-- Run once in SSMS against MotoShopDb
-- ============================================================

-- ============================================================
-- 1. ProductImages table
-- ============================================================

-- P2: Dầu nhớt Motul 5100 10W40 4T
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/motul5100-main/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/motul5100-side/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/motul5100-pack/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'dau-nhot-motul-5100-10w40-4t';

-- P3: Dầu nhớt Liqui Moly Motorbike 4T 10W40
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/liquimoly-800ml/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/liquimoly-1l/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/liquimoly-4l/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'dau-nhot-liqui-moly-motorbike-4t-10w40';

-- P4: Lốp xe Michelin Pilot Street 2
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/michelin-ps2-main/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/michelin-ps2-tread/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/michelin-ps2-side/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'lop-xe-michelin-pilot-street-2';

-- P5: Má phanh Brembo P07
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/brembo-p07-front/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/brembo-p07-rear/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/brembo-p07-detail/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'ma-phanh-brembo-p07';

-- P6: Dầu phanh Brembo DOT 4
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/brembo-dot4-500ml/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/brembo-dot4-250ml/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'dau-phanh-brembo-dot-4';

-- P7: Lọc dầu Honda chính hãng
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/honda-locdau-main/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/honda-locdau-box/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/honda-locdau-compare/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'loc-dau-honda-chinh-hang';

-- P8: Bugi NGK CR7HSA
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/ngk-cr7hsa-main/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/ngk-cr7hsa-box/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/ngk-cr7hsa-install/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'bugi-ngk-cr7hsa-standard';

-- P9: Giảm xóc sau YSS G-Plus
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/yss-gplus-main/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/yss-gplus-side/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/yss-gplus-detail/640/640'
        WHEN 4 THEN 'https://picsum.photos/seed/yss-gplus-install/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'giam-xoc-sau-yss-g-plus';

-- P10: Giảm xóc Ohlins S36E
UPDATE pi SET pi.ImageUrl =
    CASE pi.DisplayOrder
        WHEN 1 THEN 'https://picsum.photos/seed/ohlins-s36e-main/640/640'
        WHEN 2 THEN 'https://picsum.photos/seed/ohlins-s36e-detail1/640/640'
        WHEN 3 THEN 'https://picsum.photos/seed/ohlins-s36e-detail2/640/640'
        WHEN 4 THEN 'https://picsum.photos/seed/ohlins-s36e-pack/640/640'
        ELSE pi.ImageUrl
    END
FROM ProductImages pi
JOIN Products p ON pi.ProductId = p.ProductId
WHERE p.Slug = 'giam-xoc-ohlins-s36e';

-- ============================================================
-- 2. ProductVariants.ImageUrl — update by SKU
-- ============================================================

-- Motul 5100
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/motul5100-main/640/640' WHERE SKU = 'MOTUL-5100-1L';
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/motul5100-pack/640/640'  WHERE SKU = 'MOTUL-5100-4L';

-- Liqui Moly
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/liquimoly-800ml/640/640' WHERE SKU = 'LIQMO-4T-800ML';
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/liquimoly-1l/640/640'    WHERE SKU = 'LIQMO-4T-1L';
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/liquimoly-4l/640/640'    WHERE SKU = 'LIQMO-4T-4L';

-- Michelin Pilot Street 2
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/michelin-ps2-main/640/640' WHERE SKU IN ('MICH-PS2-7090-17','MICH-PS2-8090-17','MICH-PS2-9080-17','MICH-PS2-10080-17');

-- Brembo P07
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/brembo-p07-front/640/640' WHERE SKU = 'BRBO-P07-FRONT';
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/brembo-p07-rear/640/640'  WHERE SKU = 'BRBO-P07-REAR';

-- Brembo DOT 4
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/brembo-dot4-250ml/640/640' WHERE SKU = 'BRBO-DOT4-250ML';
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/brembo-dot4-500ml/640/640' WHERE SKU = 'BRBO-DOT4-500ML';

-- Honda lọc dầu
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/honda-locdau-main/640/640' WHERE SKU IN ('HON-LOCDAU-WAVE','HON-LOCDAU-WNX','HON-LOCDAU-AB');

-- NGK CR7HSA
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/ngk-cr7hsa-main/640/640' WHERE SKU = 'NGK-CR7HSA-1';
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/ngk-cr7hsa-box/640/640'  WHERE SKU = 'NGK-CR7HSA-4';

-- YSS G-Plus
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/yss-gplus-main/640/640' WHERE SKU IN ('YSS-GP-EXC155','YSS-GP-WNX','YSS-GP-NVX');

-- Ohlins S36E
UPDATE ProductVariants SET ImageUrl = 'https://picsum.photos/seed/ohlins-s36e-main/640/640' WHERE SKU IN ('OHL-S36E-EXC155','OHL-S36E-WNX');

-- ============================================================
-- Verify
-- ============================================================
SELECT TOP 20
    p.ProductName,
    pi.ImageUrl AS PrimaryImage,
    pi.IsPrimary
FROM Products p
LEFT JOIN ProductImages pi ON pi.ProductId = p.ProductId AND pi.IsPrimary = 1
ORDER BY p.ProductId;
