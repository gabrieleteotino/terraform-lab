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