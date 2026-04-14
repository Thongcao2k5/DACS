/**
 * MOTO-SHOP CART & ORDER HANDLER
 * Xử lý thêm vào giỏ hàng và mua ngay cho toàn hệ thống
 */

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

            const result = await response.json();
            return result;
        } catch (error) {
            console.error('Lỗi thêm vào giỏ hàng:', error);
            return { success: false, message: 'Không thể kết nối với máy chủ.' };
        }
    },

    // Cập nhật số lượng trên icon giỏ hàng
    async updateCartBadge() {
        if (typeof updateCartBadge === "function") {
            updateCartBadge(); // Gọi hàm từ _Header.cshtml
        }
    }
};

/**
 * Xử lý khi nhấn "Thêm vào giỏ"
 */
async function handleAddToCart(variantId) {
    if (!variantId || variantId === 0) {
        if (typeof Swal !== 'undefined') {
            Swal.fire('Chú ý', 'Sản phẩm này hiện chưa có biến thể để đặt hàng.', 'warning');
        }
        return;
    }

    const result = await CartApi.addToCart(variantId);
    
    if (result.success) {
        // 1. Cập nhật con số giỏ hàng
        await CartApi.updateCartBadge();
        
        // 2. Hiển thị thông báo (Ưu tiên Header Toast để giống trang Danh mục)
        if (typeof showCartSuccessToast === "function") {
            showCartSuccessToast(result.message || 'Đã thêm vào giỏ hàng thành công');
        } else if (typeof Swal !== 'undefined') {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: result.message,
                showConfirmButton: false,
                timer: 1500,
                toast: true,
                position: 'top-end'
            });
        }
    } else {
        // Thông báo lỗi
        if (typeof Swal !== 'undefined') {
            Swal.fire('Thông báo', result.message || 'Có lỗi xảy ra!', 'info');
        }
        
        if (result.message && result.message.toLowerCase().includes('đăng nhập')) {
            setTimeout(() => {
                window.location.href = '/Account/Login';
            }, 1500);
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
