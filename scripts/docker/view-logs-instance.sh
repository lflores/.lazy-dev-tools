#!/bin/bash
if docker ps > /dev/null 2>&1; then
    container=$(docker ps | awk '{if (NR!=1) print $1 ": " $(2) " -> " $(NF)}' | fzf --height 40%)
    if [[ -n $container ]];then
        container_id=$(echo "$container" | awk -F ': ' '{print $1}')
        docker logs -f --tail 1000 "$container_id"
        #docker exec -it "$container_id" /bin/bash || docker exec -it "$container_id" /bin/sh
    else
        echo "You haven't selected container"
    fi
else
    echo "Docker demon has no images running"
fi