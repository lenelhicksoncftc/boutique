<?php
$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

if (isset($_POST['name'])) {
	$id = $_POST['id'];
	$name = $_POST['name'];
	$des = $_POST['des'];
	$price = $_POST['price'];
	$currency = $_POST['currency'];
	$pubKey = $_POST['pubKey'];
	$privKey = $_POST['privKey'];
	
	if ($_POST['act'] == "edit") {
		$sql = "delete from products where id = '" . mysql_escape_string($id) . "'";
		$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	}

	$sql = "insert into products (id,name,description,price,currency,publicKey,privateKey) values (" .
		"'" . mysql_escape_string($id) . "', " .
		"'" . mysql_escape_string($name) . "', " .
		"'" . mysql_escape_string($des) . "', " .
		mysql_escape_string($price) . "," .
		"'" . mysql_escape_string($currency) . "', " .
		"'" . mysql_escape_string($pubKey) . "', " .
		"'" . mysql_escape_string($privKey) . "')";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	if ($query) {
		set_info("Product $name added successfully");
	} else {
		set_error("Error adding/product $name");
	}
	
	header("Location: products.php");
	exit();
		
}

if (isset($_GET['id'])) {
	$id = $_GET['id'];
	$sql = "select name,price,currency,description,publicKey,privateKey from products where id=" . mysql_escape_string($id);
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	$name = mysql_result($query,0,'name');
	$des = mysql_result($query,0,'description');
	$price = mysql_result($query,0,'price');
	$currency = mysql_result($query,0,'currency');
	$pubKey = mysql_result($query,0,'publicKey');
	$privKey = mysql_result($query,0,'privatekey');
	$action = "edit";
} else {
	$id = "";
	$name = "";
	$des = "";
	$price = "";
	$currency = "";
	$pubKey = "";
	$privKey = "";
	$action = "new";
}

$page_title = "Edit Product";

require 'header.inc.php';
echo "<form method=\"post\" action=\"{$_SERVER['PHP_SELF']}\">";
echo "<input type=\"hidden\" name=\"act\" value=\"$action\">\n";
echo "<table>\n";
echo "<tr><td class=\"formlabel\">Unique ID</td><td><input name=\"id\" type=\"text\" value=\"$id\"";
if ($action == "edit") echo " readonly ";
echo "></td></tr>\n";
echo "<tr><td class=\"formlabel\">Name</td><td><input name=\"name\" type=\"text\" value=\"$name\"></td></tr>\n";
echo "<tr><td class=\"formlabel\">Price</td><td><input name=\"price\" type=\"text\" value=\"$price\"></td></tr>\n";
echo "<tr><td class=\"formlabel\">Currency</td><td><input name=\"currency\" type=\"text\" value=\"$currency\"> <a href=\"https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_nvp_currency_codes\" target=\"_blank\">Currency codes</a></td></tr>\n";
echo "<tr><td class=\"formlabel\">Description</td><td><input name=\"des\" type=\"text\" value=\"$des\" size=\"40\"></td></tr>\n";
echo "<tr><td class=\"formlabel\" valign=\"top\">Public Key</td><td><textarea name=\"pubKey\" cols=\"80\" rows=\"6\">$pubKey</textarea></td></tr>\n";
echo "<tr><td class=\"formlabel\" valign=\"top\">Private Key</td><td><textarea name=\"privKey\" cols=\"80\" rows=\"6\">$privKey</textarea></td></tr>\n";
echo "<tr><td colspan=\"2\"><input type=\"submit\" value=\"Save\"></td></tr>\n";

echo "</table>\n";
echo "</form>\n";
require 'footer.inc.php';
?>