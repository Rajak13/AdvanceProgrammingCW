<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty book ? 'Add New Book' : 'Edit Book'}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>${empty book ? 'Add New Book' : 'Edit Book'}</h2>
        <form action="BookServlet" method="post">
            <input type="hidden" name="action" value="${empty book ? 'create' : 'update'}">
            <c:if test="${not empty book}">
                <input type="hidden" name="id" value="${book.bookId}">
            </c:if>

            <div class="form-group">
                <label for="bookName">Book Name:</label>
                <input type="text" class="form-control" id="bookName" name="bookName" value="${book.bookName}" required>
            </div>

            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" step="0.01" class="form-control" id="price" name="price" value="${book.price}" required>
            </div>

            <div class="form-group">
                <label for="writerName">Writer Name:</label>
                <input type="text" class="form-control" id="writerName" name="writerName" value="${book.writerName}" required>
            </div>

            <div class="form-group">
                <label for="picture">Picture URL:</label>
                <input type="text" class="form-control" id="picture" name="picture" value="${book.picture}">
            </div>

            <div class="form-group">
                <label for="status">Status:</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="Available" ${book.status eq 'Available' ? 'selected' : ''}>Available</option>
                    <option value="Out of Stock" ${book.status eq 'Out of Stock' ? 'selected' : ''}>Out of Stock</option>
                </select>
            </div>

            <div class="form-group">
                <label for="stock">Stock:</label>
                <input type="number" class="form-control" id="stock" name="stock" value="${book.stock}" required>
            </div>

            <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description" rows="3">${book.description}</textarea>
            </div>

            <div class="form-group">
                <label>Categories:</label>
                <div class="row">
                    <c:forEach items="${categories}" var="category">
                        <div class="col-md-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="categories" value="${category.categoryId}"
                                    <c:if test="${not empty book.categories}">
                                        <c:forEach items="${book.categories}" var="bookCategory">
                                            ${bookCategory.categoryId eq category.categoryId ? 'checked' : ''}
                                        </c:forEach>
                                    </c:if>
                                >
                                <label class="form-check-label">
                                    ${category.categoryName}
                                </label>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <button type="submit" class="btn btn-primary">${empty book ? 'Add' : 'Update'}</button>
            <a href="BookServlet" class="btn btn-secondary">Cancel</a>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 