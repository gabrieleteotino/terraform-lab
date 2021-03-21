terraform {
  backend "azurerm" { }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_mot" {
  name = "rg-mot"
  location = var.location
}

resource "azurerm_resource_group" "rg_mot_func" {
  name = "rg-mot-func"
  location = var.location
}

module "vnet" {
  source = "./vnet"
  resource_group_name = azurerm_resource_group.rg_mot.name
  location = var.location
}