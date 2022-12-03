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
# Create Resource group
resource "azurerm_resource_group" "default" {
name = "rg-filipe-iac"  
location = var.locat
tags = {
  "env" = "staging"
  "project": "filipe-barbosa"
}
}

# Create Virtual network
resource "azurerm_virtual_network" "default" {
  name = "vnet-filipe-iac"
  address_space = ["10.0.0.0/16"]
  location = var.locat
  resource_group_name = var.rg
 tags = { 
  "env" = "staging"
  "project": "filipe-barbosa"
}

}

resource "azurerm_subnet" "internal" {
  name = "internal"
  resource_group_name = var.rg
  virtual_network_name = var.vnet
  address_prefixes = ["10.0.1.0/24"]
  

}

resource "azurerm_subnet" "subnet2" {
  name = "subnet2"
  resource_group_name = var.rg
  virtual_network_name = var.vnet
  address_prefixes = ["10.0.2.0/24"]
  

}

resource "azurerm_subnet" "subnet3" {
  name = "subnet3"
  resource_group_name = var.rg
  virtual_network_name = var.vnet
  address_prefixes = ["10.0.3.0/24"]
  

}

resource "azurerm_subnet" "subnet4" {
  name = "subnet4"
  resource_group_name = var.rg
  virtual_network_name = var.vnet
  address_prefixes = ["10.0.4.0/24"]
  

}
resource "azurerm_subnet" "subnet5" {
  name = "subnet5"
  resource_group_name = var.rg
  virtual_network_name = var.vnet
  address_prefixes = ["10.0.5.0/24"]
  
}

#Criando interface de rede da Máquina Virtual
resource "azurerm_network_interface" "default" {
  name                = "${var.vm}-nic"
  location            = var.locat
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.vm}-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Criando a máquina virtual
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vm}-01"
  location              = var.locat
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.default.id]
  vm_size               = "Standard_DS1_v2"



  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.vm}"
    admin_username = "admfilipe"
    admin_password = "P$WTAsfgssword1234!"
    #OBS: Estudar melhores práticas de segurança para não inserir a senha no projeto
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

