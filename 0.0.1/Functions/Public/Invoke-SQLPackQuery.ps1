function Invoke-SQLPackQuery {
    param (
        [Parameter(Mandatory = $false)]
            [string]$Instance,
        [Parameter(Mandatory=$false)]
            [ArgumentCompleter({Get-SQLPackDatabasesNames} )]
            [ValidateScript( { $_ -in (Get-SQLPackDatabasesNames)} )]
            [string]$DatabaseName="default",
        [Parameter(Mandatory = $false)]
            [int] $QueryTimeOut=0,
        [Parameter(Mandatory = $false)]
            [int] $MaxRecords=0,
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true, 
            Position = 0,
            HelpMessage = "SQL Query to be executed on SQLServer"
        )]       
        [string]$SQLQuery
    )
    Write-Verbose "Invoke-SQLPackQuery called with parameters: Instance=$Instance, Port=$Port, DatabaseName=$DatabaseName, Timeout=$Timeout, MaxRecords=$MaxRecords, SQLQuery=$SQLQuery"

    $Configs = Get-SQLPackConfig 
    Write-Verbose "Configurations loaded: $($Configs.InUse.SQLServer | ConvertTo-Json -Depth 5)"

    if($Instance -eq "")
    {
        $Instance = $Configs.InUse.SQLServer.Instance
        Write-Verbose "Instance is empty. Setting to default value '$Instance' from configuration file  "
    }
    if($DatabaseName -eq "default")
    {
        $DatabaseName = $Configs.InUse.SQLServer.DatabaseName
        Write-Verbose "DatabaseName is empty. Setting to default value '$DatabaseName' from configuration file  "
    }
    if($QueryTimeOut -eq "")
    {
        $QueryTimeOut = $Configs.InUse.SQLServer.QueryTimeOut
        Write-Verbose "QueryTimeOut is empty. Setting to default value '$QueryTimeOut' from configuration file  "
    }
    if($MaxRecords -eq "")
    {
        $MaxRecords = $Configs.InUse.SQLServer.MaxRecords
        Write-Verbose "MaxRecords is empty. Setting to default value '$MaxRecords' from configuration file  "
    }
    
    $ConnectionParams = @{
        ServerInstance = $Instance 
        Database = $DatabaseName 
        QueryTimeOut = $QueryTimeOut
    }
    Write-Verbose "Using connection parameters: $($ConnectionParams | ConvertTo-Json -Depth 5)"

    $Result = Invoke-Sqlcmd -Query $SQLQuery @ConnectionParams 
    Write-Verbose "Query executed. Records: $($Result.Count) "

if ($NotFomated)
    { return$Result }
    ELSE {
        if ($null -eq $Result)
        { return "No Index found" }
        ELSE
        { return ($Result | Format-Table )}
    }
}