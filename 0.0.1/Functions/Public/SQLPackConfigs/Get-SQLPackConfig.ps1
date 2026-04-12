function Get-SQLPackConfig {
    [CmdletBinding()]
    param(
        [Parameter( Mandatory = $false)]
        [string]$ConfigPath
    )
    $FunctionName = (Get-SQLIntFunctionName)
    Write-Verbose "[$FunctionName] Starting Get-SQLPackConfig function"
    
    if (-not $script:Configs) {
        Write-Verbose "[$FunctionName] Loading SQLPack Configurations"

        $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack\Configs.json"
        Write-Verbose "[$FunctionName] Config file path: $ConfigFilePath"

        if (Test-Path -Path $ConfigFilePath) {
            try {
                $script:Configs = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
                Write-Verbose "[$FunctionName] Configurations loaded successfully"
            }
            catch { Write-Error $_.Exception.Message }
        }
        else { Write-Error "ConfigFile not found on $ConfigFilePath" }
    }
    Write-Verbose "[$FunctionName] Full Configurations loaded with success"

    $Result = $script:Configs

    if ($ConfigPath) {
        Write-Verbose "[$FunctionName] Serche for node $ConfigPath"
    
        foreach ($Folder in $ConfigPath.Split(".")) {
            Write-Verbose "[$FunctionName] Filter for folder $Folder "
            $Result = $Result.$Folder
        }
        Write-Verbose "[$FunctionName] Retrieved value: $Configs"
    }

    return $Result

    Write-Verbose "[$FunctionName] Finished Get-SQLPackConfig function"
}


