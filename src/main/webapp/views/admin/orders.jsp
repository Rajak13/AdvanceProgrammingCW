<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders Management - Panna Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    <script>
        // Define window.ctx for all JavaScript functions
        window.ctx = '${pageContext.request.contextPath}';

        // Modal functions
        function openModal() {
            document.getElementById('orderModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('orderModal').style.display = 'none';
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transition = 'opacity 0.3s ease-in-out';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }

        // Status helper function
        function getStatusClass(status) {
            switch(status) {
                case 'Pending': return 'warning';
                case 'Processing': return 'info';
                case 'Shipped': return 'primary';
                case 'Delivered': return 'success';
                case 'Cancelled': return 'danger';
                default: return 'secondary';
            }
        }

        // Order management functions
        function updateOrderStatus(orderId, newStatus) {
            if (!orderId || !newStatus) {
                console.error('Order ID or status is missing');
                showNotification('Order ID or status is missing', 'error');
                return;
            }

            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('orderStatus', newStatus);

            fetch(`${window.ctx}/admin/orders`, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showNotification('Order status updated successfully', 'success');
                    // Update the status badge color
                    const statusCell = document.querySelector(`select[onchange*="${orderId}"]`).closest('td');
                    if (statusCell) {
                        const badge = statusCell.querySelector('.status-badge');
                        if (badge) {
                            let statusClass = 'secondary';
                            switch(newStatus) {
                                case 'Pending': statusClass = 'warning'; break;
                                case 'Processing': statusClass = 'info'; break;
                                case 'Shipped': statusClass = 'primary'; break;
                                case 'Delivered': statusClass = 'success'; break;
                                case 'Cancelled': statusClass = 'danger'; break;
                            }
                            badge.className = `status-badge ${statusClass}`;
                        }
                    }
                } else {
                    throw new Error(data.error || 'Failed to update order status');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification(error.message || 'Error updating order status', 'error');
            });
        }

        function viewOrder(id) {
            if (!id) {
                console.error('Order ID is missing');
                showNotification('Order ID is missing', 'error');
                return;
            }

            const url = `${window.ctx}/admin/orders?orderId=${id}`;
            fetch(url, { 
                headers: { 'Accept': 'application/json' }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(order => {
                if (!order) {
                    throw new Error('Order not found');
                }

                document.getElementById('modalTitle').textContent = `Order Details - #${order.id}`;
                document.getElementById('orderId').value = order.id;
                document.getElementById('customerName').value = order.customerName || '';
                document.getElementById('orderDate').value = order.orderDate || '';
                document.getElementById('orderTotal').value = order.total ? `$${order.total}` : '$0.00';
                document.getElementById('paymentStatus').value = order.paymentMethod || '';
                document.getElementById('orderStatus').value = order.status || '';
                
                // Populate order items
                const orderItemsList = document.getElementById('orderItemsList');
                if (order.items && order.items.length > 0) {
                    orderItemsList.innerHTML = order.items.map(item => {
                        const productImage = item.productImage || '';
                        const productName = item.productName || '';
                        const sku = item.sku || '';
                        const quantity = item.quantity || 0;
                        const price = item.price || 0;
                        const total = item.total || 0;
                        
                        return `
                            <tr>
                                <td>
                                    <div class="product-item">
                                        <img src="${productImage}" alt="${productName}" class="product-image">
                                        <div class="product-info">
                                            <h4>${productName}</h4>
                                            <p>SKU: ${sku}</p>
                                        </div>
                                    </div>
                                </td>
                                <td>${quantity}</td>
                                <td>$${price.toFixed(2)}</td>
                                <td>$${total.toFixed(2)}</td>
                            </tr>
                        `;
                    }).join('');
                } else {
                    orderItemsList.innerHTML = '<tr><td colspan="4">No items found</td></tr>';
                }
                
                openModal();
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification(error.message || 'Error loading order details', 'error');
            });
        }

        function deleteOrder(orderId) {
            if (!orderId) {
                console.error('Order ID is missing');
                showNotification('Order ID is missing', 'error');
                return;
            }

            if (!confirm('Are you sure you want to delete this order? This action cannot be undone.')) {
                return;
            }

            fetch(`${window.ctx}/admin/orders?orderId=${orderId}`, {
                method: 'DELETE'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showNotification('Order deleted successfully', 'success');
                    // Remove the order row from the table
                    const orderRow = document.querySelector(`tr[data-order-id="${orderId}"]`);
                    if (orderRow) {
                        orderRow.remove();
                    } else {
                        location.reload(); // Reload if we can't find the row
                    }
                } else {
                    throw new Error(data.error || 'Failed to delete order');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification(error.message || 'Error deleting order', 'error');
            });
        }

        // Initialize when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Add status filter functionality
            const statusFilter = document.querySelector('select.form-control');
            if (statusFilter) {
                statusFilter.addEventListener('change', function() {
                    const status = this.value;
                    const rows = document.querySelectorAll('.data-table tbody tr');
                    
                    rows.forEach(row => {
                        const statusCell = row.querySelector('td:nth-child(6) .status-badge');
                        if (!status || (statusCell && statusCell.textContent.trim() === status)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
        });
    </script>
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
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Orders</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i>
                            <span>Users</span>
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
        <main class="admin-main">
            <!-- Header -->
            <header class="admin-header">
                <div class="header-left">
                    <button class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="search-bar">
                        <input type="text" placeholder="Search orders...">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                <div class="header-right">
                    <div class="language-selector">
                        <img src="${pageContext.request.contextPath}/assets/images/en-flag.png" alt="English">
                    </div>
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">2</span>
                    </div>
                    <div class="user-profile">
                        <img src="${pageContext.request.contextPath}/assets/images/user-avatar.jpg" alt="User">
                        <span>Aiden Max</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </header>

            <!-- Orders Content -->
            <div class="dashboard-content">
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon orders">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Orders</h3>
                            <p class="stat-value">2,345</p>
                            <p class="stat-change">+25% last month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Revenue</h3>
                            <p class="stat-value">$45,678</p>
                            <p class="stat-change">+20% last month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon customers">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Customers</h3>
                            <p class="stat-value">1,234</p>
                            <p class="stat-change">+15% last month</p>
                        </div>
                    </div>
                </div>


                <!-- Orders Table -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Orders Management</h3>
                        <div class="table-actions">
                            <div class="filters">
                                <select class="form-control">
                                    <option value="">All Status</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Processing">Processing</option>
                                    <option value="Shipped">Shipped</option>
                                    <option value="Delivered">Delivered</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                                <select class="form-control">
                                    <option value="">Payment Status</option>
                                    <option value="paid">Paid</option>
                                    <option value="unpaid">Unpaid</option>
                                    <option value="refunded">Refunded</option>
                                </select>
                            </div>
                            <button class="btn btn-primary" id="exportOrdersBtn">
                                <i class="fas fa-download"></i> Export Orders
                            </button>
                        </div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Order Date</th>
                                <th>Total</th>
                                <th>Payment Status</th>
                                <th>Order Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>
                                        <div class="customer-info">
                                            <img src="${order.customerAvatar}" alt="${order.customerName}" class="customer-avatar">
                                            <div>
                                                <h4>${order.customerName}</h4>
                                                <p>${order.customerEmail}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${order.orderDate}</td>
                                    <td>
                                        $<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" />
                                    </td>
                                    <td>
                                        <span class="status-badge ${order.paymentStatus == 'Completed' ? 'success' : 
                                                                   order.paymentStatus == 'Pending' ? 'warning' : 
                                                                   order.paymentStatus == 'Failed' ? 'danger' : 'secondary'}">
                                            ${order.paymentStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <c:set var="statusClass" value="secondary"/>
                                        <c:choose>
                                            <c:when test="${order.status == 'Pending'}">
                                                <c:set var="statusClass" value="warning"/>
                                            </c:when>
                                            <c:when test="${order.status == 'Processing'}">
                                                <c:set var="statusClass" value="info"/>
                                            </c:when>
                                            <c:when test="${order.status == 'Shipped'}">
                                                <c:set var="statusClass" value="primary"/>
                                            </c:when>
                                            <c:when test="${order.status == 'Delivered'}">
                                                <c:set var="statusClass" value="success"/>
                                            </c:when>
                                            <c:when test="${order.status == 'Cancelled'}">
                                                <c:set var="statusClass" value="danger"/>
                                            </c:when>
                                        </c:choose>
                                        <span class="status-badge ${statusClass}">
                                            <select class="status-select" onchange="updateOrderStatus('${order.id}', this.value)" 
                                                    style="background: transparent; border: none; color: inherit; cursor: pointer;">
                                                <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                                <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                                <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                                <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-icon" onclick="viewOrder('${order.id}')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn-icon" onclick="deleteOrder('${order.id}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <div class="table-info">
                            Showing ${(currentPage - 1) * itemsPerPage + 1} to 
                            ${Math.min(currentPage * itemsPerPage, totalItems)} of ${totalItems} entries
                        </div>
                        <div class="table-pagination">
                            <c:if test="${currentPage > 1}">
                                <button class="pagination-btn" onclick="changePage('${currentPage - 1}')">Previous</button>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <button class="pagination-btn ${currentPage == i ? 'active' : ''}" 
                                        onclick="changePage('${i}')">${i}</button>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <button class="pagination-btn" onclick="changePage('${currentPage + 1}')">Next</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- View/Edit Order Modal -->
    <div class="modal" id="orderModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Order Details</h2>
                <button class="modal-close">&times;</button>
            </div>
            <div class="modal-body">
                <form id="orderForm">
                    <input type="hidden" id="orderId" name="orderId">
                    <div class="form-group">
                        <label for="customerName">Customer Name</label>
                        <input type="text" id="customerName" name="customerName" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label for="orderDate">Order Date</label>
                        <input type="text" id="orderDate" name="orderDate" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label for="orderTotal">Order Total</label>
                        <input type="text" id="orderTotal" name="orderTotal" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label for="paymentStatus">Payment Status</label>
                        <select id="paymentStatus" name="paymentStatus" class="form-control">
                            <option value="Paid">Paid</option>
                            <option value="Unpaid">Unpaid</option>
                            <option value="Refunded">Refunded</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="orderStatus">Order Status</label>
                        <select id="orderStatus" name="orderStatus" class="form-control">
                            <option value="Pending">Pending</option>
                            <option value="Processing">Processing</option>
                            <option value="Shipped">Shipped</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Order Items</label>
                        <div class="order-items-table">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody id="orderItemsList">
                                    <!-- Order items will be populated dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Close</button>
                <button class="btn btn-primary" onclick="saveOrder(document.getElementById('orderId').value)">Update Order</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html> 