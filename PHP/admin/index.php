<?php

require_once 'auth.php';

require 'header.inc.php';

$timeStamp = date('r'); //'M j, Y H:i:s');
echo('<p align="center">Updated ' . $timeStamp . '</p>');

require_once '../dbconnect.php';

echo "<div id=\"content\">";
echo "<div class=\"column\">";

$today = date('Y-m-d');
$days = 14;

if ($_GET) {
	$days = mysql_real_escape_string($HTTP_GET_VARS['days']);
}

$dateIndex = 0;
while ($dateIndex < $days) {

	$query = "SELECT SUM(quantity), item, SUM(gross) FROM transactions WHERE paymentDate = DATE_SUB(NOW(), INTERVAL $dateIndex DAY) AND (paymentStatus = 'Completed' OR paymentStatus = 'Pending') AND paymentType != 'NFR' GROUP BY item ORDER BY item DESC";
	$result = mysql_query($query);
	$numTransactions = mysql_num_rows($result);


	if ($numTransactions > 0) {
		$query = "SELECT DATE_SUB(NOW(), INTERVAL $dateIndex DAY), SUM(quantity), SUM(gross) FROM transactions WHERE paymentDate = DATE_SUB(NOW(), INTERVAL $dateIndex DAY) AND (paymentStatus = 'Completed' OR paymentStatus = 'Pending') AND paymentType != 'NFR'";
		$grossResult = mysql_query($query);
		$queryDate = substr(mysql_result($grossResult, 0, 0), 0, 10);
		$sales = mysql_result($grossResult, 0, 1);
		$gross = mysql_result($grossResult, 0, 2);
	} else {
		$sales = 0;
		$gross = 0.00;
	}
	
	$todayDisplay = date('M j, Y');
	echo("<p><strong>$queryDate: $sales sales; \$$gross</strong>");
	
	if ($numTransactions > 0) {
		$detailIndex=0;
		while ($detailIndex < $numTransactions) {
			
			$count = mysql_result($result, $detailIndex, 0);
			$item = mysql_result($result, $detailIndex, 1);
			$total = mysql_result($result, $detailIndex, 2);
 
			$query = "SELECT COUNT(*) FROM transactions WHERE paymentDate = DATE_SUB(NOW(), INTERVAL $dateIndex DAY) AND paymentType = 'bulk' AND item = '$item'";
			$bulkResult = mysql_query($query) or die("MySQL error:" . mysql_error($bulkResult));
			$bulk = mysql_result($bulkResult, 0, 0);
			if ($bulk > 0) {
				$bulkString = " ($bulk promos)";
			} else {
				$bulkString = '';
			}
			
			echo("<br>&nbsp;&nbsp;-&nbsp;$count&nbsp;&nbsp;$item&nbsp;&nbsp;\$$total$bulkString");
			
			$detailIndex++;
		}
	}

	$query = "SELECT SUM(quantity), item, SUM(gross) FROM transactions WHERE paymentDate = DATE_SUB(NOW(), INTERVAL $dateIndex DAY) AND (paymentStatus = 'Refunded' OR paymentStatus = 'Denied') GROUP BY item ORDER BY item DESC";
	$result = mysql_query($query);
	$numRefunds = mysql_num_rows($result);

	if ($numRefunds > 0) {
		$query = "SELECT paymentDate, COUNT(*), SUM(gross) FROM transactions WHERE paymentDate = DATE_SUB(NOW(), INTERVAL $dateIndex DAY) AND (paymentStatus = 'Refunded' OR paymentStatus = 'Denied') GROUP BY paymentDate";
		$grossResult = mysql_query($query);
		$queryDate = mysql_result($grossResult, 0, 0);
		$sales = mysql_result($grossResult, 0, 1);
		$gross = mysql_result($grossResult, 0, 2);
		
		$todayDisplay = date('M j, Y');
		echo("<br>&nbsp;&nbsp;-&nbsp;$sales&nbsp;&nbsp;refunds; \$$gross");
	}
	$dateIndex++;
	echo("</p>");
}

$query = "SELECT  SUM(quantity), item, SUM(gross) FROM  `transactions` WHERE paymentStatus = 'Pending' GROUP BY item ORDER BY item DESC";
$result = mysql_query($query);
$num = mysql_num_rows($result);
if ($num > 0) {
	$query = "SELECT SUM(quantity), SUM(gross) FROM transactions WHERE paymentStatus = 'Pending'";
	$grossResult = mysql_query($query);
	$sales = mysql_result($grossResult, 0, 0);
	$gross = mysql_result($grossResult, 0, 1);
		
	echo("<p>$sales pending sales; \$$gross");
	$detailIndex=0;
	while ($detailIndex < $num) {
		
		$count = mysql_result($result, $detailIndex, 0);
		$item = mysql_result($result, $detailIndex, 1);
		$total = mysql_result($result, $detailIndex, 2);
		
		echo("<br>&nbsp;&nbsp;-&nbsp;$count&nbsp;&nbsp;$item&nbsp;&nbsp;\$$total</p>");
		
		$detailIndex++;
	}
	echo("</p>");
}

$query = "SELECT COUNT(*) FROM contacts WHERE id LIKE 'APL%'";
$appleResult = mysql_query($query);
$appleCount = mysql_result($appleResult, 0, 0);
echo("<p>Over $appleCount Apple employees served</p>");

?>
</div> <!-- column -->
<div class="column">
<?

$months = 18;

if ($_GET) {
	$months = mysql_real_escape_string($HTTP_GET_VARS['months']);
}

$dateIndex = 0;
while ($dateIndex < $months) {
	$fromDate = mktime(0, 0, 0, date("m") - $dateIndex, 1, date("Y"));
	$queryFromDate = date('Y-m-d', $fromDate);
	$toDate = mktime(0, 0, 0, date("m") - $dateIndex + 1, 1, date("Y"));
	$queryToDate = date('Y-m-d', $toDate);

	// Overall sales
	
	$query = "SELECT SUM(quantity), SUM(gross) FROM transactions WHERE paymentDate >= '$queryFromDate' AND paymentDate < '$queryToDate' AND (paymentStatus = 'Completed' OR paymentStatus = 'Pending') AND paymentType != 'NFR'";

	$grossResult = mysql_query($query);
	$queryDate = date('M Y', $fromDate);
	$sales = mysql_result($grossResult, 0, 0);
	$gross = mysql_result($grossResult, 0, 1);
	if ($sales > 0) $aveSale = round($gross / $sales, 2); else $aveSale = 0;
	
	$todayDisplay = date('M j, Y');
	echo("<p><strong>$queryDate: $sales sales; \$$gross; ave \$$aveSale</strong>");

	// Texas sales
	
	$query = "SELECT SUM(quantity), SUM(gross - fee), SUM(gross) FROM transactions JOIN contacts ON contacts.id = contactId WHERE contacts.state = 'TX' AND paymentDate >= '$queryFromDate' AND paymentDate < '$queryToDate' AND (paymentStatus = 'Completed' OR paymentStatus = 'Pending') AND paymentType != 'NFR'";

	$txResult = mysql_query($query);
//	echo 'result = ' . $txResult;
	$numRows = mysql_num_rows($txResult);
	if ($numRows > 0) {
		$sales = mysql_result($txResult, 0, 0);
		$net = mysql_result($txResult, 0, 1);
		$gross = mysql_result($txResult, 0, 2);
	} else {
		$sales = 0;
		$net = 0;
		$gross = 0;
	}
	
	$todayDisplay = date('M j, Y');
	echo("<br>&nbsp;&nbsp;-&nbsp;TX: $sales sales; \$$net net; \$$gross gross</p>");
	
	$dateIndex++;
/* 	echo("<br>"); */
}

require 'footer.inc.php';

?>