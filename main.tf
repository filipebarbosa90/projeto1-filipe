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
location = "eastus"
tags = {
  "env" = "staging"
  "project": "filipe-barbosa"
}
}

# Create Virtual network
resource "azurerm_virtual_network" "ddfault" {
  name = "vnet-filipe-iac"
  address_space = ["10.0.0.0/16"]
  location = "eastus"
  resource_group_name = azurerm_resource_group.default.name

}

resource "azurerm_subnet" "internal" {
  name = "default"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes = ["10.0.1.0/24"]
}
