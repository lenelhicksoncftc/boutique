<?php

// Database Configuration

define (DB_NAME, "boutique");
define (DB_HOST, "localhost");
define (DB_USER, "storeuser");
define (DB_PASS, "");

// Company Configuration

define(COMPANY_NAME, "My Company");

define(MAIL_FROM, "me@mycompany.com");

// E-mail Templates

define(MAIL_LOGO, "/usr/local/apache2/htdocs/store/admin/images/logo.png");

// Address for BCC of receipts.  Leave empty for no BCC
define(MAIL_BCC, "me@mycompany.com");

$receiptMessage =
"Hello ##NAME##,

This is your purchase confirmation email for ##PRODUCT##. If you have not already downloaded ##PRODUCT## please do so now: http://mycompany.com/download

Your total cost after any coupons: \$##PRICE##

In the future, if you have to reinstall ##PRODUCT##, you do not need to purchase again.  Register by clicking the \"License Lookup\" button in the Purchase window and enter the transaction ID found below.


  Transaction ID: ##CODE##


Thank you for supporting My Company!

Best regards,

Big Wigg
My Company
http://mycompany.com";

define(RECEIPT_MESSAGE,$receiptMessage);

$freeMessage =
"Hello ##NAME##,

This is your confirmation email for a complimentary license of ##PRODUCT##. If you have not already downloaded ##PRODUCT## please do so now: http://mycompany.com/download

Register by clicking the \"License Lookup\" button in the Purchase window and enter the transaction ID found below.


  Transaction ID: ##CODE##


Thank you for supporting My Company!

Best regards,

Big Wigg
My Company
http://mycompany.com";

define(FREE_MESSAGE,$freeMessage);

/**
# API user: The user that is identified as making the call. you can
# also use your own API username that you created on PayPal's sandbox
# or the PayPal live site
*/

define('API_USERNAME', 'sdk-three_api1.sdk.com');

/**
# API_password: The password associated with the API user
# If you are using your own API username, enter the API password that
# was generated by PayPal below
# IMPORTANT - HAVING YOUR API PASSWORD INCLUDED IN THE MANNER IS NOT
# SECURE, AND ITS ONLY BEING SHOWN THIS WAY FOR TESTING PURPOSES
*/

define('API_PASSWORD', 'QFZCWN5HZM8VBG7Q');

/**
# API_Signature:The Signature associated with the API user. which is generated by paypal.
*/

define('API_SIGNATURE', 'A.d9eRKfd1yVkRrtmMfCFLTqa6M9AyodL0SJkhYztxUi8W9pCXF6.4NI');

/**
# Endpoint: this is the server URL which you have to connect for submitting your API request.
*/

define('API_ENDPOINT', 'https://api-3t.sandbox.paypal.com/nvp');
#define('API_ENDPOINT', 'https://api-3t.paypal.com/nvp');
/**
USE_PROXY: Set this variable to TRUE to route all the API requests through proxy.
like define('USE_PROXY',TRUE);
*/
define('USE_PROXY',FALSE);
/**
PROXY_HOST: Set the host name or the IP address of proxy server.
PROXY_PORT: Set proxy port.

PROXY_HOST and PROXY_PORT will be read only if USE_PROXY is set to TRUE
*/
define('PROXY_HOST', '127.0.0.1');
define('PROXY_PORT', '808');

/* Define the PayPal URL. This is the URL that the buyer is
   first sent to to authorize payment with their paypal account
   change the URL depending if you are testing on the sandbox
   or going to the live PayPal site
   For the sandbox, the URL is
   https://www.sandbox.paypal.com/webscr&cmd=_express-checkout&token=
   For the live site, the URL is
   https://www.paypal.com/webscr&cmd=_express-checkout&token=
   */
define('PAYPAL_URL', 'https://www.sandbox.paypal.com/webscr&cmd=_express-checkout&token=');

/**
# Version: this is the API version in the request.
# It is a mandatory parameter for each API request.
# The only supported value at this time is 2.3
*/

define('VERSION', '57.0');


?>
