<?php
// Start session safely
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Check admin access
if (!isset($_SESSION['admin_id'])) {
    header("Location: login.php");
    exit();
}

// Include database connection
include_once 'includes/db_connect.php';

// Initialize messages
$success_message = $_SESSION['success'] ?? '';
$error_message = $_SESSION['error'] ?? '';
unset($_SESSION['success'], $_SESSION['error']);

// Handle actions
$action = $_GET['action'] ?? '';
$payment_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

// Add Payment
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $user_id = (int)$_POST['user_id'];
        $amount = (float)$_POST['amount'];
        $payment_date = $_POST['payment_date'];
        $status = $_POST['status'];

        if ($action === 'edit') {
            $stmt = $conn->prepare("UPDATE payments SET 
                user_id = ?, amount = ?, payment_date = ?, status = ?
                WHERE id = ?");
            $stmt->bind_param("idssi", $user_id, $amount, $payment_date, $status, $payment_id);
        } else {
            $stmt = $conn->prepare("INSERT INTO payments 
                (user_id, amount, payment_date, status)
                VALUES (?, ?, ?, ?)");
            $stmt->bind_param("idss", $user_id, $amount, $payment_date, $status);
        }

        if (!$stmt->execute()) {
            throw new Exception("Database error: " . $stmt->error);
        }

        $_SESSION['success'] = "Payment " . ($action === 'edit' ? 'updated' : 'added') . " successfully!";
        header("Location: payments.php");
        exit();

    } catch (Exception $e) {
        $error_message = $e->getMessage();
    }
}

// Handle deletion
if ($action === 'delete' && $payment_id > 0) {
    try {
        $stmt = $conn->prepare("DELETE FROM payments WHERE id = ?");
        $stmt->bind_param("i", $payment_id);
        
        if (!$stmt->execute()) {
            throw new Exception("Delete failed: " . $stmt->error);
        }
        
        $_SESSION['success'] = "Payment deleted successfully!";
        header("Location: payments.php");
        exit();
        
    } catch (Exception $e) {
        $error_message = $e->getMessage();
    }
}

// Fetch payments
$payments = [];
try {
    $query = "SELECT p.*, CONCAT(u.first_name, ' ', u.last_name) AS user_name 
             FROM payments p
             JOIN users u ON p.user_id = u.id
             ORDER BY p.payment_date DESC";
    $result = $conn->query($query);
    $payments = $result->fetch_all(MYSQLI_ASSOC);
} catch (Exception $e) {
    $error_message = "Error loading payments: " . $e->getMessage();
}

// Fetch payment data for editing
$edit_data = [];
if ($action === 'edit' && $payment_id > 0) {
    $stmt = $conn->prepare("SELECT * FROM payments WHERE id = ?");
    $stmt->bind_param("i", $payment_id);
    $stmt->execute();
    $edit_data = $stmt->get_result()->fetch_assoc();
}

// Fetch users for dropdown
$users = [];
$result = $conn->query("SELECT id, CONCAT(first_name, ' ', last_name) AS name FROM users ORDER BY first_name");
if ($result) {
    $users = $result->fetch_all(MYSQLI_ASSOC);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Payments - ARA Gym</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://unpkg.com/lucide-icons@latest/dist/umd/lucide.css" rel="stylesheet">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-badge.completed { background: #c6f6d5; color: #22543d; }
        .status-badge.pending { background: #fefcbf; color: #744210; }
        .status-badge.failed { background: #fed7d7; color: #822727; }
    </style>
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
                    <li><a href="index.php"><i data-lucide="layout-dashboard"></i><span>Dashboard</span></a></li>
                    <li><a href="members.php"><i data-lucide="users"></i><span>Members</span></a></li>
                    <li><a href="trainers.php"><i data-lucide="award"></i><span>Trainers</span></a></li>
                    <li class="active"><a href="payments.php"><i data-lucide="credit-card"></i><span>Payments</span></a></li>
                    <li><a href="settings.php"><i data-lucide="settings"></i><span>Settings</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="logout.php" class="logout-btn"><i data-lucide="log-out"></i><span>Logout</span></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="topbar">
                <button class="menu-toggle"><i data-lucide="menu"></i></button>
                <div class="search-box">
                    <form action="payments.php" method="GET">
                        <i data-lucide="search"></i>
                        <input type="text" name="search" placeholder="Search payments...">
                    </form>
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
                </div>
            </header>

            <div class="content-wrapper">
                <div class="page-header">
                    <h1><?= ($action === 'add') ? 'Add New Payment' : (($action === 'edit') ? 'Edit Payment' : 'Manage Payments') ?></h1>
                    <?php if (empty($action)): ?>
                        <a href="payments.php?action=add" class="btn btn-primary">
                            <i data-lucide="plus-circle"></i> Add Payment
                        </a>
                    <?php endif; ?>
                </div>

                <?php if ($success_message): ?>
                    <div class="alert alert-success">
                        <i data-lucide="check-circle"></i>
                        <p><?= $success_message ?></p>
                    </div>
                <?php endif; ?>

                <?php if ($error_message): ?>
                    <div class="alert alert-error">
                        <i data-lucide="alert-circle"></i>
                        <p><?= $error_message ?></p>
                    </div>
                <?php endif; ?>

                <?php if ($action === 'add' || $action === 'edit'): ?>
                    <!-- Payment Form -->
                    <div class="card">
                        <div class="card-body">
                            <form method="POST">
                                <?php if ($action === 'edit'): ?>
                                    <input type="hidden" name="payment_id" value="<?= $payment_id ?>">
                                <?php endif; ?>

                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="user_id">Member *</label>
                                        <select id="user_id" name="user_id" required>
                                            <?php foreach ($users as $user): ?>
                                                <option value="<?= $user['id'] ?>" 
                                                    <?= ($edit_data['user_id'] ?? '') == $user['id'] ? 'selected' : '' ?>>
                                                    <?= htmlspecialchars($user['name']) ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="amount">Amount (Rs) *</label>
                                        <input type="number" step="0.01" id="amount" name="amount" required
                                            value="<?= $edit_data['amount'] ?? '' ?>">
                                    </div>

                                    <div class="form-group">
                                        <label for="payment_date">Date *</label>
                                        <input type="date" id="payment_date" name="payment_date" required
                                            value="<?= $edit_data['payment_date'] ?? date('Y-m-d') ?>">
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Status *</label>
                                        <select id="status" name="status" required>
                                            <option value="completed" <?= ($edit_data['status'] ?? '') === 'completed' ? 'selected' : '' ?>>Completed</option>
                                            <option value="pending" <?= ($edit_data['status'] ?? '') === 'pending' ? 'selected' : '' ?>>Pending</option>
                                            <option value="failed" <?= ($edit_data['status'] ?? '') === 'failed' ? 'selected' : '' ?>>Failed</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <a href="payments.php" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <?= $action === 'edit' ? 'Update Payment' : 'Add Payment' ?>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                <?php elseif ($action === 'delete'): ?>
                    <!-- Delete Confirmation -->
                    <div class="card">
                        <div class="card-body">
                            <div class="confirmation-message">
                                <i data-lucide="alert-triangle"></i>
                                <h3>Delete Payment Record?</h3>
                                <p>This action cannot be undone. Payment data will be permanently removed.</p>
                            </div>
                            <form method="POST">
                                <div class="form-actions">
                                    <a href="payments.php" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" name="delete_payment" class="btn btn-danger">Confirm Delete</button>
                                </div>
                            </form>
                        </div>
                    </div>
                <?php else: ?>
                    <!-- Payments List -->
                    <div class="card">
                        <div class="card-body">
                            <?php if (!empty($payments)): ?>
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Member</th>
                                                <th>Amount</th>
                                                <th>Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach ($payments as $payment): ?>
                                                <tr>
                                                    <td><?= htmlspecialchars($payment['user_name']) ?></td>
                                                    <td>Rs <?= number_format($payment['amount'], 2) ?></td>
                                                    <td><?= date('M j, Y', strtotime($payment['payment_date'])) ?></td>
                                                    <td>
                                                        <span class="status-badge <?= $payment['status'] ?>">
                                                            <?= ucfirst($payment['status']) ?>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="table-actions">
                                                            <a href="payments.php?action=edit&id=<?= $payment['id'] ?>" 
                                                               class="btn-icon" title="Edit">
                                                                <i data-lucide="edit"></i>
                                                            </a>
                                                            <a href="payments.php?action=delete&id=<?= $payment['id'] ?>" 
                                                               class="btn-icon" 
                                                               onclick="return confirm('Delete this payment record?')"
                                                               title="Delete">
                                                                <i data-lucide="trash-2"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>
                            <?php else: ?>
                                <div class="no-data">
                                    <i data-lucide="credit-card-off"></i>
                                    <p>No payment records found</p>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/lucide@latest/dist/umd/lucide.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();

            // Sidebar toggle
            document.querySelector('.menu-toggle').addEventListener('click', function() {
                document.querySelector('.sidebar').classList.toggle('active');
            });

            // Delete confirmation
            document.querySelectorAll('a[href*="action=delete"]').forEach(link => {
                link.addEventListener('click', function(e) {
                    if (!confirm('Are you sure you want to delete this payment record?')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>