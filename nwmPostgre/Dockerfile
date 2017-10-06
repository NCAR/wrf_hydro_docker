########################
###Joe Mills
########################
FROM ubuntu:16.04
MAINTAINER Joe Mills <jmills@ucar.edu>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y python3-pip python3-dev postgresql libpq-dev build-essential gcc autoconf libtool pkg-config libssl-dev libxml2-dev libxslt1-dev libffi-dev sudo && \
  pip3 install --upgrade setuptools && \
  pip3 install --upgrade six && \
  pip3 install psycopg2 &&\
  locale-gen en_US.UTF-8 && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8