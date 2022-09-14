# We define the Droplet specs
resource "digitalocean_droplet" "ubuntu-PHI-01" {
    image = "${var.droplet_os}"
    name = "${var.droplet_name}"
    region = "${var.droplet_region}"
    size = "${var.droplet_size}"
    tags = ["${digitalocean_tag.purpose_tag.id}", "${digitalocean_tag.analyst_name_tag.id}"]
    ssh_keys = [
      data.digitalocean_ssh_key.terraform_ssh_key.id, 
      data.digitalocean_ssh_key.analyst_ssh_Key.id, 
      data.digitalocean_ssh_key.CONS_ssh_key.id, 
    ]

# Prepare an SSH connection to the droplet
connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

# Run code inside the droplet
provisioner "remote-exec" {
    inline = [
      # install nginx
      "sudo apt update",
      "sudo apt install -y python3-venv git", 
      "git clone https://oauth2:${var.gitlab_token}@${var.gitlab_project}", 
      "python3 -m venv venv", 
      "venv/bin/pip install -r phi-server/requirements.txt"
    ]
  }
}

# Tags to add to the newly created droplet
resource "digitalocean_tag" "purpose_tag" {
    name = "${var.purpose_tag}"
}

resource "digitalocean_tag" "analyst_name_tag" {
    name = "${var.analyst_name_tag}"
}

## Append Droplet to existing Project in DigitalOcean
data "digitalocean_project" "DO_project_name" {
  name        = "${var.DO_project_name}"
}
resource "digitalocean_project_resources" "terraform_rs" {
  project = data.digitalocean_project.DO_project_name.id
  resources = [
     digitalocean_droplet.ubuntu-PHI-01.urn
  ]
}

/* # Attempt to create a project to include the droplet
resource "digitalocean_project" "terraformProject" {
  name        = "Terraform"
  description = "Phishing Droplets created using infrastructure as code."
  purpose     = "Phishing"
  environment = "Production"
  resources   = [digitalocean_droplet.ubuntu-PHI-01.urn]
} */

# DNS record creation in Cloudflare 
data "cloudflare_zone" "this" {
  name = "${var.phishing_domain}"
}
resource "cloudflare_record" "record" {
  zone_id = data.cloudflare_zone.this.id
  name    = "${var.phishing_subdomain}"
  value   = "${digitalocean_droplet.ubuntu-PHI-01.ipv4_address}"
  type    = "${var.DNS_record_type}"
  proxied = "${var.DNS_is_proxied}"
}
