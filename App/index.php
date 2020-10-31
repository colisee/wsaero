<?php

$agent = $_SERVER['HTTP_USER_AGENT'];

if (stristr($agent,'android')) {
      header('Location: mobile.html');
} elseif (stristr($agent,'iphone')) {
      header('Location: mobile.html');
  } else {
      header('Location: mobile.html');
} 

?>
