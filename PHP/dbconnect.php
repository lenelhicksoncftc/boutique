<?php

//  dbconnect.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

require_once 'config.php';

// Setup connection

$dbconnection = mysql_pconnect(DB_HOST,DB_USER,DB_PASS) or die("ERROR: Unable to connect to database");
mysql_select_db(DB_NAME,$dbconnection) or die("ERROR: " . mysql_error($dbconnection));

function set_error($error) {
	if (session_id() == "") {
		exit($error);
	} else {
		$_SESSION['error'] .= "$error<br>\n";
	}
}

function set_info($text) {
	if (session_id() != "") {
		$_SESSION['info'] .= "$text<br>\n";
	}
}

?>