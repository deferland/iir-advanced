<?php

session_start();
header("Cache-control: private");
if ($_SESSION["access"] != "granted")
  include_once('validate.php');

####################################################################
# File Upload Form 1.1
####################################################################
# For updates visit http://www.zubrag.com/scripts/
####################################################################

####################################################################
#  SETTINGS START
####################################################################

// Folder to upload files to. Must end with slash /
define('DESTINATION_FOLDER','/home/jrtbcom/upload/');

// Maximum allowed file size, Kb
// Set to zero to allow any size
define('MAX_FILE_SIZE', 0);

// Upload success URL. User will be redirected to this page after upload.
define('SUCCESS_URL','http://jrtb.com/iir/file-upload.php');

// Allowed file extensions. Will only allow these extensions if not empty.
// Example: $exts = array('avi','mov','doc');
$exts = array();

// rename file after upload? false - leave original, true - rename to some unique filename
define('RENAME_FILE', true);

// put a string to append to the uploaded file name (after extension);
// this will reduce the risk of being hacked by uploading potentially unsafe files;
// sample strings: aaa, my, etc.
define('APPEND_STRING', '');

// Need uploads log? Logs would be saved in the MySql database.
define('DO_LOG', true);

// MySql data (in case you want to save uploads log)
define('DB_HOST','localhost'); // host, usually localhost
define('DB_DATABASE','jrtbcom_geo'); // database name
define('DB_USERNAME','jrtbcom_geo'); // username
define('DB_PASSWORD','geo'); // password

/* NOTE: when using log, you have to create mysql table first for this script.
Copy paste following into your mysql admin tool (like PhpMyAdmin) to create table
If you are on cPanel, then prefix _uploads_log on line 205 with your username, so it would be like myusername_uploads_log

CREATE TABLE _uploads_log (
  log_id int(11) unsigned NOT NULL auto_increment,
  log_filename varchar(128) default '',
  log_size int(10) default 0,
  log_ip varchar(24) default '',
  log_date timestamp,
  PRIMARY KEY  (log_id),
  KEY (log_filename)
);

*/

####################################################################
###  END OF SETTINGS.   DO NOT CHANGE BELOW
####################################################################

// Allow script to work long enough to upload big files (in seconds, 2 days by default)
@set_time_limit(172800);

// following may need to be uncommented in case of problems
// ini_set("session.gc_maxlifetime","10800");

      // Establish DB connection
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
      
      $m_ip = mysql_real_escape_string($_SERVER['REMOTE_ADDR']);
      $m_size = $filesize;
      $m_fname = mysql_real_escape_string($dest_filename);
      $sql = "select * from audio";
      //echo $sql . "<br/>";
      $res = @mysql_query($sql);
      if (!$res) {
        $errors[] = "Could not run query.";
        break;
      }
      
      echo "<h2>Instruments In Reach Advanced Audio Recording Management System</h2>";
      
      echo "<p>Existing Audio Recordings</p>";
      
      echo "<table cellspacing=3 cellpadding=3 border=0><tr bgcolor=bebebe><td>Recording Name</td><td>Description</td><td>Composer</td><td>Performer</td><td>More Info URL</td><td>Instrument</td><td bgcolor=FFFFFF>&nbsp;</td><td bgcolor=FFFFFF>&nbsp;</td></tr>";
      
      $c=1;
      while($row = mysql_fetch_assoc($res)){   
      	if ($c == 1) {   
		    echo "<tr bgcolor=efefef>";
		    $c = 0;
      	} else {
      		echo "<tr bgcolor=dfdfdf>";
      		$c = 1;
      	}      	
      	echo "<td>" . $row['name'] . "</td>";
      	echo "<td>" . $row['description'] . "</td>";
      	echo "<td>" . $row['composer'] . "</td>";
      	echo "<td>" . $row['performer'] . "</td>";
      	echo "<td>" . $row['moreInfoURL'] . "</td>";
      	echo "<td>" . $row['instrument'] . "</td>";
      	echo "<td bgcolor=FFFFFF><a href=edit_audio.php?id=" . $row['log_id'] . ">edit</a></td>";
      	echo "<td bgcolor=FFFFFF><a href=delete_audio.php?id=" . $row['log_id'] . ">delete</a></td>";
      	echo "</tr>";
      }
      
      echo "</table>";
      
      echo "<p>Click <a href=file-upload.php>here</a> to upload new audio recordings.</p>";
      	
      //echo "<p>Note: To change the file associated with an Audio recording, you will need to delete the entry and create a new one.</p>";
      
      @mysql_free_result($res);
      @mysql_close($link);


      
      
?>