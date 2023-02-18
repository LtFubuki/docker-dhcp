You can run the script directly from the command line using curl and bash. Here's a one-liner that downloads the script from GitHub and runs it:

curl -s https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/start.sh | bash




# To build the image:

docker build -t ltfubuki-dhcp https://github.com/LtFubuki/docker-dhcp.git#main

# To run the container, you'll need to map the container's DHCP server port 67/udp to the host's port 67/udp:

docker run -d --name ltfubuki-dhcp -p 67:67/udp ltfubuki-dhcp
