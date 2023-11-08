variable "count1" {
default= 3
}
variable "subnetname" {
type = list
default = ["aasubnet", "absubnet", "acsubnet"]
}
variable "subnetaddress" {
type = list
default = ["9.0.1.0/24", "9.0.2.0/24", "9.0.3.0/24"]
}
