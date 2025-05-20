<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>Panna<span>Admin</span></h2>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/books">
                            <i class="fas fa-book"></i>
                            <span>Books</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fas fa-tags"></i>
                            <span>Categories</span>
                        </a>
                    </li>
                    <li >
                        <a href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i>
                            <span>Users</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Orders</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/profile">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

    
        <!-- Main Content -->
         <!-- Main Content -->
        <main class="admin-main">
            <!-- Top Navigation -->
            <header class="admin-header">
                <div class="header-left">
                    <button class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
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

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon sales">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Books</h3>
                            <p class="stat-value">${totalBooks}</p>
                            <p class="stat-change">+${newBooksThisMonth} this month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon customers">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Active Readers</h3>
                            <p class="stat-value">${activeReaders}</p>
                            <p class="stat-change">+${newReadersThisMonth} this month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Book Sales</h3>
                            <p class="stat-value">$${totalSales}</p>
                            <p class="stat-change">+${salesGrowth}% this month</p>
                        </div>
                    </div>
                </div>

                <!-- Charts and Tables -->
                <div class="dashboard-grid">
                    <!-- Revenue Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Revenue</h3>
                            <div class="chart-legend">
                                <span class="legend-item">
                                    <i class="fas fa-circle" style="color: #4CAF50"></i>
                                    Google ads
                                </span>
                                <span class="legend-item">
                                    <i class="fas fa-circle" style="color: #FF9800"></i>
                                    Facebook ads
                                </span>
                            </div>
                        </div>
                        <div class="chart-container" style="height: 300px;">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>

                    <!-- Website Visitors -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Website Visitors</h3>
                        </div>
                        <div class="chart-container" style="height: 300px;">
                            <canvas id="visitorsChart"></canvas>
                        </div>
                        <div class="visitors-stats">
                            <div class="stat-item">
                                <span class="stat-label">Direct</span>
                                <span class="stat-value">38%</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">Organic</span>
                                <span class="stat-value">22%</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">Paid</span>
                                <span class="stat-value">12%</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">Social</span>
                                <span class="stat-value">28%</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top Selling Books -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Top Selling Books</h3>
                        <div class="table-actions">
                            <div class="search-bar">
                                <input type="text" placeholder="Search books...">
                                <button><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Book</th>
                                <th>Author</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Sales</th>
                                <th>Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${topSellingBooks}">
                                <tr>
                                    <td>
                                        <div class="product-item">
                                            <img src="${pageContext.request.contextPath}${book.coverImage}" 
                                                 alt="${book.title}" class="product-image">
                                            <div class="product-info">
                                                <h4>${book.title}</h4>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${book.author}</td>
                                    <td>${book.category}</td>
                                    <td>$${book.price}</td>
                                    <td>${book.salesCount}</td>
                                    <td>$${book.revenue}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Recent Orders -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Recent Orders</h3>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Books</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">${fn:substring(order.customerName, 0, 1)}</div>
                                            <div>
                                                <h4>${order.customerName}</h4>
                                                <p>${order.customerEmail}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${order.bookCount} books</td>
                                    <td>$${order.total}</td>
                                    <td>
                                        <span class="status-badge ${order.status.toLowerCase()}">${order.status}</span>
                                    </td>
                                    <td>${order.orderDate}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Popular Categories -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3>Popular Book Categories</h3>
                    </div>
                    <div class="chart-container" style="height: 300px;">
                        <canvas id="categoriesChart"></canvas>
                    </div>
                    <div class="category-stats">
                        <c:forEach var="category" items="${topCategories}">
                            <div class="stat-item">
                                <span class="stat-label">${category.name}</span>
                                <span class="stat-value">${category.percentage}%</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.0/dist/chart.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        window.ctx = '${pageContext.request.contextPath}';
        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Monthly Sales Chart
            const salesCtx = document.getElementById('salesChart').getContext('2d');
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Book Sales',
                        data: [65, 59, 80, 81, 56, 55, 40, 45, 60, 75, 85, 90],
                        fill: false,
                        borderColor: '#4CAF50',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '$' + value;
                                }
                            }
                        }
                    }
                }
            });

            // Categories Chart
            const categoriesCtx = document.getElementById('categoriesChart').getContext('2d');
            new Chart(categoriesCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Fiction', 'Non-Fiction', 'Academic', 'Children', 'Technology'],
                    datasets: [{
                        data: [30, 25, 20, 15, 10],
                        backgroundColor: [
                            '#FF6384',
                            '#36A2EB',
                            '#FFCE56',
                            '#4BC0C0',
                            '#9966FF'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>