<?php
$session_length = 14400;
$session_name = "store_session";


session_name($session_name);
session_set_cookie_params($session_length);
session_start();
?>