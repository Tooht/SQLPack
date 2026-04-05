function Get-SQLPackConfig {
    [CmdletBinding()]
    
    $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack\Configs.json"
    Write-Verbose "Config file path: $ConfigFilePath"

    if (Test-Path -Path $ConfigFilePath) {
        try {
            $jsonContent = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
            return $jsonContent
        }
        catch {
            $ret = @{
                Success      = $false
                ErrorMessage = $_.Exception.Message
            }   
            return $ret

        }
    }
    else {
        $ret = @{
            Success      = $false
            ErrorMessage = "ConfigFile not found on $ConfigFilePath" 
        }   
        return $ret
    }



}


