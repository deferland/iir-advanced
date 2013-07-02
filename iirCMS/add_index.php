<?php

   $jrtb = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
   mysql_select_db("jrtbcom_geo");
   $query_get_c = "select * from locations";
   $result_get_c = mysql_query($query_get_c);
   $c = 0;
   while($row_get_c = mysql_fetch_assoc($result_get_c)){
      echo $c++ . " " . $row_get_c['name'] . "<br/>";
	  $query_update_i = "update locations set id = '" . $c . "' where address = '" . $row_get_c['address'] . "' and phone = '" . $row_get_c['phone'] . "'";
      $result_update_i = mysql_query($query_update_i);
   }
   
?>

	
