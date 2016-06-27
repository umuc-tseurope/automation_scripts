##################################################
## Local_comp_name.ps1
##
## .Synopsis
## Renames the local machine to whatever the user 
## inputs when promted.
##
##
##################################################

# Get the local machine object
$localOS = Get-WmiObject Win32_ComputerSystem

# Read in user input for the new computer name
$newComputerName = Read-Host -Prompt "Please enter the new computer name"

$localOS.Rename($newComputerName)

# Restart the machine
#Restart-Computer