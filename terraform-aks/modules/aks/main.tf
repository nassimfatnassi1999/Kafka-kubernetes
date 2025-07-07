resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name            = var.default_node_pool_name
    node_count      = var.node_count
    vm_size         = var.vm_size
    os_disk_size_gb = 30
    vnet_subnet_id  = var.subnet_id
  }

  network_profile {
   network_plugin     = var.network_plugin
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
  }
  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Terraform AKS"
  }
}
