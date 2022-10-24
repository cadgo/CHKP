terraform {
  required_providers{
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0.0"
    } 
  } 
}

provider "azurerm"{
  features{}
}

data "template_file" "spectral_script"{
  template=file("install_spectral_machine.sh")
}

resource "azurerm_resource_group" "lab-rg"{
  location = var.location
  name = "lab-rs"
}

resource "azurerm_virtual_network" "lab_vnet"{
  name = "labvnet"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = azurerm_resource_group.lab-rg.name  
}

resource "azurerm_subnet" "lab_subnet"{
  name="subnet0"
  resource_group_name = azurerm_resource_group.lab-rg.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "lab-pubs-ips"{
  count = var.instances_number
  name = "pubsips${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.lab-rg.name
  allocation_method = "Dynamic"  
}

resource "azurerm_network_security_group" "lab-access"{
  name = "lab-sec-group"
  location = var.location
  resource_group_name = azurerm_resource_group.lab-rg.name

  security_rule{
    name = "ssh"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule{
    name = "rdp"
    priority = 1002
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3389"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface" "vms_nics"{
  count = var.instances_number
  name = "lab-nic-${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.lab-rg.name

  ip_configuration {
    name = "lab_nic_${count.index}"
    subnet_id = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.lab-pubs-ips[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "lab-sec-nic"{
  count = var.instances_number
  network_interface_id = azurerm_network_interface.vms_nics[count.index].id
  network_security_group_id = azurerm_network_security_group.lab-access.id
}

resource "random_string" "str_r"{
  length = 6
  min_lower = 6
}

resource "azurerm_storage_account" "labst"{
  count = var.instances_number
  name = "labst${random_string.str_r.result}${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.lab-rg.name
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "lab_machines"{
  count = var.instances_number
  name = "Spectral-lab-${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.lab-rg.name
  network_interface_ids = [azurerm_network_interface.vms_nics[count.index].id]
  size = "Standard_D2as_v4"

  os_disk{
    name = "lab-disk-${count.index}"
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference{
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts-gen2"
    version = "latest"
  }
  computer_name = "labvm-${count.index}"
  admin_username = "chkp"
  disable_password_authentication = false
  admin_password = var.instance_pass
  custom_data = base64encode(data.template_file.spectral_script.rendered)
  boot_diagnostics {
   storage_account_uri = azurerm_storage_account.labst[count.index].primary_blob_endpoint
  }
}

