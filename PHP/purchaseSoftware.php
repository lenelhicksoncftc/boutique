<?php

if (!isset($_POST['firstName']) OR
 	!isset($_POST['lastName']) OR
 	!isset($_POST['creditCardType']) OR
 	!isset($_POST['creditCardNumber']) OR
 	!isset($_POST['expDateMonth']) OR
 	!isset($_POST['expDateYear']) OR
 	!isset($_POST['cvv2Number']) OR
 	!isset($_POST['address1']) OR
 	!isset($_POST['city']) OR
 	!isset($_POST['state']) OR
 	!isset($_POST['postal']) OR
 	!isset($_POST['country']) OR
 	!isset($_POST['product'])) {
	exit("ERROR: Missing parameter in POST request");
}

require_once 'CallerService.php';
session_start();

$firstName = $_POST['firstName'];
$lastName = $_POST['lastName'];
$creditCardType = urlencode($_POST['creditCardType']);
$creditCardNumber = urlencode($_POST['creditCardNumber']);
$expDateMonth = urlencode($_POST['expDateMonth']);

// Month must be padded with leading zero
$padDateMonth = str_pad($expDateMonth, 2, '0', STR_PAD_LEFT);

$expDateYear = urlencode($_POST['expDateYear']);
$cvv2Number = urlencode($_POST['cvv2Number']);
$address1 = $_POST['address1'];
$city = $_POST['city'];
$state = $_POST['state'];
$postal = $_POST['postal'];
$country = $_POST['country'];
$email = $_POST['email'];

$product = $_POST['product'];

require 'dbconnect.php';
require 'transactionFunctions.php';

$sql = "select id, price, currency, publicKey, privateKey from products where name = '" . mysql_escape_string($product) . "'";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));

if (mysql_num_rows($query) === 0) exit("ERROR: Product not found");

$productid = mysql_result ($query,0,"id");
$currencyCode = mysql_result($query,0,"currency");
$key = mysql_result($query,0,"publicKey");
$privateKey = mysql_result($query,0,"privateKey");

if (isset($_POST['coupon']) and $_POST['coupon'] != "") {
	$couponID = idForCouponCode($_POST['coupon'],$productid);
	if ($couponID === FALSE) exit("ERROR: Coupon code not found");
	
	$amount = couponCalc($couponID);
	if ($amount === FALSE) exit("ERROR: Coupon code has expired");
} else {
	$amount = mysql_result($query,0,"price");
}


/* Construct the request string that will be sent to PayPal.
   The variable $nvpstr contains all the variables and is a
   name value pair string with & as a delimiter */
$nvpstr="&PAYMENTACTION=Authorization" .
"&AMT=$amount" .
"&CREDITCARDTYPE=$creditCardType" .
"&ACCT=$creditCardNumber" .
"&EXPDATE=$padDateMonth$expDateYear" .
"&CVV2=$cvv2Number" .
"&FIRSTNAME=" . urlencode($firstName) .
"&LASTNAME=" . urlencode($lastName) .
"&STREET=" . urlencode($address1) .
"&CITY=" . urlencode($city) .
"&STATE=" . urlencode($state) .
"&ZIP=" . urlencode($postal) .
"&COUNTRYCODE=" . urlencode($country) .
"&EMAIL=" . urlencode($email) .
"&CURRENCYCODE=$currencyCode";

/* Make the API call to PayPal, using API signature.
   The API response is stored in an associative array called $resArray */
$resArray=hash_call("doDirectPayment",$nvpstr);

/* If the response from PayPal was a success, issue a license.
   If the response was an error, return the error.
   */

$ack = strtoupper($resArray["ACK"]);

require 'contactFunctions.php';

$contact = IDforContactEmail($email);

if ($contact === FALSE) {
	$contact = newContact($firstName,$lastName,"",$address1,"",$city,$state,$postal,$country,"",$email,"");
}

if($ack!="SUCCESS")  {
	newFailedTransaction($contact,$resArray['L_ERRORCODE0']);
	exit("ERROR: " . $resArray['L_LONGMESSAGE0']);
}

if ($resArray['AVSCODE'] == "C" OR $resArray['AVSCODE'] == "E" OR $resArray['AVSCODE'] == "N") {
	newFailedTransaction($contact,"50000");
	exit("ERROR: Address did not verify");
}

if ($resArray['CVV2MATCH'] != "M") {
	newFailedTransaction($contact,"50001");
	exit("ERROR: CVV code does not match");
}

// Run sale for real
$authorizationID = $resArray['TRANSACTIONID'];

$nvpStr="&AUTHORIZATIONID=$authorizationID&AMT=$amount&COMPLETETYPE=Complete&CURRENCYCODE=$currencyCode";
$resArray=hash_call("DOCapture",$nvpStr);

if (isset($_POST['coupon']) and $_POST['coupon'] != "") {
	incrementCouponUsage($couponID);
}

$transactionID = newTransaction($resArray['TRANSACTIONID'],$contact,$productid,$amount);

require_once 'mailFunctions.php';

$subject = "Receipt from " . COMPANY_NAME;

$plainReceipt = RECEIPT_MESSAGE;
$plainReceipt = str_replace(array("##NAME##", "##PRODUCT##", "##CODE##", "##PRICE##"), array($firstName . " " . $lastName, $product, $transactionID, $amount), $plainReceipt);

$htmlReceipt = nl2br($plainReceipt);

$htmlReceipt = ereg_replace("[[:alpha:]]+://[^<>[:space:]]+[[:alnum:]/]", "<a href=\"\\0\">\\0</a>", $htmlReceipt);

boutique_mail($email,$subject,$plainReceipt,$htmlReceipt,TRUE);

$license = licenseForTransaction($transactionID,TRUE);

echo $license;

?>