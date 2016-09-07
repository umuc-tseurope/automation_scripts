############################################
#
# WUFirewall_rules.ps1
#
#
############################################


# Enable remote access through the firewall
netsh advfirewall firewall set rule group="remote desktop" new enable=yes

# Create outbound firewall rule for the Windows Update service
netsh advfirewall firewall add rule name="Windows Update" protocol=any dir="out" action="allow" service="wuauserv" enable="yes" profile=any

# Created inbound firewall rule for the Windows Update service
netsh advfirewall firewall add rule name="Windows Update" protocol=any dir="in" action="allow" service="wuauserv" enable="yes" profile=any