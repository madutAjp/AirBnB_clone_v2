#!/usr/bin/env bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null
then
    sudo apt-get update
    sudo apt-get install -y nginx
fi

# Create directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file for testing
echo '<html><head></head><body>Holberton School</body></html>' | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change ownership of /data/ to ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
sudo bash -c 'cat > /etc/nginx/sites-available/web_static << EOL
server {
    listen 80;
    server_name _;
    location /hbnb_static/ {
        alias /data/web_static/current/;
        try_files \$uri \$uri/ =404;
    }
}
EOL'

# Enable the site
sudo ln -s /etc/nginx/sites-available/web_static /etc/nginx/sites-enabled/

# Restart Nginx
sudo systemctl restart nginx

# Ensure the script exits successfully
exit 0
