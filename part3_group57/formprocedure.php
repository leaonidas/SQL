<html>        
    <body>
        
        <?php
        /*stores date*/
        $timestamp=$_REQUEST['date'];
        session_start();
        $_SESSION["date"]="$timestamp";
        echo("{$_SESSION["date"]}");
        ?>
        
        <!-- form for adding a procedure -->
        <form action="execprocedure.php" method="post">
            <p>Procedure description:
                <input type="text" name="des"/>
            </p>
            <p></p>
            <p><b>Blood test results</b></p>
            <p>Assistant VAT:
                <input type="number" name="ass_vat"/>
            </p>
            <p>White blood cells (cells/L):
                <input type="number" name="wbc"/>
            </p>
            <p>Neutrophils (cells/L):
                <input type="number" name="neut"/>
            </p>
            <p>Lymphocytes (cells/L):
                <input type="number" name="lym"/>
            </p>
            <p>Monocytes (cells/L):
                <input type="number" name="mono"/>
            </p>
            <p><input type="submit" value="Add"/></p>
            
        </form>
    </body>
</html>