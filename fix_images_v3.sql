SET NOCOUNT ON;
GO

PRINT N'>>> V3 - bắt đầu cập nhật ảnh...';

/* =========================================================================
   TẦNG 1: OVERRIDE - URL CDN chính thức
   ========================================================================= */
PRINT N'  [TẦNG 1] Áp dụng URL CDN chính thức...';

WITH Overrides AS (
    SELECT Pattern, ImageUrl FROM (VALUES
        (N'%Motul%7100%',   N'https://azupim01.motul.com/media/motulData/IM/bigweb/Motul_104091_7100%2010W40%204T%2012X1L_png.png'),
        (N'%Motul%5100%',   N'https://azupim01.motul.com/media/motulData/IM/bigweb/MOTUL_104066_5100%2010W40%204T%201L_NEW_png.png'),
        (N'%Liqui%Moly%',   N'https://www.liqui-moly.com/media/catalog/product/cache/70e976b945366b83018558b78d25a373/2/0/20056_Motorbike_4T_10W_40_Street_4l_6055.png')
    ) AS X(Pattern, ImageUrl)
)
UPDATE pi
SET pi.ImageUrl = ovr.ImageUrl
FROM ProductImages pi
INNER JOIN Products p ON p.ProductId = pi.ProductId
CROSS APPLY (SELECT TOP 1 ImageUrl FROM Overrides WHERE p.ProductName LIKE Overrides.Pattern) ovr;
PRINT N'    Tier1 ProductImages: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';

WITH Overrides AS (
    SELECT Pattern, ImageUrl FROM (VALUES
        (N'%Motul%7100%',   N'https://azupim01.motul.com/media/motulData/IM/bigweb/Motul_104091_7100%2010W40%204T%2012X1L_png.png'),
        (N'%Motul%5100%',   N'https://azupim01.motul.com/media/motulData/IM/bigweb/MOTUL_104066_5100%2010W40%204T%201L_NEW_png.png'),
        (N'%Liqui%Moly%',   N'https://www.liqui-moly.com/media/catalog/product/cache/70e976b945366b83018558b78d25a373/2/0/20056_Motorbike_4T_10W_40_Street_4l_6055.png')
    ) AS X(Pattern, ImageUrl)
)
UPDATE vi SET vi.ImageUrl = ovr.ImageUrl
FROM VariantImages vi
INNER JOIN ProductVariants pv ON pv.ProductVariantId = vi.ProductVariantId
INNER JOIN Products p ON p.ProductId = pv.ProductId
CROSS APPLY (SELECT TOP 1 ImageUrl FROM Overrides WHERE p.ProductName LIKE Overrides.Pattern) ovr;
PRINT N'    Tier1 VariantImages: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';

WITH Overrides AS (
    SELECT Pattern, ImageUrl FROM (VALUES
        (N'%Motul%7100%',   N'https://azupim01.motul.com/media/motulData/IM/bigweb/Motul_104091_7100%2010W40%204T%2012X1L_png.png'),
        (N'%Motul%5100%',   N'https://azupim01.motul.com/media/motulData/IM/bigweb/MOTUL_104066_5100%2010W40%204T%201L_NEW_png.png'),
        (N'%Liqui%Moly%',   N'https://www.liqui-moly.com/media/catalog/product/cache/70e976b945366b83018558b78d25a373/2/0/20056_Motorbike_4T_10W_40_Street_4l_6055.png')
    ) AS X(Pattern, ImageUrl)
)
UPDATE pv SET pv.ImageUrl = ovr.ImageUrl
FROM ProductVariants pv
INNER JOIN Products p ON p.ProductId = pv.ProductId
CROSS APPLY (SELECT TOP 1 ImageUrl FROM Overrides WHERE p.ProductName LIKE Overrides.Pattern) ovr;
PRINT N'    Tier1 ProductVariants: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';
GO

/* =========================================================================
   TẦNG 2: LOREMFLICKR - brand + model + category keyword
   ========================================================================= */
PRINT N'  [TẦNG 2] Loremflickr cho SP còn lại...';

UPDATE pi SET pi.ImageUrl =
    N'https://loremflickr.com/800/600/' +
    ISNULL(LOWER(REPLACE(REPLACE(b.BrandName,N' ',N''),N'-',N'')) + N',', N'') +
    CASE
        WHEN p.ProductName LIKE N'%7100%'         THEN N'7100,'
        WHEN p.ProductName LIKE N'%5100%'         THEN N'5100,'
        WHEN p.ProductName LIKE N'%POWER 1%' OR p.ProductName LIKE N'%Power 1%'   THEN N'power1,'
        WHEN p.ProductName LIKE N'%ACTIV%'        THEN N'activ,'
        WHEN p.ProductName LIKE N'%MAGNATEC%'     THEN N'magnatec,'
        WHEN p.ProductName LIKE N'%Pilot Street%' THEN N'pilotstreet,'
        WHEN p.ProductName LIKE N'%City Grip%'    THEN N'citygrip,'
        WHEN p.ProductName LIKE N'%Power Pure%'   THEN N'powerpure,'
        WHEN p.ProductName LIKE N'%K1%'           THEN N'k1,'
        WHEN p.ProductName LIKE N'%K3%'           THEN N'k3,'
        WHEN p.ProductName LIKE N'%Pista%'        THEN N'pista,'
        WHEN p.ProductName LIKE N'%CR7HSA%'       THEN N'cr7hsa,'
        WHEN p.ProductName LIKE N'%YTX7A%'        THEN N'ytx7a,'
        WHEN p.ProductName LIKE N'%YB9%'          THEN N'yb9,'
        WHEN p.ProductName LIKE N'%YTZ10%'        THEN N'ytz10,'
        WHEN p.ProductName LIKE N'%P07%'          THEN N'p07,'
        WHEN p.ProductName LIKE N'%DOT 4%' OR p.ProductName LIKE N'%DOT4%' THEN N'dot4,'
        WHEN p.ProductName LIKE N'%G-Plus%'       THEN N'gplus,'
        WHEN p.ProductName LIKE N'%S36E%'         THEN N's36,'
        WHEN p.ProductName LIKE N'%Wave Alpha%'   THEN N'wavealpha,'
        WHEN p.ProductName LIKE N'%CBR150%'       THEN N'cbr150,'
        WHEN p.ProductName LIKE N'%Exciter 150%'  THEN N'exciter150,'
        WHEN p.ProductName LIKE N'%Exciter 155%'  THEN N'exciter155,'
        WHEN p.ProductName LIKE N'%Vario%'        THEN N'vario,'
        ELSE N''
    END +
    CASE
        WHEN p.ProductName LIKE N'%dầu phanh%' OR p.ProductName LIKE N'%DOT %'    THEN N'brake,fluid'
        WHEN p.ProductName LIKE N'%má phanh%' OR p.ProductName LIKE N'%bố thắng%' THEN N'brakepad,motorcycle'
        WHEN p.ProductName LIKE N'%nhớt%' OR p.ProductName LIKE N'%motor oil%'    THEN N'engineoil,bottle'
        WHEN p.ProductName LIKE N'%dầu%'                                          THEN N'oil,bottle'
        WHEN p.ProductName LIKE N'%lốp%'                                          THEN N'motorcycle,tire'
        WHEN p.ProductName LIKE N'%mũ%' OR p.ProductName LIKE N'%helmet%'         THEN N'fullface,helmet'
        WHEN p.ProductName LIKE N'%ắc quy%' OR p.ProductName LIKE N'%battery%'    THEN N'motorcycle,battery'
        WHEN p.ProductName LIKE N'%bugi%'                                         THEN N'sparkplug'
        WHEN p.ProductName LIKE N'%lọc dầu%'                                     THEN N'oilfilter'
        WHEN p.ProductName LIKE N'%lọc gió%'                                     THEN N'airfilter'
        WHEN p.ProductName LIKE N'%nhông%' OR p.ProductName LIKE N'%xích%'        THEN N'chain,sprocket'
        WHEN p.ProductName LIKE N'%giảm xóc%' OR p.ProductName LIKE N'%phuộc%'   THEN N'shockabsorber,motorcycle'
        WHEN p.ProductName LIKE N'%đèn%' OR p.ProductName LIKE N'%LED%'           THEN N'motorcycle,headlight'
        WHEN p.ProductName LIKE N'%gương%'                                        THEN N'motorcycle,mirror'
        WHEN p.ProductName LIKE N'%bao tay%'                                      THEN N'motorcycle,grip'
        ELSE N'motorcycle,parts'
    END
    + N'?lock=p' + CAST(pi.ImageId AS NVARCHAR(10))
FROM ProductImages pi
INNER JOIN Products p ON p.ProductId = pi.ProductId
LEFT  JOIN Brands  b ON b.BrandId  = p.BrandId
WHERE pi.ImageUrl NOT LIKE N'%azupim01.motul.com%'
  AND pi.ImageUrl NOT LIKE N'%liqui-moly.com%';
PRINT N'    Tier2 ProductImages: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';

UPDATE vi SET vi.ImageUrl =
    N'https://loremflickr.com/800/600/' +
    ISNULL(LOWER(REPLACE(REPLACE(b.BrandName,N' ',N''),N'-',N'')) + N',', N'') +
    CASE
        WHEN p.ProductName LIKE N'%dầu phanh%' OR p.ProductName LIKE N'%DOT %'    THEN N'brake,fluid'
        WHEN p.ProductName LIKE N'%má phanh%' OR p.ProductName LIKE N'%bố thắng%' THEN N'brakepad,motorcycle'
        WHEN p.ProductName LIKE N'%nhớt%'                                         THEN N'engineoil,bottle'
        WHEN p.ProductName LIKE N'%dầu%'                                          THEN N'oil,bottle'
        WHEN p.ProductName LIKE N'%lốp%'                                          THEN N'motorcycle,tire'
        WHEN p.ProductName LIKE N'%mũ%' OR p.ProductName LIKE N'%helmet%'         THEN N'fullface,helmet'
        WHEN p.ProductName LIKE N'%ắc quy%' OR p.ProductName LIKE N'%battery%'    THEN N'motorcycle,battery'
        WHEN p.ProductName LIKE N'%bugi%'                                         THEN N'sparkplug'
        WHEN p.ProductName LIKE N'%lọc%'                                          THEN N'filter,engine'
        WHEN p.ProductName LIKE N'%nhông%' OR p.ProductName LIKE N'%xích%'        THEN N'chain,sprocket'
        WHEN p.ProductName LIKE N'%giảm xóc%'                                    THEN N'shockabsorber,motorcycle'
        WHEN p.ProductName LIKE N'%đèn%' OR p.ProductName LIKE N'%LED%'           THEN N'motorcycle,headlight'
        WHEN p.ProductName LIKE N'%gương%'                                        THEN N'motorcycle,mirror'
        WHEN p.ProductName LIKE N'%bao tay%'                                      THEN N'motorcycle,grip'
        ELSE N'motorcycle,parts'
    END
    + N'?lock=v' + CAST(vi.VariantImageId AS NVARCHAR(10))
FROM VariantImages vi
INNER JOIN ProductVariants pv ON pv.ProductVariantId = vi.ProductVariantId
INNER JOIN Products p ON p.ProductId = pv.ProductId
LEFT  JOIN Brands  b ON b.BrandId  = p.BrandId
WHERE vi.ImageUrl NOT LIKE N'%azupim01.motul.com%'
  AND vi.ImageUrl NOT LIKE N'%liqui-moly.com%';
PRINT N'    Tier2 VariantImages: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';

UPDATE pv SET pv.ImageUrl =
    N'https://loremflickr.com/800/600/' +
    ISNULL(LOWER(REPLACE(REPLACE(b.BrandName,N' ',N''),N'-',N'')) + N',', N'') +
    CASE
        WHEN p.ProductName LIKE N'%dầu phanh%' OR p.ProductName LIKE N'%DOT %'    THEN N'brake,fluid'
        WHEN p.ProductName LIKE N'%má phanh%' OR p.ProductName LIKE N'%bố thắng%' THEN N'brakepad'
        WHEN p.ProductName LIKE N'%nhớt%'                                         THEN N'engineoil,bottle'
        WHEN p.ProductName LIKE N'%dầu%'                                          THEN N'oil,bottle'
        WHEN p.ProductName LIKE N'%lốp%'                                          THEN N'motorcycle,tire'
        WHEN p.ProductName LIKE N'%mũ%' OR p.ProductName LIKE N'%helmet%'         THEN N'helmet,fullface'
        WHEN p.ProductName LIKE N'%ắc quy%' OR p.ProductName LIKE N'%battery%'    THEN N'battery'
        WHEN p.ProductName LIKE N'%bugi%'                                         THEN N'sparkplug'
        WHEN p.ProductName LIKE N'%lọc%'                                          THEN N'filter,engine'
        WHEN p.ProductName LIKE N'%giảm xóc%'                                    THEN N'shockabsorber'
        WHEN p.ProductName LIKE N'%đèn%' OR p.ProductName LIKE N'%LED%'           THEN N'motorcycle,headlight'
        WHEN p.ProductName LIKE N'%gương%'                                        THEN N'motorcycle,mirror'
        WHEN p.ProductName LIKE N'%bao tay%'                                      THEN N'motorcycle,grip'
        ELSE N'motorcycle,parts'
    END
    + N'?lock=t' + CAST(pv.ProductVariantId AS NVARCHAR(10))
FROM ProductVariants pv
INNER JOIN Products p ON p.ProductId = pv.ProductId
LEFT  JOIN Brands  b ON b.BrandId  = p.BrandId
WHERE pv.ImageUrl NOT LIKE N'%azupim01.motul.com%'
  AND pv.ImageUrl NOT LIKE N'%liqui-moly.com%';
PRINT N'    Tier2 ProductVariants: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';
GO

/* =========================================================================
   TẦNG 3: BRANDS - Logo Clearbit
   ========================================================================= */
PRINT N'  [TẦNG 3] Cập nhật logo thương hiệu...';

UPDATE Brands SET LogoUrl =
    CASE
        WHEN BrandName LIKE N'%Honda%'    THEN N'https://logo.clearbit.com/honda.com'
        WHEN BrandName LIKE N'%Yamaha%'   THEN N'https://logo.clearbit.com/yamaha-motor.com'
        WHEN BrandName LIKE N'%Motul%'    THEN N'https://logo.clearbit.com/motul.com'
        WHEN BrandName LIKE N'%Castrol%'  THEN N'https://logo.clearbit.com/castrol.com'
        WHEN BrandName LIKE N'%Liqui%'    THEN N'https://logo.clearbit.com/liqui-moly.com'
        WHEN BrandName LIKE N'%Michelin%' THEN N'https://logo.clearbit.com/michelin.com'
        WHEN BrandName LIKE N'%Brembo%'   THEN N'https://logo.clearbit.com/brembo.com'
        WHEN BrandName LIKE N'%NGK%'      THEN N'https://logo.clearbit.com/ngkntk.com'
        WHEN BrandName LIKE N'%Yuasa%'    THEN N'https://logo.clearbit.com/yuasa.co.uk'
        WHEN BrandName LIKE N'%AGV%'      THEN N'https://logo.clearbit.com/agv.com'
        WHEN BrandName LIKE N'%YSS%'      THEN N'https://logo.clearbit.com/yssracing.com'
        WHEN BrandName LIKE N'%Ohlins%' OR BrandName LIKE N'%hlins%' THEN N'https://logo.clearbit.com/ohlins.com'
        ELSE N'https://picsum.photos/seed/brand-' + CAST(BrandId AS NVARCHAR) + N'/300/300'
    END;
PRINT N'    Tier3 Brands: ' + CAST(@@ROWCOUNT AS NVARCHAR) + N' rows';
GO

/* =========================================================================
   VERIFY
   ========================================================================= */
SELECT
    p.ProductId,
    LEFT(p.ProductName, 40) AS ProductName,
    LEFT(pi.ImageUrl, 75)   AS ImageUrl,
    CASE
        WHEN pi.ImageUrl LIKE N'%azupim01.motul.com%' THEN N'CDN chinh hang'
        WHEN pi.ImageUrl LIKE N'%liqui-moly.com%'     THEN N'CDN chinh hang'
        WHEN pi.ImageUrl LIKE N'%loremflickr%'        THEN N'Loremflickr'
        ELSE N'Khac'
    END AS Source
FROM Products p
INNER JOIN ProductImages pi ON pi.ProductId = p.ProductId AND pi.IsPrimary = 1
ORDER BY p.ProductId;
GO
