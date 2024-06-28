<?php
require_once('../connect.php');

// Decode JSON data from request body
$data = json_decode(file_get_contents('php://input'), true);

// Check if 'id' is set in the JSON data
if (!isset($data['id'])) {
    die("Error: 'id' parameter is missing.");
}

$questionId = $data['id'];

// Prepare the SQL query to fetch messages
$query = "SELECT ID, userId, questionId, content, image FROM ans_reply WHERE questionId = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    die("Error: " . $conn->error); // Add error handling for prepare statement
}

// Bind parameters to the prepared statement
$stmt->bind_param("i", $questionId);
$stmt->execute();

// Check for errors in query execution
if ($stmt->error) {
    die("Error: " . $stmt->error);
}

$result = $stmt->get_result();

$messages = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        array_push($messages, $row);
    }
} else {
    $messages = [];
}

$stmt->close();
$conn->close();

header('Content-Type: application/json');
echo json_encode($messages);
?>
