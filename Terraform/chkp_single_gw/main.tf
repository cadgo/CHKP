provider "azurerm" {
   subscription_id = "a509cd76-49b3-4cf1-9bd6-e4b9a7594335"
   client_id       = "9f505e78-c3e4-432d-b4ab-f83b68440833"
   client_secret   = "mIFQXCLxtVj92n1c/+tHzLBs8FLiytYcdbg/wBEdcVo="
   tenant_id       = "612a5289-89a8-45c2-a40d-f36fadb6d37c"
}

resource "azurerm_resource_group" "main_rg" {
  name = "${var.prefix}-ResourceGroup"
  location = "${var.location}"
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.main_rg.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.main_rg.name}"
    location                    = "${var.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network-${var.vnetlab}"
  address_space       = ["${var.addressVnet}"]
  resource_group_name = "${azurerm_resource_group.main_rg.name}"
  location            = "${azurerm_resource_group.main_rg.location}"
}

resource "azurerm_subnet" "External" {
  name                 = "External"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.main_rg.name}"
  address_prefix       = "${cidrsubnet("${var.addressVnet}", 8, 1)}"
}

resource "azurerm_subnet" "Internal" {
  name                 = "Internal"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.main_rg.name}"
  address_prefix       = "${cidrsubnet("${var.addressVnet}", 8, 2)}"
}

resource "azurerm_subnet" "DMZ" {
  name                 = "DMZ"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.main_rg.name}"
  address_prefix       = "${cidrsubnet("${var.addressVnet}", 8, 3)}"
  route_table_id  = "${azurerm_route_table.DemoUDR.id}"
}

resource "azurerm_public_ip" "gwpublicip" {
    name                         = "CHKPPublicIP"
    location                     = "${azurerm_resource_group.main_rg.location}"
    resource_group_name          = "${azurerm_resource_group.main_rg.name}"
    public_ip_address_allocation = "dynamic"
}



resource "azurerm_network_interface" "gwexternal" {
    name                = "gatewayexternal"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.main_rg.name}"
    enable_ip_forwarding = "true"
  ip_configuration {
        name                          = "gwexternalConfiguration"
        subnet_id                     = "${azurerm_subnet.External.id}"
        private_ip_address_allocation = "Static"
    private_ip_address = "${cidrhost("${azurerm_subnet.External.address_prefix}", 10)}"
        primary = true
    public_ip_address_id = "${azurerm_public_ip.gwpublicip.id}"
    }

}

resource "azurerm_network_interface" "gwinternal" {
    name                = "gatewayinternal"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.main_rg.name}"
    enable_ip_forwarding = "true"
    ip_configuration {
        name                          = "gwinternalConfiguration"
        subnet_id                     = "${azurerm_subnet.Internal.id}"
        private_ip_address_allocation = "Static"
    private_ip_address = "${cidrhost("${azurerm_subnet.Internal.address_prefix}", 10)}"
    }
}

resource "azurerm_route_table" "DemoUDR"{
  name = "DemoUDR"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main_rg.name}"

  route {
    name = "DefaultGW"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${azurerm_subnet.Internal.address_prefix}", 10)}"
  }
}

resource "azurerm_virtual_machine" "chkpgw" {
    name                  = "${var.GWName}"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.main_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.gwexternal.id}","${azurerm_network_interface.gwinternal.id}"]
    primary_network_interface_id = "${azurerm_network_interface.gwexternal.id}"
    vm_size               = "Standard_D2_v2"

    storage_os_disk {
        name              = "R80dot10OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "checkpoint"
        offer     = "check-point-vsec-r80"
        sku       = "sg-byol"
        version   = "latest"
    }

    plan {
        name = "sg-byol"
        publisher = "checkpoint"
        product = "check-point-vsec-r80"
        }
    os_profile {
        computer_name  = "${var.GWName}"
        admin_username = "azureuser"
        admin_password = "${var.admin_password}"
        custom_data =  "#!/bin/bash\nconfig_system -s 'timezone=America/New_York&install_security_gw=true&gateway_daip=false&install_ppak=true&gateway_cluster_member=false&install_security_managment=false&ipstat_v6=off&ftw_sic_key=vpn12345&templateName=<NAME OF THE TEMPLATE>&ntp_primary=ntp.checkpoint.com&ntp_primary_version=4&ntp_secondary=ntp2.checkpoint.com&ntp_secondary_version=4'\nshutdown -r now\n"

    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }
tags {
        x-chkp-template = "test1"
        x-chkp-management = "adasda"
    }  

}

resource "azurerm_network_interface" "PC1Net" {
    name                = "${var.PC1VPN}-Net"
    location            = "${azurerm_resource_group.main_rg.location}"
    resource_group_name = "${azurerm_resource_group.main_rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "${var.PC1VPN}-VPN"
        subnet_id                     = "${azurerm_subnet.DMZ.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "${cidrhost("${azurerm_subnet.DMZ.address_prefix}", 4)}"
    }
}

resource "azurerm_virtual_machine" "pcvpn1" {
    name                  = "${var.PC1VPN}"
    location              = "${azurerm_resource_group.main_rg.location}"
    resource_group_name   = "${azurerm_resource_group.main_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.PC1Net.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntudmz1disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.PC1VPN}"
        admin_username = "${var.PC1USer}"
        admin_password = "${var.admin_password}"
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}