function Get-SQLPackDatabasesNames {
    param (      
        [Parameter(Mandatory = $false)]
        [ValidateSet("UserDatabase", "SystemDatabase")]
        [string[]]$Type   ,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ONLINE", "Not ONLINE" )]
        [string[]]$State   

    )
    $FunctionName=(Get-SQLIntFunctionName)

    Write-Verbose "[$FunctionName] Preparing to retrieve database names with filters: Type='$($Type -join ",")', State='$($State -join ",")'"


    if ($Type.Count -gt 0) {
        $Type | ForEach-Object {      
            if ($_ -eq "UserDatabase") { $TypeFilter += "OR [name] not in ('master','msdb','tempdb','model','distribution') " }
            if ($_ -eq "SystemDatabase") { $TypeFilter += "OR [name] in ('master','msdb','tempdb','model','distribution') " }
        }
        $TypeFilter = " AND ( " + $TypeFilter.Substring(3) + " ) "
    }
    Write-Verbose "[$FunctionName] Type filter: $TypeFilter"

    if ($State.Count -gt 0) {
        $State | ForEach-Object { $StateFilter += ", '$_' " }
        $StateFilter = " AND state_desc in ( " + $StateFilter.Substring(2) + " ) "
    }
    Write-Verbose "[$FunctionName] State filter: $StateFilter"

    $Query = "Select [name] as DatabaseName from sys.databases WHERE 1=1 $TypeFilter $StateFilter"
    Write-Verbose "[$FunctionName] Executing query: $Query"

    $dbs = invoke-sqlcmd -query $query 
    Write-Verbose "[$FunctionName] Retrieved databases: $($dbs.databasename -join ","   )   "
    
    Return $dbs.databasename

    Write-Verbose "[$FunctionName] Finished Get-SQLPackDatabasesNames function"

}