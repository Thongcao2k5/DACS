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
