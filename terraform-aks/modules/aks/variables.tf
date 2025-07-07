variable "aks_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "node_count" {}
variable "vm_size" {}
variable "subnet_id" {}
variable "dns_prefix" {}
variable "default_node_pool_name" {}
variable "vnet_cidr" {
  description = "Plage CIDR du VNet"
  type        = string
}

variable "aks_subnet_cidr" {
  description = "Plage CIDR du sous-réseau AKS"
  type        = string
}
variable "network_plugin" {
  description = "Type de plugin réseau utilisé pour AKS"
  type        = string
}

variable "service_cidr" {
  description = "Plage d'adresses CIDR utilisée pour les services Kubernetes"
  type        = string
  
}

variable "dns_service_ip" {
  description = "Adresse IP du service DNS Kubernetes"
  type        = string
  
}

