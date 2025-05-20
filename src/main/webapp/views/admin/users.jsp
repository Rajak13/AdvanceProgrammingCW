<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>Panna<span>Admin</span></h2>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i><span>Dashboard</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/books"><i class="fas fa-book"></i><span>Books</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tags"></i><span>Categories</span></a></li>
                    <li class="active"><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span>Users</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-shopping-bag"></i><span>Orders</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/profile"><i class="fas fa-user"></i><span>Profile</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="fas fa-cog"></i><span>Settings</span></a></li>
                </ul>
            </nav>
        </aside>

        <main class="admin-main">
            <header class="admin-header">
                <div class="header-left">
                    <button class="sidebar-toggle"><i class="fas fa-bars"></i></button>
                    <div class="search-bar">
                        <input type="text" placeholder="Search users...">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                <div class="header-right">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">3</span>
                    </div>
                    <div class="user-menu">
                        <div class="user-info">
                            <c:if test="${not empty sessionScope.user}">
                                <span>${sessionScope.user.name}</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </header>

            <div class="dashboard-content">
                <div class="dashboard-header">
                    <h1>Users Management</h1>
                </div>

                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Contact</th>
                                <th>Address</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.userId}</td>
                                    <td>${user.name}</td>
                                    <td>${user.email}</td>
                                    <td>${user.role}</td>
                                    <td>${user.contact}</td>
                                    <td>${user.address}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    <script>window.ctx = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>