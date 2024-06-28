<?php
require_once('connect.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $gender = $_POST['gender'];
    $university = $_POST['university'];
    $role = $_POST['role'];

    // Check if an image is uploaded
    if (isset($_FILES['profile_image']) && $_FILES['profile_image']['error'] == UPLOAD_ERR_OK) {
        $upload_dir = 'C:/xampp/htdocs/CLP/images/pf/';
        $file_tmp = $_FILES['profile_image']['tmp_name'];
        $file_name = basename($_FILES['profile_image']['name']);
        $file_path = $upload_dir . $file_name;

        // Ensure unique file name if necessary
        $i = 1;
        $new_file_name = $file_name;
        while (file_exists($file_path)) {
            $file_info = pathinfo($file_name);
            $new_file_name = $file_info['filename'] . '_' . $i . '.' . $file_info['extension'];
            $file_path = $upload_dir . $new_file_name;
            $i++;
        }

        if (move_uploaded_file($file_tmp, $file_path)) {
            $file_url = $new_file_name;
            $query = "UPDATE users SET gender = ?, uni = ?, role = ?, image = ?, N = 1 WHERE ID = ?";
            $stmt = $conn->prepare($query);
            $stmt->bind_param('ssssi', $gender, $university, $role, $file_url, $user_id);
        } else {
            echo json_encode(['status' => 'file_upload_error']);
            exit;
        }
    } else {
        // If no image is uploaded, update the user info without changing the image
        $query = "UPDATE users SET gender = ?, uni = ?, role = ?, N = 1 WHERE ID = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param('sssi', $gender, $university, $role, $user_id);
    }

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'database_error']);
    }
} else {
    echo json_encode(['status' => 'invalid_request']);
}

mysqli_close($conn);
?>
