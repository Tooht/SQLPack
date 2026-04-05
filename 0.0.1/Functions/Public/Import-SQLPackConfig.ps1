function Import-SQLPackConfig {
    [CmdletBinding()]
    
    $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack\Configs.json"
    Write-Verbose "ConfigFilePath: $ConfigFilePath"

    if (Test-Path -Path $ConfigFilePath) {
        write-verbose "Config file found at $ConfigFilePath"
        try {
            $jsonContent = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
            Write-Verbose "Config file content successfully read and parsed."
            return $jsonContent
        }
        catch {
            Write-Verbose "Error reading or parsing config file: $_"
            $ret = @{
                Success      = $false
                ErrorMessage = $_.Exception.Message
            }   
            Write-Verbose "Returning error information: "+ $_.Exception.Message  
            return $ret
        }
    }
    else {
        Write-Verbose "Config file not found at $ConfigFilePath"
        $ret = @{
            Success      = $false
            ErrorMessage = "ConfigFile not found on $ConfigFilePath" 
        }   
        Write-Verbose "Returning error information: ConfigFile not found on $ConfigFilePath"  

        return $ret
    }



}


