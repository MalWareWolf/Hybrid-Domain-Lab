# pfSense Setup

1. Assign interfaces (WAN/LAN + VLANs).
2. Create VLANs (10/20/30/40) on trunk or add OPT interfaces if simulating VLANs as separate networks.
3. Configure DHCP for VLAN20/30 (.50–.199).
4. DNS Resolver: add Host Overrides or forward to AD DNS for `lab.local`.
5. Firewall: default deny inter-VLAN, allow AD core from VLAN20 -> VLAN10.
6. NTP: enable and advertise to subnets.
