<?php
session_start();
require_once('../connect.php');

// Fetch questions from the database
$query = "SELECT * FROM diss";
$result = $conn->query($query);

$questions = array();

if ($result->num_rows > 0) {
  // Output data of each row
  while($row = $result->fetch_assoc()) {
    $question = array(
      'id' => $row['ID'],
      'subject' => $row['Subject'],
      'title' => $row['Title'],
      'description' => $row['Description'],
      'image' => $row['image']
    );
    array_push($questions, $question);
  }
} else {
  echo json_encode([]);
}

// Close connection
$conn->close();

// Return questions as JSON
header('Content-Type: application/json');
echo json_encode($questions);
?>
