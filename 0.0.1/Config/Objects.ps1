$SQLConn = [PSCustomObject]@{
    HostName       = $env:COMPUTERNAME
    ServerInstance = "localhost"
    Database       = "master"
    ConnectionTimeout = 30
    QueryTimeout   = 0
    EncryptConnection = $true
    TrustServerCertificate = $false
}