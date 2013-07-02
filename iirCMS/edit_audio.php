<?php
session_start();
header("Cache-control: private");
if ($_SESSION["access"] != "granted")
  include_once('validate.php');
  
// Upload success URL. User will be redirected to this page after upload.
define('SUCCESS_URL','http://jrtb.com/iir/video.php');

// MySql data (in case you want to save uploads log)
define('DB_HOST','localhost'); // host, usually localhost
define('DB_DATABASE','jrtbcom_geo'); // database name
define('DB_USERNAME','jrtbcom_geo'); // username
define('DB_PASSWORD','geo'); // password

// Allow script to work long enough to upload big files (in seconds, 2 days by default)
@set_time_limit(172800);

?>

<form method="post" action="file-upload.php" enctype="multipart/form-data">

<table cellspacing=3 cellpadding=3 border=0>

<?php

$id = $_GET['id'];

$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
mysql_select_db("jrtbcom_geo");
$query_get_c = "select * from audio where log_id = '" . $id . "' order by description";
//echo $query_get_c . "<br/>";
$result_get_c = mysql_query($query_get_c);
$num_rows = mysql_num_rows($result_get_c);

$c = 0;
while($row = mysql_fetch_assoc($result_get_c)){   

?>
	
<tr><td>Instrument:</td><td>
<select name="instrument" size="1">
  <option value="<?php echo $row['instrument']; ?>"><?php echo $row['instrument']; ?></option>
  <option value="flute">Flute</option>
  <option value="trumpet">Trumpet</option>
  <option value="saxophone">Saxophone</option>
  <option value="trombone">Trombone</option>
</select>
</td></tr>
<tr><td>Recording Name:</td><td><input type="text" name="name" size="25" value="<?php echo $row['name']; ?>"></td></tr>
<tr><td>Description:</td><td><textarea cols="50" rows="4" name="desc"><?php echo $row['description']; ?></textarea></td></tr>
<tr><td>Composer:</td><td><textarea cols="50" rows="4" name="composer"><?php echo $row['composer']; ?></textarea></td></tr>
<tr><td>Performer(s):</td><td><textarea cols="50" rows="4" name="performer"><?php echo $row['performer']; ?></textarea></td></tr>
<tr><td>More Info URL:</td><td><textarea cols="50" rows="4" name="moreInfoURL"><?php echo $row['moreInfoURL']; ?></textarea></td></tr>

<input type=hidden name=oldaudiofile value="<?php echo $row['log_id']; ?>">

<tr><td>Please select audio file to upload: </td><td><input type="file" size="20" name="filename"></td></tr>

<?php
	}
?>

</table>  

<input type="submit" value="Edit audio recording information" name="submit">

</form>
