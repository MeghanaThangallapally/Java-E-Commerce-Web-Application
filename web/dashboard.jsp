<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Store</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Admin</a>
            <a href="${pageContext.request.contextPath}/logout">${sessionScope.user.name} ✕</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="admin-layout">

        <%-- ── Sidebar ───────────────────────────────────── --%>
        <aside>
            <nav class="admin-sidebar">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">📊 Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/products">📦 Products</a>
                <a href="${pageContext.request.contextPath}/admin/orders">🧾 Orders</a>
                <a href="${pageContext.request.contextPath}/products">🛍️ View Store</a>
            </nav>
        </aside>

        <%-- ── Main content ──────────────────────────────── --%>
        <main>
            <div class="page-header">
                <h2>Dashboard</h2>
                <p class="text-muted">Welcome back, ${sessionScope.user.name}</p>
            </div>

            <%-- Stats --%>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">📦 Total Products</div>
                    <div class="stat-value">${totalProducts}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">🧾 Total Orders</div>
                    <div class="stat-value">${totalOrders}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">👤 Registered Users</div>
                    <div class="stat-value">${totalUsers}</div>
                </div>
            </div>

            <%-- Recent orders --%>
            <div class="section-card">
                <div class="section-title">Recent Orders</div>
                <c:choose>
                    <c:when test="${empty recentOrders}">
                        <p class="text-muted">No orders yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${recentOrders}">
                                    <tr>
                                        <td>#${order.id}</td>
                                        <td>${not empty order.userName ? order.userName : 'User #'.concat(order.userId)}</td>
                                        <td>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                        <td><span class="status-badge status-${order.status}">${order.status}</span></td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="mt-2">
                            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-ghost btn-sm" style="width:auto;">
                                View all orders →
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<footer><div class="container"><p>© 2024 ShopFlow Admin</p></div></footer>
<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
