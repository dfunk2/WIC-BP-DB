<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SQL Query Executor</title>
    </head>
    <body>
        <h1>WIC BREASTPUMP DATABASE</h1>

        <!--user's query is sent using post method to same site-->
        <form method="post" action="">
        <label for="sql_query">Enter SQL Query:</label><br>
            <!-- id linked to label-->
            <!-- create textbox-->
            <textarea id="sql_query" name="sql_query" rows="4" cols="50"></textarea><br>
            <input type="submit" name="submit" value="Submit">
        </form>
<?php     

  $db_host = 'localhost'; 
  $db_user = 'root';
  $db_password = 'root';
  $db_db = 'WIC_BP_DB';

   
  //creat connection
  $mysqli = @new mysqli($db_host, $db_user, $db_password, $db_db);
	//check connection
  if ($mysqli->connect_error) {
    echo 'Error: '.$mysqli->connect_error;
    exit();
  }

  //check if the http request method used to submit form is post 
  if($_SERVER['REQUEST_METHOD'] === 'POST'){

    //Get the SQL query from form and store in sql_query
    $sql_query = $_POST['sql_query'];

    //perform query and store in result
    $result = $mysqli->query($sql_query);

    if($result){
      //check if statement that returns data
      if($result instanceof mysqli_result){
        
        echo "<h2>Query Results:</h2>";
        //return data in a table
        echo "<table border='1'><tr>";

        //return column names
        $fields =$result->fetch_fields();

        foreach($fields as $field){
          echo "<th>" .htmlspecialchars($field->name) ."</th>";
        }
        echo "</tr>";
        
        //output rows
        while($row = $result->fetch_assoc()){
          echo "<tr>";
          foreach($row as $value){
            echo "<td>". htmlspecialchars($value) . "</td>";
          }
          echo "</tr>";
        }
        echo "</table>";
      } else{
        //query failed
        echo "<h2>Error executing query:</h2>";
      }
    }
  }
//close connection
  $mysqli->close();
?>
</html>