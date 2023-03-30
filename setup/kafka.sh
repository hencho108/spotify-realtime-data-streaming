#!/bin/bash

# Update the package list
sudo apt-get update

# Install Apache2
# sudo apt-get install apache2 -y

# Enable Apache2 service to start on boot
# sudo systemctl enable apache2.service

# Start Apache2 service
# sudo systemctl start apache2.service

# sudo echo "Hello World from $(hostname -f)" >/var/www/html/index.html

echo "Installing Docker"
sudo apt-get -y install docker.io docker-compose &&
    sudo newgrp docker &&
    docker --version &&
    docker-compose --version

echo "Cloning repo and building docker image"
git clone https://github.com/hencho108/spotify-realtime-data-streaming.git &&
    cd spotify-realtime-data-streaming/spotify-producer
# docker build -t spotify-producer .
