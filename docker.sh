#!/usr/bin/sh

set -ex

docker build -t avr-build .
CONTAINER=`docker run avr-build bash work.sh`
docker cp $CONTAINER:/out out
