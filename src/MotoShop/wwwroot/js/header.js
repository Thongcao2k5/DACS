/**
 * MOTO-SHOP FRONTEND HEADER LOGIC
 * Optimized for performance and smooth interactions
 */

const UI = {
    // 1. Toggle Search Overlay
    toggleSearch: function() {
        const overlay = document.getElementById('searchOverlay');
        const input = document.getElementById('searchOverlayInput');
        
        if (!overlay) return;

        if (overlay.style.display === 'flex') {
            overlay.style.display = 'none';
            document.body.style.overflow = 'auto';
        } else {
            overlay.style.display = 'flex';
            document.body.style.overflow = 'hidden';
            setTimeout(() => { if(input) input.focus(); }, 100);
        }
    },

    // 2. Toast Notification - Ecommerce Style
    showToast: function(message, type = 'success', productInfo = null) {
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
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
        
        let toastHtml = `
            <div class="toast-content">
                <i class="bx ${icons[type]} toast-icon"></i>
                <div class="toast-body">
                    <div class="toast-message">${message}</div>
                    ${productInfo ? `
                        <div class="toast-product-mini">
                            <img src="${productInfo.image}" alt="product" class="mini-img">
                            <div class="mini-info">
                                <span class="mini-name">${productInfo.name}</span>
                            </div>
                        </div>
                    ` : ''}
                </div>
                <button class="btn-close-toast" onclick="this.parentElement.parentElement.remove()">&times;</button>
            </div>
            <div class="toast-footer">
                <a href="/Cart" class="btn-view-cart">XEM GIỎ HÀNG</a>
                <div class="toast-progress"></div>
            </div>
        `;
        
        toast.innerHTML = toastHtml;
        container.appendChild(toast);

        // Auto remove
        const timeout = 5000;
        const progress = toast.querySelector('.toast-progress');
        if (progress) {
            progress.style.transition = `width ${timeout}ms linear`;
            setTimeout(() => progress.style.width = '0%', 10);
        }

        setTimeout(() => {
            if (toast.parentElement) {
                toast.classList.add('hide');
                setTimeout(() => toast.remove(), 400);
            }
        }, timeout);
    }
};

document.addEventListener('DOMContentLoaded', function() {
    const headerWrapper = document.getElementById('mainHeaderWrapper');
    const backToTop = document.getElementById('backToTop');
    const pageLoader = document.getElementById('pageLoader');
    let isShrunk = false;

    // 1. Page Loader Handler
    window.addEventListener('load', function() {
        if (pageLoader) {
            pageLoader.style.opacity = '0';
            setTimeout(() => {
                pageLoader.style.visibility = 'hidden';
            }, 500);
        }
    });

    // 2. Optimized Scroll Detection
    function handleScroll() {
        const currentScroll = window.pageYOffset || document.documentElement.scrollTop;

        // Header Shrink Logic
        if (window.innerWidth >= 992) {
            if (currentScroll > 100) {
                if (!isShrunk) {
                    headerWrapper.classList.add('header-sticky', 'header-shrink');
                    isShrunk = true;
                }
            } else {
                if (isShrunk) {
                    headerWrapper.classList.remove('header-sticky', 'header-shrink');
                    isShrunk = false;
                }
            }
        }

        // Back to Top Logic
        if (backToTop) {
            if (currentScroll > 400) {
                backToTop.classList.add('active');
            } else {
                backToTop.classList.remove('active');
            }
        }
    }

    // 3. Back to Top Click
    if (backToTop) {
        backToTop.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }

    // Passive listener để tối ưu performance
    window.addEventListener('scroll', function() {
        window.requestAnimationFrame(handleScroll);
    }, { passive: true });

    // Cập nhật lại khi resize trình duyệt
    window.addEventListener('resize', handleScroll);

    // 4. Keyboard Interactions
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const overlay = document.getElementById('searchOverlay');
            if (overlay && overlay.style.display === 'flex') {
                UI.toggleSearch();
            }
        }
    });

    handleScroll();
});
