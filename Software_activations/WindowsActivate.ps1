###########################################################
## WindowsActivate.ps1
##
## .SYNOPSIS This activates Windows 7
##
##
###########################################################

# Set up the computer object
$computer = gc env:computername

# Read in the file with the config data
$configData = Import-Clixml "C:\Windows\System32\tsdata.xml"

$key = $configData.productKeys.Windows7

$service = Get-WMIObject -query “select * from SoftwareLicensingService” -computername $computer

$service.InstallProductKey($key)

$service.RefreshLicenseStatus()