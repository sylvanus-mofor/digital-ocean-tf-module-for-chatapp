// infra/variables.tf - Root Module Variables

variable "ssh_key_fingerprints" {
  description = "SSH key fingerprints to add to the droplet. Get these with: doctl compute ssh-key list"
  type        = list(string)
  
  validation {
    condition     = length(var.ssh_key_fingerprints) > 0
    error_message = "At least one SSH key fingerprint is required."
  }
}

variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "additional_allowed_ips" {
  description = "Additional ips that can connect to the droplet."
  type        = list(string)
}