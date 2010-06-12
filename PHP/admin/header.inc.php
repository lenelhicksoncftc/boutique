<?php

if (isset($page_title) === FALSE) $page_title="Cocoa Boutique";

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><?php echo $page_title; ?></title>
<link rel="stylesheet" href="boutique.css" type="text/css">
<link rel="shortcut icon" href="favicon.ico" type="image/vnd.microsoft.icon">
<link rel="icon" href="favicon.ico" type="image/vnd.microsoft.icon">
</head>
<body>
<div id="wrapper">
<p><a href="index.php"><img src="images/logo.png" alt="Cocoa Boutique" border="0"></a></p>

<?php 

if (isset($_SESSION['error'])) {
	echo "<p class=\"error\">" . $_SESSION['error'] . "</p>\n";
	unset ($_SESSION['error']);
}
if (isset($_SESSION['info'])) {
	echo "<p class=\"info\">" . $_SESSION['info'] . "</p>\n";
	unset ($_SESSION['info']);
}

if (!$hideToolbar) {

?>

<p align="center"><a href="index.php">Home</a> &nbsp;<a href="products.php">Products</a> &nbsp;<a href="coupons.php">Coupons</a> &nbsp;<a href="search.php">Search</a> &nbsp;<a href="issueFree.php">Issue Free License</a> &nbsp;<a href="issuePaid.php">Issue Paid License</a></p>

<?php 

}

?>