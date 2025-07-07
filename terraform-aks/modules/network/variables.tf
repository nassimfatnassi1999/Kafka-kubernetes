variable "vnet_name" {}
variable "subnet_name" {}
variable "nsg_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "vnet_cidr" {
  description = "Plage CIDR du VNet"
  type        = string
}

variable "aks_subnet_cidr" {
  description = "Plage CIDR du sous-réseau AKS"
  type        = string
}