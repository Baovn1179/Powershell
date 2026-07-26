
param (
    [string]$ProcessName,
    [switch]$Syntax
);

[Console]::OutputEncoding = [Text.Encoding]::Unicode;

if ($Syntax) {
    Write-Host "Cú pháp: .\Watching-MemoryUsage.ps1 -ProcessName <Tên tiến trình> [-Syntax]";
    Write-Host "Ví dụ: .\Watching-MemoryUsage.ps1 -ProcessName notepad";
    exit;
}

$Millisecond = 2000;
$Process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue;

if (-not $Process) {
    Write-Host "Tiến trình $ProcessName không tồn tại";
    exit;
}

$StartMemory = $Process.WorkingSet64;

Write-Host "[+] Đang tiến hành theo dõi sự thay đổi bộ nhớ của tiến trình $ProcessName";
Write-Host "[+] Bộ nhớ hiện tại: " ($StartMemory/(1024 * 1024)) MB;



while ($true) {
    $Process.Refresh();
    $CurrentMemory = $Process.WorkingSet64;

    if ($CurrentMemory -gt $StartMemory -OR $CurrentMemory -lt $StartMemory) {
        $Check = $CurrentMemory - $StartMemory;
        if ($Check -gt 0) {
            Write-Host "[+] Bộ nhớ tăng thêm "($Check / (1024 * 1024))MB;
        } else {
            Write-Host "[+] Bộ nhớ giảm đi "($Check / (1024 * 1024))MB;
        }
        Write-Host "[+] Bộ nhớ hiện tại là "($CurrentMemory / (1024 * 1024))MB;
        $StartMemory = $CurrentMemory;
    }

    Start-Sleep -Milliseconds $Millisecond;
}
