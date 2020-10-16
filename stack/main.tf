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

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_size
  }

  identity {
    type = "SystemAssigned"
  }

  # service_principal {
  #   client_id     = azuread_application.aks_app.application_id
  #   client_secret = azuread_service_principal_password.aks_sp_password.value
  # }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed = true
    }
  }
}
