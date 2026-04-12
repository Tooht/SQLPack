function Write-SQLIntLogFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({Get-SQLPackConfig "InUse.LogFileConfig.AvailableLevels" } )]
        [ValidateScript( { $_ -in (Get-SQLPackConfig "InUse.LogFileConfig.AvailableLevels")} )]
        [string]$Level = 'INFO',
        
        [Parameter(Mandatory = $false)]
        [string]$LogPath 
    )
    $FunctionName = (Get-SQLIntFunctionName)

    Write-Verbose   "[$FunctionName] Preparing to write log entry with message: $Message, level: $Level, log path: $LogPath"

    $Configs = Get-SQLPackConfig

    Write-Verbose "[$FunctionName] LogFileConfig loaded with success"

    If (-not $LogPath) {
        Write-Verbose "[$FunctionName] LogPath parameter not provided, using default from configuration"
        if (-not $script:LogFileFullPath) {
            Write-Verbose "[$FunctionName] Script Log File not defined"

            $NewLogFolderName = $Configs.InUse.LogFileConfig.FilePath
            $NewLogFileName = $Configs.InUse.LogFileConfig.FileName.replace("{date}", (Get-Date).ToString("yyyyMMddHHmmss"))
            
            $script:LogFileFullPath = Join-Path -Path  $NewLogFolderName -ChildPath $NewLogFileName       
            Write-Verbose "[$FunctionName] Log file path set to: $script:LogFileFullPath"
        }
        $LogPath = $script:LogFileFullPath
        Write-Verbose "[$FunctionName] Using log file path: $LogPath"
    }

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Verbose "[$FunctionName] Log entry to write: $logEntry"
    
    try {
        Add-Content -Path $LogPath -Value $logEntry -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to write to log file: $_"
    }

    Write-Verbose "[$FunctionName] Finished Write-SQLIntLogFile function"
}