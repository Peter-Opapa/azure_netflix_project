#!/bin/bash

# Netflix Data Pipeline Deployment Script
# This script deploys the infrastructure and configures the data pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RESOURCE_GROUP="netflix-data-rg"
LOCATION="eastus2"
STORAGE_ACCOUNT="netflixprojectstorage"
ADF_NAME="netflix-data-factory"
DATABRICKS_WORKSPACE="netflix-databricks"

echo -e "${GREEN}Starting Netflix Data Pipeline Deployment...${NC}"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Login to Azure (if not already logged in)
echo -e "${YELLOW}Checking Azure login status...${NC}"
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}Logging in to Azure...${NC}"
    az login
fi

# Create Resource Group
echo -e "${YELLOW}Creating resource group: $RESOURCE_GROUP${NC}"
az group create --name $RESOURCE_GROUP --location $LOCATION

# Deploy Azure Data Lake Storage Gen2
echo -e "${YELLOW}Creating ADLS Gen2 storage account: $STORAGE_ACCOUNT${NC}"
az storage account create \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_LRS \
    --kind StorageV2 \
    --hierarchical-namespace true

# Create containers
echo -e "${YELLOW}Creating storage containers...${NC}"
STORAGE_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query '[0].value' -o tsv)

for container in source bronze silver gold; do
    az storage container create \
        --name $container \
        --account-name $STORAGE_ACCOUNT \
        --account-key $STORAGE_KEY
done

# Deploy Azure Data Factory
echo -e "${YELLOW}Creating Azure Data Factory: $ADF_NAME${NC}"
az datafactory create \
    --resource-group $RESOURCE_GROUP \
    --factory-name $ADF_NAME \
    --location $LOCATION

# Enable managed identity for ADF
echo -e "${YELLOW}Enabling managed identity for Data Factory...${NC}"
ADF_PRINCIPAL_ID=$(az datafactory show \
    --resource-group $RESOURCE_GROUP \
    --factory-name $ADF_NAME \
    --query identity.principalId -o tsv)

# Grant Storage Blob Data Contributor role to ADF
STORAGE_ID=$(az storage account show \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --query id -o tsv)

az role assignment create \
    --assignee $ADF_PRINCIPAL_ID \
    --role "Storage Blob Data Contributor" \
    --scope $STORAGE_ID

echo -e "${GREEN}Infrastructure deployment completed!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Deploy Databricks workspace manually from Azure Portal"
echo "2. Import ADF pipeline definitions from src/data_factory/"
echo "3. Import Databricks notebooks from src/databricks/"
echo "4. Configure DLT pipeline using infrastructure/databricks/dlt_pipeline.yml"
echo "5. Update configuration files in config/ with your specific values"

echo -e "${GREEN}Deployment script completed successfully!${NC}"
