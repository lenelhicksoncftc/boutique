<?php

//  selfIssueFree.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require '../dbconnect.php';
$error = FALSE;
$hideToolbar = TRUE;

if (isset($_POST['firstname'])) {
if ($_POST['firstname'] == "" OR $_POST['lastname'] == "" OR $_POST['email'] == "") {
	set_error("Please fill out the form completely");
	$error=TRUE;
}
	
if(preg_match("/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/", $_POST['email'])){
	list($username,$userdomain)=split('@',$_POST['email']);
	$domains = explode(",",FREE_LICENSE_DOMAINS);
	$domainmatch = FALSE;
	foreach ($domains as $domain) {
		if ($domain == $userdomain) {
			$domainmatch = TRUE;
			break;
		}
	}
	if (!$domainmatch) {
		set_error("Your email domain is not approved for free licenses");
		$error=TRUE;
	}
} else {
	set_error("Please enter a valid e-mail address");
	$error=TRUE;
}
	 
if (!$error) {
	require '../contactFunctions.php';
	require '../transactionFunctions.php';
	
	$contactID = IDforContactEmail($_POST['email']);
	if ($contactID === FALSE) {
		$contactID = newContact($_POST['firstname'],$_POST['lastname'],"","","","","","","","",$_POST['email'],"");
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
	
	boutique_mail ($_POST['email'], "Your complimentary license", $plainReceipt, $htmlReceipt,TRUE);
	set_info("Free license issued to " . $_POST['email']);
	
}

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
$sql = "select id,name from products order by name";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
while ($row = mysql_fetch_row($query)) {
	echo "<option value=\"{$row[0]}\">{$row[1]}</option>";
}
?></select></td></tr>
<tr><td>&nbsp;</td><td><input type="submit" value="Issue license"></td></tr>
</table>
</form>
<?php

echo "<p>Free licenses of " . COMPANY_NAME . " software are available to those with e-mails in the following domains: " . str_replace(",",", ",FREE_LICENSE_DOMAINS) . "</p>\n";

require 'footer.inc.php';
?>
