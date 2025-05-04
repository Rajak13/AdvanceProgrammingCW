<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders Management - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>Admin Panel</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/books" class="nav-item">
                    <i class="fas fa-book"></i> Books
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="nav-item">
                    <i class="fas fa-tags"></i> Categories
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                    <i class="fas fa-users"></i> Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="nav-item active">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="nav-item">
                    <i class="fas fa-user"></i> Profile
                </a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item">
                    <i class="fas fa-cog"></i> Settings
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <div class="header-left">
                    <h1>Orders Management</h1>
                </div>
                <div class="header-right">
                    <div class="search-bar">
                        <input type="text" placeholder="Search orders...">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">3</span>
                    </div>
                    <div class="user-menu">
                        <img src="${pageContext.request.contextPath}/assets/images/admin-avatar.png" alt="Admin">
                        <span>Admin</span>
                    </div>
                </div>
            </header>

            <!-- Orders Content -->
            <div class="content">
                <!-- Filters -->
                <div class="filters">
                    <div class="filter-group">
                        <button class="filter-btn active">All Orders</button>
                        <button class="filter-btn">Pending</button>
                        <button class="filter-btn">Processing</button>
                        <button class="filter-btn">Completed</button>
                        <button class="filter-btn">Cancelled</button>
                    </div>
                    <div class="filter-group">
                        <select class="filter-select">
                            <option value="">Sort by</option>
                            <option value="newest">Newest First</option>
                            <option value="oldest">Oldest First</option>
                            <option value="price-high">Price: High to Low</option>
                            <option value="price-low">Price: Low to High</option>
                        </select>
                    </div>
                </div>

                <!-- Orders Table -->
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Items</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${order.user.name}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy" /></td>
                                    <td>${order.orderItems.size()} items</td>
                                    <td>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></td>
                                    <td>
                                        <span class="status-badge ${order.status.toLowerCase()}">${order.status}</span>
                                    </td>
                                    <td>
                                        <button class="action-btn view-btn" onclick='viewOrder("${order.id}")'>
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="action-btn edit-btn" onclick='editOrder("${order.id}")'>
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination">
                    <button class="pagination-btn" disabled>
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="pagination-btn active">1</button>
                    <button class="pagination-btn">2</button>
                    <button class="pagination-btn">3</button>
                    <button class="pagination-btn">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
        </main>
    </div>

    <!-- Order Details Modal -->
    <div id="orderModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Order Details</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="order-info">
                    <div class="info-row">
                        <span class="info-label">Order ID:</span>
                        <span class="info-value" id="modalOrderId"></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Customer:</span>
                        <span class="info-value" id="modalCustomer"></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Date:</span>
                        <span class="info-value" id="modalDate"></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Status:</span>
                        <span class="info-value" id="modalStatus"></span>
                    </div>
                </div>

                <div class="order-items">
                    <h3>Order Items</h3>
                    <table class="items-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody id="modalItems">
                            <!-- Items will be populated by JavaScript -->
                        </tbody>
                    </table>
                </div>

                <div class="order-summary">
                    <div class="summary-row">
                        <span class="summary-label">Subtotal:</span>
                        <span class="summary-value" id="modalSubtotal"></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Shipping:</span>
                        <span class="summary-value" id="modalShipping"></span>
                    </div>
                    <div class="summary-row total">
                        <span class="summary-label">Total:</span>
                        <span class="summary-value" id="modalTotal"></span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Close</button>
                <button class="btn btn-primary" onclick="updateOrderStatus()">Update Status</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    <script>
        function viewOrder(orderId) {
            // Fetch order details via AJAX
            fetch(`/admin/orders/${orderId}`)
                .then(response => response.json())
                .then(order => {
                    document.getElementById('modalOrderId').textContent = `#${order.id}`;
                    document.getElementById('modalCustomer').textContent = order.user.name;
                    document.getElementById('modalDate').textContent = new Date(order.orderDate).toLocaleDateString();
                    document.getElementById('modalStatus').textContent = order.status;
                    
                    const itemsTable = document.getElementById('modalItems');
                    itemsTable.innerHTML = '';
                    order.orderItems.forEach(item => {
                        const row = document.createElement('tr');
                        row.innerHTML = `
                            <td>${item.book.title}</td>
                            <td>$${item.pricePerUnit.toFixed(2)}</td>
                            <td>${item.quantity}</td>
                            <td>$${(item.pricePerUnit * item.quantity).toFixed(2)}</td>
                        `;
                        itemsTable.appendChild(row);
                    });

                    document.getElementById('modalSubtotal').textContent = `$${order.totalAmount.toFixed(2)}`;
                    document.getElementById('modalShipping').textContent = '$0.00';
                    document.getElementById('modalTotal').textContent = `$${order.totalAmount.toFixed(2)}`;

                    document.getElementById('orderModal').style.display = 'block';
                })
                .catch(error => console.error('Error:', error));
        }

        function editOrder(orderId) {
            // Redirect to edit page
            window.location.href = `/admin/orders/edit?id=${orderId}`;
        }

        function closeModal() {
            document.getElementById('orderModal').style.display = 'none';
        }

        function updateOrderStatus() {
            const orderId = document.getElementById('modalOrderId').textContent.substring(1);
            const newStatus = document.getElementById('modalStatus').textContent;
            
            fetch(`/admin/orders/${orderId}/status`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ status: newStatus })
            })
            .then(response => {
                if (response.ok) {
                    closeModal();
                    location.reload();
                }
            })
            .catch(error => console.error('Error:', error));
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('orderModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html> 