###################################
# Author: Tony Castronova
# Email:  acastronova@cuahsi.org
# Date:  8.29.2017
###################################

FROM ubuntu:16.04

MAINTAINER acastronova@cuahsi.org
USER root

####################################
########## ROOT USER  ##############
####################################
RUN apt-get update
RUN apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    vim \ 
    libhdf5-dev \
    gfortran \
    m4 \
    make\ 
    libswitch-perl \ 
    mpich \
    libopenmpi-dev \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install netcdf-C
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz -P /tmp  
RUN tar -xf /tmp/netcdf-4.4.1.1.tar.gz -C /tmp
ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV NCDIR=/usr/local
RUN cd /tmp/netcdf-4.4.1.1 && CPPFLAGS=-I${H5DIR}/include LDFLAGS=-L${H5DIR}/lib ./configure --prefix=/usr/local
RUN cd /tmp/netcdf-4.4.1.1 && make
RUN cd /tmp/netcdf-4.4.1.1 && make install

# install netcdf-Fortran
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz
RUN tar -xf netcdf-fortran-4.4.4.tar.gz -C /tmp
ENV NFDIR=/usr/local
ENV LD_LIBRARY_PATH=${NCDIR}/lib
RUN cd /tmp/netcdf-fortran-4.4.4/ && CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR}
RUN cd /tmp/netcdf-fortran-4.4.4 && make
RUN cd /tmp/netcdf-fortran-4.4.4 && make install

RUN useradd -ms /bin/bash cuahsi
RUN usermod -aG sudo cuahsi

####################################
########## CUAHSI USER #############
####################################
USER cuahsi
WORKDIR /home/cuahsi

# Compile the NWM
RUN wget http://public.cuahsi.org/nwm/wrf-hydro-nwm-1.2.tar.gz
RUN tar -xf wrf-hydro-nwm-1.2.tar.gz
ENV NETCDF=/usr/local
RUN cd wrf_hydro_nwm/trunk/NDHMS && ./configure 6 && ./compile_offline_NoahMP.sh

