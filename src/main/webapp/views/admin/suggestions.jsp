<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Suggestions Management - BookStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .suggestion-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-new { background: #d1ecf1; color: #0c5460; }
        .status-in-progress { background: #fff3cd; color: #856404; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }
        
        .suggestion-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .suggestion-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .suggestion-title {
            font-size: 18px;
            font-weight: bold;
            margin: 0;
        }
        
        .suggestion-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .suggestion-content {
            background-color: #f9f9f9;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        
        .suggestion-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .suggestion-actions {
            display: flex;
            gap: 10px;
        }
        
        .note-field {
            background-color: #f9f9f9;
            border-radius: 4px;
            padding: 15px;
            margin-top: 15px;
        }
        
        .note-field h4 {
            margin-top: 0;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        textarea.admin-note {
            width: 100%;
            min-height: 80px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            font-family: inherit;
            resize: vertical;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Include sidebar -->
        <jsp:include page="common/sidebar.jsp">
            <jsp:param name="active" value="suggestions" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Suggestions Management</h1>
                <div class="header-actions">
                    <div class="search-container">
                        <input type="text" id="searchInput" placeholder="Search suggestions...">
                        <button id="searchBtn"><i class="fas fa-search"></i></button>
                    </div>
                    <div class="filter-container">
                        <select id="statusFilter">
                            <option value="">All Statuses</option>
                            <option value="NEW">New</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="REJECTED">Rejected</option>
                        </select>
                        <select id="typeFilter">
                            <option value="">All Types</option>
                            <option value="BOOK_REQUEST">Book Request</option>
                            <option value="IMPROVEMENT">Improvement</option>
                            <option value="BUG">Bug Report</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
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
                            <c:when test="${empty suggestions}">
                                <div class="empty-state">
                                    <i class="fas fa-lightbulb fa-4x"></i>
                                    <h3>No Suggestions Found</h3>
                                    <p>There are no user suggestions at the moment</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${suggestions}" var="suggestion">
                                    <div class="suggestion-card">
                                        <div class="suggestion-header">
                                            <h3 class="suggestion-title">${suggestion.title}</h3>
                                            <span class="suggestion-status status-${suggestion.status.toLowerCase().replace('_', '-')}">
                                                ${suggestion.status.replace('_', ' ')}
                                            </span>
                                        </div>
                                        
                                        <div class="suggestion-meta">
                                            <span><i class="fas fa-user"></i> ${suggestion.userName}</span>
                                            <span><i class="fas fa-envelope"></i> ${suggestion.userEmail}</span>
                                            <span><i class="fas fa-tag"></i> ${suggestion.type.replace('_', ' ')}</span>
                                            <span><i class="fas fa-calendar"></i> <fmt:formatDate value="${suggestion.createdAt}" pattern="MMM dd, yyyy HH:mm" /></span>
                                        </div>
                                        
                                        <div class="suggestion-content">
                                            ${suggestion.content}
                                        </div>
                                        
                                        <c:if test="${not empty suggestion.adminNote}">
                                            <div class="note-field">
                                                <h4>Admin Notes:</h4>
                                                <p>${suggestion.adminNote}</p>
                                            </div>
                                        </c:if>
                                        
                                        <div class="suggestion-footer">
                                            <form action="${pageContext.request.contextPath}/admin/suggestions/updateStatus" method="post" class="status-form">
                                                <input type="hidden" name="id" value="${suggestion.id}">
                                                <select name="status" class="status-select" onchange="this.form.submit()">
                                                    <option value="NEW" ${suggestion.status == 'NEW' ? 'selected' : ''}>New</option>
                                                    <option value="IN_PROGRESS" ${suggestion.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                                    <option value="COMPLETED" ${suggestion.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                                    <option value="REJECTED" ${suggestion.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                                </select>
                                            </form>
                                            
                                            <div class="suggestion-actions">
                                                <button class="btn btn-secondary add-note-btn" data-id="${suggestion.id}">
                                                    <i class="fas fa-comment"></i> ${not empty suggestion.adminNote ? 'Edit Note' : 'Add Note'}
                                                </button>
                                                <button class="btn btn-secondary reply-btn" data-email="${suggestion.userEmail}" data-name="${suggestion.userName}">
                                                    <i class="fas fa-reply"></i> Reply to User
                                                </button>
                                                <button class="btn btn-danger delete-btn" data-id="${suggestion.id}" data-title="${suggestion.title}">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination">
                                        <c:if test="${currentPage > 1}">
                                            <a href="?page=${currentPage - 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.type ? '&type='.concat(param.type) : ''}" class="pagination-link">&laquo; Previous</a>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="?page=${i}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.type ? '&type='.concat(param.type) : ''}" class="pagination-link ${currentPage == i ? 'active' : ''}">${i}</a>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <a href="?page=${currentPage + 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.type ? '&type='.concat(param.type) : ''}" class="pagination-link">Next &raquo;</a>
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

    <!-- Add/Edit Note Modal -->
    <div class="modal" id="noteModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Admin Note</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="noteForm" action="${pageContext.request.contextPath}/admin/suggestions/addNote" method="post">
                    <input type="hidden" id="suggestionId" name="id" value="">
                    
                    <div class="form-group">
                        <label for="adminNote">Note (internal use only)</label>
                        <textarea id="adminNote" name="adminNote" rows="5" class="admin-note"></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelNoteBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Note</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Reply Modal -->
    <div class="modal" id="replyModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Reply to User</h2>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="replyForm" action="${pageContext.request.contextPath}/admin/suggestions/reply" method="post">
                    <div class="form-group">
                        <label for="recipientEmail">To</label>
                        <input type="email" id="recipientEmail" name="recipientEmail" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="recipientName">Recipient Name</label>
                        <input type="text" id="recipientName" name="recipientName" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" id="subject" name="subject" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea id="message" name="message" rows="8" required></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelReplyBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Send Reply</button>
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
                <p>Are you sure you want to delete the suggestion "<span id="suggestionToDelete"></span>"?</p>
                <div class="form-actions">
                    <button class="btn btn-secondary" id="cancelDeleteBtn">Cancel</button>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/suggestions/delete" method="post">
                        <input type="hidden" id="deleteSuggestionId" name="id">
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
        const noteModal = document.getElementById('noteModal');
        const replyModal = document.getElementById('replyModal');
        const deleteModal = document.getElementById('deleteModal');
        const closeButtons = document.querySelectorAll('.close-btn');
        const cancelNoteBtn = document.getElementById('cancelNoteBtn');
        const cancelReplyBtn = document.getElementById('cancelReplyBtn');
        const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
        
        // Add/Edit Note
        document.addEventListener('click', function(e) {
            if (e.target.closest('.add-note-btn')) {
                const btn = e.target.closest('.add-note-btn');
                const suggestionId = btn.getAttribute('data-id');
                
                // Fetch current note via AJAX (if exists)
                fetch('${pageContext.request.contextPath}/admin/suggestions/getNote?id=' + suggestionId)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('suggestionId').value = suggestionId;
                        document.getElementById('adminNote').value = data.adminNote || '';
                        noteModal.style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Error fetching note:', error);
                        document.getElementById('suggestionId').value = suggestionId;
                        document.getElementById('adminNote').value = '';
                        noteModal.style.display = 'block';
                    });
            }
        });
        
        // Reply to user
        document.addEventListener('click', function(e) {
            if (e.target.closest('.reply-btn')) {
                const btn = e.target.closest('.reply-btn');
                const email = btn.getAttribute('data-email');
                const name = btn.getAttribute('data-name');
                
                document.getElementById('recipientEmail').value = email;
                document.getElementById('recipientName').value = name;
                document.getElementById('subject').value = 'RE: Your suggestion to BookStore';
                document.getElementById('message').value = 'Dear ' + name + ',\n\nThank you for your suggestion. \n\n';
                
                replyModal.style.display = 'block';
            }
        });
        
        // Delete suggestion
        document.addEventListener('click', function(e) {
            if (e.target.closest('.delete-btn')) {
                const btn = e.target.closest('.delete-btn');
                const suggestionId = btn.getAttribute('data-id');
                const suggestionTitle = btn.getAttribute('data-title');
                
                document.getElementById('deleteSuggestionId').value = suggestionId;
                document.getElementById('suggestionToDelete').textContent = suggestionTitle;
                
                deleteModal.style.display = 'block';
            }
        });
        
        // Close modals
        closeButtons.forEach(button => {
            button.addEventListener('click', function() {
                noteModal.style.display = 'none';
                replyModal.style.display = 'none';
                deleteModal.style.display = 'none';
            });
        });
        
        cancelNoteBtn.addEventListener('click', function() {
            noteModal.style.display = 'none';
        });
        
        cancelReplyBtn.addEventListener('click', function() {
            replyModal.style.display = 'none';
        });
        
        cancelDeleteBtn.addEventListener('click', function() {
            deleteModal.style.display = 'none';
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(e) {
            if (e.target === noteModal) {
                noteModal.style.display = 'none';
            }
            if (e.target === replyModal) {
                replyModal.style.display = 'none';
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
        
        document.getElementById('statusFilter').addEventListener('change', function() {
            applyFilters();
        });
        
        document.getElementById('typeFilter').addEventListener('change', function() {
            applyFilters();
        });
        
        function applyFilters() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            
            let url = '${pageContext.request.contextPath}/admin/suggestions?';
            
            if (searchTerm) {
                url += 'search=' + encodeURIComponent(searchTerm) + '&';
            }
            
            if (statusFilter) {
                url += 'status=' + encodeURIComponent(statusFilter) + '&';
            }
            
            if (typeFilter) {
                url += 'type=' + encodeURIComponent(typeFilter) + '&';
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