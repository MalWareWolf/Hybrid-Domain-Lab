\
    Import-Module GroupPolicy
    $dn = (Get-ADDomain).DistinguishedName

    $gpo = New-GPO -Name "LAB-RDP-Restricted" -ErrorAction SilentlyContinue
    if ($gpo) { New-GPLink -Name $gpo.DisplayName -Target "OU=Workstations,$dn" -Enforced $false }

    # TODO: Add additional policy settings for Firewall/Defender/LAPS as needed.
