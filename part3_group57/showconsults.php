<html>
        <head>
        <style>
            table, th, td 
            {
                border: 1px solid black;
                border-collapse: collapse;
            }
            th, td 
            {
                padding: 5px;
                text-align: left;
            }
        </style>
    </head>
    <body>
        <?php
        
        /*inputs*/
        $vat = $_REQUEST['vat'];
        $name = $_REQUEST['name'];
        
        /*session info and PDO connection*/
        $host = "db.ist.utl.pt";
        $user = "ist176934";
        $pass = "zvdz4252";
        $dsn = "mysql:host=$host;dbname=$user";
        $connection = new PDO($dsn, $user, $pass);

        /*gets the consult timestamp*/
        $sql="select date_timestamp from consult where VAT_owner='$vat' and name='$name'";
        $result=$connection->query($sql);
        
        /*verifies if there's any consult*/
        $nrows = $result->rowCount();
        if ($nrows==0)
        {
            echo("<p>No consults</p>");
        }
        else
        {
            /*table*/
            ?>
            <table border>
            <tr>
            <th>Consult date</th>
            </tr>

            <?php
            foreach ($result as $row) 
            {
                echo("<tr>");

                echo("<td>{$row['date_timestamp']}</td>");

                /*link to show consult's info*/
                echo("<td><a href=\"showinfo.php?date=");
                echo($row['date_timestamp']);
                echo("&vat=");
                echo($vat);
                echo("&name=");
                echo($name);
                echo("\">Show info</a></td> \n");
                
                /*link to add a procedure to a consult*/
                echo("<td><a href=\"formprocedure.php?date=");
                echo($row['date_timestamp']);
                echo("&vat=");
                echo($vat);
                echo("&name=");
                echo($name);
                echo("\">Enter blood test result</a></td> \n");
                

                echo("</tr>\n");
            }
            ?>
            </table>
            <?php
        }   
        
        /*save animal name in session*/
        session_start();
        $_SESSION["name"]="$name";
        $_SESSION["own_vat"]="$vat";
        
        
        ?>
        <p></p>
        <!--goes to a form to add a consult-->
        <form action="formconsult.php" method="post">
            <p><input type="submit" value="Add consult"/></p>
        </form>
        <?php
        
        /*closes connection*/ 
        $connection=null;
        ?>

    </body>
</html>