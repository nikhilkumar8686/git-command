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
resource "azurerm_resource_group" "vm_rgk" {
  name     = "${var.prefix}-resourcesk"
  location = "West Europe"
}

resource "azurerm_virtual_network" "maink" {
  name                = "${var.prefix}-networkk"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vm_rgk.location
  resource_group_name = azurerm_resource_group.vm_rgk.name
}

resource "azurerm_subnet" "internalk" {
  name                 = "internalk"
  resource_group_name  = azurerm_resource_group.vm_rgk.name
  virtual_network_name = azurerm_virtual_network.maink.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "testpublic-ip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.vm_rgk.name
  location            = azurerm_resource_group.vm_rgk.location
  allocation_method   = "Static"
  
  }
  
resource "azurerm_network_interface" "maink" {
#network interface is nothing but private ip

  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.vm_rgk.location
  resource_group_name = azurerm_resource_group.vm_rgk.name


  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internalk.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id      = azurerm_public_ip.testpublic-ip.id

  }
 

  tags = {
    environment = "Production"
  }
}
resource "azurerm_virtual_machine" "maink" {
  name                  = "${var.prefix}-vmachinee"
  location              = azurerm_resource_group.vm_rgk.location
  resource_group_name   = azurerm_resource_group.vm_rgk.name
  network_interface_ids = [azurerm_network_interface.maink.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

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
  
}
output "public_ip_address_id" {
 value =azurerm_public_ip.testpublic-ip.ip_address
 }
 output "private_ip_address_id" {
 value =azurerm_network_interface.maink.ip_configuration[0].private_ip_address
 #ip_configuration[0] , braces used b.coz ip_configuration is list and wanted to print only first ip
 # use loop to print multiple values
 }
 #public_ip_address_id      = azurerm_public_ip.testpublic-ip.id
 #STEPS
 #To CONNECT TO VM GO TO TERMIANL CMD
 #SSH USERNAME@IP
 #SSH nikhilkumar8686@iP_address
 #USERNAME AND PASSWORD AVAIABLE IN CODE LOOK ABOVE CODE