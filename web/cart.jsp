<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Shop</a>
            <a href="${pageContext.request.contextPath}/cart" class="active">
                Cart
                <c:if test="${not empty sessionScope.cart and sessionScope.cart.totalItems > 0}">
                    <span class="cart-badge">${sessionScope.cart.totalItems}</span>
                </c:if>
            </a>
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/orders">Orders</a>
                <a href="${pageContext.request.contextPath}/logout">${sessionScope.user.name} ✕</a>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login" class="navbar-cta">Sign In</a>
            </c:if>
        </div>
    </div>
</nav>

<div class="container-sm page-wrap">
    <div class="page-header">
        <h2>Your Cart</h2>
        <c:choose>
            <c:when test="${not empty cart and not cart.empty}">
                <p class="text-muted">${cart.totalItems} item(s)</p>
            </c:when>
            <c:otherwise><p class="text-muted">0 items</p></c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-error">${requestScope.error}</div>
    </c:if>

    <div class="card">
        <div class="card-body">
            <c:choose>
                <%-- Empty cart --%>
                <c:when test="${empty cart or cart.empty}">
                    <div class="empty-state">
                        <div class="icon">🛒</div>
                        <h3>Your cart is empty</h3>
                        <p>Add some products to get started.</p>
                        <a href="${pageContext.request.contextPath}/products"
                           class="btn btn-primary mt-2" style="width:auto;padding:10px 24px;">
                            Browse Products
                        </a>
                    </div>
                </c:when>

                <%-- Cart items --%>
                <c:otherwise>
                    <c:forEach var="item" items="${cart.items}">
                        <div class="cart-item">
                            <div class="cart-item-img">📦</div>
                            <div class="cart-item-info">
                                <div class="cart-item-name">${item.product.name}</div>
                                <div class="cart-item-price">
                                    ₹<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/>
                                    × ${item.quantity}
                                    = ₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>
                            </div>

                            <%-- Qty update form --%>
                            <form id="form-${item.product.id}"
                                  action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action"    value="update">
                                <input type="hidden" name="productId" value="${item.product.id}">
                                <div class="qty-controls">
                                    <button type="button" class="qty-btn"
                                            onclick="changeQty(${item.product.id}, -1);
                                                     updateCart(${item.product.id});">−</button>
                                    <input type="number" id="qty-${item.product.id}" name="quantity"
                                           value="${item.quantity}" min="1"
                                           style="width:48px;text-align:center;padding:6px 4px;">
                                    <button type="button" class="qty-btn"
                                            onclick="changeQty(${item.product.id},  1);
                                                     updateCart(${item.product.id});">+</button>
                                </div>
                            </form>

                            <%-- Remove form --%>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action"    value="remove">
                                <input type="hidden" name="productId" value="${item.product.id}">
                                <button type="submit" class="remove-btn" title="Remove">✕</button>
                            </form>
                        </div>
                    </c:forEach>

                    <%-- Summary & checkout --%>
                    <div class="cart-summary">
                        <div>
                            <div class="cart-total-label">Order Total</div>
                            <div class="cart-total-value">
                                ₹<fmt:formatNumber value="${cart.totalPrice}" pattern="#,##0.00"/>
                            </div>
                        </div>
                        <div class="d-flex gap-1">
                            <%-- Clear cart --%>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-ghost btn-sm">Clear Cart</button>
                            </form>
                            <%-- Place order --%>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <form action="${pageContext.request.contextPath}/orders" method="post">
                                        <button type="submit" class="btn btn-primary checkout-btn">
                                            Place Order →
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login"
                                       class="btn btn-primary checkout-btn">
                                        Login to Checkout →
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<footer>
    <div class="container"><p>© 2024 ShopFlow</p></div>
</footer>
<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
