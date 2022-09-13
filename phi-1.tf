# We define the Droplet specs
resource "digitalocean_droplet" "ubuntu-PHI-01" {
    image = "ubuntu-22-04-x64"
    name = "ubuntu-PHI-01"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    tags = ["${digitalocean_tag.phishing.id}", "${digitalocean_tag.AlvaroSanchez.id}"]
    ssh_keys = [
      data.digitalocean_ssh_key.CONS-Terraform-01.id
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
      "sudo apt install -y python3-venv"
    ]
  }
}


resource "digitalocean_tag" "phishing" {
    name = "phishing"
}

resource "digitalocean_tag" "AlvaroSanchez" {
    name = "AlvaroSanchez"
}

# Attempt to create a project to include the droplet
resource "digitalocean_project" "playground" {
  name        = "playground"
  description = "A project to represent development resources."
  purpose     = "Phishing"
  environment = "Production"
  resources   = [digitalocean_droplet.ubuntu-PHI-01.urn]
}