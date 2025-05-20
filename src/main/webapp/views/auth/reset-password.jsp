<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Panna BookStore</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #8D6E63;
            --primary-dark: #5D4037;
            --secondary-color: #607D8B;
            --accent-color: #FF5722;
            --text-color: #333333;
            --light-text: #757575;
            --light-bg: #F5F5F5;
            --white: #FFFFFF;
            --shadow: 0 2px 10px rgba(0,0,0,0.1);
            --border-radius: 4px;
            --transition: all 0.3s ease;
        }

        .auth-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--light-bg) 0%, #e0e0e0 100%);
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 450px;
        }

        .auth-card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            padding: 30px;
        }

        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .auth-header h2 {
            color: var(--primary-dark);
            font-size: 24px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .auth-header p {
            color: var(--light-text);
            font-size: 14px;
        }

        .auth-form .form-group {
            margin-bottom: 20px;
        }

        .auth-form label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-color);
            font-weight: 500;
        }

        .auth-form label i {
            color: var(--primary-color);
            margin-right: 8px;
        }

        .auth-form input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 14px;
            transition: var(--transition);
        }

        .auth-form input:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
            outline: none;
        }

        .auth-form input:invalid {
            border-color: #ffcdd2;
        }

        .auth-form input:invalid:focus {
            border-color: #c62828;
            box-shadow: 0 0 0 2px rgba(198, 40, 40, 0.1);
        }

        .password-requirements {
            margin-top: 5px;
            font-size: 12px;
            color: var(--light-text);
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--accent-color);
            color: var(--white);
        }

        .btn-primary:hover {
            background: #E64A19;
            transform: translateY(-2px);
        }

        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .auth-links {
            margin-top: 20px;
            text-align: center;
        }

        .auth-links a {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: var(--transition);
        }

        .auth-links a:hover {
            color: var(--accent-color);
        }

        .alert {
            padding: 12px 15px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-danger {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }

        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }

        .password-strength {
            height: 4px;
            background: #eee;
            margin-top: 8px;
            border-radius: 2px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: var(--transition);
        }

        .strength-weak { background: #c62828; width: 33.33%; }
        .strength-medium { background: #f57c00; width: 66.66%; }
        .strength-strong { background: #2e7d32; width: 100%; }
    </style>
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2><i class="fas fa-key"></i> Reset Password</h2>
                <p>Enter your new password below</p>
            </div>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth/reset-password" method="post" class="auth-form" id="resetForm">
                <input type="hidden" name="email" value="${email}">
                
                <div class="form-group">
                    <label for="newPassword">
                        <i class="fas fa-lock"></i> New Password
                    </label>
                    <input type="password" id="newPassword" name="newPassword" required
                           minlength="8" pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
                           title="Password must be at least 8 characters long and include both letters and numbers">
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="password-requirements">
                        Password must be at least 8 characters long and include both letters and numbers
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Confirm Password
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>

                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="fas fa-save"></i> Reset Password
                </button>

                <div class="auth-links">
                    <a href="${pageContext.request.contextPath}/auth" class="back-to-login">
                        <i class="fas fa-arrow-left"></i> Back to Login
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const submitBtn = document.getElementById('submitBtn');
        const form = document.getElementById('resetForm');

        function checkPasswordStrength(password) {
            let strength = 0;
            if (password.length >= 8) strength++;
            if (password.match(/[A-Za-z]/)) strength++;
            if (password.match(/\d/)) strength++;
            if (password.match(/[^A-Za-z\d]/)) strength++;

            strengthBar.className = 'password-strength-bar';
            if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
            } else if (strength === 3) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        }

        newPassword.addEventListener('input', function() {
            checkPasswordStrength(this.value);
            validateForm();
        });

        confirmPassword.addEventListener('input', validateForm);

        function validateForm() {
            const passwordsMatch = newPassword.value === confirmPassword.value;
            const isStrongEnough = newPassword.value.length >= 8 && 
                                 /[A-Za-z]/.test(newPassword.value) && 
                                 /\d/.test(newPassword.value);
            
            submitBtn.disabled = !(passwordsMatch && isStrongEnough);
            
            if (confirmPassword.value && !passwordsMatch) {
                confirmPassword.setCustomValidity('Passwords do not match');
            } else {
                confirmPassword.setCustomValidity('');
            }
        }

        form.addEventListener('submit', function(e) {
            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html> 