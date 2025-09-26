\
    # Example DHCP scope for Servers VLAN (if DHCP on Windows)
    Install-WindowsFeature DHCP -IncludeManagementTools
    Add-DhcpServerInDC
    Add-DhcpServerv4Scope -Name "Servers" -StartRange 10.10.10.50 -EndRange 10.10.10.199 -SubnetMask 255.255.255.0
    Set-DhcpServerv4OptionValue -DnsServer 10.10.10.10 -Router 10.10.10.1 -DnsDomain "lab.local"
