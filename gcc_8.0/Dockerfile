###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/gcc_5.4.0

MAINTAINER jamesmcc@ucar.edu

####################################
########## ROOT USER  ##############
####################################
USER root

#RUN apt-get update
#RUN  apt-get install gcc-7.2.0 g++-7.2.0

## Download open-coarrays

#WORKDIR /tmp

ARG OPEN_COARRAYS_VERSION="1.9.2"
RUN wget https://github.com/sourceryinstitute/OpenCoarrays/releases/download/1.9.2/OpenCoarrays-${OPEN_COARRAYS_VERSION}.tar.gz \
    && tar xvzf OpenCoarrays-${OPEN_COARRAYS_VERSION}.tar.gz \
    && mkdir open-coarrays_inst \
    && cd OpenCoarrays-${OPEN_COARRAYS_VERSION} \
    && ./install.sh --package gcc \ 
    --from-url https://github.com/sourceryinstitute/gcc/archive/teams-20170919.tar.gz \
    --install-version teams-20170919 \
    --install-prefx /tmp/open-coarrays_inst \
    --disable-bootstrap


## Download, build, and install MPICH
#ARG MPICH_VERSION="3.2"
#ARG MPICH_CONFIGURE_OPTIONS="--disable-cxx"
#ARG MPICH_MAKE_OPTIONS
#RUN mkdir /tmp/mpich-src
#WORKDIR /tmp/mpich-src
#RUN wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
#    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
#    && cd mpich-${MPICH_VERSION}  \
#    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
#    && make ${MPICH_MAKE_OPTIONS} && make install \
#    && rm -rf /tmp/mpich-src

#### TEST MPICH INSTALLATION ####
#RUN mkdir /tmp/mpich-test
#WORKDIR /tmp/mpich-test
#COPY mpich-test .
#RUN sh test.sh
#RUN rm -rf /tmp/mpich-test

## install netcdf-C
#RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz -P /tmp  
#RUN tar -xf /tmp/netcdf-4.4.1.1.tar.gz -C /tmp
#ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
#ENV NCDIR=/usr/local
#RUN cd /tmp/netcdf-4.4.1.1 && CPPFLAGS=-I${H5DIR}/include LDFLAGS=-L${H5DIR}/lib ./configure --prefix=/usr/local
#RUN cd /tmp/netcdf-4.4.1.1 && make
#RUN cd /tmp/netcdf-4.4.1.1 && make install

# install netcdf-Fortran
#RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz
#RUN tar -xf netcdf-fortran-4.4.4.tar.gz -C /tmp
#ENV NFDIR=/usr/local
#ENV LD_LIBRARY_PATH=${NCDIR}/lib
#RUN cd /tmp/netcdf-fortran-4.4.4/ && CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR}
#RUN cd /tmp/netcdf-fortran-4.4.4 && make
#RUN cd /tmp/netcdf-fortran-4.4.4 && make install

#ENV NETCDF=/usr/local

## Extras to make it nice/convenient
## May separate these into a separate container
#RUN apt-get install -yq --no-install-recommends \
#    git \
#    nano \
#    vim \
#    tcsh \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*
#RUN update-alternatives --config csh

#### CLEAN UP ####
#WORKDIR /
#RUN rm -rf /tmp/*


