variable "resource_group_name" {
  description = "Name of the resource group that will contain the function"
  validation {
    condition     = length(var.resource_group_name) > 4
    error_message = "The resource group name must be at least 4 characters."
  }
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "appinsights_key" {
  type = string
}

variable "external_storage_account_connection" {
  type = string
  validation {
    condition = length(var.external_storage_account_connection) > 0
    error_message = "The connection string cannot be empty."
  }
}