/**
 * MOTO-SHOP COMPONENT SYSTEM
 * Lưu trữ các thành phần UI dùng chung
 */

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
                    <a href="index.html" class="text-decoration-none d-flex align-items-center">
                        <i class='bx bxs-bolt-circle text-danger fs-1'></i>
                        <span class="fs-3 fw-bolder text-dark ms-2">MOTO<span class="text-danger">SHOP</span></span>
                    </a>
                </div>
                <div class="header-search">
                    <form class="input-group" action="search-results.html">
                        <input type="text" name="q" class="form-control search-input" placeholder="Tìm tên phụ tùng, thương hiệu...">
                        <button class="btn search-btn" type="submit"><i class='bx bx-search'></i></button>
                    </form>
                </div>
                <div class="nav-shrink-wrapper">
                    <ul class="nav-list justify-content-center">
                        <li><a href="index.html" class="nav-link-main">TRANG CHỦ</a></li>
                        <li class="mega-menu-wrapper">
                            <a href="products.html" class="nav-link-main">DANH MỤC <i class='bx bx-chevron-down'></i></a>
                            <div class="mega-menu">
                                <div class="container">
                                    <div class="row p-4 text-start">
                                        <div class="col-md-3">
                                            <h6 class="fw-bold text-danger mb-3">PHỤ TÙNG MÁY</h6>
                                            <ul class="list-unstyled">
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Bộ nồi (Côn)</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Lòng, piston, bạc</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Bình xăng con / Fi</a></li>
                                            </ul>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="fw-bold text-danger mb-3">DÀN CHÂN</h6>
                                            <ul class="list-unstyled">
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Phuộc trước / sau</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Mâm / Vành xe</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Hệ thống phanh</a></li>
                                            </ul>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="fw-bold text-danger mb-3">NHỚT & PHỤ GIA</h6>
                                            <ul class="list-unstyled">
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Nhớt máy Motul</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Nhớt máy Repsol</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Nước giải nhiệt</a></li>
                                            </ul>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="fw-bold text-danger mb-3">ĐỒ CHƠI XE</h6>
                                            <ul class="list-unstyled">
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Tay thắng kiểng</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Ốc Salaya / Titan</a></li>
                                                <li><a href="category-products.html" class="nav-link p-1 text-dark">Đèn trợ sáng</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li><a href="service.html" class="nav-link-main">DỊCH VỤ</a></li>
                        <li class="mega-menu-wrapper">
                            <a href="#" class="nav-link-main">THƯƠNG HIỆU <i class='bx bx-chevron-down'></i></a>
                            <div class="mega-menu">
                                <div class="container">
                                    <div class="row p-4 text-center">
                                        <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">HONDA</a></div>
                                        <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">YAMAHA</a></div>
                                        <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">SUZUKI</a></div>
                                        <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">PIAGGIO</a></div>
                                        <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">MOTUL</a></div>
                                        <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">RCB</a></div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="header-actions">
                    <div class="action-item shrink-search-toggle" onclick="UI.toggleSearch()">
                        <i class='bx bx-search'></i>
                    </div>
                    <div class="action-item">
                        <a href="profile.html" class="text-dark d-flex align-items-center">
                            <i class='bx bx-user'></i>
                        </a>
                        <div class="dropdown-menu-custom shadow-lg">
                            <div class="dropdown-header-custom">
                                <div class="d-flex align-items-center mb-2">
                                    <div class="avatar-circle me-2 bg-light-primary text-primary">
                                        <i class='bx bxs-user-circle fs-3'></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark small">Khách hàng</div>
                                        <div class="text-muted" style="font-size: 0.7rem;">Chào mừng bạn!</div>
                                    </div>
                                </div>
                            </div>
                            <ul class="list-unstyled mb-0">
                                <li>
                                    <a href="login.html" class="dropdown-item-custom">
                                        <i class='bx bx-log-in-circle me-2'></i> <span>Đăng nhập</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="register.html" class="dropdown-item-custom">
                                        <i class='bx bx-user-plus me-2'></i> <span>Đăng ký thành viên</span>
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider my-2"></li>
                                <li>
                                    <a href="profile.html" class="dropdown-item-custom">
                                        <i class='bx bx-user me-2'></i> <span>Hồ sơ cá nhân</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="orders.html" class="dropdown-item-custom">
                                        <i class='bx bx-package me-2'></i> <span>Đơn hàng của tôi</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="wishlist.html" class="dropdown-item-custom">
                                        <i class='bx bx-heart me-2'></i> <span>Sản phẩm yêu thích</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="action-item">
                        <a href="cart.html" class="text-dark"><i class='bx bx-cart'></i></a>
                        <span class="badge rounded-pill cart-badge">3</span>
                    </div>
                    <div class="action-item d-lg-none" data-bs-toggle="offcanvas" data-bs-target="#mobileMenu">
                        <i class='bx bx-menu'></i>
                    </div>
                </div>
            </header>
        </div>
        <nav class="nav-header d-none d-lg-block">
            <div class="container">
                <ul class="nav-list">
                    <li><a href="index.html" class="nav-link-main">TRANG CHỦ</a></li>
                    <li class="mega-menu-wrapper">
                        <a href="products.html" class="nav-link-main">DANH MỤC <i class='bx bx-chevron-down'></i></a>
                        <div class="mega-menu">
                            <div class="container">
                                <div class="row p-4 text-start">
                                    <div class="col-md-3">
                                        <h6 class="fw-bold text-danger mb-3">PHỤ TÙNG MÁY</h6>
                                        <ul class="list-unstyled">
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Bộ nồi (Côn)</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Lòng, piston, bạc</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Bình xăng con / Fi</a></li>
                                        </ul>
                                    </div>
                                    <div class="col-md-3">
                                        <h6 class="fw-bold text-danger mb-3">DÀN CHÂN</h6>
                                        <ul class="list-unstyled">
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Phuộc trước / sau</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Mâm / Vành xe</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Hệ thống phanh</a></li>
                                        </ul>
                                    </div>
                                    <div class="col-md-3">
                                        <h6 class="fw-bold text-danger mb-3">NHỚT & PHỤ GIA</h6>
                                        <ul class="list-unstyled">
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Nhớt máy Motul</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Nhớt máy Repsol</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Nước giải nhiệt</a></li>
                                        </ul>
                                    </div>
                                    <div class="col-md-3">
                                        <h6 class="fw-bold text-danger mb-3">ĐỒ CHƠI XE</h6>
                                        <ul class="list-unstyled">
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Tay thắng kiểng</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Ốc Salaya / Titan</a></li>
                                            <li><a href="category-products.html" class="nav-link p-1 text-dark">Đèn trợ sáng</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li><a href="service.html" class="nav-link-main">DỊCH VỤ</a></li>
                    <li class="mega-menu-wrapper">
                        <a href="#" class="nav-link-main">THƯƠNG HIỆU <i class='bx bx-chevron-down'></i></a>
                        <div class="mega-menu">
                            <div class="container">
                                <div class="row p-4 text-center">
                                    <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">HONDA</a></div>
                                    <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">YAMAHA</a></div>
                                    <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">SUZUKI</a></div>
                                    <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">PIAGGIO</a></div>
                                    <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">MOTUL</a></div>
                                    <div class="col-2"><a href="brand-products.html" class="d-block p-3 border rounded text-dark text-decoration-none fw-bold">RCB</a></div>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li><a href="promotion.html" class="nav-link-main text-danger">KHUYẾN MÃI HOT</a></li>
                    <li><a href="blog.html" class="nav-link-main">TIN TỨC</a></li>
                    <li><a href="contact.html" class="nav-link-main">LIÊN HỆ</a></li>
                </ul>
            </div>
        </nav>
    `,

    // 2. SEARCH OVERLAY
    searchOverlay: `
        <div class="text-end p-3 p-md-5" style="position:absolute; top:0; right:0;">
            <i class='bx bx-x fs-1 cursor-pointer' onclick="UI.toggleSearch()"></i>
        </div>
        <div class="text-center px-3" style="width: 100%; max-width: 800px;">
            <h2 class="fw-bold mb-4">TÌM KIẾM SẢN PHẨM</h2>
            <form action="search-results.html">
                <input type="text" name="q" class="form-control form-control-lg border-0 border-bottom rounded-0 shadow-none bg-transparent fs-2 text-center" id="searchOverlayInput" placeholder="Nhập tên phụ tùng...">
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
            <div class="p-3 bg-light border-bottom">
                <div class="d-flex align-items-center">
                    <div class="avatar-circle bg-white text-primary me-2">
                        <i class='bx bxs-user-circle fs-2'></i>
                    </div>
                    <div>
                        <div class="fw-bold text-dark">Khách hàng</div>
                        <div class="small"><a href="login.html" class="text-danger text-decoration-none">Đăng nhập</a> / <a href="register.html" class="text-dark text-decoration-none">Đăng ký</a></div>
                    </div>
                </div>
            </div>
            <ul class="list-unstyled mb-0 text-start">
                <li class="border-bottom"><a href="index.html" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-home-alt me-2 fs-5'></i> TRANG CHỦ</a></li>
                <li class="border-bottom"><a href="products.html" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-category me-2 fs-5'></i> DANH MỤC</a></li>
                <li class="border-bottom"><a href="service.html" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-wrench me-2 fs-5'></i> DỊCH VỤ</a></li>
                <li class="border-bottom"><a href="brand-products.html" class="nav-link p-3 fw-bold d-flex align-items-center"><i class='bx bx-award me-2 fs-5'></i> THƯƠNG HIỆU</a></li>
                <li class="border-bottom"><a href="promotion.html" class="nav-link p-3 fw-bold text-danger d-flex align-items-center"><i class='bx bxs-hot me-2 fs-5'></i> KHUYẾN MÃI HOT</a></li>
                
                <li class="bg-light p-2 px-3 small fw-bold text-muted text-uppercase">Tài khoản của tôi</li>
                <li class="border-bottom"><a href="profile.html" class="nav-link p-3 d-flex align-items-center"><i class='bx bx-user me-2 fs-5'></i> Hồ sơ cá nhân</a></li>
                <li class="border-bottom"><a href="orders.html" class="nav-link p-3 d-flex align-items-center"><i class='bx bx-package me-2 fs-5'></i> Đơn hàng của tôi</a></li>
                <li class="border-bottom"><a href="wishlist.html" class="nav-link p-3 d-flex align-items-center"><i class='bx bx-heart me-2 fs-5'></i> Sản phẩm yêu thích</a></li>
            </ul>
            <div class="p-4 bg-light mt-auto">
                <p class="small text-muted mb-3 fw-bold text-uppercase">Hỗ trợ khách hàng</p>
                <div class="mb-2">
                    <a href="tel:0281234567" class="text-decoration-none text-dark d-flex align-items-center">
                        <i class='bx bx-phone-call me-2 text-danger fs-4'></i> 
                        <div>
                            <div class="small text-muted">Hotline 24/7</div>
                            <div class="fw-bold">028 123 4567</div>
                        </div>
                    </a>
                </div>
                <div>
                    <a href="mailto:support@motoshop.vn" class="text-decoration-none text-dark d-flex align-items-center">
                        <i class='bx bx-envelope me-2 text-danger fs-4'></i>
                        <div>
                            <div class="small text-muted">Email hỗ trợ</div>
                            <div class="fw-bold">support@motoshop.vn</div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    `,

    // 4. FOOTER
    footer: `
        <div class="container text-start">
            <div class="row g-4 py-5">
                <div class="col-lg-4 col-md-6">
                    <div class="footer-brand mb-4">
                        <a href="index.html" class="text-decoration-none d-flex align-items-center">
                            <i class='bx bxs-bolt-circle text-danger fs-1'></i>
                            <span class="fs-3 fw-bolder text-white ms-2">MOTO<span class="text-danger">SHOP</span></span>
                        </a>
                    </div>
                    <p class="footer-description mb-4 pe-lg-5">MOTO SHOP - Hệ thống bán lẻ phụ tùng xe máy chính hãng hàng đầu Việt Nam. Chúng tôi cam kết mang đến chất lượng và sự an tâm tuyệt đối cho xế yêu của bạn.</p>
                    <div class="social-links d-flex gap-3">
                        <a href="#" class="social-icon"><i class='bx bxl-facebook'></i></a>
                        <a href="#" class="social-icon"><i class='bx bxl-youtube'></i></a>
                        <a href="#" class="social-icon"><i class='bx bxl-tiktok'></i></a>
                        <a href="#" class="social-icon"><i class='bx bxl-instagram'></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5 class="fw-bold text-white mb-4">LIÊN KẾT NHANH</h5>
                    <ul class="list-unstyled footer-links">
                        <li><a href="index.html">Trang chủ</a></li>
                        <li><a href="service.html">Dịch vụ bảo dưỡng</a></li>
                        <li><a href="promotion.html">Khuyến mãi mới nhất</a></li>
                        <li><a href="branches.html">Hệ thống chi nhánh</a></li>
                        <li><a href="about-us.html">Về chúng tôi</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="fw-bold text-white mb-4">CHÍNH SÁCH</h5>
                    <ul class="list-unstyled footer-links">
                        <li><a href="warranty-policy.html">Chính sách bảo hành</a></li>
                        <li><a href="return-policy.html">Chính sách đổi trả</a></li>
                        <li><a href="shipping-policy.html">Vận chuyển & Giao nhận</a></li>
                        <li><a href="terms-of-service.html">Điều khoản sử dụng</a></li>
                        <li><a href="privacy-policy.html">Bảo mật thông tin</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="fw-bold text-white mb-4">THÔNG TIN LIÊN HỆ</h5>
                    <ul class="list-unstyled footer-contact">
                        <li class="d-flex mb-3">
                            <i class='bx bx-map text-danger fs-4 me-3'></i>
                            <span>123 Đường ABC, Quận 1, TP. Hồ Chí Minh</span>
                        </li>
                        <li class="d-flex mb-3">
                            <i class='bx bx-phone-call text-danger fs-4 me-3'></i>
                            <div>
                                <div class="fw-bold text-white">028 123 4567</div>
                                <div class="small text-muted">Thứ 2 - Chủ Nhật (8h00 - 21h00)</div>
                            </div>
                        </li>
                        <li class="d-flex mb-3">
                            <i class='bx bx-envelope text-danger fs-4 me-3'></i>
                            <span>support@motoshop.vn</span>
                        </li>
                    </ul>
                </div>
            </div>
            <hr class="border-secondary my-0">
            <div class="py-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                <p class="mb-0 small text-center text-md-start opacity-75 text-white">© 2026 MOTO SHOP. Tất cả quyền được bảo lưu. Phát triển bởi <span class="text-white fw-bold">IDT Group</span></p>
                <div class="payment-methods opacity-50 d-flex gap-3 fs-3 text-white">
                    <i class='bx bxl-visa'></i>
                    <i class='bx bxl-mastercard'></i>
                    <i class='bx bx-credit-card'></i>
                    <i class='bx bx-qr-scan'></i>
                </div>
            </div>
        </div>
    `
};

/**
 * Hàm nạp các component vào trang
 */
function loadLayoutComponents() {
    const headerPlaceholder = document.getElementById('mainHeaderWrapper');
    const searchPlaceholder = document.getElementById('searchOverlay');
    const mobileMenuPlaceholder = document.getElementById('mobileMenu');
    const footerPlaceholder = document.querySelector('footer');

    if (headerPlaceholder) headerPlaceholder.innerHTML = UI_COMPONENTS.header;
    if (searchPlaceholder) searchPlaceholder.innerHTML = UI_COMPONENTS.searchOverlay;
    if (mobileMenuPlaceholder) mobileMenuPlaceholder.innerHTML = UI_COMPONENTS.mobileMenu;
    if (footerPlaceholder) footerPlaceholder.innerHTML = UI_COMPONENTS.footer;
}

// Gọi nạp ngay khi script được tải
loadLayoutComponents();
