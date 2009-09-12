<?php

//  editCoupon.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

if (isset($_POST['code'])) {
	$id = $_POST['id'];
	$code = $_POST['code'];
	$productId = $_POST['product'];
	$startDate = $_POST['startDate'];
	$endDate = $_POST['endDate'];
	$value = $_POST['value'];
	$type = $_POST['type'];
	$quantity = $_POST['quantity'];
	$act = $_POST['act'];
	
	switch ($act) {
		case "new":
			$sql = "insert into coupons (code,productId,startDate,endDate,value,type,quantity) values (".
			"'" . mysql_escape_string($code) . "', " .
			"'" . mysql_escape_string($productId) . "', " .
			"'" . mysql_escape_string($startDate) . "', " .
			"'" . mysql_escape_string($endDate) . "', " .
			mysql_escape_string($value) . ", " .
			"'" . mysql_escape_string($type) . "', " .
			mysql_escape_string($quantity) . ")";
			break;
		case "edit":
			$sql = "update coupons " .
			"set code = '" . mysql_escape_string($code) . "', " .
			"productId = '" . mysql_escape_string($productId) . "', " .
			"startDate = '" . mysql_escape_string($startDate) . "', " .
			"endDate = '" . mysql_escape_string($endDate) . "', " .
			"value = " . mysql_escape_string($value) . ", " .
			"type = '" . mysql_escape_string($type) . "', " .
			"quantity = " . mysql_escape_string($quantity) . " " .
			"where id = " . mysql_escape_string($id);
			break;
		default:
			exit("ERROR: No action specified");
	
	}
	
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));

	if ($query) {
		set_info("Coupon $code added successfully");
	} else {
		set_error("Error adding coupon $code");
	}
	
	header("Location: coupons.php");
	exit();

}

if (isset($_GET['id'])) {
	$id = $_GET['id'];
	$sql = "select code, productId,startDate,endDate,value,type,quantity from coupons where id = $id";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	$code = mysql_result($query,0,'code');
	$productId = mysql_result($query,0,'productId');
	$startDate = mysql_result($query,0,'startDate');
	$endDate = mysql_result($query,0,'endDate');
	$value = mysql_result($query,0,'value');
	$type = mysql_result($query,0,'type');
	$quantity = mysql_result($query,0,'quantity');
	$action = "edit";
} else {
	$id = "";
	$code = "";
	$productId = "";
	$startDate = date("Y-m-d H:i:s");
	$endDate = date("Y-m-d H:i:s", strtotime("+1 month"));
	$value = "10";
	$type = "p";
	$quantity = "100";
	$action = "new";
}

$page_title = "Edit Coupon";

require 'header.inc.php';
echo "<form method=\"post\" action=\"{$_SERVER['PHP_SELF']}\">\n";
echo "<input type=\"hidden\" name=\"id\" value=\"$id\">\n";
echo "<input type=\"hidden\" name=\"act\" value=\"$action\">\n";
echo "<table>\n";
echo "<tr><td class=\"formlabel\">Coupon Code</td><td><input name=\"code\" type=\"text\" value=\"$code\"></td></tr>\n";
echo "<tr><td class=\"formlabel\">Product</td><td>";
echo "<select name=\"product\">";
$sql = "select id,name from products order by name";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
while ($row = mysql_fetch_row($query)) {
	echo "<option value=\"{$row[0]}\"";
	if ($productId == $row[0]) echo " selected";
	echo ">{$row[1]}</option>";
}
echo "</select></td></tr>\n";
echo "<tr><td class=\"formlabel\">Start Date</td><td><input name=\"startDate\" type=\"text\" value=\"$startDate\"></td></tr>\n";
echo "<tr><td class=\"formlabel\">End Date</td><td><input name=\"endDate\" type=\"text\" value=\"$endDate\"></td></tr>\n";
echo "<tr><td class=\"formlabel\">Value</td><td><input name=\"value\" type=\"text\" value=\"$value\"></td></tr>\n";
echo "<tr><td class=\"formlabel\">Type</td><td>";
echo "<select name=\"type\">";
echo "<option value=\"p\"";
if ($type == "p") echo " selected";
echo ">Percentage</option>\n";
echo "<option value=\"a\"";
if ($type == "a") echo " selected";
echo ">Amount Off</option>\n";
echo "</select></td></tr>\n";
echo "<tr><td class=\"formlabel\">Quantity</td><td><input name=\"quantity\" type=\"text\" value=\"$quantity\"></td></tr>\n";
echo "<tr><td colspan=\"2\"><input type=\"submit\" value=\"Save\"></td></tr>\n";
echo "</table>";
echo "</form>";
require 'footer.inc.php';

?>