<?php
define('DB_HOST','localhost:3306');
define('DB_USERNAME','root');
define('DB_PASSWORD','');
define('DB_DATABASE','clpDB');
$conn = mysqli_connect(DB_HOST,DB_USERNAME,DB_PASSWORD,DB_DATABASE) or die ("Unable to connet");
	
?>