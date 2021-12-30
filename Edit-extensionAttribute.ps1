<#
This script sets extensionattribute4 to fixed value
#>
$values=Import-Csv -Path 'C:\a.csv'
foreach($item in $values)
{$email=$item.Email
$id=$item.Users
$user=Get-ADUser -Filter {emailaddress -eq $email} | select -ExpandProperty samaccountname 
set-ADUser -Identity $user  -Add @{extensionattribute4 = "$id"  }
Write-Host "Setting value extendedatribute4 at user $user to $id"}

