Set-Location Filter;

[object]$FileObj = get-childitem -recurse -file -Include *.png, *.jpg, *.jpeg | Group-Object LastWriteTime | Select-Object Name, Group 
[string]$format = "dd.MM.yyyy";
foreach ($file in $FileObj) { 
    [string]$date = ([datetime]$file.Name).ToString($format); 
    [string]$folder = "DateTime/$($date)"; 
    
    if ((Test-Path $folder) -eq $false) {
        New-Item $folder -ItemType Directory;
    }

    foreach ($image in $file.Group) {
        [string]$dt = ([datetime]((($image | Select-Object LastWriteTime).LastWriteTime))).ToString($format);

        if ($dt -eq $date) {
           Copy-Item -Path "$($image.Directory)/$($image.Name)" -Destination "Datetime/$($date)/$($image.Name)";
        }

    }
}