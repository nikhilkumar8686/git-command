terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.49.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
module "azurerm_virtual_network" {
  source  = "robertdebock/azurerm_virtual_network/azurerm"
  version = "2.0.0"
  # insert the 3 required variables here
  name = "vnetmodule"
  address_space = ["10.0.0.0/24"]
  resource_group_name = "rg_module"
}
#make sure already resource_group created in portal with exact name which is there in main.tf
# this code exracted from link : https://registry.terraform.io/modules/robertdebock/azurerm_virtual_network/azurerm/latest?tab=inputs
# please visit git hub for this link then you will able to know what are the variables have to define

	