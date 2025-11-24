#!/bin/bash

# Update system
apt update
apt upgrade -y

# Install dependencies
apt install openjdk-11-jdk git maven wget -y

# Download and install Tomcat 9
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz

# Move Tomcat to proper location (directly, not nested)
mv apache-tomcat-9.0.75 /opt/tomcat9

# Create tomcat user
useradd -r -m -U -d /opt/tomcat9 -s /bin/false tomcat

# Set permissions
chown -R tomcat:tomcat /opt/tomcat9

# Create systemd service
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat9/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat9"
Environment="CATALINA_BASE=/opt/tomcat9"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat9/bin/startup.sh
ExecStop=/opt/tomcat9/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

# Pull Github Code and build
cd /tmp
git clone https://github.com/abdelrahmanonline4/sourcecodeseniorwr
cd sourcecodeseniorwr

# Deploy WAR file to Tomcat's webapps directory
cp target/*.war /opt/tomcat9/webapps/

# Set correct ownership
chown tomcat:tomcat /opt/tomcat9/webapps/*.war

# Update /etc/hosts file for service discovery
echo "192.168.56.5 db01" >> /etc/hosts
echo "192.168.56.4 rmq01" >> /etc/hosts

# Start Tomcat
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

echo "Tomcat setup complete!"
echo "Application will be available at http://192.168.56.12:8080/vprofile-v2/"
