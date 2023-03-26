You can run the script directly from the command line using curl and bash. Here's a one-liner that downloads the script from GitHub and runs it:

curl -s https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/start.sh | bash

####################################################################################################################################################################



The Dockerfile creates a container image that runs a DHCP server with the ability to update its configuration dynamically using a script called update-config.sh. The container is based on the debian:stable-slim image, which provides a minimal Debian installation with only essential packages included.

The first instruction in the Dockerfile is ENV, which sets an environment variable named CONFIG_REPO_URL to the URL of the dhcpd.conf file on GitHub. This environment variable will be used by the update-config.sh script to download the configuration file.

The next instruction is RUN, which installs several packages required for the DHCP server to run. These packages include isc-dhcp-server, which is the DHCP server software, as well as curl, git, inotify-tools, iproute2, and ipcalc. The --no-install-recommends flag is used to prevent the installation of any recommended packages, which can help keep the container size small. Finally, the rm command is used to remove the apt cache to reduce the size of the container.

The touch command is used to create an empty dhcpd.leases file that will be used by the DHCP server to store lease information.

The COPY instruction copies the update-config.sh script into the container. The chmod command makes the update-config.sh script executable.

Finally, the ENTRYPOINT instruction sets the update-config.sh script as the entrypoint for the container. This means that when the container is started, the script will be executed automatically.

The update-config.sh script is responsible for updating the configuration of the DHCP server. It does this by downloading the latest version of the dhcpd.conf file from the GitHub repository specified in the CONFIG_REPO_URL environment variable using the curl command. The inotifywait command is used to monitor the file for changes. When a change is detected, the script restarts the DHCP server with the new configuration.

Overall, this Dockerfile provides a flexible and dynamic way to run a DHCP server inside a container, allowing users to update the configuration of the server without needing to rebuild the container. It also ensures that the DHCP server is running in a controlled environment with only the necessary packages installed, which can help improve security and reduce the risk of conflicts with other software on the host system.

####################################################################################################################################################################
