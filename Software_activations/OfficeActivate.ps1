###################################################
## OfficeActivate.ps1
##
## .SYNOPSIS This activates MS Office 2010
##
##
###################################################

# Get the product key from the datafile
# TODO: impliment this!

# Move to the office directory
cd "C:\Program Files (x86)\Microsoft Office\Office14"

# Attempt to update the product key
cscript ospp.vbs /inpkey:$productKey

# Attempt activation
cscript ospp.vbs /act

# Grab the status and display a message to the user
$activationStatus = cscript ospp.vbs /dstatus

if($activationStatus -contains 'LICENSED'){
    Write-Host "Product activation successfull!"
}else {
    Write-Host "Product activation failed!"
}