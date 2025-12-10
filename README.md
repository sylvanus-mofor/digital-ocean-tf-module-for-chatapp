# Chat App Infrastructure

Simple TF config to deploy provision a firewall, droplet (Digital Ocean Virtual Machine) and attach the firewall to the VM. sylva Chat App can be enable to clone from github and run upon droplet initialization.

## What This Does

- Creates a DigitalOcean droplet (Ubuntu 24.04)
- Install Docker
- Sets up a firewall with your current IP automatically whitelisted
- Enables automated backups
- Configures secure SSH access

## Prerequisites

- A DigitalOcean account with API token
- Have your SSH key added to DigitalOcean
- Install Terraform on your development machine

## Quick Start

### 1. Get Your SSH Key Fingerprint

```bash
doctl compute ssh-key list
```
Or find it in DigitalOcean console: **Settings → Security → SSH Keys**

### 2. Configure

Create a .tfvars file in your project root `terraform.tfvars` with the following contents:
```hcl
ssh_key_fingerprints = ["your:ssh:key:fingerprint"]
do_token = "your_digitalocean_token"
additional_allowed_ips = ["list the ips you would like to whitelist through your firewall"]

```

### 3. Deploy
```bash
terraform init
terraform plan
terraform apply
```

### 4. Connect
```bash
# Get the SSH command
terraform output ssh_connection

# SSH into your droplet
ssh root@<droplet_ip>
```

## Firewall Rules

The firewall automatically allows:

- **Port 22 (SSH)**: Your current IP + any additional IPs you specify
- **Port 80 (HTTP)**: All traffic
- **Port 443 (HTTPS)**: All traffic
- **Port 7071**: All traffic

## Adding More IPs
To allow additional IPs for SSH and restricted ports:
```hcl
# In terraform.tfvars
additional_allowed_ips = ["xx.xx.xx.xx", "yy.yy.yy.yy"]
```

## If Your IP Changes
If your IP changes, just run the `terraform apply` again and the firewall will update with your new IP.

## Other Useful Commands

```bash
# See all outputs
terraform output

# Get just the IP address
terraform output droplet_ipv4

# Check your current IP that's whitelisted
terraform output current_machine_ip

# Destroy everything
terraform destroy
```

## Cost

Approximate monthly cost: **$58-68**
- Droplet (s-4vcpu-8gb): $48/month
- Automated backups: ~$10/month if turned on

To reduce costs, use a smaller droplet size in `main.tf`:
```hcl
droplet_size = "s-2vcpu-4gb"  # $24/month
```

## Customization

All configuration is in the root `main.tf` file:

- **Region**: Change `region = "tor1"` to your preferred region
- **Droplet size**: Change `droplet_size` 
- **Features**: Set `enable_backups = false` to disable backups

## Important Files

- `main.tf` (root): Main configuration
- `variables.tf` (root): Configuration options
- `outputs.tf` (root): Output definitions
- `terraform.tfvars`: Your secrets (never commit this!)
- `chat-app-droplet/`: Reusable droplet module

## Security Notes

- Never commit `terraform.tfvars` to git
- SSH password authentication is disabled
- Firewall rules are applied automatically
- Your current IP is auto-detected each time you run Terraform

## Troubleshooting

**Can't SSH to the droplet?**
```bash
# Check your IP is whitelisted
terraform output current_machine_ip
terraform output allowed_ssh_ips
```

**Need to add a new IP?**

Add it to `additional_allowed_ips` in `terraform.tfvars` and run `terraform apply`.

**Want to see what changed?**
```bash
terraform plan
```
