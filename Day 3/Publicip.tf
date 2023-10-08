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

resource "azurerm_resource_group" "public-ip-rg" {
  name     = "public_ip_resources"
  location = "West Europe"
}

resource "azurerm_public_ip" "testpublic-ip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.public-ip-rg.name
  location            = azurerm_resource_group.public-ip-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}