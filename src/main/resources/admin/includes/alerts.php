<?php if (!empty($success_message)): ?>
    <div class="alert alert-success">
        <?= htmlspecialchars($success_message) ?>
    </div>
<?php endif; ?>

<?php if (!empty($error_message)): ?>
    <div class="alert alert-error">
        <?= htmlspecialchars($error_message) ?>
    </div>
<?php endif; ?>
