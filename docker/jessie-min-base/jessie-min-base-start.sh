#!/usr/bin/env bash

. ./jessie-min-base-config.sh

mkdir /tmp/j${IMAGE_NAME}
debootstrap --variant=minbase jessie /tmp/${IMAGE_NAME} http://ftp.debian.org/debian/
tar -C /tmp/${IMAGE_NAME} -c . | docker import - ${IMAGE_NAME}
docker tag $(docker images -q ${IMAGE_NAME}) ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
docker tag $(docker images -q ${IMAGE_NAME}) ${DOCKER_HUB_USER}/${IMAGE_NAME}:1
rm -rf /tmp/${IMAGE_NAME}

docker login
docker push ${DOCKER_HUB_USER}/j${IMAGE_NAME}
docker logout
