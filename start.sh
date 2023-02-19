#!/bin/bash

# Define the name of the new Docker image
DOCKER_IMAGE_NAME=ltfubuki-dhcp

# Define the name of the new Docker container
DOCKER_CONTAINER_NAME=ltfubuki-dhcp

# Define the URL of the DHCP configuration file
DHCP_CONFIG_URL=https://raw.githubusercontent.com/LtFubuki/docker-dhcp/main/dhcpd.conf

# Build the Docker image
docker build -t $DOCKER_IMAGE_NAME https://github.com/LtFubuki/docker-dhcp.git#main

# Stop and remove the old Docker container (if it exists)
docker stop $DOCKER_CONTAINER_NAME
docker rm $DOCKER_CONTAINER_NAME

# Run the new Docker container
docker run -d \
  --name $DOCKER_CONTAINER_NAME \
  -p 67:67 \
  $DOCKER_IMAGE_NAME
