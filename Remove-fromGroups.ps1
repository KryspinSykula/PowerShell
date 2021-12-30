<#
Script deletes disabled users from selected groups. It's not very efficient, because it deletes every user from every group, even if user is not there 
#>
Import-Module ActiveDirectory
$credential=Get-Credential
$users= #users container
$groups= #groups container
$disabledUsers=get-ADUser -SearchBase $users -Properties SAmAccountName  -Filter *|  where {$_.enabled -eq $false} | Select SAmAccountName #select disabled users
$siteDistGroups=Get-ADGroup -SearchBase $groups -Filter ''  #select unique site distribution groups. Filter can be used to select some groups
#removing all disabled users from site distribution groups
for ($i = 0; $i -lt $disabledUsers.Count; $i++) { 
    for ($j = 0; $j -lt $siteDistGroups.Count; $j++) {
        Remove-ADGroupMember -identity $siteDistGroups.DistinguishedName.Item($j) -members $disabledUsers.SAmAccountName.Item($i) -Credential $credential -Confirm:$false}
        
    }
    Write-Host "Uzytkownicy zostali usunięci z grup."
    pause
   

