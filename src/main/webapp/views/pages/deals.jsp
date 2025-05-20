<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deals & Offers - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/views/common/header.jsp" />

    <main>
<!-- Deals Banner -->
        <section class="hero-section">
    <div class="container">
                <div class="hero-content">
            <h1>Deals & Offers</h1>
            <p>Special discounts and promotions on selected books</p>
        </div>
    </div>
</section>

<!-- Books Grid -->
        <section class="featured-books">
    <div class="container">
                <div class="section-header">
                    <h2>Special Offers</h2>
                    <p>Grab these amazing deals before they're gone</p>
                    <div class="section-controls">
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
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}">${category.name}</option>
                                </c:forEach>
                </select>
                        </div>
            </div>
        </div>
        
                <div class="books-slider">
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
                        <c:if test="${page > 1}">
                            <a href="?page=${page - 1}&sort=${sortBy}&category=${categoryFilter}" class="page-link"><i class="fas fa-chevron-left"></i></a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                                <c:when test="${page eq i}">
                            <span class="page-link active">${i}</span>
                        </c:when>
                        <c:otherwise>
                                    <a href="?page=${i}&sort=${sortBy}&category=${categoryFilter}" class="page-link">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                        <c:if test="${page < totalPages}">
                            <a href="?page=${page + 1}&sort=${sortBy}&category=${categoryFilter}" class="page-link"><i class="fas fa-chevron-right"></i></a>
                </c:if>
            </div>
        </c:if>
    </div>
</section>
    </main>

    <jsp:include page="/views/common/footer.jsp" />

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
                if (!bookId) return;

                    fetch('/BookStore/cart/add', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'bookId=' + encodeURIComponent(bookId) + '&quantity=1'
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Added to cart');
                        }
                        return response.json();
                    })
                .then(data => {
                        if (data.success) {
                    updateCartCount();
                    alert(data.message || 'Added to cart!');
                        } else {
                            alert(data.message || 'Added to cart.');
                        }
                })
                .catch(() => {
                    alert('Added to cart.');
                });
            });
        });
    });
</script> 
</body>
</html> 