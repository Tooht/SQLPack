function Set-SQLPackConfigNode {
    param (
        [Parameter(ParameterSetName = 'Value', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Default', Mandatory = $true)]
        [string] $NodePath,
        [Parameter(ParameterSetName = 'Value', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Default', Mandatory = $false)]
        [string] $NodeNewValue,
        [Parameter(ParameterSetName = 'Value', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Default', Mandatory = $true)]
        [switch] $UseDefault
        
    )
    $FunctionName = (Get-SQLIntFunctionName)
    Write-Verbose "[$FunctionName] Set-SQLPackConfigNode called with NodePath=$NodePath and NodeValue=$NodeValue"

    $ConfigFilePath = "$ENV:Userprofile\AppData\Local\SQLPack\Configs.json" 
    Write-Verbose "[$FunctionName] Config file path set to $ConfigFilePath" 

    $Configs = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
    Write-Verbose "[$FunctionName] Current Configurations loaded from file: $ConfigFilePath"


    if ($UseDefault) {
        $ConfigsNewValue = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json

        foreach ($Folder in $NodePath.replace("InUse", "Defaults").Split(".")) {
            $ConfigsNewValue = $ConfigsNewValue.$Folder
        }
        $NodeNewValue = $ConfigsNewValue
    }
    Write-Verbose "[$FunctionName] New value define to :'$NodeNewValue'"

    $S0 = $NodePath.Split(".")[0]
    $S1 = $NodePath.Split(".")[1]
    $S2 = $NodePath.Split(".")[2]
    $S3 = $NodePath.Split(".")[3]
    $S4 = $NodePath.Split(".")[4]

    $C = ($NodePath.Split(".")).Count

    switch ($C) {
        1 { $Configs.$S0 = $NodeNewValue }
        2 { $Configs.$S0.$S1 = $NodeNewValue }
        3 { $Configs.$S0.$S1.$S2 = $NodeNewValue }
        4 { $Configs.$S0.$S1.$S2.$S3 = $NodeNewValue }
        5 { $Configs.$S0.$S1.$S2.$S3.$S4 = $NodeNewValue }
    }

    $script:Configs = $Configs
    Write-Verbose "[$FunctionName] Configs Variable Updated to value: $NodeNewValue"

    $Configs | convertto-json -Depth 5 | Out-File -FilePath $ConfigFilePath -Encoding utf8 -Force
    Write-Verbose "[$FunctionName] Config file $ConfigFilePath Updated"

    Write-Verbose "[$FunctionName] Finished Get-SQLPackConfig function"


}