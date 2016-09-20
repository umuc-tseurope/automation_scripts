# Automation Scripts
A collection of scripts for automation of various administrative tasks.


## Prerequisites
These scripts will only run on systems with Windows Powershell (version 2.0 or higher) installed and must be run as an administrator on the target machine. Many of these scripts make use of the tsdata.xml file as a data pool. That file needs to be generated on the target machine. See the document "Generating tsdata.xml" in the SOP's folder(Technical Support ->SOPs) in Gdrive for more details on how to set that up.


## List of scripts
The following is a list of the scripts that have been tested and are ready to be used. Clone the repository on to a thumb drive or in the directory of your choice and run the scripts as an administrator or from a shell started as administrator. Special instructions and examples are listed with each item.

* WUFirewall_rules.ps1 - Create firewall rules for Remote Desktop and Windows Update
  USAGE: Takes no arguments. Just applies the change to the firewall settings.

* WindowsActivate.ps1 - Activate windows 7
  USAGE: Takes no arguments. Just activates the OS with the enterprise license supplied by the tsdata.xml file. Run as admin with either the absolute path or navigate to the directory and perpend '.\' to the filename.

* OfficeActivate.ps1 - Activates MS Office 2010
  USAGE: Takes no arguments. Just activates the product with the enterprise license supplied by the tsdata.xml file. Run as admin with either the absolute path or navigate to the directory and perpend '.\' to the filename.


* reg_win_update_fix.ps1 - Applies a windows update registry fix
  USAGE: Takes no arguments. Just applies the fix. Run as stated for OfficeActivate.ps1


* Local_comp_name.ps1 - Allows the user to rename the local machine
  USAGE: Takes no arguments. Run as stated with OfficeActivate.ps1. Be ready to enter the desired computer name when prompted.


* Local_desc_property_no.ps1 - Allows the user to update the local machine description
  USAGE: Takes no arguments. Run as stated with OfficeActivate.ps1. Be ready to enter the desired computer description when prompted.


## Wrapper script
There is a wrapper script that automates the running of the entire suite of working and tested scripts called ConfigWrapper.ps1. This script can only be run as an administrator while in a shell that is currently in the PWD of the wrapper script file (in other words navigate to the root of the project folder and run the script by perpending '.\'). Also, some of the scripts that the wrapper runs require tsdata.xml to have been generated on the target system. The interactive portions of the script prompt for a computer name and description.


## In-progress scripts
The following is a list of scripts that have either yet to be tested or are otherwise not yet complete. See the TODO document for more information on tasks specific to these and other parts of the project.

* LUA_control.ps1 - Role based setup of local user accounts and groups

* SetExePolicy.ps1 - Sets the execution policy for Powershell scripts
