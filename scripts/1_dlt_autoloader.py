# Databricks notebook source
# MAGIC %md
# MAGIC ### **Incremental Data Loading Using Autoloader**

# COMMAND ----------

import dlt
from pyspark.sql.functions import *

# DLT Bronze table - streaming ingestion using Autoloader
@dlt.table(
  name="netflix_titles",
  comment="Streaming ingest of raw Netflix data from ADLS Gen2 using Autoloader",
  table_properties={
    "quality": "bronze",
    "pipelines.autoOptimize.managed": "true"
  }
)
def read_raw_netflix():
    return (
        spark.readStream
            .format("cloudFiles")
            .option("cloudFiles.format", "csv")
            .option("cloudFiles.inferColumnTypes", "true")
            .option("cloudFiles.schemaLocation", "abfss://silver@netflixprojectstorage1.dfs.core.windows.net/checkpoint")
            .option("cloudFiles.schemaEvolutionMode", "addNewColumns")
            .load("abfss://source@netflixprojectstorage1.dfs.core.windows.net/")
    )
