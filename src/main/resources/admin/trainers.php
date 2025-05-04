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
$success_message = '';
$error_message = '';

// Action handling
$action = $_GET['action'] ?? '';
$trainer_id = isset($_GET['id']) ? (int) $_GET['id'] : 0;

// Handle form submissions
try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $name = htmlspecialchars($_POST['name'] ?? '');
        $specialty = htmlspecialchars($_POST['specialty'] ?? '');
        $bio = htmlspecialchars($_POST['bio'] ?? '');
        $experience = (int) ($_POST['experience'] ?? 0);
        $image = htmlspecialchars($_POST['image'] ?? '');
        $status = $_POST['status'] ?? 'active';

        // Validate required fields
        if (empty($name) || empty($specialty) || empty($image)) {
            throw new Exception("Please fill all required fields");
        }

        if ($action === 'edit' && isset($_POST['update_trainer'])) {
            $stmt = $conn->prepare("UPDATE trainers SET 
                name = ?, specialty = ?, bio = ?,
                experience = ?, image = ?, status = ?
                WHERE id = ?");
            $stmt->bind_param("sssissi", $name, $specialty, $bio, $experience, $image, $status, $trainer_id);
        } elseif ($action === 'add' && isset($_POST['add_trainer'])) {
            $stmt = $conn->prepare("INSERT INTO trainers 
                (name, specialty, bio, experience, image, status)
                VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("sssiss", $name, $specialty, $bio, $experience, $image, $status);
        }

        if (isset($stmt)) {
            if (!$stmt->execute()) {
                throw new Exception("Database error: " . $stmt->error);
            }
            $_SESSION['success'] = "Trainer " . ($action === 'edit' ? 'updated' : 'added') . " successfully!";
            header("Location: trainers.php");
            exit();
        }
    }
} catch (Exception $e) {
    $error_message = $e->getMessage();
}

// Handle deletion
if ($action === 'delete' && $trainer_id > 0) {
    try {
        $stmt = $conn->prepare("DELETE FROM trainers WHERE id = ?");
        $stmt->bind_param("i", $trainer_id);

        if ($stmt->execute()) {
            $_SESSION['success'] = "Trainer deleted successfully!";
        } else {
            throw new Exception("Delete failed: " . $stmt->error);
        }
        header("Location: trainers.php");
        exit();
    } catch (Exception $e) {
        $error_message = $e->getMessage();
    }
}

// Fetch trainers data
$trainers = [];
$result = $conn->query("SELECT * FROM trainers ORDER BY name");
if ($result) {
    $trainers = $result->fetch_all(MYSQLI_ASSOC);
}

// Fetch trainer data for editing
$edit_data = [];
if ($action === 'edit' && $trainer_id > 0) {
    $stmt = $conn->prepare("SELECT * FROM trainers WHERE id = ?");
    $stmt->bind_param("i", $trainer_id);
    $stmt->execute();
    $edit_data = $stmt->get_result()->fetch_assoc();

    if (!$edit_data) {
        $error_message = "Trainer not found!";
        $action = '';
    }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Trainers - ARA Gym</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <!-- Include Lucide CSS -->
    <link href="https://cdn.jsdelivr.net/npm/lucide@latest/dist/lucide.css" rel="stylesheet">

    <link rel="stylesheet" href="css/admin.css">
    <style>
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            padding: 1rem;
        }

        .trainer-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s;
        }

        .trainer-card:hover {
            transform: translateY(-3px);
        }

        .trainer-image img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .trainer-info {
            padding: 1.5rem;
        }

        .status {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-active {
            background: #c6f6d5;
            color: #22543d;
        }

        .status-inactive {
            background: #fed7d7;
            color: #822727;
        }
    </style>
</head>

<body>
    <div class="admin-wrapper">
        <!-- Sidebar (same as members.php) -->
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
                    <li class="active">
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
                    <h1><?= ($action === 'add') ? 'Add New Trainer' : (($action === 'edit') ? 'Edit Trainer' : 'Manage Trainers') ?>
                    </h1>
                    <?php if (empty($action)): ?>
                        <a href="trainers.php?action=add" class="btn btn-primary">
                            <i data-lucide="user-plus"></i>
                            Add New Trainer
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
                    <!-- Add/Edit Form -->
                    <div class="card">
                        <div class="card-body">
                            <form method="POST" class="form">
                                <?php if ($action === 'edit'): ?>
                                    <input type="hidden" name="trainer_id" value="<?= $trainer_id ?>">
                                <?php endif; ?>

                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="name">Full Name *</label>
                                        <input type="text" id="name" name="name" required
                                            value="<?= htmlspecialchars($edit_data['name'] ?? '') ?>">
                                    </div>

                                    <div class="form-group">
                                        <label for="specialty">Specialty *</label>
                                        <input type="text" id="specialty" name="specialty" required
                                            value="<?= htmlspecialchars($edit_data['specialty'] ?? '') ?>">
                                    </div>

                                    <div class="form-group">
                                        <label for="experience">Experience (Years) *</label>
                                        <input type="number" id="experience" name="experience" min="0" required
                                            value="<?= htmlspecialchars($edit_data['experience'] ?? '') ?>">
                                    </div>

                                    <div class="form-group">
                                        <label for="image">Image URL *</label>
                                        <input type="url" id="image" name="image" required
                                            value="<?= htmlspecialchars($edit_data['image'] ?? '') ?>">
                                    </div>

                                    <div class="form-group full-width">
                                        <label for="bio">Bio</label>
                                        <textarea id="bio"
                                            name="bio"><?= htmlspecialchars($edit_data['bio'] ?? '') ?></textarea>
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Status *</label>
                                        <select id="status" name="status" required>
                                            <option value="active" <?= ($edit_data['status'] ?? 'active') === 'active' ? 'selected' : '' ?>>Active</option>
                                            <option value="inactive" <?= ($edit_data['status'] ?? '') === 'inactive' ? 'selected' : '' ?>>Inactive</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <a href="trainers.php" class="btn btn-secondary">Cancel</a>
                                    <?php if ($action === 'add'): ?>
                                        <button type="submit" name="add_trainer" class="btn btn-primary">Add Trainer</button>
                                    <?php else: ?>
                                        <button type="submit" name="update_trainer" class="btn btn-primary">Update
                                            Trainer</button>
                                    <?php endif; ?>
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
                                <h3>Delete Trainer?</h3>
                                <p>This action cannot be undone. All related data will be removed.</p>
                            </div>
                            <form method="POST">
                                <input type="hidden" name="trainer_id" value="<?= $trainer_id ?>">
                                <div class="form-actions">
                                    <a href="trainers.php" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" name="delete_trainer" class="btn btn-danger">Delete</button>
                                </div>
                            </form>
                        </div>
                    </div>
                <?php else: ?>
                    <!-- Trainers List -->
                    <div class="card">
                        <div class="card-body">
                            <?php if (!empty($trainers)): ?>
                                <div class="grid-container">
                                    <?php foreach ($trainers as $trainer): ?>
                                        <div class="trainer-card">
                                            <div class="trainer-image">
                                                <img src="<?= htmlspecialchars($trainer['image']) ?>"
                                                    alt="<?= htmlspecialchars($trainer['name']) ?>">
                                            </div>
                                            <div class="trainer-info">
                                                <h3><?= htmlspecialchars($trainer['name']) ?></h3>
                                                <p class="specialty"><?= htmlspecialchars($trainer['specialty']) ?></p>
                                                <p><?= $trainer['experience'] ?> years experience</p>
                                                <span class="status status-<?= $trainer['status'] ?>">
                                                    <?= ucfirst($trainer['status']) ?>
                                                </span>
                                                <div class="trainer-actions">
                                                    <a href="trainers.php?action=edit&id=<?= $trainer['id'] ?>" class="btn-icon">
                                                        <i data-lucide="edit"></i>
                                                    </a>
                                                    <a href="trainers.php?action=delete&id=<?= $trainer['id'] ?>" class="btn-icon"
                                                        onclick="return confirm('Delete this trainer?')">
                                                        <i data-lucide="trash-2"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                </div>
                            <?php else: ?>
                                <div class="no-data">
                                    <i data-lucide="users-x"></i>
                                    <p>No trainers found</p>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
        </main>
    </div>

    <!-- Include Lucide JavaScript -->
    
    
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize Lucide icons
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