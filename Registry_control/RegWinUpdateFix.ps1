###############################################################
## reg_win_update_fix.ps1
## 
##
## .SYNOPSIS Registry fix for Windows update
##
## 
## .DESCRIPTION This changes the registry to default settings for
## pulling updates. This script requires a restart for the changes
## to take effect. Just in case, the back up for the key and all of
## it's properties can be restored from the win32 folder.
##
##
###############################################################

# Backup the registry key first
reg export HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate winupdate.reg /y

# Navigate to the correct registry location
Set-Location HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate

# Check for and remove the AU registry key
$listOfSubkeys = dir
foreach($subkey in $listOfSubkeys){
    if($subkey -match "\\AU$"){
        Remove-Item AU
    } else{
        continue
    }
}

# Remove the properties for the update pull server from the parent key
$keyPropertyList = Get-ItemProperty .
$properyPresentFlag = 0
foreach($property in $keyPropertyList){
    if($property -match "WUServer"){
        Remove-ItemProperty . WUServer
    } elseif($property -match "WUStatusServer"){
        Remove-ItemProperty . WUStatusServer
    } else{
        continue
    }
}