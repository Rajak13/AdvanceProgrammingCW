<?php

/**
 * Function to fetch website content by section and element
 */
function get_content($section, $element, $default = '') {
    global $conn;
    
    $query = "SELECT value FROM website_content WHERE section = ? AND element = ?";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "ss", $section, $element);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    return ($result && mysqli_num_rows($result) > 0) 
        ? mysqli_fetch_assoc($result)['value'] 
        : $default;
}

/**
 * Function to fetch all classes for the website
 */
function get_classes() {
    global $conn;
    
    $classes = [];
    $query = "SELECT * FROM classes_content ORDER BY id";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    while ($row = mysqli_fetch_assoc($result)) {
        $classes[] = $row;
    }
    
    return $classes;
}

/**
 * Function to fetch all trainers for the website
 */
function get_trainers() {
    global $conn;
    
    $trainers = [];
    $query = "SELECT * FROM trainers ORDER BY id";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    while ($row = mysqli_fetch_assoc($result)) {
        $trainers[] = $row;
    }
    
    return $trainers;
}

/**
 * Function to fetch all membership plans for the website
 */
function get_plans() {
    global $conn;
    
    $plans = [];
    $query = "SELECT * FROM plans WHERE status = 'active' ORDER BY price";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    while ($row = mysqli_fetch_assoc($result)) {
        $plans[] = $row;
    }
    
    return $plans;
}

/**
 * Function to handle user registration
 */
function register_user($user_data) {
    global $conn;
    
    // Check if email exists
    $check_query = "SELECT id FROM users WHERE email = ?";
    $check_stmt = mysqli_prepare($conn, $check_query);
    mysqli_stmt_bind_param($check_stmt, "s", $user_data['email']);
    mysqli_stmt_execute($check_stmt);
    
    if(mysqli_num_rows(mysqli_stmt_get_result($check_stmt)) > 0) {
        return false;
    }

    // Insert new user
    $query = "INSERT INTO users (
                first_name, 
                last_name, 
                email, 
                phone, 
                password,
                plan_id,
                status,
                join_date
              ) VALUES (?, ?, ?, ?, ?, ?, 'pending', CURDATE())";
    
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "sssssi",
        $user_data['first_name'],
        $user_data['last_name'],
        $user_data['email'],
        $user_data['phone'],
        password_hash($user_data['password'], PASSWORD_DEFAULT),
        $user_data['plan_id']
    );
    
    return mysqli_stmt_execute($stmt) ? mysqli_insert_id($conn) : false;
}

/**
 * Get user profile by ID
 */
function get_user_profile($user_id) {
    global $conn;
    
    $query = "SELECT 
                u.*, 
                p.name as plan_name, 
                p.price as plan_price 
              FROM users u
              LEFT JOIN plans p ON u.plan_id = p.id
              WHERE u.id = ?";
              
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "i", $user_id);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    return ($result && mysqli_num_rows($result) > 0)
        ? mysqli_fetch_assoc($result)
        : false;
}

/**
 * Function to handle contact form submission
 */
function submit_contact_form($name, $email, $subject, $message) {
    global $conn;
    
    $query = "INSERT INTO contact_submissions (name, email, subject, message) 
              VALUES (?, ?, ?, ?)";
    
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "ssss", $name, $email, $subject, $message);
    return mysqli_stmt_execute($stmt);
}

/**
 * Function to handle newsletter signup
 */
function newsletter_signup($email) {
    global $conn;
    
    $check_query = "SELECT id FROM newsletter_subscribers WHERE email = ?";
    $check_stmt = mysqli_prepare($conn, $check_query);
    mysqli_stmt_bind_param($check_stmt, "s", $email);
    mysqli_stmt_execute($check_stmt);
    
    if(mysqli_num_rows(mysqli_stmt_get_result($check_stmt)) > 0) {
        return false;
    }
    
    $query = "INSERT INTO newsletter_subscribers (email, signup_date) VALUES (?, NOW())";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "s", $email);
    
    return mysqli_stmt_execute($stmt);
}

/**
 * Function to log system activities
 */
function log_activity($action, $description, $user_id = 0) {
    global $conn;
    
    $query = "INSERT INTO activity_logs (action, description, user_id, ip_address) 
              VALUES (?, ?, ?, ?)";
    
    $ip = $_SERVER['REMOTE_ADDR'];
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "ssis", $action, $description, $user_id, $ip);
    
    return mysqli_stmt_execute($stmt);
}

/**
 * Check database connection status
 */
function is_db_connected() {
    global $conn;
    return ($conn && mysqli_ping($conn));
}

/**
 * Function to fetch testimonials
 */
function get_testimonials($limit = 0) {
    global $conn;
    
    $query = "SELECT * FROM testimonials WHERE status = 'active' ORDER BY id";
    if ($limit > 0) $query .= " LIMIT ?";
    
    $stmt = mysqli_prepare($conn, $query);
    if ($limit > 0) mysqli_stmt_bind_param($stmt, "i", $limit);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    $testimonials = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $testimonials[] = $row;
    }
    
    return $testimonials;
}