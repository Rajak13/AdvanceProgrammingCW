<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.css">
    <style>
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            display: flex;
            align-items: center;
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-right: 20px;
            flex-shrink: 0;
        }
        
        .revenue-icon {
            background-color: #e7f5ea;
            color: #28a745;
        }
        
        .orders-icon {
            background-color: #e7eeff;
            color: #0d6efd;
        }
        
        .books-icon {
            background-color: #fff4e5;
            color: #fd7e14;
        }
        
        .users-icon {
            background-color: #f5e7ef;
            color: #d63384;
        }
        
        .stat-data {
            flex-grow: 1;
        }
        
        .stat-title {
            color: #6c757d;
            font-size: 14px;
            margin: 0 0 5px 0;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }
        
        .stat-change {
            font-size: 12px;
            display: flex;
            align-items: center;
            margin-top: 5px;
        }
        
        .stat-change.positive {
            color: #28a745;
        }
        
        .stat-change.negative {
            color: #dc3545;
        }
        
        .chart-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(480px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chart-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .chart-title {
            font-size: 18px;
            font-weight: bold;
            margin: 0;
        }
        
        .chart-period {
            font-size: 14px;
            color: #6c757d;
        }
        
        .chart-canvas {
            width: 100%;
            height: 300px;
        }
        
        .recent-section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .recent-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .recent-title {
            font-size: 18px;
            font-weight: bold;
            margin: 0;
        }
        
        .view-all {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .view-all:hover {
            text-decoration: underline;
        }
        
        .recent-orders {
            width: 100%;
            border-collapse: collapse;
        }
        
        .recent-orders th, 
        .recent-orders td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .recent-orders th {
            color: #6c757d;
            font-weight: 500;
            font-size: 14px;
        }
        
        .recent-orders tr:last-child td {
            border-bottom: none;
        }
        
        .recent-orders .order-id {
            font-weight: 500;
        }
        
        .recent-orders .order-date {
            color: #6c757d;
            font-size: 14px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-pending {
            background-color: #fff4e5;
            color: #fd7e14;
        }
        
        .status-processing {
            background-color: #e7eeff;
            color: #0d6efd;
        }
        
        .status-delivered {
            background-color: #e7f5ea;
            color: #28a745;
        }
        
        .status-cancelled {
            background-color: #f8d7da;
            color: #dc3545;
        }
        
        .top-selling {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .book-card {
            display: flex;
            flex-direction: column;
        }
        
        .book-cover {
            height: 180px;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 10px;
        }
        
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .book-info {
            flex-grow: 1;
        }
        
        .book-title {
            font-weight: 500;
            margin: 0 0 5px 0;
            font-size: 15px;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .book-author {
            color: #6c757d;
            font-size: 13px;
            margin: 0 0 5px 0;
        }
        
        .book-sales {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .book-price {
            font-weight: 500;
        }
        
        .book-units {
            font-size: 13px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Include sidebar -->
        <jsp:include page="common/sidebar.jsp">
            <jsp:param name="active" value="dashboard" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Dashboard</h1>
                <div class="date-filter">
                    <select id="periodFilter">
                        <option value="today">Today</option>
                        <option value="week" selected>This Week</option>
                        <option value="month">This Month</option>
                        <option value="year">This Year</option>
                    </select>
                </div>
            </div>

            <div class="content-body">
                <!-- Stats Cards -->
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon revenue-icon">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-data">
                            <h3 class="stat-title">Total Revenue</h3>
                            <p class="stat-value">$${stats.revenue}</p>
                            <div class="stat-change ${stats.revenueChange >= 0 ? 'positive' : 'negative'}">
                                <i class="fas ${stats.revenueChange >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                                ${Math.abs(stats.revenueChange)}% from previous period
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon orders-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stat-data">
                            <h3 class="stat-title">Total Orders</h3>
                            <p class="stat-value">${stats.orders}</p>
                            <div class="stat-change ${stats.ordersChange >= 0 ? 'positive' : 'negative'}">
                                <i class="fas ${stats.ordersChange >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                                ${Math.abs(stats.ordersChange)}% from previous period
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon books-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-data">
                            <h3 class="stat-title">Total Books</h3>
                            <p class="stat-value">${stats.books}</p>
                            <div class="stat-change ${stats.booksChange >= 0 ? 'positive' : 'negative'}">
                                <i class="fas ${stats.booksChange >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                                ${Math.abs(stats.booksChange)}% from previous period
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon users-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-data">
                            <h3 class="stat-title">Total Users</h3>
                            <p class="stat-value">${stats.users}</p>
                            <div class="stat-change ${stats.usersChange >= 0 ? 'positive' : 'negative'}">
                                <i class="fas ${stats.usersChange >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                                ${Math.abs(stats.usersChange)}% from previous period
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Charts -->
                <div class="chart-container">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Sales Overview</h3>
                            <span class="chart-period" id="salesChartPeriod">This Week</span>
                        </div>
                        <canvas id="salesChart" class="chart-canvas"></canvas>
                    </div>
                    
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Category Distribution</h3>
                            <span class="chart-period">All Time</span>
                        </div>
                        <canvas id="categoriesChart" class="chart-canvas"></canvas>
                    </div>
                </div>
                
                <!-- Recent Orders -->
                <div class="recent-section">
                    <div class="recent-header">
                        <h3 class="recent-title">Recent Orders</h3>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="view-all">View All Orders</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty recentOrders}">
                            <p>No recent orders found.</p>
                        </c:when>
                        <c:otherwise>
                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${recentOrders}" var="order">
                                        <tr>
                                            <td class="order-id">#${order.id}</td>
                                            <td>${order.user.name}</td>
                                            <td class="order-date">
                                                <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy" />
                                            </td>
                                            <td>$${order.totalAmount}</td>
                                            <td>
                                                <span class="status-badge status-${fn:toLowerCase(order.status)}">${order.status}</span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/orders/view?id=${order.id}" class="btn btn-sm btn-primary">
                                                    View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Top Selling Books -->
                <div class="recent-section">
                    <div class="recent-header">
                        <h3 class="recent-title">Top Selling Books</h3>
                        <a href="${pageContext.request.contextPath}/admin/books" class="view-all">View All Books</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty topBooks}">
                            <p>No book sales data available.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="top-selling">
                                <c:forEach items="${topBooks}" var="book">
                                    <div class="book-card">
                                        <div class="book-cover">
                                            <img src="${pageContext.request.contextPath}${book.picture}" alt="${book.bookName}">
                                        </div>
                                        <div class="book-info">
                                            <h4 class="book-title">${book.bookName}</h4>
                                            <p class="book-author">by ${book.writerName}</p>
                                            <div class="book-sales">
                                                <span class="book-price">$${book.price}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    <script>
    // Toggle sidebar
    document.getElementById('toggleSidebar').addEventListener('click', function() {
        document.querySelector('.sidebar').classList.toggle('collapsed');
        document.querySelector('.main-content').classList.toggle('expanded');
    });
    
    // Period filter
    document.getElementById('periodFilter').addEventListener('change', function() {
        // In a real scenario, this would update the dashboard data
        const selectedPeriod = this.value;
        document.getElementById('salesChartPeriod').textContent = 
            selectedPeriod === 'today' ? 'Today' :
            selectedPeriod === 'week' ? 'This Week' :
            selectedPeriod === 'month' ? 'This Month' : 'This Year';
        
        // This would send a request to server to get updated data
        // For now, let's just reload the page with a parameter
        window.location.href = '${pageContext.request.contextPath}/admin/dashboard?period=' + selectedPeriod;
    });
    
    // Set up Charts
    document.addEventListener('DOMContentLoaded', function() {
        // Sales Chart
        const salesCtx = document.getElementById('salesChart').getContext('2d');
        //<![CDATA[
        const salesChart = new Chart(salesCtx, {
            type: 'line',
            data: {
                labels: ${salesChartLabels},
                datasets: [{
                    label: 'Sales',
                    data: ${salesChartData},
                    backgroundColor: 'rgba(13, 110, 253, 0.1)',
                    borderColor: 'rgba(13, 110, 253, 1)',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: 'rgba(13, 110, 253, 1)',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.7)',
                        padding: 10,
                        titleColor: '#ffffff',
                        titleFont: {
                            size: 14
                        },
                        bodyColor: '#ffffff',
                        bodyFont: {
                            size: 13
                        },
                        displayColors: false,
                        callbacks: {
                            label: function(context) {
                                return '$ ' + context.parsed.y;
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            font: {
                                size: 12
                            }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        },
                        ticks: {
                            font: {
                                size: 12
                            },
                            callback: function(value) {
                                return '$ ' + value;
                            }
                        }
                    }
                }
            }
        });
        
        // Categories Chart
        const categoriesCtx = document.getElementById('categoriesChart').getContext('2d');
        const categoriesChart = new Chart(categoriesCtx, {
            type: 'doughnut',
            data: {
                labels: ${categoryLabels},
                datasets: [{
                    data: ${categoryData},
                    backgroundColor: [
                        '#0d6efd',
                        '#fd7e14',
                        '#28a745',
                        '#d63384',
                        '#20c997',
                        '#6f42c1',
                        '#ffc107',
                        '#6c757d'
                    ],
                    borderWidth: 1,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            font: {
                                size: 13
                            },
                            boxWidth: 15,
                            padding: 15
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.7)',
                        padding: 10,
                        titleColor: '#ffffff',
                        titleFont: {
                            size: 14
                        },
                        bodyColor: '#ffffff',
                        bodyFont: {
                            size: 13
                        },
                        displayColors: false
                    }
                },
                cutout: '70%'
            }
        });
        //]]>
    });
    </script>
</body>
</html> 