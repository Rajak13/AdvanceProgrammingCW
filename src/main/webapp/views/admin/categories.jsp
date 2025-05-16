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
                <h2>Panna BookStore</h2>
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
                        <a href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Orders</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i>
                            <span>Users</span>
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
            <!-- Header -->
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
                    <div class="language-selector">
                        <img src="${pageContext.request.contextPath}/assets/images/en-flag.png" alt="English">
                    </div>
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">2</span>
                    </div>
                    <div class="user-profile">
                        <img src="${pageContext.request.contextPath}/assets/images/user-avatar.jpg" alt="User">
                        <span>Aiden Max</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </header>

            <!-- Categories Content -->
            <div class="dashboard-content">
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon categories">
                            <i class="fas fa-tags"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Categories</h3>
                            <p class="stat-value">24</p>
                            <p class="stat-change">+5% last month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon books">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Books</h3>
                            <p class="stat-value">1,234</p>
                            <p class="stat-change">+15% last month</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Category Revenue</h3>
                            <p class="stat-value">$45,678</p>
                            <p class="stat-change">+20% last month</p>
                        </div>
                    </div>
                </div>

                <!-- Categories Table -->
                <div class="table-container">
                    <div class="table-header">
                        <h3>Categories Management</h3>
                        <div class="table-actions">
                            <div class="filters">
                                <select class="form-control">
                                    <option value="">Status</option>
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                            <button class="btn btn-primary" id="addCategoryBtn">
                                <i class="fas fa-plus"></i> Add New Category
                            </button>
                        </div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Category</th>
                                <th>Description</th>
                                <th>Books</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="category" items="${categories}">
                                <tr>
                                    <td>
                                        <div class="category-item">
                                            <i class="fas ${category.icon}"></i>
                                            <div class="category-info">
                                                <h4>${category.name}</h4>
                                                <p>Created: ${category.createdDate}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${category.description}</td>
                                    <td>${category.bookCount}</td>
                                    <td>
                                        <span class="status-badge ${category.status == 'Active' ? 'active' : 'inactive'}">
                                            ${category.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-icon" onclick="viewCategory('${category.id}')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn-icon" onclick="editCategory('${category.id}')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn-icon" onclick="deleteCategory('${category.id}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <div class="table-info">
                            Showing ${(currentPage - 1) * itemsPerPage + 1} to 
                            ${Math.min(currentPage * itemsPerPage, totalItems)} of ${totalItems} entries
                        </div>
                        <div class="table-pagination">
                            <c:if test="${currentPage > 1}">
                                <button class="pagination-btn" onclick="changePage('${currentPage - 1}')">Previous</button>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
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

    <!-- Add/Edit Category Modal -->
    <div class="modal" id="categoryModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New Category</h2>
                <button class="modal-close">&times;</button>
            </div>
            <div class="modal-body">
                <form id="categoryForm">
                    <input type="hidden" id="categoryId" name="categoryId">
                    <div class="form-group">
                        <label for="name">Category Name</label>
                        <input type="text" id="name" name="name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="icon">Icon</label>
                        <select id="icon" name="icon" class="form-control" required>
                            <option value="fa-book">Book</option>
                            <option value="fa-graduation-cap">Education</option>
                            <option value="fa-heart">Romance</option>
                            <option value="fa-dragon">Fantasy</option>
                            <option value="fa-microscope">Science</option>
                            <option value="fa-history">History</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" class="form-control" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn btn-primary" onclick="saveCategory()">Save Category</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        window.ctx = '${pageContext.request.contextPath}';
        // Category Management Functions
        function viewCategory(id) {
            // Implement view category details
        }

        function editCategory(id) {
            fetch(`${window.ctx}/api/categories/${id}`)
                .then(response => response.json())
                .then(category => {
                    document.getElementById('modalTitle').textContent = 'Edit Category';
                    document.getElementById('categoryId').value = category.id;
                    document.getElementById('name').value = category.name;
                    document.getElementById('description').value = category.description;
                    document.getElementById('icon').value = category.icon;
                    document.getElementById('status').value = category.status;
                    openModal();
                })
                .catch(error => console.error('Error:', error));
        }

        function deleteCategory(id) {
            if (confirm('Are you sure you want to delete this category?')) {
                fetch(`${window.ctx}/api/categories/${id}`, { method: 'DELETE' })
                    .then(response => {
                        if (response.ok) {
                            location.reload();
                        } else {
                            throw new Error('Failed to delete category');
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        }

        function saveCategory() {
            const form = document.getElementById('categoryForm');
            const formData = new FormData(form);
            
            fetch(`${window.ctx}/api/categories`, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    closeModal();
                    location.reload();
                } else {
                    throw new Error('Failed to save category');
                }
            })
            .catch(error => console.error('Error:', error));
        }

        function openModal() {
            document.getElementById('categoryModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('categoryModal').classList.remove('active');
            document.getElementById('categoryForm').reset();
        }

        function changePage(page) {
            window.location.href = `?page=${page}`;
        }

        // Initialize modal triggers
        document.getElementById('addCategoryBtn').addEventListener('click', function() {
            document.getElementById('modalTitle').textContent = 'Add New Category';
            document.getElementById('categoryForm').reset();
            openModal();
        });

        document.querySelector('.modal-close').addEventListener('click', closeModal);
    </script>
</body>
</html> 