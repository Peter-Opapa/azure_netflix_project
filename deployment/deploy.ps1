# Netflix Data Pipeline Deployment (PowerShell)
# This script deploys the infrastructure and configures the data pipeline

param(
    [string]$ResourceGroup = "netflix-data-rg",
    [string]$Location = "eastus2",
    [string]$StorageAccount = "netflixprojectstorage",
    [string]$DataFactoryName = "netflix-data-factory"
)

Write-Host "Starting Netflix Data Pipeline Deployment..." -ForegroundColor Green

# Check if Azure CLI is installed
if (!(Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "Azure CLI is not installed. Please install it first." -ForegroundColor Red
    exit 1
}

# Check Azure login status
try {
    az account show | Out-Null
    Write-Host "Already logged in to Azure" -ForegroundColor Yellow
} catch {
    Write-Host "Logging in to Azure..." -ForegroundColor Yellow
    az login
}

# Create Resource Group
Write-Host "Creating resource group: $ResourceGroup" -ForegroundColor Yellow
az group create --name $ResourceGroup --location $Location

# Deploy Azure Data Lake Storage Gen2
Write-Host "Creating ADLS Gen2 storage account: $StorageAccount" -ForegroundColor Yellow
az storage account create `
    --name $StorageAccount `
    --resource-group $ResourceGroup `
    --location $Location `
    --sku Standard_LRS `
    --kind StorageV2 `
    --hierarchical-namespace true

# Create containers
Write-Host "Creating storage containers..." -ForegroundColor Yellow
$StorageKey = (az storage account keys list --resource-group $ResourceGroup --account-name $StorageAccount --query '[0].value' -o tsv)

$containers = @("source", "bronze", "silver", "gold")
foreach ($container in $containers) {
    az storage container create `
        --name $container `
        --account-name $StorageAccount `
        --account-key $StorageKey
}

# Deploy Azure Data Factory
Write-Host "Creating Azure Data Factory: $DataFactoryName" -ForegroundColor Yellow
az datafactory create `
    --resource-group $ResourceGroup `
    --factory-name $DataFactoryName `
    --location $Location

# Enable managed identity for ADF and grant permissions
Write-Host "Configuring managed identity and permissions..." -ForegroundColor Yellow
$ADFPrincipalId = (az datafactory show `
    --resource-group $ResourceGroup `
    --factory-name $DataFactoryName `
    --query identity.principalId -o tsv)

$StorageId = (az storage account show `
    --name $StorageAccount `
    --resource-group $ResourceGroup `
    --query id -o tsv)

az role assignment create `
    --assignee $ADFPrincipalId `
    --role "Storage Blob Data Contributor" `
    --scope $StorageId

Write-Host "Infrastructure deployment completed!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Deploy Databricks workspace manually from Azure Portal"
Write-Host "2. Import ADF pipeline definitions from src/data_factory/"
Write-Host "3. Import Databricks notebooks from src/databricks/"
Write-Host "4. Configure DLT pipeline using infrastructure/databricks/dlt_pipeline.yml"
Write-Host "5. Update configuration files in config/ with your specific values"

Write-Host "Deployment script completed successfully!" -ForegroundColor Green
