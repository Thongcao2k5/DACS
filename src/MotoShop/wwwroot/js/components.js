/**
 * MOTO-SHOP COMPONENT SYSTEM
 * Lưu trữ các thành phần UI dùng chung và các tiện ích hiển thị
 */

window.UI = window.UI || {};
Object.assign(window.UI, {
    // Hiển thị thông báo Toast (Đã thống nhất)
    showToast(message, type = 'success') {
        const icons = {
            success: '✓',
            danger: '✗',
            warning: '⚠',
            info: 'ℹ'
        };
        const toast = document.createElement('div');
        toast.className = `toast-custom toast-${type}`;
        toast.innerHTML = `
            <span class="toast-icon">
                ${icons[type] || icons.info}
            </span>
            <span class="toast-message">
                ${message}
            </span>`;
        
        const container = document.getElementById('toastContainer');
        if (container) {
            container.appendChild(toast);
            setTimeout(() => toast.classList.add('show'), 10);
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 400);
            }, 3000);
        } else {
            // Fallback nếu không có container
            console.log(`Toast (${type}): ${message}`);
        }
    },

    initCheckoutPayment() {
        document.querySelectorAll('.payment-option').forEach(option => {
            option.addEventListener('click', function() {
                // Bỏ selected tất cả
                document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
                // Thêm selected vào cái được click
                this.classList.add('selected');
                // Check radio input bên trong
                const radio = this.querySelector('input[type="radio"]');
                if (radio) radio.checked = true;

                // Hiện/ẩn thông tin phụ
                const method = this.dataset.method;
                document.querySelectorAll('.payment-detail').forEach(d => d.style.display = 'none');
                const detail = document.getElementById(`detail-${method}`);
                if (detail) detail.style.display = 'block';
            });
        });
    },

    toggleSearch() {
        const overlay = document.getElementById('searchOverlay');
        if (overlay) {
            const isVisible = overlay.style.display !== 'none';
            overlay.style.display = isVisible ? 'none' : 'flex';
            if (!isVisible) {
                setTimeout(() => document.getElementById('searchOverlayInput')?.focus(), 100);
            }
        }
    }
});

const UI_COMPONENTS = {
    // 1. HEADER
    header: `
        <div class="top-header">
            <div class="container d-flex justify-content-between align-items-center">
                <div>
                    <span class="me-3"><i class='bx bx-phone'></i> 028 123 4567</span>
                    <span><i class='bx bx-envelope'></i> support@motoshop.vn</span>
                </div>
                <div class="fw-bold text-danger d-none d-md-block">🔥 Miễn phí vận chuyển cho đơn hàng từ 500k</div>
            </div>
        </div>
        <div class="container">
            <header class="main-header">
                <div class="header-logo">
                    <a href="/" class="text-decoration-none d-flex align-items-center">
                        <i class='bx bxs-bolt-circle text-danger fs-1'></i>
                        <span class="fs-3 fw-bolder text-dark ms-2">MOTO<span class="text-danger">SHOP</span></span>
                    </a>
                </div>
                <div class="header-search">
                    <form class="input-group" action="/Product">
                        <input type="text" name="searchTerm" class="form-control search-input" placeholder="Tìm tên phụ tùng, thương hiệu...">
                        <button class="btn search-btn" type="submit"><i class='bx bx-search'></i></button>
                    </form>
                </div>
                <div class="header-actions">
                    <div class="action-item">
                        <a href="/Account/Profile" class="text-dark d-flex align-items-center">
                            <i class='bx bx-user fs-4'></i>
                        </a>
                    </div>
                    <div class="action-item">
                        <a href="/Cart" class="text-dark position-relative">
                            <i class='bx bx-cart fs-4'></i>
                            <span class="badge rounded-pill bg-danger cart-badge-floating" id="cartBadge">0</span>
                        </a>
                    </div>
                </div>
            </header>
        </div>
    `,

    // 2. SEARCH OVERLAY
    searchOverlay: `
        <div class="text-end p-3 p-md-5" style="position:absolute; top:0; right:0;">
            <i class='bx bx-x fs-1 cursor-pointer' onclick="UI.toggleSearch()"></i>
        </div>
        <div class="text-center px-3" style="width: 100%; max-width: 800px;">
            <h2 class="fw-bold mb-4">TÌM KIẾM SẢN PHẨM</h2>
            <form action="/Product">
                <input type="text" name="searchTerm" class="form-control form-control-lg border-0 border-bottom rounded-0 shadow-none bg-transparent fs-2 text-center" id="searchOverlayInput" placeholder="Nhập tên phụ tùng...">
            </form>
        </div>
    `,

    // 3. MOBILE MENU
    mobileMenu: `
        <div class="offcanvas-header border-bottom">
            <h5 class="offcanvas-title fw-bold">MENU CHÍNH</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
        </div>
        <div class="offcanvas-body p-0 d-flex flex-column">
            <ul class="list-unstyled mb-0 text-start">
                <li class="border-bottom"><a href="/" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-home-alt me-2 fs-5'></i> TRANG CHỦ</a></li>
                <li class="border-bottom"><a href="/Product" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-category me-2 fs-5'></i> DANH MỤC</a></li>
                <li class="border-bottom"><a href="/Service" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-wrench me-2 fs-5'></i> DỊCH VỤ</a></li>
            </ul>
        </div>
    `,

    // 4. FOOTER
    footer: `
        <div class="container text-start">
            <div class="row g-4 py-5 text-white">
                <div class="col-lg-4 col-md-6">
                    <div class="footer-brand mb-4">
                        <a href="/" class="text-decoration-none d-flex align-items-center">
                            <i class='bx bxs-bolt-circle text-danger fs-1'></i>
                            <span class="fs-3 fw-bolder text-white ms-2">MOTO<span class="text-danger">SHOP</span></span>
                        </a>
                    </div>
                    <p class="footer-description mb-4 pe-lg-5 text-white-50">MOTO SHOP - Hệ thống bán lẻ phụ tùng xe máy chính hãng hàng đầu Việt Nam.</p>
                </div>
            </div>
        </div>
    `
};
