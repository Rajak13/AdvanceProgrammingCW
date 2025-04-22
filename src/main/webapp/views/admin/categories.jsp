<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Management - BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .category-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 15px 20px;
            margin-bottom: 15px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .category-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .category-info {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-grow: 1;
        }
        
        .category-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--primary-color-light);
            color: var(--primary-color);
            border-radius: 8px;
            font-size: 18px;
        }
        
        .category-name {
            font-weight: bold;
            font-size: 16px;
            margin: 0;
        }
        
        .category-details {
            display: flex;
            gap: 30px;
            color: #666;
            font-size: 14px;
        }
        
        .category-detail {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .category-actions {
            display: flex;
            gap: 10px;
        }
        
        .action-btn {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .view-btn {
            background-color: #e3f2fd;
            color: #0d47a1;
        }
        
        .view-btn:hover {
            background-color: #bbdefb;
        }
        
        .edit-btn {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .edit-btn:hover {
            background-color: #c8e6c9;
        }
        
        .delete-btn {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .delete-btn:hover {
            background-color: #ffcdd2;
        }
        
        .color-preview {
            width: 24px;
            height: 24px;
            border-radius: 4px;
            display: inline-block;
            margin-right: 8px;
            vertical-align: middle;
            border: 1px solid #ddd;
        }
        
        .color-field {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .icon-preview {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f5f5f5;
            border-radius: 8px;
            margin-right: 15px;
            font-size: 20px;
        }
        
        .icon-list {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 10px;
            margin-top: 10px;
            max-height: 200px;
            overflow-y: auto;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }
        
        .icon-option {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .icon-option:hover {
            background-color: #f0f0f0;
            transform: scale(1.1);
        }
        
        .icon-option.selected {
            border-color: var(--primary-color);
            background-color: var(--primary-color-light);
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <jsp:include page="\common\sidebar.jsp">
            <jsp:param name="active" value="categories" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h2>Manage Categories</h2>
                <button id="addCategoryBtn" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add Category
                </button>
            </div>
            
            <div class="content-section">
                <div class="search-filter">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="search-container">
                        <input type="text" name="search" placeholder="Search categories..." value="${param.search}">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>
                
                <div class="table-container">
                    <div class="categories-list">
                        <c:choose>
                            <c:when test="${empty categories}">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="fas fa-tags"></i>
                                    </div>
                                    <h3>No Categories Found</h3>
                                    <p>There are no categories matching your search criteria.</p>
                                    <button id="emptyAddCategoryBtn" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Add Category
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${categories}" var="category">
                                    <div class="category-card">
                                        <div class="category-info">
                                            <div class="category-icon" style="background-color: ${category.colorLight}; color: ${category.color};">
                                                <i class="fas ${category.icon}"></i>
                                            </div>
                                            <div>
                                                <h3 class="category-name">${category.name}</h3>
                                                <div class="category-details">
                                                    <div class="category-detail">
                                                        <i class="fas fa-book"></i>
                                                        <span>${category.bookCount} Books</span>
                                                    </div>
                                                    <div class="category-detail">
                                                        <i class="fas fa-calendar-alt"></i>
                                                        <span><fmt:formatDate value="${category.createdAt}" pattern="MMM dd, yyyy" /></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="category-actions">
                                            <button class="action-btn view-btn" title="View Books" 
                                                    onclick="window.location.href='${pageContext.request.contextPath}/admin/books?category=${category.id}'">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-btn edit-btn edit-category-btn" title="Edit Category" 
                                                    data-id="${category.id}" 
                                                    data-name="${category.name}" 
                                                    data-description="${category.description}" 
                                                    data-color="${category.color}" 
                                                    data-color-light="${category.colorLight}" 
                                                    data-icon="${category.icon}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="action-btn delete-btn delete-category-btn" title="Delete Category" 
                                                    data-id="${category.id}" 
                                                    data-name="${category.name}" 
                                                    data-book-count="${category.bookCount}">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination">
                                        <c:if test="${currentPage > 1}">
                                            <a href="?page=${currentPage - 1}${not empty param.search ? '&search='.concat(param.search) : ''}" class="pagination-link">&laquo; Previous</a>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="?page=${i}${not empty param.search ? '&search='.concat(param.search) : ''}" class="pagination-link ${currentPage == i ? 'active' : ''}">${i}</a>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <a href="?page=${currentPage + 1}${not empty param.search ? '&search='.concat(param.search) : ''}" class="pagination-link">Next &raquo;</a>
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

    <!-- Add/Edit Category Modal -->
    <div class="modal" id="categoryModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="categoryModalTitle">Add Category</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="categoryForm" action="${pageContext.request.contextPath}/admin/categories/save" method="post">
                    <input type="hidden" id="categoryId" name="id">
                    
                    <div class="form-group">
                        <label for="categoryName">Category Name</label>
                        <input type="text" id="categoryName" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoryDescription">Description</label>
                        <textarea id="categoryDescription" name="description" rows="3"></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group half">
                            <label for="categoryColor">Color</label>
                            <div class="color-field">
                                <span class="color-preview" id="colorPreview"></span>
                                <input type="color" id="categoryColor" name="color" value="#4a6ee0">
                            </div>
                        </div>
                        
                        <div class="form-group half">
                            <label for="categoryColorLight">Light Color</label>
                            <div class="color-field">
                                <span class="color-preview" id="colorLightPreview"></span>
                                <input type="color" id="categoryColorLight" name="colorLight" value="#e7eeff">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Icon</label>
                        <div class="form-row">
                            <div class="icon-preview" id="selectedIconPreview">
                                <i class="fas fa-book" id="previewIconClass"></i>
                            </div>
                            <div>
                                <input type="hidden" id="categoryIcon" name="icon" value="fa-book">
                                <button type="button" class="btn btn-secondary" id="selectIconBtn">Select Icon</button>
                            </div>
                        </div>
                        
                        <div class="icon-list" id="iconList" style="display: none;">
                            <div class="icon-option" data-icon="fa-book"><i class="fas fa-book"></i></div>
                            <div class="icon-option" data-icon="fa-graduation-cap"><i class="fas fa-graduation-cap"></i></div>
                            <div class="icon-option" data-icon="fa-laptop-code"><i class="fas fa-laptop-code"></i></div>
                            <div class="icon-option" data-icon="fa-flask"><i class="fas fa-flask"></i></div>
                            <div class="icon-option" data-icon="fa-history"><i class="fas fa-history"></i></div>
                            <div class="icon-option" data-icon="fa-heart"><i class="fas fa-heart"></i></div>
                            <div class="icon-option" data-icon="fa-globe"><i class="fas fa-globe"></i></div>
                            <div class="icon-option" data-icon="fa-palette"><i class="fas fa-palette"></i></div>
                            <div class="icon-option" data-icon="fa-music"><i class="fas fa-music"></i></div>
                            <div class="icon-option" data-icon="fa-camera"><i class="fas fa-camera"></i></div>
                            <div class="icon-option" data-icon="fa-utensils"><i class="fas fa-utensils"></i></div>
                            <div class="icon-option" data-icon="fa-plane"><i class="fas fa-plane"></i></div>
                            <div class="icon-option" data-icon="fa-running"><i class="fas fa-running"></i></div>
                            <div class="icon-option" data-icon="fa-child"><i class="fas fa-child"></i></div>
                            <div class="icon-option" data-icon="fa-bible"><i class="fas fa-bible"></i></div>
                            <div class="icon-option" data-icon="fa-business-time"><i class="fas fa-business-time"></i></div>
                            <div class="icon-option" data-icon="fa-chess"><i class="fas fa-chess"></i></div>
                            <div class="icon-option" data-icon="fa-seedling"><i class="fas fa-seedling"></i></div>
                            <div class="icon-option" data-icon="fa-brain"><i class="fas fa-brain"></i></div>
                            <div class="icon-option" data-icon="fa-cogs"><i class="fas fa-cogs"></i></div>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelCategoryBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Category</button>
                    </div>
                </form>
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
                <p id="deleteWarning">Are you sure you want to delete the category "<span id="categoryToDelete"></span>"?</p>
                <p id="deleteWithBooksWarning" class="warning-text">This category contains <span id="bookCount"></span> books that will become uncategorized.</p>
                
                <div class="form-actions">
                    <button class="btn btn-secondary" id="cancelDeleteBtn">Cancel</button>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/categories/delete" method="post">
                        <input type="hidden" id="deleteCategoryId" name="id">
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
        const categoryModal = document.getElementById('categoryModal');
        const deleteModal = document.getElementById('deleteModal');
        const closeButtons = document.querySelectorAll('.close-btn');
        const cancelCategoryBtn = document.getElementById('cancelCategoryBtn');
        const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
        
        // Category form elements
        const categoryForm = document.getElementById('categoryForm');
        const categoryId = document.getElementById('categoryId');
        const categoryName = document.getElementById('categoryName');
        const categoryDescription = document.getElementById('categoryDescription');
        const categoryColor = document.getElementById('categoryColor');
        const categoryColorLight = document.getElementById('categoryColorLight');
        const categoryIcon = document.getElementById('categoryIcon');
        const categoryModalTitle = document.getElementById('categoryModalTitle');
        const colorPreview = document.getElementById('colorPreview');
        const colorLightPreview = document.getElementById('colorLightPreview');
        const previewIconClass = document.getElementById('previewIconClass');
        
        // Buttons
        const addCategoryBtn = document.getElementById('addCategoryBtn');
        const emptyAddCategoryBtn = document.getElementById('emptyAddCategoryBtn');
        const selectIconBtn = document.getElementById('selectIconBtn');
        const iconList = document.getElementById('iconList');
        const iconOptions = document.querySelectorAll('.icon-option');
        
        // Opening modals
        if (addCategoryBtn) {
            addCategoryBtn.addEventListener('click', openAddCategoryModal);
        }
        
        if (emptyAddCategoryBtn) {
            emptyAddCategoryBtn.addEventListener('click', openAddCategoryModal);
        }
        
        document.querySelectorAll('.edit-category-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                openEditCategoryModal(this);
            });
        });
        
        document.querySelectorAll('.delete-category-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                openDeleteModal(this);
            });
        });
        
        // Closing modals
        closeButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                categoryModal.style.display = 'none';
                deleteModal.style.display = 'none';
            });
        });
        
        cancelCategoryBtn.addEventListener('click', function() {
            categoryModal.style.display = 'none';
        });
        
        cancelDeleteBtn.addEventListener('click', function() {
            deleteModal.style.display = 'none';
        });
        
        window.addEventListener('click', function(event) {
            if (event.target == categoryModal) {
                categoryModal.style.display = 'none';
            }
            if (event.target == deleteModal) {
                deleteModal.style.display = 'none';
            }
        });
        
        // Color preview functionality
        categoryColor.addEventListener('input', function() {
            colorPreview.style.backgroundColor = this.value;
        });
        
        categoryColorLight.addEventListener('input', function() {
            colorLightPreview.style.backgroundColor = this.value;
        });
        
        // Icon selection
        selectIconBtn.addEventListener('click', function() {
            iconList.style.display = iconList.style.display === 'none' ? 'grid' : 'none';
        });
        
        iconOptions.forEach(option => {
            option.addEventListener('click', function() {
                const iconClass = this.getAttribute('data-icon');
                categoryIcon.value = iconClass;
                previewIconClass.className = 'fas ' + iconClass;
                
                iconOptions.forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');
                
                iconList.style.display = 'none';
            });
        });
        
        // Functions
        function openAddCategoryModal() {
            categoryModalTitle.textContent = 'Add Category';
            categoryId.value = '';
            categoryForm.reset();
            
            // Set default values
            categoryColor.value = '#4a6ee0';
            categoryColorLight.value = '#e7eeff';
            categoryIcon.value = 'fa-book';
            
            colorPreview.style.backgroundColor = categoryColor.value;
            colorLightPreview.style.backgroundColor = categoryColorLight.value;
            previewIconClass.className = 'fas fa-book';
            
            iconOptions.forEach(opt => {
                opt.classList.remove('selected');
                if (opt.getAttribute('data-icon') === 'fa-book') {
                    opt.classList.add('selected');
                }
            });
            
            categoryModal.style.display = 'block';
        }
        
        function openEditCategoryModal(button) {
            categoryModalTitle.textContent = 'Edit Category';
            
            categoryId.value = button.getAttribute('data-id');
            categoryName.value = button.getAttribute('data-name');
            categoryDescription.value = button.getAttribute('data-description');
            categoryColor.value = button.getAttribute('data-color');
            categoryColorLight.value = button.getAttribute('data-color-light');
            categoryIcon.value = button.getAttribute('data-icon');
            
            colorPreview.style.backgroundColor = categoryColor.value;
            colorLightPreview.style.backgroundColor = categoryColorLight.value;
            previewIconClass.className = 'fas ' + categoryIcon.value;
            
            iconOptions.forEach(opt => {
                opt.classList.remove('selected');
                if (opt.getAttribute('data-icon') === categoryIcon.value) {
                    opt.classList.add('selected');
                }
            });
            
            categoryModal.style.display = 'block';
        }
        
        function openDeleteModal(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            const bookCount = parseInt(button.getAttribute('data-book-count'));
            
            document.getElementById('deleteCategoryId').value = id;
            document.getElementById('categoryToDelete').textContent = name;
            document.getElementById('bookCount').textContent = bookCount;
            
            if (bookCount > 0) {
                document.getElementById('deleteWithBooksWarning').style.display = 'block';
            } else {
                document.getElementById('deleteWithBooksWarning').style.display = 'none';
            }
            
            deleteModal.style.display = 'block';
        }
    </script>
</body>
</html> 