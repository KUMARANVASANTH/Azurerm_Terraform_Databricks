# Azurerm_Terraform_Databricks

This repository contains Terraform code to deploy an Azure Databricks workspace along with a Databricks cluster. The infrastructure is defined using HashiCorp's Terraform and leverages the Azure provider for resource management.

## Prerequisites
Before running the Terraform scripts, ensure you have the following prerequisites:

**Terraform Installation:** Make sure you have Terraform installed on your local machine. You can download it from Terraform's official website.

**Azure Subscription:** You need an active Azure subscription. If you don't have one, you can create a free account with Azure.

**Azure Service Principal:** Create an Azure Service Principal with the necessary permissions. Refer to the Azure provider documentation for more information on creating a Service Principal.

## Terraform Configuration
The **`main.tf`** file contains the main configuration for the Terraform deployment. Here's an overview of the key components:

## Azure Providers

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host                        = azurerm_databricks_workspace.databrick-cluster-ws.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.databrick-cluster-ws.id
}
```
The configuration defines the required Azure and Databricks providers with specific versions.

## Resource Group and Databricks Workspace

```hcl
resource "azurerm_resource_group" "databrick-cluster-rg" {
  name     = "databrick-rg-test"
  location = "East Asia"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_databricks_workspace" "databrick-cluster-ws" {
  name                = "databrick-ws-test"
  location            = azurerm_resource_group.databrick-cluster-rg.location
  resource_group_name = azurerm_resource_group.databrick-cluster-rg.name
  sku                 = "trial"
  tags = {
    environment = "dev"
  }
}
```
These blocks define the Azure resource group and Databricks workspace.

## Databricks Cluster Configuration

```hcl
data "databricks_node_type" "smallest" {
  local_disk  = true
  min_cores   = 2
  gb_per_core = 4
  depends_on  = [azurerm_databricks_workspace.databrick-cluster-ws]
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  depends_on        = [azurerm_databricks_workspace.databrick-cluster-ws]
}

resource "databricks_cluster" "databrick-cluster" {
  cluster_name            = "databrick-cluster-test"
  depends_on              = [azurerm_databricks_workspace.databrick-cluster-ws]
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 120
  autoscale {
    min_workers = 2
    max_workers = 8
  }
  spark_conf = {
    "spark.databricks.io.cache.enabled" : true
  }
  custom_tags = {
    "CreatedBy" = "Vasantharan"
  }
}
```
This section configures the Databricks cluster with specific settings, including node type, Spark version, and autoscaling parameters.

# Running the Deployment

## Initialize Terraform:
```bash
terraform init
```
## Review the Execution Plan:
```bash
terraform plan
```
