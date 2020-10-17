data "azurerm_role_definition" "key_vault_owner" {
  # Key Vault Administrator
  # https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide
  role_definition_id = "00482a5a-887f-4fb3-b363-3b7fe8e74483"
}

data "azurerm_role_definition" "cluster_admin" {
  role_definition_id = "0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8"
}

resource "azurerm_role_assignment" "key_vault_owners" {
  count              = length(var.key_vault_owner_object_ids)
  principal_id       = var.key_vault_owner_object_ids[count.index]
  role_definition_id = data.azurerm_role_definition.key_vault_owner.id
  scope              = data.azurerm_subscription.current.id
}

resource "azurerm_role_assignment" "cluster_admins" {
  count              = length(var.cluster_admin_object_ids)
  principal_id       = var.cluster_admin_object_ids[count.index]
  role_definition_id = data.azurerm_role_definition.cluster_admin.id
  scope              = data.azurerm_subscription.current.id
}
