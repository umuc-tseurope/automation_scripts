####################################################################################
## .SYNOPSIS User account script stub for student lab/support PC's
## 
## .DESCRIPTION This is the basis of testing the automation of local user account
## management Windows 7 deployments. This script will be run against newly loaded
## hardware and eliminate the need to manually create/delete user accounts during
## initial configuration.
##
####################################################################################

# This makes the argument passed availible to the rest of the script
param(
        $role
    )

function Main{
    
    # Validate the argument and notify the user if they are incorrect
    Write-Host $role
    switch($role){
        {$_ -match "ntctsa"}{$validMachineRole = $role; break;}
        {$_ -match "support"}{$validMachineRole = "$role"; break;}
        {$_ -match "staff"}{$validMachineRole = $role; break;}
        {$_ -match "faculty"}{$validMachineRole = $role; break;}
        {$_ -match "ntctesting"}{$validMachineRole = $role; break;}
        {$_ -match "server"}{$validMachineRole = $role; break;}
        {$_ -match "advisor"}{$validMachineRole = $role; break;}
        default{
            Write-Host "The computer role that you provided is not valid! Valid roles include:
            ntctsa, support, staff, faculty, ntctesting, server, and adviser."
            return
            }
    }

    # Grab TSData info for configuration TODO: wrap this in some error handling
    # just in case the file has not yet been created!
    $TSData = Import-Clixml "C:\Windows\system32\TSData.xml"

    # Create a list of the names of all local accounts
    $localAccountsList = updateLocalAccountList

    # Create a list of the desired accounts for this deployment depending
    # on the machine role
    $desiredAccountsList = $TSData.$validMachineRole.desiredUserAccounts

    # Use the list of desired accounts to create a structure with user account data
    $desiredAccountData = @{}
    foreach($desiredAccountName in $desiredAccountsList){
        $desiredAccountData[$desiredAccountName] = $TSData.$desiredAccountName
    }

    $desiredAccountData
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
            $desiredAccountData.$desiredAccount.password
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