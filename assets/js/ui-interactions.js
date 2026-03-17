/**
 * UI Interaction System - MotoShop Admin
 */

const UI = {
    // 1. Toast Notification
    showToast: function(message, type = 'success') {
        let container = document.querySelector('.toast-container') || this._createToastContainer();
        const icons = {
            success: 'bx-check-circle text-success',
            error: 'bx-error-circle text-danger',
            warning: 'bx-error text-warning',
            info: 'bx-info-circle text-info'
        };

        const toast = document.createElement('div');
        toast.className = `custom-toast ${type}`;
        toast.innerHTML = `
            <i class="bx ${icons[type]} toast-icon"></i>
            <div class="toast-message">${message}</div>
        `;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => toast.remove(), 300);
        }, 4000);
    },

    _createToastContainer: function() {
        const div = document.createElement('div');
        div.className = 'toast-container';
        document.body.appendChild(div);
        return div;
    },

    // 2. Modern Modal Xác nhận Xóa
    confirmDelete: function({ title = 'Xác nhận xóa', message, onConfirm }) {
        const modalId = 'globalDeleteModal';
        let modalEl = document.getElementById(modalId);
        
        if (!modalEl) {
            const html = `
                <div class="modal fade modal-confirm-delete" id="${modalId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-sm">
                        <div class="modal-content border-0">
                            <div class="modal-header">
                                <h5 class="modal-title fw-bold">
                                    <i class="bx bx-trash"></i> ${title}
                                </h5>
                            </div>
                            <div class="modal-body text-dark">
                                <div id="deleteModalMessage">${message}</div>
                                <span class="warning-text">Hành động này không thể hoàn tác.</span>
                            </div>
                            <div class="modal-footer border-0">
                                <button type="button" class="btn btn-modern btn-cancel" data-bs-dismiss="modal">Hủy bỏ</button>
                                <button type="button" class="btn btn-modern btn-danger-modern" id="globalDeleteBtn">
                                    <span class="btn-text">Đồng ý xóa</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>`;
            document.body.insertAdjacentHTML('beforeend', html);
            modalEl = document.getElementById(modalId);
        } else {
            document.getElementById('deleteModalMessage').innerHTML = message;
        }

        const modal = new bootstrap.Modal(modalEl);
        const confirmBtn = document.getElementById('globalDeleteBtn');
        const cancelBtn = modalEl.querySelector('.btn-cancel');
        const btnText = confirmBtn.querySelector('.btn-text');

        confirmBtn.disabled = false;
        cancelBtn.disabled = false;
        btnText.innerText = 'Đồng ý xóa';

        confirmBtn.onclick = () => {
            confirmBtn.disabled = true;
            cancelBtn.disabled = true;
            btnText.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang xóa...';

            setTimeout(() => {
                if (onConfirm) onConfirm();
                modal.hide();
                this.showToast('Xóa dữ liệu thành công', 'success');
            }, 1200);
        };

        modal.show();
        modalEl.addEventListener('shown.bs.modal', () => { cancelBtn.focus(); }, { once: true });
    },

    showLoader: function() {
        let loader = document.querySelector('.page-loader') || this._createLoader();
        loader.style.display = 'flex';
    },

    hideLoader: function() {
        const loader = document.querySelector('.page-loader');
        if (loader) loader.style.display = 'none';
    },

    _createLoader: function() {
        const div = document.createElement('div');
        div.className = 'page-loader';
        div.innerHTML = '<div class="spinner-border text-primary" role="status"></div>';
        document.body.appendChild(div);
        return div;
    }
};
