 function Get-SQLPackIndexStatus{
param (
        [Parameter(Mandatory=$false)]
            [int] $MaxRecords=100,

        [Parameter(Mandatory=$false)]
            [switch] $NotFomated,
            
        [Parameter(Mandatory=$true)]
            [ArgumentCompleter({Get-SQLPackDatabasesNames } )]
            [ValidateScript( { $_ -in (Get-SQLPackDatabasesNames)} )]
            [string]$DatabaseName,

        [Parameter(Mandatory=$false)]
            [switch]$IncludeHeaps,

        [Parameter(Mandatory=$false)]
            [switch]$IncludeClustered, 

        [Parameter(Mandatory=$false)]
            [switch]$ExcludeNonClustered,
                    
        [Parameter(Mandatory=$false)]
            [int]$MinFragmentation=30
                )
    $FunctionName=(Get-SQLIntFunctionName)

    Write-Verbose "[$FunctionName] Preparing to get SQL index fragmentation status with parameters: DatabaseName='$DatabaseName', IncludeHeaps='$IncludeHeaps', IncludeClustered='$IncludeClustered', ExcludeNonClustered='$ExcludeNonClustered', MinFragmentation='$MinFragmentation', Period='$Period'"       

 
 
    if($ExcludeNonClustered)
        {$IndexTypeFilter= '9'}
    else
        {$IndexTypeFilter= '2'}
    
    if($IncludeHeaps){$IndexTypeFilter+= ',0'}

    if($IncludeClustered){$IndexTypeFilter+= ',1'}

    $Query = "SELECT TOP ($MaxRecords)
        dbtables.[name] AS 'TableName', 
        dbschemas.[name] as 'SchemaName',  
        dbindexes.[name] AS 'IndexName', 
        dbindexes.type_desc AS 'IndexType',
        Concat(cast(indexstats.avg_fragmentation_in_percent as decimal(6,2)), '%') as PercentFrag
        FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
	        INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
	        INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
	        INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id] AND indexstats.index_id = dbindexes.index_id
        WHERE dbindexes.type in ($IndexTypeFilter) AND indexstats.avg_fragmentation_in_percent >= $MinFragmentation 
        ORDER BY indexstats.avg_fragmentation_in_percent DESC ,dbtables.[name],dbschemas.[name], dbindexes.[name]"
        Write-Verbose "[$FunctionName] Query to execute: $Query"

        Write-host "DB: $DatabaseName"

        Invoke-SQLIntQuery -SQLQuery $Query -DatabaseName master
        Write-Verbose "[$FunctionName] Query executed with success"


}