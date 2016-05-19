####################################################################################
## .SYNOPSIS User account script stub for student lab/support PC's
## 
## .DESCRIPTION This is the basis of testing the automation of local user account
## management Windows 7 deployments. This script will be run against newly loaded
## hardware and eliminate the need to manually create/delete user accounts during
## initial configuration.
##
####################################################################################


# NOTE: each of these scripts are designed for a specific target
# Target: support/lab PC
# TODO: find a way to integrate/modularize the necessary local account configs to make
#       this a one script fits all solution.

function Main{

    # Create a list of the names of all local accounts
    $localAccountsList = updateLocalAccountList

    # Create a list of the desired accounts for this deployment
    # FIXME: this should really be a hash or object!
    $desiredAccountsList = "student", "tsupport", "maintenance"

    # Setup the ADSI connection for account management
    # NOTE: pass the handle to any helper fucnctions!
    $computername = $env:COMPUTERNAME
    $ADSIComp = [adsi]"WinNT://$Computername"

    # Remove all unwanted user accounts
    removeUnwantedLocalAccounts $ADSIComp $localAccountsList $desiredAccountsList

    # Update the list of local user accounts (again)
    $localAccountsList = updateLocalAccountList

    # Add any accounts that are not yet present
    foreach($desiredAccount in $desiredAccountsList){
        if($desiredAccount -notin $localAccountsList){
            switch($desiredAccount){
                {$_ -match "student"}{createLocalAccount $ADSIComp $desiredAccount "maryland"}
                {$_ -match "tsupport"}{createLocalAccount $ADSIComp $desiredAccount "Arizona1941"}
                {$_ -match "maintenance"}{createLocalAccount $ADSIComp $desiredAccount "Fixit4me"}
            }
        }
    }

    # Update the list of local accounts (yet again)
    $localAccountsList = updateLocalAccountList

    # Check to ensure that all of the right user accounts exist and are enabled
    $localAccountExistsFlag = 0
    foreach($localAccount in $localAccountsList){
        if($localAccount -notin $desiredAccountsList){
            if($localAccount -match "guest" -or "administrator"){
                continue
            } else {
                $localAccountExistsFlag = 1
            }
        }
    }
    
    # TODO: place user account enabled check here

    if($localAccountExistsFlag -eq 0){
        Write-Host "All user accounts successfully created and enabled!"
    } else {
        Write-Host "There was a problem creating the desired user accounts!"
    }


} # end Main()

function updateLocalAccountList(){
    
    $results = Get-LocalUser
    $updatedAccountList = $results | ForEach-Object {$_.Name}
    return $updatedAccountList

} # end updateLocalAccountList()


function removeUnwantedLocalAccounts($ADSIHandle, 
                                     $localAccountsList, $desiredAccountsList){

    # Remove any unwanted local user accounts 
    foreach($localAccount in $localAccountsList){
        if($localAccount -notin $desiredAccountsList){
            # Skip the built-in accounts and create the others
            if($localAccount -match "guest"){
                continue
            } elseif ($localAccount -match "administrator"){
                continue
            } else {
                $ADSIComp.Delete('user', "$localAccount")
            }
        }
    }
} # end removeUnwantedLocalAccounts()


function createLocalAccount($ADSIHandle, $desiredUsername, $desiredPasswd){
    
    # This is where accounts are created
    $newUser = $ADSIHandle.Create('User',$desiredUsername)

    # Create and set the password for the new account
    $rawPasswd = ConvertTo-SecureString $desiredPasswd -asplaintext -force
    $jPasswd = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($rawPasswd)
    $secPasswd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($jPasswd)
    $newUser.SetPassword($secPasswd)
    $newUser.SetInfo()
} # end createLocalAccount()

function checkLocalAccountsEnabled($ADSIHandle, $localAccountList, $desiredAccountList){
    
    #Set the flag for disabled account status
    $Disabled = 0x0002

    # Check that the desired user accounts are in enabled status

} # end checkLocalAccountsEnabled()


# Source Main
. Main 