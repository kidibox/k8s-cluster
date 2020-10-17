resource "azurerm_key_vault" "main" {
  name                            = "kidibox"
  sku_name                        = "standard"
  location                        = azurerm_resource_group.k8s.location
  resource_group_name             = azurerm_resource_group.k8s.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  purge_protection_enabled        = false
  soft_delete_enabled             = true
  soft_delete_retention_days      = 7
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

  depends_on = [
    azurerm_role_assignment.key_vault_owners
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
