<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,.6); z-index: 500;
            align-items: center; justify-content: center;
        }
        .modal-box {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 2rem; width: 100%; max-width: 480px;
            max-height: 90vh; overflow-y: auto;
        }
        .modal-title { font-size: 1.2rem; font-weight: 800; margin-bottom: 1.2rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Store</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
            <a href="${pageContext.request.contextPath}/logout">${sessionScope.user.name} ✕</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="admin-layout">

        <%-- Sidebar --%>
        <aside>
            <nav class="admin-sidebar">
                <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/products" class="active">📦 Products</a>
                <a href="${pageContext.request.contextPath}/admin/orders">🧾 Orders</a>
                <a href="${pageContext.request.contextPath}/products">🛍️ View Store</a>
            </nav>
        </aside>

        <main>
            <div class="page-header d-flex justify-between align-center">
                <div>
                    <h2>Product Management</h2>
                    <p class="text-muted">${products.size()} product(s) in store</p>
                </div>
                <button class="btn btn-primary btn-sm" onclick="toggleAddForm()" style="width:auto;">
                    + Add Product
                </button>
            </div>

            <%-- ── Add product form (hidden by default) ───── --%>
            <div id="addProductForm" class="section-card" style="display:none;">
                <div class="section-title">Add New Product</div>
                <form action="${pageContext.request.contextPath}/admin/products" method="post">
                    <input type="hidden" name="action" value="addProduct">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Product Name *</label>
                            <input type="text" name="name" placeholder="e.g. Wireless Headphones" required>
                        </div>
                        <div class="form-group">
                            <label>Category *</label>
                            <input type="text" name="category" placeholder="e.g. Electronics" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Price (₹) *</label>
                            <input type="number" name="price" placeholder="999.00" min="0" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label>Stock *</label>
                            <input type="number" name="stock" placeholder="10" min="0" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <input type="text" name="description" placeholder="Short product description">
                    </div>
                    <div class="form-group">
                        <label>Image URL</label>
                        <input type="text" name="imageUrl" placeholder="images/product.jpg">
                    </div>
                    <div class="d-flex gap-1">
                        <button type="submit" class="btn btn-primary btn-sm" style="width:auto;">Save Product</button>
                        <button type="button" class="btn btn-ghost btn-sm" onclick="toggleAddForm()">Cancel</button>
                    </div>
                </form>
            </div>

            <%-- ── Products table ──────────────────────────── --%>
            <div class="section-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td class="text-muted">#${p.id}</td>
                                <td style="font-weight:600;">${p.name}</td>
                                <td>${p.category}</td>
                                <td>₹<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stock > 0}">
                                            <span class="stock-badge">${p.stock}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-badge out">0</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <%-- Edit button → opens modal --%>
                                        <button class="btn btn-ghost btn-sm"
                                                onclick="editProduct(
                                                    ${p.id},
                                                    '${p.name}',
                                                    '${p.category}',
                                                    '${p.price}',
                                                    ${p.stock},
                                                    '${p.description}',
                                                    '${p.imageUrl}')">
                                            Edit
                                        </button>
                                        <%-- Delete --%>
                                        <form id="del-${p.id}"
                                              action="${pageContext.request.contextPath}/admin/products"
                                              method="post">
                                            <input type="hidden" name="action"    value="deleteProduct">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <button type="button" class="btn btn-danger btn-sm"
                                                    onclick="confirmAction('Delete ${p.name}?', 'del-${p.id}')">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<%-- ── Edit Modal ───────────────────────────────────────────── --%>
<div id="editModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-title">Edit Product</div>
        <form action="${pageContext.request.contextPath}/admin/products" method="post">
            <input type="hidden" name="action"    value="updateProduct">
            <input type="hidden" name="productId" id="editId">
            <div class="form-row">
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="name" id="editName" required>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <input type="text" name="category" id="editCategory" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Price (₹)</label>
                    <input type="number" name="price" id="editPrice" min="0" step="0.01" required>
                </div>
                <div class="form-group">
                    <label>Stock</label>
                    <input type="number" name="stock" id="editStock" min="0" required>
                </div>
            </div>
            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description" id="editDescription">
            </div>
            <div class="form-group">
                <label>Image URL</label>
                <input type="text" name="imageUrl" id="editImageUrl">
            </div>
            <div class="d-flex gap-1 mt-2">
                <button type="submit" class="btn btn-primary btn-sm" style="width:auto;">Update</button>
                <button type="button" class="btn btn-ghost btn-sm" onclick="closeModal('editModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<footer><div class="container"><p>© 2024 ShopFlow Admin</p></div></footer>
<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
