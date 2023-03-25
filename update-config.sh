#!/bin/bash

# Function to fetch the latest config file from GitHub
fetch_config() {
  echo "Fetching configuration file..."
  curl -L -o /etc/dhcp/dhcpd.conf --silent "${CONFIG_REPO_URL}"
}

# Fetch the initial config file
fetch_config

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

    # Restart the DHCP server
    pkill dhcpd
    /usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf --no-pid &
  fi
done
