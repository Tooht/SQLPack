function Get-SQLPackDatabasesNames {
    param (      
        [Parameter(Mandatory = $false)]
        [ValidateSet("UserDatabase", "SystemDatabase")]
        [string[]]$Type   ,
        [Parameter(Mandatory = $false)]
        [ValidateSet("ONLINE", "RESTORING", "RECOVERING", "RECOVERY_PENDING", "SUSPECT", "EMERGENCY", "OFFLINE", "COPYING", "OFFLINE_SECONDARY")]
        [string[]]$State   

    )
    Write-Verbose "Getting databases names from SQL Server instance with filters: Type = $($Type -join ",") and State = $($State -join ",")"

    if ($Type.Count -gt 0) {
        $Type | ForEach-Object {      
            if ($_ -eq "UserDatabase") { $TypeFilter += "OR [name] not in ('master','msdb','tempdb','model','distribution') " }
            if ($_ -eq "SystemDatabase") { $TypeFilter += "OR [name] in ('master','msdb','tempdb','model','distribution') " }
        }
        $TypeFilter = " AND ( " + $TypeFilter.Substring(3) + " ) "
    }
    write-verbose "Type filter: $TypeFilter"

    if ($State.Count -gt 0) {
        $State | ForEach-Object { $StateFilter += ", '$_' " }
        $StateFilter = " AND state_desc in ( " + $StateFilter.Substring(2) + " ) "
    }
    write-verbose "State filter: $StateFilter"

    $Query = "Select [name] as DatabaseName from sys.databases WHERE 1=1 $TypeFilter $StateFilter"
    write-verbose "Executing query: $Query"

    $dbs = invoke-sqlcmd -query $query 
    write-verbose "Retrieved databases: $($dbs.databasename -join ","   )   "
    
    Return $dbs.databasename

}