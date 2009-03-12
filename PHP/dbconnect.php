<?php

// Enter your configuration here

$dbname = 'store';
$dbhost ='localhost';
$dbuser = 'storeuser';
$dbpassword = '';

// Setup connection

$dbconnection = mysql_pconnect($dbhost,$dbuser,$dbpassword) or die("Unable to connect to database");
mysql_select_db($dbname,$dbconnection) or die(mysql_error($dbconnection));


?>