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
  features {

  }
}
provider "databricks" {
  host                        = azurerm_databricks_workspace.databrick-cluster-ws.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.databrick-cluster-ws.id

}
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