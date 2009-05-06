<?php
function boutique_mail ($to, $subject, $plain_body, $html_body="", $bcc=FALSE) {

	include_once 'Mail.php';
	include_once 'Mail/mime.php';

	$crlf = "\n";
	$message = new Mail_mime($crlf);
	
	if ($html_body != "") {
		$header = "<p><img src=\"". MAIL_LOGO . "\"></p>";
		$html_message = "<html><head>";
		$html_message .= "<style text=\"text/css\"><!-- ";
		$html_message .= file_get_contents("boutique-mail.css",TRUE);
		$html_message .= " --></style></head><body>" . $header . "<p>" . $html_body . "</p>" . "</body></html>";
		$message->setHTMLBody($html_message);
		$message->addHTMLImage(MAIL_LOGO, "image/png");
	}

	$message->setTXTBody($plain_body);

	$body = $message->get();
	$from_address = COMPANY_NAME . " <" . MAIL_FROM . ">";
	$extraheaders = array("To" => $to, "From" => $from_address, "Subject" => $subject);

	$mail = Mail::factory("mail");
	if ($bcc and MAIL_BCC != "") {
		$extraheaders['Bcc'] = MAIL_BCC;	
	}
	$headers = $message->headers($extraheaders);
	$mail->send($to, $headers, $body);

}
?>