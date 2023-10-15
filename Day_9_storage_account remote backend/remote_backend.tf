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
  name     = "example-resources-remote"
  location = "West Europe"
}

terraform {
  backend "azurerm" {
    storage_account_name = "nikhilkumar"
    container_name       = "vhds"
    key                  = "prod.terraform.tfstate"

    access_key = "1+tB/33bL0AT0OuRT0eYY3YTCfrIMdH8mb62Xyh/plVn5X5d8acKL0LxSHYfCXneCLPuHScKYety+ASt1IcTGQ=="
  }
}