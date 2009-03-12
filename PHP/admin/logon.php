<?php
require 'session.php';

$page_title = "store logon";

require 'header.inc.php';

?>

<form action="logon2.php" method="post">
<fieldset>
<table>
<tr><td>username&nbsp;</td><td><input type="text" name="username" class="logon" size="16" tabindex="1"></td></tr>
<tr><td>password&nbsp;</td><td><input type="password" name="password" class="logon" size="16" tabindex="2"></td></tr>
<tr><td>&nbsp;</td>
<td><input class="button" type="submit" value="logon" name="logon" tabindex="3">&nbsp;<input class="button" type="reset" value="clear" name="reset" tabindex="4"></td></tr>
</table>
</fieldset>
</form>

<?php

require 'footer.inc.php';

?>