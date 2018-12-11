<#
.Synopsis
Get-InactiveUsers lists user objects that have not logged in over a specified amount of time
.Description

.Parameter Domain 
Target domain
.Parameter Days
Number of days since login
.Example
Get-InactiveUsers -Domain ad.contoso.com -Days 30

Name               Description                                                       Stamp
----               -----------                                                       -----
Mickey Mouse       Testing account - Do not delete                                   2018-08-23_03:42:25
#>

Param(
    [Parameter(Mandatory = $True)]
    [string]$Domain,
    [Parameter(Mandatory = $False)]
    [string]$Days = 90
)

import-module activedirectory  
$time = (Get-Date).Adddays( - ($Days)) 
  
# Get AD User with lastLogonTimestamp less than our time and set to enable 
Get-ADUser -server $Domain -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true} -Properties Description, LastLogonTimeStamp | 
  
# Output Name and lastLogonTimestamp into CSV  
select-object Name, Description, @{Name = "Stamp"; Expression = {[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}}
