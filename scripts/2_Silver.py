# Databricks notebook source
# MAGIC %md
# MAGIC ### **Silver Notebook Lookup Tables**

# COMMAND ----------

# MAGIC %md
# MAGIC **Parameters**

# COMMAND ----------

dbutils.widgets.text("sourcefolder","")
dbutils.widgets.text("targetfolder","")

# COMMAND ----------

# MAGIC %md
# MAGIC **Variables**

# COMMAND ----------

var_src_folder = dbutils.widgets.get("sourcefolder")
var_trg_folder = dbutils.widgets.get("targetfolder")

# COMMAND ----------

df = spark.read.format("csv")\
        .option("header",True)\
        .option("inferSchema",True)\
        .load(f"abfss://bronze@netflixprojectstorage1.dfs.core.windows.net/{var_src_folder}")

# COMMAND ----------

df.write.format("delta")\
        .mode("append")\
        .option("path",f"abfss://silver@netflixprojectstorage1.dfs.core.windows.net/{var_trg_folder}")\
        .save()