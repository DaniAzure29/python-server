terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
features {}

}

data "azurerm_key_vault" "linuxkeyvault" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.cloudprojectsgrp.name
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "ssh-public-key"
  key_vault_id = data.azurerm_key_vault.linuxkeyvault.id
}

resource "azurerm_resource_group" "cloudprojectsgrp" {
  name     = var.resource_group_name
  location = local.resource_location
}

resource "azurerm_virtual_network" "projects-vnet" {
  name                = "projects-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cloudprojectsgrp.location
  resource_group_name = azurerm_resource_group.cloudprojectsgrp.name
}

resource "azurerm_subnet" "project-subnet" {
  name                 = "linuxvmsubnet"
  resource_group_name  = azurerm_resource_group.cloudprojectsgrp.name
  virtual_network_name = azurerm_virtual_network.projects-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "projects-interfece" {
  name                = "pythonvm-nic"
  location            = azurerm_resource_group.cloudprojectsgrp.location
  resource_group_name = azurerm_resource_group.cloudprojectsgrp.name

  ip_configuration {
    name                          = "project-ip"
    subnet_id                     = azurerm_subnet.project-subnet.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_linux_virtual_machine" "pythonvm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.cloudprojectsgrp.name
  location            = azurerm_resource_group.cloudprojectsgrp.location
  size                = "Standard_B1s"
  admin_username      = "serveradmin"
  network_interface_ids = [
    azurerm_network_interface.projects-interfece.id,
  ]

admin_ssh_key {
    username   = "serveradmin"
    public_key = data.azurerm_key_vault_secret.ssh_public_key.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}