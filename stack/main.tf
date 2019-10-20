data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = var.cluster_name
  dns_prefix = var.dns_prefix

  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  agent_pool_profile {
    name            = "default"
    count           = var.node_count
    vm_size         = var.node_size
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }
}
