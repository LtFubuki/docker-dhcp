# To build the image:

docker build -t ltfubuki-dhcp https://github.com/LtFubuki/docker-dhcp.git#main

# To run the container, you'll need to map the container's DHCP server port 67/udp to the host's port 67/udp:

docker run -d --name LtFubuki-dhcp -p 67:67/udp LtFubuki-dhcp
