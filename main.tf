resource "azurerm_resource_group" "NixOS" {
  name     = "NixOS"
  location = "East Asia"
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
  # TODO: Use `formatdate("YYYY-MM-DD", timestamp())` in future.
  name                   = format("%s_%s", timestamp(), "disk.vhd")
  storage_account_name   = azurerm_storage_account.NixOS_Images.name
  storage_container_name = azurerm_storage_container.vhd.name
  type                   = "Page" # Required by `azurerm_image`.
  source                 = "./result/disk.vhd"
}

resource "azurerm_image" "nixos-image" {
  name                = "nixos-image"
  location            = azurerm_storage_account.NixOS_Images.location
  resource_group_name = azurerm_resource_group.NixOS.name

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = azurerm_storage_blob.nixos-disk.id
  }
}
