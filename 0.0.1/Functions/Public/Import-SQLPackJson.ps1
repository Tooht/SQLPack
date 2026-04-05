 function Import-SQLPackJson
 {
    param (
        [Parameter(Mandatory=$true)]
            [string]$FilePath
     )

    if (Test-Path -Path $FilePath) {
        try {
            $jsonContent = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
            return $jsonContent
        }
        catch {
                $ret= @{
                    Success = $false
                    ErrorMessage = $_.Exception.Message
                }   
                return $ret

        }
    }
    else {
         $ret= @{
                    Success = $false
                    ErrorMessage = "File not found: $FilePath" 
                }   
                return $ret
    }

}