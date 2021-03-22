resource "random_string" "postfix" {
  length  = 6
  lower   = true
  upper   = false
  number  = true
  special = false
}

resource "azurerm_application_insights" "app" {
  name                = "appi-mot-${random_string.postfix.id}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}
