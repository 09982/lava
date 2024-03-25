#!/bin/bash

docker pull nezha123/titan-edge:latest

# 创建5个容器
for i in {1..4}
do
    # 为每个容器创建一个存储卷
    storage="titan_storage_$i"
    # mkdir -p "$storage"

    # 运行容器，并设置重启策略为always
    container_id=$(docker run -d --restart always -v "$PWD/$storage:/root/.titanedge/storage" --name "titan$i" nezha123/titan-edge:latest)

    echo "Container titan$i started with ID $container_id"

    sleep 30
    
    # 进入容器并执行绑定和其他命令
    docker exec -it $container_id bash -c "\
        titan-edge bind --hash=EE78736B-11F6-49A1-9752-7E9AFDCA3441 https://api-test1.container1.titannet.io/api/v2/device/binding"
done

docker ps -q | xargs -I {} docker exec {} sed -i 's/#BandwidthMB = 10/BandwidthMB = 1000/g' /root/.titanedge/config.toml
docker ps -q | xargs -I {} docker exec {} sed -i 's/#StorageGB = 64/StorageGB = 100/g' /root/.titanedge/config.toml
docker restart $(docker ps -q)


docker ps -q | xargs -I {} docker exec {} sed -i 's/#BandwidthMB = 10/BandwidthMB = 10/g' /root/.titanedge/config.toml
docker ps -q | xargs -I {} docker exec {} sed -i 's/#StorageGB = 64/StorageGB = 156/g' /root/.titanedge/config.toml
docker restart $(docker ps -q)
