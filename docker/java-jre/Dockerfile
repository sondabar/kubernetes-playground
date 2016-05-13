FROM sondabar/jessie-minbase:latest
MAINTAINER Lars Cormann <docker@cormann.biz>

COPY jessie-backports.list /etc/apt/sources.list.d/

RUN apt-get -y update && \
    apt-get -y --force-yes dist-upgrade && \
    apt-get -y --no-install-recommends install openjdk-8-jre-headless && \
    /usr/sbin/update-java-alternatives -s java-1.8.0-openjdk-amd64 && \
    apt-get -y --force-yes --purge autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*
