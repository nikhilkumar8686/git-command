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
resource "azurerm_resource_group" "az-rg-n8" {
  name     = "rg-resourcesn8"
  location = "West Europe"
}
terraform {
  backend "local" {
    path = "C:/New_folder/terraform.tfstate"
  }
}