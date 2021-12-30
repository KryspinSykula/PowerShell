<#
This script can assign permissions to selected file from folder indicated in script
#>
$credential= Get-Credential
New-PSDrive -Name Z  -Persist -PSProvider filesystem -Scope global -Credential $credential -Root #Put mapped drive here"
$acl=Get-Acl -Path #write path here where acl should be taken from
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$path = [Microsoft.VisualBasic.Interaction]::InputBox('Podaj ścieżke do pliku','Zmiana uprawnień','')
 Set-Acl -Path $path -AclObject $acl
 Remove-PSDrive z