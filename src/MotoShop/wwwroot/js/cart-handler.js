/**
 * MOTO-SHOP CART & ORDER HANDLER
 */

const CartUI = {
    showToast(message, icon = 'success') {
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer)
                toast.addEventListener('mouseleave', Swal.resumeTimer)
            },
            showClass: {
                popup: 'animate__animated animate__fadeInRight animate__faster'
            },
            hideClass: {
                popup: 'animate__animated animate__fadeOutRight animate__faster'
            }
        });

        Toast.fire({
            icon: icon,
            title: `<span style="font-weight: 700; font-family: 'Public Sans', sans-serif;">${message}</span>`,
            background: '#fff',
            color: '#1a1a1a',
            iconColor: icon === 'success' ? '#dc3545' : '#ffc107', // Màu đỏ cho thành công (theo logo)
            customClass: {
                popup: 'rounded-4 shadow-lg border-0',
                timerProgressBar: 'bg-danger'
            }
        });
    }
};

const CartApi = {
    // Thêm vào giỏ hàng
    async addToCart(variantId, quantity = 1) {
        try {
            const formData = new FormData();
            formData.append('variantId', variantId);
            formData.append('quantity', quantity);

            const response = await fetch('/Cart/AddToCart', {
                method: 'POST',
                body: formData
            });

            return await response.json();
        } catch (error) {
            return { success: false, message: 'Không thể kết nối với máy chủ.' };
        }
    },

    async updateCartBadge() {
        if (typeof updateCartBadge === "function") {
            updateCartBadge();
        }
    }
};

/**
 * Xử lý khi nhấn "Thêm vào giỏ"
 */
async function handleAddToCart(variantId) {
    if (!variantId || variantId === 0) {
        CartUI.showToast('Vui lòng chọn đầy đủ các tùy chọn sản phẩm!', 'error');
        return;
    }

    const result = await CartApi.addToCart(variantId);
    
    if (result.success) {
        await CartApi.updateCartBadge();
        CartUI.showToast(result.message || 'Sản phẩm đã được thêm vào giỏ hàng.');
    } else {
        CartUI.showToast(result.message || 'Có lỗi xảy ra!', 'error');
        if (result.message && result.message.toLowerCase().includes('đăng nhập')) {
            setTimeout(() => {
                window.location.href = '/Account/Login?returnUrl=' + encodeURIComponent(window.location.pathname + window.location.search);
            }, 2000);
        }
    }
}

/**
 * Xử lý khi nhấn "Mua ngay"
 */
async function handleBuyNow(variantId) {
    if (!variantId || variantId === 0) {
        return;
    }

    const result = await CartApi.addToCart(variantId);
    
    if (result.success) {
        window.location.href = '/Cart/Checkout';
    } else {
        if (typeof Swal !== 'undefined') {
            Swal.fire('Thông báo', result.message || 'Có lỗi xảy ra!', 'info');
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    CartApi.updateCartBadge();
});
