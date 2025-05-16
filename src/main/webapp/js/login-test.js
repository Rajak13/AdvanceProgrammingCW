// Login Test Script
document.addEventListener('DOMContentLoaded', function() {
    // Function to log session info
    function logSessionInfo(label) {
        console.log(`\n=== ${label} ===`);
        console.log('All Cookies:', document.cookie);
        const sessionId = document.cookie.split(';').find(c => c.trim().startsWith('JSESSIONID='));
        console.log('Session ID:', sessionId ? sessionId.split('=')[1] : 'Not found');
    }

    // Log initial state
    logSessionInfo('Before Login');

    // Add event listener to login form
    const loginForm = document.querySelector('form[action*="login"]');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            // Log state just before form submission
            logSessionInfo('During Login (Form Submit)');
            
            // After a short delay to allow login to complete
            setTimeout(() => {
                logSessionInfo('After Login');
            }, 1000);
        });
    }
});

// Network monitoring
if (window.performance && window.performance.getEntriesByType) {
    const observer = new PerformanceObserver((list) => {
        for (const entry of list.getEntries()) {
            if (entry.name.includes('/login')) {
                console.log('\n=== Network Request ===');
                console.log('URL:', entry.name);
                console.log('Type:', entry.initiatorType);
                console.log('Duration:', entry.duration);
            }
        }
    });
    
    observer.observe({ entryTypes: ['resource'] });
}

console.log('=== Login Panel Status ===');
console.log('Current URL:', window.location.href);
console.log('Active Panel:', document.getElementById('container').classList.contains('right-panel-active') ? 'Register' : 'Login');

// Check for form elements
const loginForm = document.querySelector('.sign-in-container form');
const registerForm = document.querySelector('.sign-up-container form');

console.log('Login Form Present:', !!loginForm);
console.log('Register Form Present:', !!registerForm);

if (loginForm) {
    console.log('Login Form Fields:', {
        username: !!loginForm.querySelector('input[name="username"]'),
        password: !!loginForm.querySelector('input[name="password"]'),
        remember: !!loginForm.querySelector('input[name="remember"]')
    });
}

if (registerForm) {
    console.log('Register Form Fields:', {
        name: !!registerForm.querySelector('input[name="name"]'),
        email: !!registerForm.querySelector('input[name="email"]'),
        password: !!registerForm.querySelector('input[name="password"]'),
        confirmPassword: !!registerForm.querySelector('input[name="confirmPassword"]')
    });
}

// Check for error/success messages
const errorMessage = document.querySelector('.error-message');
const successMessage = document.querySelector('.success-message');

console.log('Error Message Present:', !!errorMessage);
console.log('Success Message Present:', !!successMessage);

// Check session and cookies
console.log('=== Session & Cookie Status ===');
console.log('All Cookies:', document.cookie);
console.log('Session ID:', document.cookie.includes('JSESSIONID') ? 'Found' : 'Not found'); 