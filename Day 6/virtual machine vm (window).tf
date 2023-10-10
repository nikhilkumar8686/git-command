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
  name     = "${var.prefixes}-resourcesn8"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vir-netn8" {
  name                = "${var.prefixes}-networkn8"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.az-rg-n8.location
  resource_group_name = azurerm_resource_group.az-rg-n8.name
}

resource "azurerm_subnet" "snetn8" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.az-rg-n8.name
  virtual_network_name = azurerm_virtual_network.vir-netn8.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "azpublic-ipn8" {
  name                = "${var.prefixes}-publicipn8"
  resource_group_name = azurerm_resource_group.az-rg-n8.name
  location            = azurerm_resource_group.az-rg-n8.location
  allocation_method   = "Static"
  }
  
resource "azurerm_network_interface" "n-interfacen8" {
  name                = "${var.prefixes}-nicn8"
  location            = azurerm_resource_group.az-rg-n8.location
  resource_group_name = azurerm_resource_group.az-rg-n8.name

  ip_configuration {
    name                          = "internaln8"
    subnet_id                     = azurerm_subnet.snetn8.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id          =azurerm_public_ip.azpublic-ipn8.id
  }
}

resource "azurerm_windows_virtual_machine" "nikhilkumar8686" {
  name                = "nikhilkumar8686"
  resource_group_name = azurerm_resource_group.az-rg-n8.name
  location            = azurerm_resource_group.az-rg-n8.location
  size                = "Standard_F2"
  admin_username      = "nikhilkumar8686"
  admin_password      = "*Nikhil1"
  network_interface_ids = [
    azurerm_network_interface.n-interfacen8.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
output "public_ip"{
value =azurerm_public_ip.azpublic-ipn8.ip_address
#above value code you able understand how i take reference upto azpulic-ipn8 but after that .ip_address you won't understand. please run terraform apply without declaring .ip_address in value code
}
output "private_ip"{
value =azurerm_network_interface.n-interfacen8.ip_configuration[0].private_ip_address
#ip_configuration[0] , braces used b.coz ip_configuration is list and wanted to print only first ip
# use loop to print multiple values

}
 #public_ip_address_id          =azurerm_public_ip.azpublic-ipn8.id
 #STEPS
 #To CONNECT TO VM GO TO start> seacrh rdp> enter credentials
 
 #USERNAME AND PASSWORD AVAIABLE IN CODE LOOK ABOVE CODE