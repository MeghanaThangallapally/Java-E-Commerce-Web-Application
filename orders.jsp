<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Shop</a>
            <a href="${pageContext.request.contextPath}/cart">Cart</a>
            <a href="${pageContext.request.contextPath}/orders" class="active">Orders</a>
            <a href="${pageContext.request.contextPath}/logout">${sessionScope.user.name} ✕</a>
        </div>
    </div>
</nav>

<div class="container page-wrap" style="max-width:720px;">
    <div class="page-header">
        <h2>My Orders</h2>
        <p class="text-muted">${orders.size()} order(s) placed</p>
    </div>

    <%-- Success flash after placing order --%>
    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success">
            🎉 Order placed successfully! We'll start processing it right away.
        </div>
    </c:if>

    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-error">${requestScope.error}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="empty-state">
                <div class="icon">📦</div>
                <h3>No orders yet</h3>
                <p>Start shopping and your orders will appear here.</p>
                <a href="${pageContext.request.contextPath}/products"
                   class="btn btn-primary mt-2" style="width:auto;padding:10px 24px;">
                    Browse Products
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orders}">
                <div class="order-card">
                    <div class="order-header">
                        <span class="order-id">Order #${order.id}</span>
                        <span class="status-badge status-${order.status}">${order.status}</span>
                    </div>
                    <div class="order-date">
                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, HH:mm"/>
                        &nbsp;·&nbsp; ${order.items.size()} item(s)
                    </div>

                    <%-- Item chips --%>
                    <div class="order-items-list">
                        <c:forEach var="item" items="${order.items}">
                            <span class="order-item-chip">
                                ${item.product.name} ×${item.quantity}
                            </span>
                        </c:forEach>
                    </div>

                    <div class="order-total">
                        ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<footer>
    <div class="container"><p>© 2024 ShopFlow</p></div>
</footer>
<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
