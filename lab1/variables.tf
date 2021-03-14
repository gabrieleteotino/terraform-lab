variable "int_port" {
  type    = number
  default = 3000
  validation {
    condition     = var.int_port == 3000
    error_message = "Internal port must be 3000."
  }
}

variable "ext_port" {
  type = list
  validation {
    condition     = ! contains([for x in var.ext_port : x > 0 && x <= 65535], false) && length(var.ext_port) > 0
    error_message = "External port must be in the range 1-65535."
  }
}
