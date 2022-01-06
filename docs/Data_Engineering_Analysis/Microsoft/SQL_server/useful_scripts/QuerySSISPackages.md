# Querying your SSIS packages

For analysis purposes it might be handy to look for a certain string in the package definition. For SSIS packages 
in the package store, you can use the following query.

=== "Package Store"
    ``` sql linenums="1"
    SELECT TOP 1000
        F.foldername
    ,	P.[name]
    ,	P.[id]
    ,	P.[description]
    ,	[XML_content]		= CAST(CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX), packagedata)) AS XML)
    ,	P.[createdate]
    ,	P.[folderid]
    ,	P.[ownersid]
    ,	P.[packagedata]
    ,	P.[packageformat]
    ,	P.[packagetype]
    ,	P.[vermajor]
    ,	P.[verminor]
    ,	P.[verbuild]
    ,	P.[vercomments]
    ,	P.[verid]
    ,	P.[isencrypted]
    ,	P.[readrolesid]
    ,	P.[writerolesid]
    FROM [msdb].[dbo].[sysssispackages] P
        JOIN msdb.dbo.sysssispackagefolders F
            ON P.folderid = F.folderid
    WHERE 1=1
        AND CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX), packagedata)) LIKE '%<you search string>%'
    ```