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

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
