###################################
# WRF-Hydro Development docker
# Purpose:
#   1) Compile code on the host system (non-interactive mode)
#   2) Run code on the host system     (non-interactive mode)
#   3) Interactive use. 
# The above is achieved through entrypoint and host-side scripting.
#
# Authors: Tony Castronova, James McCreight, Joe Mills
# Email:  acastronova@cuahsi.org, jamesmcc@ucar.edu, jmills@ucar.edu
# Date:  8.29.2017, 9.15.2017, 10.1.2017
###################################

FROM ubuntu:16.04
MAINTAINER jamesmcc@ucar.edu

####################################
########## ROOT USER  ##############
####################################
USER root

###################################
## System-wide updates
RUN apt-get update


####################################
## WRF-Hydro dependencies
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

###################################
## wrf_hydro_tools dependencies
RUN apt-get update && apt-get -y --no-install-recommends install \
    git

###################################
## create joedocker user
RUN useradd -ms /bin/bash joedocker
RUN usermod -aG sudo joedocker
ENV NETCDF=/usr/local

###################################
## wrf-hydro development docker interface script
COPY ./interface.sh /.

####################################
######### joedocker user ###########
####################################
USER joedocker
RUN cp /interface.sh ~/.
RUN cd $HOME
ENTRYPOINT ["/interface.sh"]
CMD ["interactive"]