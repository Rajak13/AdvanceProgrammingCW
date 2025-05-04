<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:set var="user" value="${sessionScope.user}" />
                            <c:set var="username" value="${user.name}" />
                            <c:set var="firstLetter" value="${fn:substring(username, 0, 1)}" />
                            <div class="account-trigger">
                                <div class="user-avatar">
                                    <c:choose>
                                        <c:when test="${not empty user.picture}">
                                            <img src="${pageContext.request.contextPath}/${user.picture}" alt="Profile Picture">
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:toUpperCase(firstLetter)}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="username">${username}</span>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="account-dropdown">
                                <div class="user-info">
                                    <div class="user-avatar large">
                                        <c:choose>
                                            <c:when test="${not empty user.picture}">
                                                <img src="${pageContext.request.contextPath}/${user.picture}" alt="Profile Picture">
                                            </c:when>
                                            <c:otherwise>
                                                ${fn:toUpperCase(firstLetter)}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="user-details">
                                        <h4>${user.name}</h4>
                                        <p>${user.email}</p>
                                    </div>
                                </div>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a></li>
                                    <li><a href="${pageContext.request.contextPath}/orders"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                                    <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fas fa-heart"></i> Wishlist</a></li>
                                    <li><a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="auth-buttons">
                                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-login">Login</a>
                                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-register">Register</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
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
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <c:set var="user" value="${sessionScope.user}" />
                <li class="mobile-user-info">
                    <div class="user-avatar">
                        <c:choose>
                            <c:when test="${not empty user.picture}">
                                <img src="${pageContext.request.contextPath}/${user.picture}" alt="Profile Picture">
                            </c:when>
                            <c:otherwise>
                                ${fn:toUpperCase(fn:substring(user.name, 0, 1))}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="user-details">
                        <h4>${user.name}</h4>
                        <p>${user.email}</p>
                    </div>
                </li>
            </c:when>
        </c:choose>
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
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/orders"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/wishlist"><i class="fas fa-heart"></i> Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/auth/login"><i class="fas fa-sign-in-alt"></i> Login</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</div>