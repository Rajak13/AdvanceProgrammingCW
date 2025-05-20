<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="admin-header">
    <div class="header-left">
        <button class="sidebar-toggle">
            <i class="fas fa-bars"></i>
        </button>
        <div class="search-bar">
            <input type="text" placeholder="Search...">
            <button><i class="fas fa-search"></i></button>
        </div>
    </div>
    <div class="header-right">
        <div class="notifications">
            <i class="fas fa-bell"></i>
            <span class="badge">3</span>
        </div>
        <div class="user-menu">
            <div class="user-info">
                <c:if test="${not empty sessionScope.user}">
                    <span>${sessionScope.user.name}</span>
                    <button class="btn-logout" onclick="logout()">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </c:if>
            </div>
        </div>
    </div>
</header>

<style>
    .user-menu {
        position: relative;
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .btn-logout {
        background: none;
        border: none;
        color: #dc3545;
        cursor: pointer;
        padding: 0.5rem 1rem;
        border-radius: 4px;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
        transition: background-color 0.2s;
    }

    .btn-logout:hover {
        background-color: rgba(220, 53, 69, 0.1);
    }

    .btn-logout i {
        font-size: 1rem;
    }
</style>

<script>
    function logout() {
        if (confirm('Are you sure you want to logout?')) {
            fetch('${pageContext.request.contextPath}/auth/logout', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    window.location.href = '${pageContext.request.contextPath}/auth';
                } else {
                    throw new Error('Logout failed');
                }
            })
            .catch(error => {
                console.error('Logout error:', error);
                alert('Failed to logout. Please try again.');
            });
        }
    }
</script> 