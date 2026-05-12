/* ============================================================
   PRODUCT COMPARE — sessionStorage-based, max 3, same-category
============================================================ */
const compareState = {
    items: JSON.parse(sessionStorage.getItem('cmpItems') || '[]'),
    // Each item: { id, name, categoryId, categoryName, imgUrl }

    _save() {
        sessionStorage.setItem('cmpItems', JSON.stringify(this.items));
    },

    get ids() {
        return this.items.map(i => i.id);
    },

    add(id, name, categoryId, categoryName, imgUrl) {
        if (this.items.some(i => i.id === id)) return 'dup';
        if (this.items.length > 0 && this.items[0].categoryId !== categoryId) return 'cat';
        if (this.items.length >= 3) return 'max';
        this.items.push({ id, name, categoryId, categoryName, imgUrl: imgUrl || '' });
        this._save();
        return 'ok';
    },

    remove(id) {
        this.items = this.items.filter(i => i.id !== id);
        this._save();
    },

    clear() {
        this.items = [];
        this._save();
    }
};

// Button-based compare (from product card overlay button)
function addToCompareFromBtn(btn) {
    const id           = parseInt(btn.dataset.id, 10);
    const name         = btn.dataset.name || '';
    const categoryId   = parseInt(btn.dataset.categoryId || '0', 10);
    const categoryName = btn.dataset.categoryName || '';
    const imgUrl       = btn.dataset.img || '';

    if (compareState.items.some(i => i.id === id)) {
        compareState.remove(id);
        btn.classList.remove('active');
        _syncCompareCheckboxes();
        _renderCompareBar();
        return;
    }

    const result = compareState.add(id, name, categoryId, categoryName, imgUrl);

    if (result === 'cat') {
        const currentCat = compareState.items[0]?.categoryName || '';
        Swal.fire({
            icon: 'warning',
            title: 'Không thể so sánh',
            html: `Chỉ so sánh được sản phẩm <strong>cùng danh mục</strong>.<br>Đang so sánh danh mục: <em>${currentCat}</em>`,
            confirmButtonColor: '#dc3545',
            confirmButtonText: 'Đồng ý'
        });
        return;
    }
    if (result === 'max') {
        Swal.fire({
            icon: 'info',
            title: 'Tối đa 3 sản phẩm',
            text: 'Bạn chỉ có thể so sánh tối đa 3 sản phẩm cùng lúc.',
            confirmButtonColor: '#dc3545'
        });
        return;
    }

    btn.classList.add('active');
    _syncCompareCheckboxes();
    _renderCompareBar();
}

// Checkbox-based compare (for pc-compare-chk checkboxes)
function toggleCompare(checkbox) {
    const id           = parseInt(checkbox.dataset.id, 10);
    const name         = checkbox.dataset.name
        ? JSON.parse(checkbox.dataset.name)
        : (checkbox.closest('.pc-card')?.querySelector('.pc-name-link')?.textContent?.trim() || '');
    const categoryId   = parseInt(checkbox.dataset.categoryId || '0', 10);
    const categoryName = checkbox.dataset.categoryName || '';

    if (checkbox.checked) {
        const result = compareState.add(id, name, categoryId, categoryName);
        if (result === 'dup') { checkbox.checked = false; return; }
        if (result === 'cat') {
            checkbox.checked = false;
            const currentCat = compareState.items[0]?.categoryName || '';
            Swal.fire({
                icon: 'warning',
                title: 'Không thể so sánh',
                html: `Chỉ so sánh được sản phẩm <strong>cùng danh mục</strong>.<br>Đang so sánh danh mục: <em>${currentCat}</em>`,
                confirmButtonColor: '#dc3545'
            });
            return;
        }
        if (result === 'max') {
            checkbox.checked = false;
            Swal.fire({ icon: 'info', title: 'Tối đa 3 sản phẩm', confirmButtonColor: '#dc3545' });
            return;
        }
    } else {
        compareState.remove(id);
    }
    _syncCompareCheckboxes();
    _renderCompareBar();
}

function _syncCompareCheckboxes() {
    const ids = compareState.ids;
    document.querySelectorAll('.pc-compare-chk').forEach(chk => {
        chk.checked = ids.includes(parseInt(chk.dataset.id, 10));
    });
    document.querySelectorAll('.btn-compare-abs').forEach(btn => {
        btn.classList.toggle('active', ids.includes(parseInt(btn.dataset.id, 10)));
    });
}

function _renderCompareBar() {
    const count = compareState.items.length;
    let bar = document.getElementById('pcCompareBar');

    if (count === 0) {
        if (bar) bar.style.display = 'none';
        return;
    }

    if (!bar) {
        bar = document.createElement('div');
        bar.id = 'pcCompareBar';
        document.body.appendChild(bar);
    }

    const catName = compareState.items[0]?.categoryName || '';
    const slots = [0, 1, 2].map(i => {
        const item = compareState.items[i];
        if (item) {
            const thumb = item.imgUrl
                ? `<img src="${item.imgUrl}" alt="${item.name}">`
                : `<i class='bx bx-image-alt' style="font-size:22px;color:#9ca3af"></i>`;
            return `<div class="cmp-slot cmp-slot-filled">
                <div class="cmp-slot-thumb">${thumb}</div>
                <span class="cmp-slot-name">${item.name}</span>
                <button class="cmp-slot-remove" onclick="removeFromCompare(${item.id})" title="Bỏ sản phẩm này">
                    <i class='bx bx-x'></i>
                </button>
            </div>`;
        }
        return `<div class="cmp-slot cmp-slot-empty">
            <i class='bx bx-plus' style="font-size:20px;opacity:.4"></i>
            <span>Chọn SP</span>
        </div>`;
    }).join('');

    bar.className = 'compare-bar';
    bar.style.display = 'flex';
    bar.innerHTML = `
        <div class="compare-bar-info">
            <div class="compare-bar-cat"><i class='bx bx-layer me-1'></i>${catName || 'So sánh sản phẩm'}</div>
            <div class="compare-bar-count">${count}/3 sản phẩm</div>
        </div>
        <div class="compare-bar-slots">${slots}</div>
        <div class="compare-bar-actions">
            <button class="compare-bar-btn-go" onclick="doCompare()" ${count < 2 ? 'disabled' : ''}>
                So sánh ngay <i class='bx bx-right-arrow-alt'></i>
            </button>
            <button class="compare-bar-btn-clear" onclick="clearCompare()">Xóa tất cả</button>
        </div>`;
}

function removeFromCompare(id) {
    compareState.remove(id);
    _syncCompareCheckboxes();
    _renderCompareBar();
}

function doCompare() {
    if (compareState.ids.length < 2) return;
    window.location.href = '/Product/Compare?ids=' + compareState.ids.join(',');
}

function clearCompare() {
    compareState.clear();
    _syncCompareCheckboxes();
    _renderCompareBar();
}

/* ============================================================
   INIT
============================================================ */
document.addEventListener('DOMContentLoaded', () => {
    _syncCompareCheckboxes();
    _renderCompareBar();
});
