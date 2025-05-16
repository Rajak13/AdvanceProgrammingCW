<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            <!-- Header -->
            <header class="admin-header">
                <div class="header-left">
                    <button class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="search-bar">
                        <input type="text" placeholder="Search...">
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

            <!-- Settings Content -->
            <div class="dashboard-content">
                <div class="settings-container">
                    <div class="settings-grid">
                        <!-- General Settings -->
                        <div class="settings-card">
                            <h3>Store Settings</h3>
                            <form id="generalSettingsForm" class="settings-form">
                                <div class="form-group">
                                    <label for="storeName">Store Name</label>
                                    <input type="text" id="storeName" name="storeName" class="form-control" value="Panna BookStore">
                                </div>
                                <div class="form-group">
                                    <label for="storeUrl">Store URL</label>
                                    <input type="url" id="storeUrl" name="storeUrl" class="form-control" value="https://pannabooks.com">
                                </div>
                                <div class="form-group">
                                    <label for="contactEmail">Contact Email</label>
                                    <input type="email" id="contactEmail" name="contactEmail" class="form-control" value="contact@pannabooks.com">
                                </div>
                                <div class="form-group">
                                    <label for="contactPhone">Contact Phone</label>
                                    <input type="tel" id="contactPhone" name="contactPhone" class="form-control" value="+1 (555) 123-4567">
                                </div>
                                <div class="form-group">
                                    <label for="timezone">Timezone</label>
                                    <select id="timezone" name="timezone" class="form-control">
                                        <option value="UTC">UTC</option>
                                        <option value="America/New_York">Eastern Time</option>
                                        <option value="America/Chicago">Central Time</option>
                                        <option value="America/Denver">Mountain Time</option>
                                        <option value="America/Los_Angeles" selected>Pacific Time</option>
                                    </select>
                                </div>
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>

                        <!-- Book Settings -->
                        <div class="settings-card">
                            <h3>Book Settings</h3>
                            <form id="bookSettingsForm" class="settings-form">
                                <div class="form-group">
                                    <label>Book Features</label>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="enableReviews" name="bookFeatures[]" value="reviews" checked>
                                            <label for="enableReviews">Enable Book Reviews</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="enableRatings" name="bookFeatures[]" value="ratings" checked>
                                            <label for="enableRatings">Enable Book Ratings</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="enableWishlist" name="bookFeatures[]" value="wishlist" checked>
                                            <label for="enableWishlist">Enable Wishlist</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="defaultBookImage">Default Book Image</label>
                                    <input type="file" id="defaultBookImage" name="defaultBookImage" class="form-control" accept="image/*">
                                </div>
                                <div class="form-group">
                                    <label for="bookImageSize">Book Image Size Limit (MB)</label>
                                    <input type="number" id="bookImageSize" name="bookImageSize" class="form-control" value="5">
                                </div>
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>

                        <!-- Payment Settings -->
                        <div class="settings-card">
                            <h3>Payment Settings</h3>
                            <form id="paymentSettingsForm" class="settings-form">
                                <div class="form-group">
                                    <label>Payment Methods</label>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="stripe" name="paymentMethods[]" value="stripe" checked>
                                            <label for="stripe">Stripe</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="paypal" name="paymentMethods[]" value="paypal" checked>
                                            <label for="paypal">PayPal</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="bank" name="paymentMethods[]" value="bank">
                                            <label for="bank">Bank Transfer</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="currency">Default Currency</label>
                                    <select id="currency" name="currency" class="form-control">
                                        <option value="USD" selected>US Dollar (USD)</option>
                                        <option value="EUR">Euro (EUR)</option>
                                        <option value="GBP">British Pound (GBP)</option>
                                        <option value="INR">Indian Rupee (INR)</option>
                                    </select>
                                </div>
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>

                        <!-- Notification Settings -->
                        <div class="settings-card">
                            <h3>Notification Settings</h3>
                            <form id="notificationSettingsForm" class="settings-form">
                                <div class="form-group">
                                    <label>Email Notifications</label>
                                    <div class="toggle-group">
                                        <div class="toggle-item">
                                            <label>New Order Notifications</label>
                                            <div class="toggle-switch">
                                                <input type="checkbox" id="orderNotifications" name="orderNotifications" checked>
                                                <label for="orderNotifications"></label>
                                            </div>
                                        </div>
                                        <div class="toggle-item">
                                            <label>Low Stock Alerts</label>
                                            <div class="toggle-switch">
                                                <input type="checkbox" id="stockAlerts" name="stockAlerts" checked>
                                                <label for="stockAlerts"></label>
                                            </div>
                                        </div>
                                        <div class="toggle-item">
                                            <label>Book Review Notifications</label>
                                            <div class="toggle-switch">
                                                <input type="checkbox" id="reviewNotifications" name="reviewNotifications" checked>
                                                <label for="reviewNotifications"></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        window.ctx = '${pageContext.request.contextPath}';
        // Form Submissions
        document.getElementById('generalSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            saveSettings('general', this);
        });

        document.getElementById('bookSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            saveSettings('book', this);
        });

        document.getElementById('paymentSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            saveSettings('payment', this);
        });

        document.getElementById('notificationSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            saveSettings('notification', this);
        });

        function saveSettings(type, form) {
            const formData = new FormData(form);
            
            fetch(`${window.ctx}/api/settings/${type}`, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    alert('Settings saved successfully!');
                } else {
                    throw new Error('Failed to save settings');
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>