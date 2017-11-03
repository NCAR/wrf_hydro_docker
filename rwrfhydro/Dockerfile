FROM rocker/r-base:3.4.0
MAINTAINER jamesmcc

####################################
########## ROOT USER  ##############

#Install system dependencies for rwrfhydro
RUN apt-get update
RUN apt-get install -yq --no-install-recommends \
    wget \
    libhdf5-dev \
    nco \
    m4 \
    libgdal-dev \
    libjpeg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

#For ncdf4
# install netcdf-C
ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV NCDIR=/usr/local

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

# Install rwrfhydro
RUN Rscript -e "devtools::install_github('NCAR/rwrfhydro')"

# Install doMC and foreach
RUN Rscript -e "install.packages('doMC')"
RUN Rscript -e "install.packages('foreach')"

#Install rgdal and rgeos
RUN Rscript -e "install.packages('rgdal')"
RUN Rscript -e "install.packages('rgeos')"
