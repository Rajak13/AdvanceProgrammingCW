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
$success_message = $_SESSION['success_message'] ?? '';
$error_message = $_SESSION['error_message'] ?? '';
unset($_SESSION['success_message'], $_SESSION['error_message']); // Clear messages after displaying

// Action handling
$action = $_GET['action'] ?? '';
$member_id = isset($_GET['id']) ? (int) $_GET['id'] : 0;

// Handle form submissions
// In your form handling section, replace the try-catch block with this:

try {
    if (isset($_POST['add_member']) || isset($_POST['update_member'])) {
        // Validate required fields first
        $required = ['first_name', 'last_name', 'email', 'phone', 'plan_id', 'status'];
        foreach ($required as $field) {
            if (empty($_POST[$field])) {
                throw new Exception("Required field '$field' is missing!");
            }
        }

        // Prepare base query
        if (isset($_POST['add_member'])) {
            $query = "INSERT INTO users (
                    first_name, last_name, email, phone, gender, 
                    dob, plan_id, status, emergency_contact, health_issues, join_date
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        } else {
            $query = "UPDATE users SET 
                    first_name = ?, last_name = ?, email = ?, phone = ?, 
                    gender = ?, dob = ?, plan_id = ?, status = ?, 
                    emergency_contact = ?, health_issues = ?
                    WHERE id = ?";
        }

        // Prepare statement
        $stmt = $conn->prepare($query);
        if (!$stmt) {
            throw new Exception("Prepare failed: " . $conn->error);
        }

        // Bind parameters
        $params = [
            $_POST['first_name'],
            $_POST['last_name'],
            $_POST['email'],
            $_POST['phone'],
            $_POST['gender'] ?? 'Other',
            $_POST['dob'] ?? null,
            $_POST['plan_id'],
            $_POST['status'],
            $_POST['emergency_contact'] ?? '',
            $_POST['health_issues'] ?? ''
        ];

        if (isset($_POST['update_member'])) {
            $params[] = $_POST['member_id'];
        }

        // Dynamically build type string
        $types = str_repeat('s', count($params));
        $stmt->bind_param($types, ...$params);

        // Execute
        if (!$stmt->execute()) {
            throw new Exception("Execution failed: " . $stmt->error);
        }

        $_SESSION['success_message'] = "Member " . (isset($_POST['add_member']) ? 'added' : 'updated') . " successfully!";
        header("Location: members.php");
        exit();
    }
} catch (Exception $e) {
    $_SESSION['error_message'] = $e->getMessage();
    header("Location: members.php");
    exit();
}
// Handle member deletion
if (isset($_POST['delete_member'])) {
    try {
        $member_id = (int) $_POST['member_id'];
        $stmt = $conn->prepare("DELETE FROM users WHERE id = ?");
        $stmt->bind_param("i", $member_id);

        if ($stmt->execute()) {
            $_SESSION['success_message'] = "Member deleted successfully!";
            header("Location: members.php");
            exit();
        } else {
            throw new Exception("Delete failed: " . $stmt->error);
        }
    } catch (Exception $e) {
        $_SESSION['error_message'] = $e->getMessage();
        header("Location: members.php");
        exit();
    }
}

// Fetch member data if editing
$member_data = [];
if ($action == 'edit' && $member_id > 0) {
    try {
        $stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $member_data = $result->fetch_assoc();

        if (!$member_data) {
            throw new Exception("Member not found!");
        }
    } catch (Exception $e) {
        $error_message = $e->getMessage();
        $action = '';
    }
}

// Fetch membership plans
$plans = [];
$query = "SELECT id, name, price FROM plans WHERE status = 'active' ORDER BY price";
$result = mysqli_query($conn, $query);

if (!$result) {
    $error_message = "Error loading plans: " . mysqli_error($conn);
} else {
    while ($row = mysqli_fetch_assoc($result)) {
        $plans[] = $row;
    }
}

// Pagination and search
$page = max(1, (int) ($_GET['page'] ?? 1));
$per_page = 10;
$offset = ($page - 1) * $per_page;
$search = $conn->real_escape_string($_GET['search'] ?? '');
$search_condition = $search ?
    "WHERE CONCAT(first_name, ' ', last_name) LIKE '%$search%' 
    OR email LIKE '%$search%' 
    OR phone LIKE '%$search%'" : '';

// Get total members
$count_result = $conn->query("SELECT COUNT(*) AS total FROM users $search_condition");
$total_members = $count_result->fetch_assoc()['total'] ?? 0;
$total_pages = ceil($total_members / $per_page);

// Get paginated members
try {
    $members_result = $conn->query(
        "SELECT u.*, p.name AS plan_name 
        FROM users u
        LEFT JOIN plans p ON u.plan_id = p.id
        $search_condition
        ORDER BY u.join_date DESC
        LIMIT $offset, $per_page"
    );
    $members = $members_result->fetch_all(MYSQLI_ASSOC);
} catch (Exception $e) {
    $error_message = "Error loading members: " . $e->getMessage();
    $members = [];
}
?>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Members - ARA Gym</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
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
                    <li>
                        <a href="index.php">
                            <i data-lucide="layout-dashboard"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="active">
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
                    <form action="members.php" method="GET">
                        <i data-lucide="search"></i>
                        <input type="text" name="search" value="<?php echo htmlspecialchars($search); ?>"
                            placeholder="Search members...">
                        <button type="submit" class="search-btn">Search</button>
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
                                            <p>New member registered</p>
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
                                <li>
                                    <a href="#">
                                        <div class="notification-icon">
                                            <i data-lucide="alert-triangle"></i>
                                        </div>
                                        <div class="notification-content">
                                            <p>Server load high</p>
                                            <span>2 hours ago</span>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                            <div class="dropdown-footer">
                                <a href="notifications.php">View all notifications</a>
                            </div>
                        </div>
                    </div>
                    <div class="admin-profile">
                        <button class="profile-btn">
                            <img src="/placeholder.svg?height=40&width=40" alt="Admin">
                            <span><?php echo $_SESSION['admin_name']; ?></span>
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
                    <h1><?php echo ($action == 'add') ? 'Add New Member' : (($action == 'edit') ? 'Edit Member' : 'Manage Members'); ?>
                    </h1>
                    <?php if (empty($action)): ?>
                        <a href="members.php?action=add" class="btn btn-primary">
                            <i data-lucide="user-plus"></i>
                            Add New Member
                        </a>
                    <?php endif; ?>
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

                <?php if ($action == 'add' || $action == 'edit'): ?>
                    <!-- Add/Edit Member Form -->
                    <div class="card">
                        <div class="card-body">
                            <form action="members.php" method="POST" class="form">
                                <?php if ($action == 'edit'): ?>
                                    <input type="hidden" name="member_id" value="<?php echo $member_id ?>">
                                <?php endif; ?>

                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="first_name">First Name <span class="required">*</span></label>
                                        <input type="text" id="first_name" name="first_name"
                                            value="<?= htmlspecialchars($member_data['first_name'] ?? '') ?>" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="last_name">Last Name <span class="required">*</span></label>
                                        <input type="text" id="last_name" name="last_name"
                                            value="<?= htmlspecialchars($member_data['last_name'] ?? '') ?>" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email <span class="required">*</span></label>
                                        <input type="email" id="email" name="email"
                                            value="<?php echo isset($member_data['email']) ? htmlspecialchars($member_data['email']) : ''; ?>"
                                            required>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Phone <span class="required">*</span></label>
                                        <input type="text" id="phone" name="phone"
                                            value="<?php echo isset($member_data['phone']) ? htmlspecialchars($member_data['phone']) : ''; ?>"
                                            required>
                                    </div>


                                    <div class="form-group">
                                        <label for="gender">Gender</label>
                                        <select id="gender" name="gender">
                                            <option value="Male" <?php echo (isset($member_data['gender']) && $member_data['gender'] == 'Male') ? 'selected' : ''; ?>>Male</option>
                                            <option value="Female" <?php echo (isset($member_data['gender']) && $member_data['gender'] == 'Female') ? 'selected' : ''; ?>>Female</option>
                                            <option value="Other" <?php echo (isset($member_data['gender']) && $member_data['gender'] == 'Other') ? 'selected' : ''; ?>>Other</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="dob">Date of Birth</label>
                                        <input type="date" id="dob" name="dob"
                                            value="<?php echo isset($member_data['dob']) ? htmlspecialchars($member_data['dob']) : ''; ?>">
                                    </div>

                                    <div class="form-group">
                                        <label for="plan_id">Membership Plan <span class="required">*</span></label>
                                        <?php if (!empty($plans)): ?>
                                            <select id="plan_id" name="plan_id" required>
                                                <option value="">Select a plan</option>
                                                <?php foreach ($plans as $plan): ?>
                                                    <option value="<?= $plan['id'] ?>" <?= (isset($member_data['plan_id']) && $member_data['plan_id'] == $plan['id']) ? 'selected' : '' ?>>
                                                        <?= htmlspecialchars($plan['name']) ?> - Rs
                                                        <?= number_format($plan['price']) ?>
                                                    </option>
                                                <?php endforeach; ?>
                                            </select>
                                        <?php else: ?>
                                            <div class="alert alert-warning">
                                                <i data-lucide="alert-triangle"></i>
                                                No active plans available
                                            </div>
                                        <?php endif; ?>
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Status <span class="required">*</span></label>
                                        <select id="status" name="status" required>
                                            <option value="active" <?php echo (isset($member_data['status']) && $member_data['status'] == 'active') ? 'selected' : ''; ?>>Active</option>
                                            <option value="inactive" <?php echo (isset($member_data['status']) && $member_data['status'] == 'inactive') ? 'selected' : ''; ?>>Inactive</option>
                                            <option value="pending" <?php echo (isset($member_data['status']) && $member_data['status'] == 'pending') ? 'selected' : ''; ?>>Pending</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="emergency_contact">Emergency Contact</label>
                                        <input type="text" id="emergency_contact" name="emergency_contact"
                                            value="<?php echo isset($member_data['emergency_contact']) ? htmlspecialchars($member_data['emergency_contact']) : ''; ?>">
                                    </div>

                                    <div class="form-group full-width">
                                        <label for="health_issues">Health Issues / Notes</label>
                                        <textarea id="health_issues"
                                            name="health_issues"><?php echo isset($member_data['health_issues']) ? htmlspecialchars($member_data['health_issues']) : ''; ?></textarea>
                                    </div>

                                    <div class="form-group">
                                        <label for="join_date">Join Date</label>
                                        <input type="date" id="join_date" name="join_date"
                                            value="<?php echo isset($member_data['join_date']) ? htmlspecialchars($member_data['join_date']) : ''; ?>">
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <a href="members.php" class="btn btn-secondary">Cancel</a>
                                    <?php if ($action == 'add'): ?>
                                        <button type="submit" name="add_member" class="btn btn-primary">Add Member</button>
                                    <?php else: ?>
                                        <button type="submit" name="update_member" class="btn btn-primary">Update
                                            Member</button>
                                    <?php endif; ?>
                                </div>
                            </form>
                        </div>
                    </div>
                <?php elseif ($action == 'delete'): ?>
                    <!-- Delete Confirmation -->
                    <div class="card">
                        <div class="card-body">
                            <div class="confirmation-message">
                                <i data-lucide="alert-triangle"></i>
                                <h3>Are you sure you want to delete this member?</h3>
                                <p>This action cannot be undone. All associated data will be permanently removed.</p>
                            </div>
                            <form action="members.php" method="POST">
                                <input type="hidden" name="member_id" value="<?php echo $member_id; ?>">
                                <div class="form-actions">
                                    <a href="members.php" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" name="delete_member" class="btn btn-danger">Delete Member</button>
                                </div>
                            </form>
                        </div>
                    </div>
                <?php else: ?>
                    <!-- Members List -->
                    <div class="card">
                        <div class="card-body">
                            <?php if (mysqli_num_rows($members_result) > 0): ?>
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Phone</th>
                                                <th>Plan</th>
                                                <th>Join Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach ($members as $member): ?>
                                                <tr>
                                                    <td><?= $member['id'] ?></td>
                                                    <td><?= htmlspecialchars($member['first_name'] . ' ' . $member['last_name']) ?>
                                                    </td>
                                                    <td><?= htmlspecialchars($member['email']) ?></td>
                                                    <td><?= htmlspecialchars($member['phone']) ?></td>
                                                    <td><?= htmlspecialchars($member['plan_name'] ?? 'None') ?></td>
                                                    <td><?= date('M d, Y', strtotime($member['join_date'])) ?></td>
                                                    <td>
                                                        <span class="status status-<?= $member['status'] ?>">
                                                            <?= ucfirst($member['status']) ?>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="table-actions">
                                                            <a href="member-profile.php?id=<?php echo $member['id']; ?>"
                                                                class="btn-icon" title="View Profile">
                                                                <i data-lucide="eye"></i>
                                                            </a>
                                                            <a href="members.php?action=edit&id=<?php echo $member['id']; ?>"
                                                                class="btn-icon" title="Edit">
                                                                <i data-lucide="edit"></i>
                                                            </a>
                                                            <a href="members.php?action=delete&id=<?php echo $member['id']; ?>"
                                                                class="btn-icon" title="Delete">
                                                                <i data-lucide="trash-2"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <?php if ($total_pages > 1): ?>
                                    <div class="pagination">
                                        <?php if ($page > 1): ?>
                                            <a href="members.php?page=<?php echo ($page - 1); ?><?php echo (!empty($search)) ? '&search=' . urlencode($search) : ''; ?>"
                                                class="pagination-item">
                                                <i data-lucide="chevron-left"></i>
                                            </a>
                                        <?php endif; ?>

                                        <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                                            <?php if ($i == 1 || $i == $total_pages || ($i >= $page - 2 && $i <= $page + 2)): ?>
                                                <a href="members.php?page=<?php echo $i; ?><?php echo (!empty($search)) ? '&search=' . urlencode($search) : ''; ?>"
                                                    class="pagination-item <?php echo ($i == $page) ? 'active' : ''; ?>">
                                                    <?php echo $i; ?>
                                                </a>
                                            <?php elseif ($i == 2 || $i == $total_pages - 1): ?>
                                                <span class="pagination-dots">...</span>
                                            <?php endif; ?>
                                        <?php endfor; ?>

                                        <?php if ($page < $total_pages): ?>
                                            <a href="members.php?page=<?php echo ($page + 1); ?><?php echo (!empty($search)) ? '&search=' . urlencode($search) : ''; ?>"
                                                class="pagination-item">
                                                <i data-lucide="chevron-right"></i>
                                            </a>
                                        <?php endif; ?>
                                    </div>
                                <?php endif; ?>

                            <?php else: ?>
                                <div class="no-data">
                                    <i data-lucide="users-x"></i>
                                    <p>No members
                                        found<?php echo (!empty($search)) ? ' matching "' . htmlspecialchars($search) . '"' : ''; ?>
                                    </p>
                                    <?php if (!empty($search)): ?>
                                        <a href="members.php" class="btn btn-secondary">Show All Members</a>
                                    <?php endif; ?>
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
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize Lucide icons
            lucide.createIcons();

            // Mobile menu toggle
            const menuToggle = document.querySelector('.menu-toggle');
            const sidebar = document.querySelector('.sidebar');

            menuToggle.addEventListener('click', function () {
                sidebar.classList.toggle('active');
            });

            // Notification dropdown
            const notificationBtn = document.querySelector('.notification-btn');
            const notificationDropdown = document.querySelector('.notifications .dropdown-menu');

            notificationBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                notificationDropdown.classList.toggle('active');
            });

            // Profile dropdown
            const profileBtn = document.querySelector('.profile-btn');
            const profileDropdown = document.querySelector('.admin-profile .dropdown-menu');

            profileBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                profileDropdown.classList.toggle('active');
            });

            // Close dropdowns when clicking elsewhere
            document.addEventListener('click', function () {
                notificationDropdown.classList.remove('active');
                profileDropdown.classList.remove('active');
            });
        });
    </script>
</body>

</html>