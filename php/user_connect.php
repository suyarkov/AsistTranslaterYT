<?php

$ipOk = $_SERVER['REMOTE_ADDR'];
//echo 'ip = ' . $ipOk;

$link = mysqli_connect("localhost", "anysailcom_ass", "E5KDJ41KE_PgT7FT","anysailcom_ass");

if ($link == false){
    print("-2;00 Error: Impossibility connecting to MySQL " . mysqli_connect_error()); // нет подключение к mysql
    exit;
}
else {
    //print("REAL THIS IS GOOD! and =");
    mysqli_set_charset($con, "utf8");
//    $Id_Client = 0;
    $name = "not set";
    
    if(isset($_GET["name"])){
        $name = $_GET["name"];
    }    
    $age = "not set";
    if(isset($_GET["age"])){
        $age = $_GET["age"];
    }
}

if ($age == null)
    $age = '98989797979879846545461321';

$Id_Client = 0;

if ($name != "not set") {
//    $sql = 'SELECT Id_Client, AvClicks, CountConnect, LastConnectDate  FROM AssMain WHERE upper(Email) = upper("'.$name.'") AND Email2 = "'.$age.'"';
    $sql = 'SELECT Id_Client, CountConnect, LastConnectDate  FROM AssMain WHERE upper(Email) = upper("'.$name.'")';
    $result = mysqli_query($link, $sql);
    $countm =0;
    if ($result != null) {
        $row = mysqli_fetch_array($result);
        $countm = mysqli_num_rows($result);
    };
    if ($countm == 1) {
        $Id_Client = $row['Id_Client'];
        $CountConnect = 0;
        $CountConnect = $row['CountConnect'];
        $LastConnectDate = $row['LastConnectDate'];
        if ($CountConnect == null)
            {
                $CountConnect = 0;
            };
            
        if ($CountConnect >= 3){
//            print('99;10'); // временная блокировка аккаунта
            if ((SYSDATE -$LastConnectDate)>0.01) { // четверть часа
            $CountConnect = 0;
            }
            else{
                print('0;01'); // временная блокировка аккаунта
                exit;
            }
        }
        
        $sql2 = 'SELECT Id_Client, AvClicks  FROM AssMain WHERE Id_Client = '.$Id_Client.' AND Email2 = "'.$age.'"';
        $result2 = mysqli_query($link, $sql2);  
        $countm2 = 0;
        if ($result2 != null)
        $row = mysqli_fetch_array($result2);
        $countm2 = mysqli_num_rows($result2);
        
        if ($countm2 == 1) {
            $Token = $row['Id_Client'];
            $AvClicks = $row['AvClicks'];
            if ($AvClicks == null)
                $AvClicks = 0;
            $sql =
            'update AssMain set LastConnectDate = SYSDATE(), CountConnect = 0, ip_last = "'.$ipOk.'" WHERE Id_Client = ("'.$Id_Client.'")';
            $result = mysqli_query($link, $sql);
            //print('1;'.$Token.';'.$AvClicks.';'.$CountConnect.';'.$LastConnectDate.';02');
            print('1;'.$Token.';'.$AvClicks.';02');
        }
        else
        {
            // пароль не верен, но говорить будем, что пароль не верен, нет такого логина{"Testing Add": "0","count": 1} 
            $CountConnect = $CountConnect + 1;
            $sql =
            'update AssMain set LastConnectDate = SYSDATE(), CountConnect = '.$CountConnect.', ip_last = "'.$ipOk.'" WHERE Id_Client = ("'.$Id_Client.'")';
            $result = mysqli_query($link, $sql);            
            print('-1;03');
        }
        
        
    } 
    else{
        print('-1;04'); // нет такого логина{"Testing Add": "0","count": 1} 
    }
}
else{
    print('-1;05');
}
    
?>