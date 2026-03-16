<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopFlow — Shop Smarter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- ── Navbar ─────────────────────────────────────────────── --%>
<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Shop</a>
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

<%-- ── Hero ──────────────────────────────────────────────── --%>
<section class="hero">
    <h1>Shop <span>Smarter</span>,<br>Live Better</h1>
    <p>Premium products, seamless experience — powered by Java &amp; JSP</p>
    <a href="${pageContext.request.contextPath}/products"
       class="btn btn-primary" style="width:auto;padding:12px 32px;font-size:1rem;">
        Browse Products →
    </a>
</section>

<%-- ── Feature highlights ─────────────────────────────────── --%>
<section style="padding:0 0 5rem;">
    <div class="container">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">🛍️ Products</div>
                <div class="stat-value">50+</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">🔒 Secure Auth</div>
                <div class="stat-value">SHA-256</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">⚡ Built With</div>
                <div class="stat-value" style="font-size:1.3rem;">Java EE</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">🗄️ Database</div>
                <div class="stat-value" style="font-size:1.3rem;">MySQL</div>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="container">
        <p>© 2024 ShopFlow · Built with ☕ Java, JSP, JDBC &amp; MySQL</p>
    </div>
</footer>

<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<c:if test="${not empty sessionScope.cartSuccess}">
    <script>showToast('${sessionScope.cartSuccess}');</script>
    <c:remove var="cartSuccess" scope="session"/>
</c:if>
</body>
</html>
