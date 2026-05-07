-- SCRIPT CẬP NHẬT THƯƠNG HIỆU MỚI CHO MOTOSHOP
-- Cảnh báo: Script này sẽ xóa các thương hiệu cũ và cập nhật bộ dữ liệu mới chuyên nghiệp.
USE MotorcycleShopDB;
GO
BEGIN TRANSACTION;

-- 1. Xử lý ràng buộc: Set NULL cho Product.BrandId để tránh lỗi khóa ngoại khi xóa Brand
UPDATE Products SET BrandId = NULL;

-- 2. Xóa toàn bộ thương hiệu cũ
DELETE FROM Brands;

-- 3. Thêm bộ dữ liệu thương hiệu mới (Logo + Mô tả chi tiết)
INSERT INTO Brands (BrandName, LogoUrl, Description)
VALUES 
(N'Malossi', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Malossi_logo.svg/1200px-Malossi_logo.svg.png', 
 N'Xuất xứ: Italy. Thương hiệu hàng đầu thế giới chuyên về bộ nồi, xy-lanh và hệ thống truyền động hiệu năng cao cho xe tay ga.'),

(N'Motobatt', 'https://www.motobatt.com/image/catalog/logo.png', 
 N'Xuất xứ: USA. Nhà tiên phong trong công nghệ ắc quy Gel QuadFlex độc quyền, đảm bảo khởi động mạnh mẽ và độ bền gấp đôi.'),

(N'CRG', 'https://constructorsrg.com/templates/beez3/images/logo.png', 
 N'Xuất xứ: USA. Chuyên về các phụ kiện điều khiển cao cấp như tay thắng, tay côn CNC và gương chiếu hậu cho xe phân khối lớn.'),

(N'Yaguso', 'https://yaguso.com/wp-content/uploads/2021/05/logo-yaguso.png', 
 N'Xuất xứ: Thailand. Nổi tiếng với công nghệ mạ chrome 3 lớp trên các dòng căm (nan hoa) và niềng xe máy siêu bền.'),

(N'MTX', 'https://www.mtx.com/c/mtx-theme/images/logo-mtx.png', 
 N'Xuất xứ: Global. Tập trung vào các giải pháp truyền động bền bỉ, nhông sên dĩa MTX giúp xe vận hành êm ái và ổn định.'),

(N'CYT', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_cyt.png', 
 N'Xuất xứ: Taiwan. Thương hiệu vỏ xe (lốp) và phụ tùng thay thế chất lượng cao, phù hợp với mọi điều kiện địa hình.'),

(N'TR', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_tr.png', 
 N'Xuất xứ: Malaysia. TR Performance chuyên về các dòng nhông dĩa hợp kim siêu nhẹ cho các tín đồ tốc độ và độ xe chuyên nghiệp.'),

(N'Orange', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_orange.png', 
 N'Xuất xứ: Vietnam/Thailand. Thương hiệu nhông sên dĩa quốc dân với chất lượng nhiệt luyện kỹ càng và giá thành hợp lý.'),

(N'Kozi', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_kozi.png', 
 N'Xuất xứ: Malaysia. Nổi tiếng với các dòng pô độ, két nước tản nhiệt và xy-lanh nâng cấp công suất máy.'),

(N'RGV', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_rgv.png', 
 N'Xuất xứ: Malaysia. Chuyên cung cấp linh kiện máy và phụ tùng thay thế chuẩn xác cho các dòng xe 2 thì huyền thoại.'),

(N'Apido', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_apido.png', 
 N'Xuất xứ: Malaysia. Thương hiệu racing trẻ trung với các dòng giảm xóc (phuộc) và phụ kiện nhôm CNC màu sắc bắt mắt.'),

(N'Yaz125R', 'https://theme.hstatic.net/1000282430/1000910168/14/logo_brand_yaz.png', 
 N'Xuất xứ: Malaysia. Danh mục chuyên biệt cho các phụ tùng nâng cấp và linh kiện máy dành riêng cho Yamaha Z125.');

COMMIT;

-- Kiểm tra kết quả
SELECT * FROM Brands;
