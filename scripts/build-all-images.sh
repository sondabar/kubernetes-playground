#!/usr/bin/env bash

cd ../docker/java-jre/
./build-image.sh
cd -
cd ../docker/jenkins-master
./build-image.sh
cd -