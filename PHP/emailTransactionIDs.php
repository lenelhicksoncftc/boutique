<?php

//  emailTransactionIDs.php
//
//  Copyright � 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

if (!isset($_POST['email'])) {
	exit("ERROR: Missing parameter in POST request");
}
require 'config.php';
require 'dbconnect.php';

$email = $_POST['email'];

$sql = "select name, transactions.id from transactions, contacts, products where transactions.contactId = contacts.id
and transactions.item = products.id and errorcode is null and contacts.email = '" . mysql_escape_string($email) . "' order by products.name";

$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));

if (mysql_num_rows($query) === 0) exit("ERROR: No Transaction IDs found");

require 'mailFunctions.php';

$plain = "Thanks for requesting your Transaction IDs.  We hope your enjoy our software.\n\n";

while ($row = mysql_fetch_row($query)) {
	$plain .= $row[0] . "   " . $row[1] . "\n";
}

$html = nl2br($plain);

boutique_mail($email, "Your Transaction IDs from " . COMPANY_NAME, $plain, $html);


?>