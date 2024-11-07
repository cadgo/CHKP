#!/bin/bash
 
## Enable verbose and debug mode
#set -xv
 
# Set the student ID
STUDENT_ID="your_student_id_here"
 
# Use STUDENT_ID to create a unique ACR name
ACR_NAME="myacr${STUDENT_ID}"
 
# Service Principal Name
SERVICE_PRINCIPAL_NAME="${ACR_NAME}-SPN"
 
# Create a resource group
az group create --name myResourceGroup --location westus
 
# Create the ACR (Azure Container Registry)
az acr create --resource-group myResourceGroup --name $ACR_NAME --sku Basic
 
# Create the AKS (Azure Kubernetes Service) cluster and attach it to the ACR
az aks create --resource-group myResourceGroup --name myAKSCluster --enable-managed-identity --node-count 3 --generate-ssh-keys --attach-acr $ACR_NAME
 
# Get the credentials for the AKS cluster
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
 
# Get the ACR registry ID
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --resource-group myResourceGroup --query "id" --output tsv)
 
# Create a service principal and get its password
PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query "password" --output tsv)
 
# Get the username for the service principal
USER_NAME=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)
 
# Create a namespace in Kubernetes
kubectl create namespace checkpoint
 
# Create a secret in Kubernetes with the credentials for the ACR
kubectl create secret docker-registry acr-secret --namespace checkpoint --docker-server=${ACR_NAME}.azurecr.io --docker-username=$USER_NAME --docker-password=$PASSWORD
 
# Import images into the ACR
az acr import --name $ACR_NAME --source docker.io/library/nginx:latest --image nginx:latest --resource-group myResourceGroup --username cadgoroot2 --password dckr_pat_9fxzOPmIS_j0xk25U_XbeBwFZOo
az acr import --name $ACR_NAME --source docker.io/bkimminich/juice-shop:latest --image juice-shop:latest --resource-group myResourceGroup --username ccastilloporras --password dckr_pat_mIqAaIKaEw0-n_xOWl3e_K4elzk
 
# Get the Tenant ID
TENANT_ID=$(az account list | grep tenantId)
 
# Output the required parameters
echo "For Azure Container registry On Boarding use the following parameters:"
echo "    $TENANT_ID"
echo "   ACR Login name : ${ACR_NAME}.azurecr.io"
echo "   ACR Secret Name : acr-secret"
echo "Setup completed successfully."
