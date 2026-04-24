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
    getFeaturedProducts: () => MotoApi.fetchJson('/api/HomeApi/featured'),
    getCategories: () => MotoApi.fetchJson('/api/HomeApi/categories'),
    getPromotions: () => MotoApi.fetchJson('/api/HomeApi/promotions'),
    getCartCount: () => MotoApi.fetchJson('/api/HomeApi/cart-count'),
    validateCoupon: (code) => MotoApi.fetchJson(`/api/HomeApi/validate-coupon?code=${code}`),
    
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
            console.error(`[API Error] addToCart:`, e);
            return { success: false, message: 'Lỗi kết nối máy chủ' };
        }
    }
};

const UI = {
    showToast(message, type = 'success') {
        if (typeof Swal === 'undefined') {
            alert(message);
            return;
        }
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.onmouseenter = Swal.stopTimer;
                toast.onmouseleave = Swal.resumeTimer;
            },
            showClass: {
                popup: 'animate__animated animate__fadeInRight animate__faster'
            },
            hideClass: {
                popup: 'animate__animated animate__fadeOutRight animate__faster'
            }
        });

        Toast.fire({
            icon: type,
            title: `<span style="font-weight: 700; font-family: 'Public Sans', sans-serif;">${message}</span>`,
            background: '#fff',
            color: '#1a1a1a',
            iconColor: type === 'success' ? '#dc3545' : '#ffc107',
            customClass: {
                popup: 'rounded-4 shadow-lg border-0',
                timerProgressBar: 'bg-danger'
            }
        });
    },

    renderProductCard(p, badgeClass = 'badge-new', badgeText = 'New') {
        const hasPromotion = p.discountPercent > 0 || p.oldPrice > p.minPrice;
        const currentPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.minPrice);
        const oldPrice = hasPromotion ? new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.oldPrice || p.minPrice * 1.2) : '';
        const img = p.primaryImageUrl ? (p.primaryImageUrl.startsWith('http') ? p.primaryImageUrl : `${API_CONFIG.BASE_URL}${p.primaryImageUrl}`) : 'https://via.placeholder.com/400';
        
        const badgeHtml = hasPromotion 
            ? `<span class="product-badge badge-promo">-${p.discountPercent || 15}%</span>`
            : `<span class="product-badge ${badgeClass}">${badgeText}</span>`;

        return `
            <div class="col">
                <div class="product-card h-100 shadow-sm border-0">
                    ${badgeHtml}
                    <div class="product-img-wrapper" onclick="location.href='${API_CONFIG.BASE_URL}/Product/Details?slug=${p.slug}'">
                        <img src="${img}" alt="${p.productName}" onerror="this.src='https://via.placeholder.com/400'">
                    </div>
                    <div class="product-info p-3">
                        <span class="brand text-uppercase small text-muted">${p.brandName || 'MotoShop'}</span>
                        <h6 class="name fw-bold mb-2 text-truncate">${p.productName}</h6>
                        <div class="product-price d-flex align-items-center gap-2">
                            <span class="current text-danger fw-bold fs-5">${currentPrice}</span>
                            ${hasPromotion ? `<span class="old text-muted text-decoration-line-through small">${oldPrice}</span>` : ''}
                        </div>
                    </div>
                    <div class="p-3 pt-0">
                        <button class="btn btn-danger rounded-pill fw-bold w-100 btn-sm py-2" onclick="handleAddToCart(${p.defaultVariantId || 0})">
                            <i class='bx bx-cart-add fs-5 me-1'></i> THÊM GIỎ
                        </button>
                    </div>
                </div>
            </div>`;
    },

    renderSkeleton(count = 8) {
        return Array(count).fill(0).map(() => `
            <div class="col">
                <div class="product-card h-100 border-0 shadow-none bg-light opacity-50" style="min-height: 350px;">
                    <div class="product-img-wrapper bg-secondary bg-opacity-10" style="height: 200px;"></div>
                    <div class="p-3">
                        <div class="bg-secondary bg-opacity-25 mb-2" style="height: 10px; width: 40%;"></div>
                        <div class="bg-secondary bg-opacity-25 mb-3" style="height: 20px; width: 90%;"></div>
                        <div class="bg-secondary bg-opacity-25" style="height: 25px; width: 60%;"></div>
                    </div>
                </div>
            </div>`).join('');
    },

    updateCartBadge(count) {
        const badges = document.querySelectorAll('.cart-badge');
        badges.forEach(badge => {
            badge.textContent = count;
            badge.style.display = count > 0 ? 'block' : 'none';
        });
    }
};

/**
 * XỬ LÝ SỰ KIỆN TOÀN CỤC
 */
async function handleAddToCart(variantId) {
    if (!variantId || variantId === 0) {
        UI.showToast('Sản phẩm này hiện chưa có biến thể để đặt hàng.', 'error');
        return;
    }

    const result = await MotoApi.addToCart(variantId);
    
    if (result && result.success) {
        UI.showToast(result.message || 'Đã thêm vào giỏ hàng thành công!');
        const cartData = await MotoApi.getCartCount();
        if (cartData) {
            UI.updateCartBadge(cartData.count);
        }
    } else {
        UI.showToast(result?.message || 'Có lỗi xảy ra khi thêm vào giỏ hàng!', 'error');
    }
}

async function handleBuyNow(variantId) {
    if (!variantId || variantId === 0) return;
    const result = await MotoApi.addToCart(variantId);
    if (result && result.success) {
        window.location.href = 'cart.html';
    } else {
        UI.showToast(result?.message || 'Có lỗi xảy ra!', 'error');
    }
}
