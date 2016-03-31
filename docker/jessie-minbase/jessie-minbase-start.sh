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

mkdir /tmp/${IMAGE_NAME}
debootstrap --variant=minbase jessie /tmp/${IMAGE_NAME} http://ftp.debian.org/debian/
tar -C /tmp/${IMAGE_NAME} -c . | docker import - ${IMAGE_NAME}
docker tag $(docker images -q ${IMAGE_NAME}) ${REPO_USER}/${IMAGE_NAME}:latest
docker tag $(docker images -q ${IMAGE_NAME}) ${REPO_USER}/${IMAGE_NAME}:1
rm -rf /tmp/${IMAGE_NAME}

docker push ${REPO_USER}/${IMAGE_NAME}
