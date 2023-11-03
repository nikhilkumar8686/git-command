variable "rgname" {
  type    = string
  default = "rg_name"
}
variable "loc" {
  type    = list
  default = ["eastus", "westus"]

}
variable "vnet" {
type = map
default = {
dev = "dev_vnet"
pro = "prod_vnet" }
}
