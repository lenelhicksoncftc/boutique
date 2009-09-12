<?php

//  index.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

require_once 'auth.php';

require 'header.inc.php';

$timeStamp = date('r'); //'M j, Y H:i:s');
echo("<p align=\"center\">Updated " . $timeStamp . "</p>\n");

require_once '../dbconnect.php';

echo "<div id=\"content\">\n";
echo "<div class=\"column\">\n";

$today = date('Y-m-d');
$days = 14;

if ($_GET) {
	$days = mysql_real_escape_string($_GET['days']);
}

echo "<h2>Last $days days</h2>\n";

$dateIndex = 0;
while ($dateIndex < $days) {
	$daysAgo = 0-$dateIndex;
	$daysAgoEnd = $daysAgo + 1;
	$query = "SELECT SUM(quantity), item, SUM(gross), SUM(refund), name FROM transactions, products WHERE (paymentDate >= DATE_ADD(DATE(NOW()),interval $daysAgo day) AND paymentDate < DATE_ADD(DATE(NOW()), INTERVAL $daysAgoEnd DAY)) AND paypaltransactionid is not null AND paypaltransactionid != '' AND transactions.item = products.id GROUP BY item ORDER BY name";
	$result = mysql_query($query);
	$numTransactions = mysql_num_rows($result);


	if ($numTransactions > 0) {
		$sales = mysql_result($result, 0, 0);
		$gross = mysql_result($result, 0, 2) - mysql_result($result, 0, 3);
	} else {
		$sales = 0;
		$gross = 0.00;
	}
	
	$displayDate = date('D, M j, Y',time()-($dateIndex*24*60*60));
	echo("<p><strong>$displayDate: $sales sales; \$$gross</strong>");
	
	if ($numTransactions > 0) {
		$detailIndex=0;
		while ($detailIndex < $numTransactions) {
			
			$count = mysql_result($result, $detailIndex, 0);
			$item = mysql_result($result, $detailIndex, 4);
			$total = mysql_result($result, $detailIndex, 2);
			$refunds = mysql_result($result, $detailIndex, 3);
			echo("<br>&nbsp;&nbsp;-&nbsp;$count&nbsp;&nbsp;$item&nbsp;&nbsp;\$$total (\$$refunds in refunds)");
			
			$detailIndex++;
		}
	}

	$dateIndex++;
	echo("</p>\n");
}


?>
</div> <!-- column -->
<div class="column">
<?

$months = 18;

if ($_GET) {
	$months = mysql_real_escape_string($_GET['months']);
}

echo "<h2>Last $months months</h2>\n";


$dateIndex = 0;
while ($dateIndex < $months) {
	$fromDate = mktime(0, 0, 0, date("m") - $dateIndex, 1, date("Y"));
	$queryFromDate = date('Y-m-d', $fromDate);
	$toDate = mktime(0, 0, 0, date("m") - $dateIndex + 1, 1, date("Y"));
	$queryToDate = date('Y-m-d', $toDate);

	// Overall sales
	
	$query = "SELECT SUM(quantity), SUM(gross), sum(refund) FROM transactions WHERE paymentDate >= '$queryFromDate' AND paymentDate < '$queryToDate' AND paypaltransactionid is not null AND paypaltransactionid != ''";

	$grossResult = mysql_query($query);
	$queryDate = date('M Y', $fromDate);

	$sales = mysql_result($grossResult, 0, 0);
	$gross = mysql_result($grossResult, 0, 1);
	$refunds = mysql_result($grossResult, 0, 2);

	$todayDisplay = date('M j, Y');
	echo("<p><strong>$queryDate: " .number_format($sales). " sales; \$" .number_format($gross). " gross (\$" .number_format($refunds). " in Refunds)</strong>");
	
	$dateIndex++;
}

echo "</div>\n";
echo "</div>\n";

require 'footer.inc.php';

?>