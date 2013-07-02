<?php
/* get the incoming ID and password hash */
$user = $_POST["userid"];
$pass = sha1($_POST["password"]);

/* establish a connection with the database */
$server = mysql_connect("localhost", "jrtbcom", "aforest69") or die("could not connect to database");
//$server = mysql_connect("localhost", "mysql_user",
//          "mysql_password");
if (!$server) die(mysql_error());
mysql_select_db("jrtbcom_geo");
  
/* SQL statement to query the database */
$query = "SELECT * FROM Users WHERE User = '$user'
         AND Password = '$pass'";

//$query = "insert into Users (User, Password) values ('" . $_POST["userid"] . "','" . sha1($_POST["password"]) . "')";

//echo $query;

/* query the database */
$result = mysql_query($query);

/* Allow access if a matching record was found, else deny access. */
if (mysql_fetch_row($result)) {
  /* access granted */
  session_start();
  header("Cache-control: private");
  $_SESSION["access"] = "granted";
  header("Location: index.php");
} else {
  /* access denied &#8211; redirect back to login */
  header("Location: login2.php");
  
}
  
mysql_close($server);  
?>