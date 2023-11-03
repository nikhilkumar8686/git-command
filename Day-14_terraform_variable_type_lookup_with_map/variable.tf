variable "env" {}
variable "rgname" {
  type    = map
  default = { dev = "DEV-rg_name"
  prod = "PROD-rg_name"
}
}
variable "loc" {
  type    = map
  default = { dev = "east us"
  prod = "west us"
}
}