terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}

  client_id       = var.cyclecloud_application_id
  client_secret   = var.cyclecloud_application_secret
  tenant_id       = var.cyclecloud_tenant_id
  subscription_id = var.sub_id
}
