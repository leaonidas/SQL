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
        
        /*variables from the previous page*/
        $name=$_REQUEST['name'];
        $vat=$_REQUEST['vat'];
        $cdate=$_REQUEST['date'];
        
        /*session info and PDO connection*/
        $host = "db.ist.utl.pt";
        $user = "ist176934";
        $pass = "zvdz4252";
        $dsn = "mysql:host=$host;dbname=$user";
        $connection = new PDO($dsn, $user, $pass);
        
        
        /*animal weight*/
        
        $sql="select weight from consult where date_timestamp='$cdate' and name='$name' and vat_owner='$vat'";
        $result=$connection->query($sql);
        $nrows=$result->rowCount();
        
        if ($nrows==0)
        {
            echo("<p>No weight info</p>");
        }
        
        else
        {   
            $row=$result->fetch();
            $weight=$row['weight'];
        }
        
        /*animal characteristics*/
        
        $sql="select species_name, colour, gender, age from animal where name='$name' and vat='$vat'";
        $result=$connection->query($sql);
        $nrows=$result->rowCount();
        
        if ($nrows==0)
        {
            echo("<p>No animal info</p>");
        }
        
        else
        {   
            $row=$result->fetch();
            /*table*/
            ?>
            <table border>
                <caption>Animal charasteristics</caption>
                <tr>
                    <th>Specie</th>
                    <th>Colour</th>
                    <th>Gender</th>
                    <th>Age</th>
                    <th>Weight</th>
                </tr>
                <tr>
                    <?php
                    echo("<td>{$row['species_name']}</td>");
                    echo("<td>{$row['colour']}</td>");
                    echo("<td>{$row['gender']}</td>");
                    echo("<td>{$row['age']}</td>");
                    echo("<td>{$weight}</td>");
                    ?>
                </tr>
            </table>
            <p></p>
            <?php
        }
        
        
        
        
        /*SOAP notes*/
        
        $sql="select sub, obj, asmnt, pln from consult where date_timestamp='$cdate' and name='$name' and vat_owner='$vat'";
        $result=$connection->query($sql);
        $nrows=$result->rowCount();
        
        if ($nrows==0)
        {
            echo("<p>No SOAP notes</p>");
        }
        
        else
        {    
            $row=$result->fetch();
            ?>
            <table border>
                <caption>SOAP notes</caption>
                <tr>
                    <th>Subjective</th>
                    <th>Objective</th>
                    <th>Assessment</th>
                    <th>Plan</th>
                </tr>
        
                <?php
                echo("<tr>");
                echo("<td>{$row['sub']}</td>");
                echo("<td>{$row['obj']}</td>");
                echo("<td>{$row['asmnt']}</td>");
                echo("<td>{$row['pln']}</td>");
                echo("</tr>");
                ?>

            </table>
            <p></p>
            <?php
        }
        
        
        
        /*diagnosis code*/
        
        $sql="select code, name from diagnosis_code where code in (select code from consultdiagnosis where date_timestamp='$cdate' and name='$name' and vat_owner='$vat')";
        $result=$connection->query($sql);
        
        $nrows=$result->rowCount();
        if ($nrows==0)
        {
            echo("<p>There´s no diagnosis</p>");
        }
        else
        {
            $row=$result->fetch();
            ?>
            <table border>
                <caption>Diagnosis</caption>
                <tr>
                    <th>Diagnosis code</th>
                    <th>Diagnosis name</th>
                </tr>
                <tr>
                    <?php
                    echo("<td>{$row['code']}</td>");
                    echo("<td>{$row['name']}</td>");
                    ?>
                </tr>
            </table>
            <p></p>
            <?php
        }
        
        
        
        /*prescriptions*/
        
        $sql="select name_med, lab, dosage, regime from prescription where date_timestamp='$cdate' and name='$name' and vat_owner='$vat'";
        $result=$connection->query($sql);
        
        $nrows=$result->rowCount();
        if ($nrows==0)
        {
            echo("<p>There´s no prescription</p>");
        }
        else
        {
            foreach($result as $row)
            {
                ?>
                <table border>
                    <caption>Prescription</caption>
                    <tr>
                        <th>Name</th>
                        <th>Laboratory</th>
                        <th>Dosage</th>
                        <th>Regime</th>
                    </tr>
                    <tr>
                        <?php
                        echo("<td>{$row['name_med']}</td>");
                        echo("<td>{$row['lab']}</td>");
                        echo("<td>{$row['dosage']}</td>");
                        echo("<td>{$row['regime']}</td>");
                        ?>
                    </tr>
                </table>
                <?php
            }
        }
        
        /*closes connection*/
        $connection=null;
        ?>
        
        <p></p>
        <!--return intup form-->
        <form>
            <input type="button" value="Return" onclick="history.back()">
        </form>
    
    </body>
</html>