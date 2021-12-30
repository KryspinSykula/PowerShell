<#
This script was prepared to check which windows 10 computers  needs to be upgrated because of ending Windows 10 version support.
#>
$listOfComputers=Get-Content 'C:\comps.txt' 
$computerDetails=foreach ($item in $listOfComputers) {
    Get-ADComputer -Identity $item -Properties OperatingSystem, OperatingSystemVersion, Name, Description 
}

foreach ($comp in $computerDetails){    
    if ($comp.OperatingSystem -clike "Windows 10 Enterprise") { 
        if ($comp.OperatingSystemVersion -like "*10586*" -or $comp.OperatingSystemVersion -like "*15063*" -or $comp.OperatingSystemVersion -like "*16299*"`
         -or $comp.OperatingSystemVersion -like "*18362*" -or $comp.OperatingSystemVersion -like "*17134*" -or $comp.OperatingSystemVersion -like "*17763*"`
          -or $comp.OperatingSystemVersion -like "*19041*") {
            $comp.Name, $comp.Description, $comp.OperatingSystemVersion | Out-File 'C:\detailedComputerList.txt' -Append
        } 
    }
}



$finalList=Get-Content 'C:\detailedComputerList.txt'
$finalList | ConvertFrom-String | Select-Object @{n="Name";e={$_.p1}}, @{n="Site";e={$_.p2}}, @{n="Name";e={$_.p4}},`
@{n="Surname";e={$_.p5}}, @{n="Windows version";e={$_.p8}} 


$finalList.Replace('19041','2004').Replace('15063','1703').Replace('16299','1709').Replace('18362','1903').Replace('17134','1803').Replace('17763','1809').Replace('10586','1511')`
 | Out-File 'C:\detailedComputerList.txt'
$finalList | ConvertFrom-String
<#
End of support = 1511, 1703, 1709,1903

1511 = 10586
1703 = 15063
1709 = 16299
1903 = 18362

Soon end of support = 1803,1809,2004

1803 = 17134
1809 = 17763
2004 = 19041

Ok Suppport = 1909,20H2

1909 = 18363
20H2 = 19042
#>



