###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/gcc_default

MAINTAINER jamesmcc

####################################
########## ROOT USER  ##############

USER root

RUN BUILD_PACKAGES='software-properties-common python-software-properties gcc-snapshot gcc-7 g++-7 gfortran-7' \
    && apt-get update \
    && apt-get install -y software-properties-common python-software-properties \
    && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
    && apt-get update \
    && apt-get install gcc-snapshot -y \
    && apt-get update \
    && apt-get install gcc-7 g++-7 gfortran-7 -y \
    && apt-get update \
    && apt-get clean \
    && AUTO_ADDED_PACKAGES=`apt-mark showauto` \
##    && apt-get remove -y $AUTO_ADDED_PACKAGES \
##    && apt-get remove --purge -y --allow-remove-essential $BUILD_PACKAGES $AUTO_ADDED_PACKAGES \
    && rm -rf /var/lib/apt/lists/*

## Download, build, and install MPICH
## Reference: https://www.mpich.org/static/downloads/3.2/mpich-3.2-installguide.pdf
RUN MPICH_VERSION="3.2" \
    && MPICH_CONFIGURE_OPTIONS="--disable-cxx CC=gcc-7 CXX=g++-7 FC=gfortran-7 F77=gfortran-7" \
    && MPICH_MAKE_OPTIONS='' \
    && mkdir /tmp/mpich-src \
    && cd /tmp/mpich-src \
    && wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
    && cd mpich-${MPICH_VERSION}  \
    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
    && make ${MPICH_MAKE_OPTIONS} \
    && make install \
    && rm -rf /tmp/mpich-src
