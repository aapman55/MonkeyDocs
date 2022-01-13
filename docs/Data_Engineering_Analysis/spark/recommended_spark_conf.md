# Recommended spark configuration
Spark has an enormous set of configuration that can be changed, see the [documentation](https://spark.apache.org/docs/latest/configuration.html) 
for the list.

## Recommendation by Apache
Please see the link: https://spark.apache.org/docs/latest/cloud-integration.html

### Some highlights
Spark first writes the output files to a temporary "folder". When everything is finished, it renames all the files.
This renaming is having a great hit on performance. A solution to limit the impact is to use the fileoutputcommitter
algorithm version 2.

```yml
spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version: 2
```

Version 1 is safer, but slower. According to the link, the consistency models for AWS and Azure are consistent, as of 2021.
So this should not be an issue.

!!! quote
    As of 2021, the object stores of Amazon (S3), Google Cloud (GCS) and Microsoft 
    (Azure Storage, ADLS Gen1, ADLS Gen2) are all consistent.

## Other recommendations

### Adaptive Query Execution
Adaptive Query Execution (AQE) not only evaluates the execution at the start, but as it gets more insight in the 
data, it will change the query plan accordingly. 

Starting with spark 3.2 AQE is enabled by default. Also, in spark 3.2 the skew-joins are handles much better.

```yml
spark.sql.adaptive.enabled: True
spark.sql.adaptive.coalescePartitions.enabled: True
spark.sql.adaptive.skewJoin.enabled: True
```

Further reading: https://sparkbyexamples.com/spark/spark-adaptive-query-execution/

### Speculation
With speculation enabled the engine tries to predict what it might need to do next when there are executors idling.
This is the same what your CPU is doing all the time. As a consequence, you may see in the Spark UI that tasks
get killed because of speculation. All this means is that the task is already done by another executor.

```yml
spark.speculation: True
```