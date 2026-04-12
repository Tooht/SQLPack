function Write-SQLPackLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warning", "Error", "Message", "None")]
        [string]$Level = 'None',

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({ Get-SQLPackConfig "InUse.Constants.LogLevels" } )]
        [ValidateScript( { $_ -in (Get-SQLPackConfig "InUse.Constants.LogLevels") } )]
        [string]$Level2,
        
        [Parameter(Mandatory = $false)]
        [switch]$ToFile,
        
        [Parameter(Mandatory = $false)]
        [switch]$ToConsole,
        
        [Parameter(Mandatory = $false)]
        [switch]$ToWindowsEvents,
        
        [Parameter(Mandatory = $false)]
        [switch]$ToSQLErrorLog
    )
    $FunctionName = (Get-SQLIntFunctionName)
    Write-Verbose   "[$FunctionName] Preparing to write log with message: $Message, level: $Level"

    $Configs = Get-SQLPackConfig
    Write-Verbose   "[$FunctionName] Configs loaded"
    
    # Default to all outputs if none specified
    if (-not ($ToFile -or $ToConsole -or $ToWindowsEvents -or $ToSQLErrorLog)) {
        $ToFile = ($Configs.InUse.LogFileConfig.ActiveChannel -eq "True")
        $ToConsole = ($Configs.InUse.ConsoleLogConfig.ActiveChannel -eq "True")
        $ToWindowsEvents = ($Configs.InUse.WindowsEventLogConfig.ActiveChannel -eq "True")
        $ToSQLErrorLog = ($Configs.InUse.SQLErrorLogConfig.ActiveChannel -eq "True")
    }
    
    Write-Verbose "[$FunctionName] Log Message: $Message"
    Write-Verbose "[$FunctionName] Log Level: $Level"   
    Write-Verbose "[$FunctionName] To File: $ToFile"
    Write-Verbose "[$FunctionName] To Console: $ToConsole"
    Write-Verbose "[$FunctionName] To Windows Events: $ToWindowsEvents"
    Write-Verbose "[$FunctionName] To SQL Error Log: $ToSQLErrorLog"

    if ($ToFile) {
        $LogLevel = ($Configs.InUse.LogFileConfig.AvailableLevels | Where-Object { $_ -eq $Level })
        if (-not $LogLevel) {
            Write-Verbose "[$FunctionName] Invalid log level '$Level' for file logging."
            $LogLevel = ($Configs.InUse.LogFileConfig.DefaultLevel)
        }
        Write-Verbose "[$FunctionName] Log level '$Level' mapped to value '$LogLevel' for file logging."

        Write-SQLIntLogFile -Message $Message -Level $Level
        Write-Verbose "[$FunctionName] Log written to file successfully" 
    }

    if ($ToConsole) {
        $ConsoleLevel = ($Configs.InUse.ConsoleLogConfig.AvailableLevels | Where-Object { $_ -eq $Level })
        if (-not $ConsoleLevel) {
            Write-Verbose "[$FunctionName] Invalid console level '$Level' for console logging."
            $ConsoleLevel = ($Configs.InUse.ConsoleLogConfig.DefaultLevel)
        }
        Write-Verbose "[$FunctionName] Log level '$Level' mapped to value '$ConsoleLevel' for Console logging."

        Write-SQLIntConsole -Message $Message -Level $ConsoleLevel
        Write-Verbose "[$FunctionName] Log written to console successfully"
    }

    if ($ToWindowsEvents) {
        $WindowsEventLevel = ($Configs.InUse.WindowsEventLogConfig.AvailableLevels | Where-Object { $_ -eq $Level })
        if (-not $WindowsEventLevel) {
            Write-Verbose "[$FunctionName] Invalid Windows Event level '$Level' for Windows Event logging."
            $WindowsEventLevel = ($Configs.InUse.WindowsEventLogConfig.DefaultLevel)
        }
        Write-Verbose "[$FunctionName] Log level '$Level' mapped to value '$WindowsEventLevel' for Windows Event logging."

        Write-SQLIntWindowsEvent -Message $Message -EntryType $WindowsEventLevel
        Write-Verbose "[$FunctionName] Log written to Windows events successfully"
    }

    if ($ToSQLErrorLog) {
        $SQLErrorLogLevel = ($Configs.InUse.SQLErrorLogConfig.AvailableLevels | Where-Object { $_ -eq $Level })
        if (-not $SQLErrorLogLevel) {
            Write-Verbose "[$FunctionName] Invalid Error Log level '$Level' for SQL Error Log logging."
            $SQLErrorLogLevel = ($Configs.InUse.SQLErrorLogConfig.DefaultLevel)
        }

        Write-Verbose "[$FunctionName] Log level '$Level' mapped to value '$SQLErrorLogLevel' for Windows Event logging."


        Write-SQLIntSQLErrorLog -Message $Message -Level $SQLErrorLogLevel
        Write-Verbose "[$FunctionName] Log written to SQL Error Log successfully"
    }

    Write-Verbose "[$FunctionName] Finished Write-SQLPackLog function"
}