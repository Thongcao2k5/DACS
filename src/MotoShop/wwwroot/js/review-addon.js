/**
 * MOTO-SHOP REVIEW ADD-ON
 * Tự động thêm nút đánh giá vào trang đơn hàng mà không cần sửa code cũ
 */
(function() {
    if (!window.location.pathname.includes('/Order/Detail')) return;

    // 1. Chờ trang tải xong và tìm bảng sản phẩm
    window.addEventListener('load', function() {
        const orderTable = document.querySelector('table'); // Tìm bảng đầu tiên (thường là bảng sản phẩm)
        if (!orderTable) return;

        // Thêm cột Header nếu chưa có
        const headerRow = orderTable.querySelector('thead tr');
        if (headerRow) {
            const th = document.createElement('th');
            th.innerText = 'ĐÁNH GIÁ';
            headerRow.appendChild(th);
        }

        // Duyệt các dòng sản phẩm
        const rows = orderTable.querySelectorAll('tbody tr');
        rows.forEach(row => {
            // Lấy productId từ link sản phẩm trong dòng
            const productLink = row.querySelector('a[href*="/Product/Details"]');
            if (!productLink) return;

            const urlParts = productLink.href.split('/');
            const productSlug = urlParts[urlParts.length - 1];
            
            const td = document.createElement('td');
            const btn = document.createElement('button');
            btn.className = 'btn btn-sm btn-outline-danger rounded-pill';
            btn.innerText = 'Đánh giá';
            btn.onclick = () => openReviewModal(productSlug, row);
            td.appendChild(btn);
            row.appendChild(td);
        });
    });

    function openReviewModal(slug, row) {
        // Sử dụng Swal để hiện form đánh giá nhanh
        Swal.fire({
            title: 'Đánh giá sản phẩm',
            html: `
                <div id="starRating" style="font-size: 25px; color: #ffc107; margin-bottom: 15px; cursor:pointer">
                    <i class='bx bx-star' data-v="1"></i>
                    <i class='bx bx-star' data-v="2"></i>
                    <i class='bx bx-star' data-v="3"></i>
                    <i class='bx bx-star' data-v="4"></i>
                    <i class='bx bx-star' data-v="5"></i>
                </div>
                <textarea id="reviewComment" class="form-control" placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
            `,
            showCancelButton: true,
            confirmButtonText: 'Gửi đánh giá',
            confirmButtonColor: '#E24B4A',
            didOpen: () => {
                let rating = 0;
                const stars = document.querySelectorAll('#starRating i');
                stars.forEach(s => {
                    s.onclick = function() {
                        rating = this.dataset.v;
                        stars.forEach(star => {
                            if (star.dataset.v <= rating) {
                                star.classList.replace('bx-star', 'bxs-star');
                            } else {
                                star.classList.replace('bxs-star', 'bx-star');
                            }
                        });
                        window.currentRating = rating;
                    }
                });
            },
            preConfirm: () => {
                const comment = document.getElementById('reviewComment').value;
                const rating = window.currentRating || 0;
                if (rating === 0) {
                    Swal.showValidationMessage('Vui lòng chọn số sao!');
                    return false;
                }
                return { rating, comment };
            }
        }).then((result) => {
            if (result.isConfirmed) {
                // Gửi API (Bạn cần OrderId, ProductId - lấy từ URL hoặc Context)
                const urlParams = new URLSearchParams(window.location.search);
                const orderId = window.location.pathname.split('/').pop();

                fetch('/ProductReviewAddon/SubmitReview', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        orderId: parseInt(orderId),
                        productId: 0, // Cần mapping Slug -> ID hoặc bổ sung ID vào link
                        rating: parseInt(result.value.rating),
                        comment: result.value.comment
                    })
                }).then(res => res.json()).then(data => {
                    if (data.success) Swal.fire('Thành công', data.message, 'success');
                });
            }
        });
    }
})();
