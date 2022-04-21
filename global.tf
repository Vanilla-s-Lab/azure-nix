terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.2.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.20.0"
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