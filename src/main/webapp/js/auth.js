document.addEventListener('DOMContentLoaded', function() {
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const container = document.getElementById('container');
    
    // Check if we should show register panel by default
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('panel') === 'register') {
        container.classList.add('right-panel-active');
    }
    
    // Enhanced click handlers with animation
    signUpButton.addEventListener('click', () => {
        container.classList.add('right-panel-active');
        // Add animation class
        container.classList.add('animate');
        setTimeout(() => {
            container.classList.remove('animate');
        }, 600);
    });
    
    signInButton.addEventListener('click', () => {
        container.classList.remove('right-panel-active');
        // Add animation class
        container.classList.add('animate');
        setTimeout(() => {
            container.classList.remove('animate');
        }, 600);
    });
    
    // Auto-hide messages with fade effect
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
    
    // Password strength indicator
    const passwordInputs = document.querySelectorAll('input[type="password"]');
    passwordInputs.forEach(input => {
        input.addEventListener('input', function() {
            const strength = checkPasswordStrength(this.value);
            updatePasswordStrengthIndicator(this, strength);
        });
    });
    
    function checkPasswordStrength(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (password.match(/[a-z]+/)) strength++;
        if (password.match(/[A-Z]+/)) strength++;
        if (password.match(/[0-9]+/)) strength++;
        if (password.match(/[^a-zA-Z0-9]+/)) strength++;
        return strength;
    }
    
    function updatePasswordStrengthIndicator(input, strength) {
        const parent = input.parentElement;
        let indicator = parent.querySelector('.password-strength');
        
        if (!indicator) {
            indicator = document.createElement('div');
            indicator.className = 'password-strength';
            parent.appendChild(indicator);
        }
        
        const strengthText = ['Very Weak', 'Weak', 'Medium', 'Strong', 'Very Strong'];
        const strengthColors = ['#ff4444', '#ffbb33', '#ffeb3b', '#00C851', '#007E33'];
        
        indicator.textContent = strengthText[strength - 1] || '';
        indicator.style.color = strengthColors[strength - 1] || '';
    }
    
    // Form validation
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            let isValid = true;
            const inputs = form.querySelectorAll('input[required]');
            
            inputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    input.classList.add('error');
                } else {
                    input.classList.remove('error');
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                // Show error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> Please fill in all required fields';
                form.insertBefore(errorDiv, form.firstChild);
                
                setTimeout(() => {
                    errorDiv.style.opacity = '0';
                    setTimeout(() => {
                        errorDiv.remove();
                    }, 500);
                }, 3000);
            }
        });
    });
    
    // Input focus effects
    const inputs = document.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            if (!this.value) {
                this.parentElement.classList.remove('focused');
            }
        });
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
            container.classList.add('animate');
            setTimeout(() => {
                container.classList.remove('animate');
            }, 600);
        });
        
        mobileSignInButton.addEventListener('click', (e) => {
            e.preventDefault();
            container.classList.remove('right-panel-active');
            container.classList.add('animate');
            setTimeout(() => {
                container.classList.remove('animate');
            }, 600);
        });
    }
    
    // Check if mobile view
    function checkMobileView() {
        if (window.innerWidth <= 768) {
            setupMobileToggles();
            document.body.classList.add('mobile-view');
        } else {
            document.body.classList.remove('mobile-view');
            const existingToggles = document.querySelectorAll('.mobile-toggle');
            existingToggles.forEach(toggle => toggle.remove());
        }
    }
    
    // Initial check
    checkMobileView();
    
    // Handle resize
    window.addEventListener('resize', checkMobileView);
});