#!/usr/bin/env bash

DOCKER_USER=${DOCKER_USER:-"sondabar"}
REPO=${REPO}
IMAGE_NAME=${IMAGE_NAME:-"jessie-minbase"}

if [ -z ${REPO} ]; then
    REPO_USER=${DOCKER_USER}
else
    REPO_USER="${REPO}/${DOCKER_USER}"
fi

docker pull -a ${REPO_USER}/${IMAGE_NAME}
LATEST=`docker images | grep ${REPO_USER}/${IMAGE_NAME} | tr -s ' ' '\t' | cut -f 2 | grep -v latest | sort -n -r | head -n 1`

if [ -z ${LATEST} ]; then
    echo "No base image, can't update!"
    exit 1;
else
    docker build --no-cache -t ${REPO_USER}/${IMAGE_NAME} - <<EOF
    FROM ${REPO_USER}/${IMAGE_NAME}:latest

    RUN apt-get -y update && \
        apt-get -y --force-yes dist-upgrade && \
        apt-get -y --force-yes --purge autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
EOF
fi

ID=$(docker images | grep ${REPO_USER}/${IMAGE_NAME} | grep latest | tr -s ' ' '\t' | cut -f 3)
docker tag ${ID} ${REPO_USER}/${IMAGE_NAME}:$((LATEST + 1))
docker push ${REPO_USER}/${IMAGE_NAME}