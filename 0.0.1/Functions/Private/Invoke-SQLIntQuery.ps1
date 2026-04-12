function Invoke-SQLIntQuery {
    param (
        [Parameter(Mandatory = $false)]
        [string]$Instance,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({ Get-SQLPackDatabasesNames } )]
        [ValidateScript( { $_ -in (Get-SQLPackDatabasesNames) } )]
        [string]$DatabaseName="master",
        
        [Parameter(Mandatory = $false)]
        [int] $QueryTimeOut = 0,
        
        [Parameter(Mandatory = $false)]
        [int] $MaxRecords = 0,

        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true, 
            Position = 0,
            HelpMessage = "SQL Query to be executed on SQLServer"
        )]       
        [string]$SQLQuery
    )
    $FunctionName = (Get-SQLIntFunctionName)

    Write-Verbose "[$FunctionName] Preparing to execute SQL query with parameters: Instance='$Instance', DatabaseName='$DatabaseName', QueryTimeOut='$QueryTimeOut', MaxRecords='$MaxRecords', SQLQuery='$SQLQuery'"



    $Configs = Get-SQLPackConfig 
    Write-Verbose "[$FunctionName] Configurations loaded with success"

    if ($Instance -eq "") {
        $Instance = $Configs.InUse.SQLServer.Instance
        Write-Verbose "[$FunctionName] Instance is empty. Setting to default value '$Instance' from configuration file  "
    }
    if ($DatabaseName -eq "default") {
        $DatabaseName = $Configs.InUse.SQLServer.DatabaseName
        Write-Verbose "[$FunctionName] DatabaseName is empty. Setting to default value '$DatabaseName' from configuration file  "
    }
    if ($QueryTimeOut -eq "") {
        $QueryTimeOut = $Configs.InUse.SQLServer.QueryTimeOut
        Write-Verbose "[$FunctionName] QueryTimeOut is empty. Setting to default value '$QueryTimeOut' from configuration file  "
    }
    if ($MaxRecords -eq "") {
        $MaxRecords = $Configs.InUse.SQLServer.MaxRecords
        Write-Verbose "[$FunctionName] MaxRecords is empty. Setting to default value '$MaxRecords' from configuration file  "
    }


    $ConnectionParams = @{
        ServerInstance = $Instance 
        Database       = $DatabaseName 
        QueryTimeOut   = $QueryTimeOut
    }
    Write-Verbose "[$FunctionName] Using connection parameters: $($ConnectionParams | ConvertTo-Json -Depth 5)"
    #$SQLQuery = "$SQLQuery ; Print '[$FunctionName] Invoke-Sqlcmd OK'"

    Write-Verbose "[$FunctionName] Query to run '$SQLQuery'"

    Write-Verbose "[$FunctionName] Verbose Disabled"
    $VerboseState = $VerbosePreference 
    $VerbosePreference = "SilentlyContinue"

    $Result=Invoke-Sqlcmd -Query $SQLQuery @ConnectionParams 
    
    $VerbosePreference = $VerboseState
    Write-Verbose "[$FunctionName] Verbose Re-Enabled"

    Write-Verbose "[$FunctionName] Query executed. Records: $($Result.Count) "

    return $Result
}
