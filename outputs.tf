// infra/outputs.tf - Root Module Outputs

output "api_server_ip" {
  description = "The public IPv4 address of the API server Droplet."
  value       = module.chat-app-droplet.droplet_ipv4_address
}

output "droplet_id" {
  description = "The unique ID of the deployed Droplet."
  value       = module.chat-app-droplet.droplet_id
}

output "ssh_connection" {
  description = "SSH connection string for the droplet."
  value       = module.chat-app-droplet.ssh_connection
}

output "firewall_id" {
  description = "The ID of the chat-app-firewall."
  value       = digitalocean_firewall.chat_app_firewall.id
}

output "firewall_status" {
  description = "The status of the chat-app-firewall."
  value       = digitalocean_firewall.chat_app_firewall.status
}

output "current_machine_ip" {
  description = "The public IP address of the machine running Terraform."
  value       = local.current_ip
}

output "allowed_ssh_ips" {
  description = "List of IP addresses allowed to access SSH and restricted ports."
  value       = local.ssh_allowed_ips
}