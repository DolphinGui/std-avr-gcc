#!/usr/bin/sh

set -ex

docker build -t avr-build .
mkdir -p out
docker run avr-build bash work.sh
# docker run --mount type=bind,src="$(pwd)"/out,dst=/out avr-build bash work.sh
# cd out
# tar -Ipixz -cf root.tar.xz root/
# tar -Ipigz -cf winroot.tar.gz winroot/
# cd ..
