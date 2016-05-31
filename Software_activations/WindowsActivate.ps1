###########################################################
## WindowsActivate.ps1
##
## .SYNOPSIS This activates Windows 7
##
##
###########################################################

function main(){
# Set up the computer object
$computer = gc env:computername

# Get the license key from the datafile
# TODO: impliment this!

$key = # insert variable with product key here!

$service = get-wmiObject -query “select * from SoftwareLicensingService” -computername $computer

$service.InstallProductKey($key)

$service.RefreshLicenseStatus()