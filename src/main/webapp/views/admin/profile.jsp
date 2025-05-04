<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Admin Dashboard</title>
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
                <a href="${pageContext.request.contextPath}/admin/profile" class="nav-item active">
                    <i class="fas fa-user"></i> Profile
                </a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item">
                    <i class="fas fa-cog"></i> Settings
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <div class="header-left">
                    <h1>Profile Settings</h1>
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

            <!-- Profile Content -->
            <div class="content">
                <div class="profile-container">
                    <!-- Profile Picture Section -->
                    <div class="profile-picture-section">
                        <div class="profile-picture">
                            <img src="${pageContext.request.contextPath}/assets/images/admin-avatar.png" alt="Profile Picture">
                            <button class="change-picture-btn">
                                <i class="fas fa-camera"></i> Change Picture
                            </button>
                        </div>
                    </div>

                    <!-- Profile Form -->
                    <form class="profile-form" id="profileForm">
                        <div class="form-group">
                            <label for="name">Name</label>
                            <input type="text" id="name" name="name" value="${user.name}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${user.email}" required>
                        </div>

                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address" value="${user.address}">
                        </div>

                        <div class="form-group">
                            <label for="contact">Contact</label>
                            <input type="text" id="contact" name="contact" value="${user.contact}">
                        </div>

                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword">
                        </div>

                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword">
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword">
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    <script>
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const data = {};
            formData.forEach((value, key) => {
                if (value) data[key] = value;
            });

            fetch('${pageContext.request.contextPath}/admin/profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Network response was not ok');
                }
            })
            .then(data => {
                if (data.success) {
                    alert('Profile updated successfully!');
                    window.location.reload();
                } else {
                    alert(data.message || 'Error updating profile. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating profile. Please try again.');
            });
        });

        function resetForm() {
            document.getElementById('profileForm').reset();
        }

        // Handle profile picture change
        document.querySelector('.change-picture-btn').addEventListener('click', function() {
            const input = document.createElement('input');
            input.type = 'file';
            input.accept = 'image/*';
            
            input.onchange = function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        document.querySelector('.profile-picture img').src = e.target.result;
                        
                        // Upload the new picture
                        const formData = new FormData();
                        formData.append('picture', file);
                        
                        fetch('${pageContext.request.contextPath}/admin/profile/picture', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => {
                            if (response.ok) {
                                return response.json();
                            } else {
                                throw new Error('Network response was not ok');
                            }
                        })
                        .then(data => {
                            if (data.success) {
                                alert('Profile picture updated successfully!');
                                window.location.reload();
                            } else {
                                alert(data.message || 'Error updating profile picture. Please try again.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Error updating profile picture. Please try again.');
                        });
                    };
                    reader.readAsDataURL(file);
                }
            };
            
            input.click();
        });
    </script>
</body>
</html> 