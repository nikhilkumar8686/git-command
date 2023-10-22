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


resource "azurerm_resource_group" "RG_PRO" {
  name     = "${var.prefix}-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG_PRO.location
  resource_group_name = azurerm_resource_group.RG_PRO.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RG_PRO.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "pip-PRO" {
  name                    = "test-pip"
  location                = azurerm_resource_group.RG_PRO.location
  resource_group_name     = azurerm_resource_group.RG_PRO.name
  allocation_method       = "static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.RG_PRO.location
  resource_group_name = azurerm_resource_group.RG_PRO.name
  
  

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id          = azurerm_public_ip.pip-PRO.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.RG_PRO.location
  resource_group_name   = azurerm_resource_group.RG_PRO.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "nikhilkumar8686"
    admin_username = "nikhilkumar8686"
    admin_password = "*Nikhil1"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }

provisioner "file" {
connection {
    host     = azurerm_public_ip.pip-PRO.ip_address
    type     = "ssh"
    user     = "nikhilkumar8686"
    password = "*Nikhil1"
    
  }
  source      = "New_Text_Document"
  destination = "New_Text_Document"
  
}
provisioner "remote-exec" {
connection {
    host     = azurerm_public_ip.pip-PRO.ip_address
    type     = "ssh"
    user     = "nikhilkumar8686"
    password = "*Nikhil1"
    
  }
  inline =[
  "ls -a",
  "chmod 777 New_Text_Document",
  "cat New_Text_Document"]
}
provisioner "local-exec"{
command ="echo ${azurerm_public_ip.pip-PRO.ip_address} >>temp.txt"
}
}
output "public_ip_address_id"{
value =azurerm_public_ip.pip-PRO.ip_address
}
output "private_ip_address_id"{
value =azurerm_network_interface.main.ip_configuration[0].private_ip_address
}
