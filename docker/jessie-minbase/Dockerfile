FROM debian
MAINTAINER Lars Cormann <docker@cormann.biz>

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y debootstrap

VOLUME /tmp/base

ENTRYPOINT debootstrap --variant=minbase jessie /base http://ftp.debian.org/debian/ && \
           cp -R /base/usr/share/locale/en\@* /tmp/ && \
           rm -rf /base/usr/share/locale/* && \
           mv /tmp/en\@* /base/usr/share/locale/ && \
           rm -rf /base/usr/share/doc/* && \
           rm -rf /base/var/lib/apt/lists/* && \
           rm -rf /base/var/cache/* && \
           rm -f /tmp/base/jessie.tar && \
           tar -zcvf /tmp/base/jessie.tar.gz /base
