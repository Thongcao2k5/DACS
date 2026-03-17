/**
 * MOTO-SHOP DESIGN SYSTEM - CORE LOGIC
 */

const DS = {
    /**
     * TOAST NOTIFICATION SYSTEM
     */
    showToast: function(message, type = 'success') {
        let container = document.querySelector('.ds-toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'ds-toast-container';
            container.style.cssText = 'position:fixed; top:20px; right:20px; z-index:9999;';
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        const color = `var(--ds-${type})`;
        toast.className = `ds-toast ds-toast-${type}`;
        toast.style.cssText = `
            background: #fff; border-left: 4px solid ${color};
            padding: 12px 20px; border-radius: 8px; margin-bottom: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); display: flex; align-items: center;
            animation: dsSlideIn 0.3s ease forwards; min-width: 300px;
        `;

        toast.innerHTML = `
            <div style="flex-grow:1; font-size:0.9rem; font-weight:500; color:var(--ds-text-main)">${message}</div>
        `;

        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }, 4000);
    },

    /**
     * MODAL SYSTEM
     */
    confirm: function({ title, message, onConfirm, type = 'danger', confirmText = 'Xác nhận', cancelText = 'Hủy bỏ' }) {
        const modalId = 'dsConfirmModal';
        let modalEl = document.getElementById(modalId);
        if (modalEl) {
            const instance = bootstrap.Modal.getInstance(modalEl);
            if(instance) instance.dispose();
            modalEl.remove();
        }

        const isSuccess = type === 'success';
        const modalClass = isSuccess ? 'modal-confirm-success' : 'modal-confirm-delete';
        const icon = isSuccess ? 'bx-check-circle' : 'bx-error-circle';
        const btnClass = isSuccess ? 'btn-success-modern' : 'btn-danger-modern';

        const html = `
            <div class="modal fade ${modalClass}" id="${modalId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-sm">
                    <div class="modal-content shadow-lg border-0" style="border-radius: 16px;">
                        <div class="modal-header border-0 pt-4 pb-0 justify-content-center">
                            <div class="text-center">
                                <i class='bx ${icon}' style="font-size: 4rem; color: ${isSuccess ? '#71dd37' : 'var(--ds-primary)'};"></i>
                                <h5 class="modal-title fw-bold mt-2" style="font-size: 1.25rem;">${title}</h5>
                            </div>
                        </div>
                        <div class="modal-body text-center py-3 px-4" style="color: #566a7f;">
                            ${message}
                        </div>
                        <div class="modal-footer border-0 pb-4 pt-0 px-4 d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary flex-grow-1" data-bs-dismiss="modal" style="height: 45px; border-radius: 10px;">${cancelText}</button>
                            <button type="button" class="btn ${isSuccess ? 'btn-success' : 'btn-primary'} flex-grow-1" id="dsConfirmBtn" style="height: 45px; border-radius: 10px; ${isSuccess ? 'background-color:#71dd37; border-color:#71dd37;' : ''}">${confirmText}</button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', html);
        const newModalEl = document.getElementById(modalId);
        const modal = new bootstrap.Modal(newModalEl);

        document.getElementById('dsConfirmBtn').onclick = () => {
            if (onConfirm) onConfirm();
            modal.hide();
        };

        modal.show();
    },

    /**
     * LOADING SYSTEM
     */
    loading: {
        show: function() {
            let loader = document.getElementById('dsPageLoader');
            if (!loader) {
                loader = document.createElement('div');
                loader.id = 'dsPageLoader';
                loader.style.cssText = 'position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.7); z-index:10000; display:flex; align-items:center; justify-content:center;';
                loader.innerHTML = '<div class="ds-spinner"></div>';
                document.body.appendChild(loader);
            }
            loader.style.display = 'flex';
        },
        hide: function() {
            const loader = document.getElementById('dsPageLoader');
            if (loader) loader.style.display = 'none';
        },
        btnStart: function(btn) {
            btn.setAttribute('data-old-text', btn.innerHTML);
            btn.innerHTML = '<span class="ds-btn-spinner"></span> Đang xử lý...';
            btn.classList.add('disabled');
            btn.style.pointerEvents = 'none';
        },
        btnStop: function(btn) {
            btn.innerHTML = btn.getAttribute('data-old-text');
            btn.classList.remove('disabled');
            btn.style.pointerEvents = 'auto';
        }
    }
};

// Add Animation and Spinner styles
const style = document.createElement('style');
style.textContent = `
    @keyframes dsSlideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    .ds-spinner { width: 40px; height: 40px; border: 4px solid var(--ds-primary-light); border-top: 4px solid var(--ds-primary); border-radius: 50%; animation: dsSpin 0.8s linear infinite; }
    .ds-btn-spinner { width: 14px; height: 14px; border: 2px solid rgba(255,255,255,0.3); border-top: 2px solid #fff; border-radius: 50%; display: inline-block; animation: dsSpin 0.8s linear infinite; margin-right: 5px; }
    @keyframes dsSpin { to { transform: rotate(360deg); } }
`;
document.head.appendChild(style);
