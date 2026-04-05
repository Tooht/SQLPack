function Set-SQLPackConfig {
    param([hashtable]$Config)

    $configFile = Join-Path $PSScriptRoot "..\Config\settings.json"
    $Config | ConvertTo-Json -Depth 5 | Set-Content $configFile
}
