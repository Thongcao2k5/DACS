-- SCRIPT CẬP NHẬT DANH MỤC MỚI CHO MOTOSHOP
-- Cảnh báo: Script này sẽ xóa các danh mục cũ. Nếu có sản phẩm đang liên kết, hãy cập nhật ProductId trước.
USE MotorcycleShopDB;
GO
BEGIN TRANSACTION;

-- 1. Xóa dữ liệu cũ (Xóa bảng con trước nếu cần, hoặc set null Product.CategoryId)
UPDATE Products SET CategoryId = NULL;
DELETE FROM Categories;

-- Khai báo biến lưu ID cha
DECLARE @ParentId INT;

-- 1. BỘ NỒI XE TAY GA
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỘ NỒI XE TAY GA', 'bo-noi-xe-tay-ga', 'bx-cycling', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi trước', 'bo-noi-truoc', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bộ nồi sau', 'bo-noi-sau', @ParentId, 1);

-- 2. NHÔNG - SÊN - DĨA
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'NHÔNG - SÊN - DĨA', 'nhong-sen-dia', 'bx-loader-circle', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Combo 2 món', 'combo-2-mon', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Combo 3 món', 'combo-3-mon', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Sên', 'sen', @ParentId, 1);

-- 3. CĂM XE MÁY
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'CĂM XE MÁY', 'cam-xe-may', 'bx-unite', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Căm số 9', 'cam-so-9', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Căm số 10', 'cam-so-10', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Căm số 9-10', 'cam-so-9-10', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Căm Diamond', 'cam-diamond', @ParentId, 1);

-- 4. MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)', 'may-sac-binh-dien', 'bx-battery', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bình điện GEL', 'binh-dien-gel', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bình điện khô', 'binh-dien-kho', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bình điện phân khối lớn', 'binh-dien-pkl', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Máy sạc - phụ kiện', 'may-sac-phu-kien', @ParentId, 1);

-- 5. LỌC GIÓ
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'LỌC GIÓ', 'loc-gio', 'bx-wind', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc gió Honda', 'loc-gio-honda', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc gió Yamaha', 'loc-gio-yamaha', @ParentId, 1);

-- 6. PHỤ GIA - NHỚT
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHỤ GIA - NHỚT', 'phu-gia-nhot', 'bx-droplet', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Nhớt 4 thì', 'nhot-4-thi', @ParentId, 1);

-- 7. BỐ THẮNG
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'BỐ THẮNG', 'bo-thang', 'bx-disc', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bố thắng đùm', 'bo-thang-dum', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bố thắng đĩa', 'bo-thang-dia', @ParentId, 1);

-- 8. VỎ XE - NIỀNG XE
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'VỎ XE - NIỀNG XE', 'vo-xe-nieng-xe', 'bx-target-lock', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bánh trước', 'banh-truoc', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bánh sau', 'banh-sau', @ParentId, 1);

-- 9. DÂY CÁP
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'DÂY CÁP', 'day-cap', 'bx-git-commit', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dây thắng', 'day-thang', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dây côn', 'day-con', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dây ga', 'day-ga', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dây e', 'day-e', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dây đồng hồ', 'day-dong-ho', @ParentId, 1);

-- 10. PHÂN KHỐI LỚN
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHÂN KHỐI LỚN', 'phan-khoi-lon', 'bx-rocket', 1);
SET @ParentId = SCOPE_IDENTITY();
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bố thắng đĩa PKL', 'bo-thang-dia-pkl', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dĩa tải - nhông tải', 'dia-tai-nhong-tai', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dĩa thắng', 'dia-thang', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lọc nhớt', 'loc-nhot', @ParentId, 1);
INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Sên PKL', 'sen-pkl', @ParentId, 1);

-- 11. CHÉN CỔ
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'CHÉN CỔ', 'chen-co', 'bx-shape-circle', 1);

-- 12. PHỤ KIỆN KHÁC
INSERT INTO Categories (CategoryName, Slug, Icon, IsActive) VALUES (N'PHỤ KIỆN KHÁC', 'phu-kien-khac', 'bx-box', 1);

COMMIT;
SELECT * FROM Categories;
