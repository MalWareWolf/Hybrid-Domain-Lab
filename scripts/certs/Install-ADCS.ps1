\
    # Basic AD CS Lab CA install (Enterprise Root CA)
    Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
    Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -KeyLength 2048 -HashAlgorithmName SHA256 -ValidityPeriod Years -ValidityPeriodUnits 5 -Force
