########################################
# User account script stub for student lab/support PC's
#
# This is the basis of testing the automation of local user accounts in
# Windows 7 deployments. This script will be run against newly loaded hardware
# and eliminate the need to manually create/delete user accounts.
#
########################################


# NOTE: each of these scripts are designed for a specific target
# Target: support/lab PC

# First, set the warning and error preferences
$warningPreference = "SilentlyContinue"
$errorActionPreference = "SilentlyContinue"

# Get a list of the local users
$localUserList = @{(Get-localUser)}

# Remove the unnedded local accounts,
Remove-LocalUser -Name ntctsa -Computername localhost
Remove-LocalUser -Name XXXX -Computername localhost
Remove-LocalUser -Name umucfr -Computername localhost
Remove-LocalUser -Name  -Computername localhost


# Create needed accounts if not already on the system
# New-LocalUser -Name student -Password maryland -Computername localhost -Description (Student user account)
# New-LocalUser -Name maintenance -Password Fixit4me -Computername localhost -Description (maintenance account)
# New-LocalUser -Name tsupport -Password Arizona1941 -Computername localhost -Description (admin account)

# Ensure that the student, maintenenace, and tsupport accounts are enabled
# Enable-LocalUser -Name student -Computername localhost
# Enable-LocalUser -Name tsupport -Computername localhost
# Enable-LocalUser -Name maintenance -Computername localhost
