<?php
/**
 * Database Connection
 * 
 * Creates and manages the database connection for the application
 */

// Error reporting - should be disabled in production
// error_reporting(E_ALL);
// ini_set('display_errors', 1);

// Database connection parameters
$db_host = 'localhost';
$db_user = 'root';
$db_pass = '';
$db_name = 'aragym';

// Connection options
$mysqli_options = [
    // Report SQL errors as PHP warnings
    MYSQLI_REPORT_ERROR => true,
    // Throw mysqli_sql_exceptions for errors instead of warnings
    MYSQLI_REPORT_STRICT => true,
];

// Create database connection
try {
    $conn = mysqli_connect($db_host, $db_user, $db_pass, $db_name);
    
    // Check connection
    if (!$conn) {
        throw new Exception("Connection failed: " . mysqli_connect_error());
    }

    // Set character set
    mysqli_set_charset($conn, "utf8mb4");
    
} catch (Exception $e) {
    // Log the error (in a production environment)
    error_log("Database connection error: " . $e->getMessage());
    
    // For development, you might want to see the error
    // die("Database connection failed: " . $e->getMessage());
    
    // For production, show a user-friendly message
    die("We're experiencing technical difficulties. Please try again later.");
}

/**
 * Function to safely close the database connection
 */
function close_database_connection() {
    global $conn;
    if ($conn) {
        mysqli_close($conn);
    }
}

// Register shutdown function to close connection
register_shutdown_function('close_database_connection');
?>