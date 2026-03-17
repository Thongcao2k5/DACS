const sidebarHTML = `
  <aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
    <div class="app-brand demo">
      <a href="dashboard.html" class="app-brand-link">
        <span class="app-brand-logo demo">
          <i class='bx bxs-bolt-circle text-primary' style="font-size: 2rem;"></i>
        </span>
        <span class="app-brand-text demo menu-text fw-bolder ms-2">MOTOSHOP</span>
      </a>

      <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto d-block d-xl-none">
        <i class="bx bx-chevron-left bx-sm align-middle"></i>
      </a>
    </div>

    <div class="menu-inner-shadow"></div>

    <ul class="menu-inner py-1">
      <!-- Dashboard -->
      <li class="menu-item">
        <a href="dashboard.html" class="menu-link">
          <i class="menu-icon tf-icons bx bx-home-circle"></i>
          <div>Tổng quan</div>
        </a>
      </li>

      <!-- Sản phẩm -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-box"></i>
          <div>Sản phẩm</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="products.html" class="menu-link"><div>Danh sách sản phẩm</div></a></li>
          <li class="menu-item"><a href="categories.html" class="menu-link"><div>Loại sản phẩm</div></a></li>
          <li class="menu-item"><a href="brands.html" class="menu-link"><div>Thương hiệu</div></a></li>
          <li class="menu-item"><a href="attributes.html" class="menu-link"><div>Thuộc tính</div></a></li>
          <li class="menu-item"><a href="units.html" class="menu-link"><div>Đơn vị tính</div></a></li>
        </ul>
      </li>

      <!-- Kho hàng -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-store"></i>
          <div>Kho hàng</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="inventory.html" class="menu-link"><div>Tồn kho hiện tại</div></a></li>
          <li class="menu-item"><a href="inventory-history.html" class="menu-link"><div>Lịch sử nhập xuất</div></a></li>
        </ul>
      </li>

      <!-- Bán hàng -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-cart"></i>
          <div>Bán hàng</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="orders.html" class="menu-link"><div>Đơn hàng</div></a></li>
          <li class="menu-item"><a href="promotions.html" class="menu-link"><div>Khuyến mãi</div></a></li>
        </ul>
      </li>

      <!-- Dịch vụ kỹ thuật -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-wrench"></i>
          <div>Dịch vụ</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="bookings.html" class="menu-link"><div>Lịch đặt dịch vụ</div></a></li>
          <li class="menu-item"><a href="services.html" class="menu-link"><div>Danh mục dịch vụ</div></a></li>
        </ul>
      </li>

      <!-- Khách hàng -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-user"></i>
          <div>Khách hàng</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="customers.html" class="menu-link"><div>Danh sách khách hàng</div></a></li>
          <li class="menu-item"><a href="wishlists.html" class="menu-link"><div>Sản phẩm yêu thích</div></a></li>
          <li class="menu-item"><a href="reviews.html" class="menu-link"><div>Đánh giá & Phản hồi</div></a></li>
        </ul>
      </li>

      <li class="menu-header small text-uppercase">
        <span class="menu-header-text">Giao diện & Nội dung</span>
      </li>

      <!-- Nội dung Blog -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-news"></i>
          <div>Bài viết Blog</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="blogs.html" class="menu-link"><div>Tất cả bài viết</div></a></li>
          <li class="menu-item"><a href="blog-categories.html" class="menu-link"><div>Chuyên mục Blog</div></a></li>
        </ul>
      </li>

      <!-- Banner & Sliders -->
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link menu-toggle">
          <i class="menu-icon tf-icons bx bx-image"></i>
          <div>Banner & Quảng cáo</div>
        </a>
        <ul class="menu-sub">
          <li class="menu-item"><a href="sliders.html" class="menu-link"><div>Trình chiếu (Sliders)</div></a></li>
          <li class="menu-item"><a href="banners.html" class="menu-link"><div>Banner tĩnh</div></a></li>
        </ul>
      </li>

      <li class="menu-header small text-uppercase">
        <span class="menu-header-text">Hệ thống</span>
      </li>
      <li class="menu-item"><a href="accounts.html" class="menu-link"><i class="menu-icon tf-icons bx bx-lock-open-alt"></i><div>Tài khoản Admin</div></a></li>
      <li class="menu-item"><a href="roles.html" class="menu-link"><i class="menu-icon tf-icons bx bx-shield-quarter"></i><div>Phân quyền</div></a></li>
      <li class="menu-item"><a href="settings.html" class="menu-link"><i class="menu-icon tf-icons bx bx-cog"></i><div>Cấu hình hệ thống</div></a></li>
    </ul>
  </aside>
`;

document.write(sidebarHTML);

// Auto-active menu based on current page
document.addEventListener("DOMContentLoaded", function() {
  const currentPath = window.location.pathname.split("/").pop();
  const menuLinks = document.querySelectorAll(".menu-link");
  
  menuLinks.forEach(link => {
    const href = link.getAttribute("href");
    if (href === currentPath) {
      const menuItem = link.closest(".menu-item");
      if (menuItem) {
        menuItem.classList.add("active");
        
        // Open parent sub-menu if it exists
        const parentSub = menuItem.closest(".menu-sub");
        if (parentSub) {
          const parentMenuItem = parentSub.closest(".menu-item");
          if (parentMenuItem) {
            parentMenuItem.classList.add("active", "open");
          }
        }
      }
    }
  });
});
