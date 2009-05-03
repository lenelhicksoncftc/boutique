<?php

require_once 'AquaticPrime.php';

function newFailedTransaction($contactID,$errorCode) {
	global $dbconnection;
	$transactionID = uniqid("FAIL");

	$sql = "insert into transactions (id, contactId, errorCode) values ('$transactionID', '$contactID','$errorCode')";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
}

function newTransaction($paypalTransID,$contactID,$item,$amount,$coupon=0) {
	global $dbconnection;
	$transactionID = uniqid();
	$sql = "insert into transactions (id, paypalTransactionID, contactID, item, gross, couponId) values ('$transactionID', '$paypalTransID', '$contactID', '$item', $amount, $coupon)";
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

function idForCouponCode($code,$productID) {
	global $dbconnection;
	$sql = "select id from coupons where code = '" . mysql_escape_string($code) . "' and productId = $productID and startDate < now() and endDate > now()";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	if (mysql_num_rows($query) === 0) return FALSE;
	
	return mysql_result($query,0,'id');
}

function couponCalc($id) {
	global $dbconnection;
	$sql = "select value, type, quantity, used, price from coupons, products where coupons.productId = products.id and coupons.id = $id";

	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	if (mysql_num_rows($query) === 0) return FALSE;
	
	if (mysql_result($query,0,'used') >= mysql_result($query,0,'quantity')) return FALSE;
	
	switch (mysql_result($query,0,'type')) {
		case "p":
			$reducedPrice = mysql_result($query,0,'price') * ((100 - mysql_result($query,0,'value'))/100);
			break;
		case "a":
			$reducedPrice = mysql_result($query,0,'price') - mysql_result($query,0,'value');
			break;
	}
	
	return round($reducedPrice,2);
}

function incrementCouponUsage($id) {
	$sql = "update coupons set used = used + 1 where id = $id";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
}

?>