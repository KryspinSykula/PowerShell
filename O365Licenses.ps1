<#
This script checks which M365 licenses are applied to disabled users. 
#>

<#
In this part script checks are there requred modules installed. If not they are installed from PSGallery
#>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
$Module = Get-Module ExchangeOnlineManagement -ListAvailable
 if($Module.count -eq 0) 
 { 
  Write-Host "Exchange Online PowerShell V2 module is not available"  -ForegroundColor yellow  
  $Confirm= Read-Host Are you sure you want to install module? [Y] Yes [N] No 
  if($Confirm -match "[yY]") 
  { 
   Write-host "Installing Exchange Online PowerShell module"
   Install-Module ExchangeOnlineManagement -Repository PSGallery -AllowClobber -Force
  } 
  else 
  { 
   Write-Host "EXO V2 module is required to connect Exchange Online.Please install module using Install-Module ExchangeOnlineManagement cmdlet." 
   Exit
  }
 } 

 $Module1 = Get-Module AzureAD -ListAvailable
 if($Module1.count -eq 0) 
 { 
  Write-Host "Azure Active Directory PowerShell module is not available"  -ForegroundColor yellow  
  $Confirm= Read-Host Are you sure you want to install module? [Y] Yes [N] No 
  if($Confirm -match "[yY]") 
  { 
   Write-host "Installing Azure Active Directory PowerShell module"
   Install-Module AzureAD -Repository PSGallery -AllowClobber -Force
  } 
  else 
  { 
   Write-Host "Azure Active Directory PowerShell module is required to connect Azure AD.Please install module using Install-Module AzureAD cmdlet." 
   Exit
  }
 } 

 $Module2 = Get-Module ImportExcel -ListAvailable
 if($Module2.count -eq 0) 
 { 
  Write-Host "ImportExcel PowerShell module is not available"  -ForegroundColor yellow  
  $Confirm= Read-Host Are you sure you want to install module? [Y] Yes [N] No 
  if($Confirm -match "[yY]") 
  { 
   Write-host "Installing ImportExcel PowerShell module"
   Install-Module ImportExcel  -Repository PSGallery -AllowClobber -Force
  } 
  else 
  { 
   Write-Host "ImportExcel module i required to export report.Please install module using Install-Module ImportExcel  cmdlet." 
   Exit
  }
 } 

Write-Host "Connecting to Azure AD - Please enter O365 Admin credentials" -ForegroundColor Green
Connect-AzureAD 

Write-Host "Connecting to Exchange Online - Please enter O365 Admin credentials" -ForegroundColor Green
Connect-ExchangeOnline
<#
creating empty PSObject
#>
$output =@()
<#
Function selects assigned licenses form user and returns it
#>
function Get-Licenses ($user) {
    Get-AzureADUser -SearchString $user.UserPrincipalName | select -ExpandProperty AssignedLicenses | select skuid      
    Return 
    
}
<#
This function check when was the last time user accesed mailbox. According to some articles property "LastUserActionTime" is the most reliable.
#>
function Get-LastmailoxAccess ($user) {
    if (Get-EXOMailbox -Identity $user.UserPrincipalName -ErrorAction SilentlyContinue) {
        Get-EXOMailboxStatistics -PropertySets All -Identity $user.UserPrincipalName | select -ExpandProperty LastUserActionTime
    return
}
}
<#
Function changes id of license to more readable version
#>
function Get-Name ($item) {    
    switch ($item) {
        "dcb1a3ae-b33f-4487-846a-a640262fadf4"  { $license+= "Microsoft Power Apps Plan 2 Trial, "}
        "18181a46-0d4e-45cd-891e-60aabd171b4e"  { $license+= "OFFICE 365 E1, "}
        "efccb6f7-5641-4e0e-bd10-b4976e1bf68e"  { $license+= "ENTERPRISE MOBILITY + SECURITY E3, "}
        "ee02fd1b-340e-4a4b-b355-4a514e4c8943"  { $license+= "EXCHANGE ONLINE ARCHIVING FOR EXCHANGE ONLINE, " }
        "1f2f344a-700d-42c9-9427-5cea1d5d7ba6"  { $license+= "MICROSOFT STREAM, "}
        "f8a1db68-be16-40ed-86d5-cb42ce701560"  { $license+= "POWER BI PRO, "}
        "6470687e-a428-4b7a-bef2-8a291ad947c9"  { $license+= "WINDOWS STORE FOR BUSINESS, "}
        "6fd2c87f-b296-42f0-b197-1e91e994b900"  { $license+= "Office 365 E3, "}
        "f30db892-07e9-47e9-837c-80727f46fd3d"  { $license+= "MICROSOFT FLOW FRE, "}
        "726a0894-2c77-4d65-99da-9775ef05aad1"  { $license+= "MICROSOFT BUSINESS CENTER, "}
        "80b2d799-d2ba-4d2a-8842-fb0d0f3a4b82"  { $license+= "EXCHANGE ONLINE KIOSK, "}
        "6a0f6da5-0b87-4190-a6ae-9bb5a2b9546a"  { $license+= "WINDOWS 10 ENTERPRISE E3, "}
        "606b54a9-78d8-4298-ad8b-df6ef4481c80 " { $license+= "Power Virtual Agents Viral Trial, "}
        "338148b6-1b11-4102-afb9-f92b6cdc0f8d " { $license+= "DYNAMICS 365 P1 TRIAL FOR INFORMATION WORKERS, "}
        "6070a4c8-34c6-4937-8dfb-39bbc6397a60 " { $license+= "Microsoft Teams Rooms Standard, "}
        "4fb214cb-a430-4a91-9c91-4976763aa78f " { $license+= "Teams Rooms Premium, "}
        "c1d032e0-5619-4761-9b5c-75b6831e1711 " { $license+= "Power BI Premium Per User, "}
        "fcecd1f9-a91e-488d-a918-a96cdb6ce2b0 " { $license+= "Microsoft Dynamics AX7 User Trial, "}
        "0c266dff-15dd-4b49-8397-2bb16070ed52"  { $license+= "Microsoft 365 Audio Conferencing, "}
        "50f60901-3181-4b75-8a2c-4c8e4c1d5a72"  { $license+= "Microsoft 365 F1, "}
        "8c4ce438-32a7-4ac5-91a6-e22ae08d9c8b " { $license+= "Rights Management Adhoc, "}
        "a403ebcc-fae0-4ca2-8c8c-7a907fd6c235"  { $license+= "Power BI (Free), "}
    }
    return $license
}

#"ou=PLDSSB, ou=Organization, ou=Food Europe, DC=aryzta,dc=com"
$SB=Read-Host "Write your search base. For Example ou=PLDSSB, ou=Organization, ou=Food Europe, DC=aryzta,dc=com" #Search base. It can be specified containter or whole Active directory
Write-Host "Exporting report to file C:\List.xlsx" -ForegroundColor Green
$disabledUsers=get-ADUser -SearchBase $SB  -Filter 'Enabled -eq "false"' -Properties Country, UserPrincipalName, DisplayName, City, LastLogonDate
foreach ($disabledUser in $disabledUsers){    
    $AssignedLicenses=Get-Licenses $disabledUser
    $Mailbox=Get-LastmailoxAccess $disabledUser   
    $LicenseName=Get-Name $AssignedLicenses.SkuID   
    $disabledUsersObject = New-Object psobject
    $disabledUsersObject | Add-Member -Type NoteProperty -Name UserName -Value $disabledUser.DisplayName
    $disabledUsersObject | Add-Member -Type NoteProperty -Name Country -Value $disabledUser.Country
    $disabledUsersObject | Add-Member -Type NoteProperty -Name City -Value $disabledUser.City
    $disabledUsersObject | Add-Member -Type NoteProperty -Name LastLogonDate -Value $disabledUser.LastLogonDate      
    $disabledUsersObject | Add-Member -Type NoteProperty -Name LastMailboxAccessDate -Value $Mailbox     
    $disabledUsersObject | Add-Member -Type NoteProperty -Name AppliedLicenses -Value $LicenseName   
    $output += $disabledUsersObject 
} 


$output | Export-Excel -Path C:\List.xlsx -AutoSize -WorksheetName "Disabled user with licenses" -AutoFilter 
Write-Host "Done!" -ForegroundColor Green

