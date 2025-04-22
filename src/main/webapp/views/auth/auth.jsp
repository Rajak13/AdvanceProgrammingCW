<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login & Register - Panna BookStore</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:400,600,700,800&display=swap" rel="stylesheet">
</head>
<body>
    
    <div class="container" id="container">
        <div class="form-container sign-up-container">
            <form action="<%=request.getContextPath()%>/register" method="post">
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
                
                <input type="text" name="username" placeholder="Username" required />
                <input type="email" name="email" placeholder="Email" required />
                <input type="tel" name="contact" placeholder="Phone Number" />
                <input type="text" name="address" placeholder="Address" />
                <input type="password" name="password" placeholder="Password" required />
                <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
                
                <div class="checkbox-container">
                    <input type="checkbox" id="terms" name="terms" required />
                    <label for="terms">I agree to all Terms & Conditions</label>
                </div>
                
                <button type="submit">Sign Up</button>
            </form>
        </div>
        <div class="form-container sign-in-container">
            <form action="<%=request.getContextPath()%>/login" method="post">
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
                
                <input type="text" name="username" placeholder="Username" required />
                <input type="password" name="password" placeholder="Password" required />
                
                <div class="checkbox-container">
                    <input type="checkbox" id="remember" name="remember" />
                    <label for="remember">Remember me</label>
                </div>
                
                <a href="<%=request.getContextPath()%>/forgotPassword">Forgot your password?</a>
                <button type="submit">Sign In</button>
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h1>Welcome Back!</h1>
                    <p>To keep connected with us please login with your personal info</p>
                    <button class="ghost" id="signIn">Sign In</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h1>Hello, Book Lover!</h1>
                    <p>Enter your personal details and start your reading journey with us</p>
                    <button class="ghost" id="signUp">Sign Up</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const signUpButton = document.getElementById('signUp');
        const signInButton = document.getElementById('signIn');
        const container = document.getElementById('container');
        
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
            mobileSignUpButton.innerText = 'Don\'t have an account? Sign Up';
            mobileSignUpButton.classList.add('mobile-toggle');
            mobileSignUpButton.type = 'button';
            
            const mobileSignInButton = document.createElement('button');
            mobileSignInButton.innerText = 'Already have an account? Sign In';
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