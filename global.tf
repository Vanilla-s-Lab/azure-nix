terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.14.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.26.1"
    }
  }

  cloud {
    organization = "Vanilla-s-Lab"

    # Execution Mode - Local
    workspaces {
      name = "azure-nix"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}
