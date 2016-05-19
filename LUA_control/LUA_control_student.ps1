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

function Main{

    # Create a list of the names of all local accounts
    $results = Get-LocalUser
    $localAccountsList = $results | ForEach-Object {$_.Name}

    # Create a list of the desired accounts and passwords for this deployment
    $desiredAccountsList = "student", "tsupport", "maintenance"
    $desiredPasswordList = "maryland", "Arizona1941", "Fixit4me"

    # Setup the ADSI connection for account management
    # NOTE: pass the handle to any helper fucnctions!
    $computername = $env:COMPUTERNAME
    $ADSIComp = [adsi]"WinNT://$Computername"

    # Remove all unwanted user accounts
    removeUnwantedLocalAccounts $ADSIComp $localAccountsList $desiredAccountsList

    # Update the list of local user accounts
    $results = Get-LocalUser
    $localAccountsList = $results | ForEach-Object {$_.Name}

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


} # End Main()


function removeUnwantedLocalAccounts($ADSIHandle, 
                                     $localAccountsList, $desiredAccountsList){

    # Remove any unwanted local user accounts 
    foreach($localAccount in $localAccountsList){
        if($localAccount -notin $desiredAccountsList){
            $ADSIComp.Delete('user', "$localAccount")
        }
    }
} # End removeUnwantedLocalAccounts()


function createLocalAccount($ADSIHandle, $desiredUsername, $desiredPasswd){
    
    # This is where accounts are created
    $newUser = $ADSIHandle.Create('User',$desiredUsername)

    # Create and set the password for the new account
    $rawPasswd = ConvertTo-SecureString $desiredPasswd -asplaintext -force
    $jPasswd = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($rawPasswd)
    $secPasswd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($jPasswd)
    $newUser.SetPassword($secPasswd)
    $newUser.SetInfo()
}

function checkLocalAccountsEnabled($ADSIHandle, $localAccountList){
    
    #Set the flag for disabled account status
    $Disabled = 0x0002

    # Check that the desired user accounts are in enabled status

}


# Source Main
. Main 