//Root Module

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

// Provider configuration
provider "digitalocean" {
  token = var.do_token
}

// Get current machine's public IP
data "http" "current_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  current_ip = chomp(data.http.current_ip.response_body)
  # Additional IPs that need access (add them in terraform.tfvars file in project root)
  additional_ips = var.additional_allowed_ips
  # Combine current IP with any additional IPs
  ssh_allowed_ips = concat(
    ["${local.current_ip}/32"],
    [for ip in local.additional_ips : "${ip}/32"]
  )
  restricted_port_ips = concat(
    ["${local.current_ip}/32"],
    [for ip in local.additional_ips : "${ip}/32"]
  )
}

// Firewall resource
resource "digitalocean_firewall" "chat_app_firewall" {
  name = "chat-app-firewall"
  
  droplet_ids = [module.chat-app-droplet.droplet_id]
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = local.ssh_allowed_ips
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }
  
  # inbound_rule {
  #   protocol         = "tcp"
  #   port_range       = "8081"
  #   source_addresses = local.restricted_port_ips
  # }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "7071"
    source_addresses = ["0.0.0.0/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

// Module call
module "chat-app-droplet" {
  source = "./chat-app-droplet"
  droplet_name  = "chat-app-droplet-prod"
  region        = "tor1"
  droplet_size = "s-2vcpu-4gb"
  # use "s-4vcpu-8gb" or another bigger size when required
  ssh_keys = var.ssh_key_fingerprints
  
  // settings
  enable_backups = true
  environment    = "prod"
  
  // Tags
  tags = [
    "project:chat-app",
    "managed-by:sylva",
    "team:devops",
    "firewall:chat-app"
  ]
}