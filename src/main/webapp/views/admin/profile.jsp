<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Panna BookStore</title>
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
                    <li class="active">
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
                        <input type="text" placeholder="Search books...">
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

            
            <div class="profile-content">
                <div class="profile-header">
                    <h2>My Profile</h2>
                    <p>Manage your account settings and preferences</p>
                </div>
                
                <div class="profile-grid">
                    <!-- Profile Information -->
                    <div class="profile-card">
                        <div class="card-header">
                            <h3>Profile Information</h3>
                            <button class="btn-edit" data-modal-target="#editProfileModal">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                        </div>
                        <div class="profile-info">
                            <div class="profile-avatar">
                                <img src="${user.picture != null ? user.picture : pageContext.request.contextPath.concat('/assets/images/default-avatar.jpg')}" 
                                     alt="${user.name}">
                                <div class="avatar-overlay">
                                    <i class="fas fa-camera"></i>
                                </div>
                            </div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <label>Full Name</label>
                                    <p>${user.name}</p>
                                </div>
                                <div class="info-item">
                                    <label>Email</label>
                                    <p>${user.email}</p>
                                </div>
                                <div class="info-item">
                                    <label>Phone</label>
                                    <p>${user.contact != null ? user.contact : 'Not set'}</p>
                                </div>
                                <div class="info-item">
                                    <label>Role</label>
                                    <p>${user.role}</p>
                                </div>
                                <div class="info-item">
                                    <label>Address</label>
                                    <p>${user.address != null ? user.address : 'Not set'}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Security Settings -->
                    <div class="profile-card">
                        <div class="card-header">
                            <h3>Security Settings</h3>
                        </div>
                        <div class="security-settings">
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h4>Password</h4>
                                    <p>Change your account password</p>
                                </div>
                                <button class="btn-secondary" data-modal-target="#changePasswordModal">
                                    Change Password
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal" id="editProfileModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Profile</h3>
                <button class="modal-close" data-modal-close>
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="editProfileForm" action="${pageContext.request.contextPath}/admin/profile/update" method="POST">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" value="${user.name}" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${user.email}" required>
                </div>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="tel" id="phone" name="phone" value="${user.contact}">
                </div>
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address">${user.address}</textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-modal-close>Cancel</button>
                    <button type="submit" class="btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal" id="changePasswordModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Change Password</h3>
                <button class="modal-close" data-modal-close>
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="changePasswordForm" action="${pageContext.request.contextPath}/admin/profile/change-password" method="POST">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" required>
                </div>
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-modal-close>Cancel</button>
                    <button type="submit" class="btn-primary">Change Password</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html> 