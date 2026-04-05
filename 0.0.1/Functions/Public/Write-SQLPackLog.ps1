function Write-SQLPackLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    # $logFile = Join-Path $PSScriptRoot "..\Logs\module.log"
    # $entry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
    # Add-Content -Path $logFile -Value $entry 

    write-host $Message -ForegroundColor Green


}
