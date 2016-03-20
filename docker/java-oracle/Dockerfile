FROM sondabar/jessie-minbase:latest

COPY webupd8team-java.list /etc/apt/sources.list.d/

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get -y update && \
    apt-get -y --force-yes dist-upgrade && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get -y install --no-install-recommends oracle-java8-installer oracle-java8-unlimited-jce-policy oracle-java8-set-default && \
    apt-get -y --force-yes --purge autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer
