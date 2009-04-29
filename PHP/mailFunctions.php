<?php
function boutique_mail ($to, $subject, $plain_body, $html_body="") {

	include_once 'Mail.php';
	include_once 'Mail/mime.php';

	$crlf = "\n";
	$message = new Mail_mime($crlf);
	
	if ($html_body != "") {
		$header = "<p><img src=\"logo.png\"></p>";
		$html_message = "<html><head>";
		$html_message .= "<style text=\"text/css\"><!-- ";
		$html_message .= file_get_contents("boutique-mail.css");
		$html_message .= " --></style></head><body>" . $header . $html_body . "</body></html>";
		$message->setHTMLBody($html_message);
		$message->addHTMLImage("logo.png", "image/png");
	}

	$message->setTXTBody($plain_body);

	$body = $message->get();
	$from_address = COMPANY_NAME . " <" . MAIL_FROM . ">";
	$extraheaders = array("From"=>$from_address, "Subject"=>$subject);
	$headers = $message->headers($extraheaders);

	$mail = Mail::factory("mail");
	$mail->send($to, $headers, $body);

}
?>