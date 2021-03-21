resource "random_string" "postfix" {
  length  = 6
  lower   = true
  upper   = false
  number  = true
  special = false
}

resource "azurerm_storage_account" "motstorage" {
  name                     = "stmot${random_string.postfix.id}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "vehicles"
  storage_account_name  = azurerm_storage_account.motstorage.name
  container_access_type = "private"
}

resource "azurerm_storage_queue" "queue" {
  name                 = "mailreminder"
  storage_account_name = azurerm_storage_account.motstorage.name
}

resource "azurerm_storage_table" "table" {
  name                 = "reminders"
  storage_account_name = azurerm_storage_account.motstorage.name
}
