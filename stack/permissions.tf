# Role IDS take from there https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

data "azurerm_role_definition" "key_vault_owner" {
  # Key Vault Administrator
  role_definition_id = "00482a5a-887f-4fb3-b363-3b7fe8e74483"
}

data "azurerm_role_definition" "cluster_admin" {
  # Azure Kubernetes Service RBAC Cluster Admin
  role_definition_id = "b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b"
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
