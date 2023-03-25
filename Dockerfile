# Use an Ubuntu base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    isc-dhcp-server \
    curl \
    git \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV CONFIG_REPO_URL=https://raw.githubusercontent.com/yourusername/yourrepo/main/dhcpd.conf

# Copy update-config script into the container
COPY update-config.sh /update-config.sh
RUN chmod +x /update-config.sh

# Expose DHCP ports
EXPOSE 67/udp 68/udp

# Start the update-config script
ENTRYPOINT ["/update-config.sh"]
