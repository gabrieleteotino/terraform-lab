variable "resource_group_name" {
  description = "Name of the resource group that will contain the storage account"
  validation {
    condition     = length(var.resource_group_name) > 4
    error_message = "The resource group name must be at least 4 characters."
  }
}

variable "location" {
  type = string
}

variable "use_subnet" {
  type = bool
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "allowed_ips" {
  type        = set(string)
  default     = []
  description = "Set of public IPv4 address that can access the public endpoint of the Storage Account. Used only if use_subnet is true."
}
