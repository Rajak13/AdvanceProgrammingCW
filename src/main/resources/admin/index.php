<?php
// Start session only if not already started
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once 'includes/auth.php';
requireAdmin();

// Include database connection
include_once 'includes/db_connect.php';

// Initialize stats array with default values
$stats = [
    'total_members' => 0,
    'active_members' => 0,
    'recent_signups' => [],
    'users' => 0,
    'active_users' => 0,
    'monthly_revenue' => 0,
    'today_classes' => 0
];

try {
    // Total Members
    $query = "SELECT COUNT(*) as total FROM users";
    $result = mysqli_query($conn, $query);
    $stats['total_members'] = mysqli_fetch_assoc($result)['total'] ?? 0;
    $stats['users'] = $stats['total_members'];  // Alias for template

    // Active Members (using user_metrics table)
    $query = "SELECT COUNT(*) as total FROM user_metrics WHERE activity_level IN ('active', 'very_active')";
    $result = mysqli_query($conn, $query);
    $stats['active_members'] = mysqli_fetch_assoc($result)['total'] ?? 0;

    // Recent Signups
    $query = "SELECT * FROM users ORDER BY created_at DESC LIMIT 5";
    $result = mysqli_query($conn, $query);
    $stats['recent_signups'] = mysqli_fetch_all($result, MYSQLI_ASSOC) ?? [];

} catch (Exception $e) {
    error_log("Admin Dashboard Error: " . $e->getMessage());
    $error = "Error loading dashboard statistics";
}

// Active users (using users table status)
$query = "SELECT COUNT(*) as total FROM users WHERE status = 'active'";
$result = mysqli_query($conn, $query);
$stats['active_users'] = mysqli_fetch_assoc($result)['total'] ?? 0;

// Revenue this month
$query = "SELECT SUM(amount) as total FROM payments 
          WHERE MONTH(payment_date) = MONTH(CURRENT_DATE()) 
          AND YEAR(payment_date) = YEAR(CURRENT_DATE())";
$result = mysqli_query($conn, $query);
$stats['monthly_revenue'] = mysqli_fetch_assoc($result)['total'] ?? 0;

// Classes scheduled today (using sessions table)
$query = "SELECT COUNT(*) as total FROM sessions 
          WHERE DATE(session_date) = CURRENT_DATE()";
$result = mysqli_query($conn, $query);
$stats['today_classes'] = mysqli_fetch_assoc($result)['total'] ?? 0;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ARA Gym</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://unpkg.com/lucide-icons@latest/dist/umd/lucide.css" rel="stylesheet">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <div class="admin-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h1>ARA<span>Gym</span></h1>
                <p>Admin Panel</p>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li class="active">
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
                    <li>
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
                    <h1>Dashboard</h1>
                    <p>Welcome back, <?= htmlspecialchars($_SESSION['admin_name'] ?? 'Admin') ?>!</p>
                </div>

                <!-- Statistics Cards -->
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i data-lucide="users"></i>
                        </div>
                        <div class="stat-details">
                            <h3>Total Users</h3>
                            <p class="stat-value"><?= $stats['users'] ?></p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i data-lucide="user-check"></i>
                        </div>
                        <div class="stat-details">
                            <h3>Active Users</h3>
                            <p class="stat-value"><?= $stats['active_users'] ?></p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i data-lucide="credit-card"></i>
                        </div>
                        <div class="stat-details">
                            <h3>Monthly Revenue</h3>
                            <p class="stat-value">Rs <?= number_format($stats['monthly_revenue']) ?></p>
                        </div>
                    </div>
                </div>

                <!-- Recent Users Section -->
                <div class="dashboard-grid">
                    <div class="card recent-users">
                        <div class="card-header">
                            <h2>Recent Users</h2>
                            <a href="members.php" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Plan</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $query = "SELECT u.*, p.name as plan_name 
                                            FROM users u
                                            LEFT JOIN plans p ON u.plan_id = p.id
                                            ORDER BY u.join_date DESC LIMIT 5";
                                    $result = mysqli_query($conn, $query);
                                    while($row = mysqli_fetch_assoc($result)):
                                    ?>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="/assets/images/avatar.png" alt="User">
                                                <div>
                                                    <p><?= htmlspecialchars($row['first_name'].' '.$row['last_name']) ?></p>
                                                    <small><?= htmlspecialchars($row['phone']) ?></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><?= htmlspecialchars($row['email']) ?></td>
                                        <td><?= htmlspecialchars($row['plan_name'] ?? 'None') ?></td>
                                        <td>
                                            <span class="status status-<?= $row['status'] ?>">
                                                <?= ucfirst($row['status']) ?>
                                            </span>
                                        </td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card quick-actions">
                        <div class="card-header">
                            <h2>Quick Actions</h2>
                        </div>
                        <div class="card-body">
                            <div class="action-buttons">
                                <a href="members.php?action=add" class="action-btn">
                                    <i data-lucide="user-plus"></i>
                                    <span>Add User</span>
                                    </a>
                                <a href="payments.php?action=add" class="action-btn">
                                    <i data-lucide="credit-card"></i>
                                    <span>Record Payment</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Payments -->
                <div class="card recent-payments">
                    <div class="card-header">
                        <h2>Recent Payments</h2>
                        <a href="payments.php" class="view-all">View All</a>
                    </div>
                    <div class="card-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $query = "SELECT p.*, u.first_name, u.last_name 
                                        FROM payments p
                                        JOIN users u ON p.user_id = u.id
                                        ORDER BY p.payment_date DESC LIMIT 5";
                                $result = mysqli_query($conn, $query);
                                while($row = mysqli_fetch_assoc($result)):
                                ?>
                                <tr>
                                    <td><?= htmlspecialchars($row['first_name'].' '.$row['last_name']) ?></td>
                                    <td>Rs <?= number_format($row['amount']) ?></td>
                                    <td><?= date('M d, Y', strtotime($row['payment_date'])) ?></td>
                                    <td>
                                        <span class="status status-<?= $row['status'] ?>">
                                            <?= ucfirst($row['status']) ?>
                                        </span>
                                    </td>
                                </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/lucide@latest/dist/umd/lucide.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
            
            // Toggle sidebar
            document.querySelector('.menu-toggle').addEventListener('click', function() {
                document.querySelector('.sidebar').classList.toggle('active');
            });

            // Toggle dropdowns
            document.querySelectorAll('.notification-btn, .profile-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const dropdown = this.closest('div').querySelector('.dropdown-menu');
                    dropdown.classList.toggle('active');
                });
            });

            // Close dropdowns on click outside
            document.addEventListener('click', function() {
                document.querySelectorAll('.dropdown-menu').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
            });
        });
    </script>
</body>
</html>