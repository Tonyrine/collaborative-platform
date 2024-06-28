<?php
require_once('connect.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];

    $query = "SELECT firstname, secondname, email, uni, gender, role, image FROM users WHERE ID = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('i', $user_id);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            echo json_encode(['status' => 'success', 'data' => $user]);
        } else {
            echo json_encode(['status' => 'not_found']);
        }
    } else {
        echo json_encode(['status' => 'database_error']);
    }

    $stmt->close();
}

mysqli_close($conn);
?>
