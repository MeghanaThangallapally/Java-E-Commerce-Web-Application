<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- ── Navbar ─────────────────────────────────────────────── --%>
<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products" class="active">Shop</a>
            <a href="${pageContext.request.contextPath}/cart">
                Cart
                <c:if test="${not empty sessionScope.cart and sessionScope.cart.totalItems > 0}">
                    <span class="cart-badge" id="cartBadge">${sessionScope.cart.totalItems}</span>
                </c:if>
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/orders">Orders</a>
                    <c:if test="${sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout">${sessionScope.user.name} ✕</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="navbar-cta">Sign In</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="container page-wrap">
    <%-- ── Search bar ─────────────────────────────────────── --%>
    <form action="${pageContext.request.contextPath}/products" method="get" class="search-bar">
        <input type="text" id="searchInput" name="search"
               placeholder="Search products…"
               value="${not empty param.search ? param.search : ''}"
               oninput="filterProducts()">
        <select name="category" onchange="this.form.submit()">
            <option value="">All Categories</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat}"
                    <c:if test="${cat == selectedCategory}">selected</c:if>>
                    ${cat}
                </option>
            </c:forEach>
        </select>
        <button type="submit" class="btn btn-primary btn-sm" style="white-space:nowrap;">Search</button>
    </form>

    <%-- ── Alerts ─────────────────────────────────────────── --%>
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-error">${requestScope.error}</div>
    </c:if>

    <%-- ── Product grid ────────────────────────────────────── --%>
    <c:choose>
        <c:when test="${empty products}">
            <div class="empty-state">
                <div class="icon">🔍</div>
                <h3>No products found</h3>
                <p>Try a different search or category.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="product" items="${products}">
                    <div class="card product-card"
                         data-name="${product.name}"
                         data-category="${product.category}">

                        <%-- Product image / emoji placeholder --%>
                        <div class="product-img">
                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                                         alt="${product.name}" loading="lazy">
                                </c:when>
                                <c:otherwise>📦</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-body">
                            <div class="product-name">${product.name}</div>
                            <div class="product-cat">${product.category}</div>

                            <div class="product-footer">
                                <span class="product-price">
                                    ₹<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                                </span>
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <span class="stock-badge">${product.stock} left</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-badge out">Out of stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Add to Cart form --%>
                            <c:choose>
                                <c:when test="${product.stock > 0}">
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action"    value="add">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <input type="hidden" name="quantity"  value="1">
                                        <button type="submit" class="btn btn-primary">Add to Cart</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-ghost" disabled>Out of Stock</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer>
    <div class="container"><p>© 2024 ShopFlow · Built with ☕ Java, JSP &amp; MySQL</p></div>
</footer>

<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<c:if test="${not empty sessionScope.cartSuccess}">
    <script>showToast('${sessionScope.cartSuccess}');</script>
    <c:remove var="cartSuccess" scope="session"/>
</c:if>
</body>
</html>
