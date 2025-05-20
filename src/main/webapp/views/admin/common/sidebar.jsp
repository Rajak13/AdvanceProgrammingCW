<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="admin-sidebar">
    <div class="sidebar-header">
        <h2>Panna<span>Admin</span></h2>
    </div>
    <nav class="sidebar-nav">
        <ul>
            <li class="${pageContext.request.servletPath == '/views/admin/dashboard.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="${pageContext.request.servletPath == '/views/admin/books.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/books">
                    <i class="fas fa-book"></i>
                    <span>Books</span>
                </a>
            </li>
            <li class="${pageContext.request.servletPath == '/views/admin/categories.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/categories">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
            </li>
            <li class="${pageContext.request.servletPath == '/views/admin/users.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i>
                    <span>Users</span>
                </a>
            </li>
            <li class="${pageContext.request.servletPath == '/views/admin/orders.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/orders">
                    <i class="fas fa-shopping-bag"></i>
                    <span>Orders</span>
                </a>
            </li>
            <li class="${pageContext.request.servletPath == '/views/admin/profile.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/profile">
                    <i class="fas fa-user"></i>
                    <span>Profile</span>
                </a>
            </li>
            <li class="${pageContext.request.servletPath == '/views/admin/suggestions.jsp' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/suggestions">
                    <i class="fas fa-lightbulb"></i>
                    <span>Suggestions</span>
                </a>
            </li>
        </ul>
    </nav>
</aside> 