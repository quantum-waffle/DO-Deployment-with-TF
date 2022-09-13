# Provider specification
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# DigitalOcean token and Private SSH key location for droplet login
variable "do_token" {}
variable "pvt_key" {}

## Accessing DO token
provider "digitalocean" {
  token = var.do_token
}

## SSH key name inside DO
data "digitalocean_ssh_key" "CONS-Terraform-01" {
  name = "CONS-Terraform-01"
}
