<?php

session_start();
header("Cache-control: private");
if ($_SESSION["access"] != "granted")
  include_once('validate.php');
?>

IIR Web CMS Top Level Menu<ul>
<li><a href="audio.php">Audio</a></li>
<li><a href="video.php">Video</a></li>
</ul>