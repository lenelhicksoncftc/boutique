<?php

//  products.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

$page_title = "Products";

require 'header.inc.php';

$sql = "select id,name,price,currency from products order by name";
$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
while ($row = mysql_fetch_row($query)) {
	echo "<p>$row[1] - $row[2] $row[3] <a href=\"editProduct.php?id=$row[0]\">edit</a></p>\n";
}
echo "<p><a href=\"editProduct.php\">New product</a></p>";

require 'footer.inc.php';
?>