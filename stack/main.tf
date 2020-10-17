data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

data "azurerm_client_config" "current" {}

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

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed = true
    }
  }
}

resource "azurerm_key_vault" "main" {
  name                        = "kidibox"
  sku_name                    = "standard"
  location                    = azurerm_resource_group.k8s.location
  resource_group_name         = azurerm_resource_group.k8s.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
    ]
  }
}

resource "azurerm_key_vault_key" "sops" {
  name         = "sops"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "encrypt",
    "decrypt",
  ]
}

output "azure_key_vault_id" {
  value = azurerm_key_vault.main.id
}

output "azure_key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "sops_key_id" {
  value = azurerm_key_vault_key.sops.id
}
