<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Sidebar -->
<div class="sidebar">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="BookStore Logo">
        <button id="toggleSidebar"><i class="fas fa-bars"></i></button>
    </div>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" ${param.active == 'dashboard' ? 'class="active"' : ''}><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/books" ${param.active == 'books' ? 'class="active"' : ''}><i class="fas fa-book"></i> Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories" ${param.active == 'categories' ? 'class="active"' : ''}><i class="fas fa-tags"></i> Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders" ${param.active == 'orders' ? 'class="active"' : ''}><i class="fas fa-shopping-cart"></i> Orders</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" ${param.active == 'users' ? 'class="active"' : ''}><i class="fas fa-users"></i> Users</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/suggestions" ${param.active == 'suggestions' ? 'class="active"' : ''}><i class="fas fa-lightbulb"></i> Suggestions</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/profile" ${param.active == 'profile' ? 'class="active"' : ''}><i class="fas fa-user"></i> Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </nav>
</div> 