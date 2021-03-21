terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "rg_mot" {
  name     = "rg-mot"
  location = var.location
}

resource "azurerm_resource_group" "rg_mot_func" {
  name     = "rg-mot-func"
  location = var.location
}

module "vnet" {
  source              = "./vnet"
  resource_group_name = azurerm_resource_group.rg_mot.name
  location            = var.location
}

module "storageservices" {
  source              = "./storageservices"
  resource_group_name = azurerm_resource_group.rg_mot.name
  location            = var.location
  subnet_ids          = [module.vnet.subnet_storageservices_id]
}

module "function" {
  source              = "./function"
  resource_group_name = azurerm_resource_group.rg_mot_func.name
  location            = var.location
  subnet_id           = module.vnet.subnet_functions_id
}
