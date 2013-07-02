<?php

// MySql data (in case you want to save uploads log)
define('DB_HOST','localhost'); // host, usually localhost
define('DB_DATABASE','jrtbcom_geo'); // database name
define('DB_USERNAME','jrtbcom_geo'); // username
define('DB_PASSWORD','geo'); // password

$instrument = $_GET['instrument'];

$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
mysql_select_db("jrtbcom_geo");
$query_get_c = "select * from video where instrument = '" . $instrument . "' order by name";
//echo $query_get_c . "<br/>";
$result_get_c = mysql_query($query_get_c);
$num_rows = mysql_num_rows($result_get_c);

$numFiles = 0;
$ids = "";
$names = "";
$urls = "";
$moreInfoURLs = "";
$categories = "";

$c = 0;
while($row = mysql_fetch_assoc($result_get_c)){   
	$numFiles++;
	$ids .= $row['log_id'];
	$names .= $row['name'];
	$urls .= $row['url'];
	$moreInfoURLs .= $row['moreInfoURL'];
	$categories .= $row['category'];
	$c++;
	if ($c < $num_rows) {
		$ids .= "$";
		$names .= "$";
		$urls .= "$";
		$moreInfoURLs .= "$";
		$categories .= "$";
	}
	
}

echo $numFiles . '#$%' . $ids . '#$%' . $names . '#$%' . $urls . '#$%' . $moreInfoURLs . '#$%' . $categories;

?>
