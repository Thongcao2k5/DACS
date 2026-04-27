/**
 * MOTO-SHOP CART & ORDER HANDLER
 */

const CartUI = {
    showToast(message, icon = 'success') {
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2500,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer)
                toast.addEventListener('mouseleave', Swal.resumeTimer)
            }
        });

        Toast.fire({
            icon: icon,
            title: message
        });
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
async function handleAddToCart(variantId) {
    if (!variantId || variantId === 0) {
        CartUI.showToast('Vui lòng chọn đầy đủ tùy chọn!', 'warning');
        return;
    }

    const btn = event?.currentTarget;
    if (btn) btn.disabled = true;

    const result = await CartApi.addToCart(variantId);
    
    if (btn) btn.disabled = false;

    if (result.success) {
        await CartApi.updateCartBadge();
        CartUI.showToast(result.message || 'Đã thêm vào giỏ hàng.');
    } else {
        CartUI.showToast(result.message || 'Có lỗi xảy ra!', 'error');
    }
}

/**
 * Xử lý khi nhấn "Mua ngay"
 */
async function handleBuyNow(variantId) {
    if (!variantId || variantId === 0) return;

    const result = await CartApi.addToCart(variantId);
    if (result.success) {
        window.location.href = '/Cart/Checkout';
    } else {
        CartUI.showToast(result.message, 'error');
    }
}

document.addEventListener('DOMContentLoaded', () => {
    CartApi.updateCartBadge();
});
