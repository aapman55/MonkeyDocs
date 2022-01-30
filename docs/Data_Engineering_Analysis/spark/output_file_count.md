# Output file count
The normal behaviour is that every executor writes its own files. How many files each executor writes
depends on how many tasks there were to be picked up. Although you could force 1 output file, it will
negatively impact the performance. The data will be shuffled to 1 executor.

There are 3 ways to influence the amount of output files:

1. `spark.default.parallelism`
2. `spark.sql.shuffle.partitions`
3. `repartition()` or `coalesce()`

For more information, see https://www.google.com/amp/s/hadoopsters.com/2019/06/22/how-to-control-file-count-reducers-and-partitions-in-spark-and-spark-sql/amp/.
