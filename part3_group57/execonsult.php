<html>
    <body>
        
        <?php
        
        /*opens session for global variables*/
        session_start();
        
        /*inputs*/
        $vet_vat=$_REQUEST['vet_vat'];
        $weight=$_REQUEST['weight'];
        $sub=$_REQUEST['sub'];
        $obj=$_REQUEST['obj'];
        $asmnt=$_REQUEST['asmnt'];
        $pln=$_REQUEST['pln'];
        
        /*variables wiht current date and hour*/
        $today=date("Y-m-d");
        $hour=date("H:i:s");
        
        /*session info and PDO connection*/
        $host = "db.ist.utl.pt";
        $user = "ist176934";
        $pass = "zvdz4252";
        $dsn = "mysql:host=$host;dbname=$user";
        $connection = new PDO($dsn, $user, $pass);
        
        
        /*inserts the data*/
        $sql="insert into consult values ('{$_SESSION["name"]}',{$_SESSION["own_vat"]},'$today $hour','$sub','$obj','$asmnt', '$pln', {$_SESSION["cl_vat"]}, $vet_vat, $weight)";
        $row=$connection->exec($sql);
        
        if ($row==0)
        {
            /*returns to the first page*/
            header("Location: formvat.php");
        }
        else
        {   
            echo('Success!');
        }
        
        /*closes connection*/
        $connection=null;
        
        ?>
        
    </body>
</html>