#!/bin/bash

# Update the package list
sudo apt-get update

# Install Apache2
sudo apt-get install apache2 -y

# Enable Apache2 service to start on boot
sudo systemctl enable apache2.service

# Start Apache2 service
sudo systemctl start apache2.service

sudo echo "Hello World from $(hostname -f)" >/var/www/html/index.html

sudo apt-get -y install docker.io docker-compose &&
    docker --version &&
    docker-compose --version &&
    exec newgrp docker

git clone https://github.com/hencho108/spotify-realtime-data-streaming.git &&
    cd spotify-realtime-data-streaming/spotify-producer &&
    docker build -t spotify-producer .

docker run -it spotify-listener
