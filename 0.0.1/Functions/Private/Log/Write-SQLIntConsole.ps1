function Write-SQLIntConsole {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({Get-SQLPackConfig "InUse.ConsoleLogConfig.AvailableLevels" } )]
        [ValidateScript( { $_ -in (Get-SQLPackConfig "InUse.ConsoleLogConfig.AvailableLevels")} )]
        [string]$Level 

    )
    $FunctionName=(Get-SQLIntFunctionName)

    Write-Verbose "[$FunctionName] Preparing to write console log entry with message: $Message, level: $Level"

    $Configs = Get-SQLPackConfig
    Write-Verbose "[$FunctionName] ConsoleLogConfig loaded with success"

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Verbose "[$FunctionName] Log message: $logMessage"

    $hostParams = @{ NoNewline = $false }
    if ($null -ne $Configs.InUse.ConsoleLogConfig.Layouts.$Level.ForegroundColor) 
        {$hostParams.ForegroundColor = $Configs.InUse.ConsoleLogConfig.Layouts.$Level.ForegroundColor}
    if ($null -ne $Configs.InUse.ConsoleLogConfig.Layouts.$Level.BackgroundColor) 
        {$hostParams.BackgroundColor = $Configs.InUse.ConsoleLogConfig.Layouts.$Level.BackgroundColor}
    Write-Verbose "[$FunctionName] Host parameters: $($hostParams | ConvertTo-Json -Depth 5)"

    Write-Host $logMessage @hostParams 

    Write-Verbose "[$FunctionName] Finished Write-SQLIntConsole function"
}