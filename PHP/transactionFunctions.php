<?php

require_once 'AquaticPrime.php';

function newFailedTransaction($contactID,$errorCode) {
	global $dbconnection;
	$transactionID = uniqid("FAIL");

	$sql = "insert into transactions (id, contactId, errorCode) values ('$transactionID', '$contactID','$errorCode')";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
}

function newTransaction($paypalTransID,$contactID,$item,$amount) {
	global $dbconnection;
	$transactionID = uniqid();
	$sql = "insert into transactions (id, paypalTransactionID, contactID, item, gross) values ('$transactionID', '$paypalTransID', '$contactID', '$item', $amount)";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	return $transactionID;
}

function licenseForTransaction($transactionID,$duringSale) {
	global $dbconnection;
	$sql = "select firstname, lastname, email, paymentDate, name, publicKey, privateKey from contacts, transactions, products
	where contacts.id = transactions.contactid and
	products.id = transactions.item and
	transactions.id = '$transactionID'";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	if (mysql_num_rows($query) === 0) return FALSE;
	
	if ($duringSale) $b = 1; else; $b = 0;
	$sql = "insert into requests (transactionID, duringSale) values ('" . mysql_escape_string($transactionID) . "', " . $b . ")";
	$request_insert = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	$dict = array("Product" => mysql_result($query,0,'name'),
			  "Name" => mysql_result($query,0,'firstname') . " " . mysql_result($query,0,'lastname'),
			  "Email" => mysql_result($query,0,'email'),
			  "Date" => mysql_result($query,0,'paymentDate'),
			  "TransactionID" => $transactionID);

	$license = licenseDataForDictionary($dict, mysql_result($query,0,'publicKey'), mysql_result($query,0,'privateKey'));
	
	return $license;
	
}

?>