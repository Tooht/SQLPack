function Write-SQLIntSQLErrorLog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({ Get-SQLPackConfig "InUse.SQLErrorLogConfig.AvailableLevels" } )]
        [ValidateScript( { $_ -in (Get-SQLPackConfig "InUse.SQLErrorLogConfig.AvailableLevels") } )]
        [string]$Level ,

        [Parameter(Mandatory = $false)]
        [string]$State
    )
    $FunctionName = (Get-SQLIntFunctionName)
    Write-Verbose "[$FunctionName] Preparing to write SQL Error Log log entry with message: $Message, level: $Level"

    $Configs = Get-SQLPackConfig
    Write-Verbose "[$FunctionName] Config loaded with success"

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Verbose "[$FunctionName] Log message: $logMessage"

    if (-not $Level) { $Level = $Configs.InUse.SQLErrorLogConfig.DefaultLevel }
    $LevelSimple = $Level.replace("Information", "10").replace("Warning", "13").replace("Error", "19")
    Write-Verbose "[$FunctionName] Log level '$Level' Converted to value '$LevelSimple' ."


    if (-not $State) { $State = $Configs.InUse.SQLErrorLogConfig.DefaultState }
    Write-Verbose "[$FunctionName] Log State: $State"

    $Query = "RAISERROR ('$Message', $LevelSimple, $State) WITH LOG;"
    Write-Verbose "[$FunctionName] SQL Query '$Query'"

    Invoke-SQLIntQuery -SQLQuery $Query -ErrorAction SilentlyContinue

    Write-Verbose "[$FunctionName] Finished Write-SQLIntConsole function"
}