<?php
$path = '../';
set_include_path(get_include_path() . PATH_SEPARATOR . $path);
require_once 'auth.php';
require '../dbconnect.php';

$page_title = "Search";

require 'header.inc.php';

if (isset($_GET['q']) && $_GET['q'] != "") {
	$q = trim($_GET['q']);
	
} else {
	$q = "";
}

echo "<p>Enter a transaction ID, person name, email address, or product name</p>\n";
echo "<form method=\"get\" action=\"{$_SERVER['PHP_SELF']}\">\n";
echo "<p><input type=\"text\" value=\"$q\" name=\"q\" size=\"40\"> ";
echo "<input type=\"submit\" value=\"Search\"></p>\n";
echo "</form>\n";

if ($q != "") {
	while (strpos($q,"  ")) {
		$q = str_replace("  ", " ", $q);
	}
	$sql = "select transactions.id, firstName, lastName, name, paymentDate, gross, email, revoked, refund from transactions, products, contacts where transactions.item = products.id and transactions.contactId = contacts.id";
	$terms = explode(" ", $q);
	foreach ($terms as $term) {
		$esc_term = mysql_escape_string($term);
		$sql .= " and (firstName like '%$esc_term%' or lastName like '%$esc_term%' or name like '%$esc_term%' or transactions.id like '%$esc_term%' or email like '%$esc_term%')";
	}
	$sql .= " order by paymentDate";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	if (mysql_num_rows($query) === 0) {
		echo "<p>No transactions found</p>";
	} else {
		echo "<table>\n";
		echo "<tr><td>ID</td><td>Name</td><td>Email</td><td>Product</td><td>Date</td><td>Gross</td><td>Refund</td></tr>";
		while ($row = mysql_fetch_assoc($query)) {
			echo "<tr>";
			echo "<td>{$row['id']}</td>";
			echo "<td>{$row['firstName']} {$row['lastName']}</td>";
			echo "<td>{$row['email']}</td>";
			echo "<td>{$row['name']}</td>";
			echo "<td>{$row['paymentDate']}</td>";
			echo "<td>{$row['gross']}</td>";
			echo "<td>{$row['refund']}</td>";
			echo "<td>";
			if ($row['revoked'] == 1) echo "Y"; else echo "N";
			echo "</td>";
			if ($row['gross'] > 0) echo "<td><a href=\"refund.php?id={$row['id']}\">Refund</a></td>";
			echo "</tr>\n";
		}
		echo "</table>\n";
	}
}
	


require 'footer.inc.php';
?>