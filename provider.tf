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

# Passing DigitalOcean token to provider
provider "digitalocean" {
  token = var.do_token
}

# Passing Cloudflare token to provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# SSH key name inside DigitalOcean for loggin in to the droplet
data "digitalocean_ssh_key" "terraform_ssh_key" {
  name = "${var.terraform_ssh_key}"
}

data "digitalocean_ssh_key" "analyst_ssh_Key" {
  name = "${var.analyst_ssh_key}"
}

data "digitalocean_ssh_key" "CONS_ssh_key" {
  name = "${var.CONS_ssh_key}"
}
