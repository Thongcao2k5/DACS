-- 1. Xóa dữ liệu cũ nếu cần (tùy chọn)
-- DELETE FROM Blogs;
-- DELETE FROM BlogCategories;

-- 2. Chèn Danh mục tin tức
SET IDENTITY_INSERT BlogCategories ON;
INSERT INTO BlogCategories (Id, Name, Slug) VALUES (1, N'Kinh nghiệm', 'kinh-nghiem');
INSERT INTO BlogCategories (Id, Name, Slug) VALUES (2, N'Tin tức', 'tin-tuc');
INSERT INTO BlogCategories (Id, Name, Slug) VALUES (3, N'Sản phẩm mới', 'san-pham-moi');
SET IDENTITY_INSERT BlogCategories OFF;

-- 3. Chèn 5 bài viết mẫu
INSERT INTO Blogs (Title, Slug, Content, Thumbnail, CategoryId, Status, CreatedDate, IsPublished)
VALUES 
(N'Cách bảo dưỡng xe máy định kỳ để tăng tuổi thọ động cơ', 
 'cach-bao-duong-xe-may-dinh-ky', 
 N'<h4>Tại sao cần bảo dưỡng định kỳ?</h4><p>Việc bảo dưỡng xe máy định kỳ không chỉ giúp xe vận hành êm ái mà còn kéo dài tuổi thọ cho các bộ phận quan trọng như động cơ, hệ thống phanh và lốp xe. Dưới đây là các hạng mục bạn nên kiểm tra...</p><ul><li>Thay dầu nhớt mỗi 2.000km</li><li>Kiểm tra lọc gió mỗi 5.000km</li><li>Vệ sinh bugi và hệ thống phun xăng</li></ul>', 
 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800', 
 1, 1, GETDATE(), 1),

(N'Top 5 phụ tùng nâng cấp giúp xe chạy bốc hơn', 
 'top-5-phu-tung-nang-cap', 
 N'<h4>Nâng tầm trải nghiệm lái xe</h4><p>Bạn muốn chiếc xe của mình mạnh mẽ hơn? Hãy tham khảo ngay danh sách 5 món phụ tùng nâng cấp đáng đồng tiền bát gạo nhất hiện nay:</p><ol><li>Buggi Iridium giúp đánh lửa tốt hơn</li><li>Lọc gió độ (DNA, K&N)</li><li>Hệ thống ống xả hiệu năng cao</li><li>Nồi độ cho xe ga</li><li>IC/ECU mở tour</li></ol>', 
 'https://images.unsplash.com/photo-1599819811279-d5ad9cccf838?w=800', 
 3, 1, GETDATE(), 1),

(N'MotoShop chính thức ra mắt hệ thống đặt lịch sửa chữa Online', 
 'ra-mat-he-thong-dat-lich-online', 
 N'<h4>Tiện lợi và Nhanh chóng</h4><p>Từ ngày 15/05, MotoShop chính thức triển khai tính năng đặt lịch hẹn sửa chữa và bảo dưỡng trực tuyến trên website. Khách hàng giờ đây có thể chủ động chọn khung giờ và kỹ thuật viên mình mong muốn...</p><p>Sử dụng ngay tại mục "Dịch vụ" trên thanh menu!</p>', 
 'https://images.unsplash.com/photo-1615906659973-5a3636d221fe?w=800', 
 2, 1, GETDATE(), 1),

(N'Hướng dẫn chọn dầu nhớt phù hợp cho từng dòng xe Ga và xe Số', 
 'huong-dan-chon-dau-nhot-phu-hop', 
 N'<h4>Chọn đúng nhớt - Xe đi mượt</h4><p>Dầu nhớt được ví như "máu" của động cơ. Tuy nhiên không phải loại nhớt nào cũng dùng chung được cho mọi loại xe. Bạn cần lưu ý các chỉ số:</p><ul><li><strong>JASO MA/MA2:</strong> Dành cho xe số, xe côn tay.</li><li><strong>JASO MB:</strong> Dành cho xe tay ga.</li><li><strong>Độ nhớt:</strong> 10W40, 5W30...</li></ul>', 
 'https://images.unsplash.com/photo-1635843104390-3f451f28020d?w=800', 
 1, 1, GETDATE(), 1),

(N'Chương trình khuyến mãi: Săn Sale Phụ Tùng - Giảm giá đến 50%', 
 'san-sale-phu-tung-giam-gia-50', 
 N'<h4>Cơ hội vàng cho tín đồ yêu xe</h4><p>Duy nhất trong tuần này, MotoShop bùng nổ chương trình khuyến mãi lớn nhất năm. Hàng ngàn mã giảm giá và quà tặng hấp dẫn đang chờ đón bạn:</p><ul><li>Giảm 20% cho tất cả các loại lốp xe</li><li>Mua 1 tặng 1 khi mua dầu nhớt tổng hợp</li><li>Miễn phí công lắp đặt khi mua combo nồi</li></ul>', 
 'https://images.unsplash.com/photo-1591761029304-ff7328905260?w=800', 
 2, 1, GETDATE(), 1);
