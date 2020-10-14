data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azuread_application" "k8s_cluster" {
  name = "${var.cluster_name}-name"
}

resource "azuread_service_principal" "k8s_cluster" {
  application_id = azuread_application.k8s_cluster.application_id
  app_role_assignment_required = true
}

resource "azuread_service_principal_password" "k8s_cluster" {
  service_principal_id = azuread_service_principal.k8s_cluster.id
  value = random_string.password.result
  end_date_relative = "17520h"
}

resource "random_string" "password" {
  length  = 32
  special = true
}

resource "azurerm_role_assignment" "k8s_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = data.azurerm_role_definition.contributor.id
  principal_id         = azuread_service_principal.k8s_cluster.id
}
