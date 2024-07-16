<?php
$ipOk = $_SERVER['REMOTE_ADDR'];

$link = mysqli_connect("localhost", "anysailcom_ass", "E5KDJ41KE_PgT7FT","anysailcom_ass");

if ($link == false){
    print("Error: Impossibility connecting to MySQL " . mysqli_connect_error());
}
else {
    //print("REAL THIS IS GOOD! and =");
    mysqli_set_charset($con, "utf8");

$id = 0;
if(isset($_GET["id"])){
    $id = $_GET["id"];
}
$device = 0;
if(isset($_GET["device"])){
    $device = $_GET["device"];
}
$cl = 0;
if(isset($_GET["cl"])){
    $cl = $_GET["cl"];
}

$typecl = 0;
if(isset($_GET["typecl"])){
    $typecl = $_GET["typecl"];
}

//echo "Name: $name <br> Age : $age";

$sql = 'INSERT INTO Clicks (Id_Client, Id_Device, Clicks, ip, ClickDate, TypeClick) VALUES ("'.$id.'", "'.$device.'", "'.$cl.'", "'.$ipOk.'", SYSDATE(), '.$typecl.')';

    $result = mysqli_query($link, $sql);

    if ($result == false) {
        //print("Error insert");
//        echo "<br> sql : $sql";
        print(-1);
    }
    else
    {
//        echo "<br> sql : $sql";
        print(1);
    }



}
?>