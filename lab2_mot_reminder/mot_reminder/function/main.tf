# Uncomment this block to enable testing this module in isolation 
# provider "azurerm" {
#   features {}
# }

resource "random_string" "postfix" {
  length  = 6
  lower   = true
  upper   = false
  number  = true
  special = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "stfuncmot${random_string.postfix.id}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "service_plan" {
  name                = "asp-mot-${random_string.postfix.id}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

resource "azurerm_function_app" "function" {
  name                       = "fn-mot-${random_string.postfix.id}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.service_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  https_only = true
  app_settings = {
    #"WEBSITE_RUN_FROM_PACKAGE" = "1", 
    "FUNCTIONS_WORKER_RUNTIME"       = "dotnet",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.appinsights_key
  }
  site_config {
    always_on = true
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "subnet_connection" {
  app_service_id = azurerm_function_app.function.id
  subnet_id      = var.subnet_id
}