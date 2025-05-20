<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login & Register - Panna BookStore</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    
    <div class="container" id="container" class="${activePanel == 'register' ? 'right-panel-active' : ''}">
        <div class="form-container sign-up-container">
            <form action="${pageContext.request.contextPath}/auth/register" method="post">
                <h1>Create Account</h1>
                
                <c:if test="${not empty errorMessage}">
                    <div class="error-message" id="errorMessage">
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="success-message" id="successMessage">
                        <i class="fas fa-check-circle"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" name="name" placeholder="Full Name" required />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" name="email" placeholder="Email" required />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-phone input-icon"></i>
                        <input type="tel" name="contact" placeholder="Phone Number" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-map-marker-alt input-icon"></i>
                        <input type="text" name="address" placeholder="Address" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" name="password" placeholder="Password" required />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
                    </div>
                </div>
                
                <div class="checkbox-container">
                    <input type="checkbox" id="terms" name="terms" required />
                    <label for="terms">I agree to all Terms & Conditions</label>
                </div>
                
                <button type="submit">
                    <i class="fas fa-user-plus"></i> Sign Up
                </button>
            </form>
        </div>
        <div class="form-container sign-in-container">
            <form action="${pageContext.request.contextPath}/auth/login" method="post">
                <h1>Sign In</h1>
                
                <c:if test="${not empty errorMessage}">
                    <div class="error-message" id="errorMessage">
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="success-message" id="successMessage">
                        <i class="fas fa-check-circle"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" name="email" placeholder="Email" required />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" name="password" placeholder="Password" required />
                    </div>
                </div>
                
                <div class="checkbox-container">
                    <input type="checkbox" id="remember" name="remember" />
                    <label for="remember">Remember me</label>
                </div>
                
                <a href="${pageContext.request.contextPath}/auth/forgot-password" class="forgot-password-link">
                    <i class="fas fa-key"></i> Forgot your password?
                </a>
                <button type="submit">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h1>Welcome Back!</h1>
                    <p>To keep connected with us please login with your personal info</p>
                    <button class="ghost" id="signIn">
                        <i class="fas fa-sign-in-alt"></i> Sign In
                    </button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h1>Hello, Book Lover!</h1>
                    <p>Enter your personal details and start your reading journey with us</p>
                    <button class="ghost" id="signUp">
                        <i class="fas fa-user-plus"></i> Sign Up
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const signUpButton = document.getElementById('signUp');
        const signInButton = document.getElementById('signIn');
        const container = document.getElementById('container');
        
        // Check if we should show register panel by default
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('panel') === 'register') {
            container.classList.add('right-panel-active');
        }
        
        signUpButton.addEventListener('click', () => {
            container.classList.add('right-panel-active');
        });
        
        signInButton.addEventListener('click', () => {
            container.classList.remove('right-panel-active');
        });
        
        // Auto-hide messages after 5 seconds
        const errorMessages = document.querySelectorAll('.error-message');
        const successMessages = document.querySelectorAll('.success-message');
        
        errorMessages.forEach(message => {
            setTimeout(() => {
                message.style.opacity = '0';
                setTimeout(() => {
                    message.style.display = 'none';
                }, 500);
            }, 5000);
        });
        
        successMessages.forEach(message => {
            setTimeout(() => {
                message.style.opacity = '0';
                setTimeout(() => {
                    message.style.display = 'none';
                }, 500);
            }, 5000);
        });
        
        // Mobile toggle for sign in/sign up
        function setupMobileToggles() {
            const mobileSignUpButton = document.createElement('button');
            mobileSignUpButton.innerHTML = '<i class="fas fa-user-plus"></i> Don\'t have an account? Sign Up';
            mobileSignUpButton.classList.add('mobile-toggle');
            mobileSignUpButton.type = 'button';
            
            const mobileSignInButton = document.createElement('button');
            mobileSignInButton.innerHTML = '<i class="fas fa-sign-in-alt"></i> Already have an account? Sign In';
            mobileSignInButton.classList.add('mobile-toggle');
            mobileSignInButton.type = 'button';
            
            const signInForm = document.querySelector('.sign-in-container form');
            const signUpForm = document.querySelector('.sign-up-container form');
            
            // Remove any existing mobile toggles
            const existingToggles = document.querySelectorAll('.mobile-toggle');
            existingToggles.forEach(toggle => toggle.remove());
            
            signInForm.appendChild(mobileSignUpButton);
            signUpForm.appendChild(mobileSignInButton);
            
            mobileSignUpButton.addEventListener('click', (e) => {
                e.preventDefault();
                container.classList.add('right-panel-active');
            });
            
            mobileSignInButton.addEventListener('click', (e) => {
                e.preventDefault();
                container.classList.remove('right-panel-active');
            });
        }
        
        // Check if mobile view
        function checkMobileView() {
            if (window.innerWidth <= 768) {
                setupMobileToggles();
                // Add class for mobile view
                document.body.classList.add('mobile-view');
            } else {
                document.body.classList.remove('mobile-view');
                // Remove mobile toggles if they exist
                const existingToggles = document.querySelectorAll('.mobile-toggle');
                existingToggles.forEach(toggle => toggle.remove());
            }
        }
        
        // Initial check
        checkMobileView();
        
        // Handle resize
        window.addEventListener('resize', checkMobileView);
    </script>
</body>
</html>