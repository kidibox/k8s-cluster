terraform {
  required_version = ">= 0.12"

  backend "remote" {
    organization = "kidibox"

    workspaces {
      name = "terraform-k8s-azure"
    }
  }
}

provider "azurerm" {
  # version = "=2.13.0"
  # version = ">=2.31.1"
  features {}
}

provider "azuread" {
  version = ">=0.7.0"
}
