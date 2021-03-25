variable "location" {
  type    = string
  default = "UK South"
}

variable "use_vnet" {
  type    = bool
  default = false
}

variable "config" {
  default = {
    "default" = {
      "use_vnet" = false
      "function_sku" = {
        "tier" = "Standard"
        "size" = "S1"
      }
    }
    "prod" = {
      "use_vnet" = true
      "function_sku" = {
        "tier" = "PremiumV2"
        "size" = "P1v2"
      }
    }
  }
}
