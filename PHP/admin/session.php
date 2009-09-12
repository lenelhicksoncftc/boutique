<?php

//  session.php
//
//  Copyright © 2009 Sweeter Rhythm LLC/No Thirst Software LLC/Atomic Bird LLC
//  All rights reserved.
//  BSD License http://www.opensource.org/licenses/bsd-license.php

$session_length = 14400;
$session_name = "cocoa_boutique_session";


session_name($session_name);
session_set_cookie_params($session_length);
session_start();
?>