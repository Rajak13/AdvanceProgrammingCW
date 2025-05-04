<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panna BookStore - Your Premier Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- Header -->
    <header class="site-header">
        <div class="header-top">
            <div class="container">
                <div class="top-info">
                    <span><i class="fas fa-phone"></i> +977 987-654-3210</span>
                    <span><i class="fas fa-envelope"></i> info@pannabookstore.com</span>
                </div>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                </div>
            </div>
        </div>
        <div class="header-main">
            <div class="container">
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/">
                        <h1>Panna<span>BookStore</span></h1>
                    </a>
                </div>
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/search" method="get">
                        <input type="text" name="query" placeholder="Search for books, authors...">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>
                <div class="header-right">
                    <div class="cart-icon">
                        <a href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="cart-count">0</span>
                        </a>
                    </div>
                    <div class="user-account">
                        <div class="account-trigger">
                            <% if (session != null && session.getAttribute("user") != null) { 
                                model.User user = (model.User) session.getAttribute("user");
                                String name = user.getName();
                                String firstLetter = name.substring(0, 1).toUpperCase();
                            %>
                            <div class="user-avatar"><%= firstLetter %></div>
                            <span class="username"><%= name %></span>
                            <% } else { %>
                            <i class="fas fa-user-circle"></i>
                            <span>Account</span>
                            <% } %>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="account-dropdown">
                            <% if (session != null && session.getAttribute("user") != null) { 
                                model.User user = (model.User) session.getAttribute("user");
                                String email = user.getEmail() != null ? user.getEmail() : "No email provided";
                            %>
                            <div class="user-info">
                                <div class="user-avatar large"><%= user.getName().substring(0, 1).toUpperCase() %></div>
                                <div class="user-details">
                                    <h4><%= user.getName() %></h4>
                                    <p><%= email %></p>
                                </div>
                            </div>
                            <% } %>
                            <ul>
                                <% if (session != null && session.getAttribute("user") != null) { %>
                                    <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a></li>
                                    <li><a href="${pageContext.request.contextPath}/orders"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                                    <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fas fa-heart"></i> Wishlist</a></li>
                                    <li><a href="${pageContext.request.contextPath}/settings"><i class="fas fa-cog"></i> Settings</a></li>
                                    <li class="divider"></li>
                                    <li><a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                                <% } else { %>
                                    <li><a href="${pageContext.request.contextPath}/auth/login"><i class="fas fa-sign-in-alt"></i> Login</a></li>
                                    <li><a href="${pageContext.request.contextPath}/auth/register"><i class="fas fa-user-plus"></i> Register</a></li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                    <div class="mobile-menu-toggle">
                        <i class="fas fa-bars"></i>
                    </div>
                </div>
            </div>
        </div>
        <nav class="site-nav">
            <div class="container">
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/" class="active">Home</a></li>
                    <li class="has-dropdown">
                        <a href="#">Categories <i class="fas fa-chevron-down"></i></a>
                        <ul class="dropdown">
                            <li><a href="${pageContext.request.contextPath}/category/fiction">Fiction</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/non-fiction">Non-Fiction</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/children">Children's Books</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/textbooks">Textbooks</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/nepali">Nepali Literature</a></li>
                        </ul>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/new-releases">New Releases</a></li>
                    <li><a href="${pageContext.request.contextPath}/bestsellers">Bestsellers</a></li>
                    <li><a href="${pageContext.request.contextPath}/deals">Deals & Offers</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </div>
        </nav>
    </header>
    
    <!-- Mobile Navigation -->
    <div class="mobile-nav">
        <div class="mobile-nav-header">
            <div class="logo">
                <h1>Panna<span>BookStore</span></h1>
            </div>
            <div class="close-mobile-nav">
                <i class="fas fa-times"></i>
            </div>
        </div>
        <div class="mobile-search">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" name="query" placeholder="Search for books, authors...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        <ul class="mobile-nav-menu">
            <% if (session != null && session.getAttribute("user") != null) { 
                model.User user = (model.User) session.getAttribute("user");
            %>
            <li class="mobile-user-info">
                <div class="user-avatar"><%= user.getName().substring(0, 1).toUpperCase() %></div>
                <div class="user-details">
                    <h4><%= user.getName() %></h4>
                    <p><%= user.getEmail() %></p>
                </div>
            </li>
            <% } %>
            <li><a href="${pageContext.request.contextPath}/" class="active">Home</a></li>
            <li class="has-dropdown">
                <a href="#">Categories <i class="fas fa-chevron-down"></i></a>
                <ul class="dropdown">
                    <li><a href="${pageContext.request.contextPath}/category/fiction">Fiction</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/non-fiction">Non-Fiction</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/children">Children's Books</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/textbooks">Textbooks</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/nepali">Nepali Literature</a></li>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/new-releases">New Releases</a></li>
            <li><a href="${pageContext.request.contextPath}/bestsellers">Bestsellers</a></li>
            <li><a href="${pageContext.request.contextPath}/deals">Deals & Offers</a></li>
            <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
            <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
            <% if (session != null && session.getAttribute("user") != null) { %>
                <li class="divider"></li>
                <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/orders"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fas fa-heart"></i> Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/settings"><i class="fas fa-cog"></i> Settings</a></li>
                <li><a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            <% } else { %>
                <li class="divider"></li>
                <li><a href="${pageContext.request.contextPath}/auth/login"><i class="fas fa-sign-in-alt"></i> Login</a></li>
                <li><a href="${pageContext.request.contextPath}/auth/register"><i class="fas fa-user-plus"></i> Register</a></li>
            <% } %>
        </ul>
    </div>
    
    <main>
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
    </main>

    <!-- Footer -->
    <footer class="site-footer">
        <div class="footer-top">
            <div class="container">
                <div class="footer-widgets">
                    <div class="footer-widget">
                        <h3>About Panna BookStore</h3>
                        <p>Nepal's leading bookstore offering a wide selection of books across genres. We're dedicated to promoting literacy and a love for reading in our community.</p>
                        <div class="footer-social">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-pinterest"></i></a>
                        </div>
                    </div>
                    <div class="footer-widget">
                        <h3>Quick Links</h3>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                            <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                            <li><a href="${pageContext.request.contextPath}/terms">Terms & Conditions</a></li>
                            <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                            <li><a href="${pageContext.request.contextPath}/shipping">Shipping & Returns</a></li>
                            <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
                        </ul>
                    </div>
                    <div class="footer-widget">
                        <h3>Categories</h3>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/category/fiction">Fiction</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/non-fiction">Non-Fiction</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/children">Children's Books</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/textbooks">Textbooks</a></li>
                            <li><a href="${pageContext.request.contextPath}/category/nepali">Nepali Literature</a></li>
                        </ul>
                    </div>
                    <div class="footer-widget">
                        <h3>Contact Us</h3>
                        <ul class="contact-info">
                            <li><i class="fas fa-map-marker-alt"></i> 123 Putali Sadak, Kathmandu, Nepal</li>
                            <li><i class="fas fa-phone"></i> +977 987-654-3210</li>
                            <li><i class="fas fa-envelope"></i> info@pannabookstore.com</li>
                            <li><i class="fas fa-clock"></i> Mon-Sat: 9:00 AM - 8:00 PM</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="container">
                <div class="copyright">
                    <p>&copy; 2023 Panna BookStore. All Rights Reserved.</p>
                </div>
                <div class="payment-methods">
                    <span>Accepted Payment Methods:</span>
                    <img src="${pageContext.request.contextPath}/images/payment-methods.png" alt="Payment Methods">
                </div>
            </div>
        </div>
        <div id="back-to-top">
            <i class="fas fa-chevron-up"></i>
        </div>
    </footer>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/js/home.js"></script>
</body>
</html>