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
#Criando interface de rede da Máquina Virtual
resource "azurerm_network_interface" "dev" {
  name                = "${var.vm}dev-nic"
  location            = var.locat
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.vm}dev-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Criando a máquina virtual
resource "azurerm_virtual_machine" "dev" {
  name                  = "${var.vm}-02"
  location              = var.locat
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.dev.id]
  vm_size               = "Standard_DS1_v2"



  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm}02-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.vm}-dev"
    admin_username = "admfilipe"
    admin_password = "P$WTAsfgssword1234!"
    #OBS: Estudar melhores práticas de segurança para não inserir a senha no projeto
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

#Criando interface de rede da Máquina Virtual AD
resource "azurerm_network_interface" "ad" {
  name                = "${var.vm}03-nic"
  location            = var.locat
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.vm}03-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "ad" {
  name                = "${var.vm}-03"
  resource_group_name = var.rg
  location            = var.locat
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.ad.id]

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

#Criando interface de rede da Máquina Virtual AD2
resource "azurerm_network_interface" "ad2" {
  name                = "${var.vm}04-nic"
  location            = var.locat
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.vm}04-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "ad2" {
  name                = "${var.vm}-04"
  resource_group_name = var.rg
  location            = var.locat
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.ad2.id]

  os_disk {
    name              = "${var.vm}04-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

#resource "azurerm_resource_group" "example" {
#  name     = "example-resources"
#  location = var.locat
#}

/*resource "azurerm_databricks_workspace" "databrickfilipeiac" {
  name                = var.databricks
  resource_group_name = var.rg
  location            = var.locat
  sku                 = "standard"

  tags = {
  "env" = "staging"
  "project": "filipe-barbosa"
}
}*/

#resource "azurerm_resource_group" "banco" {
#  name     = var.rg
#  location = var.locat
#}


/*resource "azurerm_postgresql_server" "banco" {
  name                = var.database
  location            = var.locat
  resource_group_name = var.rg

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_configuration" "banco" {
  name                = "backslash_quote"
  resource_group_name = var.rg
  server_name         = azurerm_postgresql_server.banco.name
  value               = "on"
}*/