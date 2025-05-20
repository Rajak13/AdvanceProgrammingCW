<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books Management - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <jsp:include page="common/sidebar.jsp" />
        
        <main class="admin-main">
            <jsp:include page="common/header.jsp" />

            <!-- Books Content -->
            <div class="dashboard-content">
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon sales">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Books</h3>
                            <p class="stat-value">${totalBooks}</p>
                            <p class="stat-change">+${newBooksThisMonth} this month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon customers">
                            <i class="fas fa-tags"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Categories</h3>
                            <p class="stat-value">${totalCategories}</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Revenue</h3>
                            <p class="stat-value">$${totalRevenue}</p>
                            <p class="stat-change">+${revenueGrowth}% this month</p>
                        </div>
                    </div>
                </div>

                <!-- Books Table -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Books Management</h3>
                            <button class="btn btn-primary" id="addBookBtn">
                                <i class="fas fa-plus"></i> Add New Book
                            </button>
                        </div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Book</th>
                                <th>Author</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${books}">
                                <tr>
                                    <td>
                                        <div class="book-item">
                                            <img src="${pageContext.request.contextPath}/uploads/books/${book.picture}" alt="${book.bookName}" class="book-image">
                                            <div class="book-info">
                                                <h4>${book.bookName}</h4>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${book.writerName}</td>
                                    <td>${book.price}</td>
                                    <td>${book.stock}</td>
                                    <td>
                                        <span class="status-badge ${book.status}">${book.status}</span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-icon" onclick="editBook('${book.bookId}')"><i class="fas fa-edit"></i></button>
                                            <button class="btn-icon" onclick="deleteBook('${book.bookId}')"><i class="fas fa-trash"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <div class="table-info">
                            Showing ${(currentPage - 1) * itemsPerPage + 1} to 
                            ${((currentPage * itemsPerPage) > totalItems) ? totalItems : (currentPage * itemsPerPage)} of ${totalItems} entries
                        </div>
                        <div class="table-pagination">
                    <c:if test="${currentPage > 1}">
                                <button class="pagination-btn" onclick="changePage('${currentPage - 1}')">Previous</button>
                    </c:if>
                            <c:set var="end" value="${currentPage + 2}" />
                            <c:set var="endPage" value="${end > noOfPages ? noOfPages : end}" />
                            <c:forEach begin="1" end="${endPage}" var="i">
                                <button class="pagination-btn ${currentPage == i ? 'active' : ''}" 
                                        onclick="changePage('${i}')">${i}</button>
                    </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <button class="pagination-btn" onclick="changePage('${currentPage + 1}')">Next</button>
                    </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Add/Edit Book Modal -->
    <div class="modal" id="bookModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New Book</h2>
                <button type="button" class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="bookForm" enctype="multipart/form-data">
                    <input type="hidden" id="bookId" name="bookId">
                    <div class="form-group">
                        <label for="bookName">Book Title*</label>
                        <input type="text" id="bookName" name="bookName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="writerName">Author*</label>
                        <input type="text" id="writerName" name="writerName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="category">Category*</label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="">Select Category</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="price">Price*</label>
                        <input type="number" id="price" name="price" class="form-control" step="0.01" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="stock">Stock*</label>
                        <input type="number" id="stock" name="stock" class="form-control" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="status">Status*</label>
                        <select id="status" name="status" class="form-control" required>
                            <option value="">Select Status</option>
                            <option value="new-release">New Release</option>
                            <option value="bestseller">Bestseller</option>
                            <option value="deals">Deals</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="picture">Cover Image</label>
                        <input type="file" id="picture" name="picture" class="form-control" accept="image/*" onchange="previewImage(this)">
                        <div id="imagePreview" class="mt-2"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary">Cancel</button>
                <button type="submit" form="bookForm" class="btn btn-primary">Save Book</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        window.ctx = '${pageContext.request.contextPath}';
        document.addEventListener('DOMContentLoaded', function() {
            const bookModal = document.getElementById('bookModal');
            const bookForm = document.getElementById('bookForm');
            const addBookBtn = document.getElementById('addBookBtn');
            
            // Show modal function
            function showModal() {
                bookModal.style.display = 'block';
                bookModal.classList.add('show');
            }

            // Hide modal function
            function hideModal() {
                bookModal.style.display = 'none';
                bookModal.classList.remove('show');
                bookForm.reset();
            }

            // Add Book button click
            addBookBtn.addEventListener('click', function() {
                document.getElementById('modalTitle').textContent = 'Add New Book';
                document.getElementById('bookId').value = '';
                showModal();
            });

            // Close modal when clicking close button or outside
            document.querySelector('.close-modal').addEventListener('click', hideModal);
            document.querySelector('.btn-secondary').addEventListener('click', hideModal);
            window.addEventListener('click', function(event) {
                if (event.target === bookModal) {
                    hideModal();
                }
            });

            // Add debug logging
            console.log('Books data:', {
                count: '${books != null ? books.size() : 0}',
                page: '${currentPage}',
                totalPages: '${noOfPages}'
            });
            
            // Handle form submission
            bookForm.addEventListener('submit', async function(e) {
                e.preventDefault();
                const formData = new FormData(this);
                const bookId = document.getElementById('bookId').value;
                
                // Add action parameter based on whether it's an edit or add operation
                formData.append('action', bookId ? 'edit' : 'add');

                try {
                    console.log('Submitting form data...');
                    const response = await fetch(window.ctx + '/books', {
                        method: 'POST',
                        body: formData
                    });
                    
                    let result;
                    const contentType = response.headers.get("content-type");
                    console.log('Response content type:', contentType);
                    
                    try {
                        const text = await response.text();
                        console.log('Response text:', text);
                        result = JSON.parse(text);
                    } catch (e) {
                        console.error('Error parsing response:', e);
                        throw new Error('Invalid response format from server');
                    }

                    if (!response.ok) {
                        throw new Error(result.error || 'Failed to save book');
                    }

                    AdminDashboard.showNotification('success', result.message || 'Book saved successfully');
                    hideModal();
                    window.location.reload();
                } catch (error) {
                    console.error('Error:', error);
                    AdminDashboard.showNotification('error', error.message);
                }
            });

            // Edit book function
            window.editBook = async function(id) {
                try {
                    const response = await fetch(window.ctx + '/books?bookId=' + id, {
                        headers: { 'Accept': 'application/json' }
                    });
                    if (!response.ok) {
                        throw new Error('Failed to fetch book details');
                    }
                    const book = await response.json();
                    document.getElementById('modalTitle').textContent = 'Edit Book';
                    document.getElementById('bookId').value = book.bookId;
                    document.getElementById('bookName').value = book.bookName;
                    document.getElementById('writerName').value = book.writerName;
                    document.getElementById('price').value = book.price;
                    document.getElementById('stock').value = book.stock;
                    document.getElementById('description').value = book.description || '';
                    document.getElementById('status').value = book.status;
                    document.getElementById('category').value = book.categoryId;
                    if (book.categories) {
                        const categoriesSelect = document.getElementById('categories');
                        if (categoriesSelect) {
                            Array.from(categoriesSelect.options).forEach(option => option.selected = false);
                            book.categories.forEach(categoryId => {
                                const option = categoriesSelect.querySelector(`option[value="${categoryId}"]`);
                                if (option) option.selected = true;
                            });
                        }
                    }
                    showModal();
                } catch (error) {
                    console.error('Error:', error);
                    AdminDashboard.showNotification('error', 'Failed to load book details');
                }
            };

            // Delete book function
            window.deleteBook = async function(id) {
                if (!id) {
                    AdminDashboard.showNotification('error', 'Invalid book ID');
                    return;
                }

                if (!confirm('Are you sure you want to delete this book?')) {
                    return;
                }

                try {
                    const response = await fetch(window.ctx + '/books?bookId=' + id, {
                        method: 'DELETE',
                        headers: { 'Accept': 'application/json' }
                    });

                    let result;
                    try {
                        const text = await response.text();
                        result = text ? JSON.parse(text) : { message: 'Book deleted successfully' };
                    } catch (e) {
                        console.error('Error parsing response:', e);
                        result = { message: 'Book deleted successfully' };
                    }

                    if (!response.ok) {
                        throw new Error(result.error || 'Failed to delete book');
                    }

                    AdminDashboard.showNotification('success', result.message);
                    window.location.reload();
                } catch (error) {
                    console.error('Error:', error);
                    AdminDashboard.showNotification('error', error.message);
                }
            };

            function previewImage(input) {
                const preview = document.getElementById('imagePreview');
                preview.innerHTML = '';
                
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.style.maxWidth = '200px';
                        img.style.maxHeight = '200px';
                        img.style.marginTop = '10px';
                        preview.appendChild(img);
                    }
                    
                    reader.readAsDataURL(input.files[0]);
                }
            }
        });
    </script>
</body>
</html> 