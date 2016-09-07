####################################################################################
## .SYNOPSIS User account script stub for student lab/support PC's
## 
## .DESCRIPTION This is the basis of testing the automation of local user account
## management Windows 7 deployments. This script will be run against newly loaded
## hardware and eliminate the need to manually create/delete user accounts during
## initial configuration.
##
####################################################################################


# TODO: find a way to integrate/modularize the necessary local account configs to make
#       this a one script fits all solution.

function Main([string] $rawMachineRole){
    
    # Validate the argument and notify the user if they are incorrect
    switch($rawMachineRole){
        {$_ -match "ntctsa"}{ $validMachineRole = $rawMachineRole; break;}
        {$_ -match "support"}{$validMachineRole = $rawMachineRole; break;}
        {$_ -match "staff"}{$validMachineRole = $rawMachineRole; break;}
        {$_ -match "faculty"}{$validMachineRole = $rawMachineRole; break;}
        {$_ -match "ntc testing"}{$validMachineRole = $rawMachineRole; break;}
        {$_ -match "server"}{$validMachineRole = $rawMachineRole; break;}
        {$_ -match "advisor"}{$validMachineRole = $rawMachineRole; break;}
        default{"The computer role that you provided was not valid! Valid roles include:
            ntctsa, support, staff, faculty, ntc testing, server, and adviser."}
    }

    # Grab TSData info for configuration
    # TODO: there needs to be some error handling here for if the file does
    # not yet exist!
    $TSData = Import-Clixml "C:\Windows\system32\TSData.xml"

    # Create a list of the names of all local accounts
    $localAccountsList = updateLocalAccountList

    # Create a list of the desired accounts for this deployment depending
    # on the machine role
    $desiredAccountsList = $TSData."$validMachineRole"

    # Use the list of desired accounts to create a structure with user account data
    $desiredAccountData = @{}
    foreach($desiredAccountName in $desiredAccountsList){
        $desiredAccountData["$desiredAccountName"] = $TSData."$desiredAccountName"
    }

    # Setup the ADSI connection for account management
    # NOTE: pass the handle to any helper fucnctions!
    $computername = $env:COMPUTERNAME
    $ADSIComp = [adsi]"WinNT://$Computername"

    # Remove all unwanted user accounts
    removeUnwantedLocalAccounts $ADSIComp $localAccountsList $desiredAccountsList

    # Update the list of local user accounts (again)
    $localAccountsList = updateLocalAccountList

    # Create any accounts that don't exist and set their properties
    setLocalUserAccounts $ADSIComp $localAccountsList $desiredAccountsData

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

    # TODO: put some cleanup code here for the TSData file in %Windows%\System32\


} # end Main()

function setLocalUserAccounts($ADSIHandle, $localAccountsList,
                                    $desiredAccountData){
    
    # TODO: add users to appropriate groups on creation
    foreach($desiredAccount in $desiredAccountData.Keys){
        if($desiredAccount -notin $localAccountsList){
            $newUser = $ADSIHandle.Create("User", $desiredAccount)
            $newUser.SetPassword($desiredAccountData.$desiredAccount.password)
            $newUser.SetInfo()
        }
    }
} # end setLocalUserAccounts()

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
            # Skip the built-in accounts and check the others
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


function checkLocalAccountsEnabled($ADSIHandle, $localAccountList, $desiredAccountList){
    
    #Set the flag for disabled account status
    $Disabled = 0x0002

    # Check that the desired user accounts are in enabled status
    # TODO: impliment this fucntionality!

} # end checkLocalAccountsEnabled()


# Source Main
. Main 