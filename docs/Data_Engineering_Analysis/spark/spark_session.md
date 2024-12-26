# Spark session

The spark session is the entry point to programming Spark with the Dataset and DataFrame API.
It is convention to put the spark session in a variable called `spark`.

See the documentation:

https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/spark_session.html

To create the spark session, you can make use of the spark session builder.
Creating the session does not require any arguments, and can be as simple as:

## The Spark Builder

```python linenums="1"
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
```

Although arguments are not necessary, there are some useful settings that can be set.

* `master` 
    * Sets the Spark master URL to connect to, such as “local” to run locally, 
      “local[4]” to run locally with 4 cores, or “spark://master:7077” to run on 
      a Spark standalone cluster.
* `appName`
    * Sets a name for the application, which will be shown in the Spark web UI.
* `config`
    * Sets a config. The input is a list of strings, alternating between key name and value.
      Or you can chain the config multiple times.

When all config is set, you can call `getOrCreate` on the builder to create the spark session.

In the example below we create a spark session on our local machine using 4 cores.
We also allocate 4 gigabytes of memory to the driver. 

```python linenums="1"
from pyspark.sql import SparkSession

# Specify the amount of cores
cores: int = 4

# Specify the amount of memory for the driver
driver_memory = "4g"

# Give the app a name
app_name = "example"

builder = (
    SparkSession.builder.master(f"local[{cores}]")
    .appName(app_name)
    .config("spark.driver.memory", driver_memory)
)

spark = builder.getOrCreate()
```

## Delta tables

To use delta tables with spark, we need to install the package `delta-spark`.
https://delta.io/learn/getting-started/

The easiest way to work with delta, spark and python is to add some config to the 
spark builder. 

* `spark.sql.extensions`: `io.delta.sql.DeltaSparkSessionExtension`
* `spark.sql.catalog.spark_catalog`: `org.apache.spark.sql.delta.catalog.DeltaCatalog`

Then we also need to download and configure the correct delta-core package. This 
depends on which scala version and spark version you are on. Luckily, there is a 
function provided by delta that does this for us (`configure_spark_with_delta_pip`). 
We just need to pass the builder to the function, and it will add those packages 
to the builder.

To not have to type this everytime we need spark, a simple function is created:

```python linenums="1"
from pyspark.sql import SparkSession


def get_or_create_spark_session(
    use_delta: bool = True,
    cores: int = 4,
    app_name: str = "Local",
    driver_memory: str = "4g",
):
    # If a spark session already exists, do not build a new one
    if spark := SparkSession.getActiveSession():
        return spark

    builder = (
        SparkSession.builder.master(f"local[{cores}]")
        .appName(app_name)
        .config("spark.driver.memory", driver_memory)
    )

    if use_delta:
        from delta import configure_spark_with_delta_pip

        builder = configure_spark_with_delta_pip(
            builder.config(
                "spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension"
            ).config(
                "spark.sql.catalog.spark_catalog",
                "org.apache.spark.sql.delta.catalog.DeltaCatalog",
            )
        )

    return builder.getOrCreate()

```


