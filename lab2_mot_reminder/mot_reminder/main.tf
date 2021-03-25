terraform {
  backend "azurerm" {}
}

locals {
  use_vnet     = var.config[terraform.workspace].use_vnet
  name_postfix = terraform.workspace == "default" ? "dev" : terraform.workspace
  function_sku = var.config[terraform.workspace].function_sku
  subnet_id    = local.use_vnet ? module.vnet[0].subnet_mot_id : ""
}

resource "azurerm_resource_group" "rg_mot" {
  name     = "rg-mot-${local.name_postfix}"
  location = var.location
}

resource "azurerm_resource_group" "rg_mot_func" {
  name     = "rg-mot-func-${local.name_postfix}"
  location = var.location
}

module "appinsights" {
  source              = "./appinsights"
  resource_group_name = azurerm_resource_group.rg_mot.name
  location            = var.location
}

module "vnet" {
  count = local.use_vnet ? 1 : 0

  source              = "./vnet"
  resource_group_name = azurerm_resource_group.rg_mot.name
  location            = var.location
}

module "storageservices" {
  source              = "./storageservices"
  resource_group_name = azurerm_resource_group.rg_mot.name
  location            = var.location
  use_subnet          = local.use_vnet
  subnet_ids          = [local.subnet_id]
}

module "function" {
  source                              = "./function"
  resource_group_name                 = azurerm_resource_group.rg_mot_func.name
  location                            = var.location
  sku                                 = local.function_sku
  use_subnet                          = local.use_vnet
  subnet_id                           = local.subnet_id
  appinsights_key                     = module.appinsights.instrumentation_key
  external_storage_account_connection = module.storageservices.connection_string
}
