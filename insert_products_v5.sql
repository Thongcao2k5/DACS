USE MotorcycleShopDB;
GO

-- INSERT CATEGORIES
SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (1, N'Lốp xe máy', 'lop-xe-may', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (2, N'Ắc quy', 'ac-quy', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (3, N'Bugi', 'bugi', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (4, N'Hệ thống phanh', 'he-thong-phanh', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (5, N'Gương', 'guong', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (6, N'Lọc gió', 'loc-gio', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (7, N'Sên (xích)', 'sen-xich', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (8, N'Bộ nhông sên dĩa', 'bo-nhong-sen-dia', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (9, N'Tay thắng', 'tay-thang', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (10, N'Đèn trợ sáng', 'en-tro-sang', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (11, N'Giảm xóc sau', 'giam-xoc-sau', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (12, N'Bộ nồi', 'bo-noi', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (13, N'Tay ga nhanh', 'tay-ga-nhanh', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (14, N'Kính chắn gió', 'kinh-chan-gio', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (15, N'Pad biển số', 'pad-bien-so', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (16, N'Tay dắt', 'tay-dat', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (17, N'Đĩa tải', 'ia-tai', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (18, N'Ốc xe', 'oc-xe', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (19, N'Ống xả', 'ong-xa', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (20, N'Lọc nhớt', 'loc-nhot', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (21, N'Dây ga', 'day-ga', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (22, N'Heo dầu', 'heo-dau', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (23, N'Đĩa phanh', 'ia-phanh', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (24, N'Má phanh', 'ma-phanh', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (25, N'Tay côn', 'tay-con', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (26, N'Dè', 'de', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (27, N'Chắn xích', 'chan-xich', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (28, N'Cổ pô', 'co-po', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (29, N'Đồng hồ điện tử', 'ong-ho-ien-tu', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (30, N'Gác chân', 'gac-chan', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (31, N'Bình dầu', 'binh-dau', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (32, N'Bảo vệ két nước', 'bao-ve-ket-nuoc', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (33, N'Dây dầu', 'day-dau', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (34, N'Công tắc', 'cong-tac', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (35, N'Bình xăng con', 'binh-xang-con', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (36, N'Ốp pô', 'op-po', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (37, N'Móc treo', 'moc-treo', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (38, N'Xi nhan', 'xi-nhan', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (39, N'Bảo vệ tay lái', 'bao-ve-tay-lai', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (40, N'Dây curoa', 'day-curoa', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (41, N'Bi nồi', 'bi-noi', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (42, N'Chuông nồi', 'chuong-noi', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (43, N'Lò xo', 'lo-xo', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (44, N'Dầu phanh', 'dau-phanh', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (45, N'Nắp nhớt', 'nap-nhot', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (46, N'Sensor', 'sensor', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (47, N'Dây điện', 'day-ien', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (48, N'Khóa', 'khoa', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (49, N'Camera', 'camera', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (50, N'Mâm xe', 'mam-xe', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (51, N'Cùm côn', 'cum-con', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (52, N'Dây thắng', 'day-thang', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (53, N'Két nước', 'ket-nuoc', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (54, N'Quạt làm mát', 'quat-lam-mat', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (55, N'ECU', 'ecu', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (56, N'IC', 'ic', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (57, N'Mobin', 'mobin', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (58, N'Lọc xăng', 'loc-xang', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (59, N'Kim phun', 'kim-phun', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (60, N'Bơm xăng', 'bom-xang', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (61, N'Ốp', 'op', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (62, N'Tem', 'tem', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (63, N'Keo bảo vệ', 'keo-bao-ve', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (64, N'Yên', 'yen', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (65, N'Gù', 'gu', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (66, N'Tay nắm', 'tay-nam', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (67, N'Sạc', 'sac', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (68, N'Đồng hồ', 'ong-ho', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (69, N'Bơm', 'bom', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (70, N'Phụ kiện', 'phu-kien', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (71, N'Giá đỡ', 'gia-o', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (72, N'Kính', 'kinh', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (73, N'Dây', 'day', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (74, N'Bọc', 'boc', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (75, N'Chắn gió', 'chan-gio', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (76, N'Lót sàn', 'lot-san', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (77, N'Dụng cụ', 'dung-cu', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (78, N'Dung dịch', 'dung-dich', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (79, N'Dầu nhớt động cơ', 'dau-nhot-ong-co', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (80, N'Ắc quy xe máy', 'ac-quy-xe-may', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (81, N'Gương chiếu hậu', 'guong-chieu-hau', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (82, N'Sên xe máy', 'sen-xe-may', 1);
INSERT INTO Categories (CategoryId, CategoryName, Slug, IsActive) VALUES (83, N'Dè chắn bùn', 'de-chan-bun', 1);
SET IDENTITY_INSERT Categories OFF;
GO

-- INSERT BRANDS
SET IDENTITY_INSERT Brands ON;
INSERT INTO Brands (BrandId, BrandName) VALUES (1, N'Michelin');
INSERT INTO Brands (BrandId, BrandName) VALUES (2, N'GS');
INSERT INTO Brands (BrandId, BrandName) VALUES (3, N'NGK');
INSERT INTO Brands (BrandId, BrandName) VALUES (4, N'Brembo');
INSERT INTO Brands (BrandId, BrandName) VALUES (5, N'Rizoma');
INSERT INTO Brands (BrandId, BrandName) VALUES (6, N'K&N');
INSERT INTO Brands (BrandId, BrandName) VALUES (7, N'DID');
INSERT INTO Brands (BrandId, BrandName) VALUES (8, N'Recto');
INSERT INTO Brands (BrandId, BrandName) VALUES (9, N'CRG');
INSERT INTO Brands (BrandId, BrandName) VALUES (10, N'L4X');
INSERT INTO Brands (BrandId, BrandName) VALUES (11, N'YSS');
INSERT INTO Brands (BrandId, BrandName) VALUES (12, N'SSS');
INSERT INTO Brands (BrandId, BrandName) VALUES (13, N'Domino');
INSERT INTO Brands (BrandId, BrandName) VALUES (14, N'Puig');
INSERT INTO Brands (BrandId, BrandName) VALUES (15, N'CNC Racing');
INSERT INTO Brands (BrandId, BrandName) VALUES (16, N'Biker');
INSERT INTO Brands (BrandId, BrandName) VALUES (17, N'Khác');
INSERT INTO Brands (BrandId, BrandName) VALUES (18, N'Akrapovic');
INSERT INTO Brands (BrandId, BrandName) VALUES (19, N'Honda');
INSERT INTO Brands (BrandId, BrandName) VALUES (20, N'UMA Racing');
INSERT INTO Brands (BrandId, BrandName) VALUES (21, N'Galfer');
INSERT INTO Brands (BrandId, BrandName) VALUES (22, N'Elig');
INSERT INTO Brands (BrandId, BrandName) VALUES (23, N'TWM');
INSERT INTO Brands (BrandId, BrandName) VALUES (24, N'Koso');
INSERT INTO Brands (BrandId, BrandName) VALUES (25, N'HEL');
INSERT INTO Brands (BrandId, BrandName) VALUES (26, N'UMA');
INSERT INTO Brands (BrandId, BrandName) VALUES (27, N'Bando');
INSERT INTO Brands (BrandId, BrandName) VALUES (28, N'Dr.Pulley');
INSERT INTO Brands (BrandId, BrandName) VALUES (29, N'DNA');
INSERT INTO Brands (BrandId, BrandName) VALUES (30, N'RCB');
INSERT INTO Brands (BrandId, BrandName) VALUES (31, N'SC Project');
INSERT INTO Brands (BrandId, BrandName) VALUES (32, N'Nissin');
INSERT INTO Brands (BrandId, BrandName) VALUES (33, N'BRT');
INSERT INTO Brands (BrandId, BrandName) VALUES (34, N'Motul');
INSERT INTO Brands (BrandId, BrandName) VALUES (35, N'Universal');
INSERT INTO Brands (BrandId, BrandName) VALUES (36, N'Carbon Style');
INSERT INTO Brands (BrandId, BrandName) VALUES (37, N'Titan Racing');
SET IDENTITY_INSERT Brands OFF;
GO

-- INSERT PRODUCTS
SET IDENTITY_INSERT Products ON;
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (1, 79, 34, N'Dầu nhớt Motul 7100 10W40', 'dau-nhot-motul-7100-10w40', N'Dầu nhớt Motul 7100 10W40 là dòng dầu nhớt tổng hợp cao cấp nổi tiếng đến từ Pháp, được phát triển dành riêng cho các dòng xe côn tay và xe thể thao vận hành ở hiệu suất cao. Sản phẩm sử dụng công nghệ Ester độc quyền giúp tạo lớp màng bôi trơn bền chắc, giảm tối đa ma sát giữa các chi tiết máy và bảo vệ động cơ trong điều kiện hoạt động liên tục ở nhiệt độ cao. Nhờ khả năng ổn định độ nhớt cực tốt, dầu giúp động cơ vận hành êm ái, sang số nhẹ và hạn chế nóng máy khi đi đường dài hoặc chạy tốc độ cao. Ngoài ra, công thức phụ gia hiện đại còn giúp làm sạch cặn bẩn bên trong động cơ, kéo dài tuổi thọ máy và tăng độ bền cho hộp số. Đây là lựa chọn hàng đầu cho người dùng muốn tối ưu hiệu suất và bảo vệ động cơ lâu dài.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (2, 1, 1, N'Lốp Michelin Pilot Street 2', 'lop-michelin-pilot-street-2', N'Lốp Michelin Pilot Street 2 là dòng lốp hiệu năng cao được thiết kế nhằm tối ưu độ bám đường và khả năng vận hành ổn định trong điều kiện đô thị. Với hợp chất cao su chứa Silica tiên tiến, sản phẩm cho độ bám vượt trội khi di chuyển trên đường khô lẫn mặt đường ướt, giúp tăng độ an toàn khi ôm cua hoặc phanh gấp. Thiết kế gai lốp hiện đại hỗ trợ thoát nước nhanh, hạn chế hiện tượng trượt bánh khi đi mưa và giúp xe vận hành ổn định ở tốc độ cao. Cấu trúc lốp được gia cường giúp tăng độ bền, chống mài mòn không đều và kéo dài tuổi thọ sử dụng. Michelin Pilot Street 2 là lựa chọn phù hợp cho người dùng cần sự cân bằng giữa độ bền, độ bám và cảm giác lái thể thao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (3, 80, 2, N'Ắc quy GS GTZ6V', 'ac-quy-gs-gtz6v', N'Ắc quy GS GTZ6V là dòng ắc quy khô cao cấp được sản xuất theo công nghệ Nhật Bản, nổi bật với khả năng đề nổ mạnh và hoạt động ổn định trong thời gian dài. Thiết kế kín khí hoàn toàn giúp sản phẩm không cần bảo dưỡng định kỳ, hạn chế rò rỉ dung dịch và tăng độ an toàn khi sử dụng. Bên cạnh đó, khả năng lưu trữ điện năng tốt giúp xe khởi động nhanh ngay cả trong điều kiện thời tiết lạnh hoặc sau thời gian dài không sử dụng. Vỏ ngoài được làm từ nhựa ABS chịu nhiệt và chống va đập hiệu quả, giúp tăng độ bền trong quá trình vận hành hàng ngày. Đây là lựa chọn đáng tin cậy cho nhiều dòng xe phổ thông hiện nay.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (4, 3, 3, N'Bugi NGK Iridium', 'bugi-ngk-iridium', N'Bugi NGK Iridium là dòng bugi hiệu năng cao sử dụng điện cực Iridium siêu nhỏ giúp tạo tia lửa mạnh và ổn định hơn so với bugi thông thường. Nhờ khả năng đánh lửa chính xác, nhiên liệu được đốt cháy hiệu quả hơn, giúp động cơ tăng tốc mượt, tiết kiệm xăng và giảm khí thải. Sản phẩm có khả năng chịu nhiệt cực tốt, hoạt động ổn định trong điều kiện động cơ vận hành liên tục ở vòng tua cao. Ngoài ra, tuổi thọ của bugi Iridium cao hơn nhiều lần so với bugi tiêu chuẩn, giúp người dùng tiết kiệm chi phí bảo dưỡng và thay thế trong thời gian dài sử dụng.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (5, 4, 4, N'Phanh đĩa Brembo', 'phanh-ia-brembo', N'Phanh đĩa Brembo là dòng sản phẩm cao cấp nổi tiếng toàn cầu với khả năng mang lại hiệu suất phanh mạnh mẽ và độ an toàn vượt trội trong mọi điều kiện vận hành. Sản phẩm được chế tạo từ thép không gỉ và hợp kim nhôm cao cấp giúp tăng độ cứng, chịu nhiệt tốt và hạn chế biến dạng khi phanh liên tục ở tốc độ cao. Thiết kế floating disc hiện đại giúp giảm rung lắc, tăng độ ổn định và cải thiện cảm giác bóp phanh chính xác hơn cho người lái. Ngoài ra, các lỗ thoát nhiệt được bố trí khoa học giúp giảm nhiệt nhanh, hạn chế tình trạng mất phanh do quá nhiệt và giữ hiệu suất hoạt động ổn định trong thời gian dài. Đây là lựa chọn lý tưởng cho những người yêu thích cảm giác lái thể thao và muốn nâng cấp khả năng kiểm soát xe tối đa.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (6, 81, 5, N'Gương chiếu hậu Rizoma', 'guong-chieu-hau-rizoma', N'Gương chiếu hậu Rizoma là phụ kiện cao cấp mang phong cách thiết kế thể thao và hiện đại, được nhiều biker lựa chọn để nâng cấp ngoại hình xe. Sản phẩm được gia công CNC từ nhôm nguyên khối với độ hoàn thiện cực kỳ sắc sảo, vừa đảm bảo độ bền cao vừa mang lại vẻ ngoài sang trọng. Phần mặt gương sử dụng kính chống chói màu xanh giúp hạn chế ánh sáng mạnh từ đèn xe phía sau, mang lại tầm nhìn rõ ràng và dễ chịu hơn khi di chuyển ban đêm. Thiết kế khí động học giúp giảm rung khi chạy tốc độ cao, đảm bảo hình ảnh phản chiếu luôn ổn định. Ngoài tính thẩm mỹ, gương Rizoma còn giúp tăng độ an toàn nhờ góc quan sát rộng và khả năng điều chỉnh linh hoạt.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (7, 6, 6, N'Lọc gió K&N', 'loc-gio-kn', N'Lọc gió K&N là dòng lọc gió hiệu năng cao nổi tiếng trên toàn thế giới, được thiết kế nhằm tăng lưu lượng không khí nạp vào buồng đốt để cải thiện hiệu suất động cơ. Sản phẩm sử dụng cấu trúc nhiều lớp cotton cao cấp được tẩm dầu đặc biệt giúp lọc sạch bụi bẩn nhưng vẫn đảm bảo lượng gió lưu thông tối đa. Nhờ đó, động cơ phản hồi ga nhạy hơn, tăng tốc mượt và cải thiện sức kéo ở dải tua cao. Điểm nổi bật của lọc gió K&N là khả năng tái sử dụng lâu dài, người dùng chỉ cần vệ sinh định kỳ thay vì thay mới như lọc giấy truyền thống. Đây là phụ kiện phù hợp cho những ai muốn nâng cấp hiệu năng xe nhưng vẫn đảm bảo độ bền và tiết kiệm chi phí lâu dài.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (8, 82, 7, N'Sên DID 428', 'sen-did-428', N'Sên DID 428 là dòng sên truyền động chất lượng cao được sản xuất theo tiêu chuẩn Nhật Bản, nổi tiếng với độ bền và khả năng chịu tải vượt trội. Sản phẩm được chế tạo từ thép hợp kim cường lực trải qua quy trình nhiệt luyện hiện đại giúp tăng độ cứng và giảm hiện tượng giãn sên trong quá trình sử dụng lâu dài. Nhờ thiết kế mắt sên chính xác, sản phẩm giúp truyền động mượt mà, giảm tiếng ồn và hạn chế hao hụt công suất khi vận hành. Phiên bản Gold còn được phủ lớp chống gỉ cao cấp giúp tăng tuổi thọ và tạo điểm nhấn thẩm mỹ nổi bật cho xe. Đây là lựa chọn phù hợp cho cả xe đi phố lẫn xe độ hiệu năng cao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (9, 8, 8, N'Nhông sên dĩa Recto', 'nhong-sen-dia-recto', N'Bộ nhông sên dĩa Recto là giải pháp nâng cấp hệ truyền động toàn diện giúp xe vận hành mượt mà và tối ưu khả năng tăng tốc. Sản phẩm được gia công từ thép hợp kim C45 chất lượng cao với công nghệ CNC chính xác, giúp từng mắt sên và bánh răng ăn khớp hoàn hảo, hạn chế rung lắc và giảm hao hụt công suất khi truyền động. Bề mặt được xử lý nhiệt nhằm tăng độ cứng và chống mài mòn hiệu quả trong điều kiện sử dụng lâu dài. Nhờ thiết kế chuẩn xác, bộ nhông sên dĩa giúp xe tăng tốc tốt hơn, vận hành êm hơn và kéo dài tuổi thọ cho toàn bộ hệ truyền động. Đây là lựa chọn phù hợp cho người dùng muốn nâng cấp cả hiệu năng lẫn độ bền cho xe.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (10, 9, 9, N'Tay thắng CRG', 'tay-thang-crg', N'Tay thắng CRG là phụ kiện cao cấp dành cho những người yêu thích phong cách lái thể thao và cần sự chính xác trong từng thao tác phanh. Sản phẩm được gia công từ nhôm CNC nguyên khối với độ hoàn thiện cực kỳ tinh xảo, mang lại cảm giác chắc chắn nhưng vẫn giữ trọng lượng nhẹ để tối ưu thao tác điều khiển. Thiết kế công thái học ôm sát ngón tay giúp giảm mỏi khi sử dụng lâu dài, đặc biệt phù hợp với những chuyến đi xa hoặc điều kiện giao thông đông đúc. Điểm nổi bật của tay thắng CRG là khả năng chỉnh xa gần linh hoạt cùng cơ chế gập chống gãy, giúp hạn chế hư hỏng khi va chạm và tăng độ bền cho sản phẩm. Ngoài hiệu năng sử dụng, thiết kế sắc sảo và hiện đại còn giúp dàn lái xe trở nên nổi bật và đậm chất thể thao hơn.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (11, 10, 10, N'Đèn LED trợ sáng L4X', 'en-led-tro-sang-l4x', N'Đèn LED trợ sáng L4X là giải pháp +chiếu sáng hiệu suất cao dành cho những người thường xuyên di chuyển ban đêm hoặc đi tour đường dài. Sản phẩm sử dụng chip LED thế hệ mới cho ánh sáng mạnh, độ gom tốt giúp tăng tầm nhìn xa và rõ nét hơn đáng kể so với đèn zin. Ánh sáng trắng 6000K hỗ trợ quan sát tốt trong nhiều điều kiện thời tiết mà không gây chói mắt hay mỏi mắt khi sử dụng lâu. Thân đèn được gia công từ nhôm CNC nguyên khối giúp tản nhiệt nhanh, duy trì hiệu suất ổn định và kéo dài tuổi thọ. Chuẩn chống nước IP68 giúp đèn hoạt động bền bỉ dưới mưa lớn, bùn đất và môi trường khắc nghiệt.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (12, 11, 11, N'Phuộc sau YSS', 'phuoc-sau-yss', N'Phuộc sau YSS là dòng giảm xóc cao cấp giúp cải thiện rõ rệt độ êm ái và khả năng ổn định của xe khi vận hành trên nhiều loại địa hình. Thiết kế mono-shock hiện đại kết hợp hệ thống thủy lực tiên tiến giúp hấp thụ lực hiệu quả khi đi qua ổ gà, đường xấu hoặc khi chở nặng. Nhờ khả năng đàn hồi chính xác, phuộc giúp xe giữ thăng bằng tốt hơn khi vào cua hoặc chạy tốc độ cao, hạn chế tình trạng sàn lắc. Sản phẩm còn giúp tăng độ bám đường của bánh sau, mang lại cảm giác lái chắc chắn và an toàn hơn. Đây là lựa chọn nâng cấp đáng giá so với phuộc zin cho người dùng thường xuyên di chuyển.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (13, 12, 12, N'Bộ nồi độ SSS', 'bo-noi-o-sss', N'Bộ nồi độ SSS là giải pháp nâng cấp hiệu suất truyền động giúp xe tăng tốc nhanh hơn và vận hành mượt mà hơn. Sản phẩm được chế tạo từ vật liệu chịu nhiệt cao kết hợp lá bố chất lượng, giúp hạn chế tối đa tình trạng trượt nồi khi tăng ga mạnh. Khi lắp đặt, xe sẽ có khả năng đề-pa tốt hơn, phản hồi ga nhanh và sang số dứt khoát hơn. Ngoài ra, bộ nồi còn giúp giảm rung giật khi vận hành trong điều kiện tải nặng hoặc đi đường dài. Đây là lựa chọn phù hợp cho cả xe đi phố lẫn xe độ hiệu năng cao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (14, 13, 13, N'Cùm tăng tốc Domino', 'cum-tang-toc-domino', N'Cùm tăng tốc Domino là phụ kiện giúp rút ngắn hành trình tay ga, mang lại khả năng tăng tốc nhanh và phản hồi động cơ gần như tức thì. Sản phẩm đặc biệt phù hợp với những người yêu thích cảm giác lái thể thao hoặc xe đã nâng cấp công suất. Được gia công từ nhôm CNC nguyên khối, cùm ga đảm bảo độ chính xác cao và độ bền lâu dài trong quá trình sử dụng. Hệ thống dây ga đi kèm chống giãn giúp duy trì hiệu suất ổn định theo thời gian. Khi sử dụng, người lái sẽ cảm nhận rõ sự khác biệt về độ nhạy và khả năng kiểm soát ga.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (15, 14, 14, N'Kính chắn gió Puig', 'kinh-chan-gio-puig', N'Kính chắn gió Puig được thiết kế dựa trên nguyên lý khí động học nhằm giảm lực cản gió và hạn chế gió tạt trực tiếp vào người lái. Sản phẩm giúp tăng sự ổn định khi chạy ở tốc độ cao và giảm mệt mỏi trong những chuyến đi dài. Chất liệu nhựa cao cấp có độ trong suốt cao, chống trầy xước và chịu lực tốt khi va chạm nhẹ. Ngoài ra, kính còn có khả năng chống tia UV giúp bảo vệ người lái khỏi ánh nắng gắt. Đây là phụ kiện vừa nâng cao trải nghiệm lái vừa tăng tính thẩm mỹ cho xe.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (16, 22, 4, N'Heo dầu Brembo M4', 'heo-dau-brembo-m4', N'Heo dầu Brembo M4 là dòng kẹp phanh hiệu suất cao được thiết kế dành cho các dòng xe thể thao và xe phân khối lớn cần lực phanh mạnh mẽ và ổn định. Với cấu tạo 4 piston đối xứng, sản phẩm tạo lực ép đồng đều lên má phanh giúp xe giảm tốc nhanh nhưng vẫn giữ được độ mượt và kiểm soát tốt. Phần thân heo được đúc nguyên khối từ hợp kim nhôm cao cấp giúp tăng độ cứng và khả năng tản nhiệt hiệu quả trong điều kiện phanh liên tục. Thiết kế logo Brembo đỏ nổi bật kết hợp kiểu dáng thể thao giúp tăng thêm vẻ hầm hố và đẳng cấp cho dàn chân xe. Đây là lựa chọn được nhiều biker yêu thích nhờ hiệu năng và độ bền vượt trội.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (17, 23, 21, N'Đĩa thắng Galfer', 'ia-thang-galfer', N'Đĩa thắng Galfer là sản phẩm nổi tiếng với khả năng tản nhiệt nhanh và độ ổn định cao trong quá trình phanh ở tốc độ lớn. Sản phẩm được chế tạo từ thép High-Carbon giúp tăng độ cứng và chống cong vênh hiệu quả khi hoạt động trong điều kiện nhiệt độ cao. Thiết kế dạng Wave hiện đại không chỉ tăng tính thẩm mỹ mà còn giúp thoát bụi, thoát nước nhanh và cải thiện độ bám của má phanh lên bề mặt đĩa. Khi kết hợp với heo dầu hiệu năng cao, đĩa Galfer mang lại cảm giác bóp phanh chính xác và an toàn hơn đáng kể. Đây là lựa chọn phù hợp cho cả xe đi phố lẫn xe độ thể thao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (18, 24, 22, N'Bố thắng Elig', 'bo-thang-elig', N'Bố thắng Elig được sản xuất theo công nghệ hợp kim hiện đại giúp tăng độ bám lên bề mặt đĩa và mang lại hiệu quả phanh ổn định trong nhiều điều kiện vận hành khác nhau. Sản phẩm có khả năng chịu nhiệt cao, hạn chế hiện tượng cháy bố hoặc mất lực phanh khi rà phanh liên tục trên đường đèo hoặc khi chạy tốc độ cao. Ngoài ra, chất liệu cao cấp còn giúp giảm tiếng kêu khó chịu và hạn chế bụi phanh bám vào dàn chân xe. Với độ mòn đều và tuổi thọ cao, bố thắng Elig là lựa chọn phù hợp cho người dùng cần sự an toàn và bền bỉ trong quá trình sử dụng hàng ngày.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (19, 25, 23, N'Tay côn TWM', 'tay-con-twm', N'Tay côn TWM là phụ kiện cao cấp giúp cải thiện cảm giác bóp côn và mang lại trải nghiệm sang số mượt mà hơn cho người lái xe côn tay. Sản phẩm được gia công CNC từ nhôm nguyên khối với độ hoàn thiện sắc sảo, vừa đảm bảo độ bền cao vừa giúp tổng thể dàn lái trở nên sang trọng hơn. Cơ chế đòn bẩy thông minh giúp giảm đáng kể lực bóp côn, hạn chế tình trạng mỏi tay khi di chuyển đường dài hoặc đi trong phố đông. Ngoài ra, tay côn còn hỗ trợ chỉnh khoảng cách linh hoạt phù hợp với nhiều kích cỡ bàn tay khác nhau, giúp người dùng dễ dàng tùy chỉnh theo thói quen sử dụng.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (20, 83, 35, N'Dè chắn bùn Carbon', 'de-chan-bun-carbon', N'Dè chắn bùn Carbon là phụ kiện giúp bảo vệ dàn chân và lốc máy khỏi bùn đất, nước bẩn hoặc đá văng trong quá trình vận hành. Sản phẩm được chế tạo từ sợi Carbon cao cấp với trọng lượng cực nhẹ nhưng vẫn đảm bảo độ cứng và khả năng chịu lực tốt hơn nhiều so với nhựa thông thường. Thiết kế ôm sát bánh xe giúp hạn chế rung lắc khi chạy tốc độ cao đồng thời tăng tính khí động học cho xe. Ngoài công dụng bảo vệ, các đường vân carbon 3D sắc nét còn giúp tổng thể xe trở nên hiện đại, thể thao và đậm chất độ hơn. Đây là món phụ kiện được nhiều biker lựa chọn để nâng cấp ngoại hình xe.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (21, 20, 19, N'Lọc nhớt Honda', 'loc-nhot-honda', N'Lọc nhớt Honda là bộ phận quan trọng giúp giữ cho dầu nhớt luôn sạch sẽ trong suốt quá trình động cơ vận hành. Sản phẩm có khả năng loại bỏ hiệu quả cặn bẩn, mạt kim loại và tạp chất sinh ra từ ma sát bên trong động cơ, từ đó giúp dầu lưu thông ổn định và duy trì khả năng bôi trơn tối ưu. Nhờ sử dụng vật liệu giấy lọc cao cấp cùng cấu trúc xếp lớp khoa học, lọc nhớt vẫn đảm bảo lưu lượng dầu ổn định ngay cả khi xe vận hành ở vòng tua cao. Việc thay lọc nhớt định kỳ giúp giảm hao mòn động cơ, tăng tuổi thọ máy và hạn chế các hư hỏng nghiêm trọng trong quá trình sử dụng lâu dài. Đây là phụ tùng thiết yếu giúp động cơ Honda luôn hoạt động bền bỉ và êm ái.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (22, 21, 20, N'Dây ga UMA Racing', 'day-ga-uma-racing', N'Dây ga UMA Racing là phụ kiện nâng cấp giúp cải thiện đáng kể độ nhạy của tay ga và khả năng phản hồi động cơ. Sản phẩm sử dụng lõi cáp thép cường lực có độ bền cao, chống giãn hiệu quả trong quá trình sử dụng lâu dài, giúp hành trình ga luôn chính xác và mượt mà. Lớp vỏ ngoài được thiết kế với vật liệu giảm ma sát giúp thao tác kéo ga nhẹ hơn, hạn chế hiện tượng nặng ga khi di chuyển trong đô thị hoặc đi tour đường dài. Khi lắp đặt, người lái có thể cảm nhận rõ sự khác biệt về độ bốc của xe cũng như khả năng tăng tốc nhanh và ổn định hơn. Đây là lựa chọn phù hợp cho các bản độ chú trọng hiệu suất vận hành và cảm giác lái thể thao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (23, 22, 4, N'Heo dầu Brembo M4', 'heo-dau-brembo-m4', N'Heo dầu Brembo M4 là dòng kẹp phanh cao cấp nổi tiếng với khả năng mang lại lực phanh cực mạnh và độ ổn định vượt trội trong mọi điều kiện vận hành. Sản phẩm sử dụng cấu trúc 4 piston đối xứng giúp phân bổ lực ép đều lên má phanh, từ đó tăng hiệu quả hãm tốc và kiểm soát xe tốt hơn khi phanh gấp. Phần thân heo được đúc nguyên khối từ hợp kim nhôm chất lượng cao giúp giảm trọng lượng nhưng vẫn đảm bảo độ cứng và khả năng chịu nhiệt tối ưu. Hệ thống tản nhiệt hiệu quả giúp hạn chế hiện tượng mất phanh khi hoạt động liên tục ở cường độ cao. Với thiết kế thể thao và logo Brembo nổi bật, đây không chỉ là món nâng cấp hiệu năng mà còn giúp tăng tính thẩm mỹ cho xe.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (24, 23, 21, N'Đĩa thắng Galfer', 'ia-thang-galfer', N'Đĩa thắng Galfer là dòng đĩa phanh hiệu năng cao được thiết kế nhằm tối ưu khả năng phanh và độ ổn định khi vận hành tốc độ lớn. Sản phẩm sử dụng thép không gỉ High-Carbon có độ cứng cao giúp hạn chế cong vênh và tăng khả năng chịu nhiệt trong quá trình phanh liên tục. Thiết kế dạng Wave đặc trưng không chỉ mang tính thẩm mỹ mà còn giúp tản nhiệt nhanh, loại bỏ bụi bẩn và nước trên bề mặt má phanh hiệu quả hơn. Điều này giúp duy trì độ bám ổn định và tăng độ an toàn khi vận hành trong điều kiện đường ướt hoặc địa hình khó. Với ngoại hình mạnh mẽ và chất lượng cao cấp, Galfer là lựa chọn phổ biến cho cả xe zin lẫn xe độ hiệu năng cao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (25, 24, 22, N'Bố thắng Elig', 'bo-thang-elig', N'Bố thắng Elig là dòng má phanh chất lượng cao mang lại lực phanh ổn định và cảm giác bóp thắng chắc chắn trong nhiều điều kiện vận hành khác nhau. Sản phẩm sử dụng hợp kim thiêu kết chịu nhiệt giúp duy trì hệ số ma sát ổn định ngay cả khi phanh liên tục trên đường đèo hoặc khi di chuyển tốc độ cao. Điểm nổi bật của bố thắng Elig là khả năng mòn đều, hạn chế tình trạng ăn đĩa và giảm tối đa tiếng kêu khó chịu khi phanh. Ngoài ra, vật liệu cao cấp còn giúp kéo dài tuổi thọ sử dụng và hạn chế bụi phanh bám lên dàn chân xe. Đây là lựa chọn phù hợp cho người dùng cần sự an toàn, bền bỉ và hiệu quả phanh cao.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (26, 25, 23, N'Tay côn TWM', 'tay-con-twm', N'Tay côn TWM là phụ kiện cao cấp giúp cải thiện đáng kể cảm giác bóp côn và khả năng sang số khi vận hành xe côn tay. Sản phẩm được gia công CNC từ nhôm 6061 nguyên khối với độ hoàn thiện cao, mang lại độ cứng chắc nhưng vẫn đảm bảo trọng lượng nhẹ. Cơ chế đòn bẩy tối ưu giúp giảm lực bóp côn, hạn chế mỏi tay khi di chuyển đường dài hoặc trong điều kiện giao thông đông đúc. Thiết kế công thái học ôm sát tay người dùng kết hợp khả năng chỉnh xa gần giúp thao tác dễ dàng và chính xác hơn. Ngoài ra, lớp anodized cao cấp còn giúp sản phẩm chống ăn mòn và giữ màu sắc bền đẹp theo thời gian.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (27, 83, 36, N'Dè chắn bùn Carbon', 'de-chan-bun-carbon', N'Dè chắn bùn Carbon là phụ kiện giúp bảo vệ xe khỏi bùn đất, nước bẩn và đá văng trong quá trình vận hành, đồng thời tăng mạnh tính thẩm mỹ cho dàn chân xe. Sản phẩm được chế tác từ sợi carbon cao cấp với các đường vân 3D đặc trưng tạo nên vẻ ngoài cực kỳ sang trọng và thể thao. Chất liệu carbon không chỉ nhẹ mà còn có độ cứng cao hơn nhiều so với nhựa thông thường, giúp dè ổn định khi xe chạy tốc độ lớn. Thiết kế khí động học ôm sát bánh xe giúp giảm rung lắc và tăng hiệu quả chắn bùn. Đây là món nâng cấp vừa mang tính bảo vệ vừa giúp chiếc xe trở nên nổi bật hơn đáng kể.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (28, 27, 15, N'Chắn xích CNC', 'chan-xich-cnc', N'Chắn xích CNC là phụ kiện giúp bảo vệ hệ thống sên và tăng tính thẩm mỹ cho phần gắp sau của xe. Sản phẩm được gia công bằng công nghệ CNC từ nhôm nguyên khối với độ chính xác cao, mang lại độ cứng chắc và độ bền vượt trội trong quá trình sử dụng lâu dài. Thiết kế gọn gàng giúp hạn chế bùn đất và dầu mỡ văng ra ngoài, giữ cho dàn chân và dàn áo luôn sạch sẽ hơn khi vận hành. Lớp sơn tĩnh điện giúp sản phẩm chống trầy xước, chống oxy hóa và duy trì vẻ ngoài bền đẹp theo thời gian. Đây là món phụ kiện nhỏ nhưng giúp tổng thể chiếc xe trở nên thể thao và cứng cáp hơn rõ rệt.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (29, 28, 37, N'Cổ pô Titan', 'co-po-titan', N'Cổ pô Titan là trang bị nâng cấp hiệu năng giúp tối ưu luồng khí xả và cải thiện khả năng vận hành của động cơ. Sản phẩm sử dụng titanium cao cấp có trọng lượng nhẹ hơn đáng kể so với inox hoặc thép thông thường, giúp giảm tải cho xe và tăng độ bền trong điều kiện nhiệt độ cao. Thiết kế uốn cong chính xác giúp khí xả lưu thông mượt mà hơn, hỗ trợ động cơ tăng tốc tốt và cải thiện tiếng pô uy lực hơn. Một trong những điểm đặc trưng của cổ pô titan là khả năng đổi màu xanh tím đẹp mắt khi tiếp xúc nhiệt độ cao, tạo nên vẻ ngoài cực kỳ nổi bật cho xe. Đây là món nâng cấp được nhiều biker yêu thích cả về hiệu năng lẫn tính thẩm mỹ.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (30, 29, 24, N'Đồng hồ Koso', 'ong-ho-koso', N'Đồng hồ Koso là thiết bị hiển thị điện tử hiện đại giúp người lái dễ dàng theo dõi toàn bộ thông số vận hành của xe một cách trực quan và chính xác. Sản phẩm sử dụng màn hình LCD sắc nét với khả năng hiển thị rõ ràng cả ngày lẫn đêm, hỗ trợ xem vận tốc, vòng tua máy, nhiệt độ động cơ, mức nhiên liệu và nhiều thông tin khác. Ngoài thiết kế thể thao và hiện đại, đồng hồ còn được trang bị khả năng chống nước và chống chói giúp hoạt động ổn định trong nhiều điều kiện thời tiết. Các hiệu ứng LED khởi động bắt mắt mang lại cảm giác công nghệ cao và tăng tính thẩm mỹ cho khu vực ghi đông. Đây là món phụ kiện cực kỳ phù hợp cho các bản độ yêu thích phong cách hiện đại và chuyên nghiệp.', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (31, 30, 16, N'Gác chân Biker', 'gac-chan-biker', N'Gác chân Biker là món phụ kiện nâng cấp thiết thực giúp tối ưu hóa tư thế lái và tăng cường độ bám cho lòng bàn chân trong suốt quá trình điều khiển xe. Sản phẩm được gia công bằng công nghệ CNC từ nhôm khối với độ chính xác cực cao, bề mặt được tạo hình các vân răng cưa hoặc gai nhỏ giúp chống trượt hiệu quả, đảm bảo chân người lái luôn được giữ chắc chắn ngay cả khi di chuyển dưới trời mưa tầm tã hoặc trong môi trường đường xá bùn lầy trơn trượt. Với kiểu dáng mang đậm phong cách thể thao và màu sơn điện phân bền bỉ, gác chân Biker không chỉ nâng cao tính an toàn mà còn là điểm nhấn thẩm mỹ mạnh mẽ cho dàn chân của chiếc xe, mang lại cảm giác chuyên nghiệp và tự tin hơn khi vào cua hay vận hành ở tốc độ cao.


Thông số
Chất liệu: Nhôm T6061 CNC nguyên khối
Tính năng: Bề mặt răng cưa chống trượt cường độ cao
Hoàn thiện: Sơn Anodized chống trầy xước
Thiết kế: Công thái học phù hợp với nhiều kích cỡ giày', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (32, 31, 5, N'Bình dầu Rizoma', 'binh-dau-rizoma', N'Bình dầu Rizoma là món phụ kiện trang trí cao cấp thay thế cho bình chứa dầu phanh hoặc dầu côn nhựa nguyên bản vốn đơn điệu. Sản phẩm được chế tác tỉ mỉ từ nhôm CNC chất lượng cao, có khả năng chống ăn mòn tuyệt vời bởi các thành phần hóa học có trong dầu phanh. Thiết kế của Rizoma luôn dẫn đầu về xu hướng thẩm mỹ với các đường nét tinh tế, kết hợp cùng phần kính quan sát trong suốt chịu lực cao giúp người dùng dễ dàng kiểm tra mức dầu và màu sắc dầu bên trong để kịp thời bảo trì, đảm bảo hệ thống phanh luôn hoạt động an toàn. Đây là điểm nhấn không thể thiếu trên ghi-đông của những bản độ xe sang trọng, mang lại diện mạo hiện đại và đẳng cấp cho khu vực điều khiển.


Thông số
Chất liệu: Nhôm máy bay CNC + Kính chịu lực
Tính năng: Chứa dầu phanh/côn, chống rò rỉ tuyệt đối
Màu sắc: Đen / Bạc / Vàng
Tương thích: Các dòng cùm phanh đĩa và cùm côn dầu', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (33, 32, 17, N'Lưới bảo vệ két nước', 'luoi-bao-ve-ket-nuoc', N'Lưới bảo vệ két nước là lớp giáp bảo vệ quan trọng cho hệ thống làm mát của xe, đặc biệt đối với các dòng xe có két nước nằm ở vị trí dễ bị tổn thương. Sản phẩm đóng vai trò ngăn chặn các loại đá dăm, cát bẩn và các vật thể lạ bắn thẳng vào các lá nhôm tản nhiệt mỏng manh khi xe di chuyển ở tốc độ cao, từ đó triệt tiêu nguy cơ móp méo lá nhôm hoặc nghiêm trọng hơn là rò rỉ nước làm mát dẫn đến nóng máy. Được làm từ thép hoặc inox chắc chắn với các lỗ thoáng khí được tính toán khoa học, lưới bảo vệ vẫn đảm bảo lưu lượng gió đi qua làm mát két nước một cách tối ưu nhất. Đây là món phụ kiện cực kỳ cần thiết cho những biker thường xuyên thực hiện các chuyến hành trình dài hoặc di chuyển trên những cung đường đang thi công.


Thông số
Chất liệu: Thép hợp kim hoặc Inox 304 không gỉ
Thiết kế: Dạng lưới tổ ong hoặc nan dọc thoáng khí
Tính năng: Chống va đập, bảo vệ lá nhôm két nước
Lắp đặt: Chuẩn zin theo từng dòng xe, không cần chế cháo', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (34, 33, 25, N'Dây dầu HEL', 'day-dau-hel', N'Dây dầu HEL là giải pháp nâng cấp hệ thống phanh chuyên nghiệp, giúp truyền tải áp suất thủy lực từ tay phanh xuống heo dầu một cách trực tiếp và mạnh mẽ nhất. Khác với dây dầu cao su nguyên bản thường bị giãn nở khi gặp nhiệt độ cao hoặc áp suất lớn, dây dầu HEL sử dụng lõi thép bện inox siêu bền, bọc ngoài là lớp bảo vệ Teflon cao cấp, giúp hạn chế tối đa sự giãn nở của dây. Kết quả là người lái sẽ cảm nhận được lực phanh cực kỳ chắc chắn, hành trình tay thắng ngắn lại và phản hồi phanh chính xác đến từng mili-giây. Sản phẩm giúp tăng cường hiệu suất phanh đáng kể, mang lại sự an tâm tuyệt đối khi phanh gấp ở tốc độ cao và là lựa chọn không thể thiếu cho các dòng xe đua hay xe độ hiệu năng cao.


Thông số
Cấu tạo: Lõi Teflon bọc lưới inox 304 chịu áp suất cao
Đầu bấm: Inox hoặc nhôm CNC chống rò rỉ
Tính năng: Không giãn nở, tăng lực phanh, chống ăn mòn
Tiêu chuẩn: Đạt chứng nhận an toàn quốc tế', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (35, 34, 13, N'Công tắc Domino', 'cong-tac-domino', N'Công tắc Domino là món phụ kiện tiện ích giúp người dùng điều khiển các thiết bị điện bổ sung trên xe như đèn trợ sáng, còi hụ hoặc hệ thống tắt máy tạm thời một cách chuyên nghiệp. Sản phẩm sở hữu thiết kế nhỏ gọn, tinh tế, dễ dàng tích hợp vào ghi-đông mà không gây cản trở các thao tác lái xe. Với chất liệu nhựa kỹ thuật kết hợp kim loại chống gỉ, các nút nhấn của Domino cho cảm giác bấm rất nảy, phản hồi tốt và có khả năng chống nước đạt chuẩn, đảm bảo hoạt động ổn định trong mọi điều kiện thời tiết khắc nghiệt. Đây là giải pháp hoàn hảo để quản lý hệ thống điện cho các bản độ xe có gắn thêm nhiều phụ kiện, giúp bảng điều khiển trở nên gọn gàng và khoa học hơn.


Thông số
Chất liệu: Nhựa ABS chịu nhiệt + Kim loại chống oxy hóa
Tính năng: Bật/Tắt thiết bị điện ngoại vi (Đèn, còi,...)
Chống nước: Tiêu chuẩn IP65/IP66
Lắp đặt: Gắn trực tiếp lên ghi-đông đường kính tiêu chuẩn', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (36, 35, 26, N'Bình xăng con UMA', 'binh-xang-con-uma', N'Bình xăng con UMA là phụ kiện nâng cấp động cơ đỉnh cao, giúp tối ưu hóa quá trình nạp nhiên liệu và không khí vào buồng đốt để sản sinh công suất lớn nhất. Sản phẩm được thiết kế với các đường dẫn xăng và họng nạp được gia công chính xác tuyệt đối, giúp hỗn hợp hòa khí được trộn đều và tơi mịn, từ đó giúp xe tăng tốc cực kỳ bốc và cải thiện momen xoắn ở mọi dải tua máy. Với công nghệ tiên tiến từ UMA Racing, bình xăng con này giúp triệt tiêu tình trạng hụp ga, mang lại sự ổn định cho động cơ ngay cả khi vận hành ở tốc độ tối đa. Đây là trang bị bắt buộc cho những biker muốn khai phá hết sức mạnh tiềm ẩn của khối động cơ trên các dòng xe máy phổ thông và xe độ máy chuyên nghiệp.


Thông số
Họng nạp: 28mm (Dòng họng tròn/họng dẹp)
Tính năng: Tăng lượng khí nạp, tối ưu hỗn hợp nhiên liệu
Đặc điểm: Dễ canh chỉnh, giúp xe ga đầu nhạy và ga cuối sâu
Phù hợp: Xe độ từ 135cc đến 175cc', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (37, 36, 17, N'Ốp pô Carbon', 'op-po-carbon', N'Ốp pô Carbon là món phụ kiện bảo vệ an toàn đồng thời mang lại giá trị thẩm mỹ vượt trội cho hệ thống ống xả của xe máy. Sản phẩm đóng vai trò là tấm chắn cách nhiệt hoàn hảo, giúp bảo vệ người ngồi sau và người lái tránh khỏi nguy cơ bị bỏng khi vô tình chạm vào pô xe đang nóng. Được làm từ sợi Carbon fiber thật, sản phẩm sở hữu đặc tính chịu nhiệt cực tốt, không bị giòn gãy hay biến dạng dưới tác động của hơi nóng từ ống xả tỏa ra. Với trọng lượng siêu nhẹ và vân carbon 3D bắt mắt, ốp pô Carbon giúp chiếc xe trở nên sang trọng, hiện đại và đậm chất thể thao hơn, đồng thời che đi những vết xước hoặc gỉ sét không đáng có trên thân pô nguyên bản.


Thông số
Chất liệu: Sợi Carbon nguyên chất (Real Carbon) chịu nhiệt
Tính năng: Chống bỏng, cách nhiệt ống xả, trang trí xe
Đặc điểm: Không bị ố vàng hay phồng rộp do nhiệt
Trọng lượng: Siêu nhẹ, độ bền cơ học cao', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (38, 37, 17, N'Móc treo đồ CNC', 'moc-treo-o-cnc', N'Móc treo đồ CNC là một phụ kiện nhỏ gọn nhưng mang lại sự tiện lợi vô cùng lớn cho người dùng xe máy trong các hoạt động di chuyển hàng ngày. Sản phẩm được cắt phay từ nhôm nguyên khối chắc chắn, cho khả năng chịu tải trọng lớn giúp bạn thoải mái treo túi xách, balo, nón bảo hiểm hay đồ dùng cá nhân mà không lo bị gãy hay cong vênh như các loại móc nhựa thông thường. Thiết kế của móc treo CNC rất đa dạng với các đường cắt sắc sảo, có tính năng gập mở linh hoạt hoặc khóa bảo vệ để đồ vật không bị rơi ra khi đi qua đoạn đường xóc. Việc lắp đặt vô cùng đơn giản trên nhiều dòng xe khác nhau, giúp không gian xe trở nên gọn gàng và tiện dụng hơn bao giờ hết.


Thông số
Chất liệu: Nhôm CNC T6 cao cấp
Tính năng: Treo đồ vật nặng, có khóa bảo vệ an toàn
Lắp đặt: Vị trí chân kính hoặc giữa yếm xe
Đặc điểm: Chống gỉ sét, màu sơn bền bỉ theo thời gian', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (39, 38, 17, N'Đèn xi nhan LED', 'en-xi-nhan-led', N'Đèn xi nhan LED là bản nâng cấp hoàn hảo thay thế cho hệ thống đèn sợi đốt truyền thống vốn tiêu tốn nhiều điện năng và ánh sáng không đủ rõ. Sản phẩm sử dụng hệ thống chip LED cường độ cao, mang lại ánh sáng rực rỡ và sắc nét, giúp các phương tiện xung quanh dễ dàng nhận diện tín hiệu chuyển hướng của bạn ngay cả trong điều kiện ánh sáng ban ngày gay gắt hay đêm tối mù sương. Với kích thước nhỏ gọn và thiết kế khí động học hiện đại, đèn xi nhan LED giúp loại bỏ phần đèn xi nhan rời cồng kềnh, làm cho xe trông thon gọn và thời trang hơn. Công nghệ LED không chỉ giúp tiết kiệm điện năng cho ắc quy mà còn có tuổi thọ cực cao, đảm bảo xe luôn hoạt động an toàn và ổn định.


Thông số
Loại chip: LED High-Intensity tiết kiệm điện
Tính năng: Tín hiệu rẽ (Xi nhan), có thể tích hợp định vị
Chống nước: Chuẩn IP67, hoạt động tốt dưới mưa
Thiết kế: Gọn nhẹ, phong cách thể thao hiện đại', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (40, 39, 17, N'Ốp bảo vệ tay lái', 'op-bao-ve-tay-lai', N'Ốp bảo vệ tay lái (Handguard) là phụ kiện thiết yếu giúp bảo vệ đôi bàn tay của người lái và các bộ phận điều khiển quan trọng như tay thắng, tay côn khỏi va chạm và tác động từ môi trường. Sản phẩm đặc biệt hữu ích khi di chuyển trong các khu vực đông đúc dễ xảy ra va chạm tay lái, hoặc khi đi tour qua các cung đường rừng núi có nhiều cành cây văng vào. Được làm từ nhựa ABS bền bỉ kết hợp với khung xương cứng cáp, ốp bảo vệ tay lái còn giúp cản gió lạnh tạt vào tay vào mùa đông và ngăn nước mưa bắn trực tiếp, giữ cho đôi bàn tay luôn khô ráo và ấm áp để điều khiển xe chính xác nhất. Với thiết kế hầm hố, sản phẩm mang lại vẻ ngoài Adventure cực kỳ mạnh mẽ và sẵn sàng cho mọi chuyến hành trình chinh phục thử thách.


Thông số
Chất liệu: Nhựa ABS chịu lực + Khung nhôm gia cường
Tính năng: Chống va đập tay lái, cản gió, chắn nước mưa
Phù hợp: Xe đi phố, xe phượt và các dòng xe địa hình
Lắp đặt: Gắn trực tiếp vào gù tay lái và ghi-đông', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (41, 40, 27, N'Dây curoa Bando', 'day-curoa-bando', N'Dây curoa Bando là bộ phận truyền động quan trọng trên các dòng xe tay ga hiện đại, giúp truyền tải công suất từ động cơ đến bánh sau một cách mượt mà và ổn định. Sản phẩm được sản xuất theo tiêu chuẩn Nhật Bản với chất liệu cao su tổng hợp cao cấp kết hợp sợi aramid chịu lực, mang lại khả năng chịu tải lớn và chống giãn cực tốt trong quá trình vận hành liên tục. Thiết kế răng cưa chuẩn xác giúp giảm ma sát, hạn chế tiếng ồn và duy trì khả năng tăng tốc ổn định cho xe. Ngoài ra, dây curoa còn có khả năng chịu nhiệt cao, chống nứt gãy hiệu quả khi hoạt động trong môi trường nhiệt độ lớn của bộ nồi xe tay ga. Đây là lựa chọn đáng tin cậy giúp xe vận hành êm ái và kéo dài tuổi thọ hệ truyền động.
Thông số
Chất liệu: Cao su tổng hợp gia cường sợi Aramid
Đặc điểm: Chống trượt truyền động, chịu nhiệt cao
Tính năng: Vận hành êm ái, giảm hao mòn bộ nồi
Độ bền: Khuyến nghị kiểm tra sau mỗi 10.000km', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (42, 41, 28, N'Bi nồi Dr.Pulley', 'bi-noi-drpulley', N'Bi nồi Dr.Pulley là sản phẩm nâng cấp nổi tiếng dành cho xe tay ga, giúp cải thiện đáng kể khả năng tăng tốc và độ mượt của hệ truyền động CVT. Khác với bi nồi tròn truyền thống, sản phẩm sở hữu thiết kế dạng trượt độc quyền giúp mở rộng hành trình puly, mang lại cảm giác ga đầu bốc hơn và ga cuối thoáng hơn rõ rệt. Chất liệu polymer cao cấp có khả năng tự bôi trơn giúp giảm ma sát, chống mài mòn và hạn chế hiện tượng móp bi sau thời gian dài sử dụng. Khi lắp đặt, xe sẽ tăng tốc mượt hơn, giảm rung giật ở dải tua thấp và hỗ trợ tiết kiệm nhiên liệu hiệu quả. Đây là món nâng cấp được nhiều người chơi xe tay ga lựa chọn để cải thiện trải nghiệm lái hằng ngày.
Thông số
Trọng lượng: 10g
Chất liệu: Polymer chịu nhiệt tự bôi trơn
Thiết kế: Dạng Sliding Roller chống móp
Hiệu năng: Tăng tốc nhanh, tối ưu ga cuối', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (43, 42, 17, N'Chuông nồi CNC', 'chuong-noi-cnc', N'Chuông nồi CNC là bộ phận quan trọng trong hệ thống truyền động xe tay ga, giúp truyền lực từ bố ba càng ra bánh sau một cách ổn định và hiệu quả. Sản phẩm được gia công CNC chính xác từ thép hợp kim cứng cáp, đảm bảo độ cân bằng động cao giúp xe vận hành êm hơn ở tốc độ lớn. Thiết kế bề mặt bên trong tối ưu giúp tăng độ bám của bố nồi, hạn chế hiện tượng trượt nồi và cải thiện khả năng bắt ga. Ngoài ra, các rãnh tản nhiệt trên thân chuông giúp giải nhiệt nhanh chóng khi xe hoạt động liên tục trong điều kiện giao thông đông đúc. Đây là phụ kiện nâng cấp hữu ích cho người dùng muốn cải thiện hiệu suất vận hành và độ bền bộ nồi xe tay ga.
Thông số
Chất liệu: Thép hợp kim độ cứng cao
Gia công: CNC chính xác, cân bằng động
Tính năng: Chống trượt nồi, tản nhiệt tốt
Lắp đặt: Chuẩn zin cho nhiều dòng xe tay ga', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (44, 43, 17, N'Lò xo nồi', 'lo-xo-noi', N'Lò xo nồi là chi tiết giúp điều chỉnh lực ép trong hệ thống truyền động, ảnh hưởng trực tiếp đến độ bốc và khả năng phản hồi ga của xe. Sản phẩm được chế tạo từ thép lò xo cường lực với độ đàn hồi ổn định, chịu nhiệt và chống lún tốt sau thời gian dài sử dụng. Khi nâng cấp lò xo nồi, xe sẽ có khả năng đề-pa mạnh hơn, phản hồi ga nhạy hơn và vận hành ổn định hơn ở vòng tua cao. Đây là món đồ chơi quen thuộc đối với những người thích tinh chỉnh đặc tính vận hành của xe tay ga hoặc xe độ hiệu năng cao.
Thông số
Chất liệu: Thép lò xo chịu nhiệt cao
Độ cứng: Cao hơn 10-20% so với zin
Tính năng: Tăng lực ép ly hợp, cải thiện gia tốc
Độ bền: Chống lún và biến dạng tốt', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (45, 44, 17, N'Dầu phanh DOT4', 'dau-phanh-dot4', N'Dầu phanh DOT4 là dung dịch thủy lực chuyên dụng dành cho hệ thống phanh đĩa, giúp truyền tải lực phanh ổn định và an toàn trong mọi điều kiện vận hành. Với nhiệt độ sôi cao hơn nhiều so với dầu DOT3 thông thường, sản phẩm hạn chế tối đa hiện tượng sôi dầu và mất phanh khi xe hoạt động liên tục ở tốc độ cao hoặc đổ đèo dài. Công thức dầu còn bổ sung các phụ gia chống oxy hóa và chống ăn mòn, giúp bảo vệ piston, dây dầu và gioăng cao su trong hệ thống phanh. Việc thay dầu định kỳ bằng dầu DOT4 chất lượng cao sẽ giúp tay phanh chắc hơn, phản hồi chính xác và duy trì độ an toàn tối ưu cho xe.
Thông số
Tiêu chuẩn: DOT4
Dung tích: 500ml
Tính năng: Chống sôi dầu, chống ăn mòn
Ưu điểm: Ổn định ở nhiệt độ cao', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (46, 45, 17, N'Nắp nhớt CNC', 'nap-nhot-cnc', N'Nắp nhớt CNC là phụ kiện nhỏ gọn nhưng mang lại điểm nhấn nổi bật cho phần lốc máy của xe. Sản phẩm được gia công từ nhôm CNC nguyên khối với độ hoàn thiện cao, giúp tăng tính thẩm mỹ đồng thời đảm bảo độ kín khít tốt hơn nắp nhựa thông thường. Bề mặt anodized chống trầy và chống bay màu hiệu quả, giúp sản phẩm luôn giữ được vẻ ngoài nổi bật sau thời gian dài sử dụng. Thiết kế các rãnh vặn tiện lợi giúp thao tác mở nắp nhanh chóng mà không cần dùng nhiều lực. Đây là món phụ kiện được nhiều biker lựa chọn để làm đẹp xe với chi phí hợp lý.
Thông số
Chất liệu: Nhôm CNC 6061
Hoàn thiện: Sơn Anodized chống phai màu
Tính năng: Chống rò rỉ nhớt, tăng thẩm mỹ
Phụ kiện: Kèm gioăng cao su chịu nhiệt', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (47, 46, 17, N'Cảm biến tốc độ', 'cam-bien-toc-o', N'Cảm biến tốc độ là thiết bị điện tử quan trọng giúp ghi nhận vận tốc thực tế của xe để truyền dữ liệu đến đồng hồ hiển thị và ECU trung tâm. Sản phẩm sử dụng công nghệ cảm biến Hall Effect hiện đại với khả năng phản hồi nhanh và độ chính xác cao trong nhiều điều kiện vận hành khác nhau. Vỏ ngoài được thiết kế chống nước và chống bụi giúp cảm biến hoạt động ổn định kể cả khi di chuyển dưới trời mưa hoặc môi trường nhiều bùn đất. Đây là bộ phận cần thiết giúp hệ thống ABS, đồng hồ điện tử và các chức năng hỗ trợ lái hoạt động chính xác và an toàn hơn.
Thông số
Loại: Hall Effect Sensor
Tính năng: Đo tốc độ xe, hỗ trợ ABS/Odo
Chống nước: Chuẩn IP67
Tương thích: Xe phun xăng điện tử đời mới', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (48, 47, 17, N'Bộ dây điện độ', 'bo-day-ien-o', N'Bộ dây điện độ là giải pháp nâng cấp hệ thống điện dành cho những chiếc xe được trang bị thêm nhiều phụ kiện như đèn trợ sáng, camera hành trình hay còi công suất lớn. Sản phẩm sử dụng lõi đồng nguyên chất có khả năng truyền tải điện ổn định, hạn chế sụt áp và giảm sinh nhiệt khi hoạt động lâu dài. Lớp vỏ bọc chống cháy và chịu nhiệt giúp tăng độ an toàn, ngăn ngừa nguy cơ chập cháy trong điều kiện môi trường khắc nghiệt. Ngoài ra, bộ dây còn được trang bị đầy đủ giắc cắm và cầu chì bảo vệ giúp việc lắp đặt trở nên chuyên nghiệp và gọn gàng hơn.
Thông số
Chất liệu: Lõi đồng nguyên chất
Vỏ bọc: Nhựa PVC chống cháy
Tính năng: Truyền điện ổn định, chống chập mạch
Bao gồm: Giắc cắm, cầu chì và ống gen bảo vệ', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (49, 48, 17, N'Khóa chống trộm Smart Lock', 'khoa-chong-trom-smart-lock', N'Khóa chống trộm Smart Lock là hệ thống bảo vệ thông minh giúp tăng cường an toàn cho xe trước các tình huống trộm cắp hiện nay. Sản phẩm sử dụng công nghệ mã hóa hiện đại cho phép xe chỉ khởi động khi có remote hoặc thiết bị nhận diện đi kèm trong phạm vi hoạt động. Ngoài chức năng khóa xe và chống dắt, hệ thống còn tích hợp còi báo động công suất lớn giúp cảnh báo ngay khi có tác động bất thường lên xe. Thiết kế hiện đại với vòng LED phát sáng giúp thao tác dễ dàng vào ban đêm, đồng thời mang lại vẻ ngoài cao cấp hơn cho xe máy. Đây là phụ kiện rất hữu ích đối với người thường xuyên gửi xe ở nơi công cộng.
Thông số
Loại: Smart Key System
Công nghệ: Mã hóa ID chống sao chép
Tính năng: Chống dắt, báo động, tìm xe
An toàn: Tự động khóa khi ra xa', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (50, 49, 17, N'Camera hành trình xe máy', 'camera-hanh-trinh-xe-may', N'Camera hành trình xe máy là thiết bị ghi hình hữu ích giúp lưu lại toàn bộ quá trình di chuyển, hỗ trợ bảo vệ quyền lợi người lái trong các tình huống va chạm giao thông hoặc sự cố bất ngờ trên đường. Sản phẩm sử dụng cảm biến hình ảnh chất lượng cao cho độ phân giải sắc nét, ghi hình ổn định cả ban ngày lẫn ban đêm. Công nghệ chống rung điện tử giúp video luôn mượt mà ngay cả khi xe di chuyển trên địa hình xấu. Với góc quay siêu rộng và khả năng chống nước chuẩn IP67, camera có thể hoạt động bền bỉ dưới nhiều điều kiện thời tiết khác nhau. Đây là phụ kiện ngày càng phổ biến đối với những người thường xuyên đi tour hoặc di chuyển đường dài bằng xe máy.
Thông số
Độ phân giải: Full HD 1080p / 2K
Ống kính: Góc siêu rộng chống chói
Tính năng: Ghi đè vòng lặp, G-Sensor
Lưu trữ: Hỗ trợ thẻ nhớ MicroSD 128GB', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (51, 6, 29, N'Lọc gió DNA', 'loc-gio-dna', N'Lọc gió DNA là dòng sản phẩm hiệu suất cao được thiết kế để thay thế lọc gió giấy nguyên bản, giúp tối ưu hóa lượng không khí nạp vào buồng đốt. Với công nghệ sợi tổng hợp đặc biệt xếp lớp khoa học, lọc gió DNA cho phép lưu lượng gió đi qua cao hơn tới 30-40% so với lọc zin, giúp động cơ “hít thở” dễ dàng hơn, từ đó cải thiện đáng kể khả năng gia tốc và công suất vận hành. Điểm ưu việt của dòng lọc gió này là khả năng lọc bụi mịn cực tốt nhờ lớp dầu đặc chủng, bảo vệ động cơ khỏi các tác nhân gây mài mòn. Đặc biệt, sản phẩm có độ bền gần như vĩnh cửu theo đời xe vì có thể vệ sinh định kỳ và tái sử dụng nhiều lần, mang lại hiệu quả kinh tế lâu dài và thân thiện với môi trường.


Thông số
Chất liệu: Sợi tổng hợp Cotton 4 lớp tẩm dầu
Tính năng: Tăng lưu lượng gió, cải thiện hiệu suất đốt cháy
Đặc điểm: Có thể vệ sinh và tái sử dụng (Washable)
Tương thích: Thiết kế Plug and Play cho từng dòng xe cụ thể', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (52, 50, 30, N'Bánh mâm RCB', 'banh-mam-rcb', N'Bánh mâm RCB (Racing Boy) là biểu tượng của sự bền bỉ và phong cách thể thao trên các bản độ xe máy. Được đúc từ hợp kim nhôm cao cấp dưới áp suất lớn, sản phẩm sở hữu cấu trúc cực kỳ vững chắc, chịu được những cú va chạm mạnh mà không bị biến dạng hay nứt vỡ. Với thiết kế 5 cây hoặc các nan kiểu dáng khí động học, mâm RCB giúp giảm đáng kể trọng lượng dàn chân so với mâm zin, từ đó giúp xe linh hoạt hơn khi vào cua và giảm tải trọng cho hệ thống giảm xóc. Lớp sơn tĩnh điện cao cấp giúp bề mặt mâm luôn bóng đẹp, chống ăn mòn bởi hóa chất và tác động từ môi trường. Đây là lựa chọn hàng đầu cho những ai muốn nâng cấp diện mạo xe thêm phần cứng cáp và cải thiện độ ổn định khi vận hành ở tốc độ cao.


Thông số
Chất liệu: Hợp kim nhôm đúc cường lực
Kích thước: 17 inch tiêu chuẩn
Đặc điểm: Trọng lượng nhẹ, độ bền cơ học cao
Hoàn thiện: Sơn tĩnh điện chất lượng cao', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (53, 19, 31, N'Pô SC Project', 'po-sc-project', N'Pô SC Project là dòng ống xả hiệu năng cao mang đậm bản sắc của các giải đua mô tô thế giới, giúp giải phóng sức mạnh tiềm tàng của khối động cơ bằng cách tối ưu hóa luồng khí xả. Sản phẩm được chế tác hoàn toàn từ Titanium hoặc Carbon cao cấp, giúp cắt giảm trọng lượng xe một cách ấn tượng so với ống xả nguyên bản bằng thép. Với họng xả lớn và thiết kế lưới tản nhiệt đặc trưng, SC Project tạo ra âm thanh cực kỳ phấn khích, uy lực và đanh thép, mang lại cảm giác phấn khích mỗi khi vặn ga. Ngoài việc cải thiện mã lực và momen xoắn, sản phẩm còn là một món đồ trang sức công nghệ đỉnh cao, giúp chiếc xe sở hữu diện mạo hung hãn và thu hút mọi ánh nhìn khi di chuyển trên đường phố.


Thông số
Chất liệu: Titanium chịu nhiệt cao cấp
Cấu tạo: Slip-on gắn nối tiếp cổ pô
Tính năng: Tăng công suất máy, giảm trọng lượng xe
Âm thanh: Mạnh mẽ, uy lực, đậm chất xe đua', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (54, 22, 32, N'Heo dầu Nissin', 'heo-dau-nissin', N'Heo dầu Nissin là giải pháp nâng cấp hệ thống phanh tin cậy, mang lại hiệu suất phanh vượt trội cho cả nhu cầu đi phố lẫn đi tour đường dài. Sản phẩm được trang bị hệ thống 2 piston hoạt động độc lập với lực ép mạnh mẽ và đồng đều lên má phanh, giúp quãng đường phanh ngắn hơn và an toàn hơn trong các tình huống khẩn cấp. Nissin sử dụng hợp kim nhôm đúc với độ hoàn thiện tinh xảo, giúp tản nhiệt nhanh và duy trì lực phanh ổn định ngay cả khi phải làm việc liên tục ở cường độ cao. Với thiết kế chắc chắn và màu sắc đặc trưng, heo dầu Nissin dễ dàng lắp đặt cho nhiều dòng xe khác nhau, giúp cải thiện đáng kể cảm giác tay thắng và nâng tầm độ an toàn cho người điều khiển.


Thông số
Cấu tạo: 2 piston đối xứng / một bên
Chất liệu: Hợp kim nhôm đúc chịu lực
Tính năng: Lực phanh ổn định, phản hồi chính xác
Lắp đặt: Phù hợp với nhiều dòng xe phổ thông và xe độ', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (55, 17, 17, N'Đĩa tải nhôm CNC', 'ia-tai-nhom-cnc', N'Đĩa tải nhôm CNC là phụ kiện thay thế hoàn hảo cho đĩa tải sắt truyền thống, giúp tối ưu hóa hệ thống truyền động sên dĩa của xe máy. Sản phẩm được gia công bằng máy CNC tự động từ nhôm 7075 (nhôm máy bay) – loại vật liệu có trọng lượng chỉ bằng 1/3 sắt nhưng lại sở hữu độ cứng và độ bền tương đương. Việc giảm trọng lượng xoay ở bánh sau giúp xe tăng tốc nhanh hơn, mượt mà hơn và giảm thiểu hao hụt công suất từ động cơ truyền ra bánh xe. Các răng dĩa được phay sắc sảo, chuẩn xác từng milimet giúp sên vận hành êm ái, giảm tiếng ồn và kéo dài tuổi thọ cho cả bộ nhông sên dĩa. Với màu sắc sơn Anodized đa dạng và thiết kế phay rỗng bắt mắt, đây còn là điểm nhấn thẩm mỹ tuyệt vời cho dàn chân xe.


Thông số
Chất liệu: Nhôm hợp kim 7075-T6 cao cấp
Số răng: 40T (Tùy chỉnh theo yêu cầu truyền động)
Tính năng: Siêu nhẹ, độ cứng cao, thoát bùn đất tốt
Đặc điểm: Màu sắc bền bỉ, chống mài mòn răng', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (56, 9, 4, N'Tay thắng Brembo RCS', 'tay-thang-brembo-rcs', N'Tay thắng Brembo RCS (Ratio Click System) là dòng cùm phanh piston hướng tâm đỉnh cao dành cho những biker yêu cầu sự kiểm soát tuyệt đối trên tay lái. Sản phẩm tích hợp công nghệ độc quyền cho phép thay đổi tỉ số đòn bẩy giữa 18mm và 20mm chỉ bằng một thao tác xoay vít đơn giản, giúp người lái tùy chỉnh được lực phanh mạnh hay nhẹ tùy theo sở thích và điều kiện vận hành. Thân cùm được gia công CNC từ nhôm khối nguyên bản, kết hợp với piston chất lượng cao mang lại cảm giác bóp thắng cực kỳ êm ái, nhạy bén và không có độ rơ. Đây không chỉ là một trang bị an toàn giúp kiểm soát tốc độ chính xác đến từng centimet mà còn là món đồ chơi trang trí đẳng cấp nhất, khẳng định vị thế của chủ nhân chiếc xe.


Thông số
Chất liệu: Nhôm CNC nguyên khối
Tính năng: Tùy chỉnh tỉ số đòn bẩy RCS (18-20), chỉnh xa gần tay thắng
Cấu tạo: Piston Radial cho lực phanh mạnh và ổn định
Tương thích: Các dòng xe phanh đĩa thủy lực', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (57, 51, 4, N'Cùm côn Brembo', 'cum-con-brembo', N'Cùm côn Brembo là sản phẩm nâng cấp hàng đầu giúp cải thiện cảm giác vận hành hệ thống ly hợp trên các dòng xe côn tay. Được thiết kế với cơ chế đòn bẩy tối ưu, sản phẩm giúp việc cắt côn trở nên nhẹ nhàng hơn đáng kể so với cùm zin, giúp người lái không bị mỏi tay khi phải sang số liên tục trong môi trường đô thị tắc nghẽn. Cùm được làm từ hợp kim nhôm chịu lực cao với độ hoàn thiện sắc sảo từng đường nét, đảm bảo độ bền lâu dài và hoạt động ổn định trong mọi điều kiện. Việc kết hợp cùm côn Brembo cùng tay thắng Brembo sẽ tạo nên sự đồng bộ hoàn hảo cho khu vực ghi-đông, vừa nâng cấp hiệu suất sử dụng, vừa mang lại diện mạo chuyên nghiệp và đẳng cấp cho chiếc xe.


Thông số
Chất liệu: Nhôm đúc / CNC cao cấp
Tính năng: Giảm lực bóp côn, cắt côn dứt khoát
Loại: Côn dây (Mechanical Clutch) hoặc Côn dầu (Hydraulic)
Đặc điểm: Tay côn có thể điều chỉnh khoảng cách xa gần', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (58, 52, 25, N'Bộ dây thắng HEL Performance', 'bo-day-thang-hel-performance', N'Bộ dây thắng HEL Performance là giải pháp nâng cấp hệ thống dây dẫn thủy lực toàn diện, giúp triệt tiêu hoàn toàn hiện tượng phanh bị “xốp” hoặc mất lực do dây dẫn cao su nguyên bản bị giãn nở dưới áp suất cao. Sản phẩm sử dụng lõi Teflon bện inox 304 không gỉ bên ngoài, đảm bảo dây không bao giờ bị phồng hay biến dạng dù bạn phanh gấp ở tốc độ cao. Với khả năng chịu áp lực và nhiệt độ cực lớn, dây thắng HEL truyền tải 100% lực từ tay phanh xuống heo dầu, mang lại cảm giác phanh thực tế và cực kỳ chắc chắn. Các đầu bấm được làm từ vật liệu chống ăn mòn cao cấp với nhiều màu sắc lựa chọn, không chỉ đảm bảo độ kín khít tuyệt đối mà còn giúp dàn chân xe trở nên nổi bật và đậm chất thể thao.


Thông số
Cấu tạo: Lõi Teflon bọc lưới inox 304 siêu bền
Tính năng: Chống giãn nở dây dầu, tăng hiệu quả phanh
Phụ kiện: Đi kèm ốc dầu và vòng đệm đồng
Đặc điểm: Nhiều màu sắc tùy chọn cho lớp vỏ bọc ngoài', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (59, 53, 17, N'Két nước độ', 'ket-nuoc-o', N'Két nước độ là phụ kiện giải nhiệt chuyên dụng dành cho các dòng xe máy sử dụng hệ thống làm mát bằng dung dịch, đặc biệt là những xe đã nâng cấp động cơ (xe độ máy). Sản phẩm được thiết kế với kích thước lớn hơn và số lượng lá nhôm tản nhiệt dày đặc hơn so với két nước zin, giúp tăng diện tích tiếp xúc với luồng gió để hạ nhiệt nhanh chóng cho nước làm mát. Được chế tác từ nhôm cao cấp có khả năng dẫn nhiệt cực tốt, két nước độ giúp duy trì nhiệt độ động cơ luôn ở mức lý tưởng, ngăn chặn tình trạng quá nhiệt gây giảm công suất hoặc hư hỏng các chi tiết bên trong máy khi vận hành liên tục ở cường độ cao. Đây là món trang bị “sống còn” để đảm bảo sự bền bỉ cho khối động cơ đã được nâng cấp hiệu năng.


Thông số
Chất liệu: Nhôm tản nhiệt hiệu suất cao
Diện tích tản nhiệt: Tăng 20-30% so với nguyên bản
Tính năng: Hạ nhiệt nhanh, chống sôi nước làm mát
Lắp đặt: Có sẵn bát gắn cho từng dòng xe (Winner, Exciter,...)', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (60, 54, 17, N'Quạt két nước', 'quat-ket-nuoc', N'Quạt két nước là trợ thủ đắc lực giúp tối ưu hóa hệ thống tản nhiệt cưỡng bức của xe máy, đảm bảo luồng không khí luôn được lưu thông qua két nước ngay cả khi xe đang đứng yên hoặc di chuyển chậm trong đường phố đông đúc. Sản phẩm sở hữu motor điện 12V mạnh mẽ với tốc độ vòng quay cao, tạo ra luồng gió hút mạnh để giải nhiệt cho các lá nhôm két nước một cách nhanh chóng. Cánh quạt được làm từ vật liệu chịu nhiệt, không bị biến dạng hay nóng chảy dưới sức nóng tỏa ra từ động cơ. Với thiết kế nhỏ gọn, quạt dễ dàng lắp đặt vào mặt sau của két nước, giúp duy trì nhiệt độ ổn định, bảo vệ động cơ khỏi các rủi ro do quá nhiệt và giúp xe vận hành êm ái hơn trong những ngày hè oi bức.


Thông số
Điện áp hoạt động: 12V DC
Chất liệu: Nhựa kỹ thuật chịu nhiệt cường độ cao
Tính năng: Hỗ trợ tản nhiệt cưỡng bức, tự động kích hoạt khi nóng
Đặc điểm: Hoạt động êm ái, tiết kiệm điện năng', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (61, 12, 33, N'Bộ nồi BRT', 'bo-noi-brt', N'Bộ nồi BRT là giải pháp nâng cấp truyền động chuyên sâu dành cho các dòng xe tay ga muốn cải thiện đáng kể hiệu suất vận hành mà không cần can thiệp quá nhiều vào máy móc. Sản phẩm được nghiên cứu và phát triển bởi các chuyên gia BRT với góc độ rãnh trượt bi nồi được tính toán khoa học, giúp xe bắt ga cực nhạy và loại bỏ hoàn toàn hiện tượng rung ga đầu khó chịu. Được chế tạo từ hợp kim nhôm đúc áp lực cao, bộ nồi có khả năng chịu nhiệt cực tốt, hạn chế tối đa tình trạng cháy chuông hoặc mài mòn bố nồi khi vận hành ở cường độ cao. Khi lắp đặt bộ nồi BRT, xe sẽ có độ vọt ấn tượng, giúp việc vượt xe trên đường trường trở nên dễ dàng và mang lại cảm giác lái phấn khích, mượt mà hơn trên mọi cung đường.


Thông số
Chất liệu: Hợp kim nhôm đúc áp lực cao
Tính năng: Tăng gia tốc, chống rung ga đầu
Cấu tạo: Bao gồm chén bi, cánh quạt, và các rãnh trượt bi tối ưu
Ứng dụng: Phù hợp cho xe đi phố và xe chạy tour đường dài', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (62, 55, 17, N'ECU độ', 'ecu-o', N'ECU độ được ví như “bộ não” mới cho chiếc xe, cho phép can thiệp trực tiếp và tối ưu hóa hoàn toàn hệ thống quản lý động cơ. Sản phẩm cung cấp khả năng điều chỉnh linh hoạt lượng xăng phun, thời điểm đánh lửa và đặc biệt là mở giới hạn vòng tua máy (RPM) mà ECU zin thường bị khóa lại. Với ECU độ, người dùng có thể nạp các bản đồ (map) xăng lửa phù hợp với cấu hình máy của xe, từ xe zin đến xe độ nặng, giúp động cơ phát huy tối đa công suất và momen xoắn. Thiết kế thông minh cho phép kết nối với máy tính hoặc điện thoại để tinh chỉnh các thông số một cách chính xác, mang lại trải nghiệm lái mạnh mẽ, uy lực và giúp chiếc xe đạt được vận tốc tối đa cao hơn nhiều so với ban đầu.


Thông số
Loại: ECU lập trình thông minh (Programmable)
Tính năng: Mở giới hạn vòng tua, chỉnh xăng lửa, tối ưu công suất
Kết nối: Hỗ trợ phần mềm tinh chỉnh trên PC/Smartphone
An toàn: Tích hợp chế độ bảo vệ động cơ khi quá nhiệt hoặc quá tua', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (63, 56, 17, N'IC độ', 'ic-o', N'IC độ là món phụ kiện không thể thiếu cho các dòng xe máy sử dụng hệ thống đánh lửa trực tiếp, giúp phá bỏ giới hạn vòng tua máy mà nhà sản xuất đã thiết lập sẵn. Sản phẩm giúp cải thiện khả năng đánh lửa, tạo ra tia lửa điện mạnh và đều hơn ở mọi dải vòng tua, từ đó giúp quá trình đốt cháy hỗn hợp nhiên liệu diễn ra triệt để và nhanh chóng. Nhờ khả năng tăng giới hạn RPM, xe có thể đạt được tốc độ cao hơn ở các cấp số, giúp động cơ hoạt động thanh thoát và loại bỏ hoàn toàn hiện tượng hụt ga hay đờn máy khi chạy ở tốc độ lớn. IC độ được thiết kế để chịu được điện áp cao và hoạt động bền bỉ, giúp xe vận hành ổn định trong thời gian dài mà không gây hại cho các chi tiết điện tử khác.


Thông số
Loại: IC đánh lửa kỹ thuật số mở tua
Tính năng: Mở giới hạn vòng tua (Unlimited RPM), tăng cường đánh lửa
Ưu điểm: Xe chạy nhẹ máy, hậu sâu, không gây nóng máy đột ngột
Lắp đặt: Plug and Play, không cần cắt nối dây điện zin', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (64, 57, 17, N'Bộ mobin sườn', 'bo-mobin-suon', N'Bộ mobin sườn hiệu năng cao là thiết bị hỗ trợ hệ thống đánh lửa, đóng vai trò biến đổi dòng điện điện áp thấp từ nguồn điện thành dòng điện điện áp cực cao để tạo ra tia lửa điện tại bugi. Sản phẩm này giúp tạo ra tia lửa xanh, mạnh và cực kỳ ổn định, giúp hỗn hợp xăng gió trong buồng đốt được kích cháy hoàn toàn trong thời gian ngắn nhất. Kết quả là động cơ vận hành mạnh mẽ hơn, giảm thiểu tình trạng xăng dư gây đóng cặn carbon và giúp xe tiết kiệm nhiên liệu một cách hiệu quả. Đây là món nâng cấp lý tưởng giúp xe khởi động dễ dàng hơn vào buổi sáng, cải thiện đáng kể độ nhạy của tay ga và giúp tiếng máy trở nên tròn trịa, đều đặn hơn ở cả chế độ không tải lẫn khi đang vận hành.


Thông số
Điện áp đầu vào: 12V
Tính năng: Tăng cường cường độ dòng điện đánh lửa
Hiệu quả: Đốt sạch nhiên liệu, tăng độ nhạy tay ga, giảm khí thải
Đặc điểm: Chống nhiễu điện tử, chịu nhiệt và chống thấm nước tốt', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (65, 58, 17, N'Lọc xăng', 'loc-xang', N'Lọc xăng là lớp màng bảo vệ quan trọng giúp loại bỏ hoàn toàn các tạp chất, cặn bẩn và rỉ sét có lẫn trong nhiên liệu trước khi chúng xâm nhập vào hệ thống phun xăng hoặc buồng đốt. Sản phẩm được chế tạo với lõi lọc chất lượng cao, đảm bảo lưu lượng xăng đi qua luôn ổn định và tinh khiết nhất, từ đó bảo vệ kim phun không bị nghẹt và giảm nguy cơ xước lòng piston. Với thiết kế nhỏ gọn và lớp vỏ nhựa trong suốt bền bỉ, người dùng có thể dễ dàng quan sát tình trạng bẩn của lõi lọc để tiến hành thay thế kịp thời. Việc sử dụng lọc xăng định kỳ giúp động cơ luôn hoạt động ổn định, êm ái, tránh hiện tượng xe bị giật cục hoặc chết máy đột ngột do nguồn nhiên liệu không sạch.


Thông số
Chất liệu: Nhựa kỹ thuật chịu xăng dầu + Lõi lọc sợi tổng hợp
Tính năng: Lọc sạch cặn bẩn, bảo vệ hệ thống kim phun/bình xăng con
Đặc điểm: Dễ dàng lắp đặt và thay thế định kỳ
Khuyến nghị: Nên thay thế sau mỗi 5.000km - 8.000km', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (66, 59, 17, N'Kim phun xăng', 'kim-phun-xang', N'Kim phun xăng (Injector) là chi tiết chính xác trong hệ thống phun xăng điện tử (FI), có nhiệm vụ phun nhiên liệu dưới dạng sương mịn vào luồng khí nạp của động cơ. Sản phẩm được sản xuất với các lỗ phun siêu nhỏ, được gia công bằng laser giúp kiểm soát lượng xăng cực kỳ chính xác theo tín hiệu từ ECU, giúp tối ưu hóa quá trình hòa trộn nhiên liệu và không khí. Việc nâng cấp hoặc thay thế kim phun chất lượng cao sẽ giúp xe vận hành mượt mà, loại bỏ tình trạng ga chờ và cải thiện đáng kể khả năng tiết kiệm xăng. Đối với các xe đã nâng cấp công suất, kim phun có lưu lượng (cc) lớn hơn sẽ cung cấp đủ nhiên liệu để động cơ hoạt động mạnh mẽ nhất ở dải vòng tua cao mà không bị thiếu xăng.


Thông số
Loại: Kim phun điện tử đa điểm
Tính năng: Phun xăng dạng sương, tối ưu hóa quá trình cháy
Hiệu quả: Tăng hiệu suất máy, tiết kiệm nhiên liệu, giảm lượng khí thải
Ứng dụng: Dùng cho các dòng xe đời mới sử dụng hệ thống FI', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (67, 60, 17, N'Bơm xăng điện', 'bom-xang-ien', N'Bơm xăng điện đóng vai trò vận chuyển nhiên liệu từ bình chứa đến kim phun với một áp suất không đổi và ổn định, bất kể điều kiện vận hành của xe. Sản phẩm sử dụng motor điện 12V chất lượng cao, cho khả năng bơm liên tục và êm ái, giúp duy trì áp suất xăng ổn định trong hệ thống, tránh tình trạng hụt xăng khi xe đột ngột tăng tốc hoặc chạy ở tốc độ cao lâu dài. Được thiết kế chuyên dụng để ngâm trong xăng, bơm có khả năng tự làm mát và chống ăn mòn cực tốt, đảm bảo tuổi thọ sử dụng lâu dài. Đây là bộ phận cốt yếu giúp hệ thống phun xăng điện tử hoạt động chính xác, mang lại sự mượt mà cho xe trong mọi tình huống giao thông.


Thông số
Điện áp hoạt động: 12V DC
Áp suất bơm: Ổn định theo tiêu chuẩn nhà sản xuất
Tính năng: Cung cấp xăng liên tục, chống hụt ga ở tốc độ cao
Đặc điểm: Motor êm, độ bền cao, dễ dàng thay thế cho cụm bơm zin', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (68, 20, 17, N'Lọc nhớt CNC', 'loc-nhot-cnc', N'Lọc nhớt CNC là món phụ kiện nâng cấp công nghệ giúp thay thế hoàn toàn loại lọc nhớt giấy dùng một lần truyền thống. Sản phẩm được gia công từ nhôm CNC cao cấp với lưới lọc bằng thép không gỉ siêu mịn, có khả năng loại bỏ các mạt sắt và cặn bẩn trong nhớt một cách hiệu quả hơn. Điểm khác biệt lớn nhất là lọc nhớt CNC có thể tháo rời để vệ sinh bằng xăng hoặc dung dịch tẩy rửa và tái sử dụng mãi mãi, giúp người dùng tiết kiệm một khoản chi phí đáng kể sau mỗi lần thay nhớt. Ngoài ra, thiết kế vỏ nhôm với các cánh tản nhiệt giúp hạ nhiệt độ của dầu nhớt khi lưu thông qua lọc, hỗ trợ một phần vào việc làm mát động cơ và mang lại vẻ ngoài hiện đại, cơ khí cho xe.


Thông số
Chất liệu: Thân nhôm CNC + Lưới lọc thép không gỉ 304
Tính năng: Lọc sạch mạt sắt, cặn bẩn, hỗ trợ tản nhiệt nhớt
Ưu điểm: Có thể vệ sinh và tái sử dụng nhiều lần (Eco-friendly)
Đặc điểm: Độ bền cực cao, chống oxy hóa bởi hóa chất trong nhớt', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (69, 61, 17, N'Ốp bình xăng', 'op-binh-xang', N'Ốp bình xăng là phụ kiện trang trí và bảo vệ thiết thực, giúp che chắn bề mặt sơn của bình xăng khỏi những vết trầy xước không đáng có do khóa quần, thắt lưng hoặc các vật dụng cọ xát vào trong quá trình lái xe. Sản phẩm được chế tạo từ nhựa ABS hoặc nhựa dẻo chất lượng cao, có khả năng chịu được va đập nhẹ và không bị giòn gãy dưới tác động của ánh nắng mặt trời hay nhiệt độ động cơ. Với thiết kế ôm sát theo đường cong của bình xăng, ốp không chỉ bảo vệ lớp sơn zin mà còn tạo nên vẻ ngoài hầm hố, mạnh mẽ và đầy cá tính cho chiếc xe. Việc lắp đặt vô cùng đơn giản với keo dán chuyên dụng chắc chắn, giúp người dùng dễ dàng làm mới diện mạo xe một cách nhanh chóng và hiệu quả.


Thông số
Chất liệu: Nhựa ABS chịu lực hoặc nhựa dẻo cao cấp
Tính năng: Bảo vệ chống trầy xước bình xăng, trang trí ngoại thất
Đặc điểm: Thiết kế theo form xe, ôm khít, bề mặt chống bám bẩn
Lắp đặt: Dán trực tiếp bằng keo 3M chuyên dụng hoặc bắt ốc zin', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (70, 62, 17, N'Tem xe', 'tem-xe', N'Tem xe là giải pháp trang trí ngoại thất phổ biến nhất giúp cá nhân hóa phong cách và tạo diện mạo hoàn toàn mới cho chiếc xe mà không cần sơn lại. Sản phẩm được in trên chất liệu decal cao cấp với công nghệ in kỹ thuật số hiện đại, cho màu sắc rực rỡ, sắc nét đến từng chi tiết nhỏ. Lớp màng bảo vệ bên ngoài giúp tem có khả năng kháng nước tuyệt đối, chống lại tác động của tia UV gây phai màu và hạn chế trầy xước nhẹ từ môi trường. Với thiết kế đa dạng từ phong cách zin nguyên bản đến các mẫu tem đấu thể thao, sản phẩm giúp chiếc xe luôn nổi bật, thể hiện cá tính riêng biệt của chủ sở hữu và giữ cho ngoại hình xe luôn tươi mới theo thời gian.


Thông số
Chất liệu: Decal nhựa PVC cao cấp 3 lớp
Tính năng: Trang trí, chống thấm nước, chống phai màu
Đặc điểm: Độ bám dính cao, không để lại keo khi bóc bỏ
Công nghệ: In Eco-Solvent độ phân giải cao', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (71, 12, 33, N'Bộ nồi BRT', 'bo-noi-brt', N'Bộ nồi BRT là giải pháp nâng cấp truyền động chuyên sâu dành cho các dòng xe tay ga muốn cải thiện đáng kể hiệu suất vận hành mà không cần can thiệp quá nhiều vào máy móc. Sản phẩm được nghiên cứu và phát triển bởi các chuyên gia BRT với góc độ rãnh trượt bi nồi được tính toán khoa học, giúp xe bắt ga cực nhạy và loại bỏ hoàn toàn hiện tượng rung ga đầu khó chịu. Được chế tạo từ hợp kim nhôm đúc áp lực cao, bộ nồi có khả năng chịu nhiệt cực tốt, hạn chế tối đa tình trạng cháy chuông hoặc mài mòn bố nồi khi vận hành ở cường độ cao. Khi lắp đặt bộ nồi BRT, xe sẽ có độ vọt ấn tượng, giúp việc vượt xe trên đường trường trở nên dễ dàng và mang lại cảm giác lái phấn khích, mượt mà hơn trên mọi cung đường.


Thông số
Chất liệu: Hợp kim nhôm đúc áp lực cao
Tính năng: Tăng gia tốc, chống rung ga đầu
Cấu tạo: Bao gồm chén bi, cánh quạt, và các rãnh trượt bi tối ưu
Ứng dụng: Phù hợp cho xe đi phố và xe chạy tour đường dài', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (72, 55, 17, N'ECU độ', 'ecu-o', N'ECU độ được ví như "bộ não" mới cho chiếc xe, cho phép can thiệp trực tiếp và tối ưu hóa hoàn toàn hệ thống quản lý động cơ. Sản phẩm cung cấp khả năng điều chỉnh linh hoạt lượng xăng phun, thời điểm đánh lửa và đặc biệt là mở giới hạn vòng tua máy (RPM) mà ECU zin thường bị khóa lại. Với ECU độ, người dùng có thể nạp các bản đồ (map) xăng lửa phù hợp với cấu hình máy của xe, từ xe zin đến xe độ nặng, giúp động cơ phát huy tối đa công suất và momen xoắn. Thiết kế thông minh cho phép kết nối với máy tính hoặc điện thoại để tinh chỉnh các thông số một cách chính xác, mang lại trải nghiệm lái mạnh mẽ, uy lực và giúp chiếc xe đạt được vận tốc tối đa cao hơn nhiều so với ban đầu.


Thông số
Loại: ECU lập trình thông minh (Programmable)
Tính năng: Mở giới hạn vòng tua, chỉnh xăng lửa, tối ưu công suất
Kết nối: Hỗ trợ phần mềm tinh chỉnh trên PC/Smartphone
An toàn: Tích hợp chế độ bảo vệ động cơ khi quá nhiệt hoặc quá tua', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (73, 56, 17, N'IC độ', 'ic-o', N'IC độ là món phụ kiện không thể thiếu cho các dòng xe máy sử dụng hệ thống đánh lửa trực tiếp, giúp phá bỏ giới hạn vòng tua máy mà nhà sản xuất đã thiết lập sẵn. Sản phẩm giúp cải thiện khả năng đánh lửa, tạo ra tia lửa điện mạnh và đều hơn ở mọi dải vòng tua, từ đó giúp quá trình đốt cháy hỗn hợp nhiên liệu diễn ra triệt để và nhanh chóng. Nhờ khả năng tăng giới hạn RPM, xe có thể đạt được tốc độ cao hơn ở các cấp số, giúp động cơ hoạt động thanh thoát và loại bỏ hoàn toàn hiện tượng hụt ga hay đờn máy khi chạy ở tốc độ lớn. IC độ được thiết kế để chịu được điện áp cao và hoạt động bền bỉ, giúp xe vận hành ổn định trong thời gian dài mà không gây hại cho các chi tiết điện tử khác.


Thông số
Loại: IC đánh lửa kỹ thuật số mở tua
Tính năng: Mở giới hạn vòng tua (Unlimited RPM), tăng cường đánh lửa
Ưu điểm: Xe chạy nhẹ máy, hậu sâu, không gây nóng máy đột ngột
Lắp đặt: Plug and Play, không cần cắt nối dây điện zin', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (74, 57, 17, N'Bộ mobin sườn', 'bo-mobin-suon', N'Bộ mobin sườn hiệu năng cao là thiết bị hỗ trợ hệ thống đánh lửa, đóng vai trò biến đổi dòng điện điện áp thấp từ nguồn điện thành dòng điện điện áp cực cao để tạo ra tia lửa điện tại bugi. Sản phẩm này giúp tạo ra tia lửa xanh, mạnh và cực kỳ ổn định, giúp hỗn hợp xăng gió trong buồng đốt được kích cháy hoàn toàn trong thời gian ngắn nhất. Kết quả là động cơ vận hành mạnh mẽ hơn, giảm thiểu tình trạng xăng dư gây đóng cặn carbon và giúp xe tiết kiệm nhiên liệu một cách hiệu quả. Đây là món nâng cấp lý tưởng giúp xe khởi động dễ dàng hơn vào buổi sáng, cải thiện đáng kể độ nhạy của tay ga và giúp tiếng máy trở nên tròn trịa, đều đặn hơn ở cả chế độ không tải lẫn khi đang vận hành.


Thông số
Điện áp đầu vào: 12V
Tính năng: Tăng cường cường độ dòng điện đánh lửa
Hiệu quả: Đốt sạch nhiên liệu, tăng độ nhạy tay ga, giảm khí thải
Đặc điểm: Chống nhiễu điện tử, chịu nhiệt và chống thấm nước tốt', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (75, 58, 17, N'Lọc xăng', 'loc-xang', N'Lọc xăng là lớp màng bảo vệ quan trọng giúp loại bỏ hoàn toàn các tạp chất, cặn bẩn và rỉ sét có lẫn trong nhiên liệu trước khi chúng xâm nhập vào hệ thống phun xăng hoặc buồng đốt. Sản phẩm được chế tạo với lõi lọc chất lượng cao, đảm bảo lưu lượng xăng đi qua luôn ổn định và tinh khiết nhất, từ đó bảo vệ kim phun không bị nghẹt và giảm nguy cơ xước lòng piston. Với thiết kế nhỏ gọn và lớp vỏ nhựa trong suốt bền bỉ, người dùng có thể dễ dàng quan sát tình trạng bẩn của lõi lọc để tiến hành thay thế kịp thời. Việc sử dụng lọc xăng định kỳ giúp động cơ luôn hoạt động ổn định, êm ái, tránh hiện tượng xe bị giật cục hoặc chết máy đột ngột do nguồn nhiên liệu không sạch.


Thông số
Chất liệu: Nhựa kỹ thuật chịu xăng dầu + Lõi lọc sợi tổng hợp
Tính năng: Lọc sạch cặn bẩn, bảo vệ hệ thống kim phun/bình xăng con
Đặc điểm: Dễ dàng lắp đặt và thay thế định kỳ
Khuyến nghị: Nên thay thế sau mỗi 5.000km - 8.000km', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (76, 59, 17, N'Kim phun xăng', 'kim-phun-xang', N'Kim phun xăng (Injector) là chi tiết chính xác trong hệ thống phun xăng điện tử (FI), có nhiệm vụ phun nhiên liệu dưới dạng sương mịn vào luồng khí nạp của động cơ. Sản phẩm được sản xuất với các lỗ phun siêu nhỏ, được gia công bằng laser giúp kiểm soát lượng xăng cực kỳ chính xác theo tín hiệu từ ECU, giúp tối ưu hóa quá trình hòa trộn nhiên liệu và không khí. Việc nâng cấp hoặc thay thế kim phun chất lượng cao sẽ giúp xe vận hành mượt mà, loại bỏ tình trạng ga chờ và cải thiện đáng kể khả năng tiết kiệm xăng. Đối với các xe đã nâng cấp công suất, kim phun có lưu lượng (cc) lớn hơn sẽ cung cấp đủ nhiên liệu để động cơ hoạt động mạnh mẽ nhất ở dải vòng tua cao mà không bị thiếu xăng.


Thông số
Loại: Kim phun điện tử đa điểm
Tính năng: Phun xăng dạng sương, tối ưu hóa quá trình cháy
Hiệu quả: Tăng hiệu suất máy, tiết kiệm nhiên liệu, giảm lượng khí thải
Ứng dụng: Dùng cho các dòng xe đời mới sử dụng hệ thống FI', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (77, 60, 17, N'Bơm xăng điện', 'bom-xang-ien', N'Bơm xăng điện đóng vai trò vận chuyển nhiên liệu từ bình chứa đến kim phun với một áp suất không đổi và ổn định, bất kể điều kiện vận hành của xe. Sản phẩm sử dụng motor điện 12V chất lượng cao, cho khả năng bơm liên tục và êm ái, giúp duy trì áp suất xăng ổn định trong hệ thống, tránh tình trạng hụt xăng khi xe đột ngột tăng tốc hoặc chạy ở tốc độ cao lâu dài. Được thiết kế chuyên dụng để ngâm trong xăng, bơm có khả năng tự làm mát và chống ăn mòn cực tốt, đảm bảo tuổi thọ sử dụng lâu dài. Đây là bộ phận cốt yếu giúp hệ thống phun xăng điện tử hoạt động chính xác, mang lại sự mượt mà cho xe trong mọi tình huống giao thông.


Thông số
Điện áp hoạt động: 12V DC
Áp suất bơm: Ổn định theo tiêu chuẩn nhà sản xuất
Tính năng: Cung cấp xăng liên tục, chống hụt ga ở tốc độ cao
Đặc điểm: Motor êm, độ bền cao, dễ dàng thay thế cho cụm bơm zin', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (78, 20, 17, N'Lọc nhớt CNC', 'loc-nhot-cnc', N'Lọc nhớt CNC là món phụ kiện nâng cấp công nghệ giúp thay thế hoàn toàn loại lọc nhớt giấy dùng một lần truyền thống. Sản phẩm được gia công từ nhôm CNC cao cấp với lưới lọc bằng thép không gỉ siêu mịn, có khả năng loại bỏ các mạt sắt và cặn bẩn trong nhớt một cách hiệu quả hơn. Điểm khác biệt lớn nhất là lọc nhớt CNC có thể tháo rời để vệ sinh bằng xăng hoặc dung dịch tẩy rửa và tái sử dụng mãi mãi, giúp người dùng tiết kiệm một khoản chi phí đáng kể sau mỗi lần thay nhớt. Ngoài ra, thiết kế vỏ nhôm với các cánh tản nhiệt giúp hạ nhiệt độ của dầu nhớt khi lưu thông qua lọc, hỗ trợ một phần vào việc làm mát động cơ và mang lại vẻ ngoài hiện đại, cơ khí cho xe.


Thông số
Chất liệu: Thân nhôm CNC + Lưới lọc thép không gỉ 304
Tính năng: Lọc sạch mạt sắt, cặn bẩn, hỗ trợ tản nhiệt nhớt
Ưu điểm: Có thể vệ sinh và tái sử dụng nhiều lần (Eco-friendly)
Đặc điểm: Độ bền cực cao, chống oxy hóa bởi hóa chất trong nhớt', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (79, 61, 17, N'Ốp bình xăng', 'op-binh-xang', N'Ốp bình xăng là phụ kiện trang trí và bảo vệ thiết thực, giúp che chắn bề mặt sơn của bình xăng khỏi những vết trầy xước không đáng có do khóa quần, thắt lưng hoặc các vật dụng cọ xát vào trong quá trình lái xe. Sản phẩm được chế tạo từ nhựa ABS hoặc nhựa dẻo chất lượng cao, có khả năng chịu được va đập nhẹ và không bị giòn gãy dưới tác động của ánh nắng mặt trời hay nhiệt độ động cơ. Với thiết kế ôm sát theo đường cong của bình xăng, ốp không chỉ bảo vệ lớp sơn zin mà còn tạo nên vẻ ngoài hầm hố, mạnh mẽ và đầy cá tính cho chiếc xe. Việc lắp đặt vô cùng đơn giản với keo dán chuyên dụng chắc chắn, giúp người dùng dễ dàng làm mới diện mạo xe một cách nhanh chóng và hiệu quả.


Thông số
Chất liệu: Nhựa ABS chịu lực hoặc nhựa dẻo cao cấp
Tính năng: Bảo vệ chống trầy xước bình xăng, trang trí ngoại thất
Đặc điểm: Thiết kế theo form xe, ôm khít, bề mặt chống bám bẩn
Lắp đặt: Dán trực tiếp bằng keo 3M chuyên dụng hoặc bắt ốc zin', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (80, 62, 17, N'Tem xe', 'tem-xe', N'Tem xe là giải pháp trang trí ngoại thất phổ biến nhất giúp cá nhân hóa phong cách và tạo diện mạo hoàn toàn mới cho chiếc xe mà không cần sơn lại. Sản phẩm được in trên chất liệu decal cao cấp với công nghệ in kỹ thuật số hiện đại, cho màu sắc rực rỡ, sắc nét đến từng chi tiết nhỏ. Lớp màng bảo vệ bên ngoài giúp tem có khả năng kháng nước tuyệt đối, chống lại tác động của tia UV gây phai màu và hạn chế trầy xước nhẹ từ môi trường. Với thiết kế đa dạng từ phong cách zin nguyên bản đến các mẫu tem đấu thể thao, sản phẩm giúp chiếc xe luôn nổi bật, thể hiện cá tính riêng biệt của chủ sở hữu và giữ cho ngoại hình xe luôn tươi mới theo thời gian.


Thông số
Chất liệu: Decal nhựa PVC cao cấp 3 lớp
Tính năng: Trang trí, chống thấm nước, chống phai màu
Đặc điểm: Độ bám dính cao, không để lại keo khi bóc bỏ
Công nghệ: In Eco-Solvent độ phân giải cao', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (81, 63, 17, N'Dán keo xe', 'dan-keo-xe', N'Dán keo xe là phương pháp bảo vệ lớp sơn nguyên bản hiệu quả nhất trước những tác động vật lý hàng ngày như va quẹt trong bãi xe, đá văng hoặc tác hại từ nhựa đường và hóa chất. Sản phẩm sử dụng loại phim trong suốt có độ dẻo dai và độ bóng cao, giúp tăng cường độ sâu cho màu sơn mà không làm thay đổi thiết kế ban đầu của nhà sản xuất. Lớp keo đặc chủng có khả năng bám dính cực tốt nhưng vẫn đảm bảo không gây hại cho bề mặt sơn zin khi cần tháo bỏ sau nhiều năm sử dụng. Đây là dịch vụ bảo trì ngoại thất thiết yếu giúp duy trì giá trị của chiếc xe, giữ cho bề mặt luôn bóng bẩy như vừa dắt ra từ hãng và dễ dàng vệ sinh các vết bẩn cứng đầu bám trên thân xe.


Thông số
Loại: Phim bảo vệ trong suốt (Gloss/Matte)
Tính năng: Chống trầy xước, chống oxy hóa lớp sơn, hạn chế bám bẩn
Độ bền: Duy trì độ bóng từ 2 đến 3 năm
Thi công: Dán trùm toàn bộ diện tích nhựa màu của xe', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (82, 64, 17, N'Bọc yên xe', 'boc-yen-xe', N'Bọc yên xe là món phụ kiện quan trọng giúp cải thiện trực tiếp trải nghiệm lái xe, đặc biệt là trong những hành trình dài. Sản phẩm được chế tác từ chất liệu da tổng hợp hoặc da simili cao cấp với bề mặt được xử lý chống trượt, giúp người lái giữ vững vị trí ngồi ổn định khi phanh gấp hoặc vào cua. Lớp đệm hỗ trợ bên dưới kết hợp cùng vỏ bọc mới giúp tăng độ êm ái, giảm áp lực lên vùng mông và cột sống, từ đó triệt tiêu cảm giác mệt mỏi khi di chuyển liên tục. Với đặc tính chống thấm nước tuyệt vời và khả năng chịu nhiệt tốt, bọc yên xe bảo vệ lớp mút bên trong không bị mục nát do mưa ẩm, đồng thời mang lại diện mạo sang trọng và sạch sẽ cho tổng thể chiếc xe.


Thông số
Chất liệu: Da PU cao cấp hoặc Simili co giãn 4 chiều
Tính năng: Chống thấm nước, chống nóng, tăng độ bám ngồi
Thiết kế: Đường chỉ may tinh xảo, chống rạn nứt
Màu sắc: Đen truyền thống hoặc phối màu thể thao', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (83, 65, 17, N'Gù tay lái', 'gu-tay-lai', N'Gù tay lái không chỉ là món đồ chơi trang trí mà còn đóng vai trò như một bộ phận cân bằng động, giúp giảm thiểu rung lắc truyền từ động cơ lên bàn tay người lái. Sản phẩm được làm từ kim loại nặng với trọng lượng tiêu chuẩn, giúp ổn định ghi-đông khi xe vận hành ở dải tốc độ cao hoặc đi qua những đoạn đường gồ ghề. Ngoài chức năng triệt tiêu rung động, gù tay lái còn đóng vai trò như một thanh bảo vệ, hạn chế hư hỏng cho bộ phận tay thắng và tay nắm cao su khi xe vô tình bị ngã hoặc va chạm ngang. Với thiết kế tinh tế và bề mặt được hoàn thiện sắc sảo, gù tay lái góp phần làm cho phần đầu xe trở nên cứng cáp, chuyên nghiệp và thẩm mỹ hơn.


Thông số
Chất liệu: Thép không gỉ hoặc Nhôm CNC khối nặng
Tính năng: Chống rung ghi-đông, bảo vệ tay lái khi va chạm
Lắp đặt: Gắn trực tiếp vào hai đầu ghi-đông
Hoàn thiện: Sơn tĩnh điện hoặc mạ chrome chống gỉ', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (84, 66, 17, N'Tay nắm cao su', 'tay-nam-cao-su', N'Tay nắm cao su là điểm tiếp xúc trực tiếp và thường xuyên nhất giữa người lái với chiếc xe, do đó chất lượng của bộ phận này ảnh hưởng rất lớn đến cảm giác điều khiển. Sản phẩm được làm từ hợp chất cao su mềm dẻo, có độ đàn hồi cao và khả năng thấm hút mồ hôi tốt, giúp bàn tay luôn khô ráo và bám chắc vào tay lái trong mọi tình huống. Các vân chìm nổi trên bề mặt tay nắm được thiết kế khoa học để tăng cường ma sát, hạn chế tối đa tình trạng trượt tay ga khi đi dưới trời mưa hoặc khi đeo găng tay. Sử dụng tay nắm cao su chất lượng cao giúp giảm tình trạng tê tay, mang lại sự thoải mái tối đa cho lòng bàn chân và giúp người lái kiểm soát tay ga một cách chính xác, mượt mà hơn.


Thông số
Chất liệu: Cao su thiên nhiên hoặc Silicone mềm
Tính năng: Chống trượt, giảm chấn, tạo cảm giác êm ái
Thiết kế: Ergonomic phù hợp với kích thước bàn tay trung bình
Tương thích: Phù hợp cho ghi-đông đường kính 22mm tiêu chuẩn', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (85, 61, 17, N'Ốp tay thắng', 'op-tay-thang', N'Ốp tay thắng là phụ kiện nhỏ gọn nhưng mang lại lợi ích kép về cả bảo vệ lẫn thẩm mỹ cho hệ thống phanh và côn của xe. Sản phẩm giúp che chắn phần tay đòn kim loại khỏi các vết trầy xước do va chạm nhẹ hoặc oxy hóa do thời tiết, giữ cho khu vực tay lái luôn trông như mới. Được làm từ chất liệu nhựa bền bỉ hoặc cao su dẻo, ốp tay thắng còn mang lại cảm giác bóp phanh êm ái hơn, tránh cảm giác lạnh buốt khi chạm vào kim loại trong mùa đông hoặc nóng rát vào mùa hè. Với nhiều kiểu dáng và màu sắc đa dạng, đây là cách đơn giản và tiết kiệm nhất để tạo điểm nhấn nhẹ nhàng nhưng đầy tinh tế cho phần ghi-đông, phù hợp với hầu hết các dòng xe phổ thông trên thị trường.


Thông số
Chất liệu: Nhựa kỹ thuật chịu lực hoặc Silicone dẻo
Tính năng: Chống trầy xước tay thắng, tăng cảm giác êm khi bóp phanh
Đặc điểm: Dễ dàng tháo lắp tại nhà, không cần dụng cụ chuyên dụng
Màu sắc: Đen / Đỏ / Xanh', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (86, 34, 17, N'Công tắc phụ', 'cong-tac-phu', N'Công tắc phụ là thiết bị điện tiện ích cho phép người dùng tùy biến và kiểm soát các hệ thống đèn hoặc còi gắn thêm mà không ảnh hưởng đến hệ thống dây điện zin của xe. Sản phẩm được thiết kế tối giản, nhỏ gọn, có thể gắn linh hoạt tại nhiều vị trí trên ghi-đông hoặc dàn nhựa, giúp thao tác bật/tắt trở nên cực kỳ thuận tiện ngay cả khi đang chạy xe. Với cấu tạo vỏ ngoài chống thấm nước và các tiếp điểm dẫn điện bằng đồng chất lượng cao, công tắc đảm bảo hoạt động ổn định, không gây hiện tượng chập chờn hay cháy nổ. Đây là phụ kiện bắt buộc phải có cho những ai muốn lắp đặt đèn trợ sáng, đèn sương mù hoặc các hệ thống cảnh báo phụ, giúp quản lý năng lượng trên xe một cách khoa học và an toàn.


Thông số
Loại: Công tắc nhấn hoặc gạt (On/Off)
Chất liệu: Nhựa ABS chống cháy + Tiếp điểm đồng
Tính năng: Điều khiển thiết bị điện ngoại vi (Đèn trợ sáng, còi hụ,...)
Chống nước: Thiết kế kín khít chống nước mưa', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (87, 67, 17, N'Sạc USB xe máy', 'sac-usb-xe-may', N'Sạc USB xe máy là giải pháp năng lượng cứu cánh cho các biker trong kỷ nguyên số, đảm bảo điện thoại thông minh hoặc máy định vị GPS luôn đầy pin suốt hành trình. Sản phẩm lấy nguồn trực tiếp từ ắc quy xe và chuyển đổi thành dòng điện 5V tiêu chuẩn qua cổng USB tiện lợi. Được trang bị chip xử lý thông minh, bộ sạc có khả năng tự điều chỉnh dòng ra phù hợp với từng thiết bị, đồng thời tích hợp tính năng bảo vệ chống quá tải, quá nhiệt và đoản mạch. Với nắp đậy cao su chống nước tuyệt đối, bạn hoàn toàn có thể yên tâm sử dụng ngay cả dưới trời mưa bão. Đây là món đồ chơi công nghệ không thể thiếu cho những người đam mê xê dịch, chạy Grab hoặc thường xuyên phải di chuyển ngoài đường.


Thông số
Điện áp đầu vào: 12V - 24V DC
Điện áp đầu ra: 5V (Dòng sạc nhanh 2.1A - 3.1A)
Tính năng: Sạc đa thiết bị, chống nước, bảo vệ mạch điện
Cổng kết nối: 2 cổng USB tích hợp đèn LED hiển thị', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (88, 68, 17, N'Đồng hồ áp suất lốp', 'ong-ho-ap-suat-lop', N'Đồng hồ áp suất lốp (TPMS) là thiết bị an toàn chủ động giúp người lái giám sát liên tục tình trạng hơi của bánh trước và bánh sau theo thời gian thực. Thông qua các cảm biến gắn vào van xe, dữ liệu về áp suất và nhiệt độ lốp sẽ được hiển thị chính xác lên màn hình LCD gắn trên tay lái. Sản phẩm tích hợp hệ thống cảnh báo bằng âm thanh và đèn nháy ngay khi phát hiện lốp bị xuống hơi đột ngột hoặc áp suất vượt mức an toàn, giúp người lái kịp thời xử lý, tránh nguy cơ nổ lốp hay mất lái. Việc duy trì áp suất lốp chuẩn xác không chỉ đảm bảo an toàn tính mạng mà còn giúp xe vận hành nhẹ nhàng hơn, tiết kiệm nhiên liệu và hạn chế tối đa tình trạng mòn lốp không đều.


Thông số
Loại: Cảm biến áp suất lốp điện tử (Trong hoặc Ngoài)
Màn hình: LCD hoặc LED hiển thị sắc nét, chống chói
Tính năng: Cảnh báo áp suất thấp/cao, cảnh báo nhiệt độ lốp
Nguồn điện: Sử dụng pin sạc hoặc năng lượng mặt trời', 1, 1, 0, GETDATE());
INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, IsDeleted, CreatedDate) VALUES (89, 69, 17, N'Bơm mini xe máy', 'bom-mini-xe-may', N'Bơm mini xe máy là công cụ cứu hộ khẩn cấp cực kỳ hữu dụng, giúp bạn chủ động xử lý các tình huống lốp xe bị xì hơi giữa đường vắng hoặc sau một đêm dài không sử dụng. Với thiết kế siêu nhỏ gọn, sản phẩm có thể dễ dàng cất trong cốp xe hoặc balo mà không chiếm nhiều diện tích. Bơm hoạt động bằng nguồn điện 12V từ ắc quy hoặc cổng sạc trên xe, cho khả năng bơm căng lốp chỉ trong vài phút với thao tác cực kỳ đơn giản. Thân bơm được làm từ hợp kim tản nhiệt tốt, motor hoạt động mạnh mẽ nhưng không gây quá nhiều tiếng ồn. Đây là "vật bất ly thân" cho những chuyến đi tour xa, giúp bạn luôn tự tin chinh phục mọi nẻo đường mà không lo ngại các sự cố về lốp.


Thông số
Điện áp hoạt động: 12V DC
Công suất: Bơm căng lốp xe máy trong 2-5 phút
Đặc điểm: Có đồng hồ đo áp suất đi kèm, tích hợp đèn LED cứu hộ
Phụ kiện: Bộ đầu kim bơm bóng và các loại van chuyển đổi', 1, 1, 0, GETDATE());
SET IDENTITY_INSERT Products OFF;
GO

-- INSERT VARIANTS
SET IDENTITY_INSERT ProductVariants ON;
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (1, 1, 'MOTUL7100-1L', N'1L', 320000.0, 256000, 70, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (2, 1, 'MOTUL7100-15L', N'1.5L', 450000.0, 360000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (3, 2, 'MICHELIN-PS2-F', N'Lốp trước', 450000.0, 360000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (4, 2, 'MICHELIN-PS2-R', N'Lốp sau', 780000.0, 624000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (5, 3, 'GS-GTZ6V', N'Tiêu chuẩn', 380000.0, 304000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (6, 4, 'NGK-IRIDIUM', N'Tiêu chuẩn', 250000.0, 200000, 100, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (7, 5, 'BREMBO-260', N'260mm', 2500000.0, 2000000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (8, 5, 'BREMBO-300', N'300mm', 3200000.0, 2560000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (9, 6, 'RIZOMA-BLACK', N'Đen', 1200000.0, 960000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (10, 6, 'RIZOMA-SILVER', N'Bạc', 1250000.0, 1000000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (11, 7, 'KN-EX155', N'Cho Exciter 155', 900000.0, 720000, 35, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (12, 7, 'KN-WINNER', N'Cho Winner X', 880000.0, 704000, 35, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (13, 8, 'DID-428', N'Phiên bản 428 tiêu chuẩn', 350000.0, 280000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (14, 8, 'DID-428-GOLD', N'Phiên bản 428 Gold', 550000.0, 440000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (15, 9, 'RECTO-EX155', N'Cho Exciter 155', 950000.0, 760000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (16, 9, 'RECTO-WINNER', N'Cho Winner X', 920000.0, 736000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (17, 10, 'CRG-BLACK', N'Đen', 1800000.0, 1440000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (18, 10, 'CRG-RED', N'Đỏ', 1850000.0, 1480000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (19, 11, 'L4X-1', N'1 bóng', 500000.0, 400000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (20, 11, 'L4X-2', N'2 bóng', 900000.0, 720000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (21, 12, 'YSS-EX', N'Cho Exciter', 2800000.0, 2240000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (22, 12, 'YSS-WIN', N'Cho Winner', 2700000.0, 2160000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (23, 13, 'SSS-FULL', N'Full bộ', 2200000.0, 1760000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (24, 14, 'DOMINO-STD', N'Tiêu chuẩn', 1200000.0, 960000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (25, 15, 'PUIG-CLEAR', N'Trong suốt', 1500000.0, 1200000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (26, 15, 'PUIG-SMOKE', N'Đen khói', 1600000.0, 1280000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (27, 16, 'BREMBO-M4', N'Tiêu chuẩn', 6500000.0, 5200000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (28, 17, 'GALFER-260', N'Tiêu chuẩn', 2200000.0, 1760000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (29, 18, 'ELIG-F', N'Trước', 300000.0, 240000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (30, 18, 'ELIG-R', N'Sau', 280000.0, 224000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (31, 19, 'TWM-BLACK', N'Đen', 1500000.0, 1200000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (32, 20, 'DE-F', N'Trước', 800000.0, 640000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (33, 20, 'DE-R', N'Sau', 900000.0, 720000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (34, 21, 'LOCNHOT-WIN', N'Cho Winner', 90000.0, 72000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (35, 21, 'LOCNHOT-AB', N'Cho Air Blade', 85000.0, 68000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (36, 22, 'UMA-GA', N'Tiêu chuẩn', 250000.0, 200000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (37, 23, 'BREMBO-M4', N'Tiêu chuẩn', 6500000.0, 5200000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (38, 24, 'GALFER-260', N'Tiêu chuẩn', 2200000.0, 1760000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (39, 25, 'ELIG-F', N'Trước', 300000.0, 240000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (40, 25, 'ELIG-R', N'Sau', 280000.0, 224000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (41, 26, 'TWM-BLACK', N'Đen', 1500000.0, 1200000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (42, 27, 'DE-F', N'Trước', 800000.0, 640000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (43, 27, 'DE-R', N'Sau', 900000.0, 720000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (44, 28, 'CX-BLACK', N'Đen', 450000.0, 360000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (45, 29, 'COP-TI', N'Tiêu chuẩn', 2000000.0, 1600000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (46, 30, 'KOSO-MINI', N'Mini', 1800000.0, 1440000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (47, 30, 'KOSO-FULL', N'Full', 3500000.0, 2800000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (48, 31, 'GC-BLACK', N'Đen', 500000.0, 400000, 80, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (49, 32, 'BD-ROUND', N'Tròn', 700000.0, 560000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (50, 32, 'BD-SQUARE', N'Vuông', 750000.0, 600000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (51, 33, 'KET-STD', N'Tiêu chuẩn', 350000.0, 280000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (52, 34, 'HEL-F', N'Trước', 600000.0, 480000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (53, 34, 'HEL-R', N'Sau', 550000.0, 440000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (54, 35, 'DOM-SW', N'Tiêu chuẩn', 900000.0, 720000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (55, 36, 'UMA-28', N'28mm', 1700000.0, 1360000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (56, 37, 'OPPO-C', N'Tiêu chuẩn', 650000.0, 520000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (57, 38, 'MOC-BLACK', N'Đen', 120000.0, 96000, 100, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (58, 39, 'XN-F', N'Trước', 200000.0, 160000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (59, 39, 'XN-R', N'Sau', 200000.0, 160000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (60, 40, 'TAY-OP', N'Tiêu chuẩn', 300000.0, 240000, 70, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (61, 41, 'BANDO', N'Tiêu chuẩn', 450000.0, 360000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (62, 42, 'DRP-10', N'10g', 300000.0, 240000, 80, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (63, 43, 'CHUONG', N'Tiêu chuẩn', 600000.0, 480000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (64, 44, 'LOXO', N'Tiêu chuẩn', 150000.0, 120000, 100, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (65, 45, 'DOT4', N'500ml', 120000.0, 96000, 90, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (66, 46, 'NAP-RED', N'Đỏ', 150000.0, 120000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (67, 47, 'SPEED', N'Tiêu chuẩn', 500000.0, 400000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (68, 48, 'DAYDIEN', N'Full bộ', 700000.0, 560000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (69, 49, 'LOCK', N'Tiêu chuẩn', 1200000.0, 960000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (70, 50, 'CAM1', N'1 cam (Trước)', 1500000.0, 1200000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (71, 51, 'DNA-EX', N'Cho Exciter', 850000.0, 680000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (72, 51, 'DNA-WIN', N'Cho Winner', 830000.0, 664000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (73, 52, 'RCB-17', N'17 inch', 6500000.0, 5200000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (74, 53, 'SCP-SLIP', N'Slip-on', 7500000.0, 6000000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (75, 54, 'NISSIN-2P', N'Tiêu chuẩn', 1800000.0, 1440000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (76, 55, 'CNC-40', N'40T', 600000.0, 480000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (77, 56, 'RCS19', N'19RCS', 6800000.0, 5440000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (78, 57, 'BREMBO-CL', N'Tiêu chuẩn', 5500000.0, 4400000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (79, 58, 'HEL-FULL', N'Full bộ', 1200000.0, 960000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (80, 59, 'RAD-BIG', N'Lớn', 1800000.0, 1440000, 20, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (81, 60, 'FAN', N'Tiêu chuẩn', 400000.0, 320000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (82, 61, 'BRT-NOI', N'Full', 2500000.0, 2000000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (83, 62, 'ECU', N'Tiêu chuẩn', 3500000.0, 2800000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (84, 63, 'IC', N'Tiêu chuẩn', 800000.0, 640000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (85, 64, 'MOBIN', N'Tiêu chuẩn', 500000.0, 400000, 35, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (86, 65, 'LOCXANG', N'Tiêu chuẩn', 100000.0, 80000, 80, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (87, 66, 'INJECTOR', N'Tiêu chuẩn', 700000.0, 560000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (88, 67, 'PUMP', N'Tiêu chuẩn', 900000.0, 720000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (89, 68, 'LOC-CNC', N'Tiêu chuẩn', 400000.0, 320000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (90, 69, 'OPXANG', N'Tiêu chuẩn', 350000.0, 280000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (91, 70, 'TEM', N'Full bộ', 500000.0, 400000, 70, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (92, 71, 'BRT-NOI', N'Full', 2500000.0, 2000000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (93, 72, 'ECU', N'Tiêu chuẩn', 3500000.0, 2800000, 25, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (94, 73, 'IC', N'Tiêu chuẩn', 800000.0, 640000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (95, 74, 'MOBIN', N'Tiêu chuẩn', 500000.0, 400000, 35, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (96, 75, 'LOCXANG', N'Tiêu chuẩn', 100000.0, 80000, 80, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (97, 76, 'INJECTOR', N'Tiêu chuẩn', 700000.0, 560000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (98, 77, 'PUMP', N'Tiêu chuẩn', 900000.0, 720000, 30, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (99, 78, 'LOC-CNC', N'Tiêu chuẩn', 400000.0, 320000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (100, 79, 'OPXANG', N'Tiêu chuẩn', 350000.0, 280000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (101, 80, 'TEM', N'Full bộ', 500000.0, 400000, 70, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (102, 81, 'KEO', N'Full xe', 1000000.0, 800000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (103, 82, 'YEN', N'Tiêu chuẩn', 400000.0, 320000, 50, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (104, 83, 'GU', N'Đen', 250000.0, 200000, 60, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (105, 84, 'GRIP', N'Đen', 120000.0, 96000, 80, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (106, 85, 'OPTAY', N'Tiêu chuẩn', 100000.0, 80000, 90, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (107, 86, 'SW', N'Tiêu chuẩn', 80000.0, 64000, 100, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (108, 87, 'USB', N'2 cổng', 200000.0, 160000, 70, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (109, 88, 'TPMS', N'Tiêu chuẩn', 600000.0, 480000, 40, GETDATE());
INSERT INTO ProductVariants (ProductVariantId, ProductId, SKU, VariantName, Price, CostPrice, StockQuantity, CreatedDate) VALUES (110, 89, 'PUMP-MINI', N'Tiêu chuẩn', 350000.0, 280000, 60, GETDATE());
SET IDENTITY_INSERT ProductVariants OFF;
GO

-- INSERT IMAGES
SET IDENTITY_INSERT ProductImages ON;
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (1, 1, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (2, 2, 'https://cf.shopee.vn/file/vn-11134207-7ra0g-ma4aqo52ong852', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (3, 3, 'https://cf.shopee.vn/file/sg-11134201-7rdvv-lzzy638h94kic7', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (4, 4, 'https://cf.shopee.vn/file/vn-11134207-7r98o-lzlek80h6rf1d1', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (5, 5, 'https://cf.shopee.vn/file/vn-11134207-7ra0g-m7ak1pozkt189a', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (6, 6, 'https://cf.shopee.vn/file/sg-11134201-7reno-m2ojl0r6c7ax1a', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (7, 7, 'https://cf.shopee.vn/file/sg-11134201-7rdwl-mbxeh3b9qhp611', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (8, 8, 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRzXgshMHYCXpqqWm4atxJMCWJvDSZrGef87Oo56MiOK_GkrlxThuFPRtHh2lfKhvMK-ahPzPP1It952Xyw_GN2FAAtsrO8ZUH080Eg5Wz5iZs7D6BR1-dqIrgbkZPrF-T43_Jr8Q&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (9, 9, 'https://cf.shopee.vn/file/sg-11134201-22110-nv34i5b53cjvb4', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (10, 10, 'https://cf.shopee.vn/file/vn-11134201-820l4-men2wvvtpa115e', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (11, 11, 'https://cf.shopee.vn/file/sg-11134201-7rd3m-lvevl9p97rhuf4', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (12, 12, 'https://cf.shopee.vn/file/4c229fb05edf79352b048fe50e381a1e', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (13, 13, 'https://dochoixemay68.com/wp-content/uploads/2022/10/NOI.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (14, 14, 'https://cf.shopee.vn/file/vn-11134207-7qukw-levpnwo86t7b40', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (15, 15, 'https://imgwebikenet-8743.kxcdn.com/catalogue/images/102977/3490H_1.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (16, 16, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/477/832/products/1-8e89a2e3-ab89-45f8-a731-8952e3f845c1.png?v=1749883483687', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (17, 17, 'https://cf.shopee.vn/file/vn-11134207-7r98o-lmbg3cqp77j368', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (18, 18, 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSMiJo0rivfTLtlZWq5xXfrZZUSSgs4f7EMbJbpYup7QnqZ7XYR5Sx23xaeHTkatYRst5qfuN7AkLMrKMIl7V6x8bU9wlaUwO4eyVHlXbwkNxlanv-cTutGvflCLKNlYvwgc4LT09Q&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (19, 19, 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSlIjQEf8D0S8RP6FlX0QpjJPl5KAc0XWZBwXWmdfBjuX0KKc25D-j8ufpXFD2KOQUDzxTCbMK0PT5TGNtdd8b2rQHphyGoB6Tbgkqf53Ih1CaQzbt8vGfiTsFt-RGqkpnEeQQzig&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (20, 20, 'https://cf.shopee.vn/file/sg-11134201-821f5-mhaafgv1qebud1', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (21, 21, 'https://cf.shopee.vn/file/6f338502d1b4d4957219552d35117307', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (22, 22, 'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcR0JJkndkB2MOnw71VD4-crw-RqTrWBvjKYJCIG_WTWbLbEdWOGHXi0gKOr057YBrYtRASwF7YohwzSEMSEM2ZnXtvYs60sEDyfKVVH2wzMJTZI3u02r-Krz6Q_7yimrz2XH_PDhw&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (23, 23, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/477/832/products/1-8e89a2e3-ab89-45f8-a731-8952e3f845c1.png?v=1749883483687', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (24, 24, 'https://cf.shopee.vn/file/vn-11134207-7r98o-lmbg3cqp77j368', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (25, 25, 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSMiJo0rivfTLtlZWq5xXfrZZUSSgs4f7EMbJbpYup7QnqZ7XYR5Sx23xaeHTkatYRst5qfuN7AkLMrKMIl7V6x8bU9wlaUwO4eyVHlXbwkNxlanv-cTutGvflCLKNlYvwgc4LT09Q&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (26, 26, 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSlIjQEf8D0S8RP6FlX0QpjJPl5KAc0XWZBwXWmdfBjuX0KKc25D-j8ufpXFD2KOQUDzxTCbMK0PT5TGNtdd8b2rQHphyGoB6Tbgkqf53Ih1CaQzbt8vGfiTsFt-RGqkpnEeQQzig&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (27, 27, 'https://cf.shopee.vn/file/sg-11134201-821f5-mhaafgv1qebud1', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (28, 28, 'https://qawing.com/wp-content/uploads/2022/05/QAWG23A00590.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (29, 29, 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcTKPPOZsqcI2byKcLbSvAAwtEWXlHHlYV1XuVjv-xJJKCqoLaRu0Q_wJRQJJAZLjOKJQxrwCfkNiiTLD_eAmWfR-ee_IazIhQ7t8wMkurvKvIcZ70v0Q544iAdbjIhSQVAqLlJVpsg&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (30, 30, 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQpGVpwDITKMs6EUQteDc4mpNHmfhfgiS1f1aCMnZrx4FSqJR8NW4buSTZI_7icMgcQpO7KjQbBgZTyCMjRm0N8GuSu7EkrVxlvYxCvojJnY9BXzU1d6nl10ZUvPGYDq3SCjxfPkHg&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (31, 31, 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRTBfmCdjsr1t_vglxVw93UGd3LnHe_xDpx0Kjcv7JypfZnK2nvGVxlJsmq2ktW126TA6aqQpvVn_KPKRgntkIe0HOknShvJFSsXq77hcaf67NTUK0Wwy86cfikPYN45gBr_0ceBdw&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (32, 32, 'https://down-vn.img.susercontent.com/file/a5d7e84afd5e447f170e7e2d65853367@resize_w900_nl.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (33, 33, 'https://autostyle.vn/wp-content/uploads/2025/03/Luoi-Che-ket-Nuoc-Nhap-Thai-Cho-Xe-Ford-Next-Gen-3.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (34, 34, 'https://biraceshop.com/watermark/product/560x520x1/upload/product/f50b84ec-a272-4923-8ee5-a41f1ffb22cd-8189.jpeg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (35, 35, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/477/832/products/1-43d13d09-ea46-45d8-9759-4278e268585e.png?v=1752205421260', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (36, 36, 'https://bizweb.dktcdn.net/thumb/grande/100/444/341/products/5d17e08fd43b9fcd91577e84ea41c987-tn-jpeg-1685098423622.jpg?v=1685098426203', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (37, 37, 'https://fmanracing.com/images/op-chong-nong-carbon-lon-dai-1-1608433494911.jpeg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (38, 38, 'https://shop2banh.vn/images/thumbs/2022/11/moc-treo-do-cnc-cho-honda-sh-1954-slide-products-636339ae0f583.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (39, 39, 'https://img.lazcdn.com/g/p/8b683eeeb455082f66406f8256d78bd6.jpg_720x720q80.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (40, 40, 'https://trangtrixemayhoangtri.com/upload/product/747187187298.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (41, 41, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/419/633/products/day-cua-roa-bando-01.png?v=1702262036117', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (42, 42, 'https://imgwebikenet-8743.kxcdn.com/catalogue/18903/20-15-001.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (43, 43, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lxyycuzd7s2h55', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (44, 44, 'https://product.hstatic.net/200000692635/product/_noi_sonic_150r__winner__cbr_150r__cb_150r_chinh_hang_honda_1_bo_4_cai_0e70bd8e1ff84b059f97b6d2d0ccf4e1_master.png', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (45, 45, 'https://hpk.vn/wp-content/uploads/2024/06/a3-12.png', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (46, 46, 'https://cbcworkshop.com/wp-content/uploads/2025/06/CNC-Nap-nhot-Triumph-3.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (47, 47, 'https://binhduongngoisao.vn/wp-content/uploads/2025/03/ce1baa3m20bie1babfn20te1bb91c20c491e1bb9920xe-1.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (48, 48, 'https://down-vn.img.susercontent.com/file/ed8eb637d3559c21031be82e19c84a1c', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (49, 49, 'https://down-vn.img.susercontent.com/file/sg-11134201-22120-js20aq4s2qkv53', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (50, 50, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/m/a/may-quay-chong-rung-dji-osmo-pocket-3-advanced-4k_1.png', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (51, 51, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRy2HpyvvVBGIvMQP-nYInazzoyp96ar_hoAA&s', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (52, 52, 'https://congtuan.vn/upload/images/2019/10/360x360-1571035975-mamrcb5cayexciter.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (53, 53, 'https://drsmotor.vn/upload/product/z4276763258536afaca5fce871405db4b1a3e9cfd055b9-3574.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (54, 54, 'https://product.hstatic.net/1000375176/product/img_7814_1ab7de96f44149de99e01ba0992ef14a_master.png', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (55, 55, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRq-KPAu9Szb3xaSHLl6zp0ncBIJTB1OnwGlQ&s', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (56, 56, 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-ml9cpi58hekjd9@resize_w900_nl.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (57, 57, 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mhhb4mj3opvq72@resize_w900_nl.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (58, 58, 'https://bbracing.vn/watermark/product/900x600x6/upload/product/1-2-6492.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (59, 59, 'https://img.lazcdn.com/g/p/d0ae4a03b48f79551e36c629970ef2bd.jpg_720x720q80.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (60, 60, 'https://down-vn.img.susercontent.com/file/15237d49bd76d9e0e7f86eb96aad9b6d', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (61, 61, 'https://cdn.hstatic.net/products/1000375176/dsc05817_1aa853659144480b9031486c6f555f10_master.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (62, 62, 'https://bizweb.dktcdn.net/100/431/877/articles/05-e2092a1eb71e4e79bcd161505265716a-grande.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (63, 63, 'https://phutungthuanthanh.com/wp-content/uploads/2019/03/icex1.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (64, 64, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ls87m51qtrycec', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (65, 65, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/459/279/products/loc-xang2-jpg.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (66, 66, 'https://vietnamgarage.vn/wp-content/uploads/2023/11/Kim-Phun-Nhien-Lieu-O-to-2.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (67, 67, 'https://vapgroup.com.vn/public_folder/files_upload/202410/56ad5fb7840a5d8db56606bbd0855e6a.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (68, 68, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m53xu8dz56v726', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (69, 69, 'https://hoimexe.com/wp-content/uploads/2023/10/op-binh-xang-honda-rebel-300-500.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (70, 70, 'https://inminhkhang.com/wp-content/uploads/2023/11/tem-dan-xe-4.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (71, 71, 'https://cdn.hstatic.net/products/1000375176/dsc05817_1aa853659144480b9031486c6f555f10_master.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (72, 72, 'https://bizweb.dktcdn.net/100/431/877/articles/05-e2092a1eb71e4e79bcd161505265716a-grande.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (73, 73, 'https://phutungthuanthanh.com/wp-content/uploads/2019/03/icex1.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (74, 74, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ls87m51qtrycec', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (75, 75, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/459/279/products/loc-xang2-jpg.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (76, 76, 'https://vietnamgarage.vn/wp-content/uploads/2023/11/Kim-Phun-Nhien-Lieu-O-to-2.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (77, 77, 'https://vapgroup.com.vn/public_folder/files_upload/202410/56ad5fb7840a5d8db56606bbd0855e6a.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (78, 78, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m53xu8dz56v726', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (79, 79, 'https://hoimexe.com/wp-content/uploads/2023/10/op-binh-xang-honda-rebel-300-500.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (80, 80, 'https://inminhkhang.com/wp-content/uploads/2023/11/tem-dan-xe-4.webp', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (81, 81, 'https://bizweb.dktcdn.net/100/460/221/files/dan-keo-xe-bao-nhieu-tien-3.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (82, 82, 'https://3mp.vn/wp-content/uploads/2024/07/yen-xe-wave-9-600x450-1.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (83, 83, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/381/742/products/68dc3475-0ea6-4f26-b232-92b39a672b63.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (84, 84, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m77pnix40pd303_tn', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (85, 85, 'https://file.hstatic.net/1000238613/file/3_d373c2f4266546a3a78dede3267f47ed.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (86, 86, 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSsHhYHoK3KVWXxSZtHVyeSjOKka_J94-Xp55q7p7gfeUwLbM4iVYbtSJrdJYaaOAwyZ8iJ5zozxvsYNNJSl_19EnSN1sozOcR9KmOWoV8I&usqp=CAc', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (87, 87, 'https://bizweb.dktcdn.net/100/356/047/files/e3d71ca7-1216-48f8-9354-4a055860f14a-jpeg.jpg', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (88, 88, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-IIqvH338hSx5IxrIsGafjRwd65DrGQLaXw&s', 1, 1);
INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (89, 89, 'https://boba.vn/static/san-pham/doi-song/qua-tang-hang-thu-cong/moc-khoa/bom-hoi-mini-xe-may/maybomhoi.jpg', 1, 1);
SET IDENTITY_INSERT ProductImages OFF;
GO
