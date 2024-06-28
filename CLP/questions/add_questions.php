<?php
session_start();
require_once('../connect.php');

$targetDir = "C:/xampp/htdocs/clp/images/qandd/";

if (isset($_POST['subject'], $_POST['question'], $_POST['description'], $_POST['userId'])) {
    $subject = mysqli_real_escape_string($conn, $_POST['subject']);
    $question = mysqli_real_escape_string($conn, $_POST['question']);
    $description = mysqli_real_escape_string($conn, $_POST['description']);
    $userId = mysqli_real_escape_string($conn, $_POST['userId']);

    // Initialize image variable
    $image = null;

    // Check if an image file is included in the request
    if (isset($_FILES['image'])) {
        $image = basename($_FILES["image"]["name"]);
        $targetFile = $targetDir . $image;
        if (!move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
            die(json_encode(["status" => "error", "message" => "Failed to upload image."]));
        }
    }

    // Prepare the SQL query to insert the question
    if ($image) {
        $query = "INSERT INTO questions(UserId, Subject, Title, Description, Image) VALUES ('$userId', '$subject', '$question', '$description', '$image')";
    } else {
        $query = "INSERT INTO questions(UserId, Subject, Title, Description) VALUES ('$userId', '$subject', '$question', '$description')";
    }

    if (mysqli_query($conn, $query)) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
    }
} else {
    echo json_encode(["status" => "missing_fields"]);
}

mysqli_close($conn);
?>
