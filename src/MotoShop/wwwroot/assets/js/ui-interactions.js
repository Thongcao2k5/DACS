/**
 * UI Interaction System - MotoShop Admin
 * Đã tối ưu context và handle lỗi crash
 */

const UI = {
    // 1. Toast Notification
    showToast: function(message, type = 'success') {
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            container.style = 'position: fixed; top: 20px; right: 20px; z-index: 10000;';
            document.body.appendChild(container);
        }

        const icons = {
            success: 'bx-check-circle text-success',
            error: 'bx-error-circle text-danger',
            warning: 'bx-error text-warning',
            info: 'bx-info-circle text-info'
        };

        const toast = document.createElement('div');
        toast.className = `custom-toast ${type}`;
        toast.style = 'background: #fff; padding: 12px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 10px; display: flex; align-items: center; min-width: 250px; transition: all 0.3s ease; border-left: 4px solid #696cff;';
        if(type === 'error') toast.style.borderLeftColor = '#ff3e1d';
        
        toast.innerHTML = `
            <i class="bx ${icons[type] || icons.info} me-2 fs-4"></i>
            <div class="toast-message" style="color: #333; font-weight: 500;">${message}</div>
        `;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(20px)';
            setTimeout(() => toast.remove(), 300);
        }, 4000);
    },

    toast: function(message, type = 'success') {
        UI.showToast(message, type);
    },

    // 2. Global Loader (Sửa lỗi treo)
    showLoader: function() {
        let loader = document.getElementById('admin-global-loader');
        if (!loader) {
            loader = document.createElement('div');
            loader.id = 'admin-global-loader';
            loader.style = 'position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.7); display:none; justify-content:center; align-items:center; z-index:99999;';
            loader.innerHTML = '<div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status"></div><div style="margin-left: 15px; font-weight: bold; color: #696cff;">Đang xử lý...</div>';
            document.body.appendChild(loader);
        }
        loader.style.display = 'flex';
    },

    hideLoader: function() {
        const loader = document.getElementById('admin-global-loader');
        if (loader) loader.style.display = 'none';
        // Tắt cả các loader cũ nếu có
        $('.page-loader').hide();
        $('#adminLoader').addClass('d-none');
    },

    // 3. Modal Xác nhận
    confirm: function({ title = 'Xác nhận', message, onConfirm, type = 'primary' }) {
        const modalId = 'globalConfirmModal';
        let modalEl = document.getElementById(modalId);
        if (modalEl) modalEl.remove();

        const isDanger = type === 'danger' || type === 'error';
        const html = `
            <div class="modal fade" id="${modalId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-sm">
                    <div class="modal-content border-0 shadow-lg">
                        <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title fw-bold">
                                <i class="bx ${isDanger ? 'bx-trash text-danger' : 'bx-help-circle text-primary'}"></i> ${title}
                            </h5>
                        </div>
                        <div class="modal-body py-3">${message}</div>
                        <div class="modal-footer border-0 pt-0">
                            <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-sm ${isDanger ? 'btn-danger' : 'btn-primary'}" id="globalConfirmBtn">Đồng ý</button>
                        </div>
                    </div>
                </div>
            </div>`;
        document.body.insertAdjacentHTML('beforeend', html);
        const modal = new bootstrap.Modal(document.getElementById(modalId));
        document.getElementById('globalConfirmBtn').onclick = () => {
            if (onConfirm) onConfirm();
            modal.hide();
        };
        modal.show();
    }
};
