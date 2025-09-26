\
    Param(
      [string[]]$Forwarders = @("10.10.10.1")
    )
    Add-DnsServerForwarder -IPAddress $Forwarders -PassThru
