# Azurerm_Terraform_Databricks

This repository contains Terraform code to deploy an Azure Databricks workspace along with a Databricks cluster. The infrastructure is defined using HashiCorp's Terraform and leverages the Azure provider for resource management.

# Prerequisites
Before running the Terraform scripts, ensure you have the following prerequisites:
**Terraform Installation:** Make sure you have Terraform installed on your local machine. You can download it from Terraform's official website.
**Azure Subscription:** You need an active Azure subscription. If you don't have one, you can create a free account with Azure.
**Azure Service Principal:** Create an Azure Service Principal with the necessary permissions. Refer to the Azure provider documentation for more information on creating a Service Principal.

# Terraform Configuration
The **`main.tf`** file contains the main configuration for the Terraform deployment. Here's an overview of the key components:

# Azure Providers
