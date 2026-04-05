function Reset-SQLPackConfigFile {
    param (
        [Parameter(Mandatory = $false)]
        [switch] $OverrideExisting,
        [Parameter(Mandatory = $false)]
        [string] $Path  
    )
    Write-Verbose "Reset-SQLPackConfigFile called with OverrideExisting=$OverrideExisting and Path=$Path"

    $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack\Configs.json" 
    Write-Verbose "Config file path set to $ConfigFilePath" 

    $Configs = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
    Write-Verbose "Current Configurations loaded from file: $ConfigFilePath"


    $Configs.InUse.Log.FilePath = $Configs.Defaults.Log.FilePath
    $Configs.InUse.Log.FileName = $Configs.Defaults.Log.FileName
    $Configs.InUse.Log.IncludeTimeStamp = $Configs.Defaults.Log.IncludeTimeStamp
    Write-Verbose "Updated InUse configuration with Default values. Now saving to file $ConfigFilePath"

    $Configs | convertto-json -Depth 5 | Out-File -FilePath $ConfigFilePath -Encoding utf8 -Force
    Write-Verbose "Reset values of Config file $ConfigFilePath"


}