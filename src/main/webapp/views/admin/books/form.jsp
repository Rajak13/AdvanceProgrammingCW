<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book == null ? 'Add New Book' : 'Edit Book'} - Panna BookStore Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .form-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #5D4037;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #8D6E63;
            box-shadow: 0 0 0 3px rgba(141, 110, 99, 0.1);
            outline: none;
        }
        
        .span-2 {
            grid-column: span 2;
        }
        
        .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background-color: #8D6E63;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #5D4037;
        }
        
        .btn-secondary {
            background-color: #e0e0e0;
            color: #333;
        }
        
        .btn-secondary:hover {
            background-color: #d0d0d0;
        }
        
        .image-preview-container {
            margin-top: 15px;
            border: 2px dashed #e0e0e0;
            border-radius: 6px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .image-preview-container:hover {
            border-color: #8D6E63;
        }
        
        .image-upload-label {
            display: block;
            cursor: pointer;
            padding: 15px;
            background-color: #f5f5f5;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .image-upload-label:hover {
            background-color: #e0e0e0;
        }
        
        .image-upload-label i {
            font-size: 24px;
            color: #8D6E63;
            margin-bottom: 10px;
        }
        
        .current-image {
            margin-top: 15px;
        }
        
        .current-image img {
            max-width: 200px;
            max-height: 200px;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .page-title {
            font-size: 28px;
            color: #5D4037;
            margin-bottom: 25px;
            border-bottom: 2px solid #8D6E63;
            padding-bottom: 10px;
        }
        
        #imagePreview {
            max-width: 200px;
            max-height: 200px;
            margin-top: 15px;
            border-radius: 4px;
            display: none;
        }
    </style>
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
                    <h1>${book == null ? 'Add New Book' : 'Edit Book'}</h1>
                </div>
                <div class="user-info">
                    <span>${sessionScope.user.name}</span>
                    <img src="${pageContext.request.contextPath}/images/avatar.png" alt="User Avatar">
                </div>
            </div>
            
            <div class="content">
                <div class="content-header">
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Books
                    </a>
                </div>
                
                <div class="form-container">
                    <h2 class="page-title">
                        <i class="fas fa-${book == null ? 'plus-circle' : 'edit'}"></i> 
                        ${book == null ? 'Add New Book' : 'Edit Book Details'}
                    </h2>
                    
                    <form action="${pageContext.request.contextPath}/admin/books${book == null ? '/add' : '/edit'}" 
                          method="post" 
                          enctype="multipart/form-data" 
                          class="form-grid">
                          
                        <c:if test="${book != null}">
                            <input type="hidden" name="bookId" value="${book.bookId}">
                        </c:if>
                        
                        <div class="form-group span-2">
                            <label for="bookName">Book Title</label>
                            <input type="text" id="bookName" name="bookName" class="form-control" 
                                   value="${book != null ? book.bookName : ''}" 
                                   placeholder="Enter book title" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="writerName">Author</label>
                            <input type="text" id="writerName" name="writerName" class="form-control" 
                                   value="${book != null ? book.writerName : ''}" 
                                   placeholder="Enter author name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="price">Price (₹)</label>
                            <input type="number" id="price" name="price" class="form-control" 
                                   min="0" step="0.01" value="${book != null ? book.price : ''}" 
                                   placeholder="Enter price" required>
                        </div>
                        
                        <div class="form-group span-2">
                            <label>Book Cover Image</label>
                            <div class="image-preview-container">
                                <label for="picture" class="image-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <div>Click to select image or drag and drop</div>
                                    <div><small>(Recommended size: 600x800px)</small></div>
                                </label>
                                <input type="file" id="picture" name="picture" accept="image/*" 
                                       style="display: none;" 
                                       ${book == null ? 'required' : ''}>
                                <img id="imagePreview" src="#" alt="Image preview">
                                <c:if test="${book != null && book.picture != null}">
                                    <div class="current-image">
                                        <p>Current image:</p>
                                        <img src="${pageContext.request.contextPath}${book.picture}" 
                                             alt="${book.bookName}" class="thumbnail">
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="form-group span-2">
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${book == null ? 'Add Book' : 'Update Book'}
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Sidebar toggle
        document.getElementById('toggleSidebar').addEventListener('click', function() {
            document.querySelector('.admin-container').classList.toggle('sidebar-collapsed');
        });
        
        // Image preview
        document.getElementById('picture').addEventListener('change', function(e) {
            var preview = document.getElementById('imagePreview');
            var file = e.target.files[0];
            var reader = new FileReader();
            
            reader.onloadend = function() {
                preview.src = reader.result;
                preview.style.display = 'block';
            }
            
            if (file) {
                reader.readAsDataURL(file);
            } else {
                preview.src = '';
                preview.style.display = 'none';
            }
        });
        
        // Drag and drop functionality
        var dropArea = document.querySelector('.image-preview-container');
        
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, highlight, false);
        });
        
        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, unhighlight, false);
        });
        
        function highlight() {
            dropArea.classList.add('highlight');
        }
        
        function unhighlight() {
            dropArea.classList.remove('highlight');
        }
        
        dropArea.addEventListener('drop', handleDrop, false);
        
        function handleDrop(e) {
            var dt = e.dataTransfer;
            var files = dt.files;
            var fileInput = document.getElementById('picture');
            
            fileInput.files = files;
            
            // Trigger change event manually
            var event = new Event('change');
            fileInput.dispatchEvent(event);
        }
    </script>
</body>
</html> 