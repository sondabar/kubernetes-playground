FROM 192.168.64.1:5000/sondabar/java-jre:latest

RUN apt-get -y update && \
    apt-get -y --force-yes dist-upgrade && \
    apt-get -y --force-yes --purge autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
