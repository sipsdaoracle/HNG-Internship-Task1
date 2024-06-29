#!/bin/bash

# Variables
WEB_ROOT="/var/www/html"
SRC_DIR="/home/src" # Adjust this path if your src directory is located elsewhere
NGINX_CONF="/etc/nginx/sites-available/default"

# Step 1: Check if NGINX is already installed
if ! command -v nginx &> /dev/null
then
    echo "NGINX is not installed. Installing NGINX..."
    sudo apt update -y
    sudo apt install nginx -y
else
    echo "NGINX is already installed."
fi

# Step 2: Ensure NGINX is running and enabled
if ! systemctl is-active --quiet nginx
then
    echo "Starting NGINX..."
    sudo systemctl start nginx
else
    echo "NGINX is already running."
fi

if ! systemctl is-enabled --quiet nginx
then
    echo "Enabling NGINX to start on boot..."
    sudo systemctl enable nginx
else
    echo "NGINX is already enabled to start on boot."
fi

# Step 3: Configure firewall to allow HTTP and HTTPS traffic
if ! sudo ufw status | grep -q 'Nginx Full'
then
    echo "Configuring firewall to allow NGINX traffic..."
    sudo ufw allow 'Nginx Full'
else
    echo "Firewall is already configured to allow NGINX traffic."
fi

# Step 4: Set up the web root directory
echo "Setting up the web root directory..."
sudo mkdir -p $WEB_ROOT
sudo chown -R $USER:$USER $WEB_ROOT
sudo chmod -R 755 $WEB_ROOT

# Step 5: Copy static website files to the web root directory
if [ -d "$SRC_DIR" ]; then
    echo "Copying static website files to the web root directory..."
    sudo cp -r $SRC_DIR/* $WEB_ROOT/
else
    echo "Source directory $SRC_DIR does not exist."
    exit 1
fi

# Step 6: Configure NGINX to serve the static site
if ! grep -q "$WEB_ROOT" $NGINX_CONF
then
    echo "Configuring NGINX to serve the static site..."
    sudo tee $NGINX_CONF > /dev/null <<EOT
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root $WEB_ROOT;
    index index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOT
    # Step 7: Restart NGINX to apply changes
    echo "Restarting NGINX to apply changes..."
    sudo systemctl restart nginx
else
    echo "NGINX is already configured to serve the static site."
fi

echo "Deployment completed. Your static website is live."
