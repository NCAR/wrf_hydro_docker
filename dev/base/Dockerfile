FROM ubuntu:24.04
USER root

# WRF-Hydro dependencies
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    cmake \
    curl \
    emacs-nox \
    bzip2 \
    ca-certificates \
    g++ \
    gfortran \
    git \
    less \
    libhdf5-dev \
    libhdf5-openmpi-dev \
    libnetcdf-pnetcdf-19 \
    libnetcdf-dev \
    libnetcdff-dev \
    libnetcdff7 \
    libopenmpi-dev \
    make \
    nano \
    netcdf-bin \
    openmpi-bin \
    tcsh \
    wget \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --config csh

# install nccmp manually instead of with conda to save space
ENV NCCMP=nccmp-1.9.1.0
WORKDIR /tmp
RUN wget -q https://gitlab.com/remikz/nccmp/-/archive/1.9.1.0/${NCCMP}.tar.gz \
    && tar zxf ${NCCMP}.tar.gz \
    && cmake -B ${NCCMP}/build -S ${NCCMP} \
    && make -C ${NCCMP}/build -j install

# cleanup
RUN rm -rf /tmp/*

# setup environment
ENV NETCDF=/usr/local
ENV NCDIR=/usr/local
ENV NETCDF_LIB=/usr/local/lib
ENV NETCDF_INC=/usr/local/include

# create docker user
RUN useradd -ms /bin/bash docker \
    && usermod -aG sudo docker \
    && chmod -R 777 /home/docker/

USER docker
WORKDIR /home/docker
