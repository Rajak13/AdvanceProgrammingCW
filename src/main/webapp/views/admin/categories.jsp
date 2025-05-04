<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories Management - Panna BookStore Admin</title>
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
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/books">
                            <i class="fas fa-book"></i>
                            <span>Books</span>
                        </a>
                    </li>
                    <li class="active">
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
                        <input type="text" placeholder="Search categories...">
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
                            <div class="user-info">
                                <h4>${sessionScope.user.name}</h4>
                                <p>${sessionScope.user.email}</p>
                            </div>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/profile"><i class="fas fa-user"></i> Profile</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="fas fa-cog"></i> Settings</a></li>
                                <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Categories Content -->
            <div class="dashboard-content">
                <div class="dashboard-header">
                    <h1>Categories Management</h1>
                    <button class="btn btn-primary" id="addCategoryBtn">
                        <i class="fas fa-plus"></i> Add New Category
                    </button>
                </div>

                <!-- Categories Grid -->
                <div class="categories-grid">
                    <c:forEach var="category" items="${categories}">
                        <div class="category-card">
                            <div class="category-icon">
                                <i class="fas fa-tag"></i>
                            </div>
                            <div class="category-info">
                                <h3>${category.name}</h3>
                                <p>${category.description}</p>
                                <div class="category-stats">
                                    <span><i class="fas fa-book"></i> ${category.bookCount} Books</span>
                                </div>
                            </div>
                            <div class="category-actions">
                                <button class="btn btn-edit" data-category-id="${category.id}" data-action="edit">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-delete" data-category-id="${category.id}" data-action="delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
    </div>

    <!-- Add/Edit Category Modal -->
    <div class="modal" id="categoryModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New Category</h2>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="categoryForm">
                    <input type="hidden" id="categoryId" name="categoryId">
                    <div class="form-group">
                        <label for="categoryName">Category Name</label>
                        <input type="text" id="categoryName" name="categoryName" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="cancelBtn">Cancel</button>
                <button class="btn btn-primary" id="saveBtn">Save Category</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const categoryModal = document.getElementById('categoryModal');
            const categoryForm = document.getElementById('categoryForm');
            const addCategoryBtn = document.getElementById('addCategoryBtn');
            const saveBtn = document.getElementById('saveBtn');
            const cancelBtn = document.getElementById('cancelBtn');
            const closeModal = document.querySelector('.close-modal');

            // Function to close the modal
            function closeCategoryModal() {
                categoryModal.style.display = 'none';
                categoryForm.reset();
                document.getElementById('categoryId').value = '';
            }

            // Close modal when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === categoryModal) {
                    closeCategoryModal();
                }
            });

            // Handle edit and delete buttons
            document.querySelectorAll('.category-actions button').forEach(button => {
                button.addEventListener('click', function() {
                    const categoryId = this.getAttribute('data-category-id');
                    const action = this.getAttribute('data-action');
                    
                    if (!categoryId) {
                        alert('No category selected!');
                        return;
                    }

                    if (action === 'edit') {
                        fetch(`/BookStore/admin/categories?categoryId=${categoryId}`)
                            .then(response => {
                                if (!response.ok) throw new Error('Failed to fetch category');
                                return response.json();
                            })
                            .then(category => {
                                document.getElementById('modalTitle').textContent = 'Edit Category';
                                document.getElementById('categoryId').value = category.id;
                                document.getElementById('categoryName').value = category.name;
                                document.getElementById('description').value = category.description;
                                categoryModal.style.display = 'block';
                            })
                            .catch(error => {
                                alert('Failed to fetch category details');
                            });
                    }

                    if (action === 'delete') {
                        if (categoryId && confirm('Are you sure you want to delete this category?')) {
                            fetch(`/BookStore/admin/categories?categoryId=${categoryId}`, {
                                method: 'DELETE'
                            })
                            .then(response => {
                                if (response.ok) {
                                    location.reload();
                                } else {
                                    throw new Error('Failed to delete category');
                                }
                            })
                            .catch(error => {
                                alert('Failed to delete category');
                            });
                        }
                    }
                });
            });

            // Add Category Button
            addCategoryBtn.addEventListener('click', function() {
                document.getElementById('modalTitle').textContent = 'Add New Category';
                categoryForm.reset();
                document.getElementById('categoryId').value = '';
                categoryModal.style.display = 'block';
            });

            // Save Category
            saveBtn.addEventListener('click', function() {
                const formData = new FormData(categoryForm);
                const categoryId = document.getElementById('categoryId').value;
                const action = categoryId ? 'edit' : 'add';
                
                // Add action parameter
                formData.append('action', action);
                if (categoryId) {
                    formData.append('categoryId', categoryId);
                }

                fetch('/BookStore/admin/categories', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        closeCategoryModal();
                        location.reload();
                    } else {
                        throw new Error('Failed to save category');
                    }
                })
                .catch(error => {
                    console.error('Error saving category:', error);
                    alert('Failed to save category');
                });
            });

            // Close Modal buttons
            closeModal.addEventListener('click', closeCategoryModal);
            cancelBtn.addEventListener('click', closeCategoryModal);
        });
    </script>
</body>
</html> 