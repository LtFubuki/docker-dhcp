# To build the image:

docker build --build-arg REPO_USER=LtFubuki --build-arg REPO_NAME=docker-dhcp --build-arg BRANCH=main -t LtFubuki-dhcp-server .

# To run the container, you'll need to map the container's DHCP server port 67/udp to the host's port 67/udp:

docker run -d --name LtFubuki-dhcp-container -p 67:67/udp LtFubuki-dhcp-server
