Get-WmiObject -Class Win32_Product -Filter "Name like 'Adobe Shockwave%'" | Foreach-Object { MsiExec.exe /X$($_.IdentifyingNumber) /qn }