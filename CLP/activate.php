<?php
require_once('connect.php');

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['email'], $data['token'])) {
    $em = mysqli_real_escape_string($conn, $data['email']);
    $tk = mysqli_real_escape_string($conn, $data['token']);

    // Retrieve row with the provided email address
    $query = "SELECT * FROM users WHERE email = '$em'";
    $result = mysqli_query($conn, $query);

    if ($result) {
        if (mysqli_num_rows($result) == 1) {
            $row = mysqli_fetch_assoc($result);
            $db_token = $row['Random']; // Assuming the token column name is 'Random'

            if ($db_token == $tk) {
                // Tokens match, update activation column to 'ACTIVE'
                $update_query = "UPDATE users SET activation = 'ACTIVE' WHERE email = '$em'";
                $update_result = mysqli_query($conn, $update_query);

                if ($update_result) {
                    echo json_encode("success");
                } else {
                    echo json_encode("update_failed");
                }
            } else {
                // Tokens don't match
                echo json_encode("token_mismatch");
            }
        } else {
            // No user found with the provided email address
            echo json_encode("email_not_found");
        }
    } else {
        // Error in database query
        echo json_encode("database_error");
    }
} else {
    // Required fields not provided
    echo json_encode("missing_fields");
}

mysqli_close($conn);
?>
