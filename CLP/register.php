<?php
require_once('connect.php');

$data = json_decode(file_get_contents('php://input'), true);

// Check if all required fields are provided
if (isset($data['firstname'], $data['secondname'], $data['email'], $data['password'])) {
    $fn = mysqli_real_escape_string($conn, $data['firstname']);
    $un = mysqli_real_escape_string($conn, $data['secondname']);
    $pass = mysqli_real_escape_string($conn, $data['password']);
    $em = mysqli_real_escape_string($conn, $data['email']);
    $random = rand(1000, 9999); // Generate a random 4-digit number
    $password = password_hash($pass,PASSWORD_DEFAULT);

    // Prepare the SQL statement using a prepared statement to prevent SQL injection
    $sql = "INSERT INTO users(Firstname, Secondname, email, Password, Random) VALUES (?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($conn, $sql);

    if ($stmt) {
        // Bind parameters to the prepared statement
        mysqli_stmt_bind_param($stmt, 'sssss', $fn, $un, $em, $password, $random);

        // Execute the prepared statement
        if (mysqli_stmt_execute($stmt)) {
            // Registration successful
            SendEmailToUser($em, $random);
            echo json_encode(["status" => "success"]);
        } else {
            // Registration failed
            echo json_encode(["status" => "error", "message" => "Registration failed"]);
        }
    } else {
        // SQL statement preparation failed
        echo json_encode(["status" => "error", "message" => "Database error"]);
    }

    // Close the prepared statement
    mysqli_stmt_close($stmt);
} else {
    // Required fields not provided
    echo json_encode(["status" => "error", "message" => "Missing fields"]);
}

// Close the database connection
mysqli_close($conn);

function SendEmailToUser($email_to, $random){

    require_once 'PHPMailer/PHPMailer/PHPMailer.php';
    require_once 'PHPMailer/PHPMailer/SMTP.php';
    require_once 'PHPMailer/PHPMailer/Exception.php';
    
    
    $mail = new PHPMailer\PHPMailer\PHPMailer();
    try{
   $mail->isSMTP();                      
    $mail->Host  = 'mail.atchosting.ac.tz';         
    $mail->SMTPAuth = true;             
    $mail->Username = 'emchani@atchosting.ac.tz';       
    $mail->Password = 'tonyrine1999!';           
    $mail->SMTPSecure = 'ssl';              
    $mail->Port  = 465;
  
    $mail->setFrom('emchani@atchosting.ac.tz', 'HOUSE RENTING MANAGEMENT SYSTEM');           // Set sender of the mail
      $mail->addAddress($email_to);           // Add a recipient
    
    $mail->isHTML(true);                
    $mail->Subject = 'Welcome to HRMS';
    $mail->Body = '<b>THANK YOU FOR REGISTERING</b> your account is current inactive, please activate your account with token bellow<br> $random
    ';
    $mail->send();
  
    echo "<h3 style='color: green;'>Mail has been sent successfully!</h3>";
  
  } catch(Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
  }}

// function SendEmailToUser($email_to, $random) {
//     // Your email sending logic here
// }
?>
