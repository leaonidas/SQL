<html>
    <body>
        
        <?php
        
        /*opens session for global variables*/
        session_start();
        
        /*inputs*/
        $ass_vat=$_REQUEST['ass_vat'];
        $wbc=$_REQUEST['wbc'];
        $neut=$_REQUEST['neut'];
        $lym=$_REQUEST['lym'];
        $mono=$_REQUEST['mono'];
        $des=$_REQUEST['des'];
        
        /*auxiliar variable*/
        $a=0;
        
        /*auxiliar arrays*/
        $values=array("$wbc", "$neut", "$lym", "$mono");
        $names=array("white blood cells", "neutrophils", "lymphocytes", "monocytes");
        
        /*session info and PDO connection*/
        $host = "db.ist.utl.pt";
        $user = "ist176934";
        $pass = "zvdz4252";
        $dsn = "mysql:host=$host;dbname=$user";
        $connection = new PDO($dsn, $user, $pass);
        
        
        /*gets next procedure number*/
        $sql="select max(num) as max from procedures";
        $result=$connection->query($sql);
        $row=$result->fetch();
        $num=$row['max']+1;


        
        /*begins transaction*/
        $connection->beginTransaction();
        
        /*procedures table*/
        $sql="insert into procedures values ('{$_SESSION["name"]}',{$_SESSION["own_vat"]}, '{$_SESSION["date"]}', $num, '$des')";
        $row=$connection->exec($sql);
        
        if ($row==0)
        {
            $connection->rollback();
        }
        else
        {
            /*test_procedures table*/
            $sql="insert into test_procedures values ('{$_SESSION["name"]}',{$_SESSION["own_vat"]}, '{$_SESSION["date"]}', $num, 'blood')";
            $row=$connection->exec($sql);

            if ($row==0)
            {
                $connection->rollback();
            }
            else
            {
                /*all four produced indicators*/
                for ($i=0; $i<4; $i++)
                {
                    /*produced_indicator table*/
                    $sql="insert into produced_indicator values ('{$_SESSION["name"]}',{$_SESSION["own_vat"]}, '{$_SESSION["date"]}', $num, '$names[$i]', $values[$i])";
                    $row=$connection->exec($sql);

                    if ($row==0)
                    {
                        $connection->rollback();
                        $a=1;
                        break;
                    }
                }
                if($a==0) /*insersion of all four produced indicators successful*/
                {
                    if ($ass_vat != null) /*if there's any assistant vat to add*/
                    {
                        /*preformed table*/
                        $sql="insert into performed values ('{$_SESSION["name"]}',{$_SESSION["own_vat"]}, '{$_SESSION["date"]}', $num, '$ass_vat')";
                        $row=$connection->exec($sql);
            
                        if ($row==0)
                        {
                            $connection->rollback();
                        }
                        else
                        {
                            /*everything was inserted successfully with assistant vat*/
                            $connection->commit();
                            echo("Success!");
                        }
                    }
                    else
                    {
                        /*everything was inserted successfully without assistant vat*/
                        $connection->commit();
                        echo("Success!");
                    }
                }
            }
        }
            
        /*closes connection*/
        $connection=null;
        ?>
        
    </body>
</html>