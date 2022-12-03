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

resource "azurerm_resource_group" "default" {
name = "rg-filipe-iac"  
location = "eastus"
tags = {
  "env" = "staging"
  "project": "filipe-barbosa"
}
}
