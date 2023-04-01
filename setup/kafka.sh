#!/bin/bash
export REPO_URL="https://github.com/hencho108/spotify-realtime-data-streaming.git"

echo "Update package list"
sudo apt-get update

echo "Installing Docker"
sudo apt-get -y install docker.io docker-compose

echo "Adding user to docker group"
sudo newgrp docker

echo "Cloning repo"
git clone "$REPO_URL"

echo "Building Kafka docker images"
cd spotify-realtime-data-streaming/kafka
docker-compose up -d

echo "Building spotify-producer docker image"
cd ../spotify-producer
docker build -t spotify-producer .
