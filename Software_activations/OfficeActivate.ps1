###################################################
## OfficeActivate.ps1
##
## .SYNOPSIS Updates the product key and activates 
## MS Office 2010 on a newly imaged machine.
##
##
###################################################

# Get the product key from the datafile
$tsData = Import-Clixml "C:\Windows\System32\tsdata.xml"

$productKey = $tsData.productKeys.MSOffice2010

# Move to the office directory
cd "C:\Program Files (x86)\Microsoft Office\Office14"

$cargs = "/inpkey:$productKey"

# Attempt to update the product key
cscript ospp.vbs $cargs

# Attempt activation
cscript ospp.vbs /act