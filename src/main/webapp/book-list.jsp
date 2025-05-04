<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book List</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>Book List</h2>
        <a href="BookServlet?action=new" class="btn btn-primary mb-3">Add New Book</a>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Writer</th>
                    <th>Status</th>
                    <th>Stock</th>
                    <th>Categories</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${books}" var="book">
                    <tr>
                        <td>${book.bookId}</td>
                        <td>${book.bookName}</td>
                        <td>$${book.price}</td>
                        <td>${book.writerName}</td>
                        <td>${book.status}</td>
                        <td>${book.stock}</td>
                        <td>
                            <c:forEach items="${book.categories}" var="category" varStatus="loop">
                                ${category.categoryName}${!loop.last ? ', ' : ''}
                            </c:forEach>
                        </td>
                        <td>
                            <a href="BookServlet?action=edit&id=${book.bookId}" class="btn btn-warning btn-sm">Edit</a>
                            <a href="BookServlet?action=delete&id=${book.bookId}" class="btn btn-danger btn-sm" 
                               onclick="return confirm('Are you sure you want to delete this book?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 