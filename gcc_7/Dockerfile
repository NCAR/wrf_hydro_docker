###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/gcc_default

MAINTAINER jamesmcc

####################################
########## ROOT USER  ##############

USER root

RUN apt-get update \
    && apt-get install -y software-properties-common python-software-properties \
    && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
    && apt-get update \
    && apt-get install gcc-snapshot -y \
    && apt-get update \
    && apt-get install gcc-7 g++-7 gfortran-7 -y \
    && apt-get update \
    && apt-get clean

#RUN gcc-7 --version
#RUN g++-7 --version
#RUN gfortran-7 --version

## Download, build, and install MPICH
## Reference: https://www.mpich.org/static/downloads/3.2/mpich-3.2-installguide.pdf
ARG MPICH_VERSION="3.2"
ARG MPICH_CONFIGURE_OPTIONS="--disable-cxx CC=gcc-7 CXX=g++-7 FC=gfortran-7 F77=gfortran-7"
#ARG MPICH_MAKE_OPTIONS
RUN mkdir /tmp/mpich-src
WORKDIR /tmp/mpich-src
RUN wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
    && cd mpich-${MPICH_VERSION}  \
    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
    && make ${MPICH_MAKE_OPTIONS} \
    && make install \
    && rm -rf /tmp/mpich-src
