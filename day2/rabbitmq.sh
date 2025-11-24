#!/bin/bash

# Update system
apt update
apt upgrade -y

# Install dependencies
apt install curl gnupg apt-transport-https -y

# Add RabbitMQ repository
curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | gpg --dearmor | tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null

curl -1sLf "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf77f1eda57ebb1cc" | gpg --dearmor | tee /usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg > /dev/null

curl -1sLf "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | gpg --dearmor | tee /usr/share/keyrings/io.packagecloud.rabbitmq.gpg > /dev/null

# Add RabbitMQ sources
cat <<EOF > /etc/apt/sources.list.d/rabbitmq.list
deb [signed-by=/usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu focal main
deb-src [signed-by=/usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu focal main
deb [signed-by=/usr/share/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ focal main
deb-src [signed-by=/usr/share/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ focal main
EOF

# Update and install Erlang & RabbitMQ
apt update
apt install -y erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
                erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
                erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools \
                erlang-tftp erlang-tools erlang-xmerl

apt install rabbitmq-server -y

# Enable and start RabbitMQ
systemctl start rabbitmq-server
systemctl enable rabbitmq-server

# Enable management plugin (optional but useful)
rabbitmq-plugins enable rabbitmq_management

# Restart RabbitMQ
systemctl restart rabbitmq-server
