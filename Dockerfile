# Start from a base Ubuntu image
FROM ubuntu:latest

# Update the package list and install the DHCP server, Git, and some basic utilities
RUN apt-get update && apt-get install -y isc-dhcp-server git nano curl wget

# Set the URL for the raw configuration file on GitHub
ENV DHCP_CONFIG_URL https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/dhcpd.conf

# Create a directory to hold the configuration file
RUN mkdir /etc/dhcp/conf.d

# Copy the script and configuration file to the container
COPY update-config.sh /usr/local/bin/update-config.sh
RUN chmod +x /usr/local/bin/update-config.sh
RUN chown root:root /usr/local/bin/update-config.sh
RUN chmod 755 /usr/local/bin/update-config.sh
RUN chown -R root:root /etc/dhcp
RUN chmod -R 755 /etc/dhcp

# Copy the dhcpd.conf file to the container
COPY dhcpd.conf /etc/dhcp/dhcpd.conf

# Set the ownership of the dhcpd.leases file to the dhcpd user
RUN touch /var/lib/dhcp/dhcpd.leases && chown dhcpd:dhcpd /var/lib/dhcp/dhcpd.leases

# Set the ownership of the dhcpd.conf file to the dhcpd user
RUN chown dhcpd:dhcpd /etc/dhcp/dhcpd.conf

# Set the user that runs the DHCP server process inside the container
USER dhcpd

# Expose the DHCP server port
EXPOSE 67/udp

# Start the DHCP server using the update-config.sh script
CMD ["/usr/local/bin/update-config.sh"]
