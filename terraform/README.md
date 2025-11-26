# Terraform Infrastructure

This directory contains Terraform configurations to deploy the browser terminal to AWS.

## What Gets Created

- **EC2 Instance**: Ubuntu 24.04 with Docker, Node.js, and Caddy pre-installed
- **Elastic IP**: Static IP that survives instance restarts
- **Security Group**: Allows SSH (22), HTTP (80), HTTPS (443)
- **Key Pair**: For SSH access
- **Route53 DNS** (optional): A records for your domain

## Prerequisites

1. [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
2. [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
3. An SSH key pair (`~/.ssh/id_rsa.pub` by default)

## Quick Start

```bash
# 1. Navigate to terraform directory
cd terraform

# 2. Copy and edit variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 3. Initialize Terraform
terraform init

# 4. Preview what will be created
terraform plan

# 5. Create the infrastructure
terraform apply

# 6. Note the outputs (IP, SSH command, etc.)
```

## After Terraform Apply

SSH into your new server and deploy the app:

```bash
# SSH in (use the command from terraform output)
ssh ubuntu@<your-ip>

# Clone your repo
cd /app
git clone https://github.com/yourusername/browser-terminal.git
cd browser-terminal

# Build everything
npm ci
npm run build
docker build -t terminal-sandbox ./sandbox

# Start the service
sudo systemctl enable --now browser-terminal
```

## Setting Up HTTPS

If you have a domain, configure Caddy:

```bash
# On the EC2 instance
sudo tee /etc/caddy/Caddyfile << EOF
yourdomain.com {
    reverse_proxy localhost:3000
}
EOF

sudo systemctl restart caddy
```

Caddy automatically provisions SSL certificates from Let's Encrypt.

## Useful Commands

```bash
# View current state
terraform show

# See what would change
terraform plan

# Apply changes
terraform apply

# Destroy everything (careful!)
terraform destroy

# Format config files
terraform fmt

# Validate configuration
terraform validate
```

## Updating the App

After making changes to your app:

```bash
# On the EC2 instance
deploy-terminal
# This script pulls, builds, and restarts the app
```

Or push to main branch if you set up GitHub Actions.

## Cost

| Resource | Approximate Cost |
|----------|------------------|
| EC2 t3.small | ~$15/month |
| EC2 t3.micro (free tier) | $0 first year |
| Elastic IP (attached) | $0 |
| Data transfer | ~$0-2/month |

## Troubleshooting

**Can't SSH in?**
- Check security group allows your IP on port 22
- Verify your SSH key is correct: `terraform output ssh_command`

**User-data didn't run?**
- Check logs: `cat /var/log/user-data.log`
- Cloud-init logs: `cat /var/log/cloud-init-output.log`

**App not starting?**
- Check service status: `sudo systemctl status browser-terminal`
- Check Docker: `docker ps -a`
- Check logs: `docker compose logs`
