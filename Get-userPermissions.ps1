<#
This script can check folder permissions for selected user. 
#>
$output =@()
$user=Read-Host "Enter user login for whom permissions sholud be checked"
$path=Read-Host "Enther path to be checked"
$folders=Get-ChildItem -Path $path -Depth 1 | select -ExpandProperty fullname 
function Get-Permissions ($folder) {
    Get-Acl -Path $folder  | select path -ExpandProperty access | select path, IdentityReference
    return
    
}

function Get-name ($parcipant) {    
   if ($parcipant.IdentityReference -match $user){
    $perm += Convert-Path $parcipant.path | select -Unique
   }
   return $perm
    
}
foreach ($folder in $folders){
    $Value=Get-Permissions $folder
    $Name=Get-name $Value
    $permissionPerFolder = New-Object psobject    
    $permissionPerFolder | Add-Member -Type NoteProperty -Name Path -Value $Name
    $output += $permissionPerFolder
}
Get-ADUser -Identity $user -Properties Name | select -ExpandProperty name | Out-File c:\permissions.txt
$output.path | Out-File c:\permissions.txt -Append





