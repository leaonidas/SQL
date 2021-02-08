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
        
        /*creates session for storing global variables*/
        session_start();
        
        /*requests the inputs*/
        $num = (int)$_REQUEST['vat_num'];
        $own_name = $_REQUEST['own_name'];
        $an_name = $_REQUEST['anim_name'];
        
        /*stores vat number in session*/
        $_SESSION["cl_vat"]="$num";
        
        /*session info and PDO connection*/
        $host = "db.ist.utl.pt";
        $user = "ist176934";
        $pass = "zvdz4252";
        $dsn = "mysql:host=$host;dbname=$user";
        $connection = new PDO($dsn, $user, $pass);
        
        /*verifies if vat number is in client table*/
        $sql = "select VAT from client where VAT='$num'";
        $result = $connection->query($sql);
        $vatnum=$result->fetchColumn();
        $nrows=$result->rowCount();
        
        
        if ($nrows == 0) /*vat doesn't exist*/
        {
            echo("<p>VAT not found</p>");
            ?>
            <form>
                <input type="button" value="Return" onclick="history.back()">
            </form>
            <?php
        }
        else /*vat exists*/
        {
            /*verifies the name of owner and corresponding animal*/
            $sql="select name, vat from animal where name ='$an_name' and vat in (select vat from person where name like '%$own_name%')";
            $result = $connection->query($sql);
            $nrows=$result->rowCount();
            
            if ($nrows == 0) /*animal and owner don't exist*/
            {
                echo ("<p>Animal not found</p>");
                ?>
                <!--form for animal resistration-->
                <br><p>Register animal</p>
                <form action="execregister.php" method="post">
                    <p>Animal name:
                        <input type="text" name="anim_name"/>
                    </p>
                    <p>Specie:
                        <input type="text" name="specie"/>
                    </p>
                    <p>Colour:
                        <input type="text" name="colour"/>
                    </p>
                    <p>Gender:
                        <input type="radio" name="gender" value="F">Female
                    <input type="radio" name="gender" value="M">Male
                    </p>
                    <p>Birthday:
                        <input type="date" name="b_year"/>
                    </p>
                    <p><input type="submit" value="Register"/></p>
                </form>
                <?php
            }
            else
            {
                /*table*/
                ?>
                <table border>
                <tr>
                <th>Animal name</th>
                <th>Owner vat</th>
                </tr>
                    
                <?php
                foreach ($result as $row) /*show all corresponding animals*/
                {
                    echo("<tr>");
                    
                    echo("<td>{$row['name']}</td>");
                    echo("<td>{$row['vat']}</td>");
                    
                    /*creates link to page with all consults of corresponding animal*/
                    echo("<td><a href=\"showconsults.php?vat=");
                    echo($row['vat']);
                    echo("&name=");
                    echo($row['name']);
                    echo("\">Show consults</a></td> \n");
                    
                    echo("</tr>\n");
                }
                ?>
                    
                </table>
                <p></p>
        
                <!--return button -->
                <form>
                    <input type="button" value="Return" onclick="history.back()">
                </form>
                    
                <?php
            }
            
        }
        
        
        /*close connection*/
        $connection=null;
        ?>
        
    </body>
</html>