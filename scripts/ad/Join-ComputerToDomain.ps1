\
    Param(
      [string]$Domain = "lab.local"
    )
    Add-Computer -DomainName $Domain -Force -Restart
