FROM sondabar/jessie-minbase:latest

RUN apt-get -y update && apt-get -y --force-yes dist-upgrade && apt-get -y --force-yes --purge autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
