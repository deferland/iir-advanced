<?php

// MySql data (in case you want to save uploads log)
define('DB_HOST','localhost'); // host, usually localhost
define('DB_DATABASE','jrtbcom_geo'); // database name
define('DB_USERNAME','jrtbcom_geo'); // username
define('DB_PASSWORD','geo'); // password

$uploaddir = '/home/jrtbcom/upload/';

$instrument = $_GET['instrument'];

$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
mysql_select_db("jrtbcom_geo");
$query_get_c = "select * from audio where instrument = '" . $instrument . "' order by description";
//echo $query_get_c . "<br/>";
$result_get_c = mysql_query($query_get_c);
$num_rows = mysql_num_rows($result_get_c);

$numFiles = 0;
$totalSize = "";
$ids = "";
$names = "";
$descriptions = "";
$composers = "";
$performers = "";
$moreInfoURLs = "";

$c = 0;
while($row = mysql_fetch_assoc($result_get_c)){   
	$numFiles++;
	$totalSize .= $row['log_size'];
	$ids .= $row['log_id'];
	$names .= $row['name'];
	$descriptions .= $row['description'];
	$composers .= $row['composer'];
	$performers .= $row['performer'];
	$moreInfoURLs .= $row['moreInfoURL'];
	$c++;
	if ($c < $num_rows) {
		$totalSize .= "$";
		$ids .= "$";
		$names .= "$";
		$descriptions .= "$";
		$composers .= "$";
		$performers .= "$";
		$moreInfoURLs .= "$";
	}
	
}

echo $numFiles . '#$%' . $totalSize . '#$%' . $ids . '#$%' . $names . '#$%' . $descriptions . '#$%' . $composers . '#$%' . $performers . '#$%' . $moreInfoURLs;

?>
