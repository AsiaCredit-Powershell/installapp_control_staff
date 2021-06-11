$LocalDir = "Controll_Staff"
$localPath = "$env:ProgramData\$LocalDir"
$NetPath = "\\ilc-fileserv\it\GPO\INSTALL_Control_Security"
$FileError = "$localPath\Error.txt"
$FileName1 = "agent_ru-5.8.2537-[192.168.1.60].msi" 
$FileName2 = "grabber.x64.msi"

$ViewApp = Get-CimInstance -ClassName Win32_Product | where {$_.name -like 'Tele*' -and $_.name -like 'KickidlerNode'}

if ($ViewApp -ne $null)
{
    break
}

else 
{
    $ViewFiles = (get-ChildItem -Path $localPath\*).FullName 
    
    if ($null -eq $ViewFiles) 
    {
        Copy-Item $NetPath\* -Filter "*.msi" -Destination $localPath
    }

    foreach ($file in $ViewFiles){

        try 
        {        
            invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation="$file"}
        }
        
        catch 
        {
            $Error | Out-File -FilePath $FileError -Encoding utf8 
        }
    }
}
