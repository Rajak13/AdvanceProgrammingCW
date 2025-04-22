<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Panna BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Additional CSS if needed -->
    <c:if test="${not empty additionalCss}">
        <c:forEach var="css" items="${additionalCss}">
            <link rel="stylesheet" href="${pageContext.request.contextPath}${css}">
        </c:forEach>
    </c:if>
</head>
<body>
    <c:set var="currentPage" value="${currentPage}" scope="request" />
    <!-- Include Header -->
    <jsp:include page="/views/common/header.jsp" />
    
    <!-- Main Content -->
    <main>
        <jsp:include page="${mainContent}" />
    </main>
    
    <!-- Include Footer -->
    <jsp:include page="/views/common/footer.jsp" />
    
    <!-- Additional JavaScript if needed -->
    <c:if test="${not empty additionalJs}">
        <c:forEach var="js" items="${additionalJs}">
            <script src="${pageContext.request.contextPath}${js}"></script>
        </c:forEach>
    </c:if>
</body>
</html> 