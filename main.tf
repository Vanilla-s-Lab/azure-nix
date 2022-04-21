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
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azuread_application" "example" {
  display_name = "example"
}

resource "azuread_application_password" "example" {
  application_object_id = azuread_application.example.object_id
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

data "azurerm_subscription" "Student" {}

# https://github.com/hashicorp/terraform-provider-azuread/issues/40
resource "azurerm_role_assignment" "main" {
  scope                = data.azurerm_subscription.Student.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.id
}

resource "azurerm_resource_group" "NixOS" {
  name     = "NixOS"
  location = "Central India"
}

resource "azurerm_storage_account" "NixOS_Images" {
  name                     = "nixosimages"
  resource_group_name      = azurerm_resource_group.NixOS.name
  location                 = azurerm_resource_group.NixOS.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "vhd" {
  name                 = "vhd"
  storage_account_name = azurerm_storage_account.NixOS_Images.name
}

resource "azurerm_storage_blob" "nixos-disk" {
  name                   = "disk.vhd"
  storage_account_name   = azurerm_storage_account.NixOS_Images.name
  storage_container_name = azurerm_storage_container.vhd.name
  type                   = "Block" # Required by `content_md5`.

  # https://github.com/hashicorp/terraform-provider-azurerm/issues/1990
  source      = "./result/disk.vhd"
  content_md5 = filemd5("./result/disk.vhd")
}

# resource "azurerm_image" "nixos-image" {
#   name                = "nixos-image"
#   location            = azurerm_storage_account.NixOS_Images.location
#   resource_group_name = azurerm_resource_group.NixOS.name
#
#   os_disk {
#     os_type  = "Linux"
#     os_state = "Generalized"
#     blob_uri = azurerm_storage_blob.nixos-disk.id
#   }
# }
