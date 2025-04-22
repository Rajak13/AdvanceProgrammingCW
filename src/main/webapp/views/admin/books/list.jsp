<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books - Panna BookStore Admin</title>
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
                    <h1>Book Management</h1>
                </div>
                <div class="user-info">
                    <span>${sessionScope.user.name}</span>
                    <img src="${pageContext.request.contextPath}/images/avatar.png" alt="User Avatar">
                </div>
            </div>
            
            <div class="content">
                <div class="content-header">
                    <h2>All Books</h2>
                    <a href="${pageContext.request.contextPath}/admin/books/add" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Book
                    </a>
                </div>
                
                <div class="search-filter">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Search books...">
                        <button id="searchBtn"><i class="fas fa-search"></i></button>
                    </div>
                </div>
                
                <div class="content-card">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Book Name</th>
                                    <th>Writer</th>
                                    <th>Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${books}">
                                    <tr>
                                        <td>${book.bookId}</td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}${book.picture}" 
                                                 alt="${book.bookName}" 
                                                 class="thumbnail">
                                        </td>
                                        <td>${book.bookName}</td>
                                        <td>${book.writerName}</td>
                                        <td>Rs. ${book.price}</td>
                                        <td class="actions">
                                            <a href="${pageContext.request.contextPath}/admin/books/view?id=${book.bookId}" 
                                               class="btn-icon btn-view" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/books/edit?id=${book.bookId}" 
                                               class="btn-icon btn-edit" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" onclick="confirmDelete(${book.bookId});" 
                                               class="btn-icon btn-delete" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <c:if test="${empty books}">
                        <div class="no-data">
                            <p>No books found. <a href="${pageContext.request.contextPath}/admin/books/add">Add a new book</a>.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Sidebar toggle
        document.getElementById('toggleSidebar').addEventListener('click', function() {
            document.querySelector('.admin-container').classList.toggle('sidebar-collapsed');
        });
        
        // Search functionality
        document.getElementById('searchBtn').addEventListener('click', function() {
            performSearch();
        });
        
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });
        
        function performSearch() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            if (searchTerm) {
                window.location.href = '${pageContext.request.contextPath}/admin/books?search=' + encodeURIComponent(searchTerm);
            }
        }
        
        // Delete confirmation
        function confirmDelete(bookId) {
            if (confirm('Are you sure you want to delete this book?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/books/delete?id=' + bookId;
            }
        }
    </script>
</body>
</html> 