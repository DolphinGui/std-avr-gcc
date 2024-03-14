#!/usr/bin/sh

apt-get update
apt-get upgrade

apt-get install docker-compose
usermod -aG docker $USER
systemctl start docker

docker build -t avr-build .
docker run -dit avr-build sh avr.sh
