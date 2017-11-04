###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/gcc_7

MAINTAINER jamesmcc

####################################
########## ROOT USER  ##############

USER root

# Download open-coarrays
#WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y flex

ARG OPEN_COARRAYS_VERSION="1.9.2"
ARG OPEN_COARRAYS_INST="/tmp/open-coarrays_inst"
RUN wget https://github.com/sourceryinstitute/OpenCoarrays/releases/download/1.9.2/OpenCoarrays-${OPEN_COARRAYS_VERSION}.tar.gz \
    && tar xvzf OpenCoarrays-${OPEN_COARRAYS_VERSION}.tar.gz \
    && mkdir ${OPEN_COARRAYS_INST}  \
    && cd OpenCoarrays-${OPEN_COARRAYS_VERSION} \
    && export TERM=xterm \
    && ln -sf `which cpp-7` /lib/cpp \
    && ln -sf `which cpp-7` /usr/bin/cpp \
    && ln -sf `which gcc-7` /usr/bin/gcc \
    && ln -sf `which g++-7` /usr/bin/g++ \
    && ln -sf `which gfortran-7` /usr/bin/gfortran \	
    && ./install.sh -y -n \
    --install-prefix ${OPEN_COARRAYS_INST} \
    --package gcc \ 
    --from-url https://github.com/sourceryinstitute/gcc/archive/teams-20170919.tar.gz \
    --install-version teams-20170919 \
    --with-c gcc-7 \
    --with-cxx g++-7 \
    --with-fortran gfortran-7 \
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


