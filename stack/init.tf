terraform {
  required_version = ">= 0.12"

  backend "remote" {
    organization = "kidibox"

    workspaces {
      name = "terraform-k8s-azure"
    }
  }
}

provider "random" {}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azuread" {
  version = ">=0.7.0"
}

provider "kubernetes-alpha" {
  host                   = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.cluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.cluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
