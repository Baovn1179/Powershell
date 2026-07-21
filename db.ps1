Add-Type -AssemblyName System.Data.SqlClient;

$conn = [System.Data.SqlClient.SqlConnection]::new("Server=DESKTOP-EBJQ319\SQLEXPRESS;Database=ProleBlog;Trusted_Connection=True");

$conn.Open();

$query = "Select * from users";

$command = [System.Data.SqlClient.SqlCommand]::new($query, $conn);

$reader = $command.ExecuteReader();

while ($reader.Read()) 
{
    $reader;
}

$conn.Close();
