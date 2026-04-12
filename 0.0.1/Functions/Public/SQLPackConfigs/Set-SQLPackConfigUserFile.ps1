function Set-SQLPackConfigUserFile {
    param (
        [Parameter(Mandatory = $false)]
        [switch] $Force 
    )
    $FunctionName = (Get-SQLIntFunctionName)

    $ConfigTemplateFile = $PSScriptRoot.Replace("Functions\Private\SQLPackConfigs", "Config\configTemplate.json").Replace("Functions\Public\SQLPackConfigs", "Config\configTemplate.json")   
    Write-Verbose "[$FunctionName] Reading config template from $ConfigTemplateFile"

    $Configs = Get-Content -Path $ConfigTemplateFile -Raw | ConvertFrom-Json
    Write-Verbose "[$FunctionName] Config template read successfully. Creating config file with default settings from template."


    $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack" 
    Write-Verbose "[$FunctionName] Config file path set to $ConfigFilePath"

    if (! (Test-Path $ConfigFilePath)) { New-Item -ItemType Directory -Path $ConfigFilePath }
    Write-Verbose "[$FunctionName] Config directory verified at $ConfigFilePath"


    $ConfigFilePath = $ConfigFilePath + "\Configs.json"
    if (Test-Path -Path $ConfigFilePath) {
        if ($Force) { Write-Verbose "[$FunctionName] Overriding existing config file at $ConfigFilePath" }
        else { Write-Verbose "[$FunctionName] Config file already exists at $ConfigFilePath. Use -Force to overwrite it." ; return }
    }       
    
    Write-Verbose "[$FunctionName] Creating config file at $ConfigFilePath"
    $Configs | convertto-json -Depth 5 | Out-File -FilePath $ConfigFilePath -Encoding utf8 -Force
    Write-Verbose "[$FunctionName] Config file created at $ConfigFilePath with default settings from $ConfigTemplateFile" 

}