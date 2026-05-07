USE MotorcycleShopDB;
GO
BEGIN TRANSACTION;

-- Clear old brands
UPDATE Products SET BrandId = NULL;
DELETE FROM Brands;

-- Insert new brands
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'MTX', '/logo/mtx.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Malossi', '/logo/malossi.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Motobatt', '/logo/motobatt.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Senarc', '/logo/senarc.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Yaguso', '/logo/yaguso.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'CRG', '/logo/crg.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Tan Lan', '/logo/tan_lan.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Orange', '/logo/orange.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'FKR', '/logo/fkr.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Faito', '/logo/faito.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'RGV', '/logo/rgv.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Apido', '/logo/apido.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'YSS', '/logo/yss.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'FMF', '/logo/fmf.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'TR Tiller', '/logo/tr_tiller.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'CT Cytracing', '/logo/ct_cytracing.png');
INSERT INTO Brands (BrandName, LogoUrl) VALUES (N'Kozi', '/logo/kozi.png');

COMMIT;
SELECT BrandId, BrandName FROM Brands;
