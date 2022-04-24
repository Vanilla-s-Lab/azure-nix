# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_virtual_network" "default" {
  name                = "default"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.NixOS.location
  resource_group_name = azurerm_resource_group.NixOS.name
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.NixOS.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

# https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure

resource "azurerm_public_ip" "default" {
  name                = "default"
  location            = azurerm_resource_group.NixOS.location
  resource_group_name = azurerm_resource_group.NixOS.name
  allocation_method   = "Static" # vanilla.scp.link
}

resource "azurerm_network_interface" "default" {
  name                = "default"
  location            = azurerm_resource_group.NixOS.location
  resource_group_name = azurerm_resource_group.NixOS.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }
}

resource "azurerm_linux_virtual_machine" "NixOS" {
  name                = "NixOS"
  resource_group_name = azurerm_resource_group.NixOS.name
  location            = azurerm_resource_group.NixOS.location
  size                = "Standard_B1ls" # Cheapest server (?

  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./ssh-rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.default.id,
  ]

  os_disk {
    name                 = "nixos-system"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "4" # GB, 2x.
  }

  # The final job finished. I'm exhausted.
  source_image_id = azurerm_image.nixos.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment

resource "azurerm_managed_disk" "nixos-data" {
  name                 = "nixos-data"
  location             = azurerm_resource_group.NixOS.location
  resource_group_name  = azurerm_resource_group.NixOS.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4 # GB
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  managed_disk_id    = azurerm_managed_disk.nixos-data.id
  virtual_machine_id = azurerm_linux_virtual_machine.NixOS.id
  lun                = "10"
  caching            = "ReadWrite"
}
