terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform_rg"
    storage_account_name = "blobfortf"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

variable "imagebuild" {
  type = string
  description = "Latest Image Build"

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
    image  = "nawoda/weatherapi:${var.imagebuild}"
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