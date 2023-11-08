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
resource "azurerm_resource_group" "example" {
  name     = "disk-resources"
  location = "West Europe"
}

resource "azurerm_managed_disk" "example" {

  name                 = "acctestmd"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  lifecycle {
#create_before_destroy  = true
prevent_destroy = true
#ignore_changes = [disk_size_gb]
}

  tags = {
    environment = "staging"
  }

}