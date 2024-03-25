#!/bin/bash

docker ps -q | xargs -I {} docker exec {} sed -i 's/#BandwidthMB = 10/BandwidthMB = 1000/g' /root/.titanedge/config.toml
docker ps -q | xargs -I {} docker exec {} sed -i 's/#StorageGB = 64/StorageGB = 100/g' /root/.titanedge/config.toml
docker restart $(docker ps -q)

