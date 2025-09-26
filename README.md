# Hybrid-Domain-Lab
Hybrid Domain Lab – Windows Server + Azure AD + pfSense + VLANs
Here’s the full **README.md** content, ready to paste into your GitHub repo:

---

# Hybrid Domain Lab – Windows Server + Azure AD + pfSense + VLANs

A step-by-step lab you can run on a single workstation to simulate a **hybrid Windows domain** that joins on-prem AD with **Microsoft Entra ID (Azure AD)**, routed by **pfSense**, segmented with **VLANs**, and ready for security projects (Wazuh/SIEM later). The lab is structured in **safe batches**, so you can stand it up incrementally without breaking what already works.

> **Target host:** Windows 11 PC with VirtualBox (or Hyper-V/Proxmox), 32 GB RAM minimum recommended.
> **User prefs baked in:** Windows GUI servers, VirtualBox ISOs, VLAN segmentation, low-risk phased rollout, local desktop app focus elsewhere.

---

## Repo Structure

```
Hybrid-Domain-Lab/
├─ README.md
├─ /docs/
│  ├─ 00_topology-and-ip-plan.md
│  ├─ 01_pfsense-setup.md
│  ├─ 02_windows-core-services.md
│  ├─ 03_azure-ad-connect.md
│  ├─ 04_group-policy.md
│  ├─ 05_vlans-dhcp-dns.md
│  ├─ 06_testing-and-validation.md
│  ├─ 07_hardening-and-backups.md
│  └─ 99_troubleshooting.md
├─ /scripts/
│  ├─ ad/Initialize-AD.ps1
│  ├─ ad/Create-OU-Groups-Users.ps1
│  ├─ ad/Join-ComputerToDomain.ps1
│  ├─ dns/Set-DNSForwarders.ps1
│  ├─ dhcp/New-DhcpScopes.ps1
│  ├─ gpo/New-BaselineGPOs.ps1
│  ├─ certs/Install-ADCS.ps1
│  └─ utils/Test-Network.ps1
├─ /pfsense/
│  ├─ interface-plan.csv
│  ├─ dhcp-scopes.csv
│  ├─ firewall-rules.csv
│  └─ optional-config-backup.xml  (export after setup)
└─ /art/
   ├─ topology.drawio
   └─ vlan-map.png
```

---

## Phase Map (Safe Batches)

**Batch 1 – Core network & VLANs (pfSense + switching):**

* Build pfSense VM with 2+ NICs (WAN ↔ NAT, LAN ↔ trunk to lab switch).
* Create VLANs: **10-Servers**, **20-Clients**, **30-Management**, **40-DMZ (optional)**.
* Enable inter-VLAN routing rules narrowly.
* Verify basic connectivity (ICMP only at first).

**Batch 2 – Windows domain (AD DS/DNS/DHCP):**

* Install Windows Server (GUI) → promote to **ad1.lab.local**.
* Configure DNS forwarders to pfSense / external resolvers.
* Add DHCP role (or keep DHCP on pfSense; pick one owner).
* Create base OUs, admin groups, service accounts.

**Batch 3 – Azure AD Connect (Entra Connect):**

* Create Entra tenant (if needed) + custom domain (e.g., `lab.local` not routable; use `lab.example.com` publicly for UPN if desired).
* Install **Azure AD Connect** on a member server (or AD DS) with **Password Hash Sync** (safe default).
* Filter OU scope to **Lab Users/Devices**.

**Batch 4 – Client onboarding & GPOs:**

* Join Windows 10/11 clients to on-prem domain.
* Roll out baseline **Security GPOs** (Firewall, Defender, BitLocker if TPM/VM supports, RDP policy).
* Test **hybrid joined** state (device shows in Entra).

**Batch 5 – Hardening + Backups:**

* pfSense aliases, specific egress rules, block RFC1918 on WAN, NTP, DoT (optional).
* Windows: LAPS (Entra LAPS or On-Prem LAPS), secure admin tiers, DC backups, GPO backup.

**Batch 6 – (Optional) Certificates & NPS:**

* AD CS lab PKI; auto-enroll machine certs; set up NPS for 802.1X Wi-Fi lab or VPN.

---

## Lab Topology

```
                [ Internet ]
                     |
                pfSense (VM)
              WAN: NAT (VirtualBox NAT)
              LAN: vSwitch-Trunk
               |        |        \
         VLAN10      VLAN20      VLAN30
        (Servers)    (Clients)  (Mgmt)
           |            |          |
       ad1.lab.local    w11-01     mgmt-jump
       (DC/DNS/DHCP)    (Win11)    (Admin box)
```

**VLANs & Subnets (example)**

| VLAN | Purpose    | Subnet        | GW (pfSense) | DHCP Owner | Notes                   |
| ---- | ---------- | ------------- | ------------ | ---------- | ----------------------- |
| 10   | Servers    | 10.10.10.0/24 | 10.10.10.1   | Windows    | DC static 10.10.10.10   |
| 20   | Clients    | 10.10.20.0/24 | 10.10.20.1   | pfSense    | Join lab clients        |
| 30   | Mgmt       | 10.10.30.0/24 | 10.10.30.1   | pfSense    | Admin workstation       |
| 40   | DMZ (opt.) | 10.10.40.0/24 | 10.10.40.1   | pfSense    | Reverse proxy, honeypot |

---

## VirtualBox NIC Mapping (example)

* **pfSense VM**:

  * Adapter 1 (WAN): NAT.
  * Adapter 2 (LAN trunk): Host-only/Internal with **Promiscuous: Allow All**.
* **Windows Server (ad1)**: VLAN10.
* **Clients**: VLAN20.

---

## pfSense – Quick Configure

* Assign interfaces for WAN, VLANs.
* Enable DHCP on VLAN20 & VLAN30.
* Forward DNS to AD DNS (split-brain DNS).
* Add firewall rules (only AD ports allowed between clients and DC).
* Enable NTP service.

---

## Windows Server – Core Build

* Hostname: `ad1`
* Static IP: `10.10.10.10`
* Roles: AD DS, DNS, DHCP (optional).

PowerShell install:

```powershell
Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools
Install-ADDSForest -DomainName "lab.local" -DomainNetbiosName "LAB"
```

---

## Azure AD Connect (Entra Connect)

* Use Password Hash Synchronization.
* Filter OU scope to lab users/devices.
* Run initial sync with `Start-ADSyncSyncCycle -PolicyType Initial`.

---

## Group Policy – Baselines

* Firewall baseline.
* Defender policies.
* RDP restrictions (Admins only).
* LAPS.
* Device registration (hybrid join).

---

## Client Join & Validation

* Client on VLAN20.
* DNS points to DC.
* Join `lab.local`.
* Check `dsregcmd /status` → AzureAdJoined: YES.

---

## Firewall Rule Examples

* VLAN20 → VLAN10: Allow AD ports only.
* VLAN20 → WAN: Allow 80/443.
* VLAN30 → Any: Allow all (admin).

---

## Testing & Health Checks

* `nslookup ad1.lab.local`
* `w32tm /query /status`
* `klist`
* `dsregcmd /status`

---

## Hardening & Backups

* pfSense: Disable WAN admin, export config.
* AD: Use Entra LAPS, backup GPOs.
* VM snapshots at each batch.

---

## Troubleshooting

* Client can’t join: DNS/time sync/firewall.
* Hybrid join missing: GPOs & AADC sync.
* No internet: pfSense NAT rules.

---

## Next (Optional)

* Add Wazuh SIEM (VLAN50).
* Publish IIS app in DMZ.
* Add VPN (WireGuard/OpenVPN).

---

## Credits & License

MIT License. Educational lab reference.

---
