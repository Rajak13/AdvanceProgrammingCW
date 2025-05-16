<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
    body {
        font-family: 'Poppins', Arial, sans-serif;
        background: #f7f7f7;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 900px;
        margin: 40px auto;
        background: #fff;
        border-radius: 14px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.10);
        padding: 36px 28px 28px 28px;
    }
    .cart-container h1 {
        font-size: 2.1rem;
        margin-bottom: 28px;
        color: #222;
        letter-spacing: 0.5px;
        border-bottom: 1.5px solid #eee;
        padding-bottom: 12px;
    }
    .cart-item {
        display: flex;
        align-items: center;
        background: #fafbfc;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        margin-bottom: 18px;
        padding: 18px 20px;
        gap: 20px;
        transition: box-shadow 0.2s;
    }
    .cart-item:hover {
        box-shadow: 0 4px 16px rgba(0,0,0,0.07);
    }
    .cart-item img {
        width: 80px;
        height: 110px;
        object-fit: cover;
        border-radius: 7px;
        background: #eee;
        box-shadow: 0 1px 4px rgba(0,0,0,0.04);
    }
    .item-details {
        flex: 1;
    }
    .item-details h3 {
        margin: 0 0 6px 0;
        font-size: 1.13rem;
        color: #222;
        font-weight: 600;
    }
    .item-details p {
        margin: 0 0 4px 0;
        color: #666;
        font-size: 0.99rem;
    }
    .price {
        color: #FF5722;
        font-weight: 600;
        font-size: 1.05rem;
    }
    .quantity-controls {
        display: flex;
        align-items: center;
        gap: 14px;
        margin-top: 8px;
    }
    .quantity-controls span {
        color: #555;
        font-size: 1rem;
        font-weight: 500;
        background: #f3f3f3;
        padding: 4px 14px;
        border-radius: 16px;
        border: 1px solid #eee;
    }
    .remove-btn {
        background: none;
        border: none;
        color: #e53935;
        font-size: 1.1rem;
        cursor: pointer;
        padding: 4px 10px;
        border-radius: 4px;
        transition: all 0.2s;
        margin-left: 6px;
    }
    .remove-btn:hover {
        background-color: #ffebee;
        color: #c62828;
    }
    .cart-summary {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        margin-top: 36px;
        gap: 28px;
        border-top: 1.5px solid #eee;
        padding-top: 18px;
    }
    .cart-summary .total {
        font-size: 1.18rem;
        font-weight: 600;
        color: #222;
        letter-spacing: 0.2px;
    }
    .btn-primary {
        background: #FF5722;
        color: #fff;
        border: none;
        border-radius: 7px;
        padding: 12px 32px;
        font-size: 1.05rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
        box-shadow: 0 2px 8px rgba(255,87,34,0.08);
    }
    .btn-primary:disabled {
        background: #ccc;
        cursor: not-allowed;
    }
    .btn-primary:hover:not(:disabled) {
        background: #e64a19;
    }
    .empty-cart {
        text-align: center;
        color: #888;
        font-size: 1.13rem;
        margin: 40px 0;
    }
    /* Modal Styles */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0; top: 0;
        width: 100vw; height: 100vh;
        background: rgba(0,0,0,0.3);
        justify-content: center;
        align-items: center;
    }
    .modal-content {
        background: #fff;
        border-radius: 12px;
        padding: 36px 30px;
        max-width: 420px;
        width: 100%;
        position: relative;
        box-shadow: 0 8px 32px rgba(0,0,0,0.13);
    }
    .close {
        position: absolute;
        top: 18px; right: 18px;
        font-size: 1.3rem;
        color: #888;
        cursor: pointer;
        transition: color 0.2s;
    }
    .close:hover {
        color: #FF5722;
    }
    .form-group {
        margin-bottom: 18px;
    }
    .form-group label {
        display: block;
        margin-bottom: 6px;
        color: #333;
        font-weight: 500;
    }
    .form-group textarea, .form-group select {
        width: 100%;
        padding: 8px 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 1rem;
        font-family: inherit;
        background: #fafafa;
    }
    .summary-item, .summary-total {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
        font-size: 1rem;
    }
    .summary-total {
        font-weight: 700;
        color: #FF5722;
        border-top: 1px solid #eee;
        padding-top: 8px;
    }
    /* Notification Styles */
    .notification {
        position: fixed;
        top: 24px; right: 24px;
        background: #323232;
        color: #fff;
        padding: 14px 28px;
        border-radius: 8px;
        font-size: 1rem;
        z-index: 2000;
        box-shadow: 0 2px 12px rgba(0,0,0,0.12);
        opacity: 0.97;
        animation: fadeIn 0.3s;
    }
    .notification.success { background: #43a047; }
    .notification.error { background: #e53935; }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 0.97; transform: translateY(0); }
    }
    @media (max-width: 600px) {
        .container { padding: 10px; }
        .cart-item { flex-direction: column; align-items: flex-start; gap: 10px; }
        .cart-summary { flex-direction: column; align-items: flex-end; gap: 10px; }
        .modal-content { padding: 18px 8px; }
    }
    .loading {
        text-align: center;
        padding: 20px;
        color: #666;
        font-size: 1.1rem;
    }
    </style>
</head>
<body>

    <div class="container">
        <main>
            <div class="cart-container">
                <h1>Shopping Cart</h1>
                <div id="cart-items"></div>
                <div class="cart-summary">
                    <div class="total">
                        <span>Total:</span>
                        <span id="cart-total">₹0.00</span>
                    </div>
                    <button id="checkout-btn" class="btn-primary" disabled>Proceed to Checkout</button>
                </div>
            </div>
        </main>
        <!-- Checkout Modal -->
        <div id="checkout-modal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Checkout</h2>
                <form id="checkout-form">
                    <div class="form-group">
                        <label for="shipping-address">Shipping Address</label>
                        <textarea id="shipping-address" name="shippingAddress" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="payment-method">Payment Method</label>
                        <select id="payment-method" name="paymentMethod" required>
                            <option value="">Select payment method</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="PayPal">PayPal</option>
                            <option value="Cash on Delivery">Cash on Delivery</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Order Summary</label>
                        <div id="order-summary"></div>
                    </div>
                    <button type="submit" class="btn-primary">Place Order</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        // Load cart items
        function loadCart() {
            console.log('Loading cart...'); // Debug log
            const cartItems = document.getElementById('cart-items');
            const cartTotal = document.getElementById('cart-total');

            if (!cartItems) {
                console.error('cart-items element not found!');
                return;
            }

            cartItems.innerHTML = '<div class="loading">Loading cart...</div>';

            fetch(contextPath + '/cart', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                console.log('Response status:', response.status); // Debug log
                if (!response.ok) {
                    return response.text().then(text => {
                        console.error('Error response:', text);
                        throw new Error('Failed to load cart: ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Cart data:', data); // Debug log
                if (!data || data.length === 0) {
                    console.log('No items in cart'); // Debug log
                    cartItems.innerHTML = '<p class="empty-cart">Your cart is empty</p>';
                    const cartTotalElem = document.getElementById('cart-total');
                    if (cartTotalElem) {
                        cartTotalElem.textContent = '₹0.00';
                        console.log('Cart total set to:', cartTotalElem.textContent);
                    } else {
                        console.error('cart-total element not found!');
                    }
                    document.getElementById('checkout-btn').disabled = true;
                    return;
                }

                let total = 0;
                cartItems.innerHTML = data.map(item => {
                    // Debug log for all properties
                    console.log('item:', item);
                    console.log('item.book:', item.book);
                    console.log('cartId:', item.cartId, 'bookId:', item.bookId, 'quantity:', item.quantity);
                    console.log('bookName:', item.book && item.book.bookName, 'price:', item.book && item.book.price);

                    const cartId = item.cartId || '';
                    const bookId = item.bookId || '';
                    const quantity = item.quantity || 1;
                    const book = item.book || {};
                    const bookName = book.bookName || 'Unknown';
                    const price = typeof book.price === 'number' ? book.price : 0;
                    const imageSrc = book.picture && book.picture.trim() !== ''
                        ? contextPath + '/' + book.picture
                        : contextPath + '/images/book-placeholder.jpg';

                    const itemTotal = price * quantity;
                    total += itemTotal;
                    let template = `
                        <div class="cart-item" data-cart-id="[[cartId]]">
                            <img src="[[imageSrc]]" alt="[[bookName]]">
                            <div class="item-details">
                                <h3>[[bookName]]</h3>
                                <p class="price">₹[[price]]</p>
                                <div class="quantity-controls">
                                    <span>Quantity: [[quantity]]</span>
                                    <button class="remove-btn" onclick="removeItem([[cartIdNum]])">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                    template = template
                        .replace(/\[\[cartId\]\]/g, cartId)
                        .replace(/\[\[imageSrc\]\]/g, imageSrc)
                        .replace(/\[\[bookName\]\]/g, bookName)
                        .replace(/\[\[price\]\]/g, price.toFixed(2))
                        .replace(/\[\[quantity\]\]/g, quantity)
                        .replace(/\[\[cartIdNum\]\]/g, Number(cartId));
                    return template;
                }).join('');

                const cartTotalElem = document.getElementById('cart-total');
                if (cartTotalElem) {
                    cartTotalElem.textContent = '₹' + total.toFixed(2);
                    console.log('Cart total set to:', cartTotalElem.textContent);
                } else {
                    console.error('cart-total element not found!');
                }
                document.getElementById('checkout-btn').disabled = false;
            })
            .catch(error => {
                console.error('Error loading cart:', error);
                showNotification('Error loading cart: ' + error.message, 'error');
                cartItems.innerHTML = '<p class="empty-cart">Error loading cart. Please try again.</p>';
                const cartTotalElem = document.getElementById('cart-total');
                if (cartTotalElem) {
                    cartTotalElem.textContent = '₹0.00';
                    console.log('Cart total set to:', cartTotalElem.textContent);
                } else {
                    console.error('cart-total element not found!');
                }
                document.getElementById('checkout-btn').disabled = true;
            });
        }

        // Remove item from cart
        function removeItem(cartId) {
            // Validate cartId
            if (!Number.isInteger(cartId) || cartId <= 0) {
                console.error('Invalid cartId:', cartId);
                showNotification('Invalid cart item.', 'error');
                return;
            }
            if (!confirm('Are you sure you want to remove this item?')) return;
            console.log('Removing item with cartId:', cartId);
            
            fetch(contextPath + '/cart/remove', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded', 
                    'Accept': 'application/json' 
                },
                body: `cartId=${cartId}`
            })
            .then(response => {
                console.log('Remove response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        console.error('Remove error response:', text);
                        throw new Error('Failed to remove item: ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Remove success:', data);
                loadCart();
                showNotification('Item removed from cart', 'success');
            })
            .catch(error => {
                console.error('Error removing item:', error);
                showNotification('Error removing item: ' + error.message, 'error');
            });
        }

        // Show checkout modal
        document.getElementById('checkout-btn').addEventListener('click', () => {
            const modal = document.getElementById('checkout-modal');
            const orderSummary = document.getElementById('order-summary');
            
            // Update order summary
            fetch(contextPath + '/cart', {
                headers: { 'Accept': 'application/json' }
            })
                .then(response => response.json())
                .then(data => {
                    let total = 0;
                    let summaryHtml = data.map(item => {
                        const price = Number(item.book.price) || 0;
                        const quantity = Number(item.quantity) || 0;
                        const itemTotal = price * quantity;
                        total += itemTotal;
                        let template = `
                            <div class="summary-item">
                                <span>[[bookName]] x [[quantity]]</span>
                                <span>₹[[itemTotal]]</span>
                            </div>
                        `;
                        template = template
                            .replace('[[bookName]]', item.book.bookName)
                            .replace('[[quantity]]', quantity)
                            .replace('[[itemTotal]]', itemTotal.toFixed(2));
                        return template;
                    }).join('');
                    summaryHtml += `<div class="summary-total"><span>Total</span><span>₹${total.toFixed(2)}</span></div>`;
                    orderSummary.innerHTML = summaryHtml;
                });
            
            modal.style.display = 'block';
        });

        // Close modal
        document.querySelector('.close').addEventListener('click', () => {
            document.getElementById('checkout-modal').style.display = 'none';
        });

        // Handle checkout form submission
        document.getElementById('checkout-form').addEventListener('submit', (e) => {
            e.preventDefault();
            
            const formData = new URLSearchParams();
            formData.append('shippingAddress', document.getElementById('shipping-address').value);
            formData.append('paymentMethod', document.getElementById('payment-method').value);
            
            fetch(contextPath + '/orders', { // Changed from /admin/orders to /orders
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: formData.toString()
            })
            .then(response => {
                if (!response.ok) {
                    // Try to parse as JSON, fallback to text
                    return response.text().then(text => {
                        try {
                            const data = JSON.parse(text);
                            throw new Error(data.error || 'Network response was not ok');
                        } catch (e) {
                            throw new Error(text);
                        }
                    });
                }
                return response.json();
            })
            .then(data => {
                document.getElementById('checkout-modal').style.display = 'none';
                showNotification('Order placed successfully', 'success');
                setTimeout(() => {
                    window.location.href = contextPath + '/orders';
                }, 2000);
            })
            .catch(error => {
                console.error('Error placing order:', error);
                showNotification(error.message || 'Error placing order', 'error');
            });
        });

        // Show notification
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            // Add styles for notification
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '12px 24px';
            notification.style.borderRadius = '4px';
            notification.style.color = '#fff';
            notification.style.zIndex = '1000';
            notification.style.animation = 'fadeIn 0.3s ease-in-out';
            
            if (type === 'success') {
                notification.style.backgroundColor = '#4CAF50';
            } else if (type === 'error') {
                notification.style.backgroundColor = '#f44336';
            }
            
            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transition = 'opacity 0.3s ease-in-out';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }

        // Load cart on page load
        document.addEventListener('DOMContentLoaded', loadCart);

        // Add loading styles
        const style = document.createElement('style');
        style.textContent = `
            .loading {
                text-align: center;
                padding: 20px;
                color: #666;
                font-size: 1.1rem;
            }
            .cart-item img {
                width: 80px;
                height: 110px;
                object-fit: cover;
                border-radius: 6px;
                background: #eee;
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>