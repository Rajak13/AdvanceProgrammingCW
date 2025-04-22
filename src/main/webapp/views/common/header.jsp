<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
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
                            String username = user.getUsername();
                            String firstLetter = username.substring(0, 1).toUpperCase();
                        %>
                        <div class="user-avatar"><%= firstLetter %></div>
                        <span class="username"><%= username %></span>
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
                            <div class="user-avatar large"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
                            <div class="user-details">
                                <h4><%= user.getUsername() %></h4>
                                <p><%= email %></p>
                            </div>
                        </div>
                        <% } %>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/orders"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                            <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fas fa-heart"></i> Wishlist</a></li>
                            <li><a href="${pageContext.request.contextPath}/settings"><i class="fas fa-cog"></i> Settings</a></li>
                            <li class="divider"></li>
                            <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
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
                <li><a href="${pageContext.request.contextPath}/" ${currentPage eq 'home' ? 'class="active"' : ''}>Home</a></li>
                <li class="has-dropdown">
                    <a href="#" ${currentPage eq 'category' ? 'class="active"' : ''}>Categories <i class="fas fa-chevron-down"></i></a>
                    <ul class="dropdown">
                        <li><a href="${pageContext.request.contextPath}/category/fiction">Fiction</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/non-fiction">Non-Fiction</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/children">Children's Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/textbooks">Textbooks</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/nepali">Nepali Literature</a></li>
                    </ul>
                </li>
                <li><a href="${pageContext.request.contextPath}/new-releases" ${currentPage eq 'new-releases' ? 'class="active"' : ''}>New Releases</a></li>
                <li><a href="${pageContext.request.contextPath}/bestsellers" ${currentPage eq 'bestsellers' ? 'class="active"' : ''}>Bestsellers</a></li>
                <li><a href="${pageContext.request.contextPath}/deals" ${currentPage eq 'deals' ? 'class="active"' : ''}>Deals & Offers</a></li>
                <li><a href="${pageContext.request.contextPath}/about" ${currentPage eq 'about' ? 'class="active"' : ''}>About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contact" ${currentPage eq 'contact' ? 'class="active"' : ''}>Contact</a></li>
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
            <div class="user-avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
            <div class="user-details">
                <h4><%= user.getUsername() %></h4>
                <p><%= user.getEmail() %></p>
            </div>
        </li>
        <% } %>
        <li><a href="${pageContext.request.contextPath}/" ${currentPage eq 'home' ? 'class="active"' : ''}>Home</a></li>
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
        <li><a href="${pageContext.request.contextPath}/new-releases" ${currentPage eq 'new-releases' ? 'class="active"' : ''}>New Releases</a></li>
        <li><a href="${pageContext.request.contextPath}/bestsellers" ${currentPage eq 'bestsellers' ? 'class="active"' : ''}>Bestsellers</a></li>
        <li><a href="${pageContext.request.contextPath}/deals" ${currentPage eq 'deals' ? 'class="active"' : ''}>Deals & Offers</a></li>
        <li><a href="${pageContext.request.contextPath}/about" ${currentPage eq 'about' ? 'class="active"' : ''}>About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/contact" ${currentPage eq 'contact' ? 'class="active"' : ''}>Contact</a></li>
        <li class="divider"></li>
        <% if (session != null && session.getAttribute("user") != null) { %>
        <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/orders"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fas fa-heart"></i> Wishlist</a></li>
        <li><a href="${pageContext.request.contextPath}/settings"><i class="fas fa-cog"></i> Settings</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        <% } else { %>
        <li><a href="${pageContext.request.contextPath}/auth"><i class="fas fa-sign-in-alt"></i> Login</a></li>
        <% } %>
    </ul>
</div>