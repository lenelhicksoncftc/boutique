<?php

//  refund.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require 'dbconnect.php';

if (isset($_GET['id']) === FALSE) {
	header("Location: index.php");
	exit();
}

if (isset($_GET['id']) && isset($_GET['forreal']) && $_GET['forreal'] == "yes") {
	require 'transactionFunctions.php';
	if (isset($_GET['revoke']) && $_GET['revoke'] == "revoke") $revoke = TRUE; else $revoke = FALSE;
	refundTransaction($_GET['id'],$_GET['refamount'],$revoke);
	header("Location: index.php");
	exit();
}

$page_title = "Refund";

require 'header.inc.php';

$id = $_GET['id'];

$sql = "select firstName, lastName, name, paymentDate, gross, email, refund from transactions, contacts, products where transactions.item = products.id and transactions.contactid = contacts.id and transactions.id = '" . mysql_escape_string($id) . "'";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));

if (mysql_num_rows($query) === 0) {
	echo "<p>Transaction not found</p>";
} else {
	$firstName = mysql_result($query,0,"firstName");
	$lastName = mysql_result($query,0,"lastName");
	$name = mysql_result($query,0,"name");
	$paymentDate = mysql_result($query,0,"paymentDate");
	$gross = mysql_result($query,0,"gross");
	$email = mysql_result($query,0,"email");
	$refund = mysql_result($query,0,"refund");
	if ($refund == $gross) {
		echo "<p>This transaction has been fully refunded already.</p>\n";
	} else  {
		$refamount = $gross - $refund;
		echo "<p>Are you sure you want to refund this transaction?</p>\n";
		echo "<p>$id - $firstName $lastName ($email) - $name<br>$gross ($refund already refunded)</p>";
		echo "<form method=\"get\">\n";
		echo "<input type=\"hidden\" name=\"id\" value=\"$id\">\n";
		echo "<input type=\"hidden\" name=\"forreal\" value=\"yes\">\n";
		echo "<table>\n";
		echo "<tr><td class=\"formlabel\">Refund amount</td><td><input type=\"text\" name=\"refamount\" value=\"$refamount\" size=\"7\"></td></tr>\n";
		echo "<tr><td class=\"formlabel\">Revoke License</td><td><input type=\"checkbox\" name=\"revoke\" value=\"revoke\"></td></tr>\n";
		echo "<tr><td colspan=\"2\"><input type=\"submit\" value=\"Refund\"></td></tr>\n";
		echo "</table>\n";
	}

}

require 'footer.inc.php';
?>