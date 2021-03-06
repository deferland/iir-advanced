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

// show upload form
if (!isset($_POST['submit'])) {

?>

<form method="post" enctype="multipart/form-data">

<table cellspacing=3 cellpadding=3 border=0>

<?php
	
$id = $_GET['id'];

$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
mysql_select_db("jrtbcom_geo");
$query_get_c = "select * from video where log_id = '" . $id . "'";
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
<tr><td>Video Name:</td><td><input type="text" name="name" size="25" value="<?php echo $row['name']; ?>"></td></tr>
<tr><td>Video Category:</td><td><input type="text" name="category" size="25" value="<?php echo $row['category']; ?>"></td></tr>
<tr><td>Video URL:</td><td><textarea cols="50" rows="4" name="url"><?php echo $row['url']; ?></textarea></td></tr>
<tr><td>More Info URL:</td><td><textarea cols="50" rows="4" name="moreInfoURL"><?php echo $row['moreInfoURL']; ?></textarea></td></tr>

<input type=hidden name=oldvideofile value="<?php echo $row['log_id']; ?>">

<?php
	}
?>

</table>  

<input type="submit" value="Edit video link" name="submit">
</form>

<?php

// process file upload
} else {
        
	$link = @mysql_connect(DB_HOST, DB_USERNAME, DB_PASSWORD);
      if (!$link) {
        $errors[] = "Could not connect to mysql.";
        break;
      }
      $res = @mysql_select_db(DB_DATABASE, $link);
      if (!$res) {
        $errors[] = "Could not select database.";
        break;
      }	
	
      $name = mysql_real_escape_string($_POST['name']);
      $category = mysql_real_escape_string($_POST['category']);
      $url = $_POST['url'];
      $instrument = $_POST['instrument'];
      $moreInfoURL = $_POST['moreInfoURL'];
      
      $m_ip = mysql_real_escape_string($_SERVER['REMOTE_ADDR']);

      $sql = "insert into video (log_ip,name,category,url,instrument,moreInfoURL) values ('$m_ip','$name','$category','$url','$instrument','$moreInfoURL')";
      //echo $sql . "<br/>";
      $res = @mysql_query($sql);
      if (!$res) {
        $errors[] = "Could not run query.";
        break;
      } else {
      	
      	$oldvideofile = "";
      	$oldvideofile = $_POST['oldvideofile'];

      	if ($oldvideofile != "") {
     	
			$jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
			mysql_select_db("jrtbcom_geo");
			$query = "delete from video where log_id = '" . $oldvideofile . "'";
			//echo $query . "<br/>";
			$res2 = mysql_query($query);
			
      	}
      }
      @mysql_free_result($res);
      @mysql_close($link);

    // redirect to upload success url
    header('Location: ' . SUCCESS_URL);
    die();

    break;

}

?>