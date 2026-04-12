function Write-SQLIntWindowsEvent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({ Get-SQLPackConfig "InUse.WindowsEventLogConfig.AvailableLevels" } )]
        [ValidateScript( { $_ -in (Get-SQLPackConfig "InUse.WindowsEventLogConfig.AvailableLevels") } )]
        [string]$EntryType ,
        
        [Parameter(Mandatory = $false)]
        [int]$EventId = 1000
    )
    $FunctionName = (Get-SQLIntFunctionName)

    Write-Verbose "[$FunctionName] Preparing to write to Windows Event Log with message: $Message, entry type: $EntryType, event ID: $EventId"

    $Configs = Get-SQLPackConfig
    Write-Verbose "[$FunctionName] WindowsEventLogConfig: $($Configs.InUse.WindowsEventLogConfig | ConvertTo-Json -Depth 5)"

    $Source = $Configs.InUse.WindowsEventLogConfig.Source
    Write-Verbose "[$FunctionName] Windows Event Log Source: $Source"

    if ($EntryType -eq $null) {
        $EntryType = $Configs.WindowsEventLogConfig.DefaultLevel    
    }
    Write-Verbose "[$FunctionName] Windows Event Log Entry Type: $EntryType"

    try {
        Write-EventLog -LogName 'Application' -Source $Source -EntryType $EntryType -Message $Message -EventId $EventId
        Write-Verbose "[$FunctionName] Event log entry written successfully"
    }
    catch {
        Write-Error "Failed to write to Windows Event Log: $_"
    }

    Write-Verbose "[$FunctionName] Finished Write-SQLPackWindowsEvent function"
}