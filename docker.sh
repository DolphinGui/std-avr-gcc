#!/usr/bin/sh

apt-get update
apt-get upgrade

apt-get install docker-compose
usermod -aG docker $USER
newgrp docker

systemctl start docker
docker build -t avr-build .
