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


resource "azurerm_resource_group" "RG_Work_space" {
  name     = "${var.prefixe}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "nic" {
  name                = "WS-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG_Work_space.location
  resource_group_name = azurerm_resource_group.RG_Work_space.name
}

resource "azurerm_subnet" "Work_space_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.RG_Work_space.name
  virtual_network_name = azurerm_virtual_network.nic.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
