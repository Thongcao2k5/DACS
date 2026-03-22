const BASE_URL = "https://localhost:7276/api";
const API_PRODUCT = `${BASE_URL}/ProductApi`;

document.addEventListener("DOMContentLoaded", function () {
    fetchCategories().then(() => {
        fetchBooks();
        fetchUsers();
    });

    document.getElementById("btnAddBook").addEventListener("click", addBook);
    document.getElementById("btnAddUser").addEventListener("click", addUser);
    document.getElementById("btnAddCategory").addEventListener("click", addCategory);
});

let categories = [];

/* ================= SÁCH ================= */

function fetchBooks() {
    return fetch(API_PRODUCT)
        .then(res => res.json())
        .then(data => displayBooks(data))
        .catch(err => console.error("Lỗi sách:", err));
}

function displayBooks(books) {
    const bookList = document.getElementById("bookList");
    bookList.innerHTML = "";

    books.forEach(book => {
        const category = categories.find(c => c.id === book.categoryId);
        const categoryName = category ? category.name : "Không có";

        bookList.innerHTML += `
        <tr>
            <td>${book.id}</td>
            <td>${book.name}</td>
            <td>${book.price}</td>
            <td>${book.description || ""}</td>
            <td>${categoryName}</td>
            <td>
                <button class="btn btn-warning"
                    onclick="editBook(${book.id}, '${book.name}', ${book.price}, '${book.description || ""}', ${book.categoryId || ""})">
                    Sửa
                </button>
                <button class="btn btn-danger" onclick="deleteBook(${book.id})">
                    Xóa
                </button>
            </td>
        </tr>`;
    });
}

function addBook() {
    const id = document.getElementById("bookId").value;
    const data = {
        id: id ? parseInt(id) : 0,
        name: document.getElementById("bookName").value,
        price: parseFloat(document.getElementById("bookPrice").value),
        description: document.getElementById("bookDescription").value || "",
        categoryId: document.getElementById("bookCategory").value || null
    };

    if (!data.name || !data.price) return alert("Thiếu dữ liệu!");

    const url = id ? `${API_PRODUCT}/${id}` : API_PRODUCT;
    const method = id ? "PUT" : "POST";

    fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    }).then(() => {
        resetBookForm();
        fetchBooks();
    });
}

function deleteBook(id) {
    fetch(`${API_PRODUCT}/${id}`, { method: "DELETE" })
        .then(() => fetchBooks());
}
function deleteAllBooks() {
    if (!confirm("Bạn có chắc muốn xóa TẤT CẢ sách không?")) return;

    fetch(API_PRODUCT)
        .then(res => res.json())
        .then(books => {
            const deletePromises = books.map(book =>
                fetch(`${API_PRODUCT}/${book.id}`, {
                    method: "DELETE"
                })
            );

            return Promise.all(deletePromises);
        })
        .then(() => {
            alert("Đã xóa toàn bộ sách!");
            fetchBooks();
        })
        .catch(err => console.error("Lỗi:", err));
}

function editBook(id, name, price, description, categoryId) {
    document.getElementById("bookId").value = id;
    document.getElementById("bookName").value = name;
    document.getElementById("bookPrice").value = price;
    document.getElementById("bookDescription").value = description || "";
    document.getElementById("bookCategory").value = categoryId || "";
}

function resetBookForm() {
    ["bookId","bookName","bookPrice","bookDescription","bookCategory"]
        .forEach(id => document.getElementById(id).value = "");
}

/* ================= USERS ================= */

function fetchUsers() {
    return fetch(`${BASE_URL}/users`)
        .then(res => res.json())
        .then(data => displayUsers(data));
}

function displayUsers(users) {
    const userList = document.getElementById("userList");
    userList.innerHTML = "";

    users.forEach(u => {
        userList.innerHTML += `
        <tr>
            <td>${u.id}</td>
            <td>${u.name}</td>
            <td>${u.email}</td>
            <td>${u.role}</td>
            <td>${u.dateOfBirth ? new Date(u.dateOfBirth).toLocaleDateString() : ""}</td>
            <td>${u.address || ""}</td>
            <td>${u.phoneNumber || ""}</td>
            <td>${u.createdAt ? new Date(u.createdAt).toLocaleString() : ""}</td>
            <td>
                <button class="btn btn-warning"
                    onclick="editUser(${u.id}, '${u.name}', '${u.email}', '${u.role}', '${u.dateOfBirth}', '${u.address}', '${u.phoneNumber}')">
                    Sửa
                </button>
                <button class="btn btn-danger" onclick="deleteUser(${u.id})">Xóa</button>
            </td>
        </tr>`;
    });
}

function addUser() {
    const id = document.getElementById("userId").value;

    const data = {
        id: id ? parseInt(id) : undefined,
        name: document.getElementById("userName").value,
        email: document.getElementById("userEmail").value,
        password: document.getElementById("userPassword").value || "123456",
        role: document.getElementById("userRole").value,
        dateOfBirth: document.getElementById("userDateOfBirth").value || null,
        address: document.getElementById("userAddress").value || null,
        phoneNumber: document.getElementById("userPhoneNumber").value || null
    };

    const url = id ? `${BASE_URL}/users/${id}` : `${BASE_URL}/users`;
    const method = id ? "PUT" : "POST";

    fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    }).then(() => {
        resetUserForm();
        fetchUsers();
    });
}

function deleteUser(id) {
    fetch(`${BASE_URL}/users/${id}`, { method: "DELETE" })
        .then(() => fetchUsers());
}

function editUser(id, name, email, role, dob, address, phone) {
    document.getElementById("userId").value = id;
    document.getElementById("userName").value = name;
    document.getElementById("userEmail").value = email;
    document.getElementById("userRole").value = role;
    document.getElementById("userDateOfBirth").value = dob ? new Date(dob).toISOString().split("T")[0] : "";
    document.getElementById("userAddress").value = address || "";
    document.getElementById("userPhoneNumber").value = phone || "";
}

function resetUserForm() {
    ["userId","userName","userEmail","userPassword","userRole","userDateOfBirth","userAddress","userPhoneNumber"]
        .forEach(id => document.getElementById(id).value = "");
}

/* ================= CATEGORIES ================= */

function fetchCategories() {
    return fetch(`${BASE_URL}/categories`)
        .then(res => res.json())
        .then(data => {
            categories = data;
            displayCategories(data);
            populateCategoryDropdown();
        });
}

function displayCategories(list) {
    const el = document.getElementById("categoryList");
    el.innerHTML = "";

    list.forEach(c => {
        el.innerHTML += `
        <tr>
            <td>${c.id}</td>
            <td>${c.name}</td>
            <td>${c.description}</td>
            <td>
                <button class="btn btn-warning" onclick="editCategory(${c.id}, '${c.name}', '${c.description}')">Sửa</button>
                <button class="btn btn-danger" onclick="deleteCategory(${c.id})">Xóa</button>
            </td>
        </tr>`;
    });
}

function populateCategoryDropdown() {
    const select = document.getElementById("bookCategory");
    select.innerHTML = `<option value="">-- Chọn danh mục --</option>`;

    categories.forEach(c => {
        select.innerHTML += `<option value="${c.id}">${c.name}</option>`;
    });
}

function addCategory() {
    const id = document.getElementById("categoryId").value;

    const data = {
        id: id ? parseInt(id) : undefined,
        name: document.getElementById("categoryName").value,
        description: document.getElementById("categoryDescription").value
    };

    const url = id ? `${BASE_URL}/categories/${id}` : `${BASE_URL}/categories`;
    const method = id ? "PUT" : "POST";

    fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    }).then(() => {
        resetCategoryForm();
        fetchCategories();
    });
}

function deleteCategory(id) {
    fetch(`${BASE_URL}/categories/${id}`, { method: "DELETE" })
        .then(() => fetchCategories());
}

function editCategory(id, name, description) {
    document.getElementById("categoryId").value = id;
    document.getElementById("categoryName").value = name;
    document.getElementById("categoryDescription").value = description;
}

function resetCategoryForm() {
    ["categoryId","categoryName","categoryDescription"]
        .forEach(id => document.getElementById(id).value = "");
}