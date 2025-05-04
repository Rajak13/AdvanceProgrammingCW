<?php
// member-profile.php
if (session_status() === PHP_SESSION_NONE) session_start();
if (!isset($_SESSION['admin_id'])) header("Location: login.php");

include 'includes/db_connect.php';

$member_id = (int)$_GET['id'];
$member = [];
$metrics = [];

try {
    // Get member details
    $stmt = $conn->prepare("SELECT users.*, plans.name AS plan_name 
                           FROM users 
                           LEFT JOIN plans ON users.plan_id = plans.id 
                           WHERE users.id = ?");
    $stmt->bind_param("i", $member_id);
    $stmt->execute();
    $member = $stmt->get_result()->fetch_assoc();

    if (!$member) throw new Exception("Member not found");

    // Get metrics
    $metrics_stmt = $conn->prepare("SELECT * FROM user_metrics WHERE user_id = ?");
    $metrics_stmt->bind_param("i", $member_id);
    $metrics_stmt->execute();
    $metrics = $metrics_stmt->get_result()->fetch_assoc();

} catch (Exception $e) {
    die("Error: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><?= $member['first_name'] ?> Profile</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <!-- Add to admin wrapper structure similar to members.php -->
    <div class="content-wrapper">
        <div class="page-header">
            <h1><?= $member['first_name'] ?>'s Profile</h1>
            <a href="members.php" class="btn btn-secondary">Back to Members</a>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="profile-grid">
                    <div class="profile-section">
                        <h3>Personal Information</h3>
                        <p><strong>Name:</strong> <?= $member['first_name'] ?> <?= $member['last_name'] ?></p>
                        <p><strong>Email:</strong> <?= $member['email'] ?></p>
                        <p><strong>Phone:</strong> <?= $member['phone'] ?></p>
                        <p><strong>Plan:</strong> <?= $member['plan_name'] ?></p>
                    </div>

                    <?php if ($metrics): ?>
                    <div class="profile-section">
                        <h3>Health Metrics</h3>
                        <p><strong>Age:</strong> <?= $metrics['age'] ?></p>
                        <p><strong>Height:</strong> <?= $metrics['height'] ?> cm</p>
                        <p><strong>Weight:</strong> <?= $metrics['weight'] ?> kg</p>
                    </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>
</body>
</html>