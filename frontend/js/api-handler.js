/**
 * MOTO-SHOP CORE API HANDLER
 * Kết nối dữ liệu thực từ Backend .NET
 */

const API_CONFIG = {
    BASE_URL: window.location.protocol === 'https:' ? 'https://localhost:7106' : 'http://localhost:5201',
    TIMEOUT: 5000
};

const MotoApi = {
    async fetchJson(endpoint, options = {}) {
        try {
            // Thêm credentials: 'include' để gửi kèm Cookie (quan trọng cho Giỏ hàng/Đăng nhập)
            const response = await fetch(`${API_CONFIG.BASE_URL}${endpoint}`, {
                ...options,
                credentials: 'include' 
            });
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return await response.json();
        } catch (e) {
            console.error(`[API Error] ${endpoint}:`, e);
            return null;
        }
    },
    getFeaturedProducts: () => MotoApi.fetchJson('/api/homeapi/featured'),
    getCategories: () => MotoApi.fetchJson('/api/homeapi/categories'),
    getPromotions: () => MotoApi.fetchJson('/api/homeapi/promotions'),
    getCartCount: () => MotoApi.fetchJson('/api/homeapi/cart-count'), // Tôi sẽ tạo API này
    
    async addToCart(variantId, quantity = 1) {
        try {
            const formData = new FormData();
            formData.append('variantId', variantId);
            formData.append('quantity', quantity);
            
            const response = await fetch(`${API_CONFIG.BASE_URL}/Cart/AddToCart`, { 
                method: 'POST', 
                body: formData,
                credentials: 'include'
            });
            return await response.json();
        } catch (e) { 
            return { success: false, message: 'Không thể kết nối Backend. Hãy chạy dự án .NET (F5).' }; 
        }
    }
};

const UI = {
    renderProductCard(p, badgeClass = 'badge-new', badgeText = 'New') {
        const price = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.minPrice);
        const img = p.primaryImageUrl ? (p.primaryImageUrl.startsWith('http') ? p.primaryImageUrl : `${API_CONFIG.BASE_URL}${p.primaryImageUrl}`) : 'https://via.placeholder.com/400';
        
        return `
            <div class="col">
                <div class="product-card h-100">
                    <span class="product-badge ${badgeClass}">${badgeText}</span>
                    <div class="product-img-wrapper" onclick="location.href='${API_CONFIG.BASE_URL}/Product/Details?slug=${p.slug}'">
                        <img src="${img}" alt="${p.productName}" onerror="this.src='https://via.placeholder.com/400'">
                    </div>
                    <div class="product-info">
                        <span class="brand">${p.brandName || 'MotoShop'}</span>
                        <h6 class="name">${p.productName}</h6>
                        <div class="product-price">
                            <span class="current">${price}</span>
                        </div>
                    </div>
                    <button class="btn btn-add-cart rounded-pill fw-bold mt-3 w-100" onclick="handleAddToCart(${p.defaultVariantId})">
                        <i class='bx bx-cart-add fs-4'></i> <span>THÊM GIỎ</span>
                    </button>
                </div>
            </div>`;
    },

    updateCartBadge(count) {
        const badge = document.querySelector('.cart-badge');
        if (badge) {
            badge.innerText = count || 0;
            badge.style.display = count > 0 ? 'flex' : 'none';
        }
    }
};

async function handleAddToCart(id) {
    if (!id) return alert("Sản phẩm lỗi!");
    const res = await MotoApi.addToCart(id);
    
    if (res.success) {
        // Cập nhật số lượng trên icon giỏ hàng ngay lập tức
        const cartData = await MotoApi.getCartCount();
        UI.updateCartBadge(cartData ? cartData.count : 0);
        alert(res.message);
    } else {
        alert(res.message);
        if (res.message.toLowerCase().includes('đăng nhập')) {
            window.location.href = `${API_CONFIG.BASE_URL}/Account/Login`;
        }
    }
}

// KHỞI TẠO TRANG
document.addEventListener('DOMContentLoaded', async () => {
    const isHome = window.location.pathname.includes('index.html') || window.location.pathname.endsWith('/');
    const isPromo = window.location.pathname.includes('promotion.html');

    // 1. Cập nhật số lượng giỏ hàng trên Header
    const cartData = await MotoApi.getCartCount();
    UI.updateCartBadge(cartData ? cartData.count : 0);

    // 2. Sửa link icon Giỏ hàng trên Header để dẫn về Backend
    const cartLink = document.querySelector('a[href="cart.html"]');
    if (cartLink) cartLink.href = `${API_CONFIG.BASE_URL}/Cart`;

    // 3. Sửa link icon Tài khoản trên Header
    const userLink = document.querySelector('a[href="profile.html"]');
    if (userLink) userLink.href = `${API_CONFIG.BASE_URL}/Account/Profile`;

    if (isHome) {
        // Nạp sản phẩm nổi bật
        const featuredDiv = document.getElementById('featuredProducts');
        if (featuredDiv) {
            const products = await MotoApi.getFeaturedProducts();
            if (products && products.length > 0) {
                featuredDiv.innerHTML = products.map(p => UI.renderProductCard(p, 'badge-featured', 'Nổi bật')).join('');
            }
        }

        // Nạp danh mục
        const catDiv = document.querySelector('.cat-quick-access-row');
        if (catDiv) {
            const cats = await MotoApi.getCategories();
            if (cats && cats.length > 0) {
                catDiv.innerHTML = cats.map(c => `
                    <div class="col">
                        <a href="${API_CONFIG.BASE_URL}/Product?categoryId=${c.categoryId}" class="cat-quick-card">
                            <div class="cat-img-circle"><i class='bx bxs-component fs-1 text-danger'></i></div>
                            <span class="fw-bold">${c.categoryName}</span>
                            <small class="text-muted d-block">(${c.productCount} SP)</small>
                        </a>
                    </div>`).join('') + `
                    <div class="col">
                        <a href="${API_CONFIG.BASE_URL}/Product" class="cat-quick-card">
                            <div class="cat-img-circle"><i class='bx bxs-grid fs-1 text-danger'></i></div>
                            <span class="fw-bold">Tất cả</span>
                        </a>
                    </div>`;
            }
        }
    }
});
