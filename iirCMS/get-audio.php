<?php

// MySql data (in case you want to save uploads log)
define('DB_HOST','localhost'); // host, usually localhost
define('DB_DATABASE','jrtbcom_geo'); // database name
define('DB_USERNAME','jrtbcom_geo'); // username
define('DB_PASSWORD','geo'); // password

$uploaddir = '/home/jrtbcom/upload/';

$id = $_GET['id'];

$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
mysql_select_db("jrtbcom_geo");
$query_get_c = "select * from audio where log_id = '" . $id . "'";
//echo $query_get_c . "<br/>";
$result_get_c = mysql_query($query_get_c);
$row_get_c = mysql_fetch_assoc($result_get_c);
$file = $row_get_c['log_filename'];

if($file == '') {
die("File not found");
}
header("Content-Type: audio/mp3");
readfile($uploaddir.$file);
?>
