<#
This script was made to divide computers according to site where they are present
#>
$output=@()

$comps=Get-Content 'C:\comps.txt'
foreach ($computer in $comps){
    $information=Get-ADComputer -Identity $computer -Properties Name, Description
    if ($information.description -match "Something*") {
        $result = New-Object psobject
        $result | Add-Member -Type NoteProperty -Name Name -Value $information.Name
        $result | Add-Member -Type NoteProperty -Name Site -Value $information.Description.Split()[0] 
        $output+=$result   
    }elseif ($information.description -match "SomethingElse*") {
        $result = New-Object psobject
        $result | Add-Member -Type NoteProperty -Name Name -Value $information.Name
        $result | Add-Member -Type NoteProperty -Name Site -Value $information.Description.Split()[0]
        $output+=$result   
    }elseif ($information.description -match "AndElse*") {
        $result = New-Object psobject
        $result | Add-Member -Type NoteProperty -Name Name -Value $information.Name
        $result | Add-Member -Type NoteProperty -Name Site -Value $information.Description.Split()[0]
        $output+=$result 
    }else {
        $result = New-Object psobject
        $result | Add-Member -Type NoteProperty -Name Name -Value $information.Name        
        $output+=$result 
    }
}
$output | Export-Excel -Path C:\comps.xlsx -AutoSize