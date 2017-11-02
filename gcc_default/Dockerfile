###################################
# Author: Tony Castronova <acastronova -at- cuahsi.org>
# Author: Joe Mills <jmills -at- ucar.edu>
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/ubuntu

MAINTAINER jamesmcc@ucar.edu

####################################
########## ROOT USER  ##############
####################################
USER root

RUN apt-get update

## Keep the large pieces away from the small pieces to speed up re-builds.

####################################
## WRF-Hydro dependencies

## Core wrf-hydro compiler stuff
RUN apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    vim \ 
    libhdf5-dev \
    gfortran \
    m4 \
    make\ 
    libswitch-perl 

## Download, build, and install MPICH
ARG MPICH_VERSION="3.2"
ARG MPICH_CONFIGURE_OPTIONS="--disable-cxx"
ARG MPICH_MAKE_OPTIONS
RUN mkdir /tmp/mpich-src
WORKDIR /tmp/mpich-src
RUN wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
    && cd mpich-${MPICH_VERSION}  \
    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
    && make ${MPICH_MAKE_OPTIONS} && make install \
    && rm -rf /tmp/mpich-src

#### TEST MPICH INSTALLATION ####
#RUN mkdir /tmp/mpich-test
#WORKDIR /tmp/mpich-test
#COPY mpich-test .
#RUN sh test.sh
#RUN rm -rf /tmp/mpich-test

## install netcdf-C
ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV NCDIR=/usr/local
ARG NETCDF_C_VERSION="4.4.1.1"
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_C_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/netcdf-${NETCDF_C_VERSION}.tar.gz -C /tmp \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && CPPFLAGS=-I${H5DIR}/include LDFLAGS=-L${H5DIR}/lib ./configure --prefix=/usr/local \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && make \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && make install \
    && rm -rf /tmp/netcdf-${NETCDF_C_VERSION}


# install netcdf-Fortran
ENV NFDIR=/usr/local
ENV LD_LIBRARY_PATH=${NCDIR}/lib
ARG NETCDF_F_VERSION="4.4.4"
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${NETCDF_F_VERSION}.tar.gz \
    && tar -xf netcdf-fortran-${NETCDF_F_VERSION}.tar.gz -C /tmp \
    && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION}/ \
    && CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR} \
    && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION} \
    && make \
    && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION} \
    && make install \
    && rm -rf /tmp/netcdf-fortran-${NETCDF_F_VERSION}
## JLM: Clean up the above.

ENV NETCDF=/usr/local

## Extras to make it nice/convenient
## May separate these into a separate container
RUN apt-get install -yq --no-install-recommends \
    git \
    nano \
    tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --config csh

#### CLEAN UP ####
WORKDIR /

## just to be sure 
RUN rm -rf /tmp/*

