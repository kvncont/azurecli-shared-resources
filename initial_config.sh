#!/bin/bash

# Resources
# RESOURCE_GROUP_NAME=$1
# STORAGE_ACCOUNT_NAME=$2
# CONTAINER_NAME=$3
# REGION=eastus2

# Create resource group for terraform state
echo "Validating if resource group exists..."
FLAG_RG=$(az group exists -n $RESOURCE_GROUP_NAME)

if [ "$FLAG_RG" = false ]
then
    echo "Creating resource group $RESOURCE_GROUP_NAME..."
    az group create --name $RESOURCE_GROUP_NAME --location $REGION
else
    echo "Resource group $RESOURCE_GROUP_NAME already exist"
fi

# Create storage account for terrraform state
echo "Validating if storage account group exists..."
FLAG_SA=$(az storage account check-name -n $STORAGE_ACCOUNT_NAME --query nameAvailable)

if [ "$FLAG_SA" = true ]
then
    echo "Creating storage account for terraform state $STORAGE_ACCOUNT_NAME..."
    az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME -l $REGION --sku Standard_LRS --encryption-services blob

    echo "Creating storage container $CONTAINER_NAME..."
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --fail-on-exist
else
    echo "Storage account $STORAGE_ACCOUNT_NAME already exist"
fi

echo "Storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "Container_name: $CONTAINER_NAME"
echo "Access_key: Get the access key in the azure console to copy the access key"

# Get storage account key
# ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
# echo "access_key: $ACCOUNT_KEY"
