<?php
session_start();
require_once('../connect.php');

// Define the target directory for uploads
$targetDir = "C:/xampp/htdocs/clp/images/";
if (!file_exists($targetDir)) {
    mkdir($targetDir, 0777, true);
}

// Decode JSON data from request body
$userId = $_POST['userId'];
$questionId = $_POST['questionId'];
$content = $_POST['content'];
$image = null;

// Check if an image file is included in the request
if (isset($_FILES['image'])) {
    $targetFile = $targetDir . basename($_FILES["image"]["name"]);
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
        $image = basename($_FILES["image"]["name"]);
    } else {
        die("Error: Failed to upload image.");
    }
}

// Prepare the SQL query to insert the message
if ($image) {
    $query = "INSERT INTO ans_reply (userId, questionId, content, image) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    if (!$stmt) {
        die("Error: " . $conn->error); // Add error handling for prepare statement
    }
    // Bind parameters to the prepared statement
    $stmt->bind_param("iiss", $userId, $questionId, $content, $image);
} else {
    $query = "INSERT INTO ans_reply (userId, questionId, content) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($query);
    if (!$stmt) {
        die("Error: " . $conn->error); // Add error handling for prepare statement
    }
    // Bind parameters to the prepared statement
    $stmt->bind_param("iis", $userId, $questionId, $content);
}

$stmt->execute();

// Check for errors in query execution
if ($stmt->error) {
    die("Error: " . $stmt->error);
}

$stmt->close();
$conn->close();

echo json_encode(['status' => 'success']);
?>
