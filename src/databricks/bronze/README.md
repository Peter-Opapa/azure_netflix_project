# Bronze Layer - Data Ingestion

This notebook implements the bronze layer of our data lakehouse architecture using Databricks Autoloader for streaming ingestion of raw Netflix data.

## Overview

The bronze layer serves as the landing zone for raw data from Azure Data Lake Storage Gen2. It uses:
- **Autoloader**: For efficient streaming ingestion with schema inference
- **Delta Lake**: For ACID transactions and data versioning
- **DLT (Delta Live Tables)**: For declarative data pipeline management

## Architecture

```
ADLS Gen2 (source) → Autoloader → Delta Bronze Tables → Silver Layer
```

## Features

- **Schema Evolution**: Automatic handling of schema changes
- **Incremental Processing**: Only processes new/changed files
- **Error Handling**: Built-in error recovery and monitoring
- **Checkpointing**: Maintains processing state for recovery

## Configuration

Update the following paths based on your environment:
- Source data location in ADLS Gen2
- Checkpoint location for Autoloader
- Target delta table location
