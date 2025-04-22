<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Deals Banner -->
<section class="page-banner deals-banner">
    <div class="container">
        <div class="page-banner-content">
            <h1>Deals & Offers</h1>
            <p>Special discounts and promotions on selected books</p>
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
                    <option value="discount">Highest Discount</option>
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
                    <p>No deals available at the moment. Check back soon for updates!</p>
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
                        <div class="book-badge">20% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>${book.bookName}</h3>
                        <p class="book-author">${book.writerName}</p>
                        <div class="book-price">
                            <span class="current-price">NPR ${book.price}</span>
                            <span class="original-price">NPR ${book.price * 1.25}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <!-- Sample books for when the database is empty -->
            <c:if test="${empty books}">
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81fXBeYYxpL.jpg" alt="The Psychology of Money">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">15% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>The Psychology of Money</h3>
                        <p class="book-author">Morgan Housel</p>
                        <div class="book-price">
                            <span class="current-price">NPR 680</span>
                            <span class="original-price">NPR 800</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/91E2Mpqy5KL.jpg" alt="The Da Vinci Code">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">25% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>The Da Vinci Code</h3>
                        <p class="book-author">Dan Brown</p>
                        <div class="book-price">
                            <span class="current-price">NPR 675</span>
                            <span class="original-price">NPR 900</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81VStYnDGrL.jpg" alt="To Kill a Mockingbird">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">20% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>To Kill a Mockingbird</h3>
                        <p class="book-author">Harper Lee</p>
                        <div class="book-price">
                            <span class="current-price">NPR 720</span>
                            <span class="original-price">NPR 900</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/71D68+rJJxL.jpg" alt="The 5 AM Club">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">30% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>The 5 AM Club</h3>
                        <p class="book-author">Robin Sharma</p>
                        <div class="book-price">
                            <span class="current-price">NPR 630</span>
                            <span class="original-price">NPR 900</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/815h5-ixCQL.jpg" alt="The 7 Habits of Highly Effective People">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">15% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>The 7 Habits of Highly Effective People</h3>
                        <p class="book-author">Stephen R. Covey</p>
                        <div class="book-price">
                            <span class="current-price">NPR 765</span>
                            <span class="original-price">NPR 900</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81qRk4o4BnL.jpg" alt="The Immortals of Meluha">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">25% Off</div>
                    </div>
                    <div class="book-info">
                        <h3>The Immortals of Meluha</h3>
                        <p class="book-author">Amish Tripathi</p>
                        <div class="book-price">
                            <span class="current-price">NPR 675</span>
                            <span class="original-price">NPR 900</span>
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

<style>
    .deals-banner {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        color: var(--white);
        padding: 60px 0;
        text-align: center;
    }
    
    .page-banner {
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
    
    .book-badge {
        position: absolute;
        top: 10px;
        left: 10px;
        background-color: #ff5722;
        color: white;
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
    }
    
    .original-price {
        text-decoration: line-through;
        color: #999;
        font-size: 14px;
        margin-left: 8px;
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
    
    @media (max-width: 768px) {
        .page-banner h1 {
            font-size: 28px;
        }
        
        .books-filter {
            justify-content: center;
        }
        
        .books-grid {
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 15px;
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