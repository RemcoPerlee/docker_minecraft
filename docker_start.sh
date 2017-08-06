#!/bin/sh
docker rm minecraft
docker run \
       --env-file ./env.env  \
       --detach \
       --restart always \
       --publish 25565:25565 \
       --volume /mnt/docker/minecraft/data:/data/ \
       --volume /mnt/docker/minecraft/mods:/mods/ \
       --volume /mnt/docker/minecraft/config:/config/ \
       --volume /mnt/docker/minecraft/plugins:/plugins/ \
       --volume /etc/localtime:/etc/localtime:ro \
       --name minecraft \
       remcoperlee/minecraft:0.1.0
