\
    Import-Module ActiveDirectory
    $dn = (Get-ADDomain).DistinguishedName
    New-ADOrganizationalUnit -Name "_Tier0" -Path $dn -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
    New-ADOrganizationalUnit -Name "Servers" -Path $dn -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
    New-ADOrganizationalUnit -Name "Workstations" -Path $dn -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue

    if (-not (Get-ADGroup -Filter "Name -eq 'LAB-Admins'" -ErrorAction SilentlyContinue)) {
      New-ADGroup -Name "LAB-Admins" -GroupScope Global -Path "OU=_Tier0,$dn"
    }

    if (-not (Get-ADUser -Filter "SamAccountName -eq 'labadmin'" -ErrorAction SilentlyContinue)) {
      New-ADUser -Name "Lab Admin" -SamAccountName "labadmin" `
        -AccountPassword (Read-Host -AsSecureString "Lab Admin Password") -Enabled $true `
        -Path "OU=_Tier0,$dn"
      Add-ADGroupMember "LAB-Admins" "labadmin"
    }
