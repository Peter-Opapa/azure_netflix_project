# Netflix Data Pipeline Setup Guide

## Azure Resource Requirements

### 1. Azure Data Lake Storage Gen2
- Storage account with hierarchical namespace enabled
- Containers: `source`, `bronze`, `silver`, `gold`
- Access keys or managed identity configured

### 2. Azure Data Factory
- Data factory instance in the same region as ADLS Gen2
- Managed identity with Storage Blob Data Contributor role on ADLS Gen2
- Linked services configured for ADLS Gen2 and Databricks

### 3. Databricks Workspace
- Premium or Standard tier workspace
- Cluster configuration with appropriate node types
- Unity Catalog enabled (recommended)
- Access connector for Azure Storage

## Step-by-Step Setup

### Phase 1: Infrastructure Setup

1. **Create Resource Group**
   ```bash
   az group create --name netflix-data-rg --location eastus2
   ```

2. **Deploy ADLS Gen2**
   ```bash
   az storage account create \
     --name netflixprojectstorage \
     --resource-group netflix-data-rg \
     --location eastus2 \
     --sku Standard_LRS \
     --kind StorageV2 \
     --hierarchical-namespace true
   ```

3. **Create Containers**
   ```bash
   az storage container create --name source --account-name netflixprojectstorage
   az storage container create --name bronze --account-name netflixprojectstorage
   az storage container create --name silver --account-name netflixprojectstorage
   az storage container create --name gold --account-name netflixprojectstorage
   ```

### Phase 2: Data Factory Setup

1. **Deploy Azure Data Factory**
2. **Create Linked Services**
   - ADLS Gen2 linked service
   - Databricks linked service
3. **Import Pipeline Definitions**
   - Import `adf_pipeline.json`
   - Import dataset definitions from `src/data_factory/`

### Phase 3: Databricks Setup

1. **Create Databricks Workspace**
2. **Configure Cluster**
   - Runtime: 13.3 LTS or later
   - Node type: Standard_D3_v2 (or as per your requirements)
   - Enable auto-termination
3. **Install Required Libraries**
   - No additional libraries required for basic setup
4. **Import Notebooks**
   - Import all notebooks from `src/databricks/`
5. **Configure DLT Pipeline**
   - Use `dlt_pipeline.yml` configuration
   - Update paths and settings as needed

### Phase 4: Security and Access

1. **Configure Managed Identity**
   - Enable system-assigned managed identity for ADF
   - Grant Storage Blob Data Contributor role to ADF identity
2. **Databricks Access**
   - Configure access connector or service principal
   - Grant appropriate permissions on ADLS Gen2

## Configuration

Update the following configurations based on your environment:

- Storage account names in notebooks and scripts
- Container names
- Resource group names
- Databricks workspace URL
- Cluster configurations

## Testing

1. **Test ADF Pipeline**
   - Trigger the pipeline manually
   - Verify data lands in bronze layer
2. **Test DLT Pipeline**
   - Run the autoloader notebook
   - Verify bronze tables are created
3. **Test Silver Transformations**
   - Execute silver layer notebooks
   - Verify cleaned data in silver layer
4. **Test Gold Layer**
   - Run gold layer transformations
   - Verify aggregated data is available

## Troubleshooting

### Common Issues

1. **Access Denied Errors**
   - Check managed identity permissions
   - Verify RBAC assignments
2. **Schema Evolution Issues**
   - Check autoloader schema location
   - Verify checkpoint directories
3. **Cluster Startup Issues**
   - Check cluster configuration
   - Verify library installations

For more detailed troubleshooting, check the Databricks and ADF logs.
