<?php
session_start();
header("Cache-control: private");
if ($_SESSION["access"] != "granted")
  include_once('validate.php');
  
// MySql data (in case you want to save uploads log)
define('DB_HOST','localhost'); // host, usually localhost
define('DB_DATABASE','jrtbcom_geo'); // database name
define('DB_USERNAME','jrtbcom_geo'); // username
define('DB_PASSWORD','geo'); // password


// Upload success URL. User will be redirected to this page after upload.
define('SUCCESS_URL','http://jrtb.com/iir/video.php');

      	$oldvideofile = "";
      	$oldvideofile = $_GET['id'];

      	if ($oldvideofile != "") {
     	
			$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
			mysql_select_db("jrtbcom_geo");
			$query = "delete from video where log_id = '" . $oldvideofile . "'";
			//echo $query . "<br/>";
			$res2 = mysql_query($query);
			
      	}

      	header('Location: ' . SUCCESS_URL);

?>
