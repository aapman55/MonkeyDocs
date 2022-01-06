# Generate Queries using templates
Sometimes it is handy to be able to generate queries that adhere to the same format. The most simple example would be
to generate a bunch of queries that does a `SELECT *` from a table. The list of tables can be provided manually or taken
from the information schema. The only thing that needs to be done is to fill in the table names.

What some people tend to do is to use `+` to concatenate the parts of the query to be generated with the 
variable table name, table schema etc. This however, will quickly become an unreadable mess. A better way to do 
this is by making use of query templates. Query templates are just strings (`VARCHAR`) that have placeholders in
them. The only thing you then need to do is replace those when running the query. 

!!! tip "Choice of placeholder format" 
    It is important to choose a distinct placeholder to avoid potential collisions. Recommended is to put curly
    brackets `{}` around the name of the placeholder. In SQL curly brackets are not used.

## Simple example
Here we give an example of how the query looks like with and without the placeholder strategy. The example is
the `SELECT * FROM`.

=== "Placeholder"
    ``` sql linenums="1"
    DECLARE @template VARCHAR(MAX) =  
    ' 
    SELECT TOP 10 * 
    FROM {schema}.{table} 
    ' 
     
    SELECT  
        [Database]  = T.TABLE_CATALOG 
    ,   [Schema]    = T.TABLE_SCHEMA 
    ,   [Table]     = T.TABLE_NAME 
    ,   [Query]     =   REPLACE( 
                        REPLACE( @template, '{schema}', T.TABLE_SCHEMA) 
                                            , '{table}', T.TABLE_NAME) 
    FROM INFORMATION_SCHEMA.TABLES AS T 
    ```
=== "Using concatenation"
    ``` sql linenums="1"
    SELECT  
        [Database]  = T.TABLE_CATALOG 
    ,   [Schema]    = T.TABLE_SCHEMA 
    ,   [Table]     = T.TABLE_NAME 
    ,   [Query]     = 'SELECT TOP 10 * FROM '+T.TABLE_SCHEMA+'.'+T.TABLE_NAME 
    FROM INFORMATION_SCHEMA.TABLES AS T
    ```
For this simple example, the concatenation method is shorter and maybe just as readable. So let's
look at a more complex example.

## More complex example: Generate CREATE TABLE statement
In general when you want to create a table from an existing table, you could do that by right-clicking 
on the table and choosing `Script Table as -> CREATE To`. However, when you want to get a create table statement 
on the fly and running it afterwards in a stored procedure, you are not able to use that feature.

So this example focuses on the generation of the CREATE TABLE statement. In this example we keep it as simple as
possible by only considering the column names and datatypes. 

=== "Placeholder"
    ``` sql linenums="1"
    DECLARE @template VARCHAR(MAX) = 
    '
    CREATE TABLE [{schema}].[{table}](
    {column_definitions}
    )
    '
    
    DECLARE @column_definition_template VARCHAR(MAX) =
    ',	[{column_name}] [{column_datatype}]
    '
    
    
    SELECT 
        [Database]	=	T.TABLE_CATALOG
    ,	[Schema]	=	T.TABLE_SCHEMA
    ,	[Table]		=	T.TABLE_NAME
    ,	[Query]		=	REPLACE(
                        REPLACE(
                        REPLACE(	@template,	'{schema}', T.TABLE_SCHEMA)
                                            ,	'{table}', T.TABLE_NAME)
                                            ,	'{column_definitions}', CD.Column_definition)
    FROM INFORMATION_SCHEMA.TABLES AS T
        /* 
            This cross apply is to get the aggregated string of all the 
            column definitions.
        */
        CROSS APPLY(
            /* 
                Remove the leading comma from the template 
            */
            SELECT STUFF(A.Column_definition.value('.','NVARCHAR(MAX)'), 1,1,'')
            FROM
            (
                /*
                 This most inner SELECT is to fill in the colmn definition template.
                 The template will be filled in for each column
                 */
                SELECT 
    
                    [Column_definition]		=	REPLACE(
                                                REPLACE(	@column_definition_template, '{column_name}', C.COLUMN_NAME)
                                                                                        ,'{column_datatype}', C.DATA_TYPE)
                FROM INFORMATION_SCHEMA.COLUMNS AS C
                WHERE 1=1
                    AND C.TABLE_CATALOG = T.TABLE_CATALOG
                    AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
                    AND C.TABLE_NAME = T.TABLE_NAME
                ORDER BY C.ORDINAL_POSITION
                FOR XML PATH, TYPE
            ) AS A(Column_definition)
        ) AS CD(Column_definition)
    ORDER BY [Database],[Schema],[Table]
    ```

Although the query as a whole might look complex, by having query templates it allows the reader
of the code to have a better overview where the query is aiming for. You can immediately see that there are 2
simple templates involved:

- One containing the overall structure of the CREATE TABLE
- One containing the building block for a column with datatype
