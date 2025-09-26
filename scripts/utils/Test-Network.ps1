\
    Param(
      [string]$DC = "10.10.10.10",
      [string]$GW = "10.10.20.1"
    )
    Write-Host "Pinging DC..."; Test-Connection $DC -Count 2
    Write-Host "Pinging Gateway..."; Test-Connection $GW -Count 2
    Write-Host "DNS to DC..."; Resolve-DnsName ad1.lab.local -Server $DC
