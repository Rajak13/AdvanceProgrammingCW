<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Store Settings - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    <style>
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
        }

        .admin-main {
            flex: 1;
            margin-left: 250px;
            padding: 2rem;
        }

        .settings-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .settings-container h2 {
            color: var(--primary-dark);
            margin-bottom: 2rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--accent-color);
            display: inline-block;
        }

        .settings-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .settings-section {
            background: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }

        .settings-section h3 {
            color: var(--primary-dark);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--accent-color);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--primary-dark);
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
            outline: none;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 2rem;
            border-radius: var(--border-radius);
            color: var(--white);
            font-weight: 500;
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
        }

        .notification.success {
            background: #4CAF50;
        }

        .notification.error {
            background: #f44336;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-primary {
            background: var(--accent-color);
            color: var(--white);
        }

        .btn-primary:hover {
            background: #E64A19;
            transform: translateY(-2px);
        }

        .settings-section .form-group:last-child {
            margin-bottom: 0;
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
                    <li>
                        <a href="${pageContext.request.contextPath}/orders">
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
                    <li class="active">
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
            <div class="settings-container">
                <h2>Store Settings</h2>
                
                <div class="settings-sections">
                    <!-- General Settings -->
                    <section class="settings-section">
                        <h3>General Settings</h3>
                        <form id="generalSettingsForm" class="settings-form" action="${pageContext.request.contextPath}/admin/settings/general" method="post">
                            <div class="form-group">
                                <label for="storeName">Store Name</label>
                                <input type="text" id="storeName" name="storeName" value="Panna BookStore" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="storeEmail">Store Email</label>
                                <input type="email" id="storeEmail" name="storeEmail" value="contact@pannabookstore.com" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="storePhone">Store Phone</label>
                                <input type="tel" id="storePhone" name="storePhone" value="+1 234 567 8900" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="storeAddress">Store Address</label>
                                <textarea id="storeAddress" name="storeAddress" class="form-control" rows="3" required>123 Book Street, Reading City, RC 12345</textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save General Settings</button>
                        </form>
                    </section>

                    <!-- Payment Settings -->
                    <section class="settings-section">
                        <h3>Payment Settings</h3>
                        <form id="paymentSettingsForm" class="settings-form" action="${pageContext.request.contextPath}/admin/settings/payment" method="post">
                            <div class="form-group">
                                <label for="currency">Currency</label>
                                <select id="currency" name="currency" class="form-control" required>
                                    <option value="USD">USD ($)</option>
                                    <option value="EUR">EUR (€)</option>
                                    <option value="GBP">GBP (£)</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="taxRate">Tax Rate (%)</label>
                                <input type="number" id="taxRate" name="taxRate" value="8.5" step="0.1" min="0" max="100" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="enablePaypal" checked>
                                    Enable PayPal
                                </label>
                            </div>
                            
                            <div class="form-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="enableStripe" checked>
                                    Enable Stripe
                                </label>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Payment Settings</button>
                        </form>
                    </section>

                    <!-- Shipping Settings -->
                    <section class="settings-section">
                        <h3>Shipping Settings</h3>
                        <form id="shippingSettingsForm" class="settings-form" action="${pageContext.request.contextPath}/admin/settings/shipping" method="post">
                            <div class="form-group">
                                <label for="shippingMethod">Default Shipping Method</label>
                                <select id="shippingMethod" name="shippingMethod" class="form-control" required>
                                    <option value="standard">Standard Shipping</option>
                                    <option value="express">Express Shipping</option>
                                    <option value="overnight">Overnight Shipping</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="shippingCost">Base Shipping Cost</label>
                                <input type="number" id="shippingCost" name="shippingCost" value="5.99" step="0.01" min="0" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="freeShippingThreshold">Free Shipping Threshold</label>
                                <input type="number" id="freeShippingThreshold" name="freeShippingThreshold" value="50.00" step="0.01" min="0" class="form-control" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Shipping Settings</button>
                        </form>
                    </section>

                    <!-- Email Settings -->
                    <section class="settings-section">
                        <h3>Email Settings</h3>
                        <form id="emailSettingsForm" class="settings-form" action="${pageContext.request.contextPath}/admin/settings/email" method="post">
                            <div class="form-group">
                                <label for="smtpHost">SMTP Host</label>
                                <input type="text" id="smtpHost" name="smtpHost" value="smtp.gmail.com" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="smtpPort">SMTP Port</label>
                                <input type="number" id="smtpPort" name="smtpPort" value="587" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="smtpUsername">SMTP Username</label>
                                <input type="email" id="smtpUsername" name="smtpUsername" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="smtpPassword">SMTP Password</label>
                                <input type="password" id="smtpPassword" name="smtpPassword" class="form-control" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Email Settings</button>
                        </form>
                    </section>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Form submission handlers
        document.getElementById('generalSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/admin/settings/general', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showNotification('General settings updated successfully', 'success');
                } else {
                    throw new Error('Failed to update general settings');
                }
            })
            .catch(error => {
                showNotification(error.message, 'error');
            });
        });

        document.getElementById('paymentSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/admin/settings/payment', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showNotification('Payment settings updated successfully', 'success');
                } else {
                    throw new Error('Failed to update payment settings');
                }
            })
            .catch(error => {
                showNotification(error.message, 'error');
            });
        });

        document.getElementById('shippingSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/admin/settings/shipping', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showNotification('Shipping settings updated successfully', 'success');
                } else {
                    throw new Error('Failed to update shipping settings');
                }
            })
            .catch(error => {
                showNotification(error.message, 'error');
            });
        });

        document.getElementById('emailSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/admin/settings/email', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showNotification('Email settings updated successfully', 'success');
                } else {
                    throw new Error('Failed to update email settings');
                }
            })
            .catch(error => {
                showNotification(error.message, 'error');
            });
        });

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
    </script>
</body>
</html>