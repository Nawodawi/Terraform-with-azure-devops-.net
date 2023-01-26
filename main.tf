terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cool-rg" {
  name = "cool-resource-group"
  location = "west us"
}

resource "azurerm_container_group" "container-group" {
  name                = "our-continer-group"
  location            = azurerm_resource_group.cool-rg.location
  resource_group_name = azurerm_resource_group.cool-rg.name
  ip_address_type     = "Public"
  dns_name_label      = "nawodaweatherapi"
  os_type             = "Linux"

  container {
    name   = "weatherapi"
    image  = "nawoda/weatherapi:latest"
    cpu    = "0.5"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}