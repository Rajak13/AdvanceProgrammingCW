<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Category Banner -->
<section class="category-banner">
    <div class="container">
        <div class="category-banner-content">
            <h1>${category.categoryName}</h1>
            <p>${category.description}</p>
        </div>
    </div>
</section>

<!-- Books Grid -->
<section class="category-books">
    <div class="container">
        <div class="category-filter">
            <div class="filter-item">
                <label for="sort-by">Sort By:</label>
                <select id="sort-by" class="filter-select">
                    <option value="popularity">Popularity</option>
                    <option value="price-low">Price: Low to High</option>
                    <option value="price-high">Price: High to Low</option>
                    <option value="newest">Newest First</option>
                </select>
            </div>
            <div class="filter-item">
                <label for="price-range">Price Range:</label>
                <select id="price-range" class="filter-select">
                    <option value="all">All Prices</option>
                    <option value="0-500">Under NPR 500</option>
                    <option value="500-1000">NPR 500 - 1000</option>
                    <option value="1000-2000">NPR 1000 - 2000</option>
                    <option value="2000+">NPR 2000+</option>
                </select>
            </div>
        </div>
        
        <div class="books-grid">
            <c:if test="${empty books}">
                <div class="no-books-message">
                    <p>No books found in this category. Check back soon for updates!</p>
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

<!-- Book Recommendation -->
<section class="book-recommendation">
    <div class="container">
        <div class="section-header">
            <h2>Recommended For You</h2>
            <p>Based on your browsing history</p>
        </div>
        <div class="books-slider recommendation-slider">
            <c:forEach var="recommendedBook" items="${recommendedBooks}" varStatus="status">
                <div class="book-card">
                    <div class="book-image">
                        <img src="${recommendedBook.picture != null ? recommendedBook.picture : pageContext.request.contextPath.concat('/images/book-placeholder.jpg')}" alt="${recommendedBook.bookName}">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View" data-book-id="${recommendedBook.bookId}"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist" data-book-id="${recommendedBook.bookId}"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart" data-book-id="${recommendedBook.bookId}"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                    </div>
                    <div class="book-info">
                        <h3>${recommendedBook.bookName}</h3>
                        <p class="book-author">${recommendedBook.writerName}</p>
                        <div class="book-price">
                            <span class="current-price">NPR ${recommendedBook.price}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="section-controls">
            <button class="slider-btn recommendation-prev-btn"><i class="fas fa-chevron-left"></i></button>
            <button class="slider-btn recommendation-next-btn"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>
</section>

<style>
    .category-banner {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        color: var(--white);
        padding: 60px 0;
        text-align: center;
    }
    
    .category-banner h1 {
        font-size: 36px;
        margin-bottom: 15px;
    }
    
    .category-banner p {
        max-width: 700px;
        margin: 0 auto;
        opacity: 0.9;
    }
    
    .category-filter {
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
    
    .book-recommendation {
        padding: 60px 0;
        background-color: var(--white);
    }
    
    .recommendation-slider {
        margin-bottom: 20px;
    }
    
    @media (max-width: 768px) {
        .category-filter {
            justify-content: center;
        }
        
        .books-grid {
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 15px;
        }
        
        .category-banner h1 {
            font-size: 28px;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Recommendation Slider
        const recSlider = document.querySelector('.recommendation-slider');
        const recPrevBtn = document.querySelector('.recommendation-prev-btn');
        const recNextBtn = document.querySelector('.recommendation-next-btn');
        
        if (recSlider && recPrevBtn && recNextBtn) {
            const cardWidth = 240; // Card width + gap
            
            recPrevBtn.addEventListener('click', function() {
                recSlider.scrollBy({
                    left: -cardWidth,
                    behavior: 'smooth'
                });
            });
            
            recNextBtn.addEventListener('click', function() {
                recSlider.scrollBy({
                    left: cardWidth,
                    behavior: 'smooth'
                });
            });
        }
        
        // Filters functionality
        const sortBySelect = document.getElementById('sort-by');
        const priceRangeSelect = document.getElementById('price-range');
        
        if (sortBySelect && priceRangeSelect) {
            sortBySelect.addEventListener('change', function() {
                applyFilters();
            });
            
            priceRangeSelect.addEventListener('change', function() {
                applyFilters();
            });
        }
        
        function applyFilters() {
            const sortBy = sortBySelect.value;
            const priceRange = priceRangeSelect.value;
            
            // Construct URL with filter parameters
            let url = window.location.pathname + '?';
            if (sortBy) {
                url += 'sort=' + sortBy + '&';
            }
            if (priceRange) {
                url += 'price=' + priceRange + '&';
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
        
        // Book actions
        const quickViewBtns = document.querySelectorAll('.quick-view');
        const addToWishlistBtns = document.querySelectorAll('.add-to-wishlist');
        const addToCartBtns = document.querySelectorAll('.add-to-cart');
        
        quickViewBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                const bookId = this.getAttribute('data-book-id');
                // Implement quick view functionality
                alert('Quick view for book ID: ' + bookId);
            });
        });
        
        addToWishlistBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                const bookId = this.getAttribute('data-book-id');
                this.innerHTML = '<i class="fas fa-heart"></i>';
                this.style.color = '#FF5722';
                // Implement add to wishlist functionality
                alert('Added to wishlist: ' + bookId);
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
                
                alert('Added to cart: ' + bookId);
            });
        });
    });
</script> 