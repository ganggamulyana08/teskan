#! /usr/bin/sh

# Create random string
guid=$(cat /proc/sys/kernel/random/uuid)
suffix=${guid//[-]/}
suffix=${suffix:0:180}

# Set the necessary variables
RESOURCE_GROUP="r-d100-l${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearning"
REGIONS=(""australiaeast" "australiasoutheast" "brazilsouth" "canadacentral" "canadaeast" "centralindia" "centralus" "eastasia" "eastus" "eastus2" "francecentral" "germanywestcentral" "italynorth" "japaneast" "japanwest" "koreacentral" "northcentralus" "northeurope" "norwayeast" "polandcentral" "qatarcentral" "southafricanorth" "southcentralus" "southeastasia" "southindia" "spaincentral" "swedencentral" "switzerlandnorth" "switzerlandwest" "uaenorth" "uksouth" "ukwest" "westcentralus" "westeurope" "westus" "westus2" "westus3")
RANDOM_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]}]}
WORKSPACE_NAME="ml-d100-l${suffix}"
COMPUTE_INSTANCE="ci${suffix}"

# Register the Azure Machine Learning resource provider in the subscription
echo "Register the Machine Learning resource provider:"
az provider register --namespace $RESOURCE_PROVIDER

# Create the resource group and workspace and set to default
echo "Create a resource group and set as default:"
az group create --name $RESOURCE_GROUP --location $RANDOM_REGION
az configure --defaults group=$RESOURCE_GROUP

echo "Create an Azure Machine Learning workspace:"
az ml workspace create --name $WORKSPACE_NAME 
az configure --defaults workspace=$WORKSPACE_NAME 

# Create compute instance
echo "Creating a compute instance with name: " $COMPUTE_INSTANCE
az ml compute create --name ${COMPUTE_INSTANCE} --size Standard_F16s_v2 --type ComputeInstance 
