#!/bin/bash

# Source the configuration file
source ./config.sh

# Stop any running containers using the image
echo "Stopping any running containers using the image: $IMAGE_NAME..."
if [ "$(docker ps -q -f ancestor=$IMAGE_NAME)" ]; then
    docker stop $(docker ps -q -f ancestor=$IMAGE_NAME)
else
    echo "No running containers found for image: $IMAGE_NAME."
fi

# Remove the image if it exists
if [ "$(docker images -q $IMAGE_NAME 2> /dev/null)" ]; then
    echo "Removing image: $IMAGE_NAME..."
    docker rmi -f $IMAGE_NAME
else
    echo "Image $IMAGE_NAME does not exist. No action taken."
fi

# Build the Docker image
echo "Building the Docker image: $IMAGE_NAME..."
docker build -t $IMAGE_NAME .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Image $IMAGE_NAME built successfully."
else
    echo "Error building the image $IMAGE_NAME."
    exit 1
fi