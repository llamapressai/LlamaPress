##
# LlamaPress Installation Script
# ---------------------------------------------------------------------
# This script installs Docker, Docker Compose, and LlamaPress on a 
# fresh Ubuntu 24.04 instance. It also sets up Caddy as a reverse proxy.
# To run:
# curl -fsSL https://raw.githubusercontent.com/llamapressai/LlamaPress/refs/heads/feat/5-min-install/install_llamapress.sh?$(date +%s) | bash
# curl -fsSL "https://raw.githubusercontent.com/llamapressai/LlamaPress/508f37f/install_llamapress.sh" | bash

# curl -fsSL "https://raw.githubusercontent.com/llamapressai/LlamaPress/feat/5-min-install/install_llamapress.sh?$(date +%s)" | bash
# ---------------------------------------------------------------------

#!/usr/bin/env bash
set -e

# ---------------------------------------------------------------------
# 1. Install Docker & Compose if not present -- non-interactive
# ---------------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
    # Silence all interactive prompts and keep local config files
    export DEBIAN_FRONTEND=noninteractive
    APT_OPTS='-y -q'
    # 1-a  Update package index & apply security upgrades
    sudo apt-get update

    # 1-b  Install Docker prerequisites & add Docker’s APT repo
    sudo apt-get $APT_OPTS install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
         sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt-get update
    sudo apt-get $APT_OPTS install docker-ce docker-ce-cli \
                                   containerd.io docker-buildx-plugin \
                                   docker-compose-plugin

    # 1-c  Enable & start Docker daemon
    sudo systemctl enable --now docker

    # 1-d  (Optional) Allow current user to run Docker without sudo
    sudo usermod -aG docker "$USER"
    sudo newgrp docker   # re-evaluate group membership for this shell
fi

# 2. Clone (or curl) config files
mkdir -p llamapress && cd llamapress

# 3. Generate secrets
NEW_KEY=$(openssl rand -hex 64)
PW=$(openssl rand -hex 16)

# [Generate POSTGRES_PASSWORD, SECRET_KEY_BASE, etc...]

# 4. Write .env file
cat <<EOF > .env
# Necessary:
LLAMABOT_API_URL="http://llamabot:8000"
REDIS_URL="redis://redis:6379/1"
LLAMABOT_WEBSOCKET_URL="ws://llamabot:8000/ws"
LLAMAPRESS_API_URL="http://llamapress:3000"

AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
S3_BUCKET=your-bucket-name
ACTIVE_STORAGE_SERVICE=s3

# A Record Domain to this specific LlamaPress, Needed for pages#home controller method if you want multi-site routing.
# HOSTED_DOMAIN="llamapress.ai" 
EOF

# 5. Write docker-compose.yml
cat <<EOF > docker-compose.yml
version: "3.8"

services:
  llamapress:
    image: kody06/llamapress:latest          # <— your pre-built tag
    env_file: .env                           # read secrets from this file
    environment:
      RAILS_ENV: production
    volumes:
      - bundle_cache:/usr/local/bundle       # re-uses gems across image bumps
      - rails_storage:/rails/storage         # ActiveStorage local files
    ports:
      - "8080:3000"                            # http://server_ip/
    restart: unless-stopped
    depends_on: [db, redis]
    networks:
      - llama-network

  llamabot:
    image: kody06/llamabot:latest
    env_file:
      - .env
    command: bash -c "python init_pg_checkpointer.py --uri $$DB_URI && uvicorn main:app --host 0.0.0.0 --port 8000"
    ports:
      - "8000:8000"
    depends_on: [db]
    networks:
      - llama-network

  db:
    image: postgres:15
    environment:
      POSTGRES_DB:      llamapress_production
      POSTGRES_USER:    postgres
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped
    networks:
      - llama-network

  redis:
    image: redis:7-alpine
    volumes: [redis_data:/data]
    restart: unless-stopped
    networks:
      - llama-network
      
volumes:
  postgres_data:
  redis_data:
  bundle_cache:
  rails_storage:
  
# Declare the external network
networks:
  llama-network:
    name: llama-network
EOF

# 6. Install & configure Caddy (as reverse proxy)
echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] \
https://dl.cloudsmith.io/public/caddy/stable/deb/debian/ any-version main" \
| sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt-get install -y caddy

caddy version #ensure it's installed

# Build the Caddyfile: domain if supplied, otherwise plain :80
if [ -n "$HOSTED_DOMAIN" ]; then
  SERVER_NAME="$HOSTED_DOMAIN"
else
  SERVER_NAME=":80"
fi

sudo tee /etc/caddy/Caddyfile >/dev/null <<EOF
${SERVER_NAME} {
    reverse_proxy 127.0.0.1:8080
    encode gzip
}
EOF

# Open firewall for web traffic (Lightsail Console UI already did 443, but do both)
sudo ufw allow 22/tcp || true
sudo ufw allow 80/tcp || true
sudo ufw allow 443/tcp || true

sudo systemctl reload caddy

# 7. Pull images & launch everything
sudo docker compose pull          # fetch images
sudo docker compose up -d         # start in the background
sudo docker compose logs -f llamapress   # watch until you see:

curl -I http://localhost:8080/health

# 8. Print URL
echo "LlamaPress deployed! Visit http://$(curl -s ifconfig.me) to finish setup."
