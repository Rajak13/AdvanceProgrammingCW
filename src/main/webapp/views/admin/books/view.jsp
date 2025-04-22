<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Book - Panna BookStore Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- Include sidebar -->
        <jsp:include page="../common/sidebar.jsp">
            <jsp:param name="active" value="books" />
        </jsp:include>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <div class="header-title">
                    <h1>Book Details</h1>
                </div>
                <div class="user-info">
                    <span>${sessionScope.user.name}</span>
                    <img src="${pageContext.request.contextPath}/images/avatar.png" alt="User Avatar">
                </div>
            </div>
            
            <div class="content">
                <div class="content-header">
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Books
                    </a>
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/admin/books/edit?id=${book.bookId}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <button class="btn btn-danger" onclick="confirmDelete(${book.bookId})">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </div>
                
                <div class="content-card book-details">
                    <div class="book-image">
                        <img src="${pageContext.request.contextPath}${book.picture}" alt="${book.bookName}">
                        <div class="book-badges">
                            <c:if test="${book.bestseller}">
                                <span class="badge bestseller">Bestseller</span>
                            </c:if>
                            <c:if test="${book.featured}">
                                <span class="badge featured">Featured</span>
                            </c:if>
                            <c:if test="${book.discount > 0}">
                                <span class="badge discount">-${book.discount}%</span>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="book-info">
                        <h2>${book.bookName}</h2>
                        <p class="book-author">By ${book.writerName}</p>
                        
                        <div class="detail-row">
                            <div class="detail-label">Category:</div>
                            <div class="detail-value">${book.category.categoryName}</div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">ISBN:</div>
                            <div class="detail-value">${book.isbn != null && !book.isbn.isEmpty() ? book.isbn : "N/A"}</div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Price:</div>
                            <div class="detail-value">
                                <c:if test="${book.discount > 0}">
                                    <span class="original-price">₹<fmt:formatNumber value="${book.price}" type="number" pattern="#,##0.00" /></span>
                                    <span class="discounted-price">₹<fmt:formatNumber value="${book.price * (1 - book.discount/100)}" type="number" pattern="#,##0.00" /></span>
                                </c:if>
                                <c:if test="${book.discount == 0}">
                                    <span>₹<fmt:formatNumber value="${book.price}" type="number" pattern="#,##0.00" /></span>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Stock:</div>
                            <div class="detail-value">${book.quantity} units</div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Date Added:</div>
                            <div class="detail-value"><fmt:formatDate value="${book.dateAdded}" pattern="MMMM d, yyyy" /></div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Last Updated:</div>
                            <div class="detail-value"><fmt:formatDate value="${book.lastUpdated}" pattern="MMMM d, yyyy" /></div>
                        </div>
                    </div>
                </div>
                
                <div class="content-card">
                    <h3>Book Description</h3>
                    <div class="book-description">
                        <p>${book.description}</p>
                    </div>
                </div>
                
                <c:if test="${not empty reviews}">
                    <div class="content-card">
                        <h3>Customer Reviews</h3>
                        <div class="reviews-list">
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="review-user">
                                            <img src="${pageContext.request.contextPath}/images/avatar.png" alt="User">
                                            <span>${review.user.name}</span>
                                        </div>
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= review.rating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                        </div>
                                        <div class="review-date">
                                            <fmt:formatDate value="${review.reviewDate}" pattern="MMMM d, yyyy" />
                                        </div>
                                    </div>
                                    <div class="review-content">
                                        <p>${review.reviewText}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        // Delete confirmation
        function confirmDelete(bookId) {
            if (confirm('Are you sure you want to delete this book? This action cannot be undone.')) {
                window.location.href = '${pageContext.request.contextPath}/admin/books/delete?id=' + bookId;
            }
        }
    </script>
</body>
</html> 