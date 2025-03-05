#!/bin/bash

# Ensure clean input without Windows line endings
SERVER_IP=""
AGENT_HOSTNAME=""

# Prompt user for Zabbix server IP
while [ -z "$SERVER_IP" ]; do
    read -p "Enter the Zabbix server IP address: " SERVER_IP
    if [ -z "$SERVER_IP" ]; then
        echo "Server IP cannot be empty. Please try again."
    fi
done

# Prompt user for hostname
while [ -z "$AGENT_HOSTNAME" ]; do
    read -p "Enter the hostname for this agent: " AGENT_HOSTNAME
    if [ -z "$AGENT_HOSTNAME" ]; then
        echo "Hostname cannot be empty. Please try again."
    fi
done

# Update package lists
apt update

# Install wget if not already present
apt install -y wget

# Download Zabbix release package
wget -O zabbix-release.deb https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb

# Install Zabbix release package
dpkg -i zabbix-release.deb

# Update package lists again
apt update

# Install Zabbix agent
apt install -y zabbix-agent2

# Clear existing configuration
> /etc/zabbix/zabbix_agent2.conf

# Configure Zabbix agent with user-provided server IP and hostname
echo "Server=$SERVER_IP" > /etc/zabbix/zabbix_agent2.conf
echo "ServerActive=$SERVER_IP:10051" >> /etc/zabbix/zabbix_agent2.conf
echo "Hostname=$AGENT_HOSTNAME" >> /etc/zabbix/zabbix_agent2.conf

# Restart Zabbix agent service
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2

echo "Zabbix agent installation and configuration completed for hostname: $AGENT_HOSTNAME"