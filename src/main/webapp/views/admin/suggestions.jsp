<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Book Suggestions" />
<c:set var="currentPage" value="suggestions" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/jquery.dataTables.min.css">
</head>
<body>
    <div class="admin-container">
        <jsp:include page="common/sidebar.jsp" />
        
        <main class="admin-main">
            <jsp:include page="common/header.jsp" />

            <div class="dashboard-content">
                <div class="content-header">
                    <h2>Book Suggestions</h2>
                </div>

                <div class="filter-section">
                    <select id="statusFilter" onchange="filterSuggestions()">
                        <option value="all">All Status</option>
                        <option value="Pending">Pending</option>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div>

                <div class="suggestions-table">
                    <table>
                        <thead>
                            <tr>
                            	<th>Suggestion ID</th>
                                <th>Book Title</th>
                                <th>Author</th>
                                <th>Category</th>
                                <th>Suggested By</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="suggestion" items="${suggestions}">
                                <tr>
                                    <td>${suggestion.suggestionId}</td>
                                    <td>${suggestion.title}</td>
                                    <td>${suggestion.author}</td>
                                    <td>${suggestion.category}</td>
                                    <td>${suggestion.userId}</td>
                                    <td><fmt:formatDate value="${suggestion.date}" pattern="MMM dd, yyyy"/></td>
                                    <td>
                                        <span class="status-badge status-${fn:toLowerCase(suggestion.status)}">
                                            ${suggestion.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Update Status Modal -->
    <div id="updateModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Update Suggestion Status</h3>
                <button class="close-modal" onclick="closeModal('updateModal')">&times;</button>
            </div>
            <form id="updateStatusForm" action="${pageContext.request.contextPath}/suggestions/update" method="post">
                <input type="hidden" id="suggestionId" name="suggestionId">
                
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="Pending">Pending</option>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary">Update Status</button>
            </form>
        </div>
    </div>

    <!-- View Details Modal -->
    <div id="detailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Suggestion Details</h3>
                <button class="close-modal" onclick="closeModal('detailsModal')">&times;</button>
            </div>
            <div id="suggestionDetails">
                <!-- Details will be loaded dynamically -->
            </div>
        </div>
    </div>

    <style>
        .filter-section {
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .filter-section select {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            background: var(--white);
        }

        .suggestions-table {
            width: 100%;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .suggestions-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .suggestions-table th,
        .suggestions-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .suggestions-table th {
            background: var(--primary-dark);
            color: var(--white);
            font-weight: 500;
        }

        .suggestions-table tr:hover {
            background: var(--light-bg);
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-pending {
            background: #FFF3E0;
            color: #E65100;
        }

        .status-approved {
            background: #E8F5E9;
            color: #2E7D32;
        }

        .status-rejected {
            background: #FFEBEE;
            color: #C62828;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-primary {
            background: var(--accent-color);
            color: var(--white);
        }

        .btn-primary:hover {
            background: #E64A19;
        }

        .btn-secondary {
            background: var(--primary-dark);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: #1A237E;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal-content {
            position: relative;
            background: var(--white);
            width: 90%;
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .modal-header h3 {
            color: var(--primary-dark);
            margin: 0;
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--light-text);
            cursor: pointer;
            padding: 0.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--primary-dark);
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
            outline: none;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 2rem;
            border-radius: var(--border-radius);
            color: var(--white);
            font-weight: 500;
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
        }

        .notification.success {
            background: #4CAF50;
        }

        .notification.error {
            background: #f44336;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <div class="filter-section">
        <select id="statusFilter" onchange="filterSuggestions()">
            <option value="all">All Status</option>
            <option value="Pending">Pending</option>
            <option value="Approved">Approved</option>
            <option value="Rejected">Rejected</option>
        </select>
    </div>

    <div class="suggestions-table">
        <table>
            <thead>
                <tr>
                    <th>Book Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Suggested By</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="suggestion" items="${suggestions}">
                    <tr>
                        <td>${suggestion.suggestionId}</td>
                        <td>${suggestion.title}</td>
                        <td>${suggestion.author}</td>
                        <td>${suggestion.category}</td>
                        <td>${suggestion.userId}</td>
                        <td><fmt:formatDate value="${suggestion.date}" pattern="MMM dd, yyyy"/></td>
                        <td>
                            <span class="status-badge status-${fn:toLowerCase(suggestion.status)}">
                                ${suggestion.status}
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-view" onclick="viewSuggestion('${suggestion.suggestionId}')">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn-edit" onclick="editSuggestion('${suggestion.suggestionId}')">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn-delete" onclick="deleteSuggestion('${suggestion.suggestionId}')">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Update Status Modal -->
<div id="updateModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Update Suggestion Status</h3>
            <button class="close-modal" onclick="closeModal('updateModal')">&times;</button>
        </div>
        <form id="updateStatusForm" action="${pageContext.request.contextPath}/suggestions/update" method="post">
            <input type="hidden" id="suggestionId" name="suggestionId">
            
            <div class="form-group">
                <label for="status">Status</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="Pending">Pending</option>
                    <option value="Approved">Approved</option>
                    <option value="Rejected">Rejected</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Update Status</button>
        </form>
    </div>
</div>

<!-- View Details Modal -->
<div id="detailsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Suggestion Details</h3>
            <button class="close-modal" onclick="closeModal('detailsModal')">&times;</button>
        </div>
        <div id="suggestionDetails">
            <!-- Details will be loaded dynamically -->
        </div>
    </div>
</div>

<style>
    .filter-section {
        margin-bottom: 2rem;
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .filter-section select {
        padding: 0.5rem;
        border: 1px solid #ddd;
        border-radius: var(--border-radius);
        background: var(--white);
    }

    .suggestions-table {
        width: 100%;
        background: var(--white);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        overflow: hidden;
    }

    .suggestions-table table {
        width: 100%;
        border-collapse: collapse;
    }

    .suggestions-table th,
    .suggestions-table td {
        padding: 1rem;
        text-align: left;
        border-bottom: 1px solid #eee;
    }

    .suggestions-table th {
        background: var(--primary-dark);
        color: var(--white);
        font-weight: 500;
    }

    .suggestions-table tr:hover {
        background: var(--light-bg);
    }

    .status-badge {
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.875rem;
        font-weight: 500;
    }

    .status-pending {
        background: #FFF3E0;
        color: #E65100;
    }

    .status-approved {
        background: #E8F5E9;
        color: #2E7D32;
    }

    .status-rejected {
        background: #FFEBEE;
        color: #C62828;
    }

    .action-buttons {
        display: flex;
        gap: 0.5rem;
    }

    .btn {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: var(--border-radius);
        font-weight: 500;
        cursor: pointer;
        transition: var(--transition);
    }

    .btn-primary {
        background: var(--accent-color);
        color: var(--white);
    }

    .btn-primary:hover {
        background: #E64A19;
    }

    .btn-secondary {
        background: var(--primary-dark);
        color: var(--white);
    }

    .btn-secondary:hover {
        background: #1A237E;
    }

    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1000;
    }

    .modal-content {
        position: relative;
        background: var(--white);
        width: 90%;
        max-width: 600px;
        margin: 2rem auto;
        padding: 2rem;
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
    }

    .modal-header h3 {
        color: var(--primary-dark);
        margin: 0;
    }

    .close-modal {
        background: none;
        border: none;
        font-size: 1.5rem;
        color: var(--light-text);
        cursor: pointer;
        padding: 0.5rem;
    }

    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        color: var(--primary-dark);
        font-weight: 500;
    }

    .form-control {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid #ddd;
        border-radius: var(--border-radius);
        transition: var(--transition);
    }

    .form-control:focus {
        border-color: var(--accent-color);
        box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.1);
        outline: none;
    }

    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem 2rem;
        border-radius: var(--border-radius);
        color: var(--white);
        font-weight: 500;
        z-index: 1000;
        animation: slideIn 0.3s ease-out;
    }

    .notification.success {
        background: #4CAF50;
    }

    .notification.error {
        background: #f44336;
    }

    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
</style>

<script>
    // Filter suggestions by status
    function filterSuggestions() {
        const status = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('.suggestions-table tbody tr');
        
        rows.forEach(row => {
            if (status === 'all' || row.dataset.status === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Open update modal
    function openUpdateModal(suggestionId) {
        const modal = document.getElementById('updateModal');
        const form = document.getElementById('updateStatusForm');
        const suggestionIdInput = document.getElementById('suggestionId');
        
        suggestionIdInput.value = suggestionId;
        modal.style.display = 'block';
    }

    // View suggestion details
    function viewDetails(suggestionId) {
        const modal = document.getElementById('detailsModal');
        const detailsContainer = document.getElementById('suggestionDetails');
        
        // Fetch suggestion details
        fetch(`${pageContext.request.contextPath}/suggestions/${suggestionId}`)
            .then(response => response.json())
            .then(data => {
                detailsContainer.innerHTML = `
                    <div class="form-group">
                        <label>Book Title</label>
                        <p>${data.title}</p>
                    </div>
                    <div class="form-group">
                        <label>Author</label>
                        <p>${data.author}</p>
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <p>${data.category}</p>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <p>${data.description}</p>
                    </div>
                    <div class="form-group">
                        <label>Suggested By</label>
                        <p>${data.userName}</p>
                    </div>
                    <div class="form-group">
                        <label>Date</label>
                        <p>${data.date}</p>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <p><span class="status-badge status-${data.status.toLowerCase()}">${data.status}</span></p>
                    </div>
                `;
                modal.style.display = 'block';
            })
            .catch(error => {
                showNotification('Error loading suggestion details', 'error');
            });
    }

    // Close modal
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Form submission handler
    document.getElementById('updateStatusForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        
        fetch('${pageContext.request.contextPath}/suggestions/update', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Failed to update status');
        })
        .then(data => {
            showNotification(data.message, 'success');
            closeModal('updateModal');
            // Reload the page to show updated status
            setTimeout(() => window.location.reload(), 1500);
        })
        .catch(error => {
            showNotification(error.message, 'error');
        });
    });

    // Notification function
    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transition = 'opacity 0.3s ease-in-out';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>

<jsp:include page="common/admin_footer.jsp" /> 