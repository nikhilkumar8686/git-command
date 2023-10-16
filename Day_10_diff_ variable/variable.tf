variable "rgname"{
#default = "variable_rg"
}
variable "location"{
default = "east us"
}
#block variable{}
#run time variable = 1.terraform plan -var="rgname=runtimerg"  2.give value when it will ask 
#create folder name as terraform.tfvars in rgname="tfvars" location="west us"
#enviroment variable in terminal define syntax ###export TF_VAR_rgname=env_rg