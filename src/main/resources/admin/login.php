<?php
session_start();

// Include database connection
include_once 'includes/db_connect.php';

$error = '';
$success = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';

    // Verify credentials
    $query = "SELECT * FROM users WHERE email = ?";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($user = mysqli_fetch_assoc($result)) {
        if (password_verify($password, $user['password'])) {
            if ($user['is_admin'] && $user['status'] === 'active') {
                // Set admin session
                $_SESSION['admin_id'] = $user['id'];
                $_SESSION['admin_name'] = $user['first_name'] . ' ' . $user['last_name'];
                $_SESSION['is_admin'] = true;

                header("Location: index.php");
                exit();
            } else {
                $error = "Admin privileges required!";
            }
        } else {
            $error = "Invalid password!";
        }
    } else {
        $error = "Account not found!";
    }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - ARA Gym</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <link href="https://unpkg.com/lucide-icons@latest/dist/umd/lucide.css" rel="stylesheet">
    <link rel="stylesheet" href="css/admin.css">
</head>

<body class="login-page">
    <div class="login-container">
        <div class="login-left">
            <div class="login-overlay"></div>
            <div class="login-content">
                <h1>ARA<span>Gym</span></h1>
                <p>Nepal's Premier Fitness Destination</p>
                <div class="gym-info">
                    <div class="info-item">
                        <i data-lucide="map-pin"></i>
                        <span>Durbar Marg, Kathmandu, Nepal</span>
                    </div>
                    <div class="info-item">
                        <i data-lucide="phone"></i>
                        <span>+977 1 4123456</span>
                    </div>
                    <div class="info-item">
                        <i data-lucide="mail"></i>
                        <span>info@aragym.com.np</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="login-right">
            <div class="login-form-container">
                <div class="login-header">
                    <h2>Admin Login</h2>
                    <p>Please login to access the admin panel</p>
                </div>

                <?php if (!empty($error)): ?>
                    <div class="alert alert-error">
                        <i data-lucide="alert-circle"></i>
                        <p><?php echo $error; ?></p>
                    </div>
                <?php endif; ?>

                <form class="login-form" method="POST" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-with-icon">
                            <i data-lucide="mail"></i>
                            <input type="email" id="email" name="email"
                                value="<?php echo isset($email) ? htmlspecialchars($email) : '' ?>"
                                placeholder="admin@example.com" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-with-icon">
                            <i data-lucide="lock"></i>
                            <input type="password" id="password" name="password" required>
                        </div>
                    </div>
                    <div class="form-group remember">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember me</label>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                    <div class="forgot-password">
                        <a href="forgot-password.php">Forgot Password?</a>
                    </div>
                </form>

                <div class="return-to-site">
                    <a href="../index.html">
                        <i data-lucide="arrow-left"></i>
                        <span>Return to Website</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/lucide@latest"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize Lucide icons
            lucide.createIcons();
        });
    </script>
</body>

</html>