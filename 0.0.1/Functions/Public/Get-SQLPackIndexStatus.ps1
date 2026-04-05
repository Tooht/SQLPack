 function Get-SQLPackIndexStatus{
param (
        [Parameter(Mandatory=$false)]
            [int] $MaxRecords=100,
        [Parameter(Mandatory=$false)]
            [switch] $NotFomated,
            
        [Parameter(Position = 0, Mandatory)]
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
            [int]$MinFragmentation=30,       
        [Parameter(Mandatory=$false)]
            [ValidateSet("LastYear","LastMonth","LastWeek","LastDay")]
            [string]$Period
                )
 
 
    if($ExcludeNonClustered)
        {$TypeFilter= '9'}
    else
        {$TypeFilter= '2'}
    
    if($IncludeHeaps){$TypeFilter+= ',0'}

    if($IncludeClustered){$TypeFilter+= ',1'}

    $Query = "SELECT  
        dbtables.[name] AS 'TableName', 
        dbschemas.[name] as 'SchemaName',  
        dbindexes.[name] AS 'IndexName', 
        dbindexes.type_desc AS 'IndexType',
        Concat(cast(indexstats.avg_fragmentation_in_percent as decimal(6,2)), '%') as PercentFrag
        FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
	        INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
	        INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
	        INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id] AND indexstats.index_id = dbindexes.index_id
        WHERE dbindexes.type in ($TypeFilter) AND indexstats.avg_fragmentation_in_percent >= $MinFragmentation 
        ORDER BY indexstats.avg_fragmentation_in_percent DESC ,dbtables.[name],dbschemas.[name], dbindexes.[name]"


    #$Result = Invoke-DBACommonSQLQuery -Query $Query -Instance $Instance -InstancePort $InstancePort -QueryTimeOut $QueryTimeOut -DatabaseName $DatabaseName

    if($NotFomated)
        {$Result}
    ELSE
        {
        if($Result -eq $null)
            {return "No Index found" }
        ELSE
            {$Result|FT}
        }
}