# Формируем пути до каталогов и файлов. А так же именя файлов, папок и установленных приложений 
$LocalDir = "Controll_Staff"
$localPath = "$env:ProgramData\$LocalDir"
$FileError = "$localpath\error.txt"
$NetPath = "\\ilc-fileserv\it\GPO\INSTALL_Control_Security"
$FileName1 = "agent_ru-5.8.2537-[192.168.1.60].msi" 
$FileName2 = "grabber.x64.msi"
$FirstApp = "KickidlerNode"
$SecondApp = "Tele"
$Date = "[" + (Get-Date -Format 'dd-MM-yyyy hh:mm:ss') + "]"

# Смотрим поставились ли пакеты приложений. Если поставились - тогда ничего не делаем.
$ViewAllApp = Get-CimInstance -ClassName Win32_Product 
$SearchApp = $ViewAllApp | Where-Object {$_.name -like "$FirstApp*" -and $_.name -like "$SecondApp*"}

if ($null -ne $SearchApp)
{
    break
}

# Если не поставились - тогда проверяем наличие файлов. Если их нет - копируем из источника.
else 
{
    $ViewFiles = (get-ChildItem -Path $localPath\*).FullName 
    
    if ($null -eq $ViewFiles) 
    {
        Copy-Item $NetPath\* -Filter "*.msi" -Destination $localPath
    }

    # Если файлы скопированы - проверяем на наличие отдельных приложений. Если одного из них нет - тогда устанавливаем по одному 
    $SearchFirstAPP = $ViewAllApp | Where-Object {$_.name -like "$FirstApp*"}
    $SearchSecondAPP = $ViewAllApp | Where-Object {$_.name -like "$SecondApp*"}

    if ($null -eq $SearchFirstAPP)
    {
        Start-Process -Wait "msiexec.exe" -ArgumentList "/i", "$localPath\$FileName1", "quiet"
    }

    elseif ($null -eq $SearchSecondAPP)
    {
        Start-Process -Wait "msiexec.exe" -ArgumentList "/i", "$localPath\$FileName2", "quiet"
    }
}