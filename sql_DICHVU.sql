USE MotorcycleShopDB;
GO
DELETE FROM ServiceImages;
DELETE FROM ServiceReviews;
DELETE FROM ServiceBookings;
DELETE FROM Services;
DELETE FROM ServiceCategories;
GO
SET IDENTITY_INSERT ServiceCategories ON;
INSERT INTO ServiceCategories (CategoryId, CategoryName, Slug, IsActive, DisplayOrder) VALUES (1, N'Bảo dưỡng định kỳ', 'bao-duong-dinh-ky', 1, 1);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Gói bảo dưỡng tiêu chuẩn (15 bước)', 250000, 120, 'goi-bao-duong-tieu-chuan-15-buoc', N'Gói bảo dưỡng toàn diện giúp kiểm tra và chăm sóc mọi chi tiết quan trọng trên xe. Bao gồm: vệ sinh nồi/bướm ga, kiểm tra hệ thống phanh, tăng sên, kiểm tra lốp, hệ thống điện, chiếu sáng và bôi trơn các chi tiết chuyển động. Đảm bảo xe vận hành êm ái, an toàn và tiết kiệm nhiên liệu.', N'Mô tả: Gói bảo dưỡng toàn diện giúp kiểm tra và chăm sóc mọi chi tiết quan trọng trên xe. Bao gồm: vệ sinh nồi/bướm ga, kiểm tra hệ thống phanh, tăng sên, kiểm tra lốp, hệ thống điện, chiếu sáng và bôi trơn các chi tiết chuyển động. Đảm bảo xe vận hành êm ái, an toàn và tiết kiệm nhiên liệu.
Thông số kỹ thuật
Các hạng mục: Kiểm tra phanh, vệ sinh nồi, tăng sên, kiểm tra điện, lọc gió
Phù hợp: Tất cả các dòng xe số, xe ga phổ thông
Lợi ích: Tăng tuổi thọ động cơ, vận hành an toàn, phát hiện sớm hỏng hóc', 30, 1, N'/uploads/services/goi-bao-duong-tieu-chuan-15-buoc.png', 1, N'Bảo dưỡng tổng quát', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vệ sinh kim phun & Buồng đốt (Công nghệ sóng siêu âm)', 150000, 45, 've-sinh-kim-phun-buong-dot-cong-nghe-song-sieu-am', N'Sử dụng máy vệ sinh kim phun bằng sóng siêu âm hiện đại để loại bỏ hoàn toàn muội carbon bám trên đầu kim phun và trong buồng đốt. Giúp phục hồi công suất động cơ, giảm tình trạng hụt ga, khó nổ máy và tiết kiệm xăng rõ rệt.', N'Mô tả: Sử dụng máy vệ sinh kim phun bằng sóng siêu âm hiện đại để loại bỏ hoàn toàn muội carbon bám trên đầu kim phun và trong buồng đốt. Giúp phục hồi công suất động cơ, giảm tình trạng hụt ga, khó nổ máy và tiết kiệm xăng rõ rệt.
Thông số kỹ thuật
Công nghệ: Sóng siêu âm chuẩn quốc tế
Tác dụng: Làm sạch béc phun, sạch muội than buồng đốt, thông thoáng đường nạp
Khuyên dùng: Mỗi 10.000 km hoặc khi xe có dấu hiệu hao xăng, hụt ga', 7, 1, N'/uploads/services/ve-sinh-kim-phun-buong-dot-cong-nghe-song-sieu-am.png', 1, N'Chăm sóc động cơ', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Kiểm tra & Thay Bugi', 50000, 15, 'kiem-tra-thay-bugi', N'Kiểm tra tình trạng đánh lửa của bugi cũ. Nếu đầu cực đã mòn hoặc bám nhiều muội than, tiến hành thay bugi mới chính hãng NGK hoặc Iridium giúp xe dễ nổ máy và đánh lửa mạnh mẽ hơn.', N'Mô tả: Kiểm tra tình trạng đánh lửa của bugi cũ. Nếu đầu cực đã mòn hoặc bám nhiều muội than, tiến hành thay bugi mới chính hãng NGK hoặc Iridium giúp xe dễ nổ máy và đánh lửa mạnh mẽ hơn.
Thông số kỹ thuật
Hạng mục: Kiểm tra khe hở đánh lửa, vệ sinh đầu cực, thay mới
Lợi ích: Xe dễ khởi động, máy nổ đều, tiết kiệm nhiên liệu
Ghi chú: Giá áp dụng cho công thay, chưa bao gồm tiền phụ tùng Bugi', 90, 1, N'/uploads/services/kiem-tra-thay-bugi.png', 1, N'Hệ thống đánh lửa', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay nước làm mát', 120000, 30, 'thay-nuoc-lam-mat', N'Xả bỏ nước làm mát cũ, súc rửa két nước và châm nước làm mát cao cấp mới. Giúp động cơ giải nhiệt nhanh chóng, chống sôi nước và ngăn ngừa rỉ sét trong lòng két nước.', N'Mô tả: Xả bỏ nước làm mát cũ, súc rửa két nước và châm nước làm mát cao cấp mới. Giúp động cơ giải nhiệt nhanh chóng, chống sôi nước và ngăn ngừa rỉ sét trong lòng két nước.
Thông số kỹ thuật
Hạng mục: Xả nước cũ, súc két nước, châm nước mới, xả gió
Lợi ích: Giảm nhiệt độ máy, bảo vệ động cơ khi đi đường dài
Khuyên dùng: Mỗi 20.000 km hoặc định kỳ 1-2 năm', 0, 1, N'/uploads/services/thay-nuoc-lam-mat.png', 1, N'Hệ thống làm mát', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vệ sinh lọc gió & Thay mới', 30000, 10, 've-sinh-loc-gio-thay-moi', N'Kiểm tra tình trạng lọc gió. Nếu lọc gió quá bẩn sẽ làm xe hao xăng, hụt ga. Tiến hành vệ sinh (với lọc gió mút) hoặc thay mới (với lọc gió giấy) để động cơ luôn được hít khí sạch.', N'Mô tả: Kiểm tra tình trạng lọc gió. Nếu lọc gió quá bẩn sẽ làm xe hao xăng, hụt ga. Tiến hành vệ sinh (với lọc gió mút) hoặc thay mới (với lọc gió giấy) để động cơ luôn được hít khí sạch.
Thông số kỹ thuật
Hạng mục: Tháo bầu lọc, vệ sinh hộc gió, thay tấm lọc
Lợi ích: Tối ưu lượng gió nạp, xe bốc hơn, sạch buồng đốt
Ghi chú: Giá công thay, chưa bao gồm tiền tấm lọc gió', 0, 1, N'/uploads/services/ve-sinh-loc-gio-thay-moi.png', 1, N'Hệ thống nạp khí', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay nhớt máy & Nhớt hộp số (Combo)', 40000, 15, 'thay-nhot-may-nhot-hop-so-combo', N'Dịch vụ thay nhớt chuyên nghiệp. Bao gồm công xả nhớt cũ, vệ sinh ốc xả và lọc dầu (nếu có), châm nhớt mới đúng dung tích. Áp dụng cho cả xe số (nhớt máy) và xe ga (nhớt máy + láp).', N'Mô tả: Dịch vụ thay nhớt chuyên nghiệp. Bao gồm công xả nhớt cũ, vệ sinh ốc xả và lọc dầu (nếu có), châm nhớt mới đúng dung tích. Áp dụng cho cả xe số (nhớt máy) và xe ga (nhớt máy + láp).
Thông số kỹ thuật
Hạng mục: Xả nhớt, vệ sinh lọc dầu, châm nhớt mới
Công cụ: Dụng cụ chuyên dụng, phễu châm, khay chứa sạch
Lưu ý: Giá công thay, khách chọn nhớt sẽ tính thêm tiền nhớt
Ảnh:', 0, 1, N'/uploads/services/thay-nhot-may-nhot-hop-so-combo.png', 1, N'Bôi trơn định kỳ', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vệ sinh họng xăng & Kim phun (Manual)', 120000, 60, 've-sinh-hong-xang-kim-phun-manual', N'Tháo rời họng xăng và kim phun để vệ sinh trực tiếp bằng dung dịch chuyên dụng. Loại bỏ hoàn toàn mảng bám bẩn, bụi đất tích tụ lâu ngày trong đường nạp.', N'Mô tả: Tháo rời họng xăng và kim phun để vệ sinh trực tiếp bằng dung dịch chuyên dụng. Loại bỏ hoàn toàn mảng bám bẩn, bụi đất tích tụ lâu ngày trong đường nạp.
Thông số kỹ thuật
Hạng mục: Tháo họng ga, vệ sinh cảm biến, kim phun, họng xăng
Lợi ích: Hết tình trạng garanti không đều, xe chạy mượt mà
Khuyên dùng: Mỗi 15.000 km cho xe sử dụng công nghệ FI', 7, 1, N'/uploads/services/ve-sinh-hong-xang-kim-phun-manual.png', 1, N'Bảo dưỡng hệ thống FI', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Kiểm tra hệ thống điện & Ắc quy', 50000, 20, 'kiem-tra-he-thong-dien-ac-quy', N'Sử dụng máy đo chuyên dụng để kiểm tra điện áp ắc quy, dòng sạc từ mâm lửa. Vệ sinh các đầu cực, bôi mỡ bảo vệ để ngăn ngừa oxy hóa gây khó đề máy.', N'Mô tả: Sử dụng máy đo chuyên dụng để kiểm tra điện áp ắc quy, dòng sạc từ mâm lửa. Vệ sinh các đầu cực, bôi mỡ bảo vệ để ngăn ngừa oxy hóa gây khó đề máy.
Thông số kỹ thuật
Thiết bị: Máy đo điện áp Ắc quy, đồng hồ đo dòng sạc
Lợi ích: Đảm bảo hệ thống chiếu sáng, còi và đề hoạt động ổn định
Khuyên dùng: Khi thấy xe khó đề hoặc đèn sáng yếu', 30, 1, N'/uploads/services/kiem-tra-he-thong-dien-ac-quy.png', 1, N'Hệ thống điện', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Bôi trơn chi tiết & Chân chống', 20000, 15, 'boi-tron-chi-tiet-chan-chong', N'Tra mỡ bò, dầu bôi trơn chuyên dụng vào các vị trí: chân chống đứng/nghiêng, tay phanh, cáp ga, ổ khóa, các khớp nối gác chân. Giúp xe hoạt động linh hoạt, không bị kẹt cứng.', N'Mô tả: Tra mỡ bò, dầu bôi trơn chuyên dụng vào các vị trí: chân chống đứng/nghiêng, tay phanh, cáp ga, ổ khóa, các khớp nối gác chân. Giúp xe hoạt động linh hoạt, không bị kẹt cứng.
Thông số kỹ thuật
Sản phẩm sử dụng: Mỡ chịu nhiệt, WD-40, nhớt bôi trơn
Lợi ích: Chống rỉ sét, vận hành nhẹ nhàng, không tiếng kêu', 0, 1, N'/uploads/services/boi-tron-chi-tiet-chan-chong.jpg', 1, N'Chăm sóc tổng quát', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Kiểm tra tổng quát trước khi đi Tour', 100000, 45, 'kiem-tra-tong-quat-truoc-khi-di-tour', N'Kiểm tra toàn diện các chi tiết an toàn: phanh, lốp, nhông sên dĩa, hệ thống đèn chiếu sáng, mức nước làm mát, nhớt máy. Đảm bảo xe ở trạng thái tốt nhất cho những chuyến đi dài.', N'Mô tả: Kiểm tra toàn diện các chi tiết an toàn: phanh, lốp, nhông sên dĩa, hệ thống đèn chiếu sáng, mức nước làm mát, nhớt máy. Đảm bảo xe ở trạng thái tốt nhất cho những chuyến đi dài.
Thông số kỹ thuật
Hạng mục: Check phanh, lốp, đèn, sên, coolant, oil
Lợi ích: An tâm trên mọi cung đường, hạn chế rủi ro hỏng hóc dọc đường', 0, 1, N'/uploads/services/kiem-tra-tong-quat-truoc-khi-di-tour.jpg', 1, N'Kiểm tra an toàn', 0, 0, 0);
INSERT INTO ServiceCategories (CategoryId, CategoryName, Slug, IsActive, DisplayOrder) VALUES (2, N'Sửa chữa hệ thống truyền động', 'sua-chua-he-thong-truyen-dong', 1, 2);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Làm nồi xe tay ga (Vệ sinh & Cân chỉnh)', 200000, 60, 'lam-noi-xe-tay-ga-ve-sinh-can-chinh', N'Dịch vụ bao gồm tháo rời toàn bộ cụm nồi trước và sau, vệ sinh sạch bụi bẩn, kiểm tra độ mòn của bi nồi, dây curoa, chuông nồi và bố ba càng. Sau đó tiến hành bôi trơn mỡ bò chịu nhiệt chuyên dụng và lắp đặt, cân chỉnh để xe hết rung đầu, lên ga mượt mà hơn.', N'Mô tả: Dịch vụ bao gồm tháo rời toàn bộ cụm nồi trước và sau, vệ sinh sạch bụi bẩn, kiểm tra độ mòn của bi nồi, dây curoa, chuông nồi và bố ba càng. Sau đó tiến hành bôi trơn mỡ bò chịu nhiệt chuyên dụng và lắp đặt, cân chỉnh để xe hết rung đầu, lên ga mượt mà hơn.
Thông số kỹ thuật
Hạng mục: Tháo lắp vệ sinh, kiểm tra bi nồi, dây curoa, chuông, bố ba càng
Khắc phục: Xe bị rung đầu, lỳ máy, kêu gào bộ nồi
Lưu ý: Giá chưa bao gồm các phụ tùng thay thế nếu bị hỏng', 15, 2, N'/uploads/services/lam-noi-xe-tay-ga-ve-sinh-can-chinh.jpg', 1, N'Sửa chữa bộ truyền động', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay nhông sên dĩa & Vệ sinh sên (Combo)', 50000, 30, 'thay-nhong-sen-dia-ve-sinh-sen-combo', N'Dịch vụ tháo lắp bộ nhông sên dĩa cũ và thay bộ mới. Bao gồm công vệ sinh gắp xe, cacte và cân chỉnh độ chùng sên chuẩn xác. Nếu khách hàng chỉ vệ sinh sên, chúng tôi sử dụng dung dịch tẩy rửa chuyên dụng và dưỡng sên cao cấp.', N'Mô tả: Dịch vụ tháo lắp bộ nhông sên dĩa cũ và thay bộ mới. Bao gồm công vệ sinh gắp xe, cacte và cân chỉnh độ chùng sên chuẩn xác. Nếu khách hàng chỉ vệ sinh sên, chúng tôi sử dụng dung dịch tẩy rửa chuyên dụng và dưỡng sên cao cấp.
Thông số kỹ thuật
Phí dịch vụ: Chỉ tính công thay (không bao gồm phụ tùng)
Công cụ: Dụng cụ tháo lắp chuyên dụng, dung dịch vệ sinh sên
Lợi ích: Truyền động êm ái, kéo dài tuổi thọ bộ nhông sên dĩa', 15, 2, N'/uploads/services/thay-nhong-sen-dia-ve-sinh-sen-combo.jpg', 1, N'Bảo trì hệ thống truyền động', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay dây Curoa (Bando,Gates)', 50000, 30, 'thay-day-curoa-bandogates', N'Tháo lắp thay dây curoa mới cho xe tay ga. Kiểm tra các rãnh puly trước và sau để đảm bảo dây curoa mới vận hành êm ái, không bị trượt hay nhanh mòn.', N'Mô tả: Tháo lắp thay dây curoa mới cho xe tay ga. Kiểm tra các rãnh puly trước và sau để đảm bảo dây curoa mới vận hành êm ái, không bị trượt hay nhanh mòn.
Thông số kỹ thuật
Hạng mục: Tháo nồi, thay dây, kiểm tra puly
Lợi ích: Xe vận hành ổn định, không lo đứt dây dọc đường
Ghi chú: Giá công thay, chưa bao gồm tiền dây curoa', 180, 2, N'/uploads/services/thay-day-curoa-bandogates.jpg', 1, N'Truyền động xe ga', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay bi nồi (Zin,Độ) & Cân chỉnh trọng lượng', 50000, 30, 'thay-bi-noi-zindo-can-chinh-trong-luong', N'Thay bộ bi nồi mới phù hợp với mục đích sử dụng (tăng tốc nhanh hoặc chạy đầm chắc). Cân chỉnh trọng lượng bi giúp xe đạt được hiệu suất mong muốn của người lái.', N'Mô tả: Thay bộ bi nồi mới phù hợp với mục đích sử dụng (tăng tốc nhanh hoặc chạy đầm chắc). Cân chỉnh trọng lượng bi giúp xe đạt được hiệu suất mong muốn của người lái.
Thông số kỹ thuật
Hạng mục: Tháo nồi trước, thay bi, vệ sinh rãnh bi
Lợi ích: Thay đổi gia tốc xe theo ý muốn, vận hành mượt mà
Ghi chú: Giá công thay, chưa bao gồm tiền bộ bi nồi', 15, 2, N'/uploads/services/thay-bi-noi-zindo-can-chinh-trong-luong.jpg', 1, N'Nâng cấp truyền động', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay chuông nồi & Bố ba càng', 80000, 45, 'thay-chuong-noi-bo-ba-cang', N'Thay thế cụm chuông nồi và bố ba càng cũ đã bị mòn, cháy hoặc chai cứng. Giúp xe bắt nồi nhạy hơn, hết tình trạng rung đầu và tiếng kêu khó chịu ở nồi sau.', N'Mô tả: Thay thế cụm chuông nồi và bố ba càng cũ đã bị mòn, cháy hoặc chai cứng. Giúp xe bắt nồi nhạy hơn, hết tình trạng rung đầu và tiếng kêu khó chịu ở nồi sau.
Thông số kỹ thuật
Hạng mục: Tháo nồi sau, thay chuông, thay bố, vệ sinh puly sau
Lợi ích: Xe bắt ga nhanh, không còn rung đầu khi khởi hành
Ghi chú: Giá công thay, chưa bao gồm tiền phụ tùng', 30, 2, N'/uploads/services/thay-chuong-noi-bo-ba-cang.jpg', 1, N'Phục hồi bộ nồi sau', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay lò xo trụ nồi sau (Zin,Độ)', 60000, 40, 'thay-lo-xo-tru-noi-sau-zindo', N'Thay lò xo trụ nồi sau giúp điều chỉnh lực ép của dây curoa vào puly sau. Thay đổi độ cứng lò xo giúp xe có đề pa mạnh hơn hoặc chạy hậu êm hơn tùy theo nhu cầu.', N'Mô tả: Thay lò xo trụ nồi sau giúp điều chỉnh lực ép của dây curoa vào puly sau. Thay đổi độ cứng lò xo giúp xe có đề pa mạnh hơn hoặc chạy hậu êm hơn tùy theo nhu cầu.
Thông số kỹ thuật
Hạng mục: Rã cụm puly sau, thay lò xo, tra mỡ chịu nhiệt
Lợi ích: Tăng lực kéo, thay đổi đặc tính vận hành của xe
Ghi chú: Giá công thay', 0, 2, N'/uploads/services/thay-lo-xo-tru-noi-sau-zindo.jpg', 1, N'Cân chỉnh lực ép nồi', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vệ sinh & Tra mỡ puly sau chuyên sâu', 120000, 60, 've-sinh-tra-mo-puly-sau-chuyen-sau', N'Tháo rã toàn bộ puly sau, vệ sinh các rãnh trượt, kiểm tra phớt chặn mỡ và các vòng bi. Tiến hành châm mỡ bò chịu nhiệt chuyên dụng để puly đóng mở mượt mà.', N'Mô tả: Tháo rã toàn bộ puly sau, vệ sinh các rãnh trượt, kiểm tra phớt chặn mỡ và các vòng bi. Tiến hành châm mỡ bò chịu nhiệt chuyên dụng để puly đóng mở mượt mà.
Thông số kỹ thuật
Hạng mục: Rã puly, vệ sinh mỡ cũ, thay phớt (nếu hỏng), châm mỡ mới
Lợi ích: Kéo dài tuổi thọ puly, xe chạy êm, không bị giật', 15, 2, N'/uploads/services/ve-sinh-tra-mo-puly-sau-chuyen-sau.jpg', 1, N'Bảo dưỡng cơ khí', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Chỉnh côn xe số & Xe côn tay', 30000, 15, 'chinh-con-xe-so-xe-con-tay', N'Cân chỉnh độ rơ tay côn, hành trình cắt côn sao cho phù hợp với tay người lái. Giúp quá trình sang số nhẹ nhàng, không bị kẹt số hoặc trượt côn.', N'Mô tả: Cân chỉnh độ rơ tay côn, hành trình cắt côn sao cho phù hợp với tay người lái. Giúp quá trình sang số nhẹ nhàng, không bị kẹt số hoặc trượt côn.
Thông số kỹ thuật
Hạng mục: Chỉnh ốc côn dưới, chỉnh tăng đơ tay côn, tra dầu cáp côn
Lợi ích: Sang số nhẹ, cắt côn hoàn toàn, bảo vệ lá côn', 7, 2, N'/uploads/services/chinh-con-xe-so-xe-con-tay.jpg', 1, N'Cân chỉnh cơ khí', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay lá côn (Bố nồi) xe côn tay', 250000, 90, 'thay-la-con-bo-noi-xe-con-tay', N'Tháo lốc nồi, thay thế các lá côn (lá bố) và lá thép đã bị mòn hoặc cháy. Kiểm tra lò xo nồi và mặt nhôm nồi. Giúp xe truyền lực tối đa từ động cơ sang hộp số.', N'Mô tả: Tháo lốc nồi, thay thế các lá côn (lá bố) và lá thép đã bị mòn hoặc cháy. Kiểm tra lò xo nồi và mặt nhôm nồi. Giúp xe truyền lực tối đa từ động cơ sang hộp số.
Thông số kỹ thuật
Hạng mục: Xả nhớt, tháo lốc nồi, thay lá bố, lá thép, vệ sinh mặt nồi
Lợi ích: Xe hết trượt côn, tăng tốc mạnh mẽ, máy bốc
Ghi chú: Giá công thay, chưa bao gồm nhớt máy và phụ tùng', 30, 2, N'/uploads/services/thay-la-con-bo-noi-xe-con-tay.jpg', 1, N'Sửa chữa động cơ (bên nồi)', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Kiểm tra & Thay nhớt láp (nhớt hộp số)', 20000, 10, 'kiem-tra-thay-nhot-lap-nhot-hop-so', N'Kiểm tra tình trạng nhớt láp. Nếu nhớt bị đục (vào nước) hoặc quá bẩn, tiến hành xả bỏ và thay nhớt láp mới đúng thông số kỹ thuật.', N'Mô tả: Kiểm tra tình trạng nhớt láp. Nếu nhớt bị đục (vào nước) hoặc quá bẩn, tiến hành xả bỏ và thay nhớt láp mới đúng thông số kỹ thuật.
Thông số kỹ thuật
Hạng mục: Xả nhớt láp, kiểm tra màu nhớt, châm nhớt mới
Lợi ích: Bảo vệ bánh răng hộp số, giảm tiếng hú láp
Ghi chú: Giá công thay', 0, 2, N'/uploads/services/kiem-tra-thay-nhot-lap-nhot-hop-so.jpg', 1, N'Bảo trì xe ga', 0, 0, 0);
INSERT INTO ServiceCategories (CategoryId, CategoryName, Slug, IsActive, DisplayOrder) VALUES (3, N'Hệ thống phanh & Lốp', 'he-thong-phanh-lop', 1, 3);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay lốp (vỏ) xe máy bằng máy chuyên dụng', 40000, 20, 'thay-lop-vo-xe-may-bang-may-chuyen-dung', N'Sử dụng máy ra vào vỏ tự động hiện đại, đảm bảo không làm trầy xước vành (niềng) xe. Kiểm tra van vòi và cân bằng lốp giúp xe vận hành ổn định ở tốc độ cao.', N'Mô tả: Sử dụng máy ra vào vỏ tự động hiện đại, đảm bảo không làm trầy xước vành (niềng) xe. Kiểm tra van vòi và cân bằng lốp giúp xe vận hành ổn định ở tốc độ cao.
Thông số kỹ thuật
Trang bị: Máy ra vỏ không trầy vành
Phí dịch vụ: Áp dụng cho 1 bánh xe
Lưu ý: Giá chưa bao gồm tiền lốp xe', 7, 3, N'/uploads/services/thay-lop-vo-xe-may-bang-may-chuyen-dung.jpg', 1, N'Dịch vụ lốp xe', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Kiểm tra & Thay má phanh (bố thắng)', 30000, 15, 'kiem-tra-thay-ma-phanh-bo-thang', N'Kiểm tra độ mòn của má phanh đĩa hoặc phanh cơ. Vệ sinh heo dầu, piston phanh để đảm bảo lực phanh ăn đều, không bị kẹt hay kêu rít khi sử dụng.', N'Mô tả: Kiểm tra độ mòn của má phanh đĩa hoặc phanh cơ. Vệ sinh heo dầu, piston phanh để đảm bảo lực phanh ăn đều, không bị kẹt hay kêu rít khi sử dụng.
Thông số kỹ thuật
Hạng mục: Vệ sinh heo phanh, thay bố thắng, kiểm tra dầu phanh
An toàn: Đảm bảo khoảng cách phanh chuẩn, không bó cứng
Lưu ý: Giá áp dụng cho công thay trên 1 cụm phanh', 7, 3, N'/uploads/services/kiem-tra-thay-ma-phanh-bo-thang.jpg', 1, N'Hệ thống an toàn', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay đĩa phanh (Disc Brake)', 60000, 30, 'thay-dia-phanh-disc-brake', N'Tháo lắp thay đĩa phanh mới khi đĩa cũ bị mòn quá giới hạn hoặc bị cong vênh. Đảm bảo mặt phẳng đĩa chuẩn xác để phanh không bị rung giật.', N'Mô tả: Tháo lắp thay đĩa phanh mới khi đĩa cũ bị mòn quá giới hạn hoặc bị cong vênh. Đảm bảo mặt phẳng đĩa chuẩn xác để phanh không bị rung giật.
Thông số kỹ thuật
Hạng mục: Tháo bánh, tháo đĩa cũ, vệ sinh mặt tiếp xúc, lắp đĩa mới
An toàn: Kiểm tra độ đảo của đĩa sau khi lắp
Ghi chú: Giá công thay', 15, 3, N'/uploads/services/thay-dia-phanh-disc-brake.jpg', 1, N'Hệ thống phanh', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Ép chảng ba & Cân vành xe máy', 350000, 120, 'ep-chang-ba-can-vanh-xe-may', N'Sử dụng máy ép thủy lực để phục hồi chảng ba bị lệch do va chạm. Cân chỉnh vành (niềng) đúc hoặc vành nan hoa để xe hết tình trạng sàn lắc, đi thẳng lái.', N'Mô tả: Sử dụng máy ép thủy lực để phục hồi chảng ba bị lệch do va chạm. Cân chỉnh vành (niềng) đúc hoặc vành nan hoa để xe hết tình trạng sàn lắc, đi thẳng lái.
Thông số kỹ thuật
Hạng mục: Tháo dàn chân trước, ép chảng ba, cân vành bằng máy
Kỹ thuật: Kiểm tra độ thẳng bằng thước điện tử
Lợi ích: Xe đi thẳng lái, không bị mỏi tay, an toàn', 30, 3, N'/uploads/services/ep-chang-ba-can-vanh-xe-may.jpg', 1, N'Phục hồi khung gầm', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Phục hồi phuộc trước (Thay dầu & Phớt)', 180000, 60, 'phuc-hoi-phuoc-truoc-thay-dau-phot', N'Tháo rã phuộc trước, vệ sinh sạch dầu cũ và mạt kim loại. Thay phớt chặn dầu, phớt chắn bụi mới và châm dầu phuộc đúng dung tích để phục hồi độ nhún êm ái.', N'Mô tả: Tháo rã phuộc trước, vệ sinh sạch dầu cũ và mạt kim loại. Thay phớt chặn dầu, phớt chắn bụi mới và châm dầu phuộc đúng dung tích để phục hồi độ nhún êm ái.
Thông số kỹ thuật
Hạng mục: Rã phuộc, thay phớt, thay dầu, kiểm tra ty phuộc
Lợi ích: Giảm chấn tốt, không bị xì dầu, tay lái êm
Ghi chú: Giá đã bao gồm dầu phuộc và phớt tiêu chuẩn', 90, 3, N'/uploads/services/phuc-hoi-phuoc-truoc-thay-dau-phot.jpg', 1, N'Hệ thống giảm xóc', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay dầu phanh (Dầu thắng DOT)', 50000, 20, 'thay-dau-phanh-dau-thang-dot', N'Hút bỏ dầu phanh cũ bị biến chất hoặc nhiễm nước. Châm dầu phanh mới và tiến hành xả gió hệ thống để lực phanh đạt hiệu quả cao nhất.', N'Mô tả: Hút bỏ dầu phanh cũ bị biến chất hoặc nhiễm nước. Châm dầu phanh mới và tiến hành xả gió hệ thống để lực phanh đạt hiệu quả cao nhất.
Thông số kỹ thuật
Hạng mục: Hút dầu cũ, vệ sinh bình dầu, châm dầu mới, xả gió
Lợi ích: Phanh nhạy, không bị bọt khí, bảo vệ cuppen phanh', 0, 3, N'/uploads/services/thay-dau-phanh-dau-thang-dot.jpg', 1, N'Bảo trì hệ thống phanh', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay heo dầu (Caliper) & Vệ sinh piston', 100000, 45, 'thay-heo-dau-caliper-ve-sinh-piston', N'Thay mới cụm heo dầu hoặc tháo rã vệ sinh kỹ các piston phanh bị kẹt do bụi bẩn. Giúp piston di chuyển tự do, phanh ăn đều và không bị bó cứng bánh xe.', N'Mô tả: Thay mới cụm heo dầu hoặc tháo rã vệ sinh kỹ các piston phanh bị kẹt do bụi bẩn. Giúp piston di chuyển tự do, phanh ăn đều và không bị bó cứng bánh xe.
Thông số kỹ thuật
Hạng mục: Tháo heo dầu, vệ sinh piston, thay seal (nếu cần), lắp đặt
Kỹ thuật: Kiểm tra độ hồi của piston sau khi phanh', 15, 3, N'/uploads/services/thay-heo-dau-caliper-ve-sinh-piston.jpg', 1, N'Sửa chữa hệ thống phanh', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay dây dầu thắng (Zin,Độ)', 50000, 30, 'thay-day-dau-thang-zindo', N'Thay thế dây dẫn dầu thắng cũ bị nứt, rò rỉ hoặc nâng cấp sang dây dầu ép thủy lực (dây dầu Morin/Hel) giúp lực thắng ổn định hơn, không bị nở dây khi phanh gấp.', N'Mô tả: Thay thế dây dẫn dầu thắng cũ bị nứt, rò rỉ hoặc nâng cấp sang dây dầu ép thủy lực (dây dầu Morin/Hel) giúp lực thắng ổn định hơn, không bị nở dây khi phanh gấp.
Thông số kỹ thuật
Hạng mục: Tháo dây cũ, lắp dây mới, châm dầu, xả gió
Lợi ích: Lực phanh ổn định, thẩm mỹ cao
Ghi chú: Giá công thay', 0, 3, N'/uploads/services/thay-day-dau-thang-zindo.jpg', 1, N'Hệ thống dẫn động phanh', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vệ sinh & Châm mỡ cốt bánh xe', 20000, 15, 've-sinh-cham-mo-cot-banh-xe', N'Tháo cốt bánh xe, vệ sinh sạch rỉ sét và bụi đất. Tra mỡ bò chịu nhiệt vào cốt bánh và các bạc lót giúp việc tháo lắp sau này dễ dàng và cốt không bị sét kẹt.', N'Mô tả: Tháo cốt bánh xe, vệ sinh sạch rỉ sét và bụi đất. Tra mỡ bò chịu nhiệt vào cốt bánh và các bạc lót giúp việc tháo lắp sau này dễ dàng và cốt không bị sét kẹt.
Thông số kỹ thuật
Hạng mục: Tháo cốt, vệ sinh, tra mỡ, siết lực chuẩn
Lợi ích: Chống rỉ sét cốt bánh, bánh xe quay nhẹ nhàng', 0, 3, N'/uploads/services/ve-sinh-cham-mo-cot-banh-xe.png', 1, N'Bảo trì dàn chân', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vá lốp không săm', 40000, 15, 'va-lop-khong-sam', N'Xử lý lỗ thủng trên lốp không săm bằng phương pháp vá nấm hoặc vá trong chuyên dụng. Đảm bảo vết vá kín khít, không bị xì lại và không gây hỏng cấu trúc lốp.', N'Mô tả: Xử lý lỗ thủng trên lốp không săm bằng phương pháp vá nấm hoặc vá trong chuyên dụng. Đảm bảo vết vá kín khít, không bị xì lại và không gây hỏng cấu trúc lốp.
Thông số kỹ thuật
Phương pháp: Vá nấm kỹ thuật cao hoặc vá ép trong
Lợi ích: Vết vá bền bỉ, an toàn hơn phương pháp vá lụi thông thường', 7, 3, N'/uploads/services/va-lop-khong-sam.png', 1, N'Sửa chữa lốp', 0, 0, 0);
INSERT INTO ServiceCategories (CategoryId, CategoryName, Slug, IsActive, DisplayOrder) VALUES (4, N'Tân trang & Đồ chơi', 'tan-trang-do-choi', 1, 4);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Rửa xe chi tiết (Detailing wash)', 80000, 45, 'rua-xe-chi-tiet-detailing-wash', N'Rửa xe không chỉ là làm sạch bề mặt. Chúng tôi rửa kỹ từng ngóc ngách lốc máy, gầm xe bằng dung dịch chuyên dụng. Sau khi lau khô sẽ tiến hành xịt dưỡng bóng dàn nhựa, dưỡng lốp và tra mỡ các khớp nối.', N'Mô tả: Rửa xe không chỉ là làm sạch bề mặt. Chúng tôi rửa kỹ từng ngóc ngách lốc máy, gầm xe bằng dung dịch chuyên dụng. Sau khi lau khô sẽ tiến hành xịt dưỡng bóng dàn nhựa, dưỡng lốp và tra mỡ các khớp nối.
Thông số kỹ thuật
Dung tích: Không giới hạn dòng xe
Hạng mục: Rửa gầm, lốc máy, dưỡng nhựa, dưỡng lốp, tra mỡ chân chống
Cam kết: Sử dụng xà phòng PH trung tính, không hại sơn xe', 0, 4, N'/uploads/services/rua-xe-chi-tiet-detailing-wash.png', 1, N'Chăm sóc xe', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Lắp đặt đồ chơi & Phụ kiện trang trí', 50000, 30, 'lap-dat-do-choi-phu-kien-trang-tri', N'Nhận lắp đặt các loại đồ chơi xe như: gương chiếu hậu, bao tay, tay thắng, đèn trợ sáng, baga, chống trộm. Đảm bảo đi dây điện gọn gàng, mối nối chắc chắn và không làm ảnh hưởng đến kết cấu nguyên bản của xe.', N'Mô tả: Nhận lắp đặt các loại đồ chơi xe như: gương chiếu hậu, bao tay, tay thắng, đèn trợ sáng, baga, chống trộm. Đảm bảo đi dây điện gọn gàng, mối nối chắc chắn và không làm ảnh hưởng đến kết cấu nguyên bản của xe.
Thông số kỹ thuật
Phí dịch vụ: Từ 50.000đ tùy độ khó của món đồ chơi
Kỹ thuật: Đi dây điện thẩm mỹ, bấm jack cos chuẩn
Cam kết: Không cắt dây điện zin của xe', 0, 4, N'/uploads/services/lap-dat-do-choi-phu-kien-trang-tri.png', 1, N'Nâng cấp xe', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Phủ Nano và Ceramic bảo vệ sơn xe', 500000, 180, 'phu-nano-va-ceramic-bao-ve-son-xe', N'Đánh bóng bề mặt sơn để xóa vết xước nhẹ, sau đó phủ lớp dung dịch Ceramic cao cấp. Giúp xe có độ bóng sâu, chống tia UV, hạn chế bám nước và bụi bẩn, giữ màu sơn luôn như mới.', N'Mô tả: Đánh bóng bề mặt sơn để xóa vết xước nhẹ, sau đó phủ lớp dung dịch Ceramic cao cấp. Giúp xe có độ bóng sâu, chống tia UV, hạn chế bám nước và bụi bẩn, giữ màu sơn luôn như mới.
Thông số kỹ thuật
Quy trình: Rửa xe, tẩy ố, đánh bóng, phủ Ceramic, sấy hồng ngoại
Lợi ích: Tăng độ bóng, hiệu ứng lá sen chống bám nước, bảo vệ màu sơn
Ghi chú: Giá áp dụng cho xe phổ thông, xe PKL sẽ có báo giá riêng', 180, 4, N'/uploads/services/phu-nano-va-ceramic-bao-ve-son-xe.png', 1, N'Bảo vệ bề mặt sơn', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Đánh bóng dàn áo & Tẩy ố nhựa nhám', 150000, 60, 'danh-bong-dan-ao-tay-o-nhua-nham', N'Sử dụng xi đánh bóng chuyên dụng và máy đánh bóng cầm tay để làm mờ các vết xước dăm trên dàn nhựa bóng. Sử dụng dung dịch phục hồi nhựa nhám để lấy lại màu đen nguyên bản cho các phần nhựa đã bị bạc màu.', N'Mô tả: Sử dụng xi đánh bóng chuyên dụng và máy đánh bóng cầm tay để làm mờ các vết xước dăm trên dàn nhựa bóng. Sử dụng dung dịch phục hồi nhựa nhám để lấy lại màu đen nguyên bản cho các phần nhựa đã bị bạc màu.
Thông số kỹ thuật
Sản phẩm sử dụng: Xi 3M, Menzerna, dung dịch phục hồi nhựa nhám Solution Finish
Lợi ích: Xe nhìn sạch đẹp, dàn nhựa bóng bẩy, nhựa nhám đen sâu', 0, 4, N'/uploads/services/danh-bong-dan-ao-tay-o-nhua-nham.png', 1, N'Phục hồi ngoại thất', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Lắp khóa chống trộm & Smartkey chính hãng', 300000, 90, 'lap-khoa-chong-trom-smartkey-chinh-hang', N'Thay thế ổ khóa cơ truyền thống bằng hệ thống khóa thông minh Smartkey Honda/Yamaha hoặc lắp đặt các bộ định vị, chống trộm cướp. Đảm bảo an toàn tuyệt đối cho xe của bạn.', N'Mô tả: Thay thế ổ khóa cơ truyền thống bằng hệ thống khóa thông minh Smartkey Honda/Yamaha hoặc lắp đặt các bộ định vị, chống trộm cướp. Đảm bảo an toàn tuyệt đối cho xe của bạn.
Thông số kỹ thuật
Hạng mục: Tháo dàn áo, đi dây điện relay, lắp ổ khóa, cài đặt remote
Kỹ thuật: Sử dụng bộ dây điện (harness) chuyên dụng, không cắt dây zin', 360, 4, N'/uploads/services/lap-khoa-chong-trom-smartkey-chinh-hang.png', 1, N'Nâng cấp an ninh', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Lắp đèn trợ sáng (L4, L6, Bi cầu Mini)', 150000, 60, 'lap-den-tro-sang-l4-l6-bi-cau-mini', N'Lắp đặt thêm đèn led trợ sáng giúp cải thiện tầm nhìn khi đi đêm hoặc trên các cung đường thiếu sáng. Đi dây điện qua rơ-le (relay) và cầu chì riêng biệt để đảm bảo an toàn cho hệ thống điện zin.', N'Mô tả: Lắp đặt thêm đèn led trợ sáng giúp cải thiện tầm nhìn khi đi đêm hoặc trên các cung đường thiếu sáng. Đi dây điện qua rơ-le (relay) và cầu chì riêng biệt để đảm bảo an toàn cho hệ thống điện zin.
Thông số kỹ thuật
Hạng mục: Làm pát đèn, đi dây điện, lắp công tắc passing/on-off, lắp relay
An toàn: Chống cháy nổ, không làm yếu bình ắc quy
Ghi chú: Giá công lắp, chưa bao gồm tiền đèn', 180, 4, N'/uploads/services/lap-den-tro-sang-l4-l6-bi-cau-mini.png', 1, N'Nâng cấp chiếu sáng', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Dán Decal bảo vệ & Thay đổi màu sắc', 200000, 120, 'dan-decal-bao-ve-thay-doi-mau-sac', N'Dán keo trong bảo vệ chống trầy dàn áo hoặc dán decal màu, decal tem trùm để thay đổi phong cách cho xe. Sử dụng chất liệu decal cao cấp, độ bám dính tốt và không để lại keo khi tháo bỏ.', N'Mô tả: Dán keo trong bảo vệ chống trầy dàn áo hoặc dán decal màu, decal tem trùm để thay đổi phong cách cho xe. Sử dụng chất liệu decal cao cấp, độ bám dính tốt và không để lại keo khi tháo bỏ.
Thông số kỹ thuật
Chất liệu: Decal 3 lớp, Decal nhôm xước, Decal chuyển sắc
Lợi ích: Bảo vệ sơn zin, thể hiện cá tính riêng
Ghi chú: Giá dao động tùy vào diện tích dán', 180, 4, N'/uploads/services/dan-decal-bao-ve-thay-doi-mau-sac.jpg', 1, N'Trang trí ngoại thất', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay gương chiếu hậu thời trang', 10000, 10, 'thay-guong-chieu-hau-thoi-trang', N'Tháo lắp thay thế gương chiếu hậu zin bằng các mẫu gương thời trang (Rizoma, H2C, Gương gù). Đảm bảo gương chắc chắn, không bị rung lắc và quan sát tốt.', N'Mô tả: Tháo lắp thay thế gương chiếu hậu zin bằng các mẫu gương thời trang (Rizoma, H2C, Gương gù). Đảm bảo gương chắc chắn, không bị rung lắc và quan sát tốt.
Thông số kỹ thuật
Hạng mục: Tháo gương cũ, lắp ốc chân gương, cân chỉnh góc nhìn
Ghi chú: Giá công thay', 0, 4, N'/uploads/services/thay-guong-chieu-hau-thoi-trang.jpg', 1, N'Phụ kiện tiện ích', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Thay bao tay & Gù tay lái', 30000, 20, 'thay-bao-tay-gu-tay-lai', N'Thay thế bao tay cũ bị mòn, chai cứng bằng các loại bao tay êm ái hơn (Ariete, Barracuda, Domino). Lắp đặt thêm gù tay lái tăng tính thẩm mỹ và giảm rung tay lái.', N'Mô tả: Thay thế bao tay cũ bị mòn, chai cứng bằng các loại bao tay êm ái hơn (Ariete, Barracuda, Domino). Lắp đặt thêm gù tay lái tăng tính thẩm mỹ và giảm rung tay lái.
Thông số kỹ thuật
Hạng mục: Tháo bao tay cũ, vệ sinh ống ga, lắp bao tay mới, bắt gù
Lợi ích: Cảm giác cầm nắm tốt, không bị đau tay khi đi xa
Ghi chú: Giá công thay', 0, 4, N'/uploads/services/thay-bao-tay-gu-tay-lai.jpg', 1, N'Phụ kiện cầm nắm', 0, 0, 0);
INSERT INTO Services (ServiceName, Price, Duration, Slug, ShortDescription, Description, WarrantyDays, CategoryId, ImageUrl, IsActive, Tags, TotalBookings, AverageRating, TotalReviews) VALUES (N'Vệ sinh & Sơn lốc máy,Mâm xe (Sơn dặm)', 400000, 1, 've-sinh-son-loc-maymam-xe-son-dam', N'Vệ sinh sạch sẽ, chà nhám và sơn lại các chi tiết bị trầy xước hoặc bong tróc sơn như lốc máy, mâm xe, cản sau. Sử dụng sơn chịu nhiệt và có độ bền màu cao.', N'Mô tả: Vệ sinh sạch sẽ, chà nhám và sơn lại các chi tiết bị trầy xước hoặc bong tróc sơn như lốc máy, mâm xe, cản sau. Sử dụng sơn chịu nhiệt và có độ bền màu cao.
Thông số kỹ thuật
Quy trình: Vệ sinh, tẩy sơn cũ, lót chống rỉ, sơn màu, phủ bóng (2K)
Lợi ích: Phục hồi vẻ đẹp nguyên bản của các chi tiết kim loại', 90, 4, N'/uploads/services/ve-sinh-son-loc-maymam-xe-son-dam.jpg', 1, N'Phục hồi chi tiết', 0, 0, 0);
SET IDENTITY_INSERT ServiceCategories OFF;
GO