<?php
if (isset($_POST['username'])) {
	require 'session.php';
	$posted_username=mysql_escape_string($_POST['username']);
	$posted_password=mysql_escape_string($_POST['password']);
	require_once '../dbconnect.php';
	$sql = "select id from users where username = lower('$posted_username') and password = password ('$posted_password') and active_flag = 1";
	$result = mysql_query($sql);
	$id = mysql_result($result, 0, 'id');
	
	if ($id !== FALSE and $posted_password != "") {
		$_SESSION['storeuser'] = $id;
		
		if (isset($_SESSION['redirect'])) {
			$page = $_SESSION['redirect'];
			header("Location: $page");
			exit();
		} else {
			header("Location: index.php");
			exit();
		}
	} else {
		set_error("Incorrect username or password");
		header("Location: logon.php");
		exit();
	}
} else {
	header("Location: logon.php");
	exit();
}

?>
