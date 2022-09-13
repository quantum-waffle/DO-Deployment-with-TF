# Provider specification
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.4"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

  }
}

## Accessing DO token
provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


## SSH key name inside DO
data "digitalocean_ssh_key" "CONS-Terraform-01" {
  name = "CONS-Terraform-01"
}
