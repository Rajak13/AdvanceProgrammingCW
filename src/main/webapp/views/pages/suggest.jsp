<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Suggestion Banner -->
<section class="suggestion-banner">
    <div class="container">
        <div class="suggestion-banner-content">
            <h1>Suggest a Book</h1>
            <p>Help us grow our collection by suggesting books you'd like to see in our store</p>
        </div>
    </div>
</section>

<!-- Suggestion Form Section -->
<section class="suggestion-section">
    <div class="container">
        <div class="suggestion-form-container">
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
            
            <form class="suggestion-form" action="${pageContext.request.contextPath}/suggest-book" method="post" id="suggestionForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="suggestedBook">Book Title <span class="required">*</span></label>
                        <input type="text" id="suggestedBook" name="suggestedBook" required 
                               placeholder="Enter the book title">
                        <div class="error-message" id="suggestedBookError"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="writer">Author</label>
                        <input type="text" id="writer" name="writer" 
                               placeholder="Enter the author's name">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category">
                            <option value="">Select Category</option>
                            <option value="Fiction">Fiction</option>
                            <option value="Non-Fiction">Non-Fiction</option>
                            <option value="Children">Children's Books</option>
                            <option value="Textbooks">Textbooks</option>
                            <option value="Nepali">Nepali Literature</option>
                            <option value="Biography">Biography</option>
                            <option value="History">History</option>
                            <option value="Science">Science</option>
                            <option value="Technology">Technology</option>
                            <option value="Self-Help">Self-Help</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3" 
                              placeholder="Tell us more about the book (optional)"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">Submit Suggestion</button>
            </form>
        </div>
    </div>
</section>

<style>
    .suggestion-banner {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        color: var(--white);
        padding: 80px 0;
        text-align: center;
    }
    
    .suggestion-banner h1 {
        font-size: 42px;
        margin-bottom: 15px;
    }
    
    .suggestion-banner p {
        font-size: 18px;
        max-width: 700px;
        margin: 0 auto;
        opacity: 0.9;
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
    
    .suggestion-form label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--primary-dark);
    }
    
    .required {
        color: var(--accent-color);
    }
    
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
    
    .suggestion-form input:focus,
    .suggestion-form textarea:focus,
    .suggestion-form select:focus {
        border-color: var(--accent-color);
        box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
        outline: none;
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
    
    @media (max-width: 768px) {
        .form-row {
            grid-template-columns: 1fr;
            gap: 0;
        }
        
        .suggestion-banner h1 {
            font-size: 32px;
        }
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const suggestionForm = document.getElementById('suggestionForm');
    const suggestedBookInput = document.getElementById('suggestedBook');
    
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
    if (suggestionForm) {
        suggestionForm.addEventListener('submit', function(e) {
            let valid = true;
            
            // Validate book title
            if (!suggestedBookInput.value.trim()) {
                valid = false;
                suggestedBookInput.style.borderColor = '#F44336';
                document.getElementById('suggestedBookError').textContent = 'Book title is required';
                document.getElementById('suggestedBookError').style.display = 'block';
            } else {
                suggestedBookInput.style.borderColor = '#ddd';
                document.getElementById('suggestedBookError').style.display = 'none';
            }
            
            if (!valid) {
                e.preventDefault();
            }
        });
    }
});
</script> 