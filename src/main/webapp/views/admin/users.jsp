<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .user-role {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .role-admin { background: #cce5ff; color: #004085; }
        .role-customer { background: #d1ecf1; color: #0c5460; }
        .user-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active { background: #d4edda; color: #155724; }
        .status-inactive { background: #f8d7da; color: #721c24; }
        .profile-image {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .user-details {
            display: grid;
            grid-template-columns: 100px 1fr;
            gap: 15px;
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Include sidebar -->
        <jsp:include page="common/sidebar.jsp">
            <jsp:param name="active" value="users" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>User Management</h1>
                <div class="header-actions">
                    <div class="search-container">
                        <input type="text" id="searchInput" placeholder="Search users...">
                        <button id="searchBtn"><i class="fas fa-search"></i></button>
                    </div>
                    <div class="filter-container">
                        <select id="roleFilter">
                            <option value="">All Roles</option>
                            <option value="ADMIN">Admin</option>
                            <option value="CUSTOMER">Customer</option>
                        </select>
                        <select id="statusFilter">
                            <option value="">All Statuses</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                    <button class="btn btn-primary" id="addUserBtn"><i class="fas fa-plus"></i> Add New User</button>
                </div>
            </div>

            <div class="content-body">
                <c:if test="${not empty message}">
                    <div class="alert ${messageType == 'success' ? 'alert-success' : 'alert-danger'}">
                        ${message}
                    </div>
                </c:if>

                <div class="card">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty users}">
                                <div class="empty-state">
                                    <i class="fas fa-users fa-4x"></i>
                                    <h3>No Users Found</h3>
                                    <p>Add a new user to get started or adjust your search filters</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Profile</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Role</th>
                                            <th>Joined Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${users}" var="user">
                                            <tr>
                                                <td>${user.id}</td>
                                                <td>
                                                    <img src="${not empty user.profileImage ? pageContext.request.contextPath.concat(user.profileImage) : pageContext.request.contextPath.concat('/images/default-avatar.png')}" 
                                                         alt="Profile" class="profile-image">
                                                </td>
                                                <td>${user.firstName} ${user.lastName}</td>
                                                <td>${user.email}</td>
                                                <td>
                                                    <span class="user-role ${user.role == 'ADMIN' ? 'role-admin' : 'role-customer'}">
                                                        ${user.role}
                                                    </span>
                                                </td>
                                                <td><fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" /></td>
                                                <td>
                                                    <span class="user-status ${user.active ? 'status-active' : 'status-inactive'}">
                                                        ${user.active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td class="actions">
                                                    <button class="btn-icon view-btn" data-id="${user.id}">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn-icon edit-btn" data-id="${user.id}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <c:if test="${currentUser.id != user.id}">
                                                        <button class="btn-icon delete-btn" data-id="${user.id}" data-name="${user.firstName} ${user.lastName}">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination">
                                        <c:if test="${currentPage > 1}">
                                            <a href="?page=${currentPage - 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.role ? '&role='.concat(param.role) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}" class="pagination-link">&laquo; Previous</a>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="?page=${i}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.role ? '&role='.concat(param.role) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}" class="pagination-link ${currentPage == i ? 'active' : ''}">${i}</a>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <a href="?page=${currentPage + 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.role ? '&role='.concat(param.role) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}" class="pagination-link">Next &raquo;</a>
                                        </c:if>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- User Modal -->
    <div class="modal" id="userModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New User</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="userForm" action="${pageContext.request.contextPath}/admin/users/save" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="userId" name="id" value="0">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name <span class="required">*</span></label>
                            <input type="text" id="firstName" name="firstName" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="lastName">Last Name <span class="required">*</span></label>
                            <input type="text" id="lastName" name="lastName" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group" id="passwordGroup">
                        <label for="password">Password <span class="required" id="passwordRequired">*</span></label>
                        <input type="password" id="password" name="password">
                        <div class="form-hint">
                            <span id="passwordHint">At least 8 characters with lowercase, uppercase, number, and special character.</span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone">
                    </div>
                    
                    <div class="form-group">
                        <label for="profileImage">Profile Image</label>
                        <input type="file" id="profileImage" name="profileImage" accept="image/*">
                        <div id="currentImageContainer" style="display: none;">
                            <p>Current Image:</p>
                            <img id="currentImage" alt="Current Profile" style="max-width: 100px; max-height: 100px;">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" rows="3"></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="role">Role <span class="required">*</span></label>
                            <select id="role" name="role" required>
                                <option value="CUSTOMER">Customer</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        
                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="isActive" name="active" checked>
                            <label for="isActive">Active</label>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View User Modal -->
    <div class="modal" id="viewUserModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>User Details</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <div id="userDetails" class="user-details">
                    <div class="user-avatar-container">
                        <img id="userAvatar" src="" alt="User Avatar" class="user-avatar">
                    </div>
                    <div class="user-info">
                        <h3 id="userName"></h3>
                        <p><strong>Email:</strong> <span id="userEmail"></span></p>
                        <p><strong>Phone:</strong> <span id="userPhone"></span></p>
                        <p><strong>Role:</strong> <span id="userRole"></span></p>
                        <p><strong>Status:</strong> <span id="userStatus"></span></p>
                        <p><strong>Joined:</strong> <span id="userJoined"></span></p>
                        <p><strong>Address:</strong> <span id="userAddress"></span></p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" id="closeViewBtn">Close</button>
                    <button type="button" class="btn btn-primary" id="editFromViewBtn">Edit User</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal" id="deleteModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Deletion</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the user "<span id="userToDelete"></span>"?</p>
                <div class="form-actions">
                    <button class="btn btn-secondary" id="cancelDeleteBtn">Cancel</button>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/users/delete" method="post">
                        <input type="hidden" id="deleteUserId" name="id">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar
        document.getElementById('toggleSidebar').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('collapsed');
            document.querySelector('.main-content').classList.toggle('expanded');
        });
        
        // Modal elements
        const userModal = document.getElementById('userModal');
        const viewUserModal = document.getElementById('viewUserModal');
        const deleteModal = document.getElementById('deleteModal');
        const addUserBtn = document.getElementById('addUserBtn');
        const closeButtons = document.querySelectorAll('.close-btn');
        const cancelBtn = document.getElementById('cancelBtn');
        const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
        const closeViewBtn = document.getElementById('closeViewBtn');
        const editFromViewBtn = document.getElementById('editFromViewBtn');
        
        // User to edit
        let currentEditUserId = null;
        
        // Open Add User Modal
        addUserBtn.addEventListener('click', function() {
            document.getElementById('modalTitle').textContent = 'Add New User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '0';
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('passwordRequired').style.display = 'inline';
            document.getElementById('password').required = true;
            document.getElementById('currentImageContainer').style.display = 'none';
            currentEditUserId = null;
            userModal.style.display = 'block';
        });
        
        // View user
        document.addEventListener('click', function(e) {
            if (e.target.closest('.view-btn')) {
                const btn = e.target.closest('.view-btn');
                const userId = btn.getAttribute('data-id');
                
                // Fetch user details via AJAX
                fetch('${pageContext.request.contextPath}/admin/users/get?id=' + userId)
                    .then(response => response.json())
                    .then(user => {
                        document.getElementById('userName').textContent = user.firstName + ' ' + user.lastName;
                        document.getElementById('userEmail').textContent = user.email;
                        document.getElementById('userPhone').textContent = user.phone || 'Not provided';
                        document.getElementById('userRole').textContent = user.role;
                        document.getElementById('userStatus').textContent = user.active ? 'Active' : 'Inactive';
                        document.getElementById('userJoined').textContent = new Date(user.createdAt).toLocaleDateString('en-US', {
                            year: 'numeric', month: 'long', day: 'numeric'
                        });
                        document.getElementById('userAddress').textContent = user.address || 'Not provided';
                        
                        // Set avatar
                        const avatarUrl = user.profileImage 
                            ? '${pageContext.request.contextPath}' + user.profileImage 
                            : '${pageContext.request.contextPath}/images/default-avatar.png';
                        document.getElementById('userAvatar').src = avatarUrl;
                        
                        // Store user ID for edit button
                        currentEditUserId = userId;
                        
                        viewUserModal.style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Error fetching user details:', error);
                        alert('Failed to load user details. Please try again.');
                    });
            }
        });
        
        // Edit from view button
        editFromViewBtn.addEventListener('click', function() {
            viewUserModal.style.display = 'none';
            document.querySelector('.edit-btn[data-id="' + currentEditUserId + '"]').click();
        });
        
        // Edit user
        document.addEventListener('click', function(e) {
            if (e.target.closest('.edit-btn')) {
                const btn = e.target.closest('.edit-btn');
                const userId = btn.getAttribute('data-id');
                
                // Fetch user details via AJAX
                fetch('${pageContext.request.contextPath}/admin/users/get?id=' + userId)
                    .then(response => response.json())
                    .then(user => {
                        document.getElementById('modalTitle').textContent = 'Edit User';
                        document.getElementById('userId').value = user.id;
                        document.getElementById('firstName').value = user.firstName;
                        document.getElementById('lastName').value = user.lastName;
                        document.getElementById('email').value = user.email;
                        document.getElementById('phone').value = user.phone || '';
                        document.getElementById('address').value = user.address || '';
                        document.getElementById('role').value = user.role;
                        document.getElementById('isActive').checked = user.active;
                        
                        // Password is optional when editing
                        document.getElementById('password').required = false;
                        document.getElementById('passwordRequired').style.display = 'none';
                        document.getElementById('passwordHint').textContent = 'Leave blank to keep current password.';
                        
                        // Show current profile image if available
                        if (user.profileImage) {
                            document.getElementById('currentImageContainer').style.display = 'block';
                            document.getElementById('currentImage').src = '${pageContext.request.contextPath}' + user.profileImage;
                        } else {
                            document.getElementById('currentImageContainer').style.display = 'none';
                        }
                        
                        userModal.style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Error fetching user details:', error);
                        alert('Failed to load user details. Please try again.');
                    });
            }
        });
        
        // Delete user
        document.addEventListener('click', function(e) {
            if (e.target.closest('.delete-btn')) {
                const btn = e.target.closest('.delete-btn');
                const userId = btn.getAttribute('data-id');
                const userName = btn.getAttribute('data-name');
                
                document.getElementById('deleteUserId').value = userId;
                document.getElementById('userToDelete').textContent = userName;
                
                deleteModal.style.display = 'block';
            }
        });
        
        // Close modals
        closeButtons.forEach(button => {
            button.addEventListener('click', function() {
                userModal.style.display = 'none';
                viewUserModal.style.display = 'none';
                deleteModal.style.display = 'none';
            });
        });
        
        cancelBtn.addEventListener('click', function() {
            userModal.style.display = 'none';
        });
        
        cancelDeleteBtn.addEventListener('click', function() {
            deleteModal.style.display = 'none';
        });
        
        closeViewBtn.addEventListener('click', function() {
            viewUserModal.style.display = 'none';
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(e) {
            if (e.target === userModal) {
                userModal.style.display = 'none';
            }
            if (e.target === viewUserModal) {
                viewUserModal.style.display = 'none';
            }
            if (e.target === deleteModal) {
                deleteModal.style.display = 'none';
            }
        });
        
        // Search and filter functionality
        document.getElementById('searchBtn').addEventListener('click', function() {
            applyFilters();
        });
        
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                applyFilters();
            }
        });
        
        document.getElementById('roleFilter').addEventListener('change', function() {
            applyFilters();
        });
        
        document.getElementById('statusFilter').addEventListener('change', function() {
            applyFilters();
        });
        
        function applyFilters() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const roleFilter = document.getElementById('roleFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            
            let url = '${pageContext.request.contextPath}/admin/users?';
            
            if (searchTerm) {
                url += 'search=' + encodeURIComponent(searchTerm) + '&';
            }
            
            if (roleFilter) {
                url += 'role=' + encodeURIComponent(roleFilter) + '&';
            }
            
            if (statusFilter) {
                url += 'status=' + encodeURIComponent(statusFilter) + '&';
            }
            
            // Remove trailing & if exists
            if (url.endsWith('&')) {
                url = url.slice(0, -1);
            }
            
            window.location.href = url;
        }
    </script>
</body>
</html> 