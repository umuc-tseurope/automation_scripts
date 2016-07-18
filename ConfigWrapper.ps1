#############################################
# ConfigWrapper.ps1
#
# .SYNOPSIS a wrapper script for post image configuration
#
#
#############################################

# This runs the commands in order sequentially
.\Software_activations\WindowsActivate.ps1;
.\Software_activations\OfficeActivate.ps1;
.\Registry_control\reg_win_update_fix.ps1;
.\OS_configuration\Local_comp_name.ps1;
.\OS_configuration\Local_desc_property_no.ps1