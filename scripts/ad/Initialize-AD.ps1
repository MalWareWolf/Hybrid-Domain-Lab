\
    <#
      Initializes a new AD forest: lab.local
    #>
    Import-Module ADDSDeployment
    Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools
    Install-ADDSForest `
      -DomainName "lab.local" `
      -DomainNetbiosName "LAB" `
      -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM Password") `
      -InstallDNS
