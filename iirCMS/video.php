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
      $sql = "select * from video";
      //echo $sql . "<br/>";
      $res = @mysql_query($sql);
      if (!$res) {
        $errors[] = "Could not run query.";
        break;
      }
      
      echo "<h2>Instruments In Reach Advanced Video Management System</h2>";
      
      echo "<p>Existing Video Recordings</p>";
      
      echo "<table cellspacing=3 cellpadding=3 border=0><tr bgcolor=bebebe><td>Video Name</td><td>Category</td><td>URL</td><td>More Info URL</td><td>Instrument</td><td bgcolor=FFFFFF>&nbsp;</td><td bgcolor=FFFFFF>&nbsp;</td></tr>";
      
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
      	echo "<td>" . $row['category'] . "</td>";
      	echo "<td>" . $row['url'] . "</td>";
      	echo "<td>" . $row['moreInfoURL'] . "</td>";
      	echo "<td>" . $row['instrument'] . "</td>";
      	echo "<td bgcolor=FFFFFF><a href=edit_video.php?id=" . $row['log_id'] . ">edit</a></td>";
      	echo "<td bgcolor=FFFFFF><a href=delete_video.php?id=" . $row['log_id'] . ">delete</a></td>";
      	echo "</tr>";
      }
      
      echo "</table>";
      
      echo "<p>Click <a href=add_video.php>here</a> to upload new video links.</p>";
      	
      @mysql_free_result($res);
      @mysql_close($link);


      
      
?>