#!/bin/bash

# Define the URL of the DHCP configuration file
DHCP_CONFIG_URL="https://raw.githubusercontent.com/your-username/your-repo/main/dhcpd.conf"

while true
do
  # Download the latest version of the configuration file from GitHub
  wget -q -O /tmp/dhcpd.conf $DHCP_CONFIG_URL

  # Check if the downloaded file is different from the current configuration file
  if ! cmp -s /tmp/dhcpd.conf /etc/dhcp/conf.d/dhcpd.conf; then
    # Copy the updated configuration file to the directory
    cp /tmp/dhcpd.conf /etc/dhcp/conf.d/dhcpd.conf
    echo "Updated DHCP configuration file"
    # Restart the DHCP server to apply the changes
    /etc/init.d/isc-dhcp-server restart
  fi

  # Wait for 5 minutes before checking for updates again
  sleep 300
done
