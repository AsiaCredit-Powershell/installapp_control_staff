$LocalDir = "Controll_Staff"
$localPath = "$env:ProgramData\$LocalDir"
$NetPath = "\\ilc-fileserv\it\GPO\INSTALL_Control_Security"
$FileError = "$localPath\Error.txt"
$FileName1 = "agent_ru-5.8.2537-[192.168.1.60].msi" 
$FileName2 = "grabber.x64.msi"
$FirstApp = "KickidlerNode"
$SecondApp = "Tele"

$ViewApp = Get-CimInstance -ClassName Win32_Product | where {$_.name -like "$FirstApp*" -and $_.name -like "$SecondApp*"}

if ($null -ne $ViewApp)
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

    $ViewFirstAPP = Get-CimInstance -ClassName Win32_Product | Where-Object {$_.name -like "$FirstApp*"}
    $ViewSecondAPP = Get-CimInstance -ClassName Win32_Product | Where-Object {$_.name -like "$SecondApp*"}

    if ($null -eq $ViewFirstAPP)
    {
        invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation="$localpath\$fileName1"}
    }

    elseif ($null -eq $ViewSecondAPP)
    {
        invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation="$localpath\$fileName2"}
    }
}
