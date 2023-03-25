#!/bin/bash

# Function to fetch the latest config file from GitHub
fetch_config() {
  echo "Fetching configuration file..."
  curl -L -o /tmp/dhcpd.conf --silent "${CONFIG_REPO_URL}"
  if [ $? -eq 0 ]; then
    echo "Fetched configuration file successfully."
  else
    echo "Failed to fetch configuration file."
  fi
}

# Function to configure the DHCP server interface
configure_interface() {
  INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
  IP_ADDRESS=$(ip -o -4 addr list $INTERFACE | awk '{print $4}' | cut -d/ -f1)
  SUBNET_MASK=$(ipcalc -m $IP_ADDRESS | cut -d= -f2)
  sed -i "s/INTERFACENAME/$INTERFACE/" /tmp/dhcpd.conf
  sed -i "s/IPADDRESS/$IP_ADDRESS/" /tmp/dhcpd.conf
  sed -i "s/SUBNETMASK/$SUBNET_MASK/" /tmp/dhcpd.conf
}

# Fetch the initial config file and configure interface
fetch_config
configure_interface
cp /tmp/dhcpd.conf /etc/dhcp/dhcpd.conf

# Start the DHCP server in the background
/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf --no-pid &

# Continuously poll for updates to the config file
while true; do
  sleep 60
  fetch_config
  configure_interface

  # Check if the config file has changed
  if ! cmp -s /etc/dhcp/dhcpd.conf /tmp/dhcpd.conf; then
    echo "Configuration file has changed, updating and restarting DHCP server..."
    cp /tmp/dhcpd.conf /etc/dhcp/dhcpd.conf

    # Restart the DHCP server
    pkill dhcpd
    /usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf --no-pid &
  fi
done
