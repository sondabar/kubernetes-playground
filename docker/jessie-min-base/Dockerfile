FROM debian:jessie
MAINTAINER Lars Cormann <docker@cormann.biz>

RUN apt-get -y update && \
    apt-get -y --force-yes dist-upgrade && \
    apt-get -y --force-yes --purge autoremove && \
    apt-get install --no-install-recommends -y debootstrap && \
    mkdir /tmp/jessie && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD debootstrap --variant=minbase jessie /tmp/jessie http://ftp.debian.org/debian/ && tar -cf /target/jessie.tar -C /tmp/jessie .

