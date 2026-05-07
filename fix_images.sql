-- Fix Images for 60 products in generated_products_v2.txt
-- Category: BỘ NỒI XE TAY GA
DECLARE @pid INT;

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ nồi trước/sau Apido chuyên dụng' AND SKU LIKE 'API-BỘ 1%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg', 1, 0);
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 0, 1);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ nồi trước/sau Malossi chuyên dụng' AND SKU LIKE 'MAL-BỘ 2%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg', 1, 0);
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 0, 1);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ nồi trước/sau Apido chuyên dụng' AND SKU LIKE 'API-BỘ 3%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ nồi trước/sau Faito chuyên dụng');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ nồi trước/sau Apido chuyên dụng' AND SKU LIKE 'API-BỘ 5%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61k9H4lP8FL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

-- Category: NHÔNG - SÊN - DĨA
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ Nhông Sên Dĩa MTX High Performance' AND SKU LIKE 'MTX-BỘ 6%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg', 0, 1);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ Nhông Sên Dĩa Apido High Performance' AND SKU LIKE 'API-BỘ 7%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ Nhông Sên Dĩa MTX High Performance' AND SKU LIKE 'MTX-BỘ 8%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ Nhông Sên Dĩa RGV High Performance');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ Nhông Sên Dĩa Apido High Performance' AND SKU LIKE 'API-BỘ 10%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

-- Category: CĂM XE MÁY
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Căm xe máy Yaguso mạ Crom/Vàng' AND SKU LIKE 'YAG-CĂM11%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Căm xe máy Yaguso mạ Crom/Vàng' AND SKU LIKE 'YAG-CĂM12%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Căm xe máy RGV mạ Crom/Vàng' AND SKU LIKE 'RGV-CĂM13%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Căm xe máy RGV mạ Crom/Vàng' AND SKU LIKE 'RGV-CĂM14%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Căm xe máy Tan Lan mạ Crom/Vàng');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71X8Xm6pXVL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

-- Category: MÁY SẠC - BÌNH ĐIỆN (ẮC QUY)
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bình ắc quy Gel Senarc siêu bền' AND SKU LIKE 'SEN-BÌN16%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bình ắc quy Gel Motobatt siêu bền' AND SKU LIKE 'MOT-BÌN17%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bình ắc quy Gel Motobatt siêu bền' AND SKU LIKE 'MOT-BÌN18%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bình ắc quy Gel Motobatt siêu bền' AND SKU LIKE 'MOT-BÌN19%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bình ắc quy Gel Senarc siêu bền' AND SKU LIKE 'SEN-BÌN20%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71x4h5zQp8L._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

-- Category: LỌC GIÓ
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Lọc gió độ Malossi tăng lưu lượng khí' AND SKU LIKE 'MAL-LỌC21%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Lọc gió độ Kozi tăng lưu lượng khí' AND SKU LIKE 'KOZ-LỌC22%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Lọc gió độ Kozi tăng lưu lượng khí' AND SKU LIKE 'KOZ-LỌC23%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Lọc gió độ Faito tăng lưu lượng khí');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Lọc gió độ Malossi tăng lưu lượng khí' AND SKU LIKE 'MAL-LỌC25%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

-- Category: PHỤ GIA - NHỚT
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Nhớt tổng hợp RGV Racing' AND SKU LIKE 'RGV-NHỚ26%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg', 1, 0);
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61I+4eDizPL._AC_SL1500_.jpg', 0, 1);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Nhớt tổng hợp Faito Racing');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Nhớt tổng hợp Malossi Racing');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Nhớt tổng hợp RGV Racing' AND SKU LIKE 'RGV-NHỚ29%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Nhớt tổng hợp RGV Racing' AND SKU LIKE 'RGV-NHỚ30%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71Rndu-B3lL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

-- Category: BỐ THẮNG
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bố thắng Ceramic Apido chịu nhiệt');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bố thắng Ceramic RGV chịu nhiệt');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bố thắng Ceramic Faito chịu nhiệt' AND SKU LIKE 'FAI-BỐ 33%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bố thắng Ceramic Faito chịu nhiệt' AND SKU LIKE 'FAI-BỐ 34%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bố thắng Ceramic MTX chịu nhiệt');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/71iZ5x+m6LL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

-- Category: VỎ XE - NIỀNG XE
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Vỏ xe không ruột TR Tiller bám đường' AND SKU LIKE 'TR -VỎ 36%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Vỏ xe không ruột FKR bám đường' AND SKU LIKE 'FKR-VỎ 37%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Vỏ xe không ruột FKR bám đường' AND SKU LIKE 'FKR-VỎ 38%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Vỏ xe không ruột TR Tiller bám đường' AND SKU LIKE 'TR -VỎ 39%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Vỏ xe không ruột TR Tiller bám đường' AND SKU LIKE 'TR -VỎ 40%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/81+wE2GfHGL._AC_SL1500_.jpg' WHERE ProductId = @pid;
END

-- Category: DÂY CÁP
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Dây ga/Dây côn Apido bọc Teflon' AND SKU LIKE 'API-DÂY41%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Dây ga/Dây côn Kozi bọc Teflon' AND SKU LIKE 'KOZ-DÂY42%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Dây ga/Dây côn Apido bọc Teflon' AND SKU LIKE 'API-DÂY43%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Dây ga/Dây côn RGV bọc Teflon');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Dây ga/Dây côn Kozi bọc Teflon' AND SKU LIKE 'KOZ-DÂY45%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

-- Category: PHÂN KHỐI LỚN
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phuộc/Pô YSS cho xe PKL' AND SKU LIKE 'YSS-PHU46%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phuộc/Pô YSS cho xe PKL' AND SKU LIKE 'YSS-PHU47%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phuộc/Pô Malossi cho xe PKL');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phuộc/Pô YSS cho xe PKL' AND SKU LIKE 'YSS-PHU49%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phuộc/Pô CRG cho xe PKL');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

-- Category: CHÉN CỔ
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ chén cổ bi đũa Kozi');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ chén cổ bi đũa RGV' AND SKU LIKE 'RGV-BỘ 52%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ chén cổ bi đũa RGV' AND SKU LIKE 'RGV-BỘ 53%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ chén cổ bi đũa RGV' AND SKU LIKE 'RGV-BỘ 54%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Bộ chén cổ bi đũa RGV' AND SKU LIKE 'RGV-BỘ 55%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

-- Category: PHỤ KIỆN KHÁC
SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phụ kiện trang trí Kozi CNC' AND SKU LIKE 'KOZ-PHỤ56%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phụ kiện trang trí YSS CNC');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phụ kiện trang trí Kozi CNC' AND SKU LIKE 'KOZ-PHỤ58%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phụ kiện trang trí Kozi CNC' AND SKU LIKE 'KOZ-PHỤ59%');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END

SET @pid = (SELECT ProductId FROM Products WHERE ProductName = N'Phụ kiện trang trí Apido CNC');
IF @pid IS NOT NULL BEGIN
    DELETE FROM ProductImages WHERE ProductId = @pid;
    INSERT INTO ProductImages (ProductId, ImageUrl, IsPrimary, DisplayOrder) VALUES (@pid, 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg', 1, 0);
    UPDATE ProductVariants SET ImageUrl = 'https://m.media-amazon.com/images/I/61Nf+m6pXVL._AC_SL1000_.jpg' WHERE ProductId = @pid;
END
