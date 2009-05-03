<?php

require_once 'config.php';

// Setup connection

$dbconnection = mysql_pconnect(DB_HOST,DB_USER,DB_PASS) or die("ERROR: Unable to connect to database");
mysql_select_db(DB_NAME,$dbconnection) or die("ERROR: " . mysql_error($dbconnection));


?>