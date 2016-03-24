#!/usr/bin/env bash

while getopts ":r:i:" OPT; do
  case ${OPT} in
    r)
      REPO_USER=${OPTARG}
      ;;
    i)
      IMAGE_NAME=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "Option -${OPTARG} requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z ${REPO_USER} ]; then
    echo "Option -r (REPO_USER) is missing!" >&2
    exit 1;
fi

if [ -z ${IMAGE_NAME} ]; then
    echo "Option -i (IMAGE_NAME) is missing!" >&2
    exit 1;
fi

docker pull -a ${REPO_USER}/${IMAGE_NAME}
LATEST=`docker images | grep ${REPO_USER}/${IMAGE_NAME} | tr -s ' ' '\t' | cut -f 2 | grep -v latest | sort -n -r | head -n 1`

if [ -z ${LATEST} ]; then
    LATEST=0
    docker build --no-cache -t ${REPO_USER}/${IMAGE_NAME} .
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