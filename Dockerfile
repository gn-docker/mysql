# SEE files/production.env.example for obligatory env variables

FROM ubuntu:14.04.3
MAINTAINER Dmitry Mozzherin
ENV LAST_FULL_REBUILD 2016-02-17

RUN groupadd -f -g 301 -r mysql && \
    useradd -u 301 -g 301 -r -d "/nonexistent" -M -s "/bin/false" mysql && \
    apt-get update && \
    apt-get -yq install mysql-server-5.6 pwgen vim-nox procps && \
    mkdir -p /opt/gni/backup && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/mysql/*

VOLUME /var/log
VOLUME /var/lib/mysql
VOLUME /etc/mysql
EXPOSE 3306

COPY files/start.sh /start.sh
COPY files/stop.sh /stop.sh
COPY files/create-db.sh /create-db.sh
CMD ["/start.sh"]
