<?php
require 'session.php';
if (isset($_SESSION['storeuser'])) {
	$storeuser=$_SESSION['storeuser'];
	$session_id = session_id();
	$cookie_params = session_get_cookie_params();

	setcookie($session_name,$session_id,time()+$session_length,$cookie_params['path'],$cookie_params['domain']);
} else {
	$_SESSION['redirect'] = $_SERVER["REQUEST_URI"];
	header("Location: logon.php");
	exit();
}


?>
