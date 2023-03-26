# A first-level heading
You can run the script directly from the command line using curl and bash. Here's a one-liner that downloads the script from GitHub and runs it:

curl -s https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/start.sh | bash



#################################################################################################################################################################



The Dockerfile creates a container image that runs a DHCP server with the ability to update its configuration dynamically using a script called update-config.sh 

The container is based on the debian:stable-slim image, which provides a minimal Debian installation with only essential packages included.

The first instruction in the Dockerfile is ENV, which sets an environment variable named CONFIG_REPO_URL to the URL of the dhcpd.conf file on GitHub. 

This environment variable will be used by the update-config.sh script to download the configuration file.

The next instruction is RUN, which installs several packages required for the DHCP server to run. 

These packages include isc-dhcp-server, which is the DHCP server software, as well as curl, git, inotify-tools, iproute2, and ipcalc. 

The --no-install-recommends flag is used to prevent the installation of any recommended packages, which can help keep the container size small. 

Finally, the rm command is used to remove the apt cache to reduce the size of the container.

The touch command is used to create an empty dhcpd.leases file that will be used by the DHCP server to store lease information.

The COPY instruction copies the update-config.sh script into the container. 

The chmod command makes the update-config.sh script executable.

Finally, the ENTRYPOINT instruction sets the update-config.sh script as the entrypoint for the container. 

This means that when the container is started, the script will be executed automatically.

The update-config.sh script is responsible for updating the configuration of the DHCP server. 

It does this by downloading the latest version of the dhcpd.conf file from the GitHub repository specified in the CONFIG_REPO_URL environment variable using the curl command. 

The inotifywait command is used to monitor the file for changes. 

When a change is detected, the script restarts the DHCP server with the new configuration.

Overall, this Dockerfile provides a flexible and dynamic way to run a DHCP server inside a container, allowing users to update the configuration of the server without needing to rebuild the container. 

It also ensures that the DHCP server is running in a controlled environment with only the necessary packages installed, which can help improve security and reduce the risk of conflicts with other software on the host system.



#################################################################################################################################################################



The dhcpd.conf configuration file for the DHCP server inside the Docker container. 

It defines the IP address ranges and other network configuration parameters for each VLAN and pool of IP addresses in the network.

The first section of the file sets the global parameters for the DHCP server. 

These include the default lease time, maximum lease time, and the authoritative flag, which indicates that the DHCP server is the only one responsible for assigning IP addresses in the network.

The configuration file then defines three VLANs: VLAN 1, VLAN 2, and VLAN 3. 

Each VLAN is defined using a subnet statement, which specifies the IP address range and subnet mask for the VLAN.

Within each VLAN, there are two IP address pools defined using the pool statement. 

Each pool specifies a range of IP addresses that can be assigned to clients in the VLAN, as well as the domain name and domain name servers to use for DNS resolution.

For example, in VLAN 1, there are two pools defined: vlan1.pool1.example.com and vlan1.pool2.example.com. 

The first pool has a range of IP addresses from 10.1.1.10 to 10.1.1.50, and the second pool has a range of IP addresses from 10.1.2.10 to 10.1.2.50. 

Both pools use 10.1.0.2 as the domain name server.

Similarly, VLAN 2 and VLAN 3 also have two IP address pools defined each, with different ranges of IP addresses and domain name servers.

Overall, this dhcpd.conf file provides a configuration for the DHCP server to assign IP addresses and other network configuration parameters to clients in different VLANs and IP address pools. It enables clients to connect to the network and access resources with the appropriate network configurations.

#################################################################################################################################################################


start.sh is the Bash script that automates the process of building and running the Docker container for the DHCP server with the configuration file from the GitHub repository.

Here's a breakdown of the script:

The DOCKER_IMAGE_NAME variable defines the name of the new Docker image that will be created from the Dockerfile in the GitHub repository.

The DOCKER_CONTAINER_NAME variable defines the name of the new Docker container that will be created from the Docker image.

The DHCP_CONFIG_URL variable defines the URL of the DHCP configuration file on GitHub.

The docker build command builds the Docker image using the Dockerfile in the GitHub repository and sets the name of the new image to the value of the DOCKER_IMAGE_NAME variable.

The docker stop and docker rm commands stop and remove the old Docker container (if it exists) with the same name as the value of the DOCKER_CONTAINER_NAME variable.

The docker run command starts a new Docker container using the new image with the following options:

The --name option sets the name of the new container to the value of the DOCKER_CONTAINER_NAME variable.

The -p option maps port 67 on the host to port 67 in the container. 

Port 67 is the default port used by DHCP servers to communicate with clients.

The $DOCKER_IMAGE_NAME variable specifies the name of the Docker image to use for the container.

Overall, this script simplifies the process of building and running the Docker container for the DHCP server with the configuration file from the GitHub repository. 

By automating these steps, users can quickly and easily deploy a DHCP server in a containerized environment.



#################################################################################################################################################################


The update-config.sh script that is used to dynamically update the configuration of the DHCP server running in the Docker container. 

The script runs inside the container and is automatically executed when the container starts, thanks to the ENTRYPOINT instruction in the Dockerfile.

Here's a breakdown of the script:

The fetch_config function fetches the latest configuration file from the GitHub repository using the curl command. 

If the download is successful, the function outputs a message indicating that the configuration file was fetched successfully. 

If the download fails, the function outputs a message indicating that the download failed and exits with an error code.

The configure_interface function retrieves the IP address, subnet mask, and interface name of the Docker container using the ip and ipcalc commands. 

The function then uses the sed command to substitute these values into the configuration file template stored in /tmp/dhcpd.conf. 

The resulting file is saved to /etc/dhcp/dhcpd.conf, which is the location where the DHCP server reads its configuration file.

The script then calls the fetch_config and configure_interface functions to fetch the initial configuration file and configure the DHCP server interface.

The script sets the INTERFACESv4 environment variable in /etc/default/isc-dhcp-server to the name of the interface on which the DHCP server should listen. 

This ensures that the DHCP server only assigns IP addresses on the desired interface.

The script starts the DHCP server in the background using the /usr/sbin/dhcpd command with the -f flag to run in the foreground, the -cf flag to specify the configuration file, and the --no-pid flag to prevent the DHCP server from writing a PID file.

The script enters an infinite loop that sleeps for 60 seconds, fetches the configuration file, and checks if the configuration file has changed. 

If the configuration file has changed, the script updates the DHCP server configuration file, restarts the DHCP server, and continues the loop.

Overall, this script provides a flexible and dynamic way to update the configuration of the DHCP server running in the Docker container. 

By continuously polling for updates to the configuration file, the script ensures that the DHCP server always has the latest configuration and can adapt to changes in the network environment.



#################################################################################################################################################################
