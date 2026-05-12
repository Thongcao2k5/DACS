"""
download_images.py — Tải toàn bộ ảnh cho MotoShop seed data về local

CÁCH CHẠY:
    python download_images.py

KẾT QUẢ:
    Tạo thư mục ./uploads/{categories,brands,products,variants}/
    với toàn bộ ảnh đã tải về.

NGUỒN ẢNH (đều là nguồn miễn phí, ổn định):
    - loremflickr.com    -> ảnh thật theo từ khóa từ Flickr CC
    - logo.clearbit.com  -> logo thương hiệu
    - picsum.photos      -> fallback nếu loremflickr lỗi

Sau khi chạy script này, các path trong DB (ví dụ /uploads/products/...)
sẽ trỏ đến file thật trên ổ cứng -> KHÔNG BAO GIỜ HƯ LINK.
"""

import os
import sys
import time
import urllib.request
import urllib.error

# ----------------------------------------------------------------------------
# Cấu hình thư mục đích
# ----------------------------------------------------------------------------
BASE_DIR = "uploads"
SUBDIRS = ["categories", "brands", "products", "variants"]

# ----------------------------------------------------------------------------
# DANH SÁCH ẢNH CẦN TẢI: (đường_dẫn_local, từ_khóa_tìm_ảnh, kích_thước)
# ----------------------------------------------------------------------------

# Categories (6 ảnh)
CATEGORY_IMAGES = [
    ("uploads/categories/nhot-dau-nhon.jpg",  "motor,oil,bottle"),
    ("uploads/categories/lop-xe.jpg",         "motorcycle,tire"),
    ("uploads/categories/mu-bao-hiem.jpg",    "motorcycle,helmet"),
    ("uploads/categories/ac-quy.jpg",         "battery,motorcycle"),
    ("uploads/categories/phu-tung-may.jpg",   "motorcycle,engine,parts"),
    ("uploads/categories/phu-kien-xe.jpg",    "motorcycle,accessory"),
]

# Brand logos (6 logo) - dùng Clearbit Logo API
BRAND_LOGOS = [
    ("uploads/brands/honda.png",    "https://logo.clearbit.com/honda.com"),
    ("uploads/brands/yamaha.png",   "https://logo.clearbit.com/yamaha-motor.com"),
    ("uploads/brands/castrol.png",  "https://logo.clearbit.com/castrol.com"),
    ("uploads/brands/michelin.png", "https://logo.clearbit.com/michelin.com"),
    ("uploads/brands/yuasa.png",    "https://logo.clearbit.com/yuasa.com"),
    ("uploads/brands/agv.png",      "https://logo.clearbit.com/agv.com"),
]

# Product images (36 ảnh = 18 SP x 2 ảnh)
PRODUCT_IMAGES = [
    # P1 Castrol POWER 1
    ("uploads/products/nhot-castrol-power-1-4t-10w40-1.jpg",        "motor,oil,bottle"),
    ("uploads/products/nhot-castrol-power-1-4t-10w40-2.jpg",        "engine,oil,can"),
    # P2 Castrol ACTIV
    ("uploads/products/nhot-castrol-activ-4t-20w40-1.jpg",          "motor,oil"),
    ("uploads/products/nhot-castrol-activ-4t-20w40-2.jpg",          "lubricant,oil"),
    # P3 Castrol MAGNATEC
    ("uploads/products/nhot-castrol-magnatec-4t-10w40-1.jpg",       "motor,oil,car"),
    ("uploads/products/nhot-castrol-magnatec-4t-10w40-2.jpg",       "engine,lubricant"),
    # P4 Michelin City Grip 2
    ("uploads/products/lop-michelin-city-grip-2-90-90-14-1.jpg",    "scooter,tire"),
    ("uploads/products/lop-michelin-city-grip-2-90-90-14-2.jpg",    "motorcycle,tire,closeup"),
    # P5 Michelin Pilot Street 2
    ("uploads/products/lop-michelin-pilot-street-2-100-80-17-1.jpg", "motorcycle,tire"),
    ("uploads/products/lop-michelin-pilot-street-2-100-80-17-2.jpg", "tire,wheel"),
    # P6 Michelin Power Pure SC
    ("uploads/products/lop-michelin-power-pure-sc-120-70-12-1.jpg", "scooter,wheel,tire"),
    ("uploads/products/lop-michelin-power-pure-sc-120-70-12-2.jpg", "motorcycle,sport,tire"),
    # P7 AGV K1 S
    ("uploads/products/mu-bao-hiem-agv-k1-s-solid-1.jpg",           "motorcycle,helmet,fullface"),
    ("uploads/products/mu-bao-hiem-agv-k1-s-solid-2.jpg",           "racing,helmet"),
    # P8 AGV K3 SV
    ("uploads/products/mu-bao-hiem-agv-k3-sv-rossi-1.jpg",          "motorcycle,helmet,sport"),
    ("uploads/products/mu-bao-hiem-agv-k3-sv-rossi-2.jpg",          "rider,helmet"),
    # P9 AGV Pista GP RR
    ("uploads/products/mu-bao-hiem-agv-pista-gp-rr-1.jpg",          "motogp,helmet"),
    ("uploads/products/mu-bao-hiem-agv-pista-gp-rr-2.jpg",          "carbon,helmet,racing"),
    # P10 Yuasa YTX7A-BS
    ("uploads/products/ac-quy-yuasa-ytx7a-bs-12v-7ah-1.jpg",        "battery,motorcycle"),
    ("uploads/products/ac-quy-yuasa-ytx7a-bs-12v-7ah-2.jpg",        "battery,12v"),
    # P11 Yuasa YB9-B
    ("uploads/products/ac-quy-yuasa-yb9-b-12v-9ah-1.jpg",           "lead,acid,battery"),
    ("uploads/products/ac-quy-yuasa-yb9-b-12v-9ah-2.jpg",           "battery,vehicle"),
    # P12 Yuasa YTZ10S
    ("uploads/products/ac-quy-yuasa-ytz10s-12v-8-6ah-1.jpg",        "agm,battery"),
    ("uploads/products/ac-quy-yuasa-ytz10s-12v-8-6ah-2.jpg",        "sealed,battery"),
    # P13 Bộ nhông xích Wave
    ("uploads/products/bo-nhong-xich-honda-wave-alpha-1.jpg",       "motorcycle,chain,sprocket"),
    ("uploads/products/bo-nhong-xich-honda-wave-alpha-2.jpg",       "chain,gear"),
    # P14 Bố thắng đĩa CBR
    ("uploads/products/bo-thang-dia-honda-cbr150r-1.jpg",           "brake,disc,motorcycle"),
    ("uploads/products/bo-thang-dia-honda-cbr150r-2.jpg",           "brake,pad"),
    # P15 Lọc gió Exciter
    ("uploads/products/loc-gio-yamaha-exciter-150-1.jpg",           "air,filter,motorcycle"),
    ("uploads/products/loc-gio-yamaha-exciter-150-2.jpg",           "engine,filter"),
    # P16 Gương Honda Vario
    ("uploads/products/guong-chieu-hau-honda-vario-150-1.jpg",      "motorcycle,mirror"),
    ("uploads/products/guong-chieu-hau-honda-vario-150-2.jpg",      "scooter,mirror,side"),
    # P17 Bao tay Yamaha Exciter
    ("uploads/products/bao-tay-yamaha-exciter-155-vva-1.jpg",       "motorcycle,grip,handle"),
    ("uploads/products/bao-tay-yamaha-exciter-155-vva-2.jpg",       "rubber,grip"),
    # P18 Đèn LED Yamaha
    ("uploads/products/den-led-tro-sang-yamaha-30w-1.jpg",          "led,headlight,motorcycle"),
    ("uploads/products/den-led-tro-sang-yamaha-30w-2.jpg",          "auxiliary,light,motorcycle"),
]

# Variant images (58 ảnh = 29 biến thể x 2 ảnh)
VARIANT_IMAGES = [
    ("uploads/variants/nhot-castrol-power1-1l-1.jpg",  "motor,oil,1L"),
    ("uploads/variants/nhot-castrol-power1-1l-2.jpg",  "oil,bottle,red"),
    ("uploads/variants/nhot-castrol-power1-08l-1.jpg", "small,oil,bottle"),
    ("uploads/variants/nhot-castrol-power1-08l-2.jpg", "lubricant,can"),
    ("uploads/variants/nhot-castrol-activ-1l-1.jpg",   "engine,oil,green"),
    ("uploads/variants/nhot-castrol-activ-1l-2.jpg",   "motor,oil,bottle"),
    ("uploads/variants/nhot-castrol-activ-08l-1.jpg",  "small,bottle,oil"),
    ("uploads/variants/nhot-castrol-activ-08l-2.jpg",  "oil,can,small"),
    ("uploads/variants/nhot-castrol-mag-1l-1.jpg",     "magnatec,oil"),
    ("uploads/variants/nhot-castrol-mag-1l-2.jpg",     "synthetic,oil"),
    ("uploads/variants/nhot-castrol-mag-08l-1.jpg",    "engine,oil,blue"),
    ("uploads/variants/nhot-castrol-mag-08l-2.jpg",    "motor,lubricant"),
    ("uploads/variants/lop-mich-cg2-90-90-14-1.jpg",   "scooter,tire,14inch"),
    ("uploads/variants/lop-mich-cg2-90-90-14-2.jpg",   "tire,closeup,tread"),
    ("uploads/variants/lop-mich-ps2-100-80-17-1.jpg",  "motorcycle,tire,17inch"),
    ("uploads/variants/lop-mich-ps2-100-80-17-2.jpg",  "sport,tire,wheel"),
    ("uploads/variants/lop-mich-pp-120-70-12-1.jpg",   "scooter,sport,tire"),
    ("uploads/variants/lop-mich-pp-120-70-12-2.jpg",   "tire,12inch"),
    ("uploads/variants/mu-agv-k1s-m-1.jpg",  "helmet,fullface,black"),
    ("uploads/variants/mu-agv-k1s-m-2.jpg",  "motorcycle,helmet,m"),
    ("uploads/variants/mu-agv-k1s-l-1.jpg",  "racing,helmet,large"),
    ("uploads/variants/mu-agv-k1s-l-2.jpg",  "helmet,visor"),
    ("uploads/variants/mu-agv-k1s-xl-1.jpg", "rider,helmet,xl"),
    ("uploads/variants/mu-agv-k1s-xl-2.jpg", "helmet,sport"),
    ("uploads/variants/mu-agv-k3sv-m-1.jpg",  "helmet,graphic,sport"),
    ("uploads/variants/mu-agv-k3sv-m-2.jpg",  "motogp,helmet"),
    ("uploads/variants/mu-agv-k3sv-l-1.jpg",  "racing,helmet,visor"),
    ("uploads/variants/mu-agv-k3sv-l-2.jpg",  "rider,gear,helmet"),
    ("uploads/variants/mu-agv-k3sv-xl-1.jpg", "helmet,large,sport"),
    ("uploads/variants/mu-agv-k3sv-xl-2.jpg", "fullface,helmet"),
    ("uploads/variants/mu-agv-pista-l-1.jpg",  "carbon,helmet,premium"),
    ("uploads/variants/mu-agv-pista-l-2.jpg",  "motogp,carbon,fiber"),
    ("uploads/variants/mu-agv-pista-xl-1.jpg", "premium,helmet,sport"),
    ("uploads/variants/mu-agv-pista-xl-2.jpg", "carbon,racing,helmet"),
    ("uploads/variants/acquy-yuasa-ytx7a-1.jpg",  "battery,7ah,motorcycle"),
    ("uploads/variants/acquy-yuasa-ytx7a-2.jpg",  "sealed,battery,12v"),
    ("uploads/variants/acquy-yuasa-yb9b-1.jpg",   "battery,9ah,wet"),
    ("uploads/variants/acquy-yuasa-yb9b-2.jpg",   "lead,acid,12v"),
    ("uploads/variants/acquy-yuasa-ytz10s-1.jpg", "agm,battery,sealed"),
    ("uploads/variants/acquy-yuasa-ytz10s-2.jpg", "battery,maintenance,free"),
    ("uploads/variants/pt-honda-nhong-wave-1.jpg",    "chain,sprocket,set"),
    ("uploads/variants/pt-honda-nhong-wave-2.jpg",    "motorcycle,chain,gear"),
    ("uploads/variants/pt-honda-bo-cbr150-1.jpg",     "brake,pad,disc"),
    ("uploads/variants/pt-honda-bo-cbr150-2.jpg",     "brake,disc,motorcycle"),
    ("uploads/variants/pt-yamaha-locgio-ex150-1.jpg", "air,filter,paper"),
    ("uploads/variants/pt-yamaha-locgio-ex150-2.jpg", "engine,filter,clean"),
    ("uploads/variants/pk-honda-guong-vario-den-1.jpg", "mirror,black,scooter"),
    ("uploads/variants/pk-honda-guong-vario-den-2.jpg", "side,mirror,black"),
    ("uploads/variants/pk-honda-guong-vario-bac-1.jpg", "mirror,silver,scooter"),
    ("uploads/variants/pk-honda-guong-vario-bac-2.jpg", "chrome,mirror"),
    ("uploads/variants/pk-yamaha-baotay-ex-den-1.jpg",  "grip,black,handlebar"),
    ("uploads/variants/pk-yamaha-baotay-ex-den-2.jpg",  "rubber,grip,black"),
    ("uploads/variants/pk-yamaha-baotay-ex-do-1.jpg",   "grip,red,motorcycle"),
    ("uploads/variants/pk-yamaha-baotay-ex-do-2.jpg",   "red,handle,grip"),
    ("uploads/variants/pk-yamaha-led-30w-trang-1.jpg",  "led,white,light"),
    ("uploads/variants/pk-yamaha-led-30w-trang-2.jpg",  "headlight,white,led"),
    ("uploads/variants/pk-yamaha-led-30w-vang-1.jpg",   "led,yellow,fog"),
    ("uploads/variants/pk-yamaha-led-30w-vang-2.jpg",   "yellow,light,auxiliary"),
]

# ----------------------------------------------------------------------------
# Hàm download
# ----------------------------------------------------------------------------

def make_loremflickr_url(keywords: str, w: int = 800, h: int = 600) -> str:
    """Tạo URL loremflickr - trả về ảnh Flickr CC theo từ khóa."""
    return f"https://loremflickr.com/{w}/{h}/{keywords}"

def make_picsum_fallback_url(seed: str, w: int = 800, h: int = 600) -> str:
    """Fallback - Picsum trả về ảnh ngẫu nhiên cố định theo seed."""
    return f"https://picsum.photos/seed/{seed}/{w}/{h}"

def download_one(local_path: str, url: str, retries: int = 2) -> bool:
    """Tải 1 ảnh, trả về True nếu thành công."""
    if os.path.exists(local_path) and os.path.getsize(local_path) > 1024:
        print(f"  ⏭  Đã có: {local_path}")
        return True

    os.makedirs(os.path.dirname(local_path), exist_ok=True)

    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(
                url,
                headers={"User-Agent": "Mozilla/5.0 MotoShop-Seeder/1.0"},
            )
            with urllib.request.urlopen(req, timeout=20) as resp:
                data = resp.read()
            if len(data) < 1024:
                raise ValueError(f"File quá nhỏ ({len(data)} bytes)")
            with open(local_path, "wb") as f:
                f.write(data)
            print(f"  ✓ {local_path}  ({len(data)//1024} KB)")
            return True
        except Exception as e:
            print(f"  ⚠  Lần {attempt+1} lỗi: {e}")
            time.sleep(1)

    print(f"  ✗ Bỏ qua: {local_path}")
    return False

def download_with_fallback(local_path: str, keywords: str) -> bool:
    """Thử loremflickr trước, nếu fail thì fallback Picsum."""
    primary = make_loremflickr_url(keywords)
    if download_one(local_path, primary):
        return True
    # Fallback
    seed = os.path.basename(local_path).rsplit(".", 1)[0]
    fallback = make_picsum_fallback_url(seed)
    print(f"  ↪  Fallback Picsum: {fallback}")
    return download_one(local_path, fallback)

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------

def main():
    # Tạo cấu trúc thư mục
    for sub in SUBDIRS:
        os.makedirs(os.path.join(BASE_DIR, sub), exist_ok=True)
    print(f"📁 Đã tạo cấu trúc thư mục trong: {os.path.abspath(BASE_DIR)}/\n")

    success = 0
    failed = 0

    # 1) Categories
    print("=" * 60)
    print("📂 [1/4] Tải ảnh DANH MỤC (6 ảnh)")
    print("=" * 60)
    for path, kws in CATEGORY_IMAGES:
        if download_with_fallback(path, kws):
            success += 1
        else:
            failed += 1
        time.sleep(0.3)

    # 2) Brands (logo) - dùng URL trực tiếp Clearbit
    print("\n" + "=" * 60)
    print("🏷  [2/4] Tải LOGO THƯƠNG HIỆU (6 logo)")
    print("=" * 60)
    for path, url in BRAND_LOGOS:
        if download_one(path, url):
            success += 1
        else:
            # Fallback: dùng loremflickr với từ khóa logo
            brand_name = os.path.basename(path).rsplit(".", 1)[0]
            print(f"  ↪  Fallback: tạo placeholder cho {brand_name}")
            if download_with_fallback(path, f"logo,{brand_name}"):
                success += 1
            else:
                failed += 1
        time.sleep(0.3)

    # 3) Products
    print("\n" + "=" * 60)
    print(f"📦 [3/4] Tải ảnh SẢN PHẨM ({len(PRODUCT_IMAGES)} ảnh)")
    print("=" * 60)
    for path, kws in PRODUCT_IMAGES:
        if download_with_fallback(path, kws):
            success += 1
        else:
            failed += 1
        time.sleep(0.3)

    # 4) Variants
    print("\n" + "=" * 60)
    print(f"🎨 [4/4] Tải ảnh BIẾN THỂ ({len(VARIANT_IMAGES)} ảnh)")
    print("=" * 60)
    for path, kws in VARIANT_IMAGES:
        if download_with_fallback(path, kws):
            success += 1
        else:
            failed += 1
        time.sleep(0.3)

    # Tổng kết
    total = success + failed
    print("\n" + "=" * 60)
    print(f"🏁 HOÀN TẤT: {success}/{total} ảnh tải thành công")
    if failed > 0:
        print(f"   ⚠  {failed} ảnh thất bại - bạn có thể chạy lại script để retry")
    print(f"📁 Vị trí: {os.path.abspath(BASE_DIR)}/")
    print("=" * 60)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n⛔ Đã dừng (Ctrl+C)")
        sys.exit(1)
