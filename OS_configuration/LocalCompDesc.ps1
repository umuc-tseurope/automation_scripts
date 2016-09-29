################################################
## Local_desc_property_no.ps1
##
## .SYNOPSIS
## Changes the local machine description to whatever
## the user inputs when prompted (UMUC property tag
## number normally).
##
###############################################

$localOS = Get-WmiObject -Class Win32_OperatingSystem

# Get user input for the local machine description
$localOS.Description = Read-Host -Prompt 'Input the description'
$localOS.put()