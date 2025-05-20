<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Panna BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    <style>
        :root {
            --primary-dark: #1A237E;
            --primary-light: #534BAE;
            --accent-color: #FF5722;
            --white: #FFFFFF;
            --light-bg: #F5F5F5;
            --light-text: #757575;
            --border-radius: 4px;
            --shadow: 0 2px 4px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
            background: var(--light-bg);
        }

        .admin-sidebar {
            width: 250px;
            background: var(--primary-dark);
            color: var(--white);
            padding: 1rem;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: var(--shadow);
        }

        .admin-main {
            flex: 1;
            margin-left: 250px;
            padding: 2rem;
        }

        .sidebar-header {
            padding: 1rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 1rem;
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 1.5rem;
            color: var(--white);
        }

        .sidebar-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-nav li {
            margin-bottom: 0.5rem;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: var(--white);
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .sidebar-nav a:hover {
            background: rgba(255,255,255,0.1);
        }

        .sidebar-nav a.active {
            background: var(--accent-color);
        }

        .sidebar-nav i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
        }

        .admin-header {
            background: var(--white);
            padding: 1rem 2rem;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-header h1 {
            margin: 0;
            color: var(--primary-dark);
            font-size: 1.75rem;
        }

        .admin-header .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .admin-header .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .admin-header .user-info .user-details {
            display: flex;
            flex-direction: column;
        }

        .admin-header .user-info .user-name {
            font-weight: 500;
            color: var(--primary-dark);
        }

        .admin-header .user-info .user-role {
            font-size: 0.875rem;
            color: var(--light-text);
        }

        .btn-logout {
            padding: 0.5rem 1rem;
            background: var(--accent-color);
            color: var(--white);
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-logout:hover {
            background: #E64A19;
        }

        /* Common styles for admin content */
        .admin-content {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            padding: 2rem;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .content-header h2 {
            color: var(--primary-dark);
            margin: 0;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--accent-color);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .admin-sidebar {
                width: 60px;
                padding: 1rem 0.5rem;
            }

            .admin-sidebar .sidebar-header h2,
            .admin-sidebar .sidebar-nav span {
                display: none;
            }

            .admin-main {
                margin-left: 60px;
            }

            .admin-sidebar .sidebar-nav a {
                justify-content: center;
                padding: 0.75rem;
            }

            .admin-sidebar .sidebar-nav i {
                margin: 0;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>Panna BookStore</h2>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" 
                           class="${currentPage == 'dashboard' ? 'active' : ''}">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/books"
                           class="${currentPage == 'books' ? 'active' : ''}">
                            <i class="fas fa-book"></i>
                            <span>Books</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/categories"
                           class="${currentPage == 'categories' ? 'active' : ''}">
                            <i class="fas fa-tags"></i>
                            <span>Categories</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/orders"
                           class="${currentPage == 'orders' ? 'active' : ''}">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Orders</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users"
                           class="${currentPage == 'users' ? 'active' : ''}">
                            <i class="fas fa-users"></i>
                            <span>Users</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/suggestions"
                           class="${currentPage == 'suggestions' ? 'active' : ''}">
                            <i class="fas fa-lightbulb"></i>
                            <span>Suggestions</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="admin-main">
            <!-- Header -->
            <header class="admin-header">
                <h1>${pageTitle}</h1>
                <div class="user-info">
                    <img src="${pageContext.request.contextPath}/images/${user.picture != null ? user.picture : 'default-avatar.png'}" 
                         alt="${user.name}">
                    <div class="user-details">
                        <span class="user-name">${user.name}</span>
                        <span class="user-role">${user.role}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="fas fa-sign-out-alt"></i>
                        Logout
                    </a>
                </div>
            </header>
        </main>
    </div>
</body>
</html> 