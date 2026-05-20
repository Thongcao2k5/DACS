(function () {
    const toolbarGroups = [
        [
            { command: 'bold', icon: 'bx-bold', title: 'In đậm' },
            { command: 'italic', icon: 'bx-italic', title: 'In nghiêng' },
            { command: 'underline', icon: 'bx-underline', title: 'Gạch chân' }
        ],
        [
            { command: 'justifyLeft', icon: 'bx-align-left', title: 'Căn trái' },
            { command: 'justifyCenter', icon: 'bx-align-middle', title: 'Căn giữa' },
            { command: 'justifyRight', icon: 'bx-align-right', title: 'Căn phải' },
            { command: 'justifyFull', icon: 'bx-align-justify', title: 'Căn đều' }
        ],
        [
            { command: 'insertUnorderedList', icon: 'bx-list-ul', title: 'Danh sách chấm' },
            { command: 'insertOrderedList', icon: 'bx-list-ol', title: 'Danh sách số' }
        ],
        [
            { command: 'createLink', icon: 'bx-link', title: 'Chèn liên kết' },
            { command: 'removeFormat', icon: 'bx-eraser', title: 'Xóa định dạng' }
        ]
    ];

    function createButton(item, area, textarea) {
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'btn btn-sm btn-outline-secondary';
        button.title = item.title;
        button.innerHTML = `<i class="bx ${item.icon}"></i>`;
        button.addEventListener('click', function () {
            area.focus();
            if (item.command === 'createLink') {
                const url = prompt('Nhập đường dẫn liên kết');
                if (url) {
                    document.execCommand('createLink', false, url);
                }
            } else {
                document.execCommand(item.command, false, null);
            }
            sync(area, textarea);
        });
        return button;
    }

    function createSelect(options, onChange) {
        const select = document.createElement('select');
        select.className = 'form-select form-select-sm';
        options.forEach(option => {
            const item = document.createElement('option');
            item.value = option.value;
            item.textContent = option.label;
            select.appendChild(item);
        });
        select.addEventListener('change', onChange);
        return select;
    }

    function sync(area, textarea) {
        textarea.value = area.innerHTML.trim();
    }

    function insertTable(area, textarea) {
        area.focus();
        document.execCommand('insertHTML', false, '<table><tbody><tr><td>Cột 1</td><td>Cột 2</td></tr><tr><td>Nội dung</td><td>Nội dung</td></tr></tbody></table><p><br></p>');
        sync(area, textarea);
    }

    function init(textarea) {
        if (textarea.dataset.richTextReady === 'true') return;
        textarea.dataset.richTextReady = 'true';
        textarea.classList.add('d-none');

        const shell = document.createElement('div');
        shell.className = 'rich-text-shell';

        const toolbar = document.createElement('div');
        toolbar.className = 'rich-text-toolbar';

        const area = document.createElement('div');
        area.className = 'rich-text-area';
        area.contentEditable = 'true';
        area.dataset.placeholder = textarea.getAttribute('placeholder') || 'Nhập mô tả sản phẩm...';
        area.innerHTML = textarea.value || '';

        const formatSelect = createSelect([
            { value: 'p', label: 'Đoạn văn' },
            { value: 'h2', label: 'Tiêu đề lớn' },
            { value: 'h3', label: 'Tiêu đề vừa' },
            { value: 'h4', label: 'Tiêu đề nhỏ' }
        ], function () {
            area.focus();
            document.execCommand('formatBlock', false, this.value);
            sync(area, textarea);
        });
        toolbar.appendChild(formatSelect);

        const fontSizeSelect = createSelect([
            { value: '', label: 'Cỡ chữ' },
            { value: '2', label: 'Nhỏ' },
            { value: '3', label: 'Thường' },
            { value: '4', label: 'Vừa' },
            { value: '5', label: 'Lớn' },
            { value: '6', label: 'Rất lớn' }
        ], function () {
            if (!this.value) return;
            area.focus();
            document.execCommand('fontSize', false, this.value);
            sync(area, textarea);
            this.value = '';
        });
        toolbar.appendChild(fontSizeSelect);

        toolbarGroups.forEach(group => {
            group.forEach(item => toolbar.appendChild(createButton(item, area, textarea)));
        });

        const tableButton = document.createElement('button');
        tableButton.type = 'button';
        tableButton.className = 'btn btn-sm btn-outline-secondary';
        tableButton.title = 'Chèn bảng';
        tableButton.innerHTML = '<i class="bx bx-table"></i>';
        tableButton.addEventListener('click', () => insertTable(area, textarea));
        toolbar.appendChild(tableButton);

        area.addEventListener('input', () => sync(area, textarea));
        area.addEventListener('blur', () => sync(area, textarea));
        area.addEventListener('paste', () => setTimeout(() => sync(area, textarea), 0));

        shell.appendChild(toolbar);
        shell.appendChild(area);
        textarea.parentNode.insertBefore(shell, textarea.nextSibling);
        sync(area, textarea);
    }

    function syncAll() {
        document.querySelectorAll('textarea.rich-editor').forEach(textarea => {
            const area = textarea.parentNode.querySelector('.rich-text-area');
            if (area) sync(area, textarea);
        });
    }

    function initAll() {
        document.querySelectorAll('textarea.rich-editor').forEach(init);
        document.querySelectorAll('form').forEach(form => {
            if (form.dataset.richTextSubmitBound === 'true') return;
            form.dataset.richTextSubmitBound = 'true';
            form.addEventListener('submit', syncAll);
        });
    }

    window.MotoShopRichText = { initAll, syncAll };
    document.addEventListener('DOMContentLoaded', initAll);
})();
