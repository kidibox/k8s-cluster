resource "azuread_application" "k8s_cluster" {
  name = "${var.cluster_name}-name"
}

resource "azuread_service_principal" "k8s_cluster" {
  application_id = azuread_application.k8s_cluster.application_id
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
