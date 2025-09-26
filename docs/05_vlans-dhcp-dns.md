# VLANs, DHCP, and DNS

- Prefer DHCP on pfSense for Clients/Mgmt; optional Windows DHCP for Servers VLAN.
- Ensure Option 6 (DNS) points clients to the DC IP.
- Use conditional forwarders or pfSense overrides for split-brain DNS.
