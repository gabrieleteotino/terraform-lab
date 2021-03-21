output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_storageservices_id" {
  value = azurerm_subnet.storageservices.id
}

output "subnet_functions_id" {
  value = azurerm_subnet.functions.id
}