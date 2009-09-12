<?php

//  coupons.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

$page_title = "Coupons";

require 'header.inc.php';

$sql = "select coupons.id, code, name, startDate, endDate, value, type, used, quantity from coupons, products where coupons.productId = products.id order by coupons.id desc";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
if (mysql_num_rows($query) > 0) {
	echo "<table>\n";
	echo "<tr><td>Code</td><td>Product</td><td>Start Date</td><td>End Date</td><td>Value</td><td>Type</td><td>Used</td></tr>\n";
	while ($row = mysql_fetch_row($query)) {
		echo "<tr>";
		echo "<td>$row[1]</td>";
		echo "<td>$row[2]</td>";
		echo "<td>$row[3]</td>";
		echo "<td>$row[4]</td>";
		echo "<td>$row[5]</td>";
		echo "<td>$row[6]</td>";
		echo "<td>$row[7]/$row[8]</td>";
		echo "<td><a href=\"editCoupon.php?id=$row[0]\">edit</a></td>";
		echo "</tr>\n";
	}
	echo "</table>";
}

echo "<p><a href=\"editCoupon.php\">New coupon</a></p>";

require 'footer.inc.php';
?>