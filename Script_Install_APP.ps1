# Формируем пути до каталогов и файлов. А так же именя файлов, папок и установленных приложений 
$LocalDir = "Controll_Staff"
$localPath = "$env:ProgramData\$LocalDir"
$NetPath = "\\ilc-fileserv\it\GPO\INSTALL_Control_Security"
$FileName1 = "agent_ru-5.8.2537-[192.168.1.60].msi" 
$FileName2 = "grabber.x64.msi"
$FirstApp = "KickidlerNode"
$SecondApp = "Tele"

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
        invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation="$localpath\$fileName1"}
    }

    elseif ($null -eq $SearchSecondAPP)
    {
        invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation="$localpath\$fileName2"}
    }
}
