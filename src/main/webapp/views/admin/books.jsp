<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books Management - Panna BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>Panna<span>Admin</span></h2>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/books">
                            <i class="fas fa-book"></i>
                            <span>Books</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fas fa-tags"></i>
                            <span>Categories</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i>
                            <span>Users</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Orders</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/profile">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="admin-main">
            <!-- Top Navigation -->
            <header class="admin-header">
                <div class="header-left">
                    <button class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="search-bar">
                        <input type="text" placeholder="Search books...">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                <div class="header-right">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">3</span>
                    </div>
                    <div class="user-menu">
                        <div class="user-avatar">
                            <c:if test="${not empty sessionScope.user}">
                                ${sessionScope.user.name.substring(0, 1).toUpperCase()}
                            </c:if>
                        </div>
                        <div class="user-dropdown">
                            <h4>${sessionScope.user.name}</h4>
                            <p>${sessionScope.user.email}</p>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/profile"><i class="fas fa-user"></i> Profile</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="fas fa-cog"></i> Settings</a></li>
                                <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Books Content -->
            <div class="dashboard-content">
                <div class="dashboard-header">
                    <h1>Books Management</h1>
                    <button class="btn btn-primary" id="addBookBtn">
                        <i class="fas fa-plus"></i> Add New Book
                    </button>
                </div>

                <!-- Books Table -->
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Cover</th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${books}">
                                <tr>
                                    <td>${book.id}</td>
                                    <td>
                                        <img src="${book.coverImage}" alt="${book.title}" class="book-cover">
                                    </td>
                                    <td>${book.title}</td>
                                    <td>${book.author}</td>
                                    <td>${book.category}</td>
                                    <td>$${book.price}</td>
                                    <td>${book.stock}</td>
                                    <td>
                                        <span class="status-badge ${book.status == 'Active' ? 'active' : 'inactive'}">
                                            ${book.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-edit" data-book-id="${book.id}" data-action="edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-delete" data-book-id="${book.id}" data-action="delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}" class="page-link">
                            <i class="fas fa-chevron-left"></i> Previous
                        </a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${noOfPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage eq i}">
                                <span class="page-link active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${i}" class="page-link">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${currentPage lt noOfPages}">
                        <a href="?page=${currentPage + 1}" class="page-link">
                            Next <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <!-- Add/Edit Book Modal -->
    <div class="modal" id="bookModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New Book</h2>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="bookForm" enctype="multipart/form-data">
                    <input type="hidden" id="bookId" name="bookId">
                    <div class="form-group">
                        <label for="bookName">Book Name</label>
                        <input type="text" id="bookName" name="bookName" required>
                    </div>
                    <div class="form-group">
                        <label for="writerName">Writer Name</label>
                        <input type="text" id="writerName" name="writerName" required>
                    </div>
                    <div class="form-group">
                        <label for="categories">Categories</label>
                        <select id="categories" name="categories" multiple required>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}">${category.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input type="number" id="price" name="price" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label for="stock">Stock</label>
                        <input type="number" id="stock" name="stock" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" required>
                            <option value="New">New Release</option>
                            <option value="Deal">Deal</option>
                            <option value="Bestseller">Bestseller</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="picture">Cover Image</label>
                        <input type="file" id="picture" name="picture" accept="image/*">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="cancelBtn">Cancel</button>
                <button class="btn btn-primary" id="saveBtn">Save Book</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const bookModal = document.getElementById('bookModal');
            const bookForm = document.getElementById('bookForm');
            const addBookBtn = document.getElementById('addBookBtn');
            const saveBtn = document.getElementById('saveBtn');
            const cancelBtn = document.getElementById('cancelBtn');
            const closeModal = document.querySelector('.close-modal');

            // Function to close the modal
            function closeBookModal() {
                bookModal.style.display = 'none';
                bookForm.reset();
                document.getElementById('bookId').value = '';
            }

            // Close modal when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === bookModal) {
                    closeBookModal();
                }
            });

            // Handle edit and delete buttons
            document.querySelectorAll('.action-buttons button').forEach(button => {
                button.addEventListener('click', function() {
                    const bookId = this.getAttribute('data-book-id');
                    const action = this.getAttribute('data-action');
                    
                    if (!bookId) {
                        alert('No book selected!');
                        return;
                    }

                    if (action === 'edit') {
                        fetch(`/BookStore/admin/books?bookId=${bookId}`)
                            .then(response => {
                                if (!response.ok) throw new Error('Failed to fetch book');
                                return response.json();
                            })
                            .then(book => {
                                document.getElementById('modalTitle').textContent = 'Edit Book';
                                document.getElementById('bookId').value = book.id;
                                document.getElementById('bookName').value = book.title;
                                document.getElementById('writerName').value = book.author;
                                document.getElementById('price').value = book.price;
                                document.getElementById('stock').value = book.stock;
                                document.getElementById('description').value = book.description;
                                document.getElementById('status').value = book.status;
                                bookModal.style.display = 'block';
                            })
                            .catch(error => {
                                alert('Failed to fetch book details');
                            });
                    }

                    if (action === 'delete') {
                        if (bookId && confirm('Are you sure you want to delete this book?')) {
                            fetch(`/BookStore/admin/books?bookId=${bookId}`, {
                                method: 'DELETE'
                            })
                            .then(response => {
                                if (response.ok) {
                                    location.reload();
                                } else {
                                    throw new Error('Failed to delete book');
                                }
                            })
                            .catch(error => {
                                alert('Failed to delete book');
                            });
                        }
                    }
                });
            });

            // Add Book Button
            addBookBtn.addEventListener('click', function() {
                document.getElementById('modalTitle').textContent = 'Add New Book';
                bookForm.reset();
                document.getElementById('bookId').value = '';
                bookModal.style.display = 'block';
            });

            // Save Book
            saveBtn.addEventListener('click', function() {
                const formData = new FormData(bookForm);
                const bookId = document.getElementById('bookId').value;
                const action = bookId ? 'edit' : 'add';
                
                // Add action parameter
                formData.append('action', action);
                if (bookId) {
                    formData.append('bookId', bookId);
                }

                fetch('/BookStore/admin/books', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        closeBookModal();
                        location.reload();
                    } else {
                        throw new Error('Failed to save book');
                    }
                })
                .catch(error => {
                    console.error('Error saving book:', error);
                    alert('Failed to save book');
                });
            });

            // Close Modal buttons
            closeModal.addEventListener('click', closeBookModal);
            cancelBtn.addEventListener('click', closeBookModal);
        });
    </script>
</body>
</html> 