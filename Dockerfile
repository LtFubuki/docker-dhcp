# Start from a base Ubuntu image
FROM ubuntu:latest

# Update the package list and install the DHCP server and Git
RUN apt-get update && apt-get install -y isc-dhcp-server git

# Set the URL for the raw configuration file on GitHub
ENV DHCP_CONFIG_URL https://raw.githubusercontent.com/<username>/<repo>/<branch>/dhcpd.conf

# Create a directory to hold the configuration file
RUN mkdir /etc/dhcp/conf.d

# Copy the script to the container
COPY update-config.sh /usr/local/bin/update-config.sh
RUN chmod +x /usr/local/bin/update-config.sh

# Expose the DHCP server port
EXPOSE 67/udp

# Start the DHCP server
CMD ["dhcpd", "-f", "-d", "--no-pid", "-cf", "/etc/dhcp/dhcpd.conf"]
