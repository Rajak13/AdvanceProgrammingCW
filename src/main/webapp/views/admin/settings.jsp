<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
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
                <a href="${pageContext.request.contextPath}/admin/orders" class="nav-item">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="nav-item">
                    <i class="fas fa-user"></i> Profile
                </a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item active">
                    <i class="fas fa-cog"></i> Settings
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <div class="header-left">
                    <h1>System Settings</h1>
                </div>
                <div class="header-right">
                    <div class="search-bar">
                        <input type="text" placeholder="Search...">
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

            <!-- Settings Content -->
            <div class="content">
                <div class="settings-container">
                    <!-- General Settings -->
                    <div class="settings-section">
                        <h2>General Settings</h2>
                        <form class="settings-form" id="generalSettingsForm">
                            <div class="form-group">
                                <label for="siteName">Site Name</label>
                                <input type="text" id="siteName" name="siteName" value="${settings.siteName}" required>
                            </div>

                            <div class="form-group">
                                <label for="siteDescription">Site Description</label>
                                <textarea id="siteDescription" name="siteDescription" rows="3">${settings.siteDescription}</textarea>
                            </div>

                            <div class="form-group">
                                <label for="adminEmail">Admin Email</label>
                                <input type="email" id="adminEmail" name="adminEmail" value="${settings.adminEmail}" required>
                            </div>

                            <div class="form-group">
                                <label for="timezone">Timezone</label>
                                <select id="timezone" name="timezone" required>
                                    <option value="UTC" ${settings.timezone == 'UTC' ? 'selected' : ''}>UTC</option>
                                    <option value="EST" ${settings.timezone == 'EST' ? 'selected' : ''}>Eastern Time</option>
                                    <option value="PST" ${settings.timezone == 'PST' ? 'selected' : ''}>Pacific Time</option>
                                    <!-- Add more timezones as needed -->
                                </select>
                            </div>
                        </form>
                    </div>

                    <!-- Email Settings -->
                    <div class="settings-section">
                        <h2>Email Settings</h2>
                        <form class="settings-form" id="emailSettingsForm">
                            <div class="form-group">
                                <label for="smtpHost">SMTP Host</label>
                                <input type="text" id="smtpHost" name="smtpHost" value="${settings.smtpHost}" required>
                            </div>

                            <div class="form-group">
                                <label for="smtpPort">SMTP Port</label>
                                <input type="number" id="smtpPort" name="smtpPort" value="${settings.smtpPort}" required>
                            </div>

                            <div class="form-group">
                                <label for="smtpUsername">SMTP Username</label>
                                <input type="text" id="smtpUsername" name="smtpUsername" value="${settings.smtpUsername}" required>
                            </div>

                            <div class="form-group">
                                <label for="smtpPassword">SMTP Password</label>
                                <input type="password" id="smtpPassword" name="smtpPassword" value="${settings.smtpPassword}" required>
                            </div>

                            <div class="form-group">
                                <label for="smtpEncryption">Encryption</label>
                                <select id="smtpEncryption" name="smtpEncryption" required>
                                    <option value="none" ${settings.smtpEncryption == 'none' ? 'selected' : ''}>None</option>
                                    <option value="ssl" ${settings.smtpEncryption == 'ssl' ? 'selected' : ''}>SSL</option>
                                    <option value="tls" ${settings.smtpEncryption == 'tls' ? 'selected' : ''}>TLS</option>
                                </select>
                            </div>
                        </form>
                    </div>

                    <!-- Security Settings -->
                    <div class="settings-section">
                        <h2>Security Settings</h2>
                        <form class="settings-form" id="securitySettingsForm">
                            <div class="form-group">
                                <label for="sessionTimeout">Session Timeout (minutes)</label>
                                <input type="number" id="sessionTimeout" name="sessionTimeout" value="${settings.sessionTimeout}" required>
                            </div>

                            <div class="form-group">
                                <label for="maxLoginAttempts">Maximum Login Attempts</label>
                                <input type="number" id="maxLoginAttempts" name="maxLoginAttempts" value="${settings.maxLoginAttempts}" required>
                            </div>

                            <div class="form-group">
                                <label for="passwordExpiry">Password Expiry (days)</label>
                                <input type="number" id="passwordExpiry" name="passwordExpiry" value="${settings.passwordExpiry}" required>
                            </div>

                            <div class="form-group">
                                <label for="twoFactorAuth">Two-Factor Authentication</label>
                                <div class="toggle-switch">
                                    <input type="checkbox" id="twoFactorAuth" name="twoFactorAuth" ${settings.twoFactorAuth ? 'checked' : ''}>
                                    <span class="toggle-slider"></span>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Save Button -->
                    <div class="settings-actions">
                        <button type="button" class="btn btn-secondary" onclick="resetForms()">Reset</button>
                        <button type="button" class="btn btn-primary" onclick="saveSettings()">Save All Settings</button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    <script>
        function saveSettings() {
            const generalSettings = new FormData(document.getElementById('generalSettingsForm'));
            const emailSettings = new FormData(document.getElementById('emailSettingsForm'));
            const securitySettings = new FormData(document.getElementById('securitySettingsForm'));

            const settings = {
                general: Object.fromEntries(generalSettings),
                email: Object.fromEntries(emailSettings),
                security: Object.fromEntries(securitySettings)
            };

            fetch('/admin/settings/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(settings)
            })
            .then(response => {
                if (response.ok) {
                    alert('Settings updated successfully!');
                } else {
                    alert('Error updating settings. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating settings. Please try again.');
            });
        }

        function resetForms() {
            document.getElementById('generalSettingsForm').reset();
            document.getElementById('emailSettingsForm').reset();
            document.getElementById('securitySettingsForm').reset();
        }

        // Initialize toggle switches
        document.querySelectorAll('.toggle-switch input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                this.parentElement.classList.toggle('active', this.checked);
            });
        });
    </script>
</body>
</html> 