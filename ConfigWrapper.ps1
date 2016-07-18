#############################################
# ConfigWrapper.ps1
#
# .SYNOPSIS a wrapper script for post image configuration
#
# NOTE: This wrapper must be run as admin or in a shell started
# as admin and must be run in the directory is is located in the
# original project file tree!
#
#
#############################################

# Save the current working directory
$startPath = Convert-Path .

# This runs the commands in order sequentially
.\Software_activations\WindowsActivate.ps1;

# This returns the PWD back to the start location
cd $startPath;

.\Software_activations\OfficeActivate.ps1;

cd $startPath;

.\OS_configuration\Local_comp_name.ps1;

cd $startPath;

.\OS_configuration\Local_desc_property_no.ps1;

cd $startPath;

.\Registry_control\reg_win_update_fix.ps1;

cd $startPath;