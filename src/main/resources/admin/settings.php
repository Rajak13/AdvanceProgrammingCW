<?php
// Start session
session_start();

// Check if user is logged in as admin
if (!isset($_SESSION['admin_id'])) {
    header("Location: login.php");
    exit();
}

// Include database connection
include_once 'includes/db_connect.php';

// Initialize variables
$success_message = '';
$error_message = '';

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Sanitize and validate input
    $site_title = mysqli_real_escape_string($conn, $_POST['site_title']);
    $contact_email = mysqli_real_escape_string($conn, $_POST['contact_email']);
    $contact_phone = mysqli_real_escape_string($conn, $_POST['contact_phone']);
    $facebook_url = mysqli_real_escape_string($conn, $_POST['facebook_url']);
    $twitter_url = mysqli_real_escape_string($conn, $_POST['twitter_url']);
    $instagram_url = mysqli_real_escape_string($conn, $_POST['instagram_url']);
    $opening_hours = mysqli_real_escape_string($conn, $_POST['opening_hours']);

    try {
        // Update settings in database
        $query = "UPDATE site_settings SET 
                site_title = '$site_title',
                contact_email = '$contact_email',
                contact_phone = '$contact_phone',
                facebook_url = '$facebook_url',
                twitter_url = '$twitter_url',
                instagram_url = '$instagram_url',
                opening_hours = '$opening_hours'
                WHERE id = 1";

        if (mysqli_query($conn, $query)) {
            $success_message = "Settings updated successfully!";
        } else {
            throw new Exception("Error updating settings: " . mysqli_error($conn));
        }
    } catch (Exception $e) {
        $error_message = $e->getMessage();
    }
}

// Fetch current settings
$settings = array();
$query = "SELECT * FROM site_settings WHERE id = 1";
$result = mysqli_query($conn, $query);
if ($result && mysqli_num_rows($result) > 0) {
    $settings = mysqli_fetch_assoc($result);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - ARA Gym Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <link href="https://unpkg.com/lucide-icons@latest/dist/umd/lucide.css" rel="stylesheet">
    <!-- Include Lucide CSS -->
    <link href="https://cdn.jsdelivr.net/npm/lucide@latest/dist/lucide.css" rel="stylesheet">

    <link rel="stylesheet" href="css/admin.css">
</head>

<body>
    <div class="admin-wrapper">
        <!-- Sidebar (Same as other pages) -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h1>ARA<span>Gym</span></h1>
                <p>Admin Panel</p>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li>
                        <a href="index.php">
                            <i data-lucide="layout-dashboard"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="members.php">
                            <i data-lucide="users"></i>
                            <span>Members</span>
                        </a>
                    </li>
                    <li>
                        <a href="trainers.php">
                            <i data-lucide="award"></i>
                            <span>Trainers</span>
                        </a>
                    </li>
                    <li>
                        <a href="payments.php">
                            <i data-lucide="credit-card"></i>
                            <span>Payments</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="settings.php">
                            <i data-lucide="settings"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="logout.php" class="logout-btn">
                    <i data-lucide="log-out"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>


        <!-- Main Content -->
        <main class="main-content">
            <header class="topbar">
                <button class="menu-toggle">
                    <i data-lucide="menu"></i>
                </button>
                <div class="search-box">
                    <i data-lucide="search"></i>
                    <input type="text" placeholder="Search...">
                </div>
                <div class="topbar-right">
                    <div class="notifications">
                        <button class="notification-btn">
                            <i data-lucide="bell"></i>
                            <span class="badge">3</span>
                        </button>
                        <div class="dropdown-menu">
                            <div class="dropdown-header">
                                <h3>Notifications</h3>
                                <a href="#">Mark all as read</a>
                            </div>
                            <ul class="notification-list">
                                <li>
                                    <a href="#">
                                        <div class="notification-icon">
                                            <i data-lucide="user-plus"></i>
                                        </div>
                                        <div class="notification-content">
                                            <p>New user registered</p>
                                            <span>15 minutes ago</span>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <div class="notification-icon">
                                            <i data-lucide="credit-card"></i>
                                        </div>
                                        <div class="notification-content">
                                            <p>New payment received</p>
                                            <span>1 hour ago</span>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                            <div class="dropdown-footer">
                                <a href="notifications.php">View all</a>
                            </div>
                        </div>
                    </div>
                    <div class="admin-profile">
                        <button class="profile-btn">
                            <img src="/assets/images/avatar.png" alt="Admin">
                            <span><?= htmlspecialchars($_SESSION['admin_name'] ?? 'Admin') ?></span>
                            <i data-lucide="chevron-down"></i>
                        </button>
                        <div class="dropdown-menu">
                            <ul>
                                <li>
                                    <a href="settings.php">
                                        <i data-lucide="settings"></i>
                                        <span>Settings</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="logout.php">
                                        <i data-lucide="log-out"></i>
                                        <span>Logout</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </header>

            <div class="content-wrapper">
                <div class="page-header">
                    <h1>Website Settings</h1>
                    <p>Manage general website settings and configurations</p>
                </div>

                <?php if (!empty($success_message)): ?>
                    <div class="alert alert-success">
                        <i data-lucide="check-circle"></i>
                        <p><?php echo $success_message; ?></p>
                    </div>
                <?php endif; ?>

                <?php if (!empty($error_message)): ?>
                    <div class="alert alert-error">
                        <i data-lucide="alert-circle"></i>
                        <p><?php echo $error_message; ?></p>
                    </div>
                <?php endif; ?>

                <div class="card">
                    <div class="card-header">
                        <h2>General Settings</h2>
                    </div>
                    <div class="card-body">
                        <form action="settings.php" method="POST" class="form">
                            <div class="form-group">
                                <label for="site_title">Website Title</label>
                                <input type="text" id="site_title" name="site_title"
                                    value="<?php echo htmlspecialchars($settings['site_title'] ?? 'ARA Gym'); ?>"
                                    required>
                            </div>

                            <div class="form-group">
                                <label for="contact_email">Contact Email</label>
                                <input type="email" id="contact_email" name="contact_email"
                                    value="<?php echo htmlspecialchars($settings['contact_email'] ?? ''); ?>" required>
                            </div>

                            <div class="form-group">
                                <label for="contact_phone">Contact Phone</label>
                                <input type="tel" id="contact_phone" name="contact_phone"
                                    value="<?php echo htmlspecialchars($settings['contact_phone'] ?? ''); ?>" required>
                            </div>

                            <div class="form-group">
                                <label for="opening_hours">Opening Hours</label>
                                <textarea id="opening_hours" name="opening_hours" rows="3"><?php
                                echo htmlspecialchars($settings['opening_hours'] ?? 'Mon-Fri: 6:00 AM - 10:00 PM\nSat-Sun: 8:00 AM - 8:00 PM');
                                ?></textarea>
                            </div>

                            <div class="form-group">
                                <label for="facebook_url">Facebook URL</label>
                                <input type="url" id="facebook_url" name="facebook_url"
                                    value="<?php echo htmlspecialchars($settings['facebook_url'] ?? ''); ?>">
                            </div>

                            <div class="form-group">
                                <label for="twitter_url">Twitter URL</label>
                                <input type="url" id="twitter_url" name="twitter_url"
                                    value="<?php echo htmlspecialchars($settings['twitter_url'] ?? ''); ?>">
                            </div>

                            <div class="form-group">
                                <label for="instagram_url">Instagram URL</label>
                                <input type="url" id="instagram_url" name="instagram_url"
                                    value="<?php echo htmlspecialchars($settings['instagram_url'] ?? ''); ?>">
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
    


    <!-- Include Lucide JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/lucide@latest/dist/umd/lucide.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            lucide.createIcons();

            // Toggle sidebar
            document.querySelector('.menu-toggle').addEventListener('click', function () {
                document.querySelector('.sidebar').classList.toggle('active');
            });

            // Toggle dropdowns
            document.querySelectorAll('.notification-btn, .profile-btn').forEach(btn => {
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    const dropdown = this.closest('div').querySelector('.dropdown-menu');
                    dropdown.classList.toggle('active');
                });
            });

            // Close dropdowns on click outside
            document.addEventListener('click', function () {
                document.querySelectorAll('.dropdown-menu').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
            });
        });
    </script>
</body>

</html>