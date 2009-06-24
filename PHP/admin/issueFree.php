<?php
$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

if (isset($_POST['firstname'])) {
	if ($_POST['firstname'] == "" OR $_POST['lastname'] == "" OR $_POST['email'] == "") {
		set_error("Please fill out the form completely");
	}
	require '../contactFunctions.php';
	require '../transactionFunctions.php';
	
	$contactID = IDforContactEmail($_POST['email']);
	if ($contactID === FALSE) {
		$contactID = newContact($_POST['firstname'],$_POST['firstname'],"","","","","","","","",$_POST['email'],"");
	}
	$transactionID = newTransaction("",$contactID,$_POST['product'],0);
	
	require '../mailFunctions.php';
	
	$sql = "select name from products where id = " . mysql_escape_string($_POST['product']);
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	$product = mysql_result($query,0,"name");
	
	$plainReceipt = FREE_MESSAGE;
	$plainReceipt = str_replace(array("##NAME##", "##PRODUCT##", "##CODE##"), array($_POST['firstname'] . " " . $_POST['lastname'], $product, $transactionID), $plainReceipt);

	$htmlReceipt = nl2br($plainReceipt);

	$htmlReceipt = ereg_replace("[[:alpha:]]+://[^<>[:space:]]+[[:alnum:]/]",
                     "<a href=\"\\0\">\\0</a>", $htmlReceipt);
	
	boutique_mail ($_POST['email'], "Your free license", $plainReceipt, $htmlReceipt);
	set_info("Free license issued to " . $_POST['email']);
	
}

$page_title = "Issue Free License";

require 'header.inc.php';
?>
<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
<table>
<tr><td class="formlabel">First name:</td><td><input type="text" name="firstname" size="20"></td></tr>
<tr><td class="formlabel">Last name:</td><td><input type="text" name="lastname" size="20"></td></tr>
<tr><td class="formlabel">E-mail:</td><td><input type="text" name="email" size="50"></td></tr>
<tr><td class="formlabel">Product:</td><td><select name="product">
<?php 
$sql = "select id,name from products";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
while ($row = mysql_fetch_row($query)) {
	echo "<option value=\"{$row[0]}\">{$row[1]}</option>";
}
?></select></td></tr>
<tr><td>&nbsp;</td><td><input type="submit" value="Issue license"></td></tr>
</table>
</form>
<?php

require 'footer.inc.php';
?>