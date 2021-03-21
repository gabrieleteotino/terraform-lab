terraform {
  backend "local" {
    
  }
}

provider "azurerm" {
  features {  }
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type = string
  description = "The subscription id to use for the bootstapping process."
  validation {
    condition = can(regex("^([0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{12})$", var.subscription_id))
    error_message = "The value must be a valid subscription id."
  }
}

variable "location" {
  type = string
  default = "UK South"
}

resource "azurerm_resource_group" "rg_state" {
  name = "rg-mot-reminder-state"
  location = var.location
}

resource "azurerm_storage_account" "st_state" {
  name = "stmotreminderstate"
  location = var.location
  resource_group_name = azurerm_resource_group.rg_state.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "stc_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.st_state.name
  container_access_type = "private"
}