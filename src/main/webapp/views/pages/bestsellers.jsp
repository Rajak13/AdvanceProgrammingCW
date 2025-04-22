<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Bestsellers Banner -->
<section class="page-banner bestsellers-banner">
    <div class="container">
        <div class="page-banner-content">
            <h1>Bestsellers</h1>
            <p>Our most popular books loved by readers</p>
        </div>
    </div>
</section>

<!-- Books Grid -->
<section class="books-section">
    <div class="container">
        <div class="books-filter">
            <div class="filter-item">
                <label for="sort-by">Sort By:</label>
                <select id="sort-by" class="filter-select">
                    <option value="popularity">Most Popular</option>
                    <option value="price-low">Price: Low to High</option>
                    <option value="price-high">Price: High to Low</option>
                    <option value="name-asc">Name: A to Z</option>
                    <option value="name-desc">Name: Z to A</option>
                </select>
            </div>
            <div class="filter-item">
                <label for="category-filter">Category:</label>
                <select id="category-filter" class="filter-select">
                    <option value="all">All Categories</option>
                    <option value="fiction">Fiction</option>
                    <option value="non-fiction">Non-Fiction</option>
                    <option value="children">Children's Books</option>
                    <option value="textbooks">Textbooks</option>
                    <option value="nepali">Nepali Literature</option>
                </select>
            </div>
        </div>
        
        <div class="books-grid">
            <c:if test="${empty books}">
                <div class="no-books-message">
                    <p>No bestsellers available at the moment. Check back soon for updates!</p>
                </div>
            </c:if>
            
            <c:forEach var="book" items="${books}">
                <div class="book-card">
                    <div class="book-image">
                        <img src="${book.picture != null ? book.picture : pageContext.request.contextPath.concat('/images/book-placeholder.jpg')}" alt="${book.bookName}">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View" data-book-id="${book.bookId}"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist" data-book-id="${book.bookId}"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart" data-book-id="${book.bookId}"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>${book.bookName}</h3>
                        <p class="book-author">${book.writerName}</p>
                        <div class="book-price">
                            <span class="current-price">NPR ${book.price}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <!-- Sample books for when the database is empty -->
            <c:if test="${empty books}">
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/71kxa1-0mfL.jpg" alt="Rich Dad Poor Dad">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>Rich Dad Poor Dad</h3>
                        <p class="book-author">Robert Kiyosaki</p>
                        <div class="book-price">
                            <span class="current-price">NPR 750</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/91bYsX41DVL.jpg" alt="Atomic Habits">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>Atomic Habits</h3>
                        <p class="book-author">James Clear</p>
                        <div class="book-price">
                            <span class="current-price">NPR 950</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://images-na.ssl-images-amazon.com/images/I/91vwHMt+x7L.jpg" alt="The Alchemist">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>The Alchemist</h3>
                        <p class="book-author">Paulo Coelho</p>
                        <div class="book-price">
                            <span class="current-price">NPR 850</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81wFMY9OAGL.jpg" alt="Think and Grow Rich">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>Think and Grow Rich</h3>
                        <p class="book-author">Napoleon Hill</p>
                        <div class="book-price">
                            <span class="current-price">NPR 780</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/91DNhLLmUOL.jpg" alt="Harry Potter and the Philosopher's Stone">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>Harry Potter and the Philosopher's Stone</h3>
                        <p class="book-author">J.K. Rowling</p>
                        <div class="book-price">
                            <span class="current-price">NPR 900</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/71aFt4+OTOL.jpg" alt="The Hobbit">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">Bestseller</div>
                    </div>
                    <div class="book-info">
                        <h3>The Hobbit</h3>
                        <p class="book-author">J.R.R. Tolkien</p>
                        <div class="book-price">
                            <span class="current-price">NPR 920</span>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}" class="page-link"><i class="fas fa-chevron-left"></i></a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${currentPage eq i}">
                            <span class="page-link active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="?page=${i}" class="page-link">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}" class="page-link"><i class="fas fa-chevron-right"></i></a>
                </c:if>
            </div>
        </c:if>
    </div>
</section>

<!-- Customer Reviews -->
<section class="reviews-section">
    <div class="container">
        <div class="section-header">
            <h2>What Readers Say</h2>
            <p>Reviews from our bestseller readers</p>
        </div>
        <div class="reviews-slider">
            <div class="review-card">
                <div class="review-rating">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                </div>
                <div class="review-text">
                    <i class="fas fa-quote-left"></i>
                    <p>"Rich Dad Poor Dad completely changed my perspective on money and investing. This book is a must-read for anyone looking to improve their financial literacy."</p>
                </div>
                <div class="reviewer">
                    <div class="reviewer-image">
                        <img src="${pageContext.request.contextPath}/images/reviewers/reviewer1.jpg" alt="Reviewer">
                    </div>
                    <div class="reviewer-info">
                        <h4>Sanjeev Kumar</h4>
                        <p>Businessman</p>
                    </div>
                </div>
            </div>
            
            <div class="review-card">
                <div class="review-rating">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star-half-alt"></i>
                </div>
                <div class="review-text">
                    <i class="fas fa-quote-left"></i>
                    <p>"Atomic Habits offers practical strategies to build good habits and break bad ones. I've already seen improvements in my daily routines after applying the principles."</p>
                </div>
                <div class="reviewer">
                    <div class="reviewer-image">
                        <img src="${pageContext.request.contextPath}/images/reviewers/reviewer2.jpg" alt="Reviewer">
                    </div>
                    <div class="reviewer-info">
                        <h4>Anita Gurung</h4>
                        <p>University Student</p>
                    </div>
                </div>
            </div>
            
            <div class="review-card">
                <div class="review-rating">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                </div>
                <div class="review-text">
                    <i class="fas fa-quote-left"></i>
                    <p>"The Harry Potter series never gets old. I've read the first book multiple times and it's still as magical as the first time. J.K. Rowling's world-building is unmatched."</p>
                </div>
                <div class="reviewer">
                    <div class="reviewer-image">
                        <img src="${pageContext.request.contextPath}/images/reviewers/reviewer3.jpg" alt="Reviewer">
                    </div>
                    <div class="reviewer-info">
                        <h4>Rajan Shrestha</h4>
                        <p>Teacher</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="section-controls">
            <button class="slider-btn reviews-prev-btn"><i class="fas fa-chevron-left"></i></button>
            <button class="slider-btn reviews-next-btn"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>
</section>

<style>
    .page-banner {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        color: var(--white);
        padding: 60px 0;
        text-align: center;
    }
    
    .page-banner h1 {
        font-size: 36px;
        margin-bottom: 15px;
    }
    
    .page-banner p {
        max-width: 700px;
        margin: 0 auto;
        opacity: 0.9;
    }
    
    .books-section {
        padding: 60px 0;
        background-color: var(--light-bg);
    }
    
    .books-filter {
        display: flex;
        justify-content: flex-end;
        gap: 20px;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }
    
    .filter-item {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .filter-select {
        padding: 8px 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background-color: var(--white);
        font-family: 'Poppins', sans-serif;
    }
    
    .books-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 30px;
        margin-bottom: 40px;
    }
    
    .pagination {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 40px;
    }
    
    .page-link {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: var(--white);
        color: var(--text-color);
        text-decoration: none;
        transition: var(--transition);
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    
    .page-link:hover {
        background-color: var(--primary-color);
        color: var(--white);
    }
    
    .page-link.active {
        background-color: var(--accent-color);
        color: var(--white);
    }
    
    .no-books-message {
        grid-column: 1 / -1;
        text-align: center;
        padding: 40px;
        background-color: var(--white);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
    }
    
    .reviews-section {
        padding: 80px 0;
        background: var(--white);
    }
    
    .reviews-slider {
        display: flex;
        overflow-x: auto;
        gap: 30px;
        margin-top: 40px;
        padding: 20px 0;
        scroll-behavior: smooth;
        scrollbar-width: none;
    }
    
    .reviews-slider::-webkit-scrollbar {
        display: none;
    }
    
    .review-card {
        flex: 0 0 350px;
        background-color: var(--light-bg);
        border-radius: 10px;
        padding: 30px;
        box-shadow: var(--shadow);
    }
    
    .review-rating {
        margin-bottom: 15px;
        color: #FFC107;
    }
    
    .review-text {
        margin-bottom: 20px;
    }
    
    .review-text i {
        font-size: 24px;
        color: var(--accent-color);
        margin-right: 10px;
    }
    
    .reviewer {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .reviewer-image {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        overflow: hidden;
    }
    
    .reviewer-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .reviewer-info h4 {
        margin-bottom: 5px;
        color: var(--primary-dark);
    }
    
    .reviewer-info p {
        font-size: 12px;
        color: var(--light-text);
        margin: 0;
    }
    
    .section-controls {
        text-align: center;
        margin-top: 30px;
    }
    
    @media (max-width: 768px) {
        .books-filter {
            justify-content: center;
        }
        
        .books-grid {
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 15px;
        }
        
        .page-banner h1 {
            font-size: 28px;
        }
        
        .review-card {
            flex: 0 0 280px;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Filters functionality
        const sortBySelect = document.getElementById('sort-by');
        const categorySelect = document.getElementById('category-filter');
        
        if (sortBySelect && categorySelect) {
            sortBySelect.addEventListener('change', function() {
                applyFilters();
            });
            
            categorySelect.addEventListener('change', function() {
                applyFilters();
            });
        }
        
        function applyFilters() {
            const sortBy = sortBySelect.value;
            const category = categorySelect.value;
            
            // Construct URL with filter parameters
            let url = window.location.pathname + '?';
            if (sortBy) {
                url += 'sort=' + sortBy + '&';
            }
            if (category && category !== 'all') {
                url += 'category=' + category + '&';
            }
            
            // Get current page parameter if exists
            const urlParams = new URLSearchParams(window.location.search);
            const page = urlParams.get('page');
            if (page) {
                url += 'page=' + page;
            }
            
            // Remove trailing & or ?
            url = url.replace(/[&?]$/, '');
            
            // Navigate to filtered URL
            window.location.href = url;
        }
        
        // Reviews Slider
        const reviewsSlider = document.querySelector('.reviews-slider');
        const reviewsPrevBtn = document.querySelector('.reviews-prev-btn');
        const reviewsNextBtn = document.querySelector('.reviews-next-btn');
        
        if (reviewsSlider && reviewsPrevBtn && reviewsNextBtn) {
            const cardWidth = 380; // Review card width + gap
            
            reviewsPrevBtn.addEventListener('click', function() {
                reviewsSlider.scrollBy({
                    left: -cardWidth,
                    behavior: 'smooth'
                });
            });
            
            reviewsNextBtn.addEventListener('click', function() {
                reviewsSlider.scrollBy({
                    left: cardWidth,
                    behavior: 'smooth'
                });
            });
        }
        
        // Book actions
        const quickViewBtns = document.querySelectorAll('.quick-view');
        const addToWishlistBtns = document.querySelectorAll('.add-to-wishlist');
        const addToCartBtns = document.querySelectorAll('.add-to-cart');
        
        quickViewBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                const bookId = this.getAttribute('data-book-id');
                // Implement quick view functionality
                alert('Quick view for book ID: ' + (bookId || 'sample book'));
            });
        });
        
        addToWishlistBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                const bookId = this.getAttribute('data-book-id');
                this.innerHTML = '<i class="fas fa-heart"></i>';
                this.style.color = '#FF5722';
                // Implement add to wishlist functionality
                alert('Added to wishlist: ' + (bookId || 'sample book'));
            });
        });
        
        addToCartBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                const bookId = this.getAttribute('data-book-id');
                // Implement add to cart functionality
                
                // Update cart count
                const cartCount = document.querySelector('.cart-count');
                if (cartCount) {
                    cartCount.textContent = parseInt(cartCount.textContent) + 1;
                    cartCount.style.transform = 'scale(1.2)';
                    setTimeout(() => {
                        cartCount.style.transform = 'scale(1)';
                    }, 300);
                }
                
                alert('Added to cart: ' + (bookId || 'sample book'));
            });
        });
    });
</script> 