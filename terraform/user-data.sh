#!/bin/bash
set -e

# Log everything to a file for debugging
exec > >(tee /var/log/user-data.log) 2>&1

echo "=== Starting user-data script ==="

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install Caddy
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt-get update
apt-get install -y caddy

# Install git
apt-get install -y git

# Create app directory
mkdir -p /app
chown ubuntu:ubuntu /app

# Create a systemd service for the app
cat > /etc/systemd/system/browser-terminal.service << 'EOF'
[Unit]
Description=Browser Terminal
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/app/browser-terminal
ExecStart=/usr/bin/docker compose up
ExecStop=/usr/bin/docker compose down
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create deploy script
cat > /usr/local/bin/deploy-terminal << 'EOF'
#!/bin/bash
set -e
cd /app/browser-terminal
git pull origin main
npm ci
npm run build
docker build -t terminal-sandbox ./sandbox
sudo systemctl restart browser-terminal
echo "Deployment complete!"
EOF
chmod +x /usr/local/bin/deploy-terminal

echo "=== User-data script complete ==="
echo "Next steps:"
echo "1. SSH in: ssh ubuntu@<this-ip>"
echo "2. Clone your repo: cd /app && git clone <your-repo> browser-terminal"
echo "3. Build: cd browser-terminal && npm ci && npm run build"
echo "4. Build sandbox: docker build -t terminal-sandbox ./sandbox"
echo "5. Start: sudo systemctl enable --now browser-terminal"
