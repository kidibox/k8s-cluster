terraform {
  required_version = ">= 0.12"

  backend "remote" {
    organization = "kid"

    workspaces {
      name = "terraform-k8s-azure"
    }
  }
}

provider "azurerm" {
  version = ">=1.28.0"
}
