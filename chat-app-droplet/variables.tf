// chat-app-droplet/variables.tf

variable "droplet_name" {
  description = "The name for the Droplet."
  type        = string
  default     = "chat-app-droplet"
  
  validation {
    condition     = length(var.droplet_name) > 0 && length(var.droplet_name) <= 255
    error_message = "Name must be between 1 and 255 characters."
  }
}

variable "region" {
  description = "The region where the Droplet will be created."
  type        = string
  default     = "tor1"
  
  validation {
    condition = contains([
      "nyc1", "nyc3", "sfo3", "tor1", "lon1", "fra1", 
      "ams3", "sgp1", "blr1", "syd1"
    ], var.region)
    error_message = "Region must be a valid DigitalOcean region"
  }
}

variable "droplet_size" {
  description = "The slug identifier for the type of Droplet."
  type        = string
  default     = "s-2vcpu-4gb"
  
  validation {
    condition     = can(regex("^[a-z]-[0-9]+vcpu-[0-9]+gb", var.droplet_size))
    error_message = "Droplet size must be a valid size slug (e.g., s-2vcpu-4gb)."
  }
}

variable "image" {
  description = "The Droplet image/OS to use."
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "ssh_keys" {
  description = "A list of SSH Key IDs or Fingerprints to embed into the Droplet."
  type        = list(string)
  default     = []
  
  validation {
    condition     = length(var.ssh_keys) > 0
    error_message = "At least one SSH key must be provided for production droplets."
  }
}

variable "enable_backups" {
  description = "Enable automated backups for the droplet."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Env name (e.g., prod, stage, dev)."
  type        = string
  default     = "prod"
  
  validation {
    condition     = contains(["prod", "stage", "dev"], var.environment)
    error_message = "env must be prod, stage, or dev."
  }
}

variable "tags" {
  description = "Additional tags to apply to the droplet."
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data script to run when droplet starts."
  type        = string
  default     = <<-EOF
    #!/bin/bash
    set -e  # Exit on any error
    apt-get update
    apt-get install -y docker.io git
    systemctl enable docker
    systemctl start docker
    
    # Install Docker Compose v2
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    
    # Uncomment the following 3 lines to clone and run chat-app upon droplet initialization
    
    git clone https://github.com/sylvanus-mofor/chat-app.git /opt/chat-app
    cd /opt/chat-app
    docker compose up -d --build
  EOF
}