// chat-app-droplet/main.tf

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

// --- Resource: DigitalOcean Droplet ---
resource "digitalocean_droplet" "main" {
  name   = var.droplet_name
  size   = var.droplet_size
  image  = var.image
  region = var.region
  ssh_keys = var.ssh_keys
  # count = 2 You can uncomment this line to create multiple droplets, some config is needed to achieve this
  
  // Production best practices
  monitoring           = true
  ipv6                 = true
  backups              = var.enable_backups
  graceful_shutdown    = true
  
  tags = concat(
    var.tags,
    [
      "terraform-managed",
      "environment:${var.environment}",
      "application:chat-app"
    ]
  )
  
  // User data for initial setup (if provided)
  user_data = var.user_data != "" ? var.user_data : null

  lifecycle {
    create_before_destroy = false
    prevent_destroy       = false
  }
}