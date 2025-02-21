#!/bin/bash

# Variabel
NGINX_CONF="/etc/nginx/sites-available/proxmox"
NGINX_LINK="/etc/nginx/sites-enabled/proxmox"
SSL_CERT="/etc/ssl/certs/server.crt"
SSL_KEY="/etc/ssl/private/server.key"

echo "🔹 Installing Nginx..."
sudo apt update && sudo apt install -y nginx

echo "🔹 Creating Nginx configuration for Proxmox..."
sudo tee "$NGINX_CONF" > /dev/null <<EOL
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate $SSL_CERT;
    ssl_certificate_key $SSL_KEY;

    location / {
        proxy_pass https://localhost:8006;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_ssl_verify off;
    }
}

server {
    listen 80;
    server_name localhost;
    return 301 https://\$host\$request_uri;
}
EOL

echo "🔹 Creating symbolic link for Nginx config..."
sudo ln -sf "$NGINX_CONF" "$NGINX_LINK"

echo "🔹 Testing Nginx configuration..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "🔹 Restarting Nginx..."
    sudo systemctl restart nginx
    echo "✅ Nginx is now configured for Proxmox with SSL!"
else
    echo "❌ Nginx configuration test failed. Please check the configuration."
fi
