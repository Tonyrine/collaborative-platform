<?php 
        use PHPMailer\PHPMailer\PHPMailer;
        

        require_once('PHPMailer.php');
        require_once('SMTP.php');
        require_once('Exception.php');

        
        // require_once('../../../../PHP_Libraries/PHPMailer/PHPMailer.php');
        // require_once('../../../../PHP_Libraries/PHPMailer/SMTP.php');
        // require_once('../../../../PHP_Libraries/PHPMailer/Exception.php');
        
       
        
        //Create a new PHPMailer instance

        use PHPMailer\PHPMailer\SMTP;
        
        $mail = new PHPMailer();
        //Tell PHPMailer to use SMTP
        $mail->isSMTP();
        $mail->Mailer = "smtp";
        //Enable SMTP debugging
        // 0 = off (for production use)
        // 1 = client messages
        // 2 = client and server messages
        $mail->SMTPDebug = 2;
        //Ask for HTML-friendly debug output
        $mail->Debugoutput = 'html';
        $mail->SMTPSecure = 'tls';
        //Set the hostname of the mail server
        $mail->Host = "smtp.gmail.com";
        // $mail->SMTPSecure = 'ssl';
        //Set the SMTP port number - likely to be 25, 465 or 587
        $mail->Port = 587;
        //Whether to use SMTP authentication
        $mail->SMTPAuth = true;
        //Username to use for SMTP authentication
        $mail->Username = "";
        //Password to use for SMTP authentication

        $mail->Password = "";
        //Set who the message is to be sent from
        $mail->setFrom('docpat.appointment@gmail.com', 'Doctor Patient Appointment');
        //Set an alternative reply-to address
        // $mail->addReplyTo('replyto@example.com', 'First Last');
        //Set who the message is to be sent to
        $mail->addAddress("receiver_email");
        //Set the subject line
        $mail->Subject = 'Doctor Appointment System Email Verification';
        //Read an HTML message body from an external file, convert referenced images to embedded,
        //convert HTML into a basic plain-text alternative body
        //$mail->msgHTML(file_get_contents('contents.html'), dirname(__FILE__));
        //Replace the plain text body with one created manually
        $mail->isHTML(true);
        $message = "<p>Please click the link below to verify your email so that you can login to the system</p>
                <a href='localhost/doctor_patient_appointment/registration/patients/patient_confirm.php' style='background-color:lightblue;color:black; text-decoration:none;padding:0.5em 1em;display:inline-block;border-radius:4px;'>Click to Verify your email</a>";

        $mail->Body =$message;
        //Attach an image file
        // $mail->addAttachment('images/phpmailer_mini.png');

        //send the message, check for errors
        if (!$mail->send()) {
            $msg = "<p class='msg error'>Mailer Error: ' . $mail->ErrorInfo</p>";
        } else {
            $msg=  "<p class='msg success'>Please login to your email to verify your account!</p>";
        }



?>