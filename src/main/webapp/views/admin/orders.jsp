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
    
    <style>
        .status-select {
            padding: 5px;
            border-radius: 4px;
            border: 1px solid #ddd;
            margin-right: 10px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.85em;
            font-weight: 500;
        }
        
        .status-badge.warning {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-badge.info {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .status-badge.primary {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .status-badge.success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-badge.danger {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .status-badge.secondary {
            background-color: #e2e3e5;
            color: #383d41;
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
                        <div class="stat-icon orders">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Orders</h3>
                            <p class="stat-value">${totalOrders}</p>
                            <p class="stat-change">+${newOrdersThisMonth} this month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Revenue</h3>
                            <p class="stat-value">$${totalRevenue}</p>
                            <p class="stat-change">+${revenueGrowth}% this month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon customers">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Customers</h3>
                            <p class="stat-value">${totalCustomers}</p>
                            <p class="stat-change">+${newCustomersThisMonth} this month</p>
                        </div>
                    </div>
                </div>

                <!-- Orders Table -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Orders Management</h3>
                        <div class="table-actions">
                            <div class="filters">
                                <select class="form-control" id="orderStatusFilter">
                                    <option value="">All Order Status</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Processing">Processing</option>
                                    <option value="Shipped">Shipped</option>
                                    <option value="Delivered">Delivered</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                                <select class="form-control" id="paymentStatusFilter">
                                    <option value="">All Payment Status</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Failed">Failed</option>
                                    <option value="Refunded">Refunded</option>
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
                                <tr data-order-id="${order.orderId}">
                                    <td>Order #${order.orderId}</td>
                                    <td>${order.user.name}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>$${order.totalAmount}</td>
                                    <td>
                                        <select class="status-select" onchange="updatePaymentStatus('${order.orderId}', this.value)">
                                            <option value="Pending" ${orderPaymentStatus[order.orderId] == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Completed" ${orderPaymentStatus[order.orderId] == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Failed" ${orderPaymentStatus[order.orderId] == 'Failed' ? 'selected' : ''}>Failed</option>
                                            <option value="Refunded" ${orderPaymentStatus[order.orderId] == 'Refunded' ? 'selected' : ''}>Refunded</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select class="status-select" onchange="updateOrderStatus('${order.orderId}', this.value)">
                                            <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                            <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                            <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                            <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </td>
                                    <td>
                                        <button class="btn-icon" onclick="viewOrder('${order.orderId}')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn-icon" onclick="deleteOrder('${order.orderId}')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
    <script>
        // Define window.ctx for all JavaScript functions
        window.ctx = '${pageContext.request.contextPath}';
        console.log('window.ctx:', window.ctx);

        // Modal functions
        function openModal() {z
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

            const params = new URLSearchParams();
            params.append('orderId', orderId);
            params.append('orderStatus', newStatus);

            fetch(window.ctx + '/orders', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showNotification(data.message || 'Order status updated successfully', 'success');
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
                            badge.textContent = newStatus;
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

            const url = window.ctx + '/orders?orderId=' + id;
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

                document.getElementById('modalTitle').textContent = `Order Details - #${order.orderId}`;
                document.getElementById('orderId').value = order.orderId;
                document.getElementById('customerName').value = order.user ? order.user.name : '';
                document.getElementById('orderDate').value = order.orderDate || '';
                document.getElementById('orderTotal').value = order.totalAmount ? `$${order.totalAmount}` : '$0.00';
                document.getElementById('paymentStatus').value = order.paymentMethod || '';
                document.getElementById('orderStatus').value = order.status || '';
                
                // Populate order items
                const orderItemsList = document.getElementById('orderItemsList');
                if (order.orderItems && order.orderItems.length > 0) {
                    orderItemsList.innerHTML = order.orderItems.map(item => {
                        const book = item.book || {};
                        const productImage = book.picture || '';
                        const productName = book.bookName || '';
                        const quantity = item.quantity || 0;
                        const price = item.price || 0;
                        const total = item.getSubtotal() || 0;
                        
                        return `
                            <tr>
                                <td>
                                    <div class="product-item">
                                        <img src="${productImage}" alt="${productName}" class="product-image">
                                        <div class="product-info">
                                            <h4>${productName}</h4>
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

            fetch(window.ctx + '/orders?orderId=' + orderId, {
                method: 'DELETE',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success || data.message) {
                    showNotification(data.message || 'Order deleted successfully', 'success');
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

        function updatePaymentStatus(orderId, newStatus) {
            console.log('Attempting to update payment status for Order ID:', orderId, 'to status:', newStatus);
            if (!orderId) {
                console.error('Order ID is missing for status update');
                showNotification('Error: Order ID is missing for payment status update.', 'error');
                return;
            }
            if (!newStatus) {
                console.error('New status is missing for order ID:', orderId);
                showNotification('Error: New status is missing for payment status update.', 'error');
                return;
            }

            const params = new URLSearchParams();
            params.append('orderId', orderId);
            params.append('status', newStatus);

            fetch(window.ctx + '/admin/update-payment-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: params
            })
            .then(async response => {
                const responseText = await response.text();
                console.log('Raw server response:', responseText);
                
                if (!response.ok) {
                    throw new Error(`Server responded with ${response.status}: ${responseText}`);
                }
                
                try {
                    return JSON.parse(responseText);
                } catch (e) {
                    console.error('Failed to parse server response as JSON:', e);
                    throw new Error('Server returned invalid JSON response');
                }
            })
            .then(data => {
                if (data.success) {
                    showNotification(data.message || 'Payment status updated successfully', 'success');
                } else {
                    throw new Error(data.error || 'Failed to update payment status');
                }
            })
            .catch(error => {
                console.error('Error updating payment status:', error);
                showNotification(error.message || 'Error updating payment status', 'error');
            });
        }

        // Initialize filters
        document.addEventListener('DOMContentLoaded', function() {
            const orderStatusFilter = document.getElementById('orderStatusFilter');
            const paymentStatusFilter = document.getElementById('paymentStatusFilter');
            
            orderStatusFilter.addEventListener('change', filterOrders);
            paymentStatusFilter.addEventListener('change', filterOrders);
        });

        function filterOrders() {
            const orderStatus = document.getElementById('orderStatusFilter').value;
            const paymentStatus = document.getElementById('paymentStatusFilter').value;
            
            const rows = document.querySelectorAll('.data-table tbody tr');
            rows.forEach(row => {
                const rowOrderStatus = row.querySelector('td:nth-child(6) select').value;
                const rowPaymentStatus = row.querySelector('td:nth-child(5) select').value;
                
                const orderStatusMatch = !orderStatus || rowOrderStatus === orderStatus;
                const paymentStatusMatch = !paymentStatus || rowPaymentStatus === paymentStatus;
                
                row.style.display = orderStatusMatch && paymentStatusMatch ? '' : 'none';
            });
        }
    </script>
</body>
</html> 