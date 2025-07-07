resource "azurerm_resource_group" "myterraformgroup" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  nsg_name            = var.nsg_name
  location            = var.location
  vnet_cidr = var.vnet_cidr
  aks_subnet_cidr = var.aks_subnet_cidr
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

module "aks" {
  source              = "./modules/aks"
  aks_name            = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  node_count          = var.node_count
  dns_prefix          = var.dns_prefix
  vnet_cidr = var.vnet_cidr
  aks_subnet_cidr = var.aks_subnet_cidr
  network_plugin = var.network_plugin
  service_cidr = var.service_cidr
  dns_service_ip = var.dns_service_ip
  default_node_pool_name = var.default_node_pool_name
  vm_size             = var.vm_size
  subnet_id           = module.network.aks_subnet_id
}
