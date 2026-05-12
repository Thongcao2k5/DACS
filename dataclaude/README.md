# MotoShop Seed Data

Bộ dữ liệu mẫu cho dự án MotoShop, gồm:
- **6 danh mục** × **3 sản phẩm** = 18 sản phẩm
- **6 thương hiệu** × **3 sản phẩm** (đã cân để tổng khớp 18 SP)
- **29 biến thể** với SKU, giá, tồn kho thật
- **94 ảnh** (36 ảnh sản phẩm + 58 ảnh biến thể)
- **6 logo thương hiệu** + **6 ảnh danh mục**
- Specifications + Tags

---

## 📂 Cấu trúc

```
motoshop_seed/
├── motoshop_seed.sql      # SQL INSERT (chạy trên SQL Server)
├── download_images.py     # Script Python tải ảnh về local
└── README.md              # File này
```

## 🚀 Hướng dẫn chạy (theo thứ tự)

### Bước 1 — Tải ảnh về local

```bash
cd motoshop_seed
python download_images.py
```

Script sẽ tạo thư mục `uploads/` với ~106 ảnh, đường dẫn khớp 100% với SQL:

```
uploads/
├── categories/    (6 ảnh danh mục)
├── brands/        (6 logo thương hiệu)
├── products/      (36 ảnh sản phẩm)
└── variants/      (58 ảnh biến thể)
```

> **Tổng dung lượng:** ~30-50 MB. Mất ~2-3 phút.
> **Yêu cầu:** Python 3.6+ (không cần cài thêm thư viện nào)

### Bước 2 — Copy thư mục `uploads/` vào dự án

Đặt `uploads/` vào nơi web server của bạn phục vụ static file.
Ví dụ ASP.NET Core: copy vào `wwwroot/uploads/`

### Bước 3 — Chạy SQL

Mở **SQL Server Management Studio** (hoặc Azure Data Studio):

1. Kết nối đến database `MotoShop`
2. Mở `motoshop_seed.sql`
3. Chạy (F5)

> Script bắt đầu bằng `USE [MotoShop]` — đổi tên database nếu khác.
> Script dùng `SET IDENTITY_INSERT` để gán ID cố định, đảm bảo
> các foreign key giữa Products → Variants → Images khớp nhau.

---

## 🖼️ Nguồn ảnh — Vì sao link không hư?

| Nguồn | Mục đích | Tính ổn định |
|-------|----------|-----|
| **loremflickr.com** | Ảnh thật từ Flickr Creative Commons theo từ khóa | URL trả về ảnh ngẫu nhiên match keyword |
| **logo.clearbit.com** | Logo thương hiệu chính thức | URL ổn định theo domain |
| **picsum.photos** (fallback) | Ảnh dự phòng nếu loremflickr lỗi | URL có seed → luôn cho cùng 1 ảnh |

**Điểm quan trọng:** SQL của bạn lưu **đường dẫn local** (`/uploads/...`)
chứ KHÔNG lưu URL ngoài. Nên một khi đã chạy `download_images.py` → ảnh
nằm trên ổ cứng/server của bạn → KHÔNG BAO GIỜ HƯ.

---

## 📊 Phân bố dữ liệu

### 6 danh mục — mỗi danh mục có đúng 3 sản phẩm

| ID | Danh mục | Sản phẩm |
|----|----------|----------|
| 1 | Nhớt & Dầu nhờn | 3 SP Castrol |
| 2 | Lốp xe | 3 SP Michelin |
| 3 | Mũ bảo hiểm | 3 SP AGV |
| 4 | Ắc quy | 3 SP Yuasa |
| 5 | Phụ tùng máy | 2 Honda + 1 Yamaha |
| 6 | Phụ kiện xe | 1 Honda + 2 Yamaha |

### 6 thương hiệu — mỗi thương hiệu có đúng 3 sản phẩm

| ID | Thương hiệu | Sản phẩm |
|----|-------------|----------|
| 1 | Honda | 2 phụ tùng + 1 phụ kiện |
| 2 | Yamaha | 1 phụ tùng + 2 phụ kiện |
| 3 | Castrol | 3 nhớt |
| 4 | Michelin | 3 lốp xe |
| 5 | Yuasa | 3 ắc quy |
| 6 | AGV | 3 mũ bảo hiểm |

### Biến thể (29 cái)

| Sản phẩm | Số biến thể | Phân loại theo |
|----------|-------------|----------------|
| 3 SP nhớt Castrol | 6 (2 mỗi SP) | Dung tích (1L / 0.8L) |
| 3 SP lốp Michelin | 3 (1 mỗi SP) | Kích cỡ |
| AGV K1 S, K3 SV | 6 (3 mỗi SP) | Size (M/L/XL) |
| AGV Pista GP RR | 2 | Size (L/XL) |
| 3 SP ắc quy Yuasa | 3 (1 mỗi SP) | Dung lượng |
| 3 SP phụ tùng | 3 (1 mỗi SP) | Tiêu chuẩn |
| Gương Honda Vario | 2 | Màu (Đen/Bạc) |
| Bao tay Yamaha | 2 | Màu (Đen/Đỏ) |
| Đèn LED Yamaha | 2 | Ánh sáng (Trắng/Vàng) |

---

## ⚠️ Lưu ý

1. **Ảnh là ảnh CC từ Flickr theo từ khóa** — không phải ảnh sản phẩm chính xác.
   Cho demo/seed thì OK. Để production nên thay bằng ảnh chụp thật của shop.

2. **Nếu DB đã có dữ liệu**: chạy `SET IDENTITY_INSERT` có thể conflict.
   Khi đó: bỏ các dòng `IDENTITY_INSERT` và để DB tự sinh ID, rồi điều chỉnh
   các FK ở các bảng phụ thuộc.

3. **Logo Clearbit có thể trả 404** với một số domain ít phổ biến (như yuasa.com).
   Script đã có fallback sang loremflickr với keyword `logo,{tên}`.

4. **Nếu đổi đường dẫn ảnh** (ví dụ dùng `/static/` thay vì `/uploads/`):
   chạy `UPDATE` SQL đơn giản:
   ```sql
   UPDATE ProductImages   SET ImageUrl = REPLACE(ImageUrl, '/uploads/', '/static/');
   UPDATE VariantImages   SET ImageUrl = REPLACE(ImageUrl, '/uploads/', '/static/');
   UPDATE Products        SET ImageUrl = REPLACE(ImageUrl, '/uploads/', '/static/');
   -- ... tương tự cho Categories, Brands, ProductVariants
   ```

---

Made with ❤️ cho dự án MotoShop của bạn.
