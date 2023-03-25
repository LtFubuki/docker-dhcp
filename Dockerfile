FROM debian:stable-slim

ENV CONFIG_REPO_URL https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/dhcpd.conf

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    isc-dhcp-server \
    curl \
    git \
    inotify-tools \
    iproute2 \
    ipcalc && \
    rm -rf /var/lib/apt/lists/*

COPY update-config.sh /update-config.sh
RUN chmod +x /update-config.sh

ENTRYPOINT ["/update-config.sh"]
