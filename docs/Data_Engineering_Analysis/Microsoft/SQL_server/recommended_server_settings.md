# Recommended server settings
When you first install SQL server, it comes with some defaults that might not be optimal. In this page
we are going over some of them and what the recommended setting should be. This is based on experience, but also backed
up with some online resources.

Consulted resources:

* https://www.brentozar.com/archive/2013/09/five-sql-server-settings-to-change/

## Maximum Degree of Parallelism
This setting indicates how many parallel tasks the sql server engine uses during a query execution. By having
this setting too high will cause some queries to occupy all available resources. To prevent this you should limit
this number. 

Brent Ozar recommends to set it to the amount of physical cores available. However, this is not desired when the server
is used by lots of users and processes at the same time. So play around and see what works best.

## Cost Threshold for Parallelism
The default value is set to 5, which is too low. This results in the query engine to split the execution in too
many threads. Performance wise this is not desired. 

Brent Ozar recommends setting this to 50. From experience this works well.

## Number of files for tempdb
by having just 1 file, all processor cores would want access to that file and this would slow things down. As nowadays
compute is not the limiting factor, rather the IO. However, having too many causes also synchronisation slow downs.

Refer to the following page for more info:
http://www.sqlskills.com/blogs/paul/a-sql-server-dba-myth-a-day-1230-tempdb-should-always-have-one-data-file-per-processor-core/

Which has been summarised by a user on [stackexchange](https://dba.stackexchange.com/questions/102651/tempdb-default-number-of-files-in-sql-server-2016) by:
According to Paul Randal the number of tempdb files should be:

* equal to the number of CPU cores for 8 or less cores
* 1/4 to 1/2 of CPU cores for more than 8 cores

## Compression
Enable compression on all tables. By having smaller tables queries will run much faster. The IO is often the 
limiting factor. `PAGE COMPRESSION` would be a good point to start.