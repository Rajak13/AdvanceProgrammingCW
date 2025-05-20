<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Panna BookStore</title>
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

        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .profile-header {
            background: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profile-avatar {
            position: relative;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid var(--accent-color);
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .change-avatar-btn {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.7);
            color: var(--white);
            padding: 0.5rem;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
        }

        .change-avatar-btn:hover {
            background: var(--accent-color);
        }

        .profile-info h2 {
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
        }

        .profile-info .role {
            color: var(--accent-color);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .profile-info .email {
            color: var(--light-text);
        }

        .profile-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .profile-section {
            background: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }

        .profile-section h3 {
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
                    <li class="active">
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
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.picture}">
                                <img src="${pageContext.request.contextPath}/files/${sessionScope.user.picture}" alt="Profile Picture" id="profileImage">
                            </c:when>
                            <c:otherwise>
                                <div class="profile-initials" id="profileInitials">${fn:toUpperCase(fn:substring(sessionScope.user.name, 0, 1))}</div>
                            </c:otherwise>
                        </c:choose>
                        <label for="picture" class="change-avatar-btn">
                            <i class="fas fa-camera"></i> Change Photo
                        </label>
                    </div>
                    <div class="profile-info">
                        <h2>${sessionScope.user.name}</h2>
                        <p class="role">${sessionScope.user.role}</p>
                        <p class="email">${sessionScope.user.email}</p>
                    </div>
                </div>

                <div class="profile-sections">
                    <!-- Personal Information -->
                    <section class="profile-section">
                        <h3>Personal Information</h3>
                        <form id="personalInfoForm" class="profile-form" action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">
                            <input type="file" id="picture" name="picture" accept="image/*" style="display: none;">
                            
                            <div class="form-group">
                                <label for="name">Full Name</label>
                                <input type="text" id="name" name="name" value="${sessionScope.user.name}" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email" value="${sessionScope.user.email}" class="form-control" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" value="${sessionScope.user.contact}" class="form-control">
                            </div>
                            
                            <div class="form-group">
                                <label for="address">Address</label>
                                <textarea id="address" name="address" class="form-control" rows="3">${sessionScope.user.address}</textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Update Information</button>
                        </form>
                    </section>

                    <!-- Change Password -->
                    <section class="profile-section">
                        <h3>Change Password</h3>
                        <form id="passwordForm" class="profile-form" action="${pageContext.request.contextPath}/users/change-password" method="post">
                            <div class="form-group">
                                <label for="currentPassword">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Change Password</button>
                        </form>
                    </section>

                    <!-- Notification Preferences -->
                    <section class="profile-section">
                        <h3>Notification Preferences</h3>
                        <form id="notificationForm" class="profile-form">
                            <div class="form-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="emailNotifications" checked>
                                    Email Notifications
                                </label>
                            </div>
                            
                            <div class="form-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="orderUpdates" checked>
                                    Order Updates
                                </label>
                            </div>
                            
                            <div class="form-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="marketingEmails">
                                    Marketing Emails
                                </label>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Preferences</button>
                        </form>
                    </section>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Preview image before upload
        document.getElementById('picture').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const profileImage = document.getElementById('profileImage');
                    const profileInitials = document.getElementById('profileInitials');
                    
                    if (profileImage) {
                        profileImage.src = e.target.result;
                    } else {
                        if (profileInitials) {
                            profileInitials.style.display = 'none';
                        }
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.alt = 'Profile Picture';
                        img.id = 'profileImage';
                        document.querySelector('.profile-avatar').appendChild(img);
                    }
                };
                reader.readAsDataURL(file);
            }
        });

        // Form submission handlers
        document.getElementById('personalInfoForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/profile', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showNotification('Profile updated successfully', 'success');
                } else {
                    throw new Error('Failed to update profile');
                }
            })
            .catch(error => {
                showNotification(error.message, 'error');
            });
        });

        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (newPassword !== confirmPassword) {
                showNotification('Passwords do not match', 'error');
                return;
            }

            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/users/change-password', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showNotification('Password changed successfully', 'success');
                    this.reset();
                } else {
                    throw new Error('Failed to change password');
                }
            })
            .catch(error => {
                showNotification(error.message, 'error');
            });
        });

        document.getElementById('notificationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            // Add your notification preferences update logic here
            showNotification('Notification preferences updated successfully', 'success');
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