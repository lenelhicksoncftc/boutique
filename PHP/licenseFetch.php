<?php

//  licenseFetch.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

if (!isset($_POST['transactionID'])) {
	exit("ERROR: Missing parameter in POST request");
}

require 'dbconnect.php';
require 'transactionFunctions.php';

$transactionID = $_POST['transactionID'];

$license = licenseForTransaction($transactionID,FALSE);

if ($license === FALSE) {
	exit("ERROR: Transaction ID could not be found");
} else {
	echo $license;
}

?>