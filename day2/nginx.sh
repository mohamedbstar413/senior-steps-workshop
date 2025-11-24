#!/bin/bash

# Update system
apt update
apt upgrade -y

# Install Nginx
apt install nginx -y

# Create Nginx configuration for reverse proxy
cat <<EOF > /etc/nginx/sites-available/vproapp
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    # Pass everything to Tomcat with the /vprofile-v2 context
    location / {
        proxy_pass http://192.168.56.3:8080/vprofile-v2/ ;
       	proxy_redirect http://192.168.56.3:8080/vprofile-v2/ / ; 
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
    }

    
    location /vprofile-v2/ {
        proxy_pass http://192.168.56.3:8080/vprofile-v2/;
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

EOF

ln /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
rm -rf /etc/nginx/sites-enabled/default
# Restart Nginx
systemctl restart nginx
systemctl enable nginx
