<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="hero-content">
            <h1>Discover Your Next Favorite Book</h1>
            <p>Explore our vast collection of books from bestselling authors and discover stories that will captivate your imagination.</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary">Shop Now</a>
                <a href="${pageContext.request.contextPath}/recommendations" class="btn btn-outline">Get Recommendations</a>
            </div>
        </div>
        <div class="hero-image">
            <img src="${pageContext.request.contextPath}/images/hero-books.png" alt="Book collection">
        </div>
    </div>
</section>

<!-- Categories Section -->
<section class="categories-section">
    <div class="container">
        <div class="section-header">
            <h2>Browse by Category</h2>
            <p>Find your next great read in our curated collections</p>
        </div>
        <div class="category-grid">
            <a href="${pageContext.request.contextPath}/category/fiction" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-book"></i>
                </div>
                <h3>Fiction</h3>
                <p>Novels, Short Stories, Fantasy</p>
            </a>
            <a href="${pageContext.request.contextPath}/category/non-fiction" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-landmark"></i>
                </div>
                <h3>Non-Fiction</h3>
                <p>Biography, History, Science</p>
            </a>
            <a href="${pageContext.request.contextPath}/category/children" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-child"></i>
                </div>
                <h3>Children's</h3>
                <p>Picture Books, Young Readers</p>
            </a>
            <a href="${pageContext.request.contextPath}/category/textbooks" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h3>Textbooks</h3>
                <p>School, College, Reference</p>
            </a>
        </div>
    </div>
</section>

<!-- Featured Books Section -->
<section class="featured-books">
    <div class="container">
        <div class="section-header">
            <h2>Featured Books</h2>
            <p>Our handpicked selection of must-read titles</p>
            <div class="section-controls">
                <button class="slider-btn prev-btn"><i class="fas fa-chevron-left"></i></button>
                <button class="slider-btn next-btn"><i class="fas fa-chevron-right"></i></button>
            </div>
        </div>
        <div class="books-slider">
            <div class="book-card">
                <div class="book-image">
                    <img src="https://images-na.ssl-images-amazon.com/images/I/91vwHMt+x7L.jpg" alt="Book Cover">
                    <div class="book-actions">
                        <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                        <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                        <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                    </div>
                    <div class="book-badge">New</div>
                </div>
                <div class="book-info">
                    <h3>The Alchemist</h3>
                    <p class="book-author">Paulo Coelho</p>
                    <div class="book-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span>(4.5)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">NPR 850</span>
                        <span class="original-price">NPR 1000</span>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-image">
                    <img src="https://m.media-amazon.com/images/I/71kxa1-0mfL.jpg" alt="Book Cover">
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
                    <div class="book-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <span>(5.0)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">NPR 750</span>
                        <span class="original-price">NPR 900</span>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-image">
                    <img src="https://m.media-amazon.com/images/I/81fXBeYYxpL.jpg" alt="Book Cover">
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
                    <div class="book-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="far fa-star"></i>
                        <span>(4.0)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">NPR 680</span>
                        <span class="original-price">NPR 800</span>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-image">
                    <img src="https://m.media-amazon.com/images/I/71aFt4+OTOL.jpg" alt="Book Cover">
                    <div class="book-actions">
                        <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                        <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                        <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                    </div>
                    <div class="book-badge">Popular</div>
                </div>
                <div class="book-info">
                    <h3>The Hobbit</h3>
                    <p class="book-author">J.R.R. Tolkien</p>
                    <div class="book-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span>(4.7)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">NPR 920</span>
                        <span class="original-price">NPR 1100</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="view-all-container">
            <a href="${pageContext.request.contextPath}/featured-books" class="btn-view-all">View All Featured Books <i class="fas fa-arrow-right"></i></a>
        </div>
    </div>
</section>

<!-- Benefits Section -->
<section class="benefits-section">
    <div class="container">
        <div class="benefits-grid">
            <div class="benefit-card">
                <div class="benefit-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <div class="benefit-content">
                    <h3>Free Shipping</h3>
                    <p>On orders over NPR 1000</p>
                </div>
            </div>
            <div class="benefit-card">
                <div class="benefit-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div class="benefit-content">
                    <h3>Secure Payment</h3>
                    <p>100% secure transactions</p>
                </div>
            </div>
            <div class="benefit-card">
                <div class="benefit-icon">
                    <i class="fas fa-exchange-alt"></i>
                </div>
                <div class="benefit-content">
                    <h3>Easy Returns</h3>
                    <p>10-day return policy</p>
                </div>
            </div>
            <div class="benefit-card">
                <div class="benefit-icon">
                    <i class="fas fa-headset"></i>
                </div>
                <div class="benefit-content">
                    <h3>24/7 Support</h3>
                    <p>Dedicated customer service</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- New Arrivals Section -->
<section class="new-arrivals">
    <div class="container">
        <div class="section-header">
            <h2>New Arrivals</h2>
            <p>The latest additions to our bookstore</p>
            <div class="section-controls">
                <button class="slider-btn arrivals-prev-btn"><i class="fas fa-chevron-left"></i></button>
                <button class="slider-btn arrivals-next-btn"><i class="fas fa-chevron-right"></i></button>
            </div>
        </div>
        <div class="books-slider arrivals-slider">
            <!-- This will be populated by JavaScript or with actual data -->
            <div class="book-card">
                <div class="book-image">
                    <img src="https://m.media-amazon.com/images/I/91bYsX41DVL.jpg" alt="Book Cover">
                    <div class="book-actions">
                        <button class="quick-view" title="Quick View"><i class="fas fa-eye"></i></button>
                        <button class="add-to-wishlist" title="Add to Wishlist"><i class="far fa-heart"></i></button>
                        <button class="add-to-cart" title="Add to Cart"><i class="fas fa-shopping-cart"></i></button>
                    </div>
                    <div class="book-badge">New</div>
                </div>
                <div class="book-info">
                    <h3>Atomic Habits</h3>
                    <p class="book-author">James Clear</p>
                    <div class="book-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <span>(5.0)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">NPR 950</span>
                    </div>
                </div>
            </div>
            <!-- More book cards would go here -->
        </div>
        <div class="view-all-container">
            <a href="${pageContext.request.contextPath}/new-arrivals" class="btn-view-all">View All New Arrivals <i class="fas fa-arrow-right"></i></a>
        </div>
    </div>
</section>

<!-- Newsletter Section -->
<section class="newsletter-section">
    <div class="container">
        <div class="newsletter-content">
            <h2>Subscribe to Our Newsletter</h2>
            <p>Get updates on new releases, exclusive offers, and personalized recommendations</p>
            <form class="newsletter-form" action="${pageContext.request.contextPath}/subscribe" method="post">
                <input type="email" name="email" placeholder="Enter your email address" required>
                <button type="submit" class="btn btn-primary">Subscribe</button>
            </form>
        </div>
    </div>
</section> 