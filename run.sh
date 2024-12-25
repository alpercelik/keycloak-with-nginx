#!/bin/bash

# Source the configuration file
source ./config.sh

# Run the certificate generation script
echo "Generating self-signed certificates..."
./gen-certs.sh

# Check if the certificate generation was successful
if [ $? -ne 0 ]; then
    echo "Failed to generate certificates. Exiting."
    exit 1
fi

# Build first
echo "Building the custom keycloak image..."
./build.sh

# Check if a hostname argument is provided
if [ -n "$1" ]; then
    HOSTNAME_URL=$1
    echo "Using provided hostname: $HOSTNAME_URL"
else
    HOSTNAME_URL="localhost"
    echo "No hostname provided. Using default: $HOSTNAME_URL"
fi

# Cleanup: Stop and remove existing containers and volumes
echo "Cleaning up existing containers and volumes..."
docker-compose -p $PROJECT_NAME down -v

# Build the Docker images
echo "Building the Docker images..."
docker-compose -p $PROJECT_NAME build

# Start the services using Docker Compose with the hostname environment variable
echo "Starting the services..."
HOSTNAME_URL=$HOSTNAME_URL docker-compose -p $PROJECT_NAME up -d

# Check if the Keycloak container is running
if [ "$(docker ps -q -f name=keycloak-behind-nginx)" ]; then
    echo "Keycloak container is running."
else
    echo "Keycloak container is not running. Please check the logs for errors."
    docker-compose -p $PROJECT_NAME logs keycloak
fi