
param(
    [string]$Query,
    [string]$QueryType,
    [string]$Server = "localhost\SQLEXPRESS",
    [string]$Database,
    [switch]$Syntax
);

if ($Syntax) {
    Write-Host "Cú pháp: .\Invoke-Database.ps1 -Query <Câu lệnh SQL> -QueryType <Read|Execute> -Server <Tên server> -Database <Tên database> [-Syntax]";
    Write-Host "Ví dụ: .\Invoke-Database.ps1 -Query 'SELECT * FROM TableName' -QueryType Read -Server localhost\SQLEXPRESS -Database DatabaseName";
    exit;
}

[Console]::OutputEncoding = [Text.Encoding]::Unicode;

Add-Type -AssemblyName System.Data.SqlClient;

$conn_str = "Server=$Server;Database=$Database;Trusted_Connection=True";
$conn = [System.Data.SqlClient.SqlConnection]::new($conn_str);

$command = [Data.SqlClient.SqlCommand]::new($query, $conn);

$conn.Open();


switch ($QueryType) 
{
    "Read" 
    {
        $reader = $command.ExecuteReader();
        $count = $reader.FieldCount;
        while ($reader.Read())
        {
            for ($i = 0; $i -lt $count; $i++) 
            {
                Write-Host $reader[$i];
            }
            Write-Host "==================";
        }
    }
    "Execute" 
    {
        $command.ExecuteNonQuery();
    }
    default { Write-Host "Vui lòng nhập tham số -QueryType là Read hoặc Execute"; break; }
}


$conn.Close();
