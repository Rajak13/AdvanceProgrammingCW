<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--accent-color) 100%);
            padding: 3rem 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 2rem;
            color: var(--white);
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('${pageContext.request.contextPath}/images/pattern.png');
            opacity: 0.1;
            z-index: 0;
        }

        .profile-avatar {
            position: relative;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            overflow: hidden;
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            z-index: 1;
            background: var(--white);
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-initials {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            font-weight: 600;
            color: var(--primary-dark);
            background: var(--light-bg);
        }

        .change-avatar-btn {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.7);
            color: var(--white);
            padding: 0.75rem;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
            backdrop-filter: blur(4px);
        }

        .change-avatar-btn:hover {
            background: var(--accent-color);
        }

        .profile-info {
            z-index: 1;
            flex: 1;
        }

        .profile-info h2 {
            color: var(--white);
            margin-bottom: 0.5rem;
            font-size: 2rem;
            font-weight: 600;
        }

        .profile-info .role {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .profile-info .role i {
            color: var(--accent-color);
        }

        .profile-info .email {
            color: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .profile-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            text-align: center;
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-card i {
            font-size: 2rem;
            color: var(--accent-color);
            margin-bottom: 1rem;
        }

        .stat-card h3 {
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .stat-card p {
            color: var(--light-text);
            font-size: 0.9rem;
        }

        .profile-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
        }

        .profile-section {
            background: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .profile-section:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .profile-section h3 {
            color: var(--primary-dark);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--accent-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .profile-section h3 i {
            color: var(--accent-color);
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
            font-size: 1rem;
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
            outline: none;
        }

        .form-control:disabled {
            background: var(--light-bg);
            cursor: not-allowed;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            user-select: none;
        }

        .checkbox-label input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--accent-color);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            font-size: 1rem;
        }

        .btn-primary {
            background: var(--accent-color);
            color: var(--white);
        }

        .btn-primary:hover {
            background: #E64A19;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: var(--primary-dark);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: #1A237E;
            transform: translateY(-2px);
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
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

        .activity-timeline {
            margin-top: 1rem;
        }

        .timeline-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-left: 2px solid var(--accent-color);
            margin-left: 1rem;
            position: relative;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -0.5rem;
            width: 1rem;
            height: 1rem;
            border-radius: 50%;
            background: var(--accent-color);
        }

        .timeline-item:last-child {
            border-left: none;
        }

        .timeline-content {
            flex: 1;
        }

        .timeline-content h4 {
            color: var(--primary-dark);
            margin-bottom: 0.25rem;
        }

        .timeline-content p {
            color: var(--light-text);
            font-size: 0.9rem;
        }

        .timeline-date {
            color: var(--accent-color);
            font-size: 0.8rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <jsp:include page="common/sidebar.jsp" />
        
        <main class="admin-main">
            <jsp:include page="common/header.jsp" />
            
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
                        <p class="role">
                            <i class="fas fa-shield-alt"></i>
                            ${sessionScope.user.role}
                        </p>
                        <p class="email">
                            <i class="fas fa-envelope"></i>
                            ${sessionScope.user.email}
                        </p>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon sales">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Books</h3>
                            <p class="stat-value">${totalBooks}</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon warning">
                             <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Users</h3>
                            <p class="stat-value">${totalUsers}</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon orders">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Orders</h3>
                            <p class="stat-value">${totalOrders}</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                             <p class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/></p>
                             <h3>Total Revenue</h3>
                        </div>
                    </div>
                </div>

                <div class="profile-sections">
                    <!-- Personal Information -->
                    <section class="profile-section">
                        <h3><i class="fas fa-user"></i> Personal Information</h3>
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
                            
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Information
                            </button>
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
                    // Attempt to read error message from response body
                    response.text().then(text => {
                         try {
                             const errorData = JSON.parse(text);
                             showNotification(errorData.error || 'Failed to update profile', 'error');
                         } catch (parseError) {
                             showNotification('Failed to update profile: ' + text, 'error');
                         }
                    }).catch(() => {
                         showNotification('Failed to update profile', 'error');
                    });
                   
                }
            })
            .catch(error => {
                showNotification('Network error: ' + error.message, 'error');
            });
        });

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.innerHTML = `
                <i class="fas fa-${type == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                ${message}
            `;
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