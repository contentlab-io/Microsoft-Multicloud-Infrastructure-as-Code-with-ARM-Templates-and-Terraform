terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
    }
  }
}

variable "do_token" {
  default = "YOUR_ACCESS_TOKEN"
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web-1" {
  image = "ubuntu-18-04-x64"
  name = "web-1"
  region = "nyc3"
  size = "s-1vcpu-1gb"
}

provider "azurerm" {
  features {}
}

variable "adminUsername" {
  type = string
  default = "TestAdmin"
}

variable "adminPasswordOrKey" {
  type = string
  sensitive = true
}

resource "azurerm_resource_group_template_deployment" "web-1" {
  name                = "web-1-deploy"
  resource_group_name = "armTest"
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "adminUsername" = {
      value = var.adminUsername
    }
    "adminPasswordOrKey" = {
      value = var.adminPasswordOrKey
    }
  })
  template_content = file("./main.json", )
}
