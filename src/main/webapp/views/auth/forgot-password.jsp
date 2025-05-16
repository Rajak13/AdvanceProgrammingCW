<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Panna BookStore</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container" style="max-width: 500px;">
        <div class="form-container" style="width: 100%;">
            <form action="${pageContext.request.contextPath}/auth/reset-password" method="post">
                <h1>Reset Password</h1>
                
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" name="email" placeholder="Enter your email" required />
                    </div>
                </div>
                
                <button type="submit">
                    <i class="fas fa-paper-plane"></i> Send Reset Link
                </button>
                
                <a href="${pageContext.request.contextPath}/auth/login" style="margin-top: 20px; display: block;">
                    <i class="fas fa-arrow-left"></i> Back to Login
                </a>
            </form>
        </div>
    </div>
</body>
</html> 