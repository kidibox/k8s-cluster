variable "sp_name" {
  default = "k8s-cluster"
}

resource "azuread_application" "aks_app" {
  name = var.sp_name
}

resource "azuread_service_principal" "aks_sp" {
  application_id = azuread_application.aks_app.application_id
}

resource "random_string" "aks_sp_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.aks_sp.id
  }
}

resource "azuread_service_principal_password" "aks_sp_password" {
  service_principal_id = azuread_service_principal.aks_sp.id
  value                = "{random_string.aks_sp_password.result}"
  end_date             = timeadd(timestamp(), "8760h")

  # This stops be 'end_date' changing on each run and causing a new password to be set
  # to get the date to change here you would have to manually taint this resource...
  lifecycle {
    ignore_changes = [end_date]
  }
}

data "azurerm_subscription" "sub" {}

resource "azurerm_role_definition" "aks_sp_role_rg" {
  name        = "aks_sp_role"
  scope       = data.azurerm_subscription.sub.id
  description = "This role provides the required permissions needed by Kubernetes to: Manager VMs, Routing rules, Mount azure files and Read container repositories"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/read",
      "Microsoft.Network/loadBalancers/write",
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/routeTables/read",
      "Microsoft.Network/routeTables/routes/read",
      "Microsoft.Network/routeTables/routes/write",
      "Microsoft.Network/routeTables/routes/delete",
      "Microsoft.Storage/storageAccounts/fileServices/fileShare/read",
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/publicIPAddresses/write",
    ]

    not_actions = [
      // Deny access to all VM actions, this includes Start, Stop, Restart, Delete, Redeploy, Login, Extensions etc
      "Microsoft.Compute/virtualMachines/*/action",

      "Microsoft.Compute/virtualMachines/extensions/*",
    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.sub.id,
  ]
}
