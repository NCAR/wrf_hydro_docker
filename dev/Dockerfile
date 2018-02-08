###################################
# WRF-Hydro Development docker
# Purpose:
#   1) Compile code on the host system (non-interactive mode)
#   2) Run code on the host system     (non-interactive mode)
#   3) Interactive use. 
# The above is achieved through entrypoint and host-side scripting.
#
# Authors: James McCreight, Joe Mills
# Email:  jamesmcc-at-ucar.edu, jmills-at-ucar.edu
# Date:  2018-02-08
###################################

###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Author: Joe Mills <jmills -at- ucar.edu>
# Date:  2018-02-08
###################################

FROM phusion/baseimage

MAINTAINER jamesmcc@ucar.edu

####################################
########## ROOT USER  ##############
####################################
USER root

####################################
## WRF-Hydro dependencies

## Core wrf-hydro compiler stuff
RUN add-apt-repository ppa:ubuntu-elisp/ppa \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    vim \ 
    libhdf5-dev \
    gfortran \
    valgrind \
    m4 \
    make \ 
    libswitch-perl \
    git \
    nano \
    tcsh \
    emacs-snapshot \
    emacs-snapshot-el \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --config csh

## Download, build, and install MPICH
RUN MPICH_VERSION="3.2" \
    && MPICH_CONFIGURE_OPTIONS="--disable-cxx" \
    && MPICH_MAKE_OPTIONS='' \
    && mkdir /tmp/mpich-src \
    && cd /tmp/mpich-src \
    && wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
    && cd mpich-${MPICH_VERSION}  \
    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
    && make ${MPICH_MAKE_OPTIONS} && make install \
    && rm -rf /tmp/mpich-src

#### TEST MPICH INSTALLATION ####
## Where is this from? Should we run the test?
#WORKDIR /tmp/mpich-test
#COPY mpich-test .
#RUN mkdir /tmp/mpich-test \
#    && test.sh \
#    && RUN rm -rf /tmp/mpich-test

## install netcdf-C
ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV NCDIR=/usr/local
RUN NETCDF_C_VERSION="4.4.1.1" \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_C_VERSION}.tar.gz -P /tmp \
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
RUN NETCDF_F_VERSION="4.4.4" \
    && cd /tmp \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${NETCDF_F_VERSION}.tar.gz \
    && tar -xf netcdf-fortran-${NETCDF_F_VERSION}.tar.gz \
    && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION} \
    && CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR} \
    && make \
    && make install \
    && cd / \
    && rm -rf /tmp/netcdf-fortran-${NETCDF_F_VERSION}

ENV NETCDF=/usr/local

## just to be sure 
RUN rm -rf /tmp/*

###################################
## build nco here. really not what I was hpoing for.
RUN apt-get update
RUN apt-get install -yq --no-install-recommends \
    nco \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

###################################
## wrf-hydro development docker interface script
COPY ./interface.sh /.

###################################
## create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker

####################################
######### docker user ###########
####################################
USER docker
WORKDIR /home/docker
RUN cp /interface.sh ~/.
RUN cd $HOME
ENTRYPOINT ["/interface.sh"]
CMD ["interactive"]