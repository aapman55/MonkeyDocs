# Query users in groups
It is recommended to have the authorisation on AD-group level, rather than on user level. However, this means that
the `Logins` on your SQL server will only have the AD-groups. In case you want to know who is in those groups,
you can make use of the extended procedure 
[xp_logininfo]( https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/xp-logininfo-transact-sql).

By calling the procedure without any arguments, you will get a list of all logins and also what type of 
login it is. For example:

* group
* user


``` SQL linenums="1"
EXEC xp_logininfo
```

Once you have found the group you want to have more details about the members, you can run the 
following query.

``` SQL linenums="1"
EXEC xp_logininfo '<your-chosen-group>', 'members'
```

## Expand all groups
In case you want to expand all groups and do not want to go over each group manually, you can
use the following query:

``` SQL linenums="1"
IF OBJECT_ID('tempdb..#AllRoleMappings') IS NOT NULL
	DROP TABLE #AllRoleMappings

DECLARE @AllLogins TABLE
(
	AccountName			varchar(200)
,	type				varchar(10)
,	privilege			varchar(10)
,	mappedLoginName		varchar(100)
,	permissionPath		varchar(1000)
)

CREATE TABLE #AllRoleMappings 
(
	AccountName			varchar(200)
,	type				varchar(10)
,	privilege			varchar(10)
,	mappedLoginName		varchar(100)
,	permissionPath		varchar(1000)
)

INSERT INTO @AllLogins
EXEC xp_logininfo

DECLARE @CurrentGroup varchar(200);

DECLARE CUR_Groups CURSOR  
    FOR SELECT AccountName FROM @AllLogins WHERE Type IN ('group')

OPEN CUR_Groups
FETCH NEXT FROM CUR_Groups   
INTO @CurrentGroup

WHILE @@FETCH_STATUS = 0  
BEGIN  
      INSERT INTO #AllRoleMappings
	  EXEC xp_logininfo @CurrentGroup, 'members'

      FETCH NEXT FROM CUR_Groups INTO @CurrentGroup 
END 

CLOSE CUR_Groups  
DEALLOCATE CUR_Groups 

SELECT *
FROM #AllRoleMappings
```