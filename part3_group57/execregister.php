<html>
    <body>
        <?php
        
        /*session info and PDO connection*/
        $host = "db.ist.utl.pt";
        $user = "ist176934";
        $pass = "zvdz4252";
        $dsn = "mysql:host=$host;dbname=$user";
        $connection = new PDO($dsn, $user, $pass);
        
        /*opens session for global variables*/
        session_start();
        
        /*requests the inputs*/
        $name = $_REQUEST['anim_name'];
        $specie = $_REQUEST['specie'];
        $colour = $_REQUEST['colour'];
        $gender = $_REQUEST['gender'];
        $b_year = $_REQUEST['b_year'];
        

        /*calculates the age with the birthday date*/
        $today=date("Y-m-d");
        $age=date_diff(date_create($today), date_create($b_year));
        
        /*inserts the data*/
        $sql="insert into animal values ('$name',{$_SESSION["cl_vat"]},'$specie','$colour','$gender','$b_year', {$age->format('%y')})";
        $row=$connection->exec($sql);
        
        if ($row==0)
        {
            /*returns to first page*/
            header("Location: formvat.php");
        }
        else
        {   
            echo('Animal regitered');
            ?>
            <form>
                <input type="button" value="Return" onclick="history_back()">
            </form>
            <?php
        }
        
        /*closes connection*/
        $connection=null;
        
        ?>
    </body>
</html>