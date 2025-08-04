# Troubleshooting Guide

## Common Issues and Solutions

### 1. Azure Data Factory Issues

#### Pipeline Execution Failures
**Error**: "The pipeline run failed with error: Activity 'CopyGitData' failed"

**Possible Causes:**
- Source URL is unreachable
- Target storage container doesn't exist
- Insufficient permissions

**Solutions:**
```bash
# Check ADF managed identity permissions
az role assignment list --assignee <adf-principal-id> --scope <storage-account-resource-id>

# Verify storage container exists
az storage container exists --name source --account-name <storage-account>

# Test source URL accessibility
curl -I <github-raw-url>
```

#### ForEach Activity Timeout
**Error**: "ForEach activity execution timeout"

**Solution:**
- Increase timeout value in pipeline settings
- Reduce batch size for parallel execution
- Optimize source data accessibility

### 2. Databricks Issues

#### Cluster Startup Failures
**Error**: "Cluster failed to start due to cloud provider limitations"

**Solutions:**
```python
# Check cluster configuration
cluster_config = {
    "cluster_name": "netflix-cluster",
    "spark_version": "13.3.x-scala2.12",
    "node_type_id": "Standard_D3_v2",  # Try different instance type
    "num_workers": 2,
    "auto_termination_minutes": 60
}

# Verify resource availability in region
# Try different Azure regions if needed
```

#### Autoloader Schema Issues
**Error**: "Schema evolution failed: incompatible schema changes"

**Solutions:**
```python
# Enable rescue data column for problematic records
spark.readStream \
    .format("cloudFiles") \
    .option("cloudFiles.format", "csv") \
    .option("cloudFiles.schemaLocation", "<schema-location>") \
    .option("cloudFiles.rescuedDataColumn", "_rescued_data") \
    .load("<source-path>")

# Reset schema location if needed
dbutils.fs.rm("<schema-location>", True)
```

#### Memory and Performance Issues
**Error**: "OutOfMemoryError during DataFrame operations"

**Solutions:**
```python
# Optimize Spark configuration
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
spark.conf.set("spark.sql.adaptive.skewJoin.enabled", "true")

# Increase driver memory
spark.conf.set("spark.driver.memory", "8g")
spark.conf.set("spark.driver.maxResultSize", "4g")

# Partition large DataFrames
df.repartition(200).write.mode("overwrite").save("<path>")
```

### 3. Delta Lake Issues

#### Concurrent Write Conflicts
**Error**: "ConcurrentAppendException: Files were added to the root directory"

**Solutions:**
```python
# Use merge operations instead of append
from delta.tables import DeltaTable

# Merge instead of append to avoid conflicts
target_table = DeltaTable.forPath(spark, "<table-path>")
target_table.alias("target").merge(
    new_data.alias("source"),
    "target.id = source.id"
).whenMatchedUpdateAll().whenNotMatchedInsertAll().execute()
```

#### Table Corruption
**Error**: "CorruptRecordException: malformed records detected"

**Solutions:**
```python
# Enable corrupt record handling
df = spark.read \
    .option("mode", "PERMISSIVE") \
    .option("columnNameOfCorruptRecord", "_corrupt_record") \
    .format("delta") \
    .load("<table-path>")

# Vacuum old files if needed (be careful!)
spark.sql("VACUUM delta.`<table-path>` RETAIN 168 HOURS")
```

### 4. Authentication and Permissions

#### Access Denied to Storage Account
**Error**: "403 Forbidden: Insufficient permissions to access storage"

**Solutions:**
```bash
# Grant Storage Blob Data Contributor role to ADF
az role assignment create \
    --assignee <adf-principal-id> \
    --role "Storage Blob Data Contributor" \
    --scope <storage-account-resource-id>

# For Databricks, configure access connector
# Or use service principal authentication
```

#### Databricks Authentication Issues
**Error**: "Authentication failed: invalid token"

**Solutions:**
```bash
# Regenerate Databricks personal access token
# Configure in Databricks workspace settings

# For service principal authentication
az ad sp create-for-rbac --name "databricks-sp" \
    --role contributor \
    --scopes <resource-group-id>
```

### 5. Network and Connectivity

#### VNet Integration Issues
**Error**: "Network connectivity failed"

**Solutions:**
- Verify VNet peering configuration
- Check Network Security Groups (NSGs)
- Ensure proper subnet configurations
- Verify private endpoint connectivity

### 6. Performance Optimization

#### Slow Query Performance
**Symptoms**: Queries taking longer than expected

**Solutions:**
```python
# Optimize table layout with Z-ordering
spark.sql("OPTIMIZE delta.`<table-path>` ZORDER BY (partition_column)")

# Update table statistics
spark.sql("ANALYZE TABLE <table-name> COMPUTE STATISTICS")

# Use appropriate file sizes
spark.conf.set("spark.sql.files.maxPartitionBytes", "128MB")
```

#### High Costs
**Symptoms**: Unexpected Azure billing

**Solutions:**
- Enable auto-termination for Databricks clusters
- Use spot instances where appropriate
- Implement storage lifecycle policies
- Monitor and alert on resource usage

### 7. Data Quality Issues

#### Missing or Null Data
**Error**: "Unexpected null values in required columns"

**Solutions:**
```python
# Implement data quality checks
from pyspark.sql.functions import col, isnan, when, count

# Check for null values
null_counts = df.select([count(when(col(c).isNull(), c)).alias(c) 
                        for c in df.columns])

# Handle nulls appropriately
df_clean = df.fillna({
    "rating": "Not Rated",
    "duration": "Unknown",
    "director": "Unknown Director"
})
```

## Diagnostic Commands

### Check ADF Pipeline Status
```bash
# Get pipeline run status
az datafactory pipeline-run query-by-factory \
    --resource-group <rg-name> \
    --factory-name <adf-name> \
    --last-updated-after "2024-01-01" \
    --last-updated-before "2024-12-31"
```

### Monitor Databricks Cluster
```python
# Check cluster status
cluster_info = dbutils.clusters.get("<cluster-id>")
print(f"Cluster state: {cluster_info['state']}")

# Check driver logs
dbutils.fs.ls("dbfs:/cluster-logs/<cluster-id>/driver/")
```

### Verify Delta Table Health
```python
# Check table details
spark.sql("DESCRIBE DETAIL delta.`<table-path>`").show()

# Check table history
spark.sql("DESCRIBE HISTORY delta.`<table-path>`").show()
```

## Getting Help

### Microsoft Support Resources
- [Azure Data Factory Documentation](https://docs.microsoft.com/azure/data-factory/)
- [Databricks Documentation](https://docs.databricks.com/)
- [Delta Lake Documentation](https://docs.delta.io/)

### Community Resources
- [Stack Overflow](https://stackoverflow.com/questions/tagged/azure-data-factory)
- [Databricks Community](https://community.databricks.com/)
- [GitHub Issues](https://github.com/your-repo/issues)

### Monitoring and Alerting
- Set up Azure Monitor alerts
- Configure Databricks job notifications
- Implement custom logging and monitoring

Remember to always check logs first and ensure proper permissions are configured before implementing solutions.
