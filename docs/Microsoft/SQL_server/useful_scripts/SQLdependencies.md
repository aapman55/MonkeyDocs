# SQL dependencies
In SSMS you can right click a database object such as a table or view to view the dependencies. These dependencies 
are not bound to physical relations such as foreign keys. If the object is referenced in another view or store procedure,
it will also show up.

Manually requesting the dependencies might not be the best way to go. So I have written a script to find all the 
usages across all the databases.

``` sql linenums="1"
/*
 *	Clean up #TEMP if already exists
 */
IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL
	DROP TABLE #TEMP

DECLARE @ReferencedDatabase		NVARCHAR(50)		= N'<Enter database name of referenced entity>';
/* Schemaname: Leave empty to show all */
DECLARE @ReferencedSchemaName	NVARCHAR(100)		= N'%dbo%';	
/* Entiteitname (Tables/views etc): Leave empty to show all */
DECLARE @ReferencedEntityName	NVARCHAR(100)		= N'%%';	

DECLARE @sql NVARCHAR(2000) =
'
USE ?;

INSERT INTO ##Temp

SELECT 
       [Referencing Database]            =      ''?'' 
,      [Referencing Schema]       =      s.name 
,      [Referencing Object name]  =      ao.name 
,      [Referencing Object Type]  =      ao.type_desc 
,      [Referenced Database]             =      sql.referenced_database_name 
,      [Referenced Schema]               =      sql.referenced_schema_name 
,      [Referenced Object name]   =      sql.referenced_entity_name 
,      [Referenced Object Type]   =      aoReferenced.type_desc 
,      [ReferencedStillExists]            =      CASE WHEN aoReferenced.name IS NULL THEN 0 ELSE 1 END 
FROM sys.sql_expression_dependencies sql 
       JOIN sys.all_objects ao 
             ON ao.object_id = sql.referencing_id 
       JOIN sys.schemas s 
             ON s.schema_id = ao.schema_id 
       LEFT JOIN 
       ( 
             {ReferencedDatabase}.sys.all_objects aoReferenced 
             JOIN   {ReferencedDatabase}.sys.schemas aoReferencedSchema 
             ON aoReferenced.schema_id = aoReferencedSchema.schema_id     
       ) 
             ON aoReferenced.name COLLATE Latin1_General_CI_AS = sql.referenced_entity_name COLLATE Latin1_General_CI_AS
             AND aoReferencedSchema.name COLLATE Latin1_General_CI_AS = sql.referenced_schema_name COLLATE Latin1_General_CI_AS
WHERE 1=1
	AND (referenced_database_name = ''{ReferencedDatabase}'' OR (referenced_database_name IS NULL AND ''{ReferencedDatabase}'' = ''?''))
	AND (referenced_schema_name LIKE ''{ReferencedSchema}'' OR ''{ReferencedSchema}'' = '''')
	AND (referenced_entity_name LIKE ''{ReferencedEntity}'' OR ''{ReferencedEntity}'' = '''')
ORDER BY [Referencing Database], [Referencing Schema], [Referencing Object name]
'

IF OBJECT_ID('tempdb..##Temp') IS NOT NULL
       DROP TABLE ##Temp

CREATE TABLE ##Temp 
(
       [Referencing Database]           NVARCHAR(200)
,      [Referencing Schema]				NVARCHAR(200)
,      [Referencing Object name]		NVARCHAR(200)
,      [Referencing Object Type]		NVARCHAR(200)
,      [Referenced Database]            NVARCHAR(200)
,      [Referenced Schema]              NVARCHAR(200)
,      [Referenced Object name]			NVARCHAR(200)
,      [Referenced Object Type]			NVARCHAR(200)
,      [ReferencedStillExits]           NVARCHAR(200)
);

SET @sql	=	REPLACE(
				REPLACE(	
				REPLACE(	@sql,		'{ReferencedDatabase}',		@ReferencedDatabase)
								,		'{ReferencedSchema}',		@ReferencedSchemaName)
								,		'{ReferencedEntity}',		@ReferencedEntityName)

exec sp_MSforeachdb @sql

/* Switch to local temp table */
SELECT DISTINCT *
INTO #TEMP
FROM ##Temp

DROP TABLE ##TEMP

/* Show results */
SELECT *
FROM #TEMP
```

In this query notice the following line:
```sql linenums="43"
AND (referenced_database_name = ''{ReferencedDatabase}'' OR (referenced_database_name IS NULL AND ''{ReferencedDatabase}'' = ''?''))
```
It might be possible that in a view the database name is not mentioned. Therefore the dependencies view will show `NULL`.
However, we know that when we don't have a database name, it means it will look for it in the current database. So 
that is why there is that check: `(referenced_database_name IS NULL AND ''{ReferencedDatabase}'' = ''?''))`.