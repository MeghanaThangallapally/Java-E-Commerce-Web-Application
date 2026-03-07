<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Shop</a>
            <a href="${pageContext.request.contextPath}/register">Register</a>
        </div>
    </div>
</nav>

<div class="auth-wrap">
    <div class="auth-card">
        <h2 class="auth-title">Welcome back</h2>
        <p class="auth-sub">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Create one</a>
        </p>

        <%-- Flash success from registration --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <%-- Login error --%>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-error">${requestScope.error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
            <div class="form-group">
                <label for="email">Email address</label>
                <input type="email" id="email" name="email"
                       placeholder="you@example.com"
                       value="${not empty param.email ? param.email : ''}"
                       required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block mt-2">Sign In</button>
        </form>

        <p class="text-muted mt-2" style="font-size:.8rem;text-align:center;">
            Demo admin: admin@shopflow.com / admin123
        </p>
    </div>
</div>

<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
