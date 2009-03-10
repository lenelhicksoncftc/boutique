<?php

// Enter your configuration here

$dbname = 'store';
$dbhost ='localhost';
$dbuser = 'storeuser';
$dbpassword = '';

// Setup connection
$dsn = 'mysql:dbname=$dbname;host=$dbhost';
$dboptions = array(PDO::ATTR_PERSISTENT => true);

try {
    $dbh = new PDO($dsn, $dbuser, $dbpassword, $dboptions);
} catch (PDOException $e) {
    $message = 'Connection failed: ' . $e->getMessage();
	exit();
}

?>