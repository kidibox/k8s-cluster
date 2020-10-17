data "azurerm_role_definition" "key_vault_owner" {
  # Key Vault Administrator
  # https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide
  role_definition_id = "00482a5a-887f-4fb3-b363-3b7fe8e74483"
}

resource "azurerm_role_assignment" "key_vault_owners" {
  count              = length(var.key_vault_owner_ids)
  principal_id       = var.key_vault_owner_ids[count.index]
  role_definition_id = data.azurerm_role_definition.key_vault_owner.id
  scope              = data.azurerm_subscription.current.id
}
