<html>
    <body>
        
        <!-- form for adding a consult -->
        <form action="execonsult.php" method="post">
            <p>Veterinary VAT:
                <input type="number" name="vet_vat"/>
            </p>
            <p>Weight:
                <input type="number" name="weight"/>
            </p>
            <p>SOAP notes:</p>
            <p>Subjective:
                <input type="text" name="sub"/>
            </p>
            <p>Objective:
                <input type="text" name="obj"/>
            </p>
            <p>Assessment:
                <input type="text" name="asmnt"/>
            </p>
            <p>Plan:
                <input type="text" name="pln"/>
            </p>  
            <p><input type="submit" value="Add"/></p>
            
        </form>
    </body>
</html>