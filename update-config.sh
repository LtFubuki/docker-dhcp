#!/bin/bash

# Get primary network interface
INTERFACE=$(ip route show | awk '/default/ {print $5}' | head -n 1)

# Get IP address and subnet mask of the primary network interface
IP_ADDRESS=$(ip -o -f inet addr show $INTERFACE | awk '{print $4}')

# Calculate network address and netmask
NETWORK_ADDRESS=$(ipcalc -n $IP_ADDRESS | awk -F= '{print $2}')
NETMASK=$(ipcalc -m $IP_ADDRESS | awk -F= '{print $2}')

# Set up a basic subnet declaration
SUBNET_DECLARATION="subnet $NETWORK_ADDRESS netmask $NETMASK {
  range ${NETWORK_ADDRESS%.*}.100 ${NETWORK_ADDRESS%.*}.200;
  option routers $IP_ADDRESS;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
}"

# Function to fetch the latest config file from GitHub
fetch_config() {
  echo "Fetching configuration file..."
  curl -L -o /etc/dhcp/dhcpd.conf --silent "${CONFIG_REPO_URL}"
}

# Fetch the initial config file
fetch_config

# Append subnet declaration to the configuration file
echo "$SUBNET_DECLARATION" >> /etc/dhcp/dhcpd.conf

# Start the DHCP server in the background
/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf --no-pid &

# Continuously poll for updates to the config file
while true; do
  sleep 60
  LATEST_CONFIG=$(curl -L --silent --remote-name --remote-header-name --remote-time "${CONFIG_REPO_URL}")

  # Check if the config file has changed
  if ! cmp -s /etc/dhcp/dhcpd.conf "${LATEST_CONFIG}"; then
    echo "Configuration file has changed, updating and restarting DHCP server..."
    mv "${LATEST_CONFIG}" /etc/dhcp/dhcpd.conf
    echo "$SUBNET_DECLARATION" >> /etc/dhcp/dhcpd.conf

    # Restart the DHCP server
    pkill dhcpd
    /usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf --no-pid &
  fi
done
