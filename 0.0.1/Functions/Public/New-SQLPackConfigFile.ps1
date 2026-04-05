function New-SQLPackConfigFile {
    param (
        [Parameter(Mandatory = $false)]
        [switch] $Force,
        [Parameter(Mandatory = $false)]
        [string] $Path  
    )

    $ConfigTemplateFile = $PSScriptRoot.Replace("Functions\Private","Config\configTemplate.json").Replace("Functions\Public","Config\configTemplate.json")   
    Write-Verbose "Reading config template from $ConfigTemplateFile"

    $Configs = Get-Content -Path $ConfigTemplateFile -Raw | ConvertFrom-Json
    Write-Verbose "Config template read successfully. Creating config file with default settings from template."


    if ($Path) 
    { $ConfigFilePath = $Path }
    else
    { $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack" }
    Write-Verbose "Config file path set to $ConfigFilePath"

    if (! (Test-Path $ConfigFilePath))
    { New-Item -ItemType Directory -Path $ConfigFilePath }
    Write-Verbose "Config directory verified at $ConfigFilePath"


    $ConfigFilePath = $ConfigFilePath + "\Configs.json"
    if (Test-Path -Path $ConfigFilePath) {
        if ($Force) 
            { Write-Verbose "Overriding existing config file at $ConfigFilePath" }
        else { 
            Write-Verbose "Config file already exists at $ConfigFilePath. Use -Force to overwrite it." 
            return 
        }
    }       
    Write-Verbose "Creating config file at $ConfigFilePath"
    
    $Configs | convertto-json -Depth 5 | Out-File -FilePath $ConfigFilePath -Encoding utf8 -Force
    Write-Verbose "Config file created at $ConfigFilePath with default settings from $ConfigTemplateFile" 


}