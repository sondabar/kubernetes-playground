#!/usr/bin/env bash

. ./jessie-min-base-config.sh

docker pull -a ${DOCKER_HUB_USER}/${IMAGE_NAME}
LATEST=`docker images ${DOCKER_HUB_USER}/${IMAGE_NAME} | sed 1d | tr -s ' ' '\t' | cut -f 2 | grep -v latest | sort -n -r | head -n 1`

docker build --no-cache -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:$((LATEST + 1)) .
docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}
