# Topology & IP Plan

## VLANs
| VLAN | Purpose | Subnet | Gateway | DHCP Owner |
|------|---------|--------|---------|------------|
| 10   | Servers | 10.10.10.0/24 | 10.10.10.1 | Windows or pfSense |
| 20   | Clients | 10.10.20.0/24 | 10.10.20.1 | pfSense |
| 30   | Mgmt    | 10.10.30.0/24 | 10.10.30.1 | pfSense |
| 40   | DMZ     | 10.10.40.0/24 | 10.10.40.1 | pfSense |

## Naming
- Domain: `lab.local`
- DC: `ad1.lab.local` (10.10.10.10)
- Client example: `w11-01.lab.local`
