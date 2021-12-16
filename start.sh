#!/usr/bin/sh
mkdir -p work
sudo chown 1000:1000 work
docker run --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -v ${PWD}/work:/home/reds/ -d -p 2222:22 parpaing/sye
