terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "RG-SA" {
  name     = "example-resourcess"
  location = "West Europe"
}

resource "azurerm_storage_account" "SA" {
  name                     = "nikhilkumar"
  resource_group_name      = azurerm_resource_group.RG-SA.name
  location                 = azurerm_resource_group.RG-SA.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "CON" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.SA.name
  container_access_type = "private"
}