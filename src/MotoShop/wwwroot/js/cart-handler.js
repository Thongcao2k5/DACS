/**
 * MOTO-SHOP CART & ORDER HANDLER
 */

const CartUI = {
    showToast(message, icon = 'success') {
        const container = document.getElementById('toastContainer');
        if (!container) return;

        const colorMap = { success: '#22c55e', error: '#ef4444', warning: '#f59e0b', info: '#3b82f6' };
        const iconMap  = { success: 'bx-check-circle', error: 'bx-error-circle', warning: 'bx-error', info: 'bx-info-circle' };
        const bg       = colorMap[icon] || colorMap.success;
        const ic       = iconMap[icon]  || iconMap.success;

        const el = document.createElement('div');
        el.style.cssText = `background:${bg};color:#fff;border-radius:12px;padding:12px 16px;display:flex;align-items:center;gap:10px;min-width:260px;max-width:340px;box-shadow:0 8px 24px rgba(0,0,0,0.18);animation:fadeInRight .35s ease forwards;font-size:14px;font-weight:600;pointer-events:auto;`;
        el.innerHTML = `<i class="bx ${ic}" style="font-size:20px;flex-shrink:0"></i><span style="flex:1">${message}</span><button onclick="this.parentElement.remove()" style="background:none;border:none;color:#fff;cursor:pointer;padding:0;line-height:1;opacity:.7;font-size:18px">&times;</button>`;
        container.appendChild(el);

        setTimeout(() => {
            el.style.transition = 'opacity .3s';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 300);
        }, 3000);
    }
};

const CartApi = {
    // Helper để đảm bảo URL luôn đúng
    getBaseUrl(path) {
        const base = window.location.origin;
        return path.startsWith('/') ? base + path : base + '/' + path;
    },

    // Thêm vào giỏ hàng
    async addToCart(variantId, quantity = 1) {
        const url = this.getBaseUrl('/Cart/AddToCart');
        const formData = new FormData();
        formData.append('variantId', variantId);
        formData.append('quantity', quantity);

        // Token sẽ tự động được thêm bởi Interceptor trong _Layout.cshtml
        
        try {
            const response = await fetch(url, {
                method: 'POST',
                body: formData
                // Headers (X-XSRF-TOKEN) được Interceptor tự động thêm
            });

            if (response.status === 400) {
                return { success: false, message: 'Lỗi xác thực bảo mật. Vui lòng F5 trang.' };
            }
            if (!response.ok) {
                return { success: false, message: 'Lỗi máy chủ: ' + response.status };
            }

            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            return { success: false, message: 'Không thể kết nối đến máy chủ.' };
        }
    },

    async updateCartBadge() {
        const url = this.getBaseUrl('/Cart/GetCartCount');
        try {
            const res = await fetch(url);
            const count = await res.json();
            const badge = document.getElementById('cartBadge');
            if (badge) {
                badge.textContent = count;
                badge.style.display = count > 0 ? 'block' : 'none';
            }
        } catch (e) { }
    }
};

/**
 * Xử lý khi nhấn "Thêm vào giỏ"
 */
async function handleAddToCart(variantId, quantity = 1) {
    if (!variantId || variantId === 0) {
        CartUI.showToast('Vui lòng chọn đầy đủ thuộc tính sản phẩm!', 'warning');
        return;
    }

    const btn = window.event?.currentTarget;
    const originalContent = btn ? btn.innerHTML : null;
    
    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<i class="bx bx-loader-alt bx-spin"></i>';
    }

    const result = await CartApi.addToCart(variantId, quantity);
    
    if (btn) {
        btn.disabled = false;
        btn.innerHTML = originalContent;
    }

    if (result.success) {
        await CartApi.updateCartBadge();
        CartUI.showToast(result.message || 'Đã thêm vào giỏ hàng thành công!');
    } else {
        if (result.message && result.message.toLowerCase().includes('đăng nhập')) {
            Swal.fire({
                title: 'Yêu cầu đăng nhập',
                text: result.message,
                icon: 'info',
                showCancelButton: true,
                confirmButtonText: 'Đăng nhập ngay',
                cancelButtonText: 'Để sau',
                confirmButtonColor: '#E24B4A'
            }).then((rs) => {
                if (rs.isConfirmed) window.location.href = '/Account/Login?returnUrl=' + encodeURIComponent(window.location.pathname + window.location.search);
            });
        } else {
            CartUI.showToast(result.message || 'Không thể thêm sản phẩm vào giỏ.', 'error');
        }
    }
}

/**
 * Xử lý khi nhấn "Mua ngay"
 */
async function handleBuyNow(variantId, quantity = 1) {
    if (!variantId || variantId === 0) {
        CartUI.showToast('Vui lòng chọn đầy đủ thuộc tính sản phẩm!', 'warning');
        return;
    }

    // Với "Mua ngay", ta chuyển thẳng đến trang Checkout kèm thông tin variant
    window.location.href = `/Cart/Checkout?variantId=${variantId}&quantity=${quantity}`;
}

document.addEventListener('DOMContentLoaded', () => {
    CartApi.updateCartBadge();
});
