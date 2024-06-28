<?php
session_start();
require_once('connect.php');

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['email'], $data['password'])) {
    $em = mysqli_real_escape_string($conn, $data['email']);
    $pass = mysqli_real_escape_string($conn, $data['password']);

    $query = "SELECT * FROM users WHERE email = '$em'";
    $result = mysqli_query($conn, $query);

    if ($result) {
        if (mysqli_num_rows($result) == 1) {
            $row = mysqli_fetch_assoc($result);
            $db_password = $row['Password'];
            $activation_status = $row['activation'];
            $n_value = $row['N']; // Assuming the column name is 'N'

            if (password_verify($pass, $db_password) && $activation_status == 'ACTIVE') {
                // Passwords match and account is active, authentication successful
                $user_id = $row['ID']; // Assuming the user ID column name is 'ID'
                if ($n_value == 0) {
                    echo json_encode(["status" => "first_time", "user_id" => $user_id]);
                } else {
                    echo json_encode(["status" => "success", "user_id" => $user_id]);
                }
            } else {
                // Passwords don't match or account is not active
                echo json_encode(["status" => "invalid_credentials"]);
            }
        } else {
            // No user found with the provided email address
            echo json_encode(["status" => "email_not_found"]);
        }
    } else {
        // Error in database query
        echo json_encode(["status" => "database_error"]);
    }
} else {
    // Required fields not provided
    echo json_encode(["status" => "missing_fields"]);
}

mysqli_close($conn);
?>
