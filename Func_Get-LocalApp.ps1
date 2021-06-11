Function Get-Application {
    param 
    (
        $FilterApp
    )
        # Беру все установленные приложения и ищу в них нужное, записываю в переменную ее имя 
    $GetFilterProgramm = Get-WmiObject -Class Win32_Product | Where-Object  {$_.name -like '*$FilterApp*'}
    $AppNames = $GetFilterProgramm.name 
        
    # Если нет объекта - тогда выводим сообщение 
    if ($null -eq $AppNames) 
    {
        $Message = $FilterApp + "`r`n" +  "Отсутствует на ПК "
        Break
    }

    # Если объект есть - тогда выводим в сообщение
    else 
    {
        $Message = foreach ($AppName in $AppNames) 
        {
            $ForeachMessage = "Найдены следующие программы: " + $AppName
            $ForeachMessage
        }
    } 
  
    # Заполняем массив для дальнейшего удобства работы 
    $Array = [pscustomobject]@{ComputerName = "$env:COMPUTERNAME";Message = "$Message"}
    return $Array       
} 