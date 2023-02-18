# Start from a base Ubuntu image
FROM ubuntu:latest

# Update the package list and install the DHCP server and Git
RUN apt-get update && apt-get install -y isc-dhcp-server git

# Set the URL for the raw configuration file on GitHub
ENV DHCP_CONFIG_URL https://raw.githubusercontent.com/<username>/<repo>/<branch>/dhcpd.conf

# Create a directory to hold the configuration file
RUN mkdir /etc/dhcp/conf.d

# Download the configuration file from GitHub and store it in the container
RUN curl -L $DHCP_CONFIG_URL -o /etc/dhcp/conf.d/dhcpd.conf

# Make sure the dhcpd user has read access to the configuration file
RUN chown dhcpd:dhcpd /etc/dhcp/conf.d/dhcpd.conf
RUN chmod 644 /etc/dhcp/conf.d/dhcpd.conf

# Expose the DHCP server port
EXPOSE 67/udp

# Start the DHCP server
CMD ["dhcpd", "-f", "-d", "--no-pid", "-cf", "/etc/dhcp/conf.d/dhcpd.conf"]
