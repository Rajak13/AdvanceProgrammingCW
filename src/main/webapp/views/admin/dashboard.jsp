<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <style>
        .dashboard-content {
            padding: 2rem;
            background: #f8f9fa;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            transition: transform 0.2s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1.5rem;
        }
        
        .stat-icon.sales { background: #e3f2fd; color: #1976d2; }
        .stat-icon.customers { background: #e8f5e9; color: #2e7d32; }
        .stat-icon.revenue { background: #fff3e0; color: #f57c00; }
        .stat-icon.orders { background: #fce4ec; color: #c2185b; }
        
        .stat-info h3 {
            margin: 0;
            font-size: 0.9rem;
            color: #666;
        }
        
        .stat-value {
            font-size: 1.8rem;
            font-weight: 600;
            margin: 0.5rem 0;
            color: #333;
        }
        
        .stat-change {
            font-size: 0.85rem;
            color: #4caf50;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .stat-change.negative {
            color: #f44336;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .chart-header h3 {
            margin: 0;
            font-size: 1.1rem;
            color: #333;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
        }
        
        .table-container {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }
        
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .data-table th {
            text-align: left;
            padding: 1rem;
            background: #f8f9fa;
            font-weight: 500;
            color: #666;
        }
        
        .data-table td {
            padding: 1rem;
            border-bottom: 1px solid #eee;
        }
        
        .product-item {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .product-image {
            width: 50px;
            height: 70px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .status-badge.pending { background: #fff3e0; color: #f57c00; }
        .status-badge.completed { background: #e8f5e9; color: #2e7d32; }
        .status-badge.cancelled { background: #ffebee; color: #c62828; }
        
        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .quick-stat {
            background: white;
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .quick-stat h4 {
            margin: 0;
            font-size: 0.9rem;
            color: #666;
        }
        
        .quick-stat p {
            margin: 0.5rem 0 0;
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
        }

        .stock-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            background-color: #e0e0e0;
            color: #333;
        }

        .stock-badge.low-stock {
            background-color: #ffccbc;
            color: #d32f2f;
        }

        .btn-view-all {
            padding: 0.5rem 1rem;
            background-color: #007bff;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background-color 0.2s ease-in-out;
        }

        .btn-view-all:hover {
            background-color: #0056b3;
        }

        .customer-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .customer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #e0e0e0;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <jsp:include page="common/sidebar.jsp" />
        
        <main class="admin-main">
            <jsp:include page="common/header.jsp" />

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
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon customers">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Customers</h3>
                            <p class="stat-value">${totalCustomers}</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Revenue</h3>
                            <p class="stat-value">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                            </p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon orders">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Orders</h3>
                            <p class="stat-value">${totalOrders}</p>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="quick-stats">
                    <div class="quick-stat">
                        <h4>Average Order Value</h4>
                        <p><fmt:formatNumber value="${averageOrderValue}" type="currency" currencySymbol="$"/></p>
                    </div>
                    <div class="quick-stat">
                        <h4>Books Sold Today</h4>
                        <p>${booksSoldToday}</p>
                    </div>
                    <div class="quick-stat">
                        <h4>Pending Orders</h4>
                        <p>${pendingOrders}</p>
                    </div>
                    <div class="quick-stat">
                        <h4>Low Stock Books</h4>
                        <p>${lowStockBooks}</p>
                    </div>
                </div>

                <!-- Charts Grid -->
                <div class="dashboard-grid">
                    <!-- Sales Trend Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Sales Trend (Last 6 Months)</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="salesTrendChart"></canvas>
                        </div>
                    </div>

                    <!-- Category Distribution -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Book Categories Distribution</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="categoryDistributionChart"></canvas>
                        </div>
                    </div>

                    <!-- Monthly Revenue -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Monthly Revenue</h3>
                            </div>
                        <div class="chart-container">
                            <canvas id="monthlyRevenueChart"></canvas>
                            </div>
                            </div>

                    <!-- Customer Growth -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Customer Growth</h3>
                            </div>
                        <div class="chart-container">
                            <canvas id="customerGrowthChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Top Selling Books -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Top Selling Books</h3>
                        <div class="table-actions">
                            <div class="search-bar">
                                <input type="text" placeholder="Search books..." id="bookSearch">
                                <button><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                    </div>
                    <table class="data-table" id="topBooksTable">
                        <thead>
                            <tr>
                                <th>Book</th>
                                <th>Author</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Sales</th>
                                <th>Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${topSellingBooks}">
                                <tr>
                                    <td>
                                        <div class="product-item">
                                            <img src="${pageContext.request.contextPath}${book.picture}" 
                                                 alt="${book.bookName}" class="product-image">
                                            <div class="product-info">
                                                <h4>${book.bookName}</h4>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${book.writerName}</td>
                                    <td>${book.categoryName}</td>
                                    <td><fmt:formatNumber value="${book.price}" type="currency" currencySymbol="$"/></td>
                                    <td>
                                        <span class="stock-badge ${book.stock < 10 ? 'low-stock' : ''}">
                                            ${book.stock}
                                        </span>
                                    </td>
                                    <td>${book.salesCount}</td>
                                    <td><fmt:formatNumber value="${book.revenue}" type="currency" currencySymbol="$"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Recent Orders -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Recent Orders</h3>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn-view-all">
                            View All Orders
                        </a>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Books</th>
                                <th>Total</th>
                                <th>Payment Status</th>
                                <th>Order Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>#${order.orderId}</td>
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
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$"/></td>
                                    <td>
                                        <span class="status-badge ${order.paymentStatus != null ? order.paymentStatus.toLowerCase() : 'unknown'}">
                                            ${order.paymentStatus != null ? order.paymentStatus : 'N/A'}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${order.status.toLowerCase()}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        // Initialize DataTables
        $(document).ready(function() {
            // Destroy existing DataTable instance if it exists
            if ($.fn.DataTable.isDataTable('#topBooksTable')) {
                $('#topBooksTable').DataTable().destroy();
            }
            
            $('#topBooksTable').DataTable({
                order: [[5, 'desc']], // Sort by sales by default
                pageLength: 5,
                lengthMenu: [[5, 10, 25, 50], [5, 10, 25, 50]]
            });
        });

        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Sales Trend Chart
            new Chart(document.getElementById('salesTrendChart'), {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'], // Static Labels
                    datasets: [{
                        label: 'Sales',
                        data: [1500, 1800, 1600, 2000, 2200, 2500], // Static Data
                        borderColor: '#1976d2',
                        backgroundColor: 'rgba(25, 118, 210, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
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

            // Category Distribution Chart
            new Chart(document.getElementById('categoryDistributionChart'), {
                type: 'doughnut',
                data: {
                    labels: ['Fiction', 'Non-Fiction', 'Academic', 'Children', 'Technology'], // Static Labels
                    datasets: [{
                        data: [30, 25, 20, 15, 10], // Static Data
                        backgroundColor: [
                            '#1976d2',
                            '#2e7d32',
                            '#f57c00',
                            '#c2185b',
                            '#7b1fa2',
                            '#d32f2f'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right'
                        }
                    }
                }
            });

            // Monthly Revenue Chart
            new Chart(document.getElementById('monthlyRevenueChart'), {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'], // Static Labels
                    datasets: [{
                        label: 'Revenue',
                        data: [1200, 1500, 1300, 1700, 1900, 2100], // Static Data
                        backgroundColor: '#f57c00',
                        borderRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
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

            // Customer Growth Chart
            new Chart(document.getElementById('customerGrowthChart'), {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'], // Static Labels
                    datasets: [{
                        label: 'New Customers',
                        data: [10, 12, 8, 15, 18, 20], // Static Data
                        borderColor: '#2e7d32',
                        backgroundColor: 'rgba(46, 125, 50, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>