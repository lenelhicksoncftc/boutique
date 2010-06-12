<?php

//  issueFree.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

if (isset($_POST['firstname'])) {
	if ($_POST['firstname'] == "" OR $_POST['lastname'] == "" OR $_POST['email'] == "") {
		set_error("Please fill out the form completely");
	} else {
		require '../contactFunctions.php';
		require '../transactionFunctions.php';

		$contactID = IDforContactEmail($_POST['email']);
		if ($contactID === FALSE) {
			$contactID = newContact($_POST['firstname'],$_POST['lastname'],"","","","","","","","",$_POST['email'],"");
		}
		
		$sql = "select name,price from products where id = " . mysql_escape_string($_POST['product']);
		$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
		$product = mysql_result($query,0,"name");
		if ($_POST['price'] != "") $amount = $_POST['price']; else
			$amount = mysql_result($query,0,"price");
		
		$transactionID = newTransaction("",$contactID,$_POST['product'],$amount);

		require '../mailFunctions.php';

		$subject = "Receipt from " . COMPANY_NAME;

		$plainReceipt = RECEIPT_MESSAGE;
		$plainReceipt = str_replace(array("##NAME##", "##PRODUCT##", "##CODE##", "##PRICE##"), array($_POST['firstname'] . " " . $_POST['lastname'], $product, $transactionID, $amount), $plainReceipt);

		$htmlReceipt = nl2br($plainReceipt);

		$htmlReceipt = ereg_replace("[[:alpha:]]+://[^<>[:space:]]+[[:alnum:]/]",
                     "<a href=\"\\0\">\\0</a>", $htmlReceipt);

		boutique_mail ($_POST['email'], $subject, $plainReceipt, $htmlReceipt,TRUE);
		set_info("Paid license issued to " . $_POST['email']);

	}

}

$page_title = "Issue Paid License";

require 'header.inc.php';
?>
<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
<table>
<tr><td class="formlabel">First name:</td><td><input type="text" name="firstname" size="20"></td></tr>
<tr><td class="formlabel">Last name:</td><td><input type="text" name="lastname" size="20"></td></tr>
<tr><td class="formlabel">E-mail:</td><td><input type="text" name="email" size="50"></td></tr>
<tr><td class="formlabel">Product:</td><td><select name="product">
<?php 
$sql = "select id,name from products order by name";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
while ($row = mysql_fetch_row($query)) {
	echo "<option value=\"{$row[0]}\">{$row[1]}</option>";
}
?></select></td></tr>
<tr><td class="formlabel">Price:</td><td><input type="text" name="price" size="10"></td></tr>
<tr><td>&nbsp;</td><td><input type="submit" value="Issue license"></td></tr>
</table>
</form>
<?php

require 'footer.inc.php';
?>
