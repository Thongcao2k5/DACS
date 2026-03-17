
import http.server
import socketserver
import webbrowser
import os

PORT = 8000

def run_server():
    print("="*60)
    print("MOTO-SHOP - KHỞI CHẠY GIAO DIỆN (FRONTEND & ADMIN)")
    print("="*60)
    print("1. Xem Giao diện Khách hàng (User)")
    print("2. Xem Giao diện Quản trị (Admin)")
    print("="*60)
    
    choice = input("Nhập lựa chọn của bạn (1 hoặc 2): ")
    
    # Khởi tạo server tại thư mục gốc để tất cả đường dẫn ../assets/ đều hoạt động đúng
    handler = http.server.SimpleHTTPRequestHandler
    
    with socketserver.TCPServer(("", PORT), handler) as httpd:
        url = f"http://localhost:{PORT}"
        
        if choice == "1":
            target_url = f"{url}/frontend/index.html"
            print("\n[*] Đang mở Giao diện Khách hàng...")
        elif choice == "2":
            target_url = f"{url}/html/dashboard.html"
            print("\n[*] Đang mở Giao diện Quản trị...")
        else:
            target_url = url
            print("\n[*] Đang mở thư mục gốc...")

        print(f"\n[SUCCESS] Server đang chạy tại: {url}")
        print(f"[INFO] Trang web của bạn: {target_url}")
        print("[INFO] Nhấn Ctrl+C trong Terminal này để dừng server.")
        
        # Mở trình duyệt với đường dẫn chính xác
        webbrowser.open(target_url)
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n[STOP] Đã dừng server.")
            httpd.server_close()

if __name__ == "__main__":
    run_server()
