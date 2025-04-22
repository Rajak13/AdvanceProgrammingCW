<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Panna BookStore Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- Include sidebar -->
        <jsp:include page="common/sidebar.jsp">
            <jsp:param name="active" value="orders" />
        </jsp:include>
        
        <!-- Main Content -->
        <div class="main-content" id="adminContent">
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>
            
            <!-- Header -->
            <header class="admin-header">
                <div class="header-title">
                    <h1>Order Management</h1>
                </div>
                <div class="header-actions">
                    <div class="user-info">
                        <c:if test="${sessionScope.user != null}">
                            <div class="user-avatar">${sessionScope.user.name.substring(0, 1).toUpperCase()}</div>
                            <div class="user-details">
                                <h4>${sessionScope.user.name}</h4>
                                <p>${sessionScope.user.email}</p>
                            </div>
                        </c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </header>
            
            <!-- Main Content Area -->
            <main class="admin-main">
                <div class="page-header">
                    <h2>Manage Orders</h2>
                    <div class="search-filter">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search by Order ID or Customer...">
                        <select id="statusFilter" class="form-control">
                            <option value="">All Statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="PROCESSING">Processing</option>
                            <option value="SHIPPED">Shipped</option>
                            <option value="DELIVERED">Delivered</option>
                            <option value="CANCELLED">Cancelled</option>
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
                                    <td>#${order.orderId}</td>
                                    <td>
                                        <div class="user-info-row">
                                            <div class="user-avatar small">${order.customer.name.substring(0, 1).toUpperCase()}</div>
                                            <span>${order.customer.name}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy" />
                                        <div class="small-text"><fmt:formatDate value="${order.orderDate}" pattern="hh:mm a" /></div>
                                    </td>
                                    <td>${order.itemCount}</td>
                                    <td>₹${order.totalAmount}</td>
                                    <td>
                                        <span class="status-badge status-${order.status.toLowerCase()}">${order.status}</span>
                                    </td>
                                    <td class="actions">
                                        <button class="btn-icon view-btn" data-id="${order.orderId}" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <c:if test="${order.status != 'DELIVERED' && order.status != 'CANCELLED'}">
                                            <button class="btn-icon update-btn" data-id="${order.orderId}" title="Update Status">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn-icon invoice-btn" data-id="${order.orderId}" title="Invoice">
                                            <i class="fas fa-file-invoice"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <!-- No Orders Message -->
                <c:if test="${empty orders}">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <h3>No Orders Found</h3>
                        <p>There are no orders matching your search criteria.</p>
                    </div>
                </c:if>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/admin/orders?page=${i}" class="${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>
                    </div>
                </c:if>
            </main>
        </div>
    </div>
    
    <!-- View Order Modal -->
    <div class="modal" id="viewOrderModal">
        <div class="modal-content order-detail-modal">
            <div class="modal-header">
                <h2>Order Details</h2>
                <button class="close-btn" id="closeViewModal">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="order-info-section">
                    <div class="order-header">
                        <div>
                            <h3>Order #<span id="orderIdDetail"></span></h3>
                            <div class="order-date" id="orderDateDetail"></div>
                        </div>
                        <div>
                            <span class="status-badge" id="orderStatusBadge"></span>
                        </div>
                    </div>
                    
                    <div class="info-columns">
                        <div class="info-column">
                            <h4>Customer Information</h4>
                            <div class="info-group">
                                <div class="info-item">
                                    <span class="info-label">Name:</span>
                                    <span class="info-value" id="customerName"></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Email:</span>
                                    <span class="info-value" id="customerEmail"></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Phone:</span>
                                    <span class="info-value" id="customerPhone"></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-column">
                            <h4>Shipping Address</h4>
                            <div class="info-group">
                                <div class="info-value address-block" id="shippingAddress"></div>
                            </div>
                        </div>
                        
                        <div class="info-column">
                            <h4>Payment Information</h4>
                            <div class="info-group">
                                <div class="info-item">
                                    <span class="info-label">Method:</span>
                                    <span class="info-value" id="paymentMethod"></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Status:</span>
                                    <span class="info-value" id="paymentStatus"></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Transaction ID:</span>
                                    <span class="info-value" id="transactionId"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="order-items-section">
                    <h4>Order Items</h4>
                    <div class="order-items" id="orderItems">
                        <!-- Order items will be populated here -->
                    </div>
                </div>
                
                <div class="order-summary-section">
                    <h4>Order Summary</h4>
                    <div class="order-summary">
                        <div class="summary-item">
                            <span class="summary-label">Subtotal:</span>
                            <span class="summary-value" id="subtotal"></span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Shipping:</span>
                            <span class="summary-value" id="shipping"></span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Tax:</span>
                            <span class="summary-value" id="tax"></span>
                        </div>
                        <div class="summary-item total">
                            <span class="summary-label">Total:</span>
                            <span class="summary-value" id="total"></span>
                        </div>
                    </div>
                </div>
                
                <div class="order-timeline-section">
                    <h4>Order Timeline</h4>
                    <div class="order-timeline" id="orderTimeline">
                        <!-- Timeline will be populated here -->
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="closeViewBtn">Close</button>
                <button class="btn btn-primary" id="printOrderBtn">Print Order</button>
            </div>
        </div>
    </div>
    
    <!-- Update Status Modal -->
    <div class="modal" id="updateStatusModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Update Order Status</h2>
                <button class="close-btn" id="closeUpdateModal">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <form id="statusForm" action="${pageContext.request.contextPath}/admin/orders/updateStatus" method="post">
                    <input type="hidden" id="updateOrderId" name="orderId">
                    
                    <div class="form-group">
                        <label class="form-label" for="orderStatus">Status</label>
                        <select class="form-control" id="orderStatus" name="status" required>
                            <option value="PENDING">Pending</option>
                            <option value="PROCESSING">Processing</option>
                            <option value="SHIPPED">Shipped</option>
                            <option value="DELIVERED">Delivered</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="trackingNumber">Tracking Number (optional)</label>
                        <input type="text" class="form-control" id="trackingNumber" name="trackingNumber">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="statusNotes">Notes (optional)</label>
                        <textarea class="form-control" id="statusNotes" name="notes" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="cancelUpdateBtn">Cancel</button>
                <button class="btn btn-primary" id="saveStatusBtn">Update Status</button>
            </div>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sidebar toggle
            const sidebarToggle = document.getElementById('sidebarToggle');
            const adminSidebar = document.getElementById('adminSidebar');
            const adminContent = document.getElementById('adminContent');
            
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    adminSidebar.classList.toggle('active');
                    adminContent.classList.toggle('sidebar-active');
                });
            }
            
            // Search functionality
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('keyup', function(e) {
                    if (e.key === 'Enter') {
                        const searchTerm = this.value.trim();
                        const statusFilter = document.getElementById('statusFilter').value;
                        window.location.href = `${pageContext.request.contextPath}/admin/orders?search=${searchTerm}&status=${statusFilter}`;
                    }
                });
            }
            
            // Status filter
            const statusFilter = document.getElementById('statusFilter');
            if (statusFilter) {
                statusFilter.addEventListener('change', function() {
                    const searchTerm = document.getElementById('searchInput').value.trim();
                    window.location.href = `${pageContext.request.contextPath}/admin/orders?search=${searchTerm}&status=${this.value}`;
                });
            }
            
            // View order modal
            const viewModal = document.getElementById('viewOrderModal');
            const viewBtns = document.querySelectorAll('.view-btn');
            const closeViewModal = document.getElementById('closeViewModal');
            const closeViewBtn = document.getElementById('closeViewBtn');
            
            // View buttons click event
            viewBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    // Fetch order data
                    fetch(`${pageContext.request.contextPath}/admin/orders/get?id=${id}`)
                        .then(response => response.json())
                        .then(data => {
                            // Populate modal with order data
                            document.getElementById('orderIdDetail').textContent = data.orderId;
                            document.getElementById('orderDateDetail').textContent = new Date(data.orderDate).toLocaleString();
                            
                            const statusBadge = document.getElementById('orderStatusBadge');
                            statusBadge.textContent = data.status;
                            statusBadge.className = `status-badge status-${data.status.toLowerCase()}`;
                            
                            document.getElementById('customerName').textContent = data.customer.name;
                            document.getElementById('customerEmail').textContent = data.customer.email;
                            document.getElementById('customerPhone').textContent = data.customer.contact || 'Not provided';
                            
                            document.getElementById('shippingAddress').textContent = data.shippingAddress || 'Not provided';
                            
                            document.getElementById('paymentMethod').textContent = data.paymentMethod || 'Not provided';
                            document.getElementById('paymentStatus').textContent = data.paymentStatus || 'Not provided';
                            document.getElementById('transactionId').textContent = data.transactionId || 'Not provided';
                            
                            // Populate order items
                            const orderItemsContainer = document.getElementById('orderItems');
                            orderItemsContainer.innerHTML = '';
                            
                            data.items.forEach(item => {
                                const itemElement = document.createElement('div');
                                itemElement.className = 'order-item';
                                itemElement.innerHTML = `
                                    <div class="item-image">
                                        <img src="${pageContext.request.contextPath}${item.book.coverImage}" alt="${item.book.title}">
                                    </div>
                                    <div class="item-details">
                                        <h5>${item.book.title}</h5>
                                        <p>Author: ${item.book.author}</p>
                                        <p>Quantity: ${item.quantity}</p>
                                    </div>
                                    <div class="item-price">₹${item.price}</div>
                                `;
                                orderItemsContainer.appendChild(itemElement);
                            });
                            
                            // Populate order summary
                            document.getElementById('subtotal').textContent = `₹${data.subtotal}`;
                            document.getElementById('shipping').textContent = `₹${data.shippingCost}`;
                            document.getElementById('tax').textContent = `₹${data.tax}`;
                            document.getElementById('total').textContent = `₹${data.totalAmount}`;
                            
                            // Populate order timeline
                            const timelineContainer = document.getElementById('orderTimeline');
                            timelineContainer.innerHTML = '';
                            
                            data.statusHistory.forEach(status => {
                                const timelineElement = document.createElement('div');
                                timelineElement.className = 'timeline-item';
                                timelineElement.innerHTML = `
                                    <div class="timeline-icon status-${status.status.toLowerCase()}">
                                        <i class="fas fa-circle"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <h5>${status.status}</h5>
                                        <p>${new Date(status.timestamp).toLocaleString()}</p>
                                        ${status.notes ? `<p class="timeline-notes">${status.notes}</p>` : ''}
                                    </div>
                                `;
                                timelineContainer.appendChild(timelineElement);
                            });
                            
                            // Show modal
                            viewModal.style.display = 'block';
                        });
                });
            });
            
            // Close view modal
            if (closeViewModal) {
                closeViewModal.addEventListener('click', function() {
                    viewModal.style.display = 'none';
                });
            }
            
            if (closeViewBtn) {
                closeViewBtn.addEventListener('click', function() {
                    viewModal.style.display = 'none';
                });
            }
            
            // Print order
            const printOrderBtn = document.getElementById('printOrderBtn');
            if (printOrderBtn) {
                printOrderBtn.addEventListener('click', function() {
                    const orderId = document.getElementById('orderIdDetail').textContent;
                    window.open(`${pageContext.request.contextPath}/admin/orders/print?id=${orderId}`, '_blank');
                });
            }
            
            // Update status modal
            const updateModal = document.getElementById('updateStatusModal');
            const updateBtns = document.querySelectorAll('.update-btn');
            const closeUpdateModal = document.getElementById('closeUpdateModal');
            const cancelUpdateBtn = document.getElementById('cancelUpdateBtn');
            const saveStatusBtn = document.getElementById('saveStatusBtn');
            const statusForm = document.getElementById('statusForm');
            
            // Update status buttons click event
            updateBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    document.getElementById('updateOrderId').value = id;
                    
                    // Fetch current status
                    fetch(`${pageContext.request.contextPath}/admin/orders/get?id=${id}`)
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById('orderStatus').value = data.status;
                            updateModal.style.display = 'block';
                        });
                });
            });
            
            // Close update modal
            if (closeUpdateModal) {
                closeUpdateModal.addEventListener('click', function() {
                    updateModal.style.display = 'none';
                });
            }
            
            if (cancelUpdateBtn) {
                cancelUpdateBtn.addEventListener('click', function() {
                    updateModal.style.display = 'none';
                });
            }
            
            // Save status
            if (saveStatusBtn) {
                saveStatusBtn.addEventListener('click', function() {
                    statusForm.submit();
                });
            }
            
            // Invoice buttons click event
            const invoiceBtns = document.querySelectorAll('.invoice-btn');
            invoiceBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    window.open(`${pageContext.request.contextPath}/admin/orders/invoice?id=${id}`, '_blank');
                });
            });
            
            // Close modals when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === viewModal) {
                    viewModal.style.display = 'none';
                }
                if (event.target === updateModal) {
                    updateModal.style.display = 'none';
                }
            });
        });
    </script>
    
    <style>
        /* Order-specific styles */
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        
        .status-processing {
            background-color: #cff4fc;
            color: #055160;
        }
        
        .status-shipped {
            background-color: #fff3cd;
            color: #664d03;
        }
        
        .status-delivered {
            background-color: #d1e7dd;
            color: #0f5132;
        }
        
        .status-cancelled {
            background-color: #f8d7da;
            color: #842029;
        }
        
        .order-detail-modal {
            max-width: 900px;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .order-date {
            color: #6c757d;
            font-size: 14px;
        }
        
        .info-columns {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-column h4 {
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .info-item {
            margin-bottom: 5px;
        }
        
        .info-label {
            font-weight: 600;
            margin-right: 5px;
        }
        
        .address-block {
            white-space: pre-line;
        }
        
        .order-items-section {
            margin-bottom: 30px;
        }
        
        .order-item {
            display: flex;
            border-bottom: 1px solid #dee2e6;
            padding: 15px 0;
        }
        
        .item-image {
            width: 80px;
            height: 100px;
            margin-right: 15px;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-details h5 {
            margin: 0 0 5px;
        }
        
        .item-details p {
            margin: 0 0 3px;
            color: #6c757d;
            font-size: 14px;
        }
        
        .item-price {
            font-weight: 600;
            min-width: 80px;
            text-align: right;
        }
        
        .order-summary {
            max-width: 300px;
            margin-left: auto;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        
        .summary-item.total {
            border-top: 1px solid #dee2e6;
            padding-top: 5px;
            margin-top: 5px;
            font-weight: 600;
            font-size: 18px;
        }
        
        .order-timeline {
            margin-top: 15px;
        }
        
        .timeline-item {
            display: flex;
            margin-bottom: 15px;
        }
        
        .timeline-icon {
            width: 30px;
            margin-right: 15px;
            position: relative;
        }
        
        .timeline-icon::after {
            content: '';
            position: absolute;
            left: 50%;
            top: 24px;
            bottom: -15px;
            width: 1px;
            background-color: #dee2e6;
            transform: translateX(-50%);
        }
        
        .timeline-item:last-child .timeline-icon::after {
            display: none;
        }
        
        .timeline-content {
            flex: 1;
        }
        
        .timeline-content h5 {
            margin: 0 0 5px;
        }
        
        .timeline-content p {
            margin: 0;
            color: #6c757d;
            font-size: 14px;
        }
        
        .timeline-notes {
            margin-top: 5px !important;
            padding: 5px 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
            font-style: italic;
        }
        
        .small-text {
            font-size: 12px;
            color: #6c757d;
        }
        
        .user-info-row {
            display: flex;
            align-items: center;
        }
        
        .user-avatar.small {
            width: 25px;
            height: 25px;
            font-size: 12px;
            margin-right: 10px;
        }
    </style>
</body>
</html> 