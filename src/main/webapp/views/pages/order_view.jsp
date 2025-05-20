<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .order-details-section {
            padding: 60px 0;
            background-color: var(--light-bg);
        }
        .order-details-card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            max-width: 800px;
            margin: 0 auto;
            padding: 30px;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .order-header h2 {
            margin: 0;
            color: var(--primary-dark);
        }
        .order-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        .status-delivered { background-color: #e8f5e9; color: #2e7d32; }
        .status-shipped { background-color: #e3f2fd; color: #1565c0; }
        .status-processing { background-color: #fff3e0; color: #ef6c00; }
        .status-cancelled { background-color: #ffebee; color: #c62828; }
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-group h4 {
            margin: 0 0 10px 0;
            color: var(--text-color);
            font-size: 0.9em;
        }
        .info-group p {
            margin: 0;
            color: var(--light-text);
        }
        .order-items {
            border-top: 1px solid var(--border-color);
            padding-top: 20px;
        }
        .order-item {
            display: flex;
            gap: 20px;
            padding: 15px 0;
            border-bottom: 1px solid var(--border-color);
        }
        .order-item:last-child { border-bottom: none; }
        .item-image {
            width: 80px;
            height: 120px;
            object-fit: cover;
            border-radius: 4px;
        }
        .item-details { flex: 1; }
        .item-details h4 {
            margin: 0 0 5px 0;
            color: var(--text-color);
        }
        .item-author {
            color: var(--light-text);
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        .item-price {
            color: var(--primary-color);
            font-weight: 500;
        }
        .order-summary {
            padding: 20px 0 0 0;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }
        .total-amount {
            font-size: 1.2em;
            font-weight: 600;
            color: var(--primary-dark);
        }
        @media (max-width: 768px) {
            .order-info { grid-template-columns: 1fr; }
            .order-item { flex-direction: column; }
            .item-image { width: 100%; height: 200px; }
            .order-details-card { padding: 15px; }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/header.jsp" />
<main>
    <section class="order-details-section">
        <div class="container">
            <div class="order-details-card" id="order-list"></div>
        </div>
    </section>
</main>
<jsp:include page="/views/common/footer.jsp" />
<script>
const contextPath = '${pageContext.request.contextPath}';

// Template for a single order item
const orderItemTemplate = `
    <div class="order-item">
        <img src="[[imageSrc]]" alt="[[bookName]]" class="item-image">
        <div class="item-details">
            <h4>[[bookName]]</h4>
            <p class="item-author">[[writerName]]</p>
            <p class="item-price">
                Quantity: [[quantity]] × NPR [[price]]
            </p>
        </div>
    </div>
`;

// Template for a single order
const orderTemplate = `
                <div class="order-header">
                    <div>
            <h2>Order #[[orderId]]</h2>
            <p class="order-date">[[orderDate]]</p>
                    </div>
        <span class="order-status status-[[status]]">[[status]]</span>
                </div>
                <div class="order-info">
                    <div class="info-group">
                        <h4>Shipping Address</h4>
            <p>[[shippingAddress]]</p>
                    </div>
                    <div class="info-group">
                        <h4>Payment Method</h4>
            <p>[[paymentMethod]]</p>
                    </div>
                </div>
                <div class="order-items">
        [[itemsHtml]]
                </div>
                <div class="order-summary">
                    <div class="total-amount">
            Total: NPR [[totalAmount]]
        </div>
    </div>
    <hr style="margin: 32px 0; border: 0; border-top: 1px solid #eee;">
`;

function replacePlaceholders(template, data) {
    return template.replace(/\[\[(.*?)\]\]/g, (match, key) => {
        return data[key] !== undefined ? data[key] : '';
    });
}

function renderOrderList(orders) {
    console.log('Fetched orders:', orders);
    if (!orders || orders.length === 0) {
        document.getElementById('order-list').innerHTML = '<p style="color:red;">No orders found.</p>';
        return;
    }

    let html = '';
    orders.forEach(order => {
        console.log('Rendering order:', order);
        let itemsHtml = '';
        let total = 0;

        if (order.orderItems && order.orderItems.length > 0) {
            itemsHtml = order.orderItems.map(item => {
                console.log('Order item:', item);
                const price = item.price || 0;
                const quantity = item.quantity || 1;
                total += price * quantity;
                const book = item.book || {};
                
                const imageSrc = book.picture && book.picture.trim() !== ''
                    ? contextPath + '/' + book.picture
                    : contextPath + '/images/book-placeholder.jpg';

                return replacePlaceholders(orderItemTemplate, {
                    imageSrc: imageSrc,
                    bookName: book.bookName || '',
                    writerName: book.writerName || '',
                    quantity: quantity,
                    price: price
                });
            }).join('');
        } else {
            itemsHtml = '<p>No items in this order.</p>';
        }

        const orderData = {
            orderId: order.orderId || 'N/A',
            orderDate: order.orderDate || '',
            status: (order.status || 'N/A').toLowerCase(),
            shippingAddress: order.shippingAddress || 'N/A',
            paymentMethod: order.paymentMethod || 'N/A',
            itemsHtml: itemsHtml,
            totalAmount: order.totalAmount != null 
                ? Number(order.totalAmount).toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2}) 
                : 'N/A'
        };

        html += replacePlaceholders(orderTemplate, orderData);
    });

    document.getElementById('order-list').innerHTML = html;
}

function loadOrderList() {
    fetch(contextPath + '/orders/api/user', {
        headers: { 'Accept': 'application/json' }
    })
    .then(res => res.json())
    .then(orders => {
        renderOrderList(orders);
    })
    .catch(() => {
        document.getElementById('order-list').innerHTML = '<p style="color:red;">Failed to load orders.</p>';
    });
}

document.addEventListener('DOMContentLoaded', loadOrderList);
</script>
</body>
</html> 