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
 	!isset($_POST['product'])) {
	exit("ERROR: Missing parameter in POST request");
}

require_once 'CallerService.php';
session_start();

$paymentType = "Authorization";
$firstName = urlencode($_POST['firstName']);
$lastName = urlencode($_POST['lastName']);
$creditCardType = urlencode($_POST['creditCardType']);
$creditCardNumber = urlencode($_POST['creditCardNumber']);
$expDateMonth = urlencode($_POST['expDateMonth']);

// Month must be padded with leading zero
$padDateMonth = str_pad($expDateMonth, 2, '0', STR_PAD_LEFT);

$expDateYear = urlencode($_POST['expDateYear']);
$cvv2Number = urlencode($_POST['cvv2Number']);
$address1 = urlencode($_POST['address1']);
$city = urlencode($_POST['city']);
$state = urlencode($_POST['state']);
$postal = urlencode($_POST['postal']);
//$currencyCode=urlencode($_POST['currency']);
$currencyCode="USD";

$product = $_POST['product'];

require 'dbconnect.php';

$sql = "select id, price, publicKey, privateKey from products where name = '" . mysql_escape_string($product) . "'";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));

if (mysql_num_rows($query) === 0) exit("ERROR: Product not found");

$amount = mysql_result($query,0,"price");
$productid = mysql_result ($query,0,"id");
$key = mysql_result($query,0,"publicKey");
$privateKey = mysql_result($query,0,"privateKey");

/* Construct the request string that will be sent to PayPal.
   The variable $nvpstr contains all the variables and is a
   name value pair string with & as a delimiter */
$nvpstr="&PAYMENTACTION=$paymentType&AMT=$amount&CREDITCARDTYPE=$creditCardType&ACCT=$creditCardNumber&EXPDATE=".
$padDateMonth.$expDateYear."&CVV2=$cvv2Number&FIRSTNAME=$firstName&LASTNAME=$lastName&STREET=$address1&CITY=$city&STATE=$state".
"&ZIP=$postal&COUNTRYCODE=US&CURRENCYCODE=$currencyCode";

/* Make the API call to PayPal, using API signature.
   The API response is stored in an associative array called $resArray */
$resArray=hash_call("doDirectPayment",$nvpstr);

/* Display the API response back to the browser.
   If the response from PayPal was a success, display the response parameters'
   If the response was an error, display the errors received using APIError.php.
   */

$ack = strtoupper($resArray["ACK"]);

$email = $_POST['email'];

require 'contactFunctions.php';

$contact = IDforContactEmail($email);

if ($contact === FALSE) {
	$contact = newContact($firstName,$lastName,"",$address1,"",$city,$state,$postal,"","",$email,"");
}

require 'transactionFunctions.php';

if($ack!="SUCCESS")  {
	newFailedTransaction($contact,$resArray['L_ERRORCODE0']);
	exit("ERROR: " . $resArray['L_LONGMESSAGE0']);
}

$transactionID = newTransaction($resArray['TRANSACTIONID'],$contact,$productid,$amount);

$license = licenseForTransaction($transactionID);

echo $license;

?>