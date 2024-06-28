<?php
require_once('connect.php');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Validate required fields
    if (!isset($_POST['user_id']) || !isset($_POST['firstname']) || !isset($_POST['secondname']) || !isset($_POST['email']) || !isset($_POST['gender']) || !isset($_POST['university']) || !isset($_POST['role'])) {
        echo json_encode(['status' => 'missing_fields']);
        exit;
    }

    $user_id = $_POST['user_id'];
    $firstname = $_POST['firstname'];
    $secondname = $_POST['secondname'];
    $email = $_POST['email'];
    $gender = $_POST['gender'];
    $university = $_POST['university'];
    $role = $_POST['role'];

    // Check if a password is provided and hash it
    $password = isset($_POST['password']) ? $_POST['password'] : null;
    $hashed_password = null;
    if (!empty($password)) {
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    }

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
            $query = "UPDATE users SET firstname = ?, secondname = ?, email = ?, gender = ?, uni = ?, role = ?, password = ?, image = ? WHERE ID = ?";
            $stmt = $conn->prepare($query);
            $stmt->bind_param('ssssssssi', $firstname, $secondname, $email, $gender, $university, $role, $hashed_password, $file_url, $user_id);
        } else {
            echo json_encode(['status' => 'file_upload_error']);
            exit;
        }
    } else {
        // If no image is uploaded, update the user info without changing the image
        if (!empty($hashed_password)) {
            $query = "UPDATE users SET firstname = ?, secondname = ?, email = ?, gender = ?, uni = ?, role = ?, password = ? WHERE ID = ?";
            $stmt = $conn->prepare($query);
            $stmt->bind_param('sssssssi', $firstname, $secondname, $email, $gender, $university, $role, $hashed_password, $user_id);
        } else {
            $query = "UPDATE users SET firstname = ?, secondname = ?, email = ?, gender = ?, uni = ?, role = ? WHERE ID = ?";
            $stmt = $conn->prepare($query);
            $stmt->bind_param('ssssssi', $firstname, $secondname, $email, $gender, $university, $role, $user_id);
        }
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
