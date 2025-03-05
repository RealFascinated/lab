#!/bin/bash

# Prompt user for Zabbix server IP
read -p "Enter the Zabbix server IP address: " SERVER_IP

# Prompt user for hostname
read -p "Enter the hostname for this agent: " AGENT_HOSTNAME

# Install Zabbix
wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.2+ubuntu24.04_all.deb
apt update
apt install zabbix-agent2

# Configure Zabbix agent with user-provided server IP and hostname
echo "Server=$SERVER_IP" >> /etc/zabbix/zabbix_agent2.conf
echo "ServerActive=$SERVER_IP:10051" >> /etc/zabbix/zabbix_agent2.conf
echo "Hostname=$AGENT_HOSTNAME" >> /etc/zabbix/zabbix_agent2.conf

# Restart Zabbix agent service
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2

echo "Zabbix agent installation and configuration completed for hostname: $AGENT_HOSTNAME"