<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — ShopFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ ShopFlow</a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/products">Shop</a>
            <a href="${pageContext.request.contextPath}/login">Sign In</a>
        </div>
    </div>
</nav>

<div class="auth-wrap">
    <div class="auth-card">
        <h2 class="auth-title">Create account</h2>
        <p class="auth-sub">
            Already have one?
            <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </p>

        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-error">${requestScope.error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
            <div class="form-group">
                <label for="name">Full name</label>
                <input type="text" id="name" name="name"
                       placeholder="John Doe"
                       value="${not empty requestScope.name ? requestScope.name : ''}"
                       required autofocus>
            </div>
            <div class="form-group">
                <label for="email">Email address</label>
                <input type="email" id="email" name="email"
                       placeholder="you@example.com"
                       value="${not empty requestScope.email ? requestScope.email : ''}"
                       required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Min. 6 characters" required minlength="6">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat password" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block mt-2">Create Account</button>
        </form>
    </div>
</div>

<div id="toast"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
