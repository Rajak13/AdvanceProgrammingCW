<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .access-denied {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 60vh;
            text-align: center;
            padding: 2rem;
        }
        
        .access-denied-icon {
            font-size: 6rem;
            color: var(--accent-color);
            margin-bottom: 2rem;
        }
        
        .access-denied h1 {
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }
        
        .access-denied p {
            color: var(--light-text);
            max-width: 600px;
            margin-bottom: 2rem;
        }
        
        .btn-back {
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="/views/common/header.jsp" />
    
    <div class="access-denied">
        <div class="access-denied-icon">
            <i class="fas fa-lock"></i>
        </div>
        <h1>Access Denied</h1>
        <p>
            <c:if test="${not empty errorMessage}">
                ${errorMessage}
            </c:if>
            <c:if test="${empty errorMessage}">
                You don't have permission to access this page.
            </c:if>
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-back">Return to Home</a>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/views/common/footer.jsp" />
</body>
</html> 