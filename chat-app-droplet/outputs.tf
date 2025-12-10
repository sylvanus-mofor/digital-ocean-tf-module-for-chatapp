// chat-app-droplet/outputs.tf - Production Grade

output "droplet_ipv4_address" {
  description = "The public IPv4 address of the deployed Droplet."
  value       = digitalocean_droplet.main.ipv4_address
}

output "droplet_ipv6_address" {
  description = "The public IPv6 address of the deployed Droplet."
  value       = digitalocean_droplet.main.ipv6_address
}

output "droplet_id" {
  description = "The unique ID of the deployed Droplet."
  value       = digitalocean_droplet.main.id
}

output "droplet_urn" {
  description = "The URN of the Droplet for use with DigitalOcean API."
  value       = digitalocean_droplet.main.urn
}

output "droplet_name" {
  description = "The name of the deployed Droplet."
  value       = digitalocean_droplet.main.name
}

output "droplet_region" {
  description = "The region where the Droplet is deployed."
  value       = digitalocean_droplet.main.region
}

output "ssh_connection" {
  description = "SSH connection string for the droplet."
  value       = "ssh root@${digitalocean_droplet.main.ipv4_address}"
}