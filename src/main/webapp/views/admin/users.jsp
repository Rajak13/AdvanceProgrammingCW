<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users Management - Panna BookStore Admin</title>
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
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fas fa-tags"></i>
                            <span>Categories</span>
                        </a>
                    </li>
                    <li class="active">
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
                        <input type="text" placeholder="Search users...">
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

            <!-- Users Content -->
            <div class="dashboard-content">
                <div class="dashboard-header">
                    <h1>Users Management</h1>
                    <div class="user-filters">
                        <select id="statusFilter">
                            <option value="all">All Users</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                        <button class="btn btn-primary" id="addUserBtn">
                            <i class="fas fa-plus"></i> Add New User
                        </button>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Joined Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.id}</td>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar small">
                                                ${user.name.substring(0, 1).toUpperCase()}
                                            </div>
                                            <div class="user-info">
                                                <h4>${user.name}</h4>
                                                <p>${user.name}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>
                                        <span class="role-badge ${user.role.toLowerCase()}">
                                            ${user.role}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${user.status == 'Active' ? 'active' : 'inactive'}">
                                            ${user.status}
                                        </span>
                                    </td>
                                    <td>${user.joinedDate}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-edit" data-user-name="${user.name}" data-action="edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-delete" data-user-name="${user.name}" data-action="delete">
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

    <!-- Add/Edit User Modal -->
    <div class="modal" id="userModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New User</h2>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="userForm" enctype="multipart/form-data">
                    <input type="hidden" id="userId" name="userId">
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address">
                    </div>
                    <div class="form-group">
                        <label for="contact">Contact</label>
                        <input type="text" id="contact" name="contact">
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password">
                    </div>
                    <div class="form-group">
                        <label for="role">Role</label>
                        <select id="role" name="role" required>
                            <option value="USER">User</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="picture">Profile Picture</label>
                        <input type="file" id="picture" name="picture" accept="image/*">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="cancelBtn">Cancel</button>
                <button class="btn btn-primary" id="saveBtn">Save User</button>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log("User modal JS loaded");
            const userModal = document.getElementById('userModal');
            const userForm = document.getElementById('userForm');
            const statusFilter = document.getElementById('statusFilter');
            const addUserBtn = document.getElementById('addUserBtn');
            const saveBtn = document.getElementById('saveBtn');
            const cancelBtn = document.getElementById('cancelBtn');
            const closeModal = document.querySelector('.close-modal');

            function closeUserModal() {
                userModal.style.display = 'none';
                userForm.reset();
                document.getElementById('userId').value = '';
            }

            // Defensive event listener attachment
            if (closeModal) closeModal.addEventListener('click', closeUserModal);
            if (cancelBtn) cancelBtn.addEventListener('click', closeUserModal);

            window.addEventListener('click', function(event) {
                if (event.target === userModal) {
                    closeUserModal();
                }
            });

            // Handle edit and delete buttons
            document.querySelectorAll('.action-buttons button').forEach(button => {
                button.addEventListener('click', function() {
                    const userName = this.getAttribute('data-user-name');
                    const action = this.getAttribute('data-action');
                    
                    if (!userName) {
                        alert('No user selected!');
                        return;
                    }

                    if (action === 'edit') {
                        fetch(`/BookStore/admin/users?userName=${encodeURIComponent(userName)}`)
                            .then(response => {
                                if (!response.ok) throw new Error('Failed to fetch user');
                                return response.json();
                            })
                            .then(user => {
                                document.getElementById('modalTitle').textContent = 'Edit User';
                                document.getElementById('userId').value = user.id;
                                document.getElementById('name').value = user.name;
                                document.getElementById('email').value = user.email;
                                document.getElementById('address').value = user.address;
                                document.getElementById('contact').value = user.contact;
                                document.getElementById('role').value = user.role;
                                userModal.style.display = 'block';
                            })
                            .catch(error => {
                                alert('Failed to fetch user details');
                            });
                    }

                    if (action === 'delete') {
                        if (userName && confirm('Are you sure you want to delete this user?')) {
                            fetch(`/BookStore/admin/users?userName=${encodeURIComponent(userName)}`, {
                                method: 'DELETE'
                            })
                            .then(response => {
                                if (response.ok) {
                                    location.reload();
                                } else {
                                    throw new Error('Failed to delete user');
                                }
                            })
                            .catch(error => {
                                alert('Failed to delete user');
                            });
                        }
                    }
                });
            });

            // Add User Button
            if (addUserBtn) addUserBtn.addEventListener('click', function() {
                document.getElementById('modalTitle').textContent = 'Add New User';
                userForm.reset();
                document.getElementById('userId').value = '';
                userModal.style.display = 'block';
            });

            // Save User
            if (saveBtn) saveBtn.addEventListener('click', function() {
                const formData = new FormData(userForm);
                const userName = document.getElementById('name').value;
                const action = document.getElementById('userId').value ? 'edit' : 'add';
                
                // Add action parameter
                formData.append('action', action);
                if (userName) {
                    formData.append('userName', userName);
                }

                fetch('/BookStore/admin/users', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        closeUserModal();
                        location.reload();
                    } else {
                        response.text().then(errorMessage => {
                            console.error(`Error saving user: Status ${response.status}: ${errorMessage}`);
                            alert(`Failed to save user: Status ${response.status}: ${errorMessage}`);
                        });
                        throw new Error('Failed to save user');
                    }
                })
                .catch(error => {
                    console.error('Error saving user:', error);
                    alert('Failed to save user');
                });
            });

            // Status Filter
            statusFilter.addEventListener('change', function() {
                const status = this.value;
                window.location.href = `/BookStore/admin/users?status=${status}`;
            });

            // Show success/error messages
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');
            
            if (success) {
                alert(success);
            }
            if (error) {
                alert(error);
            }
        });
    </script>
</body>
</html> 