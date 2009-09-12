<?php

//  contactFunctions.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

function IDforContactEmail($email) {
	global $dbconnection;
	$sql = "select id from contacts where lower(email) = lower('" . mysql_escape_string($email) . "')";
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	if (mysql_num_rows($query) === 0) return FALSE; else return mysql_result($query,0,"id");
}

function newContact($firstname,$lastname,$company,$address,$address2,$city,$state,$zip,$country,$phone,$email,$website) {
	global $dbconnection;
	$newID = uniqid("CT");
	$sql = "insert into contacts (id,firstname,lastname,company,address,address2,city,state,zip,country,phone,email,website)".
	" values (".
	"'" . $newID . "'," .
	"'" . mysql_escape_string($firstname) . "'," .
	"'" . mysql_escape_string($lastname) . "'," .
	"'" . mysql_escape_string($company) . "'," .
	"'" . mysql_escape_string($address) . "'," .
	"'" . mysql_escape_string($address2) . "'," .
	"'" . mysql_escape_string($city) . "'," .
	"'" . mysql_escape_string($state) . "'," .
	"'" . mysql_escape_string($zip) . "'," .
	"'" . mysql_escape_string($country) . "'," .
	"'" . mysql_escape_string($phone) . "'," .
	"'" . mysql_escape_string($email) . "'," .
	"'" . mysql_escape_string($website) . "')";
	
	$query = mysql_query($sql) or exit("ERROR: " . mysql_error($dbconnection));
	
	return $newID;
}
?>