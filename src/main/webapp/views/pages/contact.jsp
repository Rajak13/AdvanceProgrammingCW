<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Contact Banner -->
<section class="contact-banner">
    <div class="container">
        <div class="contact-banner-content">
            <h1>Contact Us</h1>
            <p>We'd love to hear from you! Get in touch with our team.</p>
        </div>
    </div>
</section>

<!-- Contact Information and Form -->
<section class="contact-section">
    <div class="container">
        <div class="contact-container">
            <div class="contact-info">
                <h2>Get In Touch</h2>
                <p>Have questions, feedback, or need assistance? Our team is here to help you with anything related to books or your purchase.</p>
                
                <div class="info-items">
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="info-content">
                            <h3>Our Location</h3>
                            <p>123 Putali Sadak<br>Kathmandu, Nepal</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-phone-alt"></i>
                        </div>
                        <div class="info-content">
                            <h3>Phone</h3>
                            <p>+977 987-654-3210</p>
                            <p>+977 123-456-7890</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <h3>Email</h3>
                            <p>info@pannabookstore.com</p>
                            <p>support@pannabookstore.com</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="info-content">
                            <h3>Opening Hours</h3>
                            <p>Monday - Saturday: 9:00 AM - 8:00 PM</p>
                            <p>Sunday: 10:00 AM - 6:00 PM</p>
                        </div>
                    </div>
                </div>
                
                <div class="social-links">
                    <h3>Follow Us</h3>
                    <div class="social-icons">
                        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-pinterest"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="contact-form-container">
                <h2>Send Us a Message</h2>
                
                <c:if test="${not empty successMessage}">
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <form class="contact-form" action="${pageContext.request.contextPath}/contact" method="post">
                    <div class="form-group">
                        <label for="name">Your Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Your Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone">
                    </div>
                    
                    <div class="form-group">
                        <label for="subject">Subject <span class="required">*</span></label>
                        <input type="text" id="subject" name="subject" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="message">Your Message <span class="required">*</span></label>
                        <textarea id="message" name="message" rows="5" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Send Message</button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Map Section -->
<section class="map-section">
    <div class="container">
        <div class="section-header">
            <h2>Find Us</h2>
            <p>Visit our store in Kathmandu</p>
        </div>
        <div class="map-container">
            <!-- Replace with your actual map embed code -->
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14129.303504508453!2d85.3053454779098!3d27.707269388017267!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39eb19034f8252c5%3A0x2dc3c622d89fc76f!2sPutalisadak%2C%20Kathmandu%2044600!5e0!3m2!1sen!2snp!4v1629979571265!5m2!1sen!2snp" 
                    width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
        </div>
    </div>
</section>

<section class="suggestion-link-section">
    <div class="container">
        <div class="suggestion-link-content">
            <h2>Want to Suggest a Book?</h2>
            <p>Help us grow our collection by suggesting books you'd like to see in our store</p>
            <a href="${pageContext.request.contextPath}/suggest" class="btn btn-primary">Suggest a Book</a>
        </div>
    </div>
</section>

<style>
    .contact-banner {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        color: var(--white);
        padding: 60px 0;
        text-align: center;
    }
    
    .contact-banner h1 {
        font-size: 36px;
        margin-bottom: 15px;
    }
    
    .contact-banner p {
        max-width: 700px;
        margin: 0 auto;
        opacity: 0.9;
    }
    
    .contact-section {
        padding: 80px 0;
        background-color: var(--white);
    }
    
    .contact-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 50px;
        align-items: start;
    }
    
    .contact-info h2,
    .contact-form-container h2 {
        color: var(--primary-dark);
        margin-bottom: 20px;
        font-size: 28px;
    }
    
    .contact-info > p {
        margin-bottom: 30px;
        color: var(--light-text);
    }
    
    .info-items {
        display: grid;
        gap: 25px;
        margin-bottom: 30px;
    }
    
    .info-item {
        display: flex;
        align-items: flex-start;
        gap: 15px;
    }
    
    .info-icon {
        width: 50px;
        height: 50px;
        background-color: var(--light-bg);
        color: var(--accent-color);
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-size: 20px;
        flex-shrink: 0;
    }
    
    .info-content h3 {
        margin-bottom: 8px;
        color: var(--primary-dark);
        font-size: 18px;
    }
    
    .info-content p {
        color: var(--light-text);
        margin-bottom: 5px;
    }
    
    .social-links h3 {
        color: var(--primary-dark);
        margin-bottom: 15px;
        font-size: 18px;
    }
    
    .social-icons {
        display: flex;
        gap: 15px;
    }
    
    .social-icon {
        width: 40px;
        height: 40px;
        background-color: var(--light-bg);
        color: var(--primary-dark);
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        transition: var(--transition);
    }
    
    .social-icon:hover {
        background-color: var(--accent-color);
        color: var(--white);
    }
    
    .contact-form-container {
        background-color: var(--light-bg);
        padding: 30px;
        border-radius: 10px;
        box-shadow: var(--shadow);
    }
    
    .contact-form .form-group {
        margin-bottom: 20px;
    }
    
    .contact-form label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--primary-dark);
    }
    
    .required {
        color: var(--accent-color);
    }
    
    .contact-form input,
    .contact-form textarea,
    .suggestion-form input,
    .suggestion-form textarea,
    .suggestion-form select {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-family: 'Poppins', sans-serif;
        font-size: 14px;
        transition: var(--transition);
    }
    
    .contact-form input:focus,
    .contact-form textarea:focus,
    .suggestion-form input:focus,
    .suggestion-form textarea:focus,
    .suggestion-form select:focus {
        border-color: var(--accent-color);
        box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
        outline: none;
    }
    
    .map-section {
        padding: 60px 0;
        background-color: var(--light-bg);
    }
    
    .map-container {
        margin-top: 30px;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: var(--shadow);
    }
    
    .suggestion-section {
        padding: 80px 0;
        background-color: var(--white);
    }
    
    .suggestion-form-container {
        max-width: 800px;
        margin: 40px auto 0;
        background-color: var(--light-bg);
        padding: 30px;
        border-radius: 10px;
        box-shadow: var(--shadow);
    }
    
    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }
    
    .suggestion-form .form-group {
        margin-bottom: 20px;
    }
    
    .success-message,
    .error-message {
        padding: 12px 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
    }
    
    .success-message {
        background-color: rgba(76, 175, 80, 0.1);
        color: #4CAF50;
        border-left: 4px solid #4CAF50;
    }
    
    .error-message {
        background-color: rgba(244, 67, 54, 0.1);
        color: #F44336;
        border-left: 4px solid #F44336;
    }
    
    .success-message i,
    .error-message i {
        margin-right: 10px;
        font-size: 16px;
    }
    .suggestion-link-section {
        padding: 60px 0;
        background-color: var(--light-bg);
        text-align: center;
    }
    .suggestion-link-content h2 {
        color: var(--primary-dark);
        margin-bottom: 15px;
    }
    
    .suggestion-link-content p {
        margin-bottom: 25px;
        color: var(--text-color);
    }
    
    .suggestion-link-content .btn {
        display: inline-block;
        padding: 12px 30px;
        font-size: 16px;
    }
    .suggestion-link-content {
        max-width: 600px;
        margin: 0 auto;
    }
    @media (max-width: 768px) {
        .contact-container {
            grid-template-columns: 1fr;
        }
        
        .form-row {
            grid-template-columns: 1fr;
            gap: 0;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Auto-hide success and error messages after 5 seconds
        const successMessages = document.querySelectorAll('.success-message');
        const errorMessages = document.querySelectorAll('.error-message');
        
        const hideMessages = function(messages) {
            messages.forEach(message => {
                setTimeout(() => {
                    message.style.opacity = '0';
                    setTimeout(() => {
                        message.style.display = 'none';
                    }, 500);
                }, 5000);
            });
        };
        
        hideMessages(successMessages);
        hideMessages(errorMessages);
        
        // Form validation
        const contactForm = document.querySelector('.contact-form');
        const suggestionForm = document.querySelector('.suggestion-form');
        
        if (contactForm) {
            contactForm.addEventListener('submit', function(e) {
                const nameInput = document.getElementById('name');
                const emailInput = document.getElementById('email');
                const messageInput = document.getElementById('message');
                
                let valid = true;
                
                if (!nameInput.value.trim()) {
                    valid = false;
                    nameInput.style.borderColor = '#F44336';
                } else {
                    nameInput.style.borderColor = '#ddd';
                }
                
                if (!emailInput.value.trim() || !isValidEmail(emailInput.value)) {
                    valid = false;
                    emailInput.style.borderColor = '#F44336';
                } else {
                    emailInput.style.borderColor = '#ddd';
                }
                
                if (!messageInput.value.trim()) {
                    valid = false;
                    messageInput.style.borderColor = '#F44336';
                } else {
                    messageInput.style.borderColor = '#ddd';
                }
                
                if (!valid) {
                    e.preventDefault();
                }
            });
        }
        
        if (suggestionForm) {
            suggestionForm.addEventListener('submit', function(e) {
                const bookTitleInput = document.getElementById('book-title');
                const emailAddressInput = document.getElementById('email-address');
                
                let valid = true;
                
                if (!bookTitleInput.value.trim()) {
                    valid = false;
                    bookTitleInput.style.borderColor = '#F44336';
                } else {
                    bookTitleInput.style.borderColor = '#ddd';
                }
                
                if (!emailAddressInput.value.trim() || !isValidEmail(emailAddressInput.value)) {
                    valid = false;
                    emailAddressInput.style.borderColor = '#F44336';
                } else {
                    emailAddressInput.style.borderColor = '#ddd';
                }
                
                if (!valid) {
                    e.preventDefault();
                }
            });
        }
        
        function isValidEmail(email) {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        }
    });
</script> 