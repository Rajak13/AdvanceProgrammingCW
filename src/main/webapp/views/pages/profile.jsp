<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Profile - PannaBookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
        }
        
        .profile-header h1 {
            font-size: 32px;
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 10px;
            position: relative;
            display: inline-block;
        }
        
        .profile-header h1::after {
            content: '';
            height: 3px;
            width: 60%;
            background: var(--accent-color);
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }
        
        .profile-header p {
            color: var(--light-text);
            font-size: 16px;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .profile-content {
            display: flex;
            gap: 2rem;
            background: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }
        
        .profile-sidebar {
            width: 300px;
            flex-shrink: 0;
            border-right: 1px solid #eee;
            padding-right: 2rem;
        }
        
        .profile-picture {
            width: 150px;
            height: 150px;
            margin: 0 auto;
            border-radius: 50%;
            background: var(--light-bg);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            margin-bottom: 1rem;
            border: 3px solid var(--accent-color);
        }
        
        .profile-picture img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .profile-initials {
            font-size: 3rem;
            color: var(--primary-dark);
            font-weight: 600;
        }
        
        .profile-stats {
            display: flex;
            justify-content: space-around;
            margin-top: 2rem;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: var(--border-radius);
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-item i {
            font-size: 1.5rem;
            color: var(--accent-color);
            margin-bottom: 0.5rem;
        }
        
        .stat-item span {
            display: block;
            color: var(--light-text);
            font-size: 14px;
            margin-bottom: 0.25rem;
        }
        
        .stat-item strong {
            color: var(--primary-dark);
            font-size: 18px;
        }
        
        .profile-main {
            flex-grow: 1;
        }
        
        .profile-form {
            max-width: 600px;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--primary-dark);
        }
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
            outline: none;
        }
        
        .picture-upload {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .picture-upload input[type="file"] {
            display: none;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-size: 1rem;
            transition: var(--transition);
            font-weight: 500;
        }
        
        .btn-primary {
            background-color: var(--accent-color);
            color: var(--white);
        }
        
        .btn-secondary {
            background-color: var(--secondary-color);
            color: var(--white);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1rem;
            font-weight: 500;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            padding: 10px 20px;
            background-color: var(--secondary-color);
            color: var(--white);
            text-decoration: none;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition);
        }

        .back-button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .confirmation-dialog {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .confirmation-content {
            background-color: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            text-align: center;
            max-width: 400px;
            width: 90%;
            box-shadow: var(--shadow);
        }

        .confirmation-content h3 {
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }

        .confirmation-content p {
            color: var(--light-text);
            margin-bottom: 1.5rem;
        }

        .confirmation-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 1.5rem;
        }

        @media (max-width: 768px) {
            .profile-content {
                flex-direction: column;
            }
            
            .profile-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #eee;
                padding-right: 0;
                padding-bottom: 2rem;
                margin-bottom: 2rem;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Home
    </a>
    
    <div class="profile-container">
        <div class="profile-header">
            <h1>My Profile</h1>
            <p>Manage your account information and profile picture</p>
        </div>
        
        <div class="profile-content">
            <div class="profile-sidebar">
                <div class="profile-picture">
                    <c:choose>
                        <c:when test="${not empty user.picture}">
                            <img src="${pageContext.request.contextPath}/files/${user.picture}" alt="Profile Picture" id="profileImage">
                        </c:when>
                        <c:otherwise>
                            <div class="profile-initials" id="profileInitials">${fn:toUpperCase(fn:substring(user.name, 0, 1))}</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="profile-stats">
                    <div class="stat-item">
                        <i class="fas fa-shopping-bag"></i>
                        <span>Orders</span>
                        <strong>0</strong>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-heart"></i>
                        <span>Wishlist</span>
                        <strong>0</strong>
                    </div>
                </div>
            </div>
            
            <div class="profile-main">
                <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="profile-form" id="profileForm">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">${errorMessage}</div>
                    </c:if>
                    
                    <div class="form-group">
                        <label for="picture">Profile Picture</label>
                        <div class="picture-upload">
                            <input type="file" id="picture" name="picture" accept="image/*">
                            <button type="button" class="btn btn-secondary" onclick="document.getElementById('picture').click()">
                                <i class="fas fa-upload"></i> Upload Picture
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" value="${user.name}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="${user.email}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" value="${user.contact}">
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" rows="3">${user.address}</textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <button type="button" class="btn btn-secondary" onclick="showConfirmation()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Confirmation Dialog -->
    <div class="confirmation-dialog" id="confirmationDialog">
        <div class="confirmation-content">
            <h3>Are you sure?</h3>
            <p>You have unsaved changes. Do you want to leave without saving?</p>
            <div class="confirmation-buttons">
                <button class="btn btn-primary" onclick="goBack()">Yes, Leave</button>
                <button class="btn btn-secondary" onclick="hideConfirmation()">No, Stay</button>
            </div>
        </div>
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
                        document.querySelector('.profile-picture').appendChild(img);
                    }
                };
                reader.readAsDataURL(file);
            }
        });

        // Form change tracking
        let formChanged = false;
        const form = document.getElementById('profileForm');
        
        form.addEventListener('change', function() {
            formChanged = true;
        });

        // Confirmation dialog functions
        function showConfirmation() {
            if (formChanged) {
                document.getElementById('confirmationDialog').style.display = 'flex';
            } else {
                goBack();
            }
        }

        function hideConfirmation() {
            document.getElementById('confirmationDialog').style.display = 'none';
        }

        function goBack() {
            window.location.href = '${pageContext.request.contextPath}/';
        }

        // Handle form submission
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/profile', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.redirected) {
                    window.location.href = response.url;
                } else {
                    return response.text();
                }
            })
            .then(html => {
                if (html) {
                    // Update the page content without full reload
                    document.open();
                    document.write(html);
                    document.close();
                    formChanged = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating profile. Please try again.');
            });
        });
    </script>
</body>

</html>