/* ============================================================
   PRODUCT COMPARE — sessionStorage-based, max 3 products
============================================================ */
const compareState = {
    ids:   JSON.parse(sessionStorage.getItem('cmpIds')   || '[]'),
    names: JSON.parse(sessionStorage.getItem('cmpNames') || '{}'),

    _save() {
        sessionStorage.setItem('cmpIds',   JSON.stringify(this.ids));
        sessionStorage.setItem('cmpNames', JSON.stringify(this.names));
    },

    add(id, name) {
        if (this.ids.includes(id))      return 'dup';
        if (this.ids.length >= 3)       return 'max';
        this.ids.push(id);
        this.names[String(id)] = name;
        this._save();
        return 'ok';
    },

    remove(id) {
        this.ids = this.ids.filter(i => i !== id);
        delete this.names[String(id)];
        this._save();
    },

    clear() {
        this.ids   = [];
        this.names = {};
        this._save();
    }
};

function toggleCompare(checkbox) {
    const id   = parseInt(checkbox.dataset.id, 10);
    const name = checkbox.dataset.name
        ? JSON.parse(checkbox.dataset.name)
        : (checkbox.closest('.pc-card')?.querySelector('.pc-name-link')?.textContent?.trim() || '');

    if (checkbox.checked) {
        const result = compareState.add(id, name);
        if (result === 'max') {
            checkbox.checked = false;
            alert('Chỉ so sánh tối đa 3 sản phẩm');
            return;
        }
    } else {
        compareState.remove(id);
    }

    _syncCompareCheckboxes();
    _renderCompareBar();
}

function _syncCompareCheckboxes() {
    document.querySelectorAll('.pc-compare-chk').forEach(chk => {
        chk.checked = compareState.ids.includes(parseInt(chk.dataset.id, 10));
    });
}

function _renderCompareBar() {
    const count = compareState.ids.length;
    let bar = document.getElementById('pcCompareBar');

    if (count < 2) {
        if (bar) bar.style.display = 'none';
        return;
    }

    if (!bar) {
        bar = document.createElement('div');
        bar.id = 'pcCompareBar';
        document.body.appendChild(bar);
    }

    bar.className = 'compare-bar';
    bar.style.display = 'flex';
    bar.innerHTML = `
        <span class="compare-bar-text">Đang so sánh: <strong>${count} sản phẩm</strong></span>
        <div class="compare-bar-actions">
            <button class="compare-bar-btn-go" onclick="doCompare()">
                So sánh ngay <i class='bx bx-right-arrow-alt'></i>
            </button>
            <button class="compare-bar-btn-clear" onclick="clearCompare()">Xóa tất cả</button>
        </div>`;
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
