<?php
session_start();

function requireLogin() {
    if (!isset($_SESSION['user_id'])) {
        $_SESSION['redirect'] = $_SERVER['REQUEST_URI'];
        header("Location: login.php");
        exit();
    }
}

function requireAdmin() {
    if (!isset($_SESSION['admin_id']) || !$_SESSION['is_admin']) {
        $_SESSION['error'] = "Admin access required";
        header("Location: login.php");
        exit();
    }
}

function isAdmin() {
    return isset($_SESSION['is_admin']) && $_SESSION['is_admin'];
}
?>