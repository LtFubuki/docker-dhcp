# Use an Ubuntu 20.04 base image
FROM ubuntu:23.04

# Prevent any prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Update GPG keys and install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 apt-transport-https && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 && \
    apt-get update && apt-get install -y \
    isc-dhcp-server \
    curl \
    git \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV CONFIG_REPO_URL=https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/dhcpd.conf

# Copy update-config script into the container
COPY update-config.sh /update-config.sh
RUN chmod +x /update-config.sh

# Expose DHCP ports
EXPOSE 67/udp 68/udp

# Start the update-config script
ENTRYPOINT ["/update-config.sh"]
