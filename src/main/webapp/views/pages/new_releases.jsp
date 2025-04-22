<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- New Releases Banner -->
<section class="page-banner new-releases-banner">
    <div class="container">
        <div class="page-banner-content">
            <h1>New Releases</h1>
            <p>Discover the latest additions to our bookstore</p>
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
                    <option value="date-desc">Newest First</option>
                    <option value="date-asc">Oldest First</option>
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
                    <p>No new releases available at the moment. Check back soon for updates!</p>
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
                        <div class="book-badge">New</div>
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
                        <img src="https://m.media-amazon.com/images/I/71PNGYHykrL.jpg" alt="It Starts with Us">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">New</div>
                    </div>
                    <div class="book-info">
                        <h3>It Starts with Us</h3>
                        <p class="book-author">Colleen Hoover</p>
                        <div class="book-price">
                            <span class="current-price">NPR 950</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/91HHxxtA1wL.jpg" alt="The Silent Patient">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">New</div>
                    </div>
                    <div class="book-info">
                        <h3>The Silent Patient</h3>
                        <p class="book-author">Alex Michaelides</p>
                        <div class="book-price">
                            <span class="current-price">NPR 880</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81hGBkJRlsL.jpg" alt="Where the Crawdads Sing">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">New</div>
                    </div>
                    <div class="book-info">
                        <h3>Where the Crawdads Sing</h3>
                        <p class="book-author">Delia Owens</p>
                        <div class="book-price">
                            <span class="current-price">NPR 920</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81EVdWdmOKL.jpg" alt="The Philosophy of Modern Song">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">New</div>
                    </div>
                    <div class="book-info">
                        <h3>The Philosophy of Modern Song</h3>
                        <p class="book-author">Bob Dylan</p>
                        <div class="book-price">
                            <span class="current-price">NPR 1200</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/91nTClkODkL.jpg" alt="Spare">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">New</div>
                    </div>
                    <div class="book-info">
                        <h3>Spare</h3>
                        <p class="book-author">Prince Harry</p>
                        <div class="book-price">
                            <span class="current-price">NPR 1150</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-card">
                    <div class="book-image">
                        <img src="https://m.media-amazon.com/images/I/81yfsIOijJL.jpg" alt="The Light We Carry">
                        <div class="book-actions">
                            <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                            <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                            <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                        </div>
                        <div class="book-badge">New</div>
                    </div>
                    <div class="book-info">
                        <h3>The Light We Carry</h3>
                        <p class="book-author">Michelle Obama</p>
                        <div class="book-price">
                            <span class="current-price">NPR 1050</span>
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