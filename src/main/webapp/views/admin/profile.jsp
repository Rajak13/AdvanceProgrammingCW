<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .profile-container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        
        .profile-sidebar {
            flex: 0 0 280px;
        }
        
        .profile-content {
            flex: 1;
            min-width: 300px;
        }
        
        .profile-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 24px;
            text-align: center;
        }
        
        .profile-avatar-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
        }
        
        .profile-avatar {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid var(--primary-color);
        }
        
        .edit-avatar {
            position: absolute;
            bottom: 0;
            right: 0;
            background-color: var(--primary-color);
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .profile-name {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .profile-email {
            color: #666;
            margin-bottom: 20px;
        }
        
        .profile-stats {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 18px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 12px;
            color: #666;
        }
        
        .section-title {
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .form-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 24px;
            margin-bottom: 24px;
        }
        
        .nav-tabs {
            display: flex;
            border-bottom: 1px solid #ddd;
            margin-bottom: 20px;
        }
        
        .nav-item {
            padding: 12px 20px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            font-weight: 500;
        }
        
        .nav-item.active {
            border-bottom-color: var(--primary-color);
            color: var(--primary-color);
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .activity-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .activity-item {
            padding: 16px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #e7eeff;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .activity-details {
            flex-grow: 1;
        }
        
        .activity-action {
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .activity-time {
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Include sidebar -->
        <jsp:include page="common/sidebar.jsp">
            <jsp:param name="active" value="profile" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Admin Profile</h1>
            </div>

            <div class="content-body">
                <c:if test="${not empty message}">
                    <div class="alert ${messageType == 'success' ? 'alert-success' : 'alert-danger'}">
                        ${message}
                    </div>
                </c:if>

                <div class="profile-container">
                    <div class="profile-sidebar">
                        <div class="profile-card">
                            <div class="profile-avatar-container">
                                <img src="${not empty user.profileImage ? pageContext.request.contextPath.concat(user.profileImage) : pageContext.request.contextPath.concat('/images/default-avatar.png')}" 
                                     alt="Profile Avatar" class="profile-avatar">
                                <div class="edit-avatar" id="uploadAvatarBtn">
                                    <i class="fas fa-camera"></i>
                                </div>
                            </div>
                            <h2 class="profile-name">${user.firstName} ${user.lastName}</h2>
                            <p class="profile-email">${user.email}</p>
                            <button class="btn btn-primary" id="editProfileBtn">
                                <i class="fas fa-edit"></i> Edit Profile
                            </button>
                            
                            <div class="profile-stats">
                                <div class="stat-item">
                                    <div class="stat-value">${stats.totalBooks}</div>
                                    <div class="stat-label">Books</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-value">${stats.totalCategories}</div>
                                    <div class="stat-label">Categories</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-value">${stats.totalOrders}</div>
                                    <div class="stat-label">Orders</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="profile-content">
                        <div class="form-card">
                            <div class="nav-tabs">
                                <div class="nav-item active" data-tab="profile-info">Profile Information</div>
                                <div class="nav-item" data-tab="security">Security</div>
                                <div class="nav-item" data-tab="activity">Recent Activity</div>
                            </div>
                            
                            <!-- Profile Information Tab -->
                            <div class="tab-content active" id="profile-info">
                                <div class="form-group">
                                    <label>First Name</label>
                                    <div class="form-control-static">${user.firstName}</div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Last Name</label>
                                    <div class="form-control-static">${user.lastName}</div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Email</label>
                                    <div class="form-control-static">${user.email}</div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Phone Number</label>
                                    <div class="form-control-static">${not empty user.phone ? user.phone : 'Not provided'}</div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Address</label>
                                    <div class="form-control-static">${not empty user.address ? user.address : 'Not provided'}</div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Role</label>
                                    <div class="form-control-static">${user.role}</div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Account Created</label>
                                    <div class="form-control-static">
                                        <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Last Login</label>
                                    <div class="form-control-static">
                                        <fmt:formatDate value="${user.lastLogin}" pattern="MMM dd, yyyy HH:mm" />
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Security Tab -->
                            <div class="tab-content" id="security">
                                <div class="section-title">Change Password</div>
                                
                                <form id="passwordForm" action="${pageContext.request.contextPath}/admin/profile/change-password" method="post">
                                    <div class="form-group">
                                        <label for="currentPassword">Current Password</label>
                                        <input type="password" id="currentPassword" name="currentPassword" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="newPassword">New Password</label>
                                        <input type="password" id="newPassword" name="newPassword" required>
                                        <div class="form-hint">
                                            Password must be at least 8 characters with lowercase, uppercase, number, and special character.
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="confirmPassword">Confirm New Password</label>
                                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                    
                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary">Update Password</button>
                                    </div>
                                </form>
                                
                                <div class="section-title" style="margin-top: 30px;">Two-Factor Authentication</div>
                                
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <input type="checkbox" id="enableTwoFactor" ${user.twoFactorEnabled ? 'checked' : ''}>
                                        <label for="enableTwoFactor">Enable Two-Factor Authentication</label>
                                    </div>
                                    <div class="form-hint">
                                        Two-factor authentication adds an extra layer of security to your account. 
                                        When enabled, you'll need to provide a verification code in addition to your password when logging in.
                                    </div>
                                </div>
                                
                                <button class="btn btn-secondary" id="setupTwoFactorBtn" ${user.twoFactorEnabled ? 'style="display:none;"' : ''}>
                                    Set Up Two-Factor Authentication
                                </button>
                                
                                <button class="btn btn-danger" id="disableTwoFactorBtn" ${!user.twoFactorEnabled ? 'style="display:none;"' : ''}>
                                    Disable Two-Factor Authentication
                                </button>
                            </div>
                            
                            <!-- Activity Tab -->
                            <div class="tab-content" id="activity">
                                <div class="section-title">Recent Activities</div>
                                
                                <c:choose>
                                    <c:when test="${empty activities}">
                                        <p>No recent activities found.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <ul class="activity-list">
                                            <c:forEach items="${activities}" var="activity">
                                                <li class="activity-item">
                                                    <div class="activity-icon">
                                                        <i class="${activity.icon}"></i>
                                                    </div>
                                                    <div class="activity-details">
                                                        <div class="activity-action">${activity.action}</div>
                                                        <div class="activity-time">
                                                            <fmt:formatDate value="${activity.timestamp}" pattern="MMM dd, yyyy HH:mm" />
                                                        </div>
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal" id="profileModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Edit Profile</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="profileForm" action="${pageContext.request.contextPath}/admin/profile/update" method="post" enctype="multipart/form-data">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" value="${user.firstName}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" value="${user.lastName}" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${user.email}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" value="${user.phone}">
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" rows="3">${user.address}</textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelEditBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Upload Avatar Modal -->
    <div class="modal" id="avatarModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Upload Profile Picture</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="avatarForm" action="${pageContext.request.contextPath}/admin/profile/upload-avatar" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="profileImage">Select Image</label>
                        <input type="file" id="profileImage" name="profileImage" accept="image/*" required>
                        <div class="form-hint">
                            Recommended size: 300x300 pixels. Max file size: 5MB.
                        </div>
                    </div>
                    
                    <div id="imagePreviewContainer" style="display: none; text-align: center; margin-top: 20px;">
                        <img id="imagePreview" src="#" alt="Image Preview" style="max-width: 100%; max-height: 200px; border-radius: 50%;">
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelAvatarBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Upload</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Two-Factor Setup Modal -->
    <div class="modal" id="twoFactorModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Set Up Two-Factor Authentication</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <div class="setup-steps">
                    <div class="step">
                        <h3>1. Scan QR Code</h3>
                        <p>Scan this QR code with your authenticator app (Google Authenticator, Authy, etc.).</p>
                        <div class="qr-container" id="qrCode">
                            <!-- QR code will be inserted here -->
                        </div>
                    </div>
                    
                    <div class="step">
                        <h3>2. Enter Verification Code</h3>
                        <p>Enter the 6-digit verification code from your authenticator app.</p>
                        <form id="verifyTwoFactorForm" action="${pageContext.request.contextPath}/admin/profile/verify-2fa" method="post">
                            <div class="form-group">
                                <input type="text" id="verificationCode" name="verificationCode" placeholder="6-digit code" maxlength="6" required>
                            </div>
                            
                            <div class="form-actions">
                                <button type="button" class="btn btn-secondary" id="cancelTwoFactorBtn">Cancel</button>
                                <button type="submit" class="btn btn-primary">Verify & Enable</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar
        document.getElementById('toggleSidebar').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('collapsed');
            document.querySelector('.main-content').classList.toggle('expanded');
        });
        
        // Modal elements
        const profileModal = document.getElementById('profileModal');
        const avatarModal = document.getElementById('avatarModal');
        const twoFactorModal = document.getElementById('twoFactorModal');
        const closeButtons = document.querySelectorAll('.close-btn');
        
        // Edit Profile
        document.getElementById('editProfileBtn').addEventListener('click', function() {
            profileModal.style.display = 'block';
        });
        
        document.getElementById('cancelEditBtn').addEventListener('click', function() {
            profileModal.style.display = 'none';
        });
        
        // Upload Avatar
        document.getElementById('uploadAvatarBtn').addEventListener('click', function() {
            avatarModal.style.display = 'block';
        });
        
        document.getElementById('cancelAvatarBtn').addEventListener('click', function() {
            avatarModal.style.display = 'none';
        });
        
        // Image Preview
        document.getElementById('profileImage').addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imagePreview').src = e.target.result;
                    document.getElementById('imagePreviewContainer').style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
        
        // Two-Factor Authentication
        document.getElementById('enableTwoFactor').addEventListener('change', function() {
            if (this.checked) {
                document.getElementById('setupTwoFactorBtn').style.display = 'block';
                document.getElementById('disableTwoFactorBtn').style.display = 'none';
            } else {
                document.getElementById('setupTwoFactorBtn').style.display = 'none';
                document.getElementById('disableTwoFactorBtn').style.display = 'block';
            }
        });
        
        document.getElementById('setupTwoFactorBtn').addEventListener('click', function() {
            // In a real implementation, you would fetch the QR code from server
            fetch('${pageContext.request.contextPath}/admin/profile/generate-2fa-qr')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('qrCode').innerHTML = `<img src="${data.qrCodeUrl}" alt="QR Code">`;
                    twoFactorModal.style.display = 'block';
                })
                .catch(error => {
                    console.error('Error fetching QR code:', error);
                    alert('Failed to generate QR code. Please try again.');
                });
        });
        
        document.getElementById('disableTwoFactorBtn').addEventListener('click', function() {
            if (confirm('Are you sure you want to disable two-factor authentication? This will reduce the security of your account.')) {
                fetch('${pageContext.request.contextPath}/admin/profile/disable-2fa', {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('enableTwoFactor').checked = false;
                        document.getElementById('setupTwoFactorBtn').style.display = 'block';
                        document.getElementById('disableTwoFactorBtn').style.display = 'none';
                        alert('Two-factor authentication has been disabled.');
                    } else {
                        alert('Failed to disable two-factor authentication. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error disabling 2FA:', error);
                    alert('An error occurred. Please try again.');
                });
            }
        });
        
        document.getElementById('cancelTwoFactorBtn').addEventListener('click', function() {
            twoFactorModal.style.display = 'none';
        });
        
        // Tab Navigation
        document.querySelectorAll('.nav-item').forEach(tab => {
            tab.addEventListener('click', function() {
                const tabId = this.getAttribute('data-tab');
                
                // Remove active class from all tabs and contents
                document.querySelectorAll('.nav-item').forEach(item => {
                    item.classList.remove('active');
                });
                document.querySelectorAll('.tab-content').forEach(content => {
                    content.classList.remove('active');
                });
                
                // Add active class to clicked tab and corresponding content
                this.classList.add('active');
                document.getElementById(tabId).classList.add('active');
            });
        });
        
        // Password confirmation validation
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please try again.');
            }
        });
        
        // Close modals
        closeButtons.forEach(button => {
            button.addEventListener('click', function() {
                profileModal.style.display = 'none';
                avatarModal.style.display = 'none';
                twoFactorModal.style.display = 'none';
            });
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(e) {
            if (e.target === profileModal) {
                profileModal.style.display = 'none';
            }
            if (e.target === avatarModal) {
                avatarModal.style.display = 'none';
            }
            if (e.target === twoFactorModal) {
                twoFactorModal.style.display = 'none';
            }
        });
    </script>
</body>
</html> 